EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 4 5
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
L Device:R_Small R5
U 1 1 5ECD9730
P 3500 2100
F 0 "R5" H 3559 2146 50  0000 L CNN
F 1 "10K" H 3559 2055 50  0000 L CNN
F 2 "Resistor_SMD:R_0402_1005Metric" H 3500 2100 50  0001 C CNN
F 3 "~" H 3500 2100 50  0001 C CNN
	1    3500 2100
	1    0    0    -1  
$EndComp
$Comp
L power:+3V3 #PWR0113
U 1 1 5ECDAB31
P 3500 1800
F 0 "#PWR0113" H 3500 1650 50  0001 C CNN
F 1 "+3V3" H 3515 1973 50  0000 C CNN
F 2 "" H 3500 1800 50  0001 C CNN
F 3 "" H 3500 1800 50  0001 C CNN
	1    3500 1800
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C4
U 1 1 5ECDB600
P 3150 2300
F 0 "C4" H 3242 2346 50  0000 L CNN
F 1 "0.1uF" H 3242 2255 50  0000 L CNN
F 2 "Capacitor_SMD:C_0402_1005Metric" H 3150 2300 50  0001 C CNN
F 3 "~" H 3150 2300 50  0001 C CNN
	1    3150 2300
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0114
U 1 1 5ECDBF2F
P 3150 2400
F 0 "#PWR0114" H 3150 2150 50  0001 C CNN
F 1 "GND" H 3155 2227 50  0000 C CNN
F 2 "" H 3150 2400 50  0001 C CNN
F 3 "" H 3150 2400 50  0001 C CNN
	1    3150 2400
	1    0    0    -1  
$EndComp
Wire Wire Line
	3150 2000 3500 2000
Wire Wire Line
	3500 2000 3500 1800
Connection ~ 3500 2000
NoConn ~ 5900 3500
$Comp
L power:GND #PWR0115
U 1 1 5ECE3987
P 5150 5450
F 0 "#PWR0115" H 5150 5200 50  0001 C CNN
F 1 "GND" H 5155 5277 50  0000 C CNN
F 2 "" H 5150 5450 50  0001 C CNN
F 3 "" H 5150 5450 50  0001 C CNN
	1    5150 5450
	1    0    0    -1  
$EndComp
Wire Wire Line
	5150 5450 5150 5200
Text HLabel 8600 2250 2    50   Output ~ 0
TXD
Text HLabel 8600 2350 2    50   Input ~ 0
RXD
Wire Wire Line
	8600 2250 8200 2250
Wire Wire Line
	8600 2350 8200 2350
Wire Wire Line
	8200 2450 8600 2450
Text Label 8200 2250 0    50   ~ 0
TXD
Text Label 8200 2350 0    50   ~ 0
RXD
Text Label 8200 2450 0    50   ~ 0
EN
Text Label 8200 2550 0    50   ~ 0
GPIO0
Text HLabel 8600 2450 2    50   Input ~ 0
EN
Text HLabel 8600 2550 2    50   BiDi Italic 10
GPIO0
Wire Wire Line
	8200 2850 8600 2850
Wire Wire Line
	8200 2950 8600 2950
Wire Wire Line
	8200 3050 8600 3050
Wire Wire Line
	8200 3150 8600 3150
Wire Wire Line
	8200 3250 8600 3250
Wire Wire Line
	8200 3350 8600 3350
Wire Wire Line
	8200 3750 8600 3750
Wire Wire Line
	8200 3850 8600 3850
Wire Wire Line
	8200 3950 8600 3950
Wire Wire Line
	8200 4050 8600 4050
Text Label 8200 2850 0    50   ~ 0
GPIO2
Text Label 8200 2950 0    50   ~ 0
GPIO4
Text Label 8200 3050 0    50   ~ 0
GPIO5
Text Label 8200 3150 0    50   ~ 0
GPIO12
Text Label 8200 3250 0    50   ~ 0
GPIO13
Text Label 8200 3350 0    50   ~ 0
GPIO14
Text Label 8200 3750 0    50   ~ 0
GPIO18
Text Label 8200 3850 0    50   ~ 0
GPIO19
Text Label 8200 3950 0    50   ~ 0
GPIO21
Text Label 8200 4050 0    50   ~ 0
GPIO22
Wire Wire Line
	8200 4150 8600 4150
Wire Wire Line
	8200 4250 8600 4250
Wire Wire Line
	8200 4350 8600 4350
Wire Wire Line
	8200 4450 8600 4450
Wire Wire Line
	8200 4550 8600 4550
Wire Wire Line
	8200 4650 8600 4650
Text Label 8200 4150 0    50   ~ 0
GPIO23
Text Label 8200 4250 0    50   ~ 0
GPIO25
Text Label 8200 4350 0    50   ~ 0
GPIO26
Text Label 8200 4450 0    50   ~ 0
GPIO27
Text Label 8200 4550 0    50   ~ 0
GPIO32
Text Label 8200 4650 0    50   ~ 0
GPIO33
Wire Wire Line
	8200 4750 8600 4750
Wire Wire Line
	8200 4850 8600 4850
Wire Wire Line
	8200 4950 8600 4950
Wire Wire Line
	8200 5050 8600 5050
Text Label 8200 4750 0    50   ~ 0
GPI34
Text Label 8200 4850 0    50   ~ 0
GPI35
Text Label 8200 4950 0    50   ~ 0
GPI36
Text Label 8200 5050 0    50   ~ 0
GPI39
Text HLabel 8600 2850 2    50   BiDi Italic 10
GPIO2
Text HLabel 8600 2950 2    50   BiDi Italic 10
GPIO4
Text HLabel 8600 3050 2    50   BiDi Italic 10
GPIO5
Text HLabel 8600 3150 2    50   BiDi Italic 10
GPIO12
Text HLabel 8600 3250 2    50   BiDi ~ 0
GPIO13
Text HLabel 8600 3350 2    50   BiDi ~ 0
GPIO14
Text HLabel 8600 3750 2    50   BiDi ~ 0
GPIO18
Text HLabel 8600 3850 2    50   BiDi ~ 0
GPIO19
Text HLabel 8600 3950 2    50   BiDi ~ 0
GPIO21
Text HLabel 8600 4050 2    50   BiDi ~ 0
GPIO22
Text HLabel 8600 4150 2    50   BiDi ~ 0
GPIO23
Text HLabel 8600 4250 2    50   BiDi ~ 0
GPIO25
Text HLabel 8600 4350 2    50   BiDi ~ 0
GPIO26
Text HLabel 8600 4450 2    50   BiDi ~ 0
GPIO27
Text HLabel 8600 4550 2    50   BiDi ~ 0
GPIO32
Text HLabel 8600 4650 2    50   BiDi ~ 0
GPIO33
Text HLabel 8600 4750 2    50   Input ~ 0
GPI34
Text HLabel 8600 4850 2    50   Input ~ 0
GPI35
Text HLabel 8600 4950 2    50   Input ~ 0
GPI36
Text HLabel 8600 5050 2    50   Input ~ 0
GPI39
Wire Wire Line
	8200 3450 8600 3450
Text Label 8200 3450 0    50   ~ 0
GPIO15
Text HLabel 8600 3450 2    50   BiDi Italic 10
GPIO15
Text Notes 7050 7100 0    50   ~ 0
ESP32 has 6 strapping pins:\n• MTDI/GPIO12: internal pull-down\n• GPIO0: internal pull-up\n• GPIO2: internal pull-down\n• GPIO4: internal pull-down\n• MTDO/GPIO15: internal pull-up\n• GPIO5: internal pull-up
$Comp
L RF_Module:ESP32-PICO-D4 U3
U 1 1 5ECD7167
P 5150 3600
F 0 "U3" H 5150 1911 50  0000 C CNN
F 1 "ESP32-PICO-D4" H 5150 1820 50  0000 C CNN
F 2 "Package_DFN_QFN:QFN-48-1EP_7x7mm_P0.5mm_EP5.3x5.3mm" H 5150 1900 50  0001 C CNN
F 3 "https://www.espressif.com/sites/default/files/documentation/esp32-pico-d4_datasheet_en.pdf" H 5400 2600 50  0001 C CNN
	1    5150 3600
	1    0    0    -1  
$EndComp
Wire Wire Line
	4950 2000 5050 2000
Wire Wire Line
	5150 2000 5050 2000
Connection ~ 5050 2000
Wire Wire Line
	5250 2000 5150 2000
Connection ~ 5150 2000
$Comp
L Device:R R6
U 1 1 5ED510CB
P 6600 2400
F 0 "R6" V 6393 2400 50  0000 C CNN
F 1 "10K" V 6484 2400 50  0000 C CNN
F 2 "Resistor_SMD:R_0402_1005Metric" V 6530 2400 50  0001 C CNN
F 3 "" H 6600 2400 50  0001 C CNN
	1    6600 2400
	0    1    1    0   
$EndComp
$Comp
L power:+3V3 #PWR?
U 1 1 5ED5479E
P 6750 2000
AR Path="/5ED5479E" Ref="#PWR?"  Part="1" 
AR Path="/5D30401D/5ED5479E" Ref="#PWR?"  Part="1" 
AR Path="/5D881C9A/5ED5479E" Ref="#PWR?"  Part="1" 
AR Path="/5D8B744C/5ED5479E" Ref="#PWR0116"  Part="1" 
AR Path="/5ECFDC97/5ED5479E" Ref="#PWR?"  Part="1" 
F 0 "#PWR0116" H 6750 1850 50  0001 C CNN
F 1 "+3V3" H 6765 2173 50  0000 C CNN
F 2 "" H 6750 2000 50  0001 C CNN
F 3 "" H 6750 2000 50  0001 C CNN
	1    6750 2000
	1    0    0    -1  
$EndComp
Wire Wire Line
	6750 2000 6750 2400
Wire Wire Line
	5950 2500 6450 2500
Wire Wire Line
	5950 2600 6450 2600
Wire Wire Line
	5950 2700 6450 2700
Wire Wire Line
	5950 2800 6450 2800
Wire Wire Line
	5950 2900 6450 2900
Wire Wire Line
	5950 3000 6450 3000
Wire Wire Line
	5950 3100 6450 3100
Wire Wire Line
	5950 3200 6450 3200
Wire Wire Line
	5950 3300 6450 3300
Wire Wire Line
	5950 3400 6450 3400
Wire Wire Line
	5950 3500 6450 3500
Wire Wire Line
	5950 3600 6450 3600
Wire Wire Line
	5950 3700 6450 3700
Wire Wire Line
	5950 3800 6450 3800
Wire Wire Line
	5950 3900 6450 3900
Wire Wire Line
	5950 4000 6450 4000
Wire Wire Line
	5950 4100 6450 4100
Wire Wire Line
	5950 4200 6450 4200
Wire Wire Line
	5950 4300 6450 4300
Wire Wire Line
	5950 4400 6450 4400
Wire Wire Line
	5950 4500 6450 4500
Wire Wire Line
	5950 4600 6450 4600
Wire Wire Line
	5950 4700 6450 4700
Text Label 6450 2500 2    50   ~ 0
TXD
Text Label 6450 2700 2    50   ~ 0
RXD
Wire Wire Line
	6450 2400 5950 2400
Text Label 6450 2400 2    50   ~ 0
GPIO0
Wire Wire Line
	4350 2400 3950 2400
Wire Wire Line
	4350 2500 3950 2500
Wire Wire Line
	4350 2600 3950 2600
Wire Wire Line
	4350 2700 3950 2700
Wire Wire Line
	4350 3600 3950 3600
Wire Wire Line
	4350 3700 3950 3700
Wire Wire Line
	4350 3800 3950 3800
Wire Wire Line
	4350 3900 3950 3900
Wire Wire Line
	4350 4000 3950 4000
Wire Wire Line
	4350 4100 3950 4100
Text Label 3950 2200 0    50   ~ 0
EN
Text Label 6450 2600 2    50   ~ 0
GPIO2
Text Label 6450 2800 2    50   ~ 0
GPIO4
Text Label 6450 2900 2    50   ~ 0
GPIO5
Text Label 6450 3200 2    50   ~ 0
GPIO12
Text Label 6450 3300 2    50   ~ 0
GPIO13
Text Label 6450 3400 2    50   ~ 0
GPIO14
Text Label 6450 3500 2    50   ~ 0
GPIO15
Text Label 6450 3600 2    50   ~ 0
GPIO18
Text Label 6450 3700 2    50   ~ 0
GPIO19
Text Label 6450 3800 2    50   ~ 0
GPIO21
Text Label 6450 3900 2    50   ~ 0
GPIO22
Text Label 6450 4000 2    50   ~ 0
GPIO23
Text Label 6450 4100 2    50   ~ 0
GPIO25
Text Label 6450 4200 2    50   ~ 0
GPIO26
Text Label 6450 4300 2    50   ~ 0
GPIO27
Text Label 6450 4400 2    50   ~ 0
GPIO32
Text Label 6450 4500 2    50   ~ 0
GPIO33
Text Label 6450 4600 2    50   ~ 0
GPI34
Text Label 6450 4700 2    50   ~ 0
GPI35
Text Label 3950 2400 0    50   ~ 0
GPI36
Text Label 3950 2700 0    50   ~ 0
GPI39
NoConn ~ 6450 3000
NoConn ~ 6450 3100
NoConn ~ 3950 3600
NoConn ~ 3950 3700
NoConn ~ 3950 3800
NoConn ~ 3950 3900
NoConn ~ 3950 4000
NoConn ~ 3950 4100
NoConn ~ 5950 4900
NoConn ~ 3950 2500
NoConn ~ 3950 2600
Wire Wire Line
	8600 2550 8200 2550
$Comp
L Device:C_Small C5
U 1 1 5EE0D340
P 3500 2300
F 0 "C5" H 3592 2346 50  0000 L CNN
F 1 "0.1uF" H 3592 2255 50  0000 L CNN
F 2 "Capacitor_SMD:C_0402_1005Metric" H 3500 2300 50  0001 C CNN
F 3 "~" H 3500 2300 50  0001 C CNN
	1    3500 2300
	1    0    0    -1  
$EndComp
Wire Wire Line
	3500 2000 4950 2000
Connection ~ 4950 2000
Wire Wire Line
	3500 2200 4350 2200
Connection ~ 3500 2200
Wire Wire Line
	3150 2200 3150 2000
$Comp
L power:GND #PWR0117
U 1 1 5EE28B06
P 3500 2400
F 0 "#PWR0117" H 3500 2150 50  0001 C CNN
F 1 "GND" H 3505 2227 50  0000 C CNN
F 2 "" H 3500 2400 50  0001 C CNN
F 3 "" H 3500 2400 50  0001 C CNN
	1    3500 2400
	1    0    0    -1  
$EndComp
$Comp
L Device:Antenna_Chip AE1
U 1 1 5EE312DC
P 6000 1000
F 0 "AE1" H 6180 1127 50  0000 L CNN
F 1 "ANT" H 6180 1036 50  0000 L CNN
F 2 "ANT:AN9520" H 5900 1175 50  0001 C CNN
F 3 "~" H 5900 1175 50  0001 C CNN
	1    6000 1000
	0    -1   -1   0   
$EndComp
$Comp
L Device:C_Small C7
U 1 1 5ED4981A
P 6250 1650
F 0 "C7" H 6050 1700 50  0000 L CNN
F 1 "NC" H 6050 1600 50  0000 L CNN
F 2 "Capacitor_SMD:C_0402_1005Metric" H 6250 1650 50  0001 C CNN
F 3 "~" H 6250 1650 50  0001 C CNN
	1    6250 1650
	0    -1   -1   0   
$EndComp
$Comp
L Device:L_Small L1
U 1 1 5ED51720
P 6150 1550
F 0 "L1" H 6300 1500 50  0000 R CNN
F 1 "NC" H 6300 1600 50  0000 R CNN
F 2 "Inductor_SMD:L_0402_1005Metric" H 6150 1550 50  0001 C CNN
F 3 "~" H 6150 1550 50  0001 C CNN
	1    6150 1550
	-1   0    0    1   
$EndComp
$Comp
L Device:C_Small C6
U 1 1 5ED51E87
P 6250 1450
F 0 "C6" H 6342 1496 50  0000 L CNN
F 1 "NC" H 6342 1405 50  0000 L CNN
F 2 "Capacitor_SMD:C_0402_1005Metric" H 6250 1450 50  0001 C CNN
F 3 "~" H 6250 1450 50  0001 C CNN
	1    6250 1450
	0    -1   -1   0   
$EndComp
Wire Wire Line
	5950 2200 6150 2200
Wire Wire Line
	6150 2200 6150 1650
Connection ~ 6150 1650
Wire Wire Line
	6150 1450 6150 1100
Wire Wire Line
	6150 1100 6100 1100
$Comp
L power:GND #PWR0118
U 1 1 5ED6F11B
P 6450 1650
F 0 "#PWR0118" H 6450 1400 50  0001 C CNN
F 1 "GND" V 6455 1522 50  0000 R CNN
F 2 "" H 6450 1650 50  0001 C CNN
F 3 "" H 6450 1650 50  0001 C CNN
	1    6450 1650
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR0119
U 1 1 5ED70785
P 6450 1450
F 0 "#PWR0119" H 6450 1200 50  0001 C CNN
F 1 "GND" V 6455 1322 50  0000 R CNN
F 2 "" H 6450 1450 50  0001 C CNN
F 3 "" H 6450 1450 50  0001 C CNN
	1    6450 1450
	0    -1   -1   0   
$EndComp
Wire Wire Line
	6450 1450 6350 1450
Wire Wire Line
	6450 1650 6350 1650
Connection ~ 6150 1450
NoConn ~ 6100 900 
$EndSCHEMATC
