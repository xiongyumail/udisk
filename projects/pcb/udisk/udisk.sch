EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 4
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Text Label 5650 3300 0    50   ~ 0
LCD_CLK
Text Label 5650 3400 0    50   ~ 0
LCD_MOSI
Wire Wire Line
	5650 3300 6100 3300
Wire Wire Line
	5650 3400 6100 3400
Wire Wire Line
	5650 3500 6100 3500
Wire Wire Line
	5650 3600 6100 3600
Wire Wire Line
	5650 3700 6100 3700
Wire Wire Line
	5650 3800 6100 3800
Text Label 5650 3500 0    50   ~ 0
LCD_DC
Text Label 5650 3600 0    50   ~ 0
LCD_RES
Text Label 5650 3700 0    50   ~ 0
LCD_CS1
Text Label 5650 3800 0    50   ~ 0
LCD_BLK
$Sheet
S 6100 2350 600  300 
U 5D8A8C31
F0 "POWER" 50
F1 "POWER.sch" 50
$EndSheet
$Sheet
S 6100 3200 600  700 
U 5D8B73CB
F0 "LCD160x80" 50
F1 "LCD160x80.sch" 50
F2 "SCL" I L 6100 3300 50 
F3 "SDA" I L 6100 3400 50 
F4 "DC" I L 6100 3500 50 
F5 "RES" I L 6100 3600 50 
F6 "CS" I L 6100 3700 50 
F7 "BLK" I L 6100 3800 50 
$EndSheet
$Sheet
S 2800 2900 1750 1050
U 5ECFDC97
F0 "ESP32-PICO-D4" 50
F1 "ESP32-PICO-D4.sch" 50
$EndSheet
$EndSCHEMATC
