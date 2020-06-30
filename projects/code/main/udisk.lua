local LV_SYMBOL_LEFT  = "\xef\x81\x93"
local LV_SYMBOL_RIGHT = "\xef\x81\x94"
local LV_SYMBOL_UP    = "\xef\x81\xb7"
local LV_SYMBOL_DOWN  = "\xef\x81\xb8"

print('udisk ok')
lcd.print('udisk ok: '..sys.info().version)

led.write(255, 0, 0)
sys.delay(500)
led.write(0, 255, 0)
sys.delay(500)
led.write(0, 0, 255)
sys.delay(500)
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

print(web.file('/lua/img/love.bin', 'http://xwx.emake.run/udisk/img/love2.bin'))
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
        -- print(dump.table(net_info))
        -- print(dump.table(sys_info))
        -- print(dump.table(sys_stats))
        print(string.format('RAM left: %dB', tonumber(sys_info.total_heap)))
        print(string.format('CPU load: %d%%', 100 - sys_stats.IDLE0.load))
        last_1s = os.time()
    end

    if (os.difftime (os.time(), last_30s) >= 30) then
        local display = '#FF6100 '..os.date("%Y-%m-%d")..'#\n'..'#00BFFF '..net_info.ip.sta..'#\n'..'#FFC0CB '..net_info.mac.sta..'#'
        local shares = web.rest('GET', 'http://hq.sinajs.cn/list=sh688018')
        if (shares) then
            local shares_json = '['..string.match(string.gsub(shares, ',', '\",\"'), '=(.*);')..']'
            local shares_t = json.decode(shares_json)
            local price_cur = tonumber(shares_t[4])
            local price_last = tonumber(shares_t[3])
            local price_diff = price_cur - price_last
            local price_percentage = price_diff / price_last
            local price_color = (price_percentage > 0) and 'FF0000' or '00FF00'
            local price_symbol = (price_percentage > 0) and LV_SYMBOL_UP or LV_SYMBOL_DOWN
            display = display..'\n#FF0000 '..LV_SYMBOL_LEFT..'ESPRESSIF'..LV_SYMBOL_RIGHT..'#\n'..string.format('#%s %.2f %s#\n#%s %+.2f %+.2f%%#', price_color, price_cur, price_symbol, price_color, price_diff, price_percentage * 100)
            print(dump.table(shares_t))
        end
        -- lcd.print(display)
        last_30s = os.time()
    end

    if (mqtt.run()) then
        if (handle.event == 'MQTT_EVENT_DATA') then
            local t = json.decode(handle.data)
            print(dump.table(t))
            if (handle.topic == 'udisk') then
                print(handle.data)
                lcd.print(handle.data)
            end
        elseif (handle.event == 'MQTT_EVENT_CONNECTED') then
            mqtt_connected = true
            mqtt.sub('udisk', 0)
        elseif (handle.event == 'MQTT_EVENT_DISCONNECTED') then
            mqtt_connected = false
        end
    end

    sys_stats = sys.stats(1000)
end