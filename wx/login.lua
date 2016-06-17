require("TSLib")
require("TSLibEx")
require("wx_ui")
WxLogin = {strCurUsr="", strCurPwd="", isLogined=false}
WxLogin.__index = WxLogin


function WxLogin:new()  
	local self = {}     
	setmetatable(self, WxLogin)
	return self    
end

function WxLogin:loginByNewUsr()
	local isLogined = false
	
	tap(517,221)	--点击账号编辑框
	mSleep(500)
	inputText(self.strCurUsr)
	mSleep(500)
	tap(548,322)	--点击密码编辑框
	mSleep(500)
	inputText(self.strCurPwd)
	mSleep(500)
	tap(360,462)	--点击登录
	for var = 1, 20 do
		if WxUI:findLoginFingerprintUI() then
			isLogined = true
			break
		end
		if WxUI:findFirstLoginPrompt() then
			tap(414,783)	--点击否
		elseif WxUI:findIllegalAccount() then
			return false, "Illegal account"
		elseif WxUI:findUsrPwdWrong() then
			return false, "User or password wrong"
		elseif WxUI:findAccountNotLoginForLongTime() then
			return false, "Need unlock"
		elseif WxUI:findNeedPhoneVerify() then
			return false, "Need SMS verify"
		elseif WxUI:findNeedFriendVerify() then
			tap(541,758)
			x,y = findMultiColorInRegionFuzzyInTime( 0x04be02, "-236|0|0x04be02,-206|41|0x04be02,252|37|0x04be02,-107|-170|0x030303,-55|-258|0x84bc59,-32|-264|0xffffff,-21|-266|0x73a051", 90, 0, 0, 719, 1279,5000)
			if x == -1 or y == -1 then
				return false, "Friend verify failed"
			end
			tap(x,y)
			mSleep(2000)
			tap(360,462)	--点击登录
			return self:login(self.strCurUsr, self.strCurPwd)
		elseif WxUI:findNeedInputVerify() then
			return false, "Need codes"
		end
		
		mSleep(500)
	end
	
	if isLogined then
		return true, "login succeeded"
	else
		return false, "login failed"
	end
end

function WxLogin:login(strCurUsr, strCurPwd)
	closeApp("com.tencent.mm")
	mSleep(3000)
	os.execute("rm -fr /data/data/com.tencent.mm/*")
	mSleep(2000)
	local cache_file = "/data/mpsp/com.tencent.mm/"..strCurUsr
	local sdcard_cache_dir = "/sdcard/mpsp/com.tencent.mm/"..strCurUsr
	
	if fileExists(sdcard_cache_dir) then
		return self:loginByCache(cache_file, strCurUsr, strCurPwd)
	end
		
	return self:loginByInput(strCurUsr, strCurPwd)
end

function WxLogin:loginByCache(cache_file, strCurUsr, strCurPwd)
	toast("loginByCache")

	mSleep(1000)
	os.execute("cp -a "..cache_file.."/* /data/data/com.tencent.mm")
	mSleep(2000)
	runApp("com.tencent.mm")
	mSleep(3000)
	--判断是否登录成功，失败则输入用户名密码进行登录
	x,y = findMultiColorInRegionFuzzyInTime( 0xfcfcfc, "20|-11|0x45c01a,24|-26|0x45c01a,24|-33|0xfcfcfc,21|10|0xfcfcfc,16|5|0x45c01a,28|19|0xfcfcfc,50|19|0xfcfcfc,41|32|0x45c01a", 90, 0, 0, 719, 1279, 12000)
	if x == -1 or y == -1 then
		return self:loginByInput(strCurUsr, strCurPwd)
	end
	
	self.strCurUsr = strCurUsr
	self.strCurPwd = strCurPwd
	self.isLogined = true
	return true,"login succeeded"
end

function WxLogin:loginByInput(strCurUsr, strCurPwd)
	toast("loginByInput")
	local isLoginUI = false
	local msg
	
	mSleep(2000)
	
	--登录失败重新试登一次，第二次重试采用关闭APP的方式
	--登录可以直接跳到账号输入的那个界面登录，但有时跳不成功，所以当没跳转成功时跳到最开始页面登录
	--判断是否到登录界面或是否登录成功采用每隔500ms判断一次是否进入登录界面
	local iTimes = 2
	while iTimes ~= 0 do
		os.execute("am start --activity-no-history com.tencent.mm/.ui.account.LoginUI")
		for var = 1, 15 do
			if WxUI:findUsrLoginUI() then
				isLoginUI = true
				break
			end
			mSleep(500)
		end
		
		if isLoginUI == false then
			os.execute("am start --activity-no-history com.tencent.mm/.ui.account.LoginSelectorUI")
			mSleep(3000)
			randomTap(356,1103)
			mSleep(600)
			randomTap(483,1185)
			mSleep(600)
			for var = 1, 20 do
				if WxUI:findUsrLoginUI() then
					isLoginUI = true
					break
				end
				mSleep(500)
			end
		end
		
		if isLoginUI then
			break
		else
			iTimes = iTimes - 1
            if iTimes ~= 0 then
                toast("重试登录")
                closeApp("com.tencent.mm")
            end
		end
	end
	
	if isLoginUI == false then
		self.isLogined = false
		return false, "未找到登录页面"
	end
	self.strCurUsr = strCurUsr
	self.strCurPwd = strCurPwd
    self.isLogined, msg = self:loginByNewUsr()
	return self.isLogined, msg
end