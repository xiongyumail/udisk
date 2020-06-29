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
    print('Connect to AP and log in to http://192.168.1.1 and configure router information')
    lcd.print('Connect to AP and log in to http://192.168.1.1 and configure router information')
    wifi.start_ap('udisk', '')
end
sys.delay(1000)
httpd.start('udisk')
lcd.write('WIFI', 1)
print(dump.table(net.info()))
while (1) do
    web.file('/lua/udisk.lua', 'http://xwx.emake.run/udisk/udisk.lua')
    dofile('/lua/udisk.lua')
    sys.yield()
end
