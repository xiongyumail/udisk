local LV_SYMBOL_LEFT  = "\xef\x81\x93"
local LV_SYMBOL_RIGHT = "\xef\x81\x94"
local LV_SYMBOL_UP    = "\xef\x81\xb7"
local LV_SYMBOL_DOWN  = "\xef\x81\xb8"

print('udisk ok')
lcd.print('udisk ok: '..sys.info().version)
led.write(0, 0, 0)

latest_ver = web.rest('GET', 'http://xwx.emake.run/udisk/bin/udisk.version')
if (not string.find(latest_ver, sys.info().version)) then
    print('start ota: '..latest_ver)
    lcd.print('start ota: '..latest_ver)
    cert = web.rest('GET', 'http://xwx.emake.run/cert.pem')
    web.ota('http://xwx.emake.run/udisk/bin/udisk.bin', cert)
    web.file('/lua/wifi.lua', 'http://xwx.emake.run/udisk/lua/wifi.lua')
    web.file('/lua/main.lua', 'http://xwx.emake.run/udisk/lua/main.lua')
    sys.restart()
end

sys.sntp('ntp1.aliyun.com')
print(os.date("%Y-%m-%d %H:%M:%S"))
lcd.print('Welcome\n XWX')
local info = {}
local city_sub = 'sh_temp'
local location = web.rest('GET', 'http://pv.sohu.com/cityjson')
if (location) then
    local location_json = string.match(location, '({.*});')
    local location_t = json.decode(location_json)
    print (dump.table(location_t))
    local cid_pre = string.sub(location_t.cid, 1, 3)
    if (cid_pre == '310') then
        city_sub = 'sh_temp'
    elseif (cid_pre == '360') then
        city_sub = 'nc_temp'
    end
    info.location = location_t
end

print(web.file('/lua/img/love.bin', 'http://xwx.emake.run/udisk/img/love.bin'))
print(web.file('/lua/img/love1.bin', 'http://xwx.emake.run/udisk/img/love1.bin'))
print(web.file('/lua/img/love2.bin', 'http://xwx.emake.run/udisk/img/love2.bin'))
lcd.write('IMG', 'P:/lua/img/love.bin')
local mqtt_connected = false
mqtt.start('mqtt://mqtt.emake.run')
local last_1s = os.time()
local last_30s = os.time() - 25
local sys_info = sys.info()
local net_info = net.info()
local sys_stats = sys.stats(1000)
while (1) do
    if (os.difftime (os.time(), last_1s) >= 1) then
        sys_info = sys.info()
        net_info = net.info()
        lcd.write('STATE', os.date("%H:%M:%S"))
        if (net_info.ip.sta == '0.0.0.0') then
            lcd.write('WIFI', 0)
        else
            lcd.write('WIFI', 1)
        end
        print(string.format('RAM left: %dB', tonumber(sys_info.total_heap)))
        print(string.format('CPU load: %d%%', 100 - sys_stats.IDLE0.load))
        last_1s = os.time()
    end

    local handle = mqtt.run()
    if (handle) then
        if (handle.event == 'MQTT_EVENT_DATA') then
            if (handle.topic == 'udisk_msg') then
                print(handle.data)
                lcd.print(handle.data)
            end
            if (handle.topic == city_sub) then
                local display = '#FF6100 '..os.date("%Y-%m-%d")..'#\n'..'#00BFFF '..net_info.ip.sta..'#\n'..'#FFC0CB '..net_info.mac.sta..'#'
                local t = json.decode(handle.data)
                display = display..'\n#FF8C00 '..LV_SYMBOL_LEFT..'WEATHER'..LV_SYMBOL_RIGHT..'#\n'..string.format('#87CEEB %s#\n#FFA500 %s %s\'C#', t.results[1].location.name, t.results[1].now.text, t.results[1].now.temperature)
                print(display)
                lcd.print(display)
                info.clock = os.clock()
                info.date = os.date("%Y-%m-%d %H:%M:%S")
                info.info = sys_info
                info.net = net_info
                info.cpu = 100 - sys_stats.IDLE0.load
                print(json.encode(info))
                mqtt.pub('udisk_info', json.encode(info), 0)
            end
        elseif (handle.event == 'MQTT_EVENT_CONNECTED') then
            mqtt_connected = true
            mqtt.sub('udisk_msg', 0)
            mqtt.sub(city_sub, 0)
        elseif (handle.event == 'MQTT_EVENT_DISCONNECTED') then
            mqtt_connected = false
        end
    end

    sys_stats = sys.stats(1000)
end