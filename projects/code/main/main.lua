json = require('json')
dump = require('dump')
wifi = require('wifi')

function lcd.print(str)
    return lcd.write('MSG', str)
end
lcd.write('IMG', 'P:/lua/img/love.bin')
lcd.write('BATT', 0)
print(dump.table(sys.info()))
lcd.print('Connecting\nWiFi\n...')
lcd.write('WIFI', 0)
sys.delay(1000)
if (not wifi.start_sta('XWX', 'xwxlovexy')) then
    if (apds.read('distance') > 200) then
        print('Connect to AP and log in to http://192.168.1.1 and configure router information')
        lcd.print('Connect to AP and log in to http://192.168.1.1 and configure router information')
        wifi.start_ap('udisk', '')
    end
else
    sys.delay(1000)
    lcd.write('WIFI', 1)
    print(dump.table(net.info()))
    web.file('/lua/udisk.lua', 'http://xwx.emake.run/udisk/lua/udisk.lua')
    dofile('/lua/udisk.lua')
end

lcd.print('')
while (1) do
    for i = 0, 2, 1 do
        if (i == 0) then
            lcd.write('IMG', 'P:/lua/img/love.bin')
        elseif(i == 1) then
            lcd.write('IMG', 'P:/lua/img/love1.bin')
        elseif(i == 2) then
            lcd.write('IMG', 'P:/lua/img/love2.bin')
        end
        
        for x = 0, 255, 1 do
            led.write(x, 0, 0)
            sys.delay(10)
        end
        for x = 0, 255, 1 do
            led.write(255 - x, 0, 0)
            sys.delay(10)
        end
        for x = 0, 255, 1 do
            led.write(0, x, 0)
            sys.delay(10)
        end
        for x = 0, 255, 1 do
            led.write(0, 255 - x, 0)
            sys.delay(10)
        end
        for x = 0, 255, 1 do
            led.write(0, 0, x)
            sys.delay(10)
        end
        for x = 0, 255, 1 do
            led.write(0, 0, 255 - x)
            sys.delay(10)
        end
        for x = 0, 255, 1 do
            led.write(x, x, x)
            sys.delay(10)
        end
        for x = 0, 255, 1 do
            led.write(255 - x, 255 - x, 255 - x)
            sys.delay(10)
        end
    end
end

