local http = require("socket.http")

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

function saveSnapshot(path)
--	local date = os.date("%Y-%m-%d")
--	local time = os.date("%H_%M_%S")
--	local dir_name = getPath().."/res/snapshot/"..date
	local pic_name = path
	if path == nil then
		pic_name = "/sdcard/tmp/snapshot.png"
	end

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

function base64_encode_file(path)
	os.execute("base64 "..path.." > /sdcard/tmp/base64_file.tmp")
	mSleep(1500)
	return readFileString("/sdcard/tmp/base64_file.tmp")
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

--GetHttp
function getHttp(url)
	local res, code = http.request(url)
	return res
end

--GetHttp 下载文件
function getHttpFile(url, filepath)
	local res, code = http.request(url)
	if res ~= nil then
		writeFileString(filepath, res)
	end
	return res ~= nil
end

--PostHttp [可自定义头信息]
function postHttp(url,post_data,table_headers)
	local res, code
	local response_body = {}
	res, code = http.request{  
		url = url,  
		method = "POST",  
		headers = table_headers,  
		source = ltn12.source.string(post_data),  
		sink = ltn12.sink.table(response_body)  
	}

	if res ~= nil then
		return response_body[1]
	end
	
	return nil
end 