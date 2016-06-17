function findMultiColorInRegionFuzzyInTime(p1,p2,p3,p4,p5,p6,p7,p8)
	local var
	local count
	local x,y
	count = p8/500
	if count == 0 then count = 1 end
	for var = 1, count do
		coMSleep(500)
		x,y = findMultiColorInRegionFuzzy( p1,p2,p3,p4,p5,p6,p7)
		if x ~= -1 and y ~= -1 then
			return x, y
		end
	end
	return x,y
end

--time: time
--call_back_fun: callback function(return type must be [boolean,int,int])
function findColorInTime(time, call_back_fun)
	local var
	local count
	local ret
	local x,y
	count = time/500
	
	for var = 1, count do
		coMSleep(500)
		ret,x,y = call_back_fun()
		if ret then
			return true,x,y
		end
	end
	return false,-1,-1
end

function delText(count)
	local var
	for var=1, count do
		os.execute("input keyevent 67")
	end
end

function saveSnapshot()
--	local date = os.date("%Y-%m-%d")
--	local time = os.date("%H_%M_%S")
--	local dir_name = getPath().."/res/snapshot/"..date
	local pic_name = "/sdcard/tmp/snapshot.png"
--	os.execute("mkdir -p "..dir_name)
	snapshot(pic_name, 0, 0, 719, 1279)
	return pic_name
end

function base64_encode(source_str)
    local b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    local s64 = ''
    local str = source_str

    while #str > 0 do
        local bytes_num = 0
        local buf = 0

        for byte_cnt=1,3 do
            buf = (buf * 256)
            if #str > 0 then
                buf = buf + string.byte(str, 1, 1)
                str = string.sub(str, 2)
                bytes_num = bytes_num + 1
            end
        end

        for group_cnt=1,(bytes_num+1) do
            b64char = math.fmod(math.floor(buf/262144), 64) + 1
            s64 = s64 .. string.sub(b64chars, b64char, b64char)
            buf = buf * 64
        end

        for fill_cnt=1,(3-bytes_num) do
            s64 = s64 .. '='
        end
    end

    return s64
end

function base64_decode(str64)
    local b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    local temp={}
    for i=1,64 do
        temp[string.sub(b64chars,i,i)] = i
    end
    temp['=']=0
    local str=""
    for i=1,#str64,4 do
        if i>#str64 then
            break
        end
        local data = 0
        local str_count=0
        for j=0,3 do
            local str1=string.sub(str64,i+j,i+j)
            if not temp[str1] then
                return
            end
            if temp[str1] < 1 then
                data = data * 64
            else
                data = data * 64 + temp[str1]-1
                str_count = str_count + 1
            end
        end
        for j=16,0,-8 do
            if str_count > 0 then
                str=str..string.char(math.floor(data/math.pow(2,j)))
                data=data % math.pow(2,j)
                str_count = str_count - 1
            end
        end
    end
    return str
end

function base64_encode_file(file)
	data = readFileString(file)
	return base64_encode(data)
end


function fileExists(file)
	local f,e
	f,e = io.open(file, "rb")
	
	if f then f:close() end
	return f ~= nil
end

--调度型mSleep
function coMSleep(ms)
	mSleep(ms)
	coroutine.yield()
--	local count
--	count = ms/1000
--	if count == 0 then 
--		coroutine.yield()
--		mSleep(ms)
--	end
--	for var = 1, count do
--		coroutine.yield()
--		mSleep(1000)
--		ms = ms - 1000
--		if ms < 1000 then
--			mSleep(ms)
--		end
--	end
end

--获取最上层Activity
function getTopActivity()
	local iRet, sRet = pcall(function()
		local path = "/sdcard/tmp/getTopActivity"
		os.execute("dumpsys activity top >" .. path)
		mSleep(500)
		return string.match(readFileString(path),"ACTIVITY ([^ ]+)")
	end)
	if iRet == true then
		return sRet
	else
		return ""
	end
end

-- 临时文件路径 [fn:文件名] [返回文件路径, 失败返回空字符串]
function tempFile(fn)
	local tPath = "/sdcard/tmp/"

	if fn == null then
		return tPath .. "ts_temp.txt"
	else
		return tPath .. fn .. ".txt"
	end

end

--GetHttp [可自定义头信息]
function getHttp(url, t,header)
	local iRet, sRet = pcall(function()
		local path = tempFile("GET") 
		if t == null then t = 8 end 
		if header == nil then
			os.execute(string.format("curl --connect-timeout %s  -o %s '%s' ",t,path,url))
		else
			os.execute(string.format("curl --connect-timeout %s -H %s -o %s '%s'",t,header,path,url))
		end 
		result = readfile(path,1)
		return result
	end)
	if iRet == true then
		return sRet
	else
		return ""
	end
end

--GetHttp 下载文件
function getHttpFile(url, filepath, header)
	local iRet, sRet = pcall(function()
		if header == null then
			os.execute(string.format("curl -o %s '%s' ",filepath, url))
		else
			os.execute(string.format("curl -o %s -H %s '%s' ",filepath, header,url))
		end
	end)
	if iRet == true then
		return sRet
	else
		return ""
	end
end

--PostHttp [可自定义头信息]
function postHttp(url,post, t,header)
	local iRet, sRet = pcall(function()
		local path = tempFile("POST") 
		if t == null then t = 8 end 
		if header == null then
			os.execute(string.format("curl -o %s -d '%s' --connect-timeout %s '%s'",path,post,t,url))
		else 
			os.execute(string.format("curl -o %s --data-urlencode '%s' --connect-timeout %s -H %s '%s'",path,post,t,header,url))
		end 
		result = readfile(path)
		return result
	end)
	if iRet == true then
		return sRet
	else
		return ""
	end
end 

--Post提交信息，可附带cookie信息
function postHttpC(url,post,cookie_path ,t,header)
	local iRet, sRet = pcall(function()
		local path = tempFile("POST")
		if t == null then t = 8 end 
		if header == null then
			os.execute(string.format("curl -o %s -d '%s' -b '%s' --connect-timeout %s '%s'",path,post,cookie_path,t,url))
		else 
			os.execute(string.format("curl -o %s -d '%s' -b '%s' --connect-timeout %s -H % '%s'",path,post,cookie_path,t,header,url))
		end 
		result = readfile(path)
		return result
	end)
	if iRet == true then
		return sRet
	else
		return ""
	end
end 

--GET提交信息，可附带cookie信息
function getHttpC(url,cookie_path ,t,header)
	local iRet, sRet = pcall(function()
		local path = tempFile("GET") 
		if t == null then t = 8 end 
		if header == null then
			os.execute(string.format("curl -o %s -b '%s' --connect-timeout %s '%s'",path,cookie_path,t,url))
		else 
			os.execute(string.format("curl -o %s -b '%s' --connect-timeout %s -H % '%s'",path,cookie_path,t,header,url))
		end 
		result = readfile(path)
		return result
	end)
	if iRet == true then
		return sRet
	else
		return ""
	end
end 