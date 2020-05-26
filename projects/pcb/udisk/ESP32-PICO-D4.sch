EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 4 4
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L RF_Module:ESP32-PICO-D4 U?
U 1 1 5ECD7167
P 5150 3600
F 0 "U?" H 5150 1911 50  0000 C CNN
F 1 "ESP32-PICO-D4" H 5150 1820 50  0000 C CNN
F 2 "Package_DFN_QFN:QFN-48-1EP_7x7mm_P0.5mm_EP5.3x5.3mm" H 5150 1900 50  0001 C CNN
F 3 "https://www.espressif.com/sites/default/files/documentation/esp32-pico-d4_datasheet_en.pdf" H 5400 2600 50  0001 C CNN
	1    5150 3600
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R?
U 1 1 5ECD9730
P 4150 2100
F 0 "R?" H 4209 2146 50  0000 L CNN
F 1 "10K" H 4209 2055 50  0000 L CNN
F 2 "" H 4150 2100 50  0001 C CNN
F 3 "~" H 4150 2100 50  0001 C CNN
	1    4150 2100
	1    0    0    -1  
$EndComp
$Comp
L power:+3V3 #PWR?
U 1 1 5ECDAB31
P 4150 1800
F 0 "#PWR?" H 4150 1650 50  0001 C CNN
F 1 "+3V3" H 4165 1973 50  0000 C CNN
F 2 "" H 4150 1800 50  0001 C CNN
F 3 "" H 4150 1800 50  0001 C CNN
	1    4150 1800
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C?
U 1 1 5ECDB600
P 3800 2100
F 0 "C?" H 3892 2146 50  0000 L CNN
F 1 "0.1uF" H 3892 2055 50  0000 L CNN
F 2 "" H 3800 2100 50  0001 C CNN
F 3 "~" H 3800 2100 50  0001 C CNN
	1    3800 2100
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 5ECDBF2F
P 3800 2200
F 0 "#PWR?" H 3800 1950 50  0001 C CNN
F 1 "GND" H 3805 2027 50  0000 C CNN
F 2 "" H 3800 2200 50  0001 C CNN
F 3 "" H 3800 2200 50  0001 C CNN
	1    3800 2200
	1    0    0    -1  
$EndComp
Wire Wire Line
	3800 2000 4150 2000
Wire Wire Line
	4150 2000 4150 1800
Connection ~ 4150 2000
Wire Wire Line
	4150 2200 4350 2200
Wire Wire Line
	4150 2000 4950 2000
Wire Wire Line
	4950 2000 5050 2000
Connection ~ 4950 2000
Wire Wire Line
	5050 2000 5150 2000
Connection ~ 5050 2000
Wire Wire Line
	5150 2000 5250 2000
Connection ~ 5150 2000
NoConn ~ 4350 3600
NoConn ~ 4350 3700
NoConn ~ 4350 3800
NoConn ~ 4350 3900
NoConn ~ 4350 4000
NoConn ~ 4350 4100
NoConn ~ 5900 3500
NoConn ~ 3900 3400
$Comp
L power:GND #PWR?
U 1 1 5ECE3987
P 5150 5450
F 0 "#PWR?" H 5150 5200 50  0001 C CNN
F 1 "GND" H 5155 5277 50  0000 C CNN
F 2 "" H 5150 5450 50  0001 C CNN
F 3 "" H 5150 5450 50  0001 C CNN
	1    5150 5450
	1    0    0    -1  
$EndComp
Wire Wire Line
	5150 5450 5150 5200
$EndSCHEMATC
