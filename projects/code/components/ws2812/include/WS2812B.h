#pragma once

#include "driver/rmt.h"

#ifdef __cplusplus
extern "C" {
#endif

#define CONFIG_WS2812B_INVERTED 0

typedef struct
{
    uint8_t b;
    uint8_t g;
    uint8_t r;
} wsRGB_t;

/**
 * Writes to the LED
 * @param data
 * @param size Number of LED's - Must not exceed initialization size
 */
void WS2812B_setLeds(wsRGB_t* data, uint32_t size);

/**
 * Deinit driver and free memory space
 */
void WS2812B_deInit(void);

/**
 * Init RMT module and allocates space
 * @param channel RMT channel
 * @param gpio GPIO Pin
 * @param size Number of LED's
 */
void WS2812B_init(rmt_channel_t channel, gpio_num_t gpio, uint32_t size);

#ifdef __cplusplus
}
#endif

