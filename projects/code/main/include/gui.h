#pragma once

#ifdef __cplusplus
extern "C" {
#endif

#include "lvgl.h"

typedef enum {
    BATTERY_FULL,
    BATTERY_3,
    BATTERY_2,
    BATTERY_1,
    BATTERY_EMPTY, 
    BATTERY_CHARGE
} gui_battery_value_t;

int gui_write(char *io, char* str, int ticks_wait);

void gui_init(lv_disp_t **disp_array, lv_indev_t **indev_array, lv_theme_t * th);

#ifdef __cplusplus
} /* extern "C" */
#endif