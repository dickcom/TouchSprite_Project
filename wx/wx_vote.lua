function wx_vote()
    --点击url
	coMSleep(2000)
	tap(468,272)

	coMSleep(8000)
	x,y = findMultiColorInRegionFuzzy( 0xffffff, "59|-1|0x2ab098,97|-2|0x2ab098,-355|-86|0x44b6c9,-140|-81|0xf59f46,72|-81|0xff4b3f", 90, 0, 0, 719, 1279)
	if x == -1 or y == -1 then
		return false, "长时间未打开投票链接"
	end
    
    tap(x, y)
    coMSleep(1000)
    inputText("肖璟瑜")
	coMSleep(1000)
    
    --查找搜索按钮
    x,y = findMultiColorInRegionFuzzy( 0x2ab098, "-8|-5|0x78cdbe,-12|-4|0xffffff,-59|-26|0x2ab098,-54|31|0x006666,58|31|0x006666,57|-21|0x2ab098,18|9|0xc9ebe5", 90, 0, 0, 719, 1279)
    if x == -1 or y == -1 then
		return false, "投票失败"
	end
    
    tap(x, y)
    coMSleep(3000)
    
    moveTo(719,1279,719,150,6)	--下拉滑动
    x,y = findMultiColorInRegionFuzzy( 0xff4b3f, "-135|-8|0xff4b3f,115|-9|0xff4b3f,-61|-91|0x6b6b6b,-56|-92|0x333333,-40|-89|0x424242,-29|-90|0x333333,-7|-93|0x595959", 90, 0, 0, 719, 1279)
    if x == -1 or y == -1 then
		return false, "投票失败"
	end
    
    return true, "投票成功"
end

return wx_vote