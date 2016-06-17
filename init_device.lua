package.path = "/mnt/sdcard/TouchSprite/lua/common/?.lua;"..package.path
require("common.TSLibEx")
require("common.TSLib")

function setXposedInstaller()
	local x,y
	
	--返回Xposed主界面
	closeApp("de.robv.android.xposed.installer")
	os.execute("am start --activity-no-history de.robv.android.xposed.installer/.WelcomeActivity")
	
	--点击模块
	x,y = findMultiColorInRegionFuzzyInTime( 0x515151, "16|-5|0x949494,25|7|0x9a9a9a,33|22|0x909090,50|2|0x7d7d7d,60|-1|0x696969,73|15|0x787878,146|14|0xe5e5e5,595|15|0xe5e5e5", 90, 0, 0, 719, 1279, 5000)
	if x == -1 or y == -1 then
		return false
	end
	tap(x,y)
	
	--选择hookIMEI模块
	x,y = findMultiColorInRegionFuzzyInTime( 0x6e6e6e, "18|0|0x7e7e7e,18|4|0x6e6e6e,17|7|0xcacaca,-13|31|0x808080,-504|11|0x5f5f5f,-481|3|0x6c6c6c,-446|9|0x313131,-425|7|0x898989", 90, 0, 0, 719, 1279, 2000)
	if x ~= -1 and y ~= -1 then
		tap(x,y)
	end
	mSleep(1000)
	
	--返回Xposed主界面
	closeApp("de.robv.android.xposed.installer")
	os.execute("am start --activity-no-history de.robv.android.xposed.installer/.WelcomeActivity")
	
	--选择设置
	x,y = findMultiColorInRegionFuzzyInTime( 0x2b2b2b, "8|5|0x6d6d6d,24|-12|0xaaaaaa,31|3|0x565656,30|10|0x717171,53|-1|0x898989,68|9|0x636363,82|24|0x5c5c5c", 90, 0, 0, 719, 1279, 5000)
	if x == -1 or y == -1 then
		return false
	end
	tap(x,y)
	
	--禁用资源钩子
	x,y = findMultiColorInRegionFuzzyInTime( 0xd5d5d5, "24|1|0x757575,23|4|0xb7b7b7,24|7|0x676767,-555|-46|0x9a9a9a,-534|-46|0xb2b2b2,-506|-48|0x808080,-467|-47|0x636363,-539|-76|0xb7b7b7", 90, 0, 0, 719, 1279, 2000)
	if x ~= -1 and y ~= -1 then
		tap(x,y)
	end
	tap(x,y)
	mSleep(1000)
	
	--启动Xposed主界面
	closeApp("de.robv.android.xposed.installer")
	os.execute("am start --activity-no-history de.robv.android.xposed.installer/.WelcomeActivity")
	
	--点击框架
	x,y = findMultiColorInRegionFuzzyInTime( 0x4f4f4f, "17|-7|0x888888,18|2|0x000000,24|10|0x4d4d4d,50|8|0x8f8f8f,55|8|0x6a6a6a,74|15|0x666666,168|7|0xe5e5e5,622|19|0xe5e5e5", 90, 0, 0, 719, 1279, 80000)
	if x == -1 or y == -1 then
		return false
	end
	tap(x,y)
	
	--第一次出现弹框
	x,y = findMultiColorInRegionFuzzyInTime( 0x4a4a4a, "4|4|0x999999,12|6|0x494949,23|6|0x2b2b2b,29|0|0x7b7b7b,-251|-508|0x33b5e5,-271|-440|0x33b5e5,268|-440|0x33b5e5", 90, 0, 0, 719, 1279, 2000)
	if x ~= -1 and y ~= -1 then
		tap(x, y)
	end
	
	--点击安装/更新
	x,y = findMultiColorInRegionFuzzyInTime( 0x6a6a6a, "3|2|0x6a6a6a,21|4|0x171717,37|5|0x484848,57|8|0x727272,42|20|0x6a6a6a,-287|13|0xc6c6c6,289|18|0xc6c6c6", 90, 0, 0, 719, 1279, 3000)
	if x == -1 or y == -1 then
		return false
	end
	tap(x,y-100)
	
	--重启
	x,y = findMultiColorInRegionFuzzyInTime( 0x282828, "12|0|0x575757,29|0|0x838383,35|6|0x2a2a2a,37|20|0x545454,-135|14|0xdcdcdc,-425|-40|0xdcdcdc,171|-39|0xdcdcdc", 90, 0, 0, 719, 1279, 3000)
	if x == -1 or y == -1 then
		return false
	end
	tap(x,y)
	
	return true
end

function setLockClose()
	local x,y
	os.execute("am start --activity-no-history com.android.settings/.SecuritySettings")
	x,y = findMultiColorInRegionFuzzyInTime( 0x595959, "12|3|0xd7d7d7,31|-1|0xa2a2a2,68|7|0x414141,80|2|0xa1a1a1,118|23|0x707070,586|25|0xffffff", 90, 0, 0, 719, 1279, 5000)
	if x == -1 or y == -1 then
		return false
	end
	tap(x,y)
	
	x,y = findMultiColorInRegionFuzzyInTime( 0xa2a2a2, "-9|11|0x595959,4|12|0x5f5f5f,3|-96|0x868686,12|-103|0x454545,92|-104|0x4b4b4b,160|-102|0x6b6b6b,232|-99|0x949494,611|-91|0xf3f3f3", 90, 0, 0, 719, 1279, 3000)
	if x == -1 or y == -1 then
		return false
	end
	tap(x,y)
	return true
end

toast(getTopActivity())
--writeFileString("/sdcard/aaa.txt",getTopActivity())

function main()
	os.execute("settings put system screen_off_timeout 2147483647")
	mSleep(1000)
	os.execute("mv /system/fonts/FangZhengLTH.ttf /system/fonts/FangZhengLTH.ttf.bak")
	mSleep(1000)
	os.execute("ln -s /system/fonts/DroidSansFallback.ttf /system/fonts/FangZhengLTH.ttf")
	mSleep(1000)

--	--安装微信
--	getHttpFile("", "/sdcard/tmp/weixin.apk")
--	os.execute("pm install -r /sdcard/tmp/weixin.apk")
--	--安装Xposed
--	getHttpFile("", "/sdcard/tmp/Xposed.apk")
--	os.execute("pm install -r /sdcard/tmp/Xposed.apk")
--	--安装Xposed模块
--	getHttpFile("", "/sdcard/tmp/HookImei_X.apk")
--	os.execute("pm install -r /sdcard/tmp/HookImei_X.apk")
	
	co = coroutine.create(function()
			setLockClose()
			setXposedInstaller() 
			end)
	while true do
		if coroutine.status(co) == "dead" then
			break
		end
		coroutine.resume(co)
	end
end

--main()
