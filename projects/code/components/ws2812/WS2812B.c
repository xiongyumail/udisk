
#include "stdio.h"
#include "string.h"
#include "WS2812B.h"

#if CONFIG_WS2812B_INVERTED == 0
static const rmt_item32_t wsLogicZero = {.level0 = 1, .duration0 = 20, .level1 = 0, .duration1 = 80};
static const rmt_item32_t wsLogicOne = {.level0 = 1, .duration0 = 80, .level1 = 0, .duration1 = 20};
#else
static const rmt_item32_t wsLogicZero = {.level0 = 0, .duration0 = 20, .level1 = 1, .duration1 = 80};
static const rmt_item32_t wsLogicOne = {.level0 = 0, .duration0 = 80, .level1 = 1, .duration1 = 20};
#endif

static rmt_channel_t channel;
static uint32_t size;
static rmt_item32_t* items;

void WS2812B_setLeds(wsRGB_t* data, uint32_t size)
{
    uint32_t itemCnt = 0;

    for(int i = 0; i < size; i++)
        for(int j = 0; j < 24; j++)
        {
            if(j < 8) {
                if(data[i].r & (1 << (7 - j))) {
                    items[itemCnt++] = wsLogicOne;
                } else {
                    items[itemCnt++] = wsLogicZero;
                }
            } else if (j < 16) {
                if(data[i].g & (1  <<(7 - (j % 8)))) {
                    items[itemCnt++] = wsLogicOne;
                } else {
                    items[itemCnt++] = wsLogicZero;
                }
            } else {
                if(data[i].b & (1<<( 7 - (j%8) ))) {
                    items[itemCnt++] = wsLogicOne;
                } else {
                    items[itemCnt++] = wsLogicZero;
                }
            }
        }

    rmt_write_items(channel, items, size * 24, false);
}

void WS2812B_deInit()
{
    rmt_driver_uninstall(channel);
    free(items);
}

void WS2812B_init(rmt_channel_t chan, gpio_num_t gpio, uint32_t psize)
{
    channel = chan;
    size = psize;
    items = NULL;

    if(!size)
    {
        printf("%s: %d Invalid size 0!\n", __FILE__, __LINE__);
        return;
    }

    if(NULL == (items = malloc(sizeof(rmt_item32_t) * size * 24)))
    {
        printf("%s: %d Unable to allocate space!\n", __FILE__, __LINE__);
        return;
    }

    rmt_config_t rmt_tx;
    memset(&rmt_tx, 0, sizeof(rmt_config_t));

    rmt_tx.channel = channel;
    rmt_tx.gpio_num = gpio;
    rmt_tx.mem_block_num = 1;
    rmt_tx.clk_div = 1;
    rmt_tx.tx_config.idle_output_en = 1;
#if CONFIG_WS2812B_INVERTED == 1
    rmt_tx.tx_config.idle_level = RMT_IDLE_LEVEL_HIGH;
#endif

    rmt_config(&rmt_tx);
    rmt_driver_install(rmt_tx.channel, 0, 0);
}