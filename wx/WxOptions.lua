require("login")
require("log")
require("ProtocolDefine")
require("json")
--require("wxAccount")

WxOptions = {}
WxOptions.__index = WxOptions

local wxlog = nil
local wxLogin = nil
function WxOptions:new()
	local self = {}     
	setmetatable(self, WxOptions)
	wxlog = wxlog or Log:new("weixin")
	return self  
end

function WxOptions:restartApp()
	closeApp("com.tencent.mm")
	coMSleep(1000)
	os.execute("am start -W --activity-no-history --activity-single-top com.tencent.mm/.ui.LauncherUI")
	coMSleep(8000)
end

function WxOptions:login(strUsr, strPwd)
	local ret = true
	local msg = "登录成功"
	local file
		
	wxLogin = wxLogin or WxLogin:new()
	if wxLogin.isLogined and wxLogin.strCurUsr == strUsr then
		return true, "Login succeeded"
	end
	
	ret, msg = wxLogin:login(strUsr, strPwd)
	if ret then
		for var = 1, 20 do
			coMSleep(500)
			if WxUI:findLoginFingerprintUI() then
				tap(263,1222)
			end
			x,y = findMultiColorInRegionFuzzy( 0x45c01a, "-14|-6|0xfcfcfc,20|-18|0xd0eec5,-15|27|0x60c93c,-14|29|0x46c01b,-4|36|0x47c11d,24|32|0x59c732,6|18|0xfcfcfc", 90, 0, 0, 719, 1279)
			if x ~= -1 and y ~= -1 then
				break
			end
		end
		
		coMSleep(3000)
	end
	
	wxlog:log(msg)
	return ret, msg
end

function WxOptions:logout()
	--设置界面
	wxlog:log("登出")
--	wxLogin = wxLogin or WxLogin:new()
	if wxLogin == nil or wxLogin.isLogined == false then
		return true, "Quit succeeded"
	end

	os.execute("am start --activity-no-history com.tencent.mm/.plugin.setting.ui.setting.SettingsUI");
	x,y = findMultiColorInRegionFuzzyInTime( 0x353535, "-1|1|0x6b6b6b,14|-2|0x848484,15|-1|0x363636,31|1|0xaeaeae,51|9|0x555555,50|22|0x585858,51|24|0x959595", 90, 0, 0, 719, 1279, 3000)
	if x == -1 or y == -1 then
		return false, "Quit failed"
	end
	tap(331, 953)	--点击退出
	coMSleep(1500)
	tap(342, 604)	--点击退出
	coMSleep(1500)
	tap(541, 753)	--再点一次退出
	wxLogin.strCurUsr = ""
	wxLogin.strCurPwd = ""
	wxLogin.isLogined = false
	coMSleep(8000)
	return true, "Quit succeeded"
end

--function WxOptions:changeUsr(strUsr, strPwd)
--	self:logout()
--	return self:login(strUsr, strPwd)
--end

function WxOptions:addFriend(who)
	local ret, msg
	--添加朋友界面
	wxlog:log("添加好友" .. who)
	os.execute("am start --activity-no-history com.tencent.mm/.plugin.search.ui.FTSAddFriendUI")
	coMSleep(300)
	
	inputText(who)
	coMSleep(300)
	tap(378, 209)	--点击搜索
	coMSleep(2000)
	
	--查找添加按钮位置
	x,y = findMultiColorInRegionFuzzy( 0x45c01a, "-11|-6|0xfdfefd,-29|8|0xffffff,-58|4|0xffffff,56|-1|0xfefffe,80|10|0xbfe9b0,117|16|0xfffffe,-266|-19|0x45c01a,334|-19|0x45c01a", 90, 0, 0, 719, 1279)
	if x ~=-1 and y ~=-1 then
		tap(x,y)	--点击添加按钮
		coMSleep(1500)
		tap(663,93)	--点击发送按钮
		coMSleep(300)
		ret = true
		msg = "Add friend " .. who .. " succeeded"
	else
		ret = false
		msg = "Add friend " .. who .. " failed"
	end
	
	wxlog:log(msg)
	return ret, msg
end

function WxOptions:addMP(name)
	local ret, msg
	
	wxlog:log("添加公众号"..name)
	os.execute("am start --activity-no-history com.tencent.mm/.plugin.search.ui.FTSMainUI")
	coMSleep(2000)
	tap(561,375)	--点击公众号图标
	coMSleep(2000)
	inputText(name)	--搜索公众号
	coMSleep(1000)
	tap(368,75)	--焦点到输入框
	coMSleep(2000)
	tap(647, 1218)	--点击输入法搜索
	coMSleep(5000)
	tap(383,280)	--选择搜索到的第一行
	coMSleep(1000)
	--查找关注按钮
	ret,x,y = findColorInTime(1000, WxUI.findAddMpAddButton)
	if ret then
		tap(x, y)
		msg = "add MP succeeded"
		ret = true
		coMSleep(6000)
	else
		--如果已经关注查找进入公众号
		ret,x,y = findColorInTime(1000, WxUI.findAddMpEnterButton)
		if ret then
			ret = true
			msg = "Already added the MP"
		else
			ret = false
			msg = "Add MP failed"
		end
	end
	
	wxlog:log(msg)
	return ret, msg
end

function WxOptions:sendMsgCommon(message)
	local ret, msg
	local x, y
	
	--寻找聊天框初始打开界面
	ret,x,y = findColorInTime(3000, WxUI.findChatDialogInit)
	if ret == false then
		return false, "Send failed"
	end
	tap(x,y)	--使焦点到输入框
	coMSleep(500)
	
	inputText(message)
	
	--寻找发送按钮
	ret,x,y = findColorInTime(3000, WxUI.findChatDialogSendButton)
	if ret == false then
		return false, "Send failed"
	end	
	tap(x,y)	--点击发送按钮
	coMSleep(300)
	
	return true, "Send succeeded"
end

function WxOptions:sendMsg(to, message)
	wxlog:log("发送消息'" .. message .."'给"..to)
	--搜索常用联系人
	os.execute("am start --activity-no-history com.tencent.mm/.plugin.search.ui.FTSMainUI")
	coMSleep(2000)
	inputText(to)
	coMSleep(300)
	tap(299,311)	--点击搜索到的第一个
	coMSleep(1000)
	
	return self:sendMsgCommon(message)
end

function WxOptions:sendGroupMsg(title, message)
	local ret, msg
	
	wxlog:log("发送群消息'" .. message .."'给"..title)
	os.execute("am start --activity-no-history com.tencent.mm/.plugin.search.ui.FTSMainUI")
	coMSleep(2000)
	inputText(title)
	coMSleep(500)
	
	--寻找群聊分割线
	x,y = findMultiColorInRegionFuzzy( 0xb5b5b5, "3|1|0x999999,3|3|0xfefefe,10|10|0xababab,19|10|0xa4a4a4,29|5|0xd5d5d5,37|10|0xcfcfcf,35|36|0xdadada,368|36|0xdadada", 90, 0, 0, 719, 1279)
	if x ~= -1 and y ~= -1 then
		tap(x+50, y+100)	--点击搜索到的第一个群聊
		coMSleep(1000)
		ret, msg = self:sendMsgCommon(message)
	else
		--寻找最近常使用分割线
		x,y = findMultiColorInRegionFuzzy( 0xd7d7d7, "4|0|0x9e9e9e,9|-2|0xfefefe,35|3|0xa5a5a5,53|5|0xebebeb,62|6|0x9a9a9a,84|5|0xa7a7a7,81|33|0xd9d9d9,599|33|0xd9d9d9", 90, 0, 0, 719, 1279)
		if x ~= -1 and y ~= -1 then
			tap(x+50, y+100)	--点击搜索到的第一个群聊
			coMSleep(1000)
			ret, msg = self:sendMsgCommon(message)
		else
			ret = false
			msg = "Send message failed"
		end
	end
	
	wxlog:log(msg)
	return ret, msg
end

function WxOptions:createGroup(title, members)
	local ret, msg
	
	wxlog:log("创建群聊"..title)
	count = #members
	if count < 2 then
		msg = "Create group failed, people count must more than 2"
		wxlog:log(msg)
		return false, msg
	end
	
	--登录后初始界面
	os.execute("am start --activity-no-history com.tencent.mm/.ui.account.LoginFingerprintUI");
	coMSleep(2000)
	tap(652,99)	--点击右上角"+"按钮
	coMSleep(1000)
	tap(511,197)	--点击发起群聊按钮
	coMSleep(1000)
	tap(455,214)	--使焦点到搜索框
	coMSleep(500)
	for i,v in pairs(members) do
		inputText(v)
		coMSleep(500)
		tap(625, 369)	--点击单选框
		coMSleep(500)
		if i > 1 then
			break
		end
	end
	
	tap(652, 100)	--点击确定，创建群聊
	coMSleep(4000)
	tap(652, 100)	--点击群聊界面右上角图标
	coMSleep(2000)
	tap(502, 772)	--点击修改群聊名称
	coMSleep(2000)
	inputText(title)
	coMSleep(300)
	tap(652,100)	--点击右上角保存
	coMSleep(2000)
	tap(629,265)	--继续添加其他未添加完的好友
	coMSleep(1000)
	tap(455,214)	--使焦点到搜索框
	coMSleep(1000)
	for i,v in pairs(members) do
		if i > 2 then
			inputText(v)
			coMSleep(500)
			tap(625, 369)	--点击单选框
			coMSleep(500)
		end
	end
	tap(652, 100)	--点击确定，创建群聊
	coMSleep(1000)
	
	msg = "Create succeeded"
	wxlog:log(msg)
	return true, msg
end

function WxOptions:commentSNS(keyword, content)
	local ret, msg
	wxlog:log("评论朋友圈'".. keyword.. "'")
	os.execute("am start --activity-no-history com.tencent.mm/.plugin.search.ui.FTSMainUI")
	coMSleep(2000)
	tap(156, 351)	--选择朋友圈
	cocoMSleep(1000)
	inputText(keyword)
	coMSleep(1000)
	tap(514,96)
	coMSleep(2000)
	tap(646, 1221)	--点击输入法搜索
	coMSleep(5000)
	tap(289,368)	--选择搜索到的第一行
	coMSleep(3000)
	ret, msg = self:sendMsgCommon(content)
	wxlog:log(msg)
	return ret, msg
end

function WxOptions:upvoteSNS(keyword)
	local ret, msg
	wxlog:log("朋友圈点赞'".. keyword.. "'")
	os.execute("am start --activity-no-history com.tencent.mm/.plugin.search.ui.FTSMainUI")
	coMSleep(2000)
	tap(156, 351)	--选择朋友圈
	coMSleep(1000)
	inputText(keyword)
	coMSleep(1000)
	tap(514,96)
	coMSleep(2000)
	tap(646, 1221)	--点击输入法搜索
	coMSleep(5000)
	tap(289,368)	--选择搜索到的第一行
	coMSleep(3000)
	--查找评论图标
	x,y = findMultiColorInRegionFuzzy( 0x8593b0, "-8|0|0xffffff,-14|-1|0x8593b0,-19|-5|0xe9ecf0,-26|0|0xffffff,-20|4|0xe7eaef,-6|12|0x8593b0,4|16|0xfefefe,20|-1|0xffffff,15|0|0x8593b0", 90, 0, 0, 719, 1279)
	if x ~= -1 and y ~= -1 then
		tap(x,y)
		coMSleep(1000)
		tap(x-314,y)
		msg = "点赞成功"
		ret = true
	else
		msg = "点赞失败"
		ret = false
	end
	
	wxlog:log(msg)
	return ret, msg
end

function WxOptions:clearRecorder(who)
	local ret, msg
	--搜索常用联系人
	os.execute("am start --activity-no-history com.tencent.mm/.plugin.search.ui.FTSMainUI")
	coMSleep(2000)
	inputText(who)
	coMSleep(300)
	tap(299,311)	--点击搜索到的第一个
	coMSleep(1000)
	
	tap(667,97)	--点击右上角
	coMSleep(600)
	tap(293,1033)	--点击清空聊天记录
	coMSleep(600)
	--查找清空按钮
	x,y = findMultiColorInRegionFuzzy( 0xffffff, "-25|-11|0xff3e3e,-16|-11|0xff3e3e,-12|-7|0xff3e3e,-14|6|0xffaeae,-7|9|0xff3f3f", 90, 0, 0, 719, 1279)
	if x ~= -1 and y ~= -1 then
		tap(x,y)
		ret = true
		msg = "Clear succeeded"
	else
		ret = false
		msg = "Clear failed"
	end
	return ret, msg
end

function WxOptions:vote()
	func = dofile(getPath().."/lua/wx/wx_vote.lua")
	return func()
end

function WxOptions:sendSNS(content)
	local ret, msg
	wxlog:log("发朋友圈")

	os.execute("am start --activity-no-history com.tencent.mm/.plugin.sns.ui.SnsTimeLineUI")
	--查找右上角摄像头
	x,y = findMultiColorInRegionFuzzyInTime( 0xffffff, "-3|-11|0x393a3f,-14|-1|0x393a3f,-16|2|0xdadadb,-19|8|0xffffff,0|21|0x393a3f,14|8|0xffffff,-2|4|0xffffff,-651|-34|0x393a3f", 90, 0, 0, 719, 1279,5000)
	if x == -1 or y == -1 then
		return false, "Send SNS failed"
	end
	
	--长按3秒
	touchDown(0,x,y)
	coMSleep(2000)
	touchUp(0,x,y)
	--第一次不带照片发朋友圈提示
	ret,x,y = findColorInTime(1000, WxUI.findSendSnsOnlyWordPrompt)
	if ret then
		tap(x,y)
	end
	
	--查找是否进入发朋友圈出始界面
	ret,x,y = findColorInTime(3000, WxUI.findSendSnsInitUI)
	if ret == false then
		return false, "Send SNS failed"
	end
	--使焦点到输入框
	tap(188,192)
	coMSleep(500)
	inputText(content)
	
	--查找发送按钮
	ret,x,y = findColorInTime(2000, WxUI.findSendSnsSendButton)
	if ret == false then
		return false, "Send SNS failed"
	end
	tap(x,y)
	
	return true, "Send SNS succeeded"
end

function WxOptions:updateNickname(name)
	wxlog:log("更改昵称为"..name)
	os.execute("am start --activity-no-history com.tencent.mm/.plugin.setting.ui.setting.SettingsModifyNameUI")
	--判断是否是更改名字页面
	ret,x,y = findColorInTime(3000, WxUI.findSettingModifyNameUI)
	if ret == false then
		return false, "Update nickname failed. WxUI.findSettingModifyNameUI failed"
	end
	
	--使焦点到输入框
	tap(648,233)
	delText(15)
	inputText(name)
	--查找保存按钮
	ret,x,y = findColorInTime(2000, WxUI.findSettingModifyNameSaveButton)
	if ret == false then
		return false, "Update nickname failed. WxUI.findSettingModifyNameSaveButton failed"
	end
	tap(x,y)
	return true, "Update nickname succeeded"
end

function WxOptions:addNearFriend()
	wxlog:log("通过附近的人添加好友")
::LabelA::
	os.execute("am start --activity-no-history com.tencent.mm/.ui.account.LoginFingerprintUI");
	coMSleep(2000)
	
	--点击发现
	x,y = findMultiColorInRegionFuzzyInTime( 0x999999, "-2|-2|0xb2b2b2,-15|-9|0x999999,7|-27|0x9a9a9a,-10|37|0xb1b1b1,-3|41|0xbababa,13|39|0xa9a9a9", 90, 0, 0, 719, 1279,3000)
	if x == -1 or y == -1 then
		return false, "Add near friend failed"
	end
	tap(x,y)
	
	--附近的人
	x,y = findMultiColorInRegionFuzzyInTime( 0xffffff, "-69|-1|0xffffff,-56|-1|0x10aeff,-41|-2|0x10aeff,-32|-11|0x10aeff,18|0|0x353535,36|-4|0x373737,54|12|0x424242,71|14|0x828282", 90, 0, 0, 719, 1279,3000)
	if x == -1 or y == -1 then
		return false, "Add near friend failed"
	end
	tap(x,y)
	
	--第一次登录微信会有提示框
	ret,x,y = findColorInTime(1000, WxUI.findNearFriendFirstPrompt)
	if ret then
		tap(x,y)
	end
	ret,x,y = findColorInTime(1000, WxUI.findNearFriendSecondPrompt)
	if ret then
		tap(139,794)
		tap(546,845)
	end
	
	--如果跳到附近打招呼的人页面
	x,y = findMultiColorInRegionFuzzyInTime( 0x2e2e32, "-38|1|0x393a3f,-50|-11|0x45464b,-56|-2|0xffffff,142|-1|0xffffff,142|13|0xffffff,178|1|0x818285,257|0|0x8a8a8d,272|17|0xffffff", 90, 0, 0, 719, 1279,3000)
	if x ~= -1 and y ~= -1 then
		tap(654,99)
		x,y = findMultiColorInRegionFuzzyInTime( 0x63759c, "-7|3|0xffffff,-33|-9|0x576b95,-161|-9|0x576b95,-157|-3|0x586c96,-314|-103|0xffffff,-419|-187|0x454545,-423|-176|0x353535", 90, 0, 0, 719, 1279,1000)
		if x ~= -1 and y ~= -1 then
			tap(x,y)
			coMSleep(500)
			goto LabelA
		end
	end
	
	--附近的人页面
	x,y = findMultiColorInRegionFuzzyInTime( 0x2e2e32, "-13|0|0x393a3f,-37|-2|0x393a3f,-53|-8|0xfefefe,33|-13|0xececec,43|-2|0xffffff,42|10|0xfdfdfe,85|-4|0xfdfdfd,121|16|0xfefefe", 90, 0, 0, 719, 1279,8000)
	if x == -1 or y == -1 then
		return false, "Add near friend failed"
	end
	
	--随机滑动,随机选中某个人9-700,153-1274
	moveTo(719,1096,719,150,math.random(10,100))
	coMSleep(2000)
	tap(math.random(9,700), math.random(253,1274))
	
	--打招呼
	ret,x,y = findColorInTime(5000, WxUI.findNearFriendSayHiButton)
	if ret == false then
		return false, "Add near friend failed"
	end
	tap(x,y)
	
	--加为朋友
	ret,x,y = findColorInTime(3000, WxUI.findNearFriendChatDialogAddToFriendButton)
	if ret then
		coMSleep(1000)
		tap(x,y)
		coMSleep(1000)
	end
	
	--输入框焦点
	x,y = findMultiColorInRegionFuzzy( 0xffffff, "-18|30|0xd3f0c8,32|31|0x49c220,99|-3|0x8f8f8f,99|0|0x7f7f7f,111|-5|0xfdfdfd,112|-10|0x7f7f7f,119|3|0x7f7f7f", 90, 0, 0, 719, 1279)
	if x == -1 or y == -1 then
		return false, "Add near friend failed"
	end
	tap(x,y)
	coMSleep(1000)
	inputText("你好~")
	ret,x,y = findColorInTime(3000, WxUI.findNearFriendChatDialogSendButton)
	if ret == false then
		return true, "Add near friend failed. WxUI.findNearFriendChatDialogSendButton failed"
	end
	tap(x,y)
	
	return true, "Add near friend succeeded"
end

function WxOptions:updateSex(sex)
	wxlog:log("更改性别为"..sex)
	os.execute("am start --activity-no-history com.tencent.mm/.plugin.setting.ui.setting.SettingsPersonalInfoUI")
	
	--性别
	x,y = findMultiColorInRegionFuzzyInTime( 0xffffff, "-42|-5|0xffffff,-72|-6|0x4e4e4e,-72|-9|0x868686,-57|-8|0x353535,-54|-7|0x4c4c4c,-57|9|0x828282,-35|-13|0xadadad,-30|-14|0x353535", 90, 0, 0, 719, 1279,5000)
	if x == -1 or y == -1 then
		return false, "Update sex failed"
	end
	tap(x,y)
	coMSleep(1000)
	if sex == "男" then
		tap(561,662)
	else
		tap(563,756)
	end
	return true, "Update sex succeeded"
end

function WxOptions:randomSendMsg(message)
	wxlog:log("随机给好友发消息")
	os.execute("am start --activity-no-history com.tencent.mm/.ui.account.LoginFingerprintUI");
	coMSleep(2000)
	tap(263,1224)	--点击通讯录
	coMSleep(500)
	
::randomSendMsgLabelA::
	moveTo(719,150,719,1279,500) -- 滑到顶端
	coMSleep(500)
	--随机滑动
	moveTo(719,1096,719,150,math.random(10,100))
	
	local isEnd = false
	local randx1, randy1, randx2, randy2
	randx1 = 50
	randy1 = 147
	randx2 = 663
	randy2 = 1105

	ret,x,y = WxUI:findContactUIMpIteam()
	if ret then
		randy1 = y + 44
	end
	
	repeat
		x = math.random(randx1, randx2)
		y = math.random(randy1, randy2)
		if isColor( x, y, 0xffffff) then
			isEnd = true
		end
	until (isEnd)
	tap(x,y)
	coMSleep(2000)
	
	--如果是微信团队
	x,y = findMultiColorInRegionFuzzy( 0xffffff, "-10|-12|0x00d000,-14|-16|0x00cc09,17|-42|0x00d30c,26|51|0x00ba09,115|-12|0x747474,123|-17|0x4a4a4a", 90, 0, 0, 719, 1279)
	if x ~= -1 or y ~= -1 then
		os.execute("input keyevent 4")
		coMSleep(1000)
		goto randomSendMsgLabelA
	end
	
	ret,x,y = WxUI:findDetailInfoSendMsgButton()
	if ret == false then
		return false, "Send random message failed"
	end
	tap(x,y)
	
	return self:sendMsgCommon(message)
end

function WxOptions:randomSendSNS()
	wxlog:log("随机发朋友圈")
	if not isFileExist("/mnt/sdcard/TouchSprite/res/sns_msg.txt") then 
		return false, "/mnt/sdcard/TouchSprite/res/sns_msg.txt文件不存在"
	end
	
	local tblSnsMsg
	tblSnsMsg = readFile("/mnt/sdcard/TouchSprite/res/sns_msg.txt")
	if #tblSnsMsg == 0 then
		return false, "文件读取有误"
	end
	
	return self:sendSNS(tblSnsMsg[math.random(#tblSnsMsg)])
end

function WxOptions:register(nick, country_code, phone_num, password)
	os.execute("am start --activity-no-history com.tencent.mm/.ui.account.RegByMobileRegAIOUI")
	x,y = findMultiColorInRegionFuzzyInTime( 0x989898, "8|0|0x848484,32|0|0x595959,37|6|0x989898,42|5|0x808080,50|-106|0x393a3f,52|-122|0x2e2e32", 90, 0, 0, 719, 1279, 5000)
	if x == -1 or y == -1 then
		return false, "Can't get the activity"
	end
	
	--焦点到昵称输入框
	tap(236,250)
	inputText(nick)
	coMSleep(500)
	
	--焦点到区号输入框
	tap(133,447)
	delText(3)
	coMSleep(1000)
	inputText(country_code)
	coMSleep(500)
	
	--焦点到电话号码输入框
	tap(246,447)
	--inputText(phone_num)	--会有问题
	os.execute("input text "..phone_num)
	coMSleep(3000)
	
	--焦点到密码输入框
	tap(231,540)
	inputText(password)
	coMSleep(1300)
	
	--点击注册按钮
	x,y = findMultiColorInRegionFuzzy( 0x45c01a, "-315|-18|0x45c01a,-324|53|0x45c01a,303|-14|0x45c01a,301|51|0x45c01a,11|15|0xace399", 90, 0, 0, 719, 1279)
	if x == -1 or y == -1 then
		return false, "Register failed"
	end
	tap(x,y)
	
	--确认手机号码提示框弹出
	x,y = findMultiColorInRegionFuzzyInTime( 0x7f8eae, "-22|-10|0x6e80a3,-135|-11|0xb7c0d2,-152|-5|0xdfe2ea,-119|10|0x576b95,-411|-254|0x5c5c5c,-377|-245|0x6c6c6c", 90, 0, 0, 719, 1279, 10000)
	if x == -1 or y == -1 then
		return false, "Register failed"
	end
	tap(x,y)	--点击确定
	
	--填写验证码界面
	x,y = findMultiColorInRegionFuzzyInTime( 0x2e2e32, "-48|-8|0x5f6064,48|-9|0x86878a,71|-3|0x8e8f92,83|1|0xddddde,122|-6|0xa9a9ac,157|-7|0x9f9fa1,181|21|0xa0a1a3,191|535|0xa2e08d", 90, 0, 0, 719, 1279, 35000)
	if x == -1 or y == -1 then
		return false, "Register failed"
	end
	
	--获取验证码并输入验证码
	
	--进入查找朋友界面
	x,y = findMultiColorInRegionFuzzyInTime( 0x576b95, "-45|-13|0xc7cddc,47|-12|0xb7c0d2,45|0|0x7a8aab,106|101|0x44b91b,152|84|0x69c54a,-278|-294|0x929292,-137|132|0xf3f3f3", 90, 0, 0, 719, 1279,60000)
	if x == -1 or y == -1 then
		return false, "Register failed"
	end
	tap(x,y)
	
	--上传通讯录页面，点击以后再说
	coMSleep(1000)
	tap(363,1202)
	
	--进入主机面，点击下通讯录，停3秒
	x,y = findMultiColorInRegionFuzzyInTime( 0xfcfcfc, "20|-11|0x45c01a,24|-26|0x45c01a,24|-33|0xfcfcfc,21|10|0xfcfcfc,16|5|0x45c01a,28|19|0xfcfcfc,50|19|0xfcfcfc,41|32|0x45c01a", 90, 0, 0, 719, 1279, 10000)
	if x ~= -1 and y ~= -1 then
		for var = 1, 20 do
			coMSleep(500)
			tap(263,1222)
			x,y = findMultiColorInRegionFuzzy( 0x45c01a, "-14|-6|0xfcfcfc,20|-18|0xd0eec5,-15|27|0x60c93c,-14|29|0x46c01b,-4|36|0x47c11d,24|32|0x59c732,6|18|0xfcfcfc", 90, 0, 0, 719, 1279)
			if x ~= -1 and y ~= -1 then
				break
			end
		end
		coMSleep(3000)
	end
	wxLogin = wxLogin or WxLogin:new()
	wxLogin.isLogined = true
	wxLogin.strUsr = phone_num
	wxLogin.strPwd = password
	
	return true, "Register succeeded"
end

function WxOptions:setAlias(alias)
	--打开设置微信号界面
	os.execute("am start --activity-no-history com.tencent.mm/.plugin.setting.ui.setting.SettingsAliasUI")
	x,y = findMultiColorInRegionFuzzyInTime( 0x2e2e32, "-58|-9|0xd8d8d9,-46|11|0x606165,-29|11|0x393a3f,525|-4|0x3f7d2d,67|-9|0x7d7d81,109|-6|0x393a3f,179|-5|0xd1d1d2,156|-19|0x505156", 90, 0, 0, 719, 1279, 2000)
	if x == -1 or y == -1 then
		return false, "Set alias failed"
	end

	--输入微信号,点击保存
	inputText(alias)
	coMSleep(1000)
	x,y = findMultiColorInRegionFuzzyInTime( 0x46c01b, "-17|-5|0xccedc0,-41|-13|0x45c01a,33|29|0x45c01a,-562|1|0x2e2e32,-579|-9|0x393a3f", 90, 0, 0, 719, 1279, 2000)
	if x == -1 or y == -1 then
		return false, "Set alias failed"
	end
	tap(x,y)
	
	--点击弹出框的确定
	x,y = findMultiColorInRegionFuzzyInTime( 0x909db8, "-26|-10|0x6e80a3,-151|-5|0x8897b4,-119|-11|0xb8c0d2,-112|-5|0xb7c0d2,12|-10|0xb7c0d2,20|2|0xa3aec5", 90, 0, 0, 719, 1279, 3000)
	if x == -1 or y == -1 then
		return false, "Set alias failed"
	end
	tap(x,y)
	wxLogin.strCurUsr = alias
	coMSleep(6000)
	return true, "Set alias succeeded"
end

function WxOptions:clearCache()
	os.execute("rm -fr /data/data/com.tencent.mm/*")
	coMSleep(500)
	return true, "Clear cache succeeded"
end

function WxOptions:saveCache()
	--用lua的io库判断/data目录下文件存不存在会有权限限制
	--然而保存缓存到sdcard时权限会发生变化
	--为了不使权限发生变化且能够判断文件存在，
	--所以把缓存文件复制到/data目录下并同时在sdcard下建立同样的文件夹
	--这样只要判断sdcard下的文件夹是否存在就行
	
	local cache_file = "/data/mpsp/com.tencent.mm/"..wxLogin.strCurUsr
	local sdcard_cache_dir = "/sdcard/mpsp/com.tencent.mm/"..wxLogin.strCurUsr
	
	coMSleep(8000)
	
	os.execute("rm -fr "..cache_file)
	os.execute("mkdir -p "..cache_file)
	os.execute("cp -a /data/data/com.tencent.mm/* "..cache_file)
	os.execute("mkdir -p "..sdcard_cache_dir)
	coMSleep(2000)
	toast("Save cache succeeded")
	return true, "Save cache succeeded"
end

function WxOptions:setAutoDownloadWxApk(t)
	--1 仅Wi-Fi网络
	--2 从不
	
	--设置->通用
	os.execute("am start --activity-no-history com.tencent.mm/.plugin.setting.ui.setting.SettingsAboutSystemUI");
	
	--自动下载微信安装包
	ret,x,y = findColorInTime(5000, WxUI.findSettingAutoDownloadApk)
	if ret == false then
		return false, "Set auto download apk failed"
	end
	tap(x,y)
	
	coMSleep(2000)
	if t == "1" then
		tap(250,632)
	elseif t == "2" then
		tap(213,727)
	end

	return true, "Set auto download apk succeeded"
end

function WxOptions:openUrlByWx(url)
	--通过微信自带浏览器打开URL
	os.execute("am start -n com.tencent.mm/.plugin.webview.ui.tools.WebViewUI -d '"..url.."'")
	return true, "Ok"
end

function WxOptions:setArea()
	wxlog:log("更改地区")
	os.execute("am start --activity-no-history com.tencent.mm/.plugin.setting.ui.setting.SettingsPersonalInfoUI")

	ret,x,y = findColorInTime(3000, WxUI.findSettingSetArea)
	if ret == false then
		return false, "Set area failed. WxUI.findSettingSetArea failed"
	end
	mSleep(500)
	tap(x+100,y)
	mSleep(4000)
	tap(229,285)
	return true, "Set area succeeded"
end

function WxOptions:doTask(data)
	local cmd = data[1]
	local ret, msg
	local index = 1
	
	wxlog = wxlog or Log:new("weixin")
	if cmd == CMD_WX_LOGIN then
		ret, msg = self:login(data[2], data[3], data[4])
	elseif cmd == CMD_WX_REGISTER then
		closeApp("com.tencent.mm")
		os.execute("rm -fr /data/data/com.tencent.mm/*")
		ret, msg = self:register(data[2], data[3], data[4], data[5])
	else
		repeat
			if wxLogin == nil or wxLogin.isLogined == false then
				ret, msg = false, "not login!"
				break
			end
			
			if cmd == CMD_WX_LOGOUT then
				ret, msg = self:logout()
--			elseif cmd == CMD_WX_CHANG_USR then 
--				ret, msg = self:changeUsr(data[2], data[3])
			elseif cmd == CMD_WX_ADD_FRIEND then 
				ret, msg = self:addFriend(data[2])
			elseif cmd == CMD_WX_CREATE_GROUP then
				ret, msg = self:createGroup(data[2], data[3])
			elseif cmd == CMD_WX_SEND_MSG then
				ret, msg = self:sendMsg(data[2], data[3])
			elseif cmd == CMD_WX_SEND_GROUP_MSG then
				ret, msg = self:sendGroupMsg(data[2], data[3])
			elseif cmd == CMD_WX_ADD_MP then
				ret, msg = self:addMP(data[2])
			elseif cmd == CMD_WX_COMMENT_SNS then
				ret, msg = self:commentSNS(data[2], data[3])
			elseif cmd == CMD_WX_UPVOTE_SNS then
				ret, msg = self:upvoteSNS(data[2])
			elseif cmd == CMD_WX_VOTE then
				ret, msg = self:vote()
			elseif cmd == CMD_WX_SEND_SNS then
				ret, msg = self:sendSNS(data[2])
			elseif cmd == CMD_WX_UPDATE_NICKNAME then
				ret, msg = self:updateNickname(data[2])
			elseif cmd == CMD_WX_ADD_NEAR_FRIEND then
				ret, msg = self:addNearFriend()
			elseif cmd == CMD_WX_UPDATE_SEX then
				ret, msg = self:updateSex(data[2])
			elseif cmd == CMD_WX_RANDOM_SEND_MSG then
				ret, msg = self:randomSendMsg(data[2])
			elseif cmd == CMD_WX_RANDOM_SEND_SNS then
				ret, msg = self:randomSendSNS()
			elseif cmd == CMD_WX_CLEAR_MSG_RECORD then
				ret, msg = self:clearRecorder(data[2])
			elseif cmd == CMD_WX_SET_ALIAS then
				ret, msg = self:setAlias(data[2])
			elseif cmd == CMD_WX_SAVE_CACHE then
				ret, msg = self:saveCache()
			elseif cmd == CMD_WX_CLEAR_CACHE then
				ret, msg = self:clearCache()
			elseif cmd == CMD_WX_SET_AUTO_DOWNLOAD_APK then
				ret, msg = self:setAutoDownloadWxApk(data[2])
			elseif cmd == CMD_WX_OPEN_URL_BY_WX then
				ret, msg = self:openUrlByWx(data[2])
			elseif cmd == CMD_WX_SET_AREA then
				ret, msg = self:setArea()
			end
		until (true)
	end
	
	ret = ret and 0 or -1
	local pic_name
	local tbl_response 
	--如果执行失败保存当前页面截图
	if ret == -1 then
		pic_name = saveSnapshot()
		tbl_response = {
			["result"]=ret,
			["message"]=msg,
			["cmd"]=cmd,
			["snapshot"]=pic_name --base64_encode_file(pic_name)
		}
	else
		tbl_response = {
			["result"]=ret
		}
	end
	
	wxlog:close()
	wxlog = nil
	return ret, tbl_response
end
