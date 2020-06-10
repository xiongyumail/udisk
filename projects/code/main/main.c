#include <stdio.h>
#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <sys/time.h>
#include <math.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/semphr.h"
#include "esp_log.h"
#include "lvgl.h"
#include "lcd.h"
#include "driver/gpio.h"
#include "esp_lua.h"
#include "gui.h"
#include "APDS9960.h"

static const char *TAG = "main";

#define LCD_CLK  22
#define LCD_MOSI 21
#define LCD_DC   19
#define LCD_RST  23
#define LCD_CS   18
#define LCD_BK   15

static lv_disp_t *disp[1];
// static lv_indev_t *indev[1];

static void IRAM_ATTR lv_disp_flush(lv_disp_drv_t * disp_drv, const lv_area_t * area, lv_color_t * color_p)
{
    uint32_t len = (sizeof(uint16_t) * ((area->y2 - area->y1 + 1)*(area->x2 - area->x1 + 1)));

    lcd_set_index(area->x1, area->y1, area->x2, area->y2);
    lcd_write_data((uint8_t *)color_p, len);

    lv_disp_flush_ready(disp_drv);
}

static void lv_tick_task(void * arg)
{
    while(1) {
        lv_tick_inc(10);
        vTaskDelay(10 / portTICK_RATE_MS);
    }
}

static void gui_task(void *arg)
{
    lcd_config_t lcd_config = {
        .clk_fre = 40 * 1000 * 1000,
        .pin_clk = LCD_CLK,
        .pin_mosi = LCD_MOSI,
        .pin_dc = LCD_DC,
        .pin_cs = LCD_CS,
        .pin_rst = LCD_RST,
        .pin_bk = LCD_BK,
        .max_buffer_size = 2 * 1024,
        .horizontal = 1 // 1: UP, 3： DOWN
    };

    lcd_init(&lcd_config);
    
    xTaskCreate(lv_tick_task, "lv_tick_task", 1024, NULL, 10, NULL);

    lv_init();

    /*Create an other buffer for double buffering*/
    static lv_disp_buf_t disp_buf;
    static lv_color_t *buf = NULL;
    buf = (lv_color_t *)heap_caps_malloc(sizeof(lv_color_t) * (160 * 80) / 4, MALLOC_CAP_DEFAULT);
    lv_disp_buf_init(&disp_buf, buf, NULL, (160 * 80) / 4);

    /*Create a display*/
    lv_disp_drv_t disp_drv;
    lv_disp_drv_init(&disp_drv);            /*Basic initialization*/
    disp_drv.buffer = &disp_buf;
    disp_drv.flush_cb = lv_disp_flush;    /*Used when `LV_VDB_SIZE != 0` in lv_conf.h (buffered drawing)*/
    disp_drv.hor_res = 160;
    disp_drv.ver_res = 80;
    disp[0] = lv_disp_drv_register(&disp_drv);

    lv_disp_set_default(disp[0]);

    gui_init(disp, NULL, lv_theme_material_init(0, NULL));

    while(1) {
        lv_task_handler();
        vTaskDelay(10 / portTICK_RATE_MS);
    }
}

#include "esp_lua_lib.h"

static int lcd_write(lua_State *L) 
{
    int ret = -1;
    char *io = luaL_checklstring(L, 1, NULL);

    ret = gui_write(io, luaL_checklstring(L, 2, NULL), 100 / portTICK_RATE_MS);

    if (ret == 0) {
        lua_pushboolean(L, true);
    } else {
        lua_pushboolean(L, false);
    }
    return 1;
}

static const luaL_Reg lcd_lib[] = {
    {"write", lcd_write},
    {NULL, NULL}
};

LUAMOD_API int esp_lib_lcd(lua_State *L) 
{
    xTaskCreate(gui_task, "gui_task", 4096, NULL, 5, NULL);

    luaL_newlib(L, lcd_lib);
    lua_pushstring(L, "0.1.0");
    lua_setfield(L, -2, "_version");
    return 1;
}

static int led_write(lua_State *L) 
{
    int ret = -1;
    char *io = luaL_checklstring(L, 1, NULL);

    if (strcmp(io, "STATE") == 0) {
        ret = gpio_set_level(GPIO_NUM_0, !lua_toboolean(L,2));
    }
    
    if (ret == 0) {
        lua_pushboolean(L, true);
    } else {
        lua_pushboolean(L, false);
    }
    return 1;
}

static const luaL_Reg led_lib[] = {
    {"write", led_write},
    {NULL, NULL}
};

LUAMOD_API int esp_lib_led(lua_State *L) 
{
    gpio_config_t io_conf;
    //disable interrupt
    io_conf.intr_type = GPIO_PIN_INTR_DISABLE;
    //set as output mode
    io_conf.mode = GPIO_MODE_OUTPUT;
    //bit mask of the pins that you want to set,e.g.GPIO18/19
    io_conf.pin_bit_mask = 1ULL << GPIO_NUM_0;
    //disable pull-down mode
    io_conf.pull_down_en = 0;
    //disable pull-up mode
    io_conf.pull_up_en = 0;
    //configure GPIO with the given settings
    gpio_config(&io_conf);
    gpio_set_level(GPIO_NUM_0, 1);

    luaL_newlib(L, led_lib);
    lua_pushstring(L, "0.1.0");
    lua_setfield(L, -2, "_version");
    return 1;
}

static const luaL_Reg mylibs[] = {
    {"sys", esp_lib_sys},
    {"net", esp_lib_net},
    {"web", esp_lib_web},
    // {"mqtt", esp_lib_mqtt},
    {"httpd", esp_lib_httpd},
    {"ramf", esp_lib_ramf},
    {"lcd", esp_lib_lcd},
    {"led", esp_lib_led},
    {NULL, NULL}
};

const char LUA_SCRIPT_INIT[] = " \
assert(sys.init()) \
dofile(\'/lua/init.lua\') \
";

void lua_task(void *arg)
{
    char *ESP_LUA_ARGV[5] = {"./lua", "-i", "-e", LUA_SCRIPT_INIT, NULL}; // enter interactive mode after executing 'script'

    esp_lua_init(NULL, NULL, mylibs);

    while (1) {
        esp_lua_main(4, ESP_LUA_ARGV);
        printf("lua exit\n");
        vTaskDelay(2000 / portTICK_RATE_MS);
    }

    vTaskDelete(NULL);
}

#include "driver/i2c.h"
#include "esp_system.h"

#define APDS9960_I2C_MASTER_SCL_IO           (gpio_num_t)13          /*!< gpio number for I2C master clock */
#define APDS9960_I2C_MASTER_SDA_IO           (gpio_num_t)14          /*!< gpio number for I2C master data  */
#define APDS9960_I2C_MASTER_NUM              I2C_NUM_1   /*!< I2C port number for master dev */
#define APDS9960_I2C_MASTER_TX_BUF_DISABLE   0           /*!< I2C master do not need buffer */
#define APDS9960_I2C_MASTER_RX_BUF_DISABLE   0           /*!< I2C master do not need buffer */
#define APDS9960_I2C_MASTER_FREQ_HZ          100000      /*!< I2C master clock frequency */

apds9960_handle_t apds9960 = NULL;

/**
 * @brief i2c master initialization
 */
static void i2c_sensor_apds9960_init()
{
    int i2c_master_port = APDS9960_I2C_MASTER_NUM;
    i2c_config_t conf;
    conf.mode = I2C_MODE_MASTER;
    conf.sda_io_num = APDS9960_I2C_MASTER_SDA_IO;
    conf.sda_pullup_en = GPIO_PULLUP_ENABLE;
    conf.scl_io_num = APDS9960_I2C_MASTER_SCL_IO;
    conf.scl_pullup_en = GPIO_PULLUP_ENABLE;
    conf.master.clk_speed = APDS9960_I2C_MASTER_FREQ_HZ;
    i2c_param_config(i2c_master_port, &conf);
    i2c_driver_install(i2c_master_port, conf.mode, APDS9960_I2C_MASTER_TX_BUF_DISABLE, APDS9960_I2C_MASTER_RX_BUF_DISABLE, 0);

    apds9960 = apds9960_create(i2c_master_port, APDS9960_I2C_ADDRESS);
}

static void apds9960_test_func()
{
    int cnt = 0;
    while (cnt < 50) {
        uint8_t gesture = apds9960_read_gesture(apds9960);
        if (gesture == APDS9960_DOWN) {
            printf("gesture APDS9960_DOWN*********************!\n");
        } else if (gesture == APDS9960_UP) {
            printf("gesture APDS9960_UP*********************!\n");
        } else if (gesture == APDS9960_LEFT) {
            printf("gesture APDS9960_LEFT*********************!\n");
            cnt++;
        } else if (gesture == APDS9960_RIGHT) {
            printf("gesture APDS9960_RIGHT*********************!\n");
            cnt++;
        }
        vTaskDelay(100 / portTICK_RATE_MS);
    }
    apds9960_delete(apds9960, true);
}

static void apds9960_task(void *arg)
{
    i2c_sensor_apds9960_init();
    apds9960_gesture_init(apds9960);
    vTaskDelay(1000 / portTICK_RATE_MS);
    apds9960_test_func();
}

void app_main()
{
    xTaskCreate(apds9960_task, "apds9960_task", 4096, NULL, 5, NULL);
    esp_log_level_set("*", ESP_LOG_ERROR);
    xTaskCreate(lua_task, "lua_task", 10240, NULL, 5, NULL);
}
