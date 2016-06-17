package.path = "/mnt/sdcard/TouchSprite/lua/common/?.lua;/mnt/sdcard/TouchSprite/lua/wx/?.lua;"..package.path
require("wx.WxOptions")
require("wx.login")
require("common.ProtocolDefine")
require("common.GlobalTask")
require("json")
server = nil

function dispatchTask(data)
	local ret, result
	local cmd = data[1]
	
	--取高四位确定哪个应用
	local high = string.sub(cmd, 1, 4)
	
	--全局命令
	if high == "9000" then
		gTask = gTask or GlobalTask:new()
		ret, result = gTask:doTask(data)
	end
	
	--微信应用
	if high == "0000" then
		wxOpt = wxOpt or WxOptions:new()
		ret, result = wxOpt:doTask(data) 
	end
	
	return ret, result
end

function receiveCommon(clientFd)
	clientFd:settimeout(3)
	--先接受长度
	local dataA, status, dataB = clientFd:receive(4)

	--最后接收消息体
	if status~="closed" then
		dataA, status, dataB = clientFd:receive(tonumber(dataA))
	end

	return dataA, status, dataB
end

function doReceive(reads, clientFd)
	local cfd = clientFd
	local dataA, status, dataB = receiveCommon(cfd)
	local reg, result
	
	--根据消息分发任务
	if status~="closed" then
		local jsdata = json.decode(dataA)
		local var
		for var = 1, #jsdata do
			ret, result = dispatchTask(jsdata[var])
			if ret == -1 then
				break
			end
		end
		local str_response = json.encode(result)
		str_response = string.format("%04d%s", string.len(str_response), str_response)
		clientFd:send(str_response)
	else
		for k1,v1 in ipairs(reads) do
			if v1 == cfd then	
				table.remove(reads, k1)
				break
			end
		end
		cfd:close()
	end
end

function listenTask()
	local socket = require ("socket")
	server = assert(socket.bind("*", 9527))
	local reads = {}
	table.insert(reads,server)
	toast("等待任务中...")

	while true do
		local ready = socket.select(reads, nil, 3)

		for k,v in ipairs(ready) do
			if v == server then
--				toast("有客户端上线...")
				local client = v:accept()
				table.insert(reads, client)
			else
				doReceive(reads, v)
			end
		end
	end	
end

function doTask()
	local jsdata = readFileString(getPath().."/res/task_cmd.json")
	local tb_data = json.decode(dataA)
	local task_id = tb_data["task_id"]
	local guid = readFileString(getPath().."/res/guid.txt")
	local var
	local ret, result
	local str_post
	
	tb_data = tb_data["cmd"]
	for var = 1, #tb_data do
		ret, result = dispatchTask(tb_data[var]["op"])
		if ret == -1 then
			break
		end
	end
	result["task_id"] = task_id
	result["guid"] = guid
	str_post = json.encode(result)
	postHttp("http://ip:3002/task_status", str_post)
end

function checkAbnormalActivity()
	--该函数属于主程序, 禁止调用coroutine.yield()和扩展的coMSleep()
	local ta = getTopActivity()
	-- 微信升级弹框
	if ta == "com.tencent.mm/.sandbox.updater.AppUpdaterUI" then
		mSleep(1000)
		os.execute("input keyevent 4") --返回键
		mSleep(1000)
	end
end

function main()
	init(0)
	co_listen = coroutine.create(function()
		listenTask()
	end)

	--程序中对coMSleep函数进行修改，每次执行coMSleep后进行一次调度来检查弹框等信息
	while true do
		if coroutine.status(co_listen) == "dead" then
			break
		end
		coroutine.resume(co_listen)
		checkAbnormalActivity()
	end
end

main()