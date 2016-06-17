WxUI = {}

function WxUI:findUsrLoginUI()
	local x,y
	x,y = findMultiColorInRegionFuzzy( 0x6f6f6f, "-1|1|0x353535,120|15|0xdddddd,131|60|0xd3f0c8,151|227|0xa2e08d,226|253|0xcdefc2,328|362|0x576b95", 90, 0, 0, 719, 1279)
	if x ~= -1 and y ~= -1 then return true,x,y end
	
	x,y = findMultiColorInRegionFuzzy( 0xdcdcdc, "8|4|0x555555,21|7|0xadadad,69|-3|0x6d6d6d,71|5|0x545454,20|-110|0xcfcfd1,53|-94|0x2e2e32,88|-125|0x7c7c80,133|-113|0xbbbbbd", 90, 0, 0, 719, 1279)
	if x ~= -1 and y ~= -1 then return true,x,y end
	
	return false,-1,-1
end

function WxUI:findLoginFingerprintUI()
	x,y = findMultiColorInRegionFuzzy( 0xfcfcfc, "20|-11|0x45c01a,24|-26|0x45c01a,24|-33|0xfcfcfc,21|10|0xfcfcfc,16|5|0x45c01a,28|19|0xfcfcfc,50|19|0xfcfcfc,41|32|0x45c01a", 90, 0, 0, 719, 1279)
	if x ~= -1 and y ~= -1 then return true,x,y end
	
	return false,-1,-1
end

function WxUI:findFirstLoginPrompt()
	local x,y
	x,y = findMultiColorInRegionFuzzy( 0x576b95, "119|-5|0x576b95,-283|-171|0x6d6d6d,-286|-164|0x353535,-255|-165|0x383838,-246|-160|0x353535,-249|-112|0x353535", 90, 0, 0, 719, 1279)
	if x ~= -1 and y ~= -1 then return true,x,y end
	
	x,y = findMultiColorInRegionFuzzy( 0x686868, "20|8|0x626262,56|8|0x464646,66|16|0x6b6b6b,15|79|0x464646,68|86|0x6f6f6f,121|157|0xababab,223|124|0x848484,356|93|0xadadad", 90, 0, 0, 719, 1279)
	if x ~= -1 and y ~= -1 then return true,x,y end
	
	return false,-1,-1
end

function WxUI:findIllegalAccount()
	local x,y
	x,y = findMultiColorInRegionFuzzy( 0x576b95, "-98|-6|0x576b95,-205|-73|0x383838,-155|-74|0x646464,-181|-113|0x353535,-231|-161|0x6d6d6d", 90, 0, 0, 719, 1279)
	if x ~= -1 and y ~= -1 then return true,x,y end
	
	x,y = findMultiColorInRegionFuzzy( 0x7485a7, "14|6|0x576b95,-391|-236|0x696969,-358|-232|0x7a7a7a,-354|-231|0x3f3f3f,-201|-234|0x464646,-191|-231|0x959595,73|-219|0x4f4f4f", 90, 0, 0, 719, 1279)
	if x ~= -1 and y ~= -1 then return true,x,y end
	
	x,y = findMultiColorInRegionFuzzy( 0x909db8, "-132|-11|0xb7c0d2,-412|-207|0xadadad,-213|-202|0x777777,-187|-201|0x838383,-149|-207|0xc3c3c3,-120|-203|0x6f6f6f,-34|-206|0x5a5a5a", 90, 0, 0, 719, 1279)
	if x ~= -1 and y ~= -1 then return true,x,y end
	
	return false,-1,-1
end

function WxUI:findUsrPwdWrong()
	local x,y
	x,y = findMultiColorInRegionFuzzy( 0x576b95, "0|-1|0x6c7ea2,14|9|0x576b95,38|6|0x5a6d97,-62|7|0xffffff,-328|-158|0x6e6e6e,-326|-164|0x353535,-324|-168|0x6f6f6f,-310|-177|0xa5a5a5", 90, 0, 0, 719, 1279)
	if x ~= -1 and y ~= -1 then return true,x,y end
	
	x,y = findMultiColorInRegionFuzzy( 0x96a2bc, "0|-2|0x99a4be,23|0|0x5a6d97,-405|-96|0x363636,-405|-87|0x848484,-365|-94|0x989898,-358|-73|0x595959,-294|-86|0x404040", 90, 0, 0, 719, 1279)
	if x ~= -1 and y ~= -1 then return true,x,y end
	
	return false,-1,-1
end

function WxUI:findAccountNotLoginForLongTime()
	local x,y
	x,y = findMultiColorInRegionFuzzy( 0x576b95, "-408|-212|0x8d8d8d,-407|-208|0x363636,-393|-130|0x6d6d6d,-341|-164|0x616161,-279|-169|0x6f6f6f,-242|-170|0x373737", 90, 0, 0, 719, 1279)
	if x ~= -1 and y ~= -1 then return true,x,y end
	
	return false,-1,-1
end

function WxUI:findNeedPhoneVerify()
	local x,y
	x,y = findMultiColorInRegionFuzzy( 0x45c01a, "-150|-1|0x45c01a,8|61|0x45c01a,-60|109|0xf1f1f1,81|-207|0xf86161,-31|-202|0x646464,-2|-76|0x999999", 90, 0, 0, 719, 1279)
	if x ~= -1 and y ~= -1 then return true,x,y end
	
	return false,-1,-1
end

function WxUI:findNeedFriendVerify()
	local x,y
	x,y = findMultiColorInRegionFuzzy( 0x576b95, "-16|-7|0x7283a6,-139|-7|0x576b95,-254|-71|0xffffff,-296|-91|0xffffff,-142|-127|0x5d5d5d,-216|-141|0x656565,-213|-135|0x5d5d5d", 90, 0, 0, 719, 1279)
	if x ~= -1 and y ~= -1 then return true,x,y end
	
	return false,-1,-1
end

function WxUI:findNeedInputVerify()
	local x,y
	x,y = findMultiColorInRegionFuzzy( 0x576b95, "-374|-62|0x49c220,12|-62|0x47c11d,-409|-383|0x353535,-410|-370|0xbdbdbd,-390|-384|0x353535", 90, 0, 0, 719, 1279)
	if x ~= -1 and y ~= -1 then return true,x,y end
	
	return false,-1,-1
end

function WxUI:findSettingAutoDownloadApk()
	local x,y
	x,y = findMultiColorInRegionFuzzy( 0x989898, "25|-6|0x818181,63|-6|0xa1a1a1,88|-3|0x6d6d6d,124|2|0x585858,162|0|0x555555,194|4|0x959595,218|5|0x828282,245|4|0x828282", 90, 0, 0, 719, 1279)
	if x ~= -1 and y ~= -1 then return true,x,y end
	
	x,y = findMultiColorInRegionFuzzy( 0xc3c3c3, "30|7|0x373737,46|2|0x919191,69|1|0xa0a0a0,114|11|0x4a4a4a,138|10|0x6c6c6c,168|10|0x848484,204|11|0x909090,60|-393|0x2e2e32", 90, 0, 0, 719, 1279)
	if x ~= -1 and y ~= -1 then return true,x,y end
	
	return false,-1,-1
end

function WxUI:findSettingSetArea()
	local x,y
	x,y = findMultiColorInRegionFuzzy( 0x555555, "7|1|0x848484,9|1|0x545454,30|-6|0x585858,30|-4|0x545454,36|18|0x848484,35|12|0x999999,43|9|0x6d6d6d,53|-5|0x6c6c6c", 90, 0, 0, 719, 1279)
	if x ~= -1 and y ~= -1 then return true,x,y end
	
	return false,-1,-1
end

function WxUI:findSettingModifyNameUI()
	local x,y
	x,y = findMultiColorInRegionFuzzy( 0xcfcfd1, "13|1|0x393a3f,33|3|0x2e2e32,68|-11|0xddddde,101|-13|0x818285,119|-9|0x8f9092,153|-12|0x848588,178|-9|0xc7c8c9,178|4|0x9e9ea1", 90, 0, 0, 719, 1279)
	if x ~= -1 and y ~= -1 then return true,x,y end
	
	return false,-1,-1
end

function WxUI:findSettingModifyNameSaveButton()
	local x,y
	x,y = findMultiColorInRegionFuzzy( 0x1aad19, "-23|-7|0x179e16,-29|28|0x1aad19,-28|51|0x179e16,74|51|0x179e16,71|21|0x1aad19,71|-7|0x179e16", 90, 0, 0, 719, 1279)
	if x ~= -1 and y ~= -1 then return true,x,y end
	
	return false,-1,-1
end

function WxUI:findSendSnsOnlyWordPrompt()
	local x,y
	x,y = findMultiColorInRegionFuzzy( 0xaae1aa, "5|-1|0x5ec65d,13|7|0xc0e8c0,41|2|0xb3e4b3,55|0|0x72cd71,71|10|0xc7ebc7,85|4|0x85d485,92|4|0x85d485,120|-1|0x8fd78f", 90, 0, 0, 719, 1279)
	if x ~= -1 and y ~= -1 then return true,x,y end
	
	return false,-1,-1
end

function WxUI:findSendSnsInitUI()
	local x,y
	x,y = findMultiColorInRegionFuzzy( 0x838383, "42|-2|0x848484,74|-3|0x8d8d8d,100|-3|0x585858,-11|-276|0x2e2e32,500|-280|0x2c6830,524|-278|0x487c4c,548|-277|0x3d7441", 90, 0, 0, 719, 1279)
	if x ~= -1 and y ~= -1 then return true,x,y end
	
	x,y = findMultiColorInRegionFuzzy( 0x3f7d2d, "-36|-2|0x3f7d2d,-36|34|0x3f7d2d,34|35|0x3f7d2d,-130|20|0x393a3f", 90, 0, 0, 719, 1279)
	if x ~= -1 and y ~= -1 then return true,x,y end
	
	return false,-1,-1
end

function WxUI:findSendSnsSendButton()
	local x,y
	x,y = findMultiColorInRegionFuzzy( 0x81d280, "-10|-6|0x98da97,9|-2|0x83d383,23|-2|0x91d890,-39|-27|0x179e16,-536|11|0x2e2e32,-568|3|0xcfcfd1,-558|3|0x393a3f", 90, 0, 0, 719, 1279)
	if x ~= -1 and y ~= -1 then return true,x,y end
	
	x,y = findMultiColorInRegionFuzzy( 0x45c01a, "-10|-3|0xf9fdf8,-13|-8|0xfefffd,-26|-12|0x45c01a,-27|-24|0x45c01a,41|-21|0x45c01a,40|21|0x45c01a,-31|24|0x45c01a", 90, 0, 0, 719, 1279)
	if x ~= -1 and y ~= -1 then return true,x,y end
	
	return false,-1,-1
end

function WxUI:findChatDialogInit()
	local x,y
	x,y = findMultiColorInRegionFuzzy( 0xfefefe, "-206|-32|0xfefefe,-236|-48|0xc0c0c0,80|-48|0xc0c0c0,49|-14|0xcfcfcf,54|-4|0x7f7f7f,63|10|0x7f7f7f,63|6|0xa0a0a0", 90, 0, 0, 719, 1279)
	if x ~= -1 and y ~= -1 then return true,x,y end
	
	x,y = findMultiColorInRegionFuzzy( 0xffffff, "67|-7|0x999999,69|-11|0x888888,82|-21|0xaeaeae,78|-13|0xfefefe,77|-7|0xb7b7b7,80|2|0xa0a0a0,94|2|0xa0a0a0,91|7|0x7f7f7f", 90, 0, 0, 719, 1279)
	if x ~= -1 and y ~= -1 then return true,x,y end
	
	return false,-1,-1	
end

function WxUI:findChatDialogSendButton()
	local x,y
	x,y = findMultiColorInRegionFuzzy( 0x85d485, "-3|-9|0x75ce75,23|-2|0x70cc6f,33|4|0x74ce73,30|13|0xc0e8c0,-24|-28|0x179e16,-19|18|0x1aad19,47|22|0x1aad19", 90, 0, 0, 719, 1279)
	if x ~= -1 and y ~= -1 then return true,x,y end
	
	x,y = findMultiColorInRegionFuzzy( 0x45c01a, "-22|-3|0xf8fdf7,-8|2|0xd1efc5,16|2|0xffffff,10|9|0xffffff,-35|-20|0x45c01a,33|-19|0x45c01a,-35|21|0x45c01a,30|23|0x45c01a", 90, 0, 0, 719, 1279)
	if x ~= -1 and y ~= -1 then return true,x,y end
	
	return false,-1,-1	
end

function WxUI:findAddMpAddButton()
	local x,y
	x,y = findMultiColorInRegionFuzzy( 0x57c356, "37|0|0xa0dd9f,37|11|0xbce7bc,54|24|0x6ecb6d,5|19|0x9fdd9e,-304|-15|0x1aad19,335|-32|0x1aad19", 90, 0, 0, 719, 1279)
	if x ~= -1 and y ~= -1 then return true,x,y end
	
	x,y = findMultiColorInRegionFuzzy( 0x45c01a, "-17|-3|0xffffff,-18|-8|0x45c01a,-24|-10|0xfefffe,-10|-10|0xffffff,23|-4|0xfefffe,23|18|0xffffff,-299|-26|0x45c01a,306|-30|0x45c01a", 90, 0, 0, 719, 1279)
	if x ~= -1 and y ~= -1 then return true,x,y end
	
	return false,-1,-1	
end

function WxUI:findAddMpEnterButton()
	local x,y
	x,y = findMultiColorInRegionFuzzy( 0x7dd07c, "9|9|0xb6e5b6,47|19|0xa5dfa5,73|22|0x88d488,103|8|0x88d588,136|2|0x5dc55d,-244|-24|0x1aad19,399|-29|0x1aad19", 90, 0, 0, 719, 1279)
	if x ~= -1 and y ~= -1 then return true,x,y end
	
	x,y = findMultiColorInRegionFuzzy( 0x45c01a, "-23|4|0xffffff,-22|2|0xc3eab6,34|0|0xaae296,35|1|0xffffff,42|-11|0x82d565,24|14|0x47c01c,24|15|0xb8e7a8,80|15|0xc9edbd,88|9|0xffffff", 90, 0, 0, 719, 1279)
	if x ~= -1 and y ~= -1 then return true,x,y end
	
	return false,-1,-1		
end

function WxUI:findNearFriendFirstPrompt()
	local x,y
	x,y = findMultiColorInRegionFuzzy( 0xcbecca, "32|5|0x97d996,48|10|0x97d996,73|14|0x88d488,109|9|0x8ad58a,-270|-25|0x1aad19,366|-23|0x1aad19", 90, 0, 0, 719, 1279)
	if x ~= -1 and y ~= -1 then return true,x,y end
	
	x,y = findMultiColorInRegionFuzzy( 0xffffff, "-69|-1|0xffffff,-56|-1|0x10aeff,-41|-2|0x10aeff,-32|-11|0x10aeff,18|0|0x353535,36|-4|0x373737,54|12|0x424242,71|14|0x828282", 90, 0, 0, 719, 1279)
	if x ~= -1 and y ~= -1 then return true,x,y end
	
	return false,-1,-1	
end

function WxUI:findNearFriendSecondPrompt()
	local x,y
	x,y = findMultiColorInRegionFuzzy( 0x686868, "16|0|0x686868,51|8|0x626262,11|82|0xbcbcbc,42|82|0xb8b8b8,64|78|0xbbbbbb,83|86|0x484848,76|135|0x5e5e5e", 90, 0, 0, 719, 1279)
	if x ~= -1 and y ~= -1 then return true,x,y end
	
	x,y = findMultiColorInRegionFuzzy( 0x919eb9, "-122|7|0xc6ccdb,-386|-53|0xaaaaaa,-364|-63|0x383838,-357|-63|0x353535,-361|-51|0x474747,-394|-358|0xb4b4b4", 90, 0, 0, 719, 1279)
	if x ~= -1 and y ~= -1 then return true,x,y end
	
	return false,-1,-1	
end

function WxUI:findNearFriendSayHiButton()
	local x,y
	x,y = findMultiColorInRegionFuzzy( 0x1aad19, "-108|-26|0x2fa72e,-105|69|0x179e16,541|68|0x179e16,545|-26|0x1a9f19,540|29|0x1aad19", 90, 0, 0, 719, 1279)
	if x ~= -1 and y ~= -1 then return true,x,y end
	
	return false,-1,-1	
end

function WxUI:findNearFriendChatDialogAddToFriendButton()
	local x,y
	x,y = findMultiColorInRegionFuzzy( 0x1aad19, "4|-10|0x1b9f1a,4|48|0x179e16,143|48|0x179e16,142|-10|0x1b9f1a,133|16|0x1aad19", 90, 0, 0, 719, 1279)
	if x ~= -1 and y ~= -1 then return true,x,y end
	
	return false,-1,-1	
end

function WxUI:findNearFriendChatDialogSendButton()
	local x,y
	x,y = findMultiColorInRegionFuzzy( 0x1aad19, "-10|-6|0x179e16,-15|4|0x179e16,-7|56|0x179e16,61|55|0x179e16,71|32|0x179e16,60|13|0x1aad19,-7|9|0x1aad19", 90, 0, 0, 719, 1279)
	if x ~= -1 and y ~= -1 then return true,x,y end
	
	return false,-1,-1	
end

function WxUI:findContactUIMpIteam()
	local x,y
	x,y = findMultiColorInRegionFuzzy( 0x2782d7, "14|-15|0x6aa8e3,29|0|0x6caae3,39|0|0x5da0e1,94|-15|0xb3b3b3,123|-1|0xaeaeae,135|-2|0x989898", 90, 0, 0, 719, 1279)
	if x ~= -1 and y ~= -1 then return true,x,y end
	
	return false,-1,-1	
end

function WxUI:findDetailInfoSendMsgButton()
	local x,y
	x,y = findMultiColorInRegionFuzzy( 0x1aad19, "-315|-19|0x179e16,-308|9|0x1aad19,-308|75|0x179e16,309|75|0x179e16,311|23|0x1aad19,311|-19|0x179e16", 90, 0, 0, 719, 1279)
	if x ~= -1 and y ~= -1 then return true,x,y end
	
	return false,-1,-1	
end
