GlobalTask = {}
GlobalTask.__index = GlobalTask

function GlobalTask:new()
	local self = {}     
	setmetatable(self, GlobalTask)
	return self  
end

function GlobalTask:doLuaExit()
	if server ~= nil then
		server:close() 
	end
	lua_exit()
	return true, "ok"
end

function GlobalTask:resetImei(imei)
	local file = io.open(getPath().."/res/imei.txt", "wb")
	if file then
		file:write(imei)
		file:close()
	else
		return false, "open imei file failed";
	end
	return true, "Reset imei succeeded"
end

--function GlobalTask:doUploadFile(data)
--	--上传文件
--	--data[2]:上传文件源路径全名
--	--data[3]:上传文件目的路径全名
--	--data[4]:上传文件大小
--	cfd:settimeout(3)
--	local dataA, status, dataB = cfd:receive(data[4])
--	local file
	
--	if status ~= "closed" then
--		os.execute("mkdir -p "..string.match(data[3], "(.+)/[^/]*%.%w+$").."/")
--		file = io.open(data[3], "wb")
--        if file then
--            file:write(dataA)
--            file:close()
--            return true, "ok";
--        else
--            return false, "open file failed";
--        end
--	end
--	return true, "ok"
--end

function GlobalTask:doDownloadFile(data)
	-- 下载文件
	-- data[2]: 下载文件url
	-- data[3]: 下载文件保存路径全名
	
	os.execute("mkdir -p "..string.match(data[3], "(.+)/[^/]*%.%w+$").."/")
	local ftp = require("socket.ftp")
	
	local url = data[2]
	toast(url)
	local body = ftp.get(url)
    if body ~= nil then
        file = io.open(data[3], "wb")
        if file then
            file:write(body)
            file:close()
            return true, "ok";
        else
            return false, "open file failed";
        end
    else
        return false, "download failed. ";
    end
end

function GlobalTask:doTask(data)
	local ret, msg
	local cmd = data[1]
	if cmd == CMD_LUA_EXIT then 
		ret, msg = self:doLuaExit()
--	elseif cmd == CMD_UPLOAD_FILE then 
--		ret, msg = self:doUploadFile(data)
	elseif cmd == CMD_DOWNLOAD_FILE then
		ret, msg = self:doDownloadFile(data)
	elseif cmd == CMD_RESET_IMEI then
		ret, msg = self:resetImei(data[2])
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
			["snapshot"]=pic_name
		}
	else
		tbl_response = {
			["result"]=ret
		}
	end
	
	return ret, tbl_response
end