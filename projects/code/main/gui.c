#include <stdio.h>
#include <time.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/queue.h"
#include "lwip/err.h"
#include "lwip/sockets.h"
#include "lwip/sys.h"
#include <lwip/netdb.h>
#include "esp_heap_caps.h"
#include "gui.h"
#include "esp_log.h"
#include "esp_lua.h"
#include "esp_lua_lib.h"
#include "lv_lodepng.h"

static const char *TAG = "gui";

typedef struct {
    int event;
    void *arg;
} gui_event_t;

#define GUI_WIFI_EVENT 0
#define GUI_BATTERY_EVENT 1
#define GUI_STATE_EVENT 2
#define GUI_MSG_EVENT 3
#define GUI_IMG_EVENT 4

#define MY_TEMP_SYMBOL "\xEF\x8B\x88"  // f2c8
#define MY_MOTION_SYMBOL "\xEF\x8B\x9B"  // f2db
#define MY_LED_SYMBOL "\xEF\x83\xAB"  // f0eb
#define MY_TOUCH_SYMBOL "\xEF\x82\xA6" // f0a6
#define MY_CAMERA_SYMBOL "\xEF\x85\xAD" // f16d
#define MY_ESPRESSIF_SYMBOL "\xEF\x8B\xA1" // f2e1

static lv_style_t style_my_symbol;

static lv_obj_t * state = NULL;
static lv_obj_t * wifi = NULL;
static lv_obj_t * battery = NULL;
static lv_obj_t * message = NULL;
static lv_obj_t * img = NULL;

static QueueHandle_t gui_event_queue = NULL;

static lv_disp_t **disp;
static lv_indev_t **indev;

static void header_create(lv_obj_t * parent)
{
    lv_obj_t *body = lv_cont_create(parent, NULL);
    lv_obj_set_width(body, lv_disp_get_hor_res(disp[0]));
    lv_obj_set_height(body, 16);

    wifi = lv_label_create(body, NULL);
    lv_label_set_text(wifi, LV_SYMBOL_WIFI);
    lv_obj_align(wifi, NULL, LV_ALIGN_IN_LEFT_MID, 0, 0);

    state = lv_label_create(body, NULL);
    lv_label_set_align(state, LV_LABEL_ALIGN_CENTER);
    lv_label_set_text(state, "00:00:00");
    // lv_obj_set_style(state, &style_my_symbol);
    lv_obj_align(state, NULL, LV_ALIGN_CENTER, 0, 0);

    battery = lv_label_create(body, NULL);
    lv_label_set_text(battery, LV_SYMBOL_BATTERY_3);
    lv_obj_align(battery, NULL, LV_ALIGN_IN_RIGHT_MID, 0, 0);

    // lv_cont_set_fit2(body, false, true);   /*Let the height set automatically*/
    lv_obj_set_pos(body, 0, 0);
}

/*********************
 *      DEFINES
 *********************/
#define PC_FILES    1       /*If you are on PC you can add PC file function to 'lv_fs'*/

/**********************
 *      TYPEDEFS
 **********************/
typedef  FILE * pc_file_t;

#if PC_FILES && LV_USE_FILESYSTEM
/**
 * Open a file from the PC
 * @param drv pointer to the current driver
 * @param file_p pointer to a FILE* variable
 * @param fn name of the file.
 * @param mode element of 'fs_mode_t' enum or its 'OR' connection (e.g. FS_MODE_WR | FS_MODE_RD)
 * @return LV_FS_RES_OK: no error, the file is opened
 *         any error from lv_fs_res_t enum
 */
static lv_fs_res_t pcfs_open(lv_fs_drv_t * drv, void * file_p, const char * fn, lv_fs_mode_t mode)
{
    (void) drv; /*Unused*/

    errno = 0;

    const char * flags = "";

    if(mode == LV_FS_MODE_WR) flags = "wb";
    else if(mode == LV_FS_MODE_RD) flags = "rb";
    else if(mode == (LV_FS_MODE_WR | LV_FS_MODE_RD)) flags = "a+";

    /*Make the path relative to the current directory (the projects root folder)*/
    char buf[256];
    sprintf(buf, "/%s", fn);

    pc_file_t f = fopen(buf, flags);
    if(f == NULL) return LV_FS_RES_UNKNOWN;
    else {
        fseek(f, 0, SEEK_SET);

        /* 'file_p' is pointer to a file descriptor and
         * we need to store our file descriptor here*/
        pc_file_t * fp = file_p;        /*Just avoid the confusing casings*/
        *fp = f;
    }

    return LV_FS_RES_OK;
}


/**
 * Close an opened file
 * @param drv pointer to the current driver
 * @param file_p pointer to a FILE* variable. (opened with lv_ufs_open)
 * @return LV_FS_RES_OK: no error, the file is read
 *         any error from lv__fs_res_t enum
 */
static lv_fs_res_t pcfs_close(lv_fs_drv_t * drv, void * file_p)
{
    (void) drv; /*Unused*/

    pc_file_t * fp = file_p;        /*Just avoid the confusing casings*/
    fclose(*fp);
    return LV_FS_RES_OK;
}

/**
 * Read data from an opened file
 * @param drv pointer to the current driver
 * @param file_p pointer to a FILE variable.
 * @param buf pointer to a memory block where to store the read data
 * @param btr number of Bytes To Read
 * @param br the real number of read bytes (Byte Read)
 * @return LV_FS_RES_OK: no error, the file is read
 *         any error from lv__fs_res_t enum
 */
static lv_fs_res_t pcfs_read(lv_fs_drv_t * drv, void * file_p, void * buf, uint32_t btr, uint32_t * br)
{
    (void) drv; /*Unused*/

    pc_file_t * fp = file_p;        /*Just avoid the confusing casings*/
    *br = (uint32_t)fread(buf, 1, btr, *fp);
    return LV_FS_RES_OK;
}

/**
 * Set the read write pointer. Also expand the file size if necessary.
 * @param drv pointer to the current driver
 * @param file_p pointer to a FILE* variable. (opened with lv_ufs_open )
 * @param pos the new position of read write pointer
 * @return LV_FS_RES_OK: no error, the file is read
 *         any error from lv__fs_res_t enum
 */
static lv_fs_res_t pcfs_seek(lv_fs_drv_t * drv, void * file_p, uint32_t pos)
{
    (void) drv; /*Unused*/

    pc_file_t * fp = file_p;        /*Just avoid the confusing casings*/
    fseek(*fp, pos, SEEK_SET);
    return LV_FS_RES_OK;
}

/**
 * Give the position of the read write pointer
 * @param drv pointer to the current driver
 * @param file_p pointer to a FILE* variable.
 * @param pos_p pointer to to store the result
 * @return LV_FS_RES_OK: no error, the file is read
 *         any error from lv__fs_res_t enum
 */
static lv_fs_res_t pcfs_tell(lv_fs_drv_t * drv, void * file_p, uint32_t * pos_p)
{
    (void) drv; /*Unused*/
    pc_file_t * fp = file_p;        /*Just avoid the confusing casings*/
    *pos_p = ftell(*fp);
    return LV_FS_RES_OK;
}

#endif

static lv_img_dsc_t ramf_img = {
  .header.always_zero = 0,
  .header.cf = LV_IMG_CF_RAW_ALPHA,
  .data_size = 0,
  .data = NULL,
};

static void body_page_terminal(lv_obj_t * parent)
{
    static lv_style_t style_terminal_symbol;

    lv_obj_t *body = lv_cont_create(parent, NULL);
    lv_obj_set_width(body, lv_disp_get_hor_res(disp[0]));
    lv_obj_set_height(body, 64);

    /* Add a simple drive to open images from PC*/
    lv_fs_drv_t pcfs_drv;                         /*A driver descriptor*/
    memset(&pcfs_drv, 0, sizeof(lv_fs_drv_t));    /*Initialization*/

    pcfs_drv.file_size = sizeof(pc_file_t);       /*Set up fields...*/
    pcfs_drv.letter = 'P';
    pcfs_drv.open_cb = pcfs_open;
    pcfs_drv.close_cb = pcfs_close;
    pcfs_drv.read_cb = pcfs_read;
    pcfs_drv.seek_cb = pcfs_seek;
    pcfs_drv.tell_cb = pcfs_tell;
    lv_fs_drv_register(&pcfs_drv);

    static lv_style_t style_img;
    img = lv_img_create(body, NULL);
    lv_img_set_src(img, "");

    message = lv_label_create(body, NULL);
    lv_style_copy(&style_terminal_symbol, lv_obj_get_style(message));
    style_terminal_symbol.text.font = &lv_font_roboto_16;
    lv_label_set_style(message, LV_LABEL_STYLE_MAIN, &style_terminal_symbol);
    lv_label_set_recolor(message, true);
    lv_label_set_long_mode(message, LV_LABEL_LONG_SROLL_CIRC);     /*Circular scroll*/
    // lv_label_set_anim_speed(message, 32);
    lv_label_set_align(message, LV_LABEL_ALIGN_CENTER);
    lv_label_set_text(message, "Welcome");
    lv_obj_set_size(message, 160, 64);
    lv_obj_align(message, NULL, LV_LABEL_ALIGN_CENTER, 0, 0);

    lv_obj_set_pos(body, 0, 16);
}

static void gui_task(lv_task_t * arg)
{
    int ret;
    gui_event_t e;
    while (1) {
        ret = xQueueReceive(gui_event_queue, &e, 0);
        if (ret == pdFALSE) {
            break;
        }
        char *text = (char *)e.arg;
        switch (e.event) {
            case GUI_WIFI_EVENT: {
                if (atoi(text) == 1) {
                    lv_label_set_text(wifi, LV_SYMBOL_WIFI);
                } else {
                    lv_label_set_text(wifi, "");
                } 
            }
            break;

            case GUI_STATE_EVENT: {
                lv_label_set_text(state, text);
            }
            break;

            case GUI_BATTERY_EVENT: {
                switch (atoi(text)) {
                    case BATTERY_FULL: {
                        lv_label_set_text(battery, LV_SYMBOL_BATTERY_FULL);
                    }
                    break;

                    case BATTERY_3: {
                        lv_label_set_text(battery, LV_SYMBOL_BATTERY_3);
                    }
                    break;

                    case BATTERY_2: {
                        lv_label_set_text(battery, LV_SYMBOL_BATTERY_2);
                    }
                    break;

                    case BATTERY_1: {
                        lv_label_set_text(battery, LV_SYMBOL_BATTERY_1);
                    }
                    break;

                    case BATTERY_EMPTY: {
                        lv_label_set_text(battery, LV_SYMBOL_BATTERY_EMPTY);
                    }
                    break;

                    case BATTERY_CHARGE: {
                        lv_label_set_text(battery, LV_SYMBOL_CHARGE);
                    }
                    break;
                }
            }
            break;

            case GUI_MSG_EVENT: {
                lv_label_set_text(message, text);
            }
            break;

            case GUI_IMG_EVENT: {
                if (strncmp(text, ESP_LUA_RAM_FILE_PATH, strlen(ESP_LUA_RAM_FILE_PATH)) == 0) {
                    esp_lua_ramf_t *ramf = (esp_lua_ramf_t *)atoi(&text[strlen(ESP_LUA_RAM_FILE_PATH)]);
                    ramf_img.data = ramf->data;
                    ramf_img.data_size = ramf->size;
                    uint32_t size[2];
                    memcpy(size, ramf_img.data + 16, 8);
                    
                    /*The width and height are stored in Big endian format so convert them to little endian*/
                    ramf_img.header.w = (lv_coord_t) ((size[0] & 0xff000000) >> 24) +  ((size[0] & 0x00ff0000) >> 8);
                    ramf_img.header.h = (lv_coord_t) ((size[1] & 0xff000000) >> 24) +  ((size[1] & 0x00ff0000) >> 8);
                    lv_img_set_src(img, &ramf_img);
                } else {
                    lv_img_set_src(img, text);
                }
            }
            break;
        }
        free(text);
    }
}

static int gui_event_send(int event, void *arg, int ticks_wait)
{
    int ret;
    if (gui_event_queue == NULL) {
        return -1;
    }

    gui_event_t e;
    e.event = event;
    e.arg = arg;
    ret = xQueueSend(gui_event_queue, &e, ticks_wait);
    if (ret == pdFALSE) {
        return -1;
    }

    return 0;
}

int gui_write(char *io, char* str, int ticks_wait) 
{
    int event = 0;

    if (strcmp(io, "WIFI") == 0) {
        event = GUI_WIFI_EVENT;
    } else if (strcmp(io, "BATT") == 0) {
        event = GUI_BATTERY_EVENT;
    } else if (strcmp(io, "STATE") == 0) {
        event = GUI_STATE_EVENT;
    } else if (strcmp(io, "MSG") == 0) {
        event = GUI_MSG_EVENT;
    } else if (strcmp(io, "IMG") == 0) {
        event = GUI_IMG_EVENT;
    } else {
        return -1;
    }

    char *text = (char *)malloc(strlen(str) + 1);
    strcpy(text, str);
    if (gui_event_send(event, text, ticks_wait) == 0) {
        return 0;
    } else {
        free(text);
        return -1;
    }
}

void gui_init(lv_disp_t **disp_array, lv_indev_t **indev_array, lv_theme_t * th)
{
    disp = disp_array;
    indev = indev_array;
    gui_event_queue = xQueueCreate(10, sizeof(gui_event_t));
    lv_theme_set_current(th);
    th = lv_theme_get_current();    /*If `LV_THEME_LIVE_UPDATE  1` `th` is not used directly so get the real theme after set*/
    th->style.bg->body.main_color = LV_COLOR_BLACK;
    th->style.bg->body.grad_color = LV_COLOR_BLACK;
    lv_cont_set_style(lv_disp_get_scr_act(disp[0]), LV_CONT_STYLE_MAIN, th->style.bg);
    // lv_cont_set_style(scr, th->style.bg);

    LV_FONT_DECLARE(my_symbol);
    lv_style_copy(&style_my_symbol, &lv_style_scr);
    style_my_symbol.text.font = &my_symbol;

    // lv_lodepng_init(); // large ram

    header_create(lv_disp_get_scr_act(disp[0]));
    body_page_terminal(lv_disp_get_scr_act(disp[0]));
    lv_task_create(gui_task, 10, LV_TASK_PRIO_MID, NULL);
}
