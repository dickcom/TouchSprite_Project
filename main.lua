package.path = "/mnt/sdcard/TouchSprite/lua/common/?.lua;"..package.path

require("TSLib")
require("TSLibEx")
require("config")
require("json")

g_tbl_task = nil

function main()
	local guid = readFileString(getPath().."/uuid.txt")
	local res = getHttpFile(g_conf_task_file_url.."?guid="..guid, "/sdcard/tmp/task_file.tar")
	if res == false then
		toast("Get task file failed.")
		log("Get task file failed.", "main")
		return
	end

	os.execute("mkdir -p /sdcard/tmp/ts_task")
	mSleep(100)
	os.execute("rm -fr /sdcard/tmp/ts_task/* /sdcard/tmp/task_id")
	mSleep(100)
	os.execute("tar -xf /sdcard/tmp/task_file.tar -C /sdcard/tmp/ts_task/")
	mSleep(200)
	os.execute("ls /sdcard/tmp/ts_task > /sdcard/tmp/task_id")
	mSleep(100)

	local task_type, task_id

	task_id = readFileString("/sdcard/tmp/task_id")
	task_id = string.gsub(task_id, "\n", "")
	if task_id == nil or task_id == "" then
		toast("Get task file failed.")
		log("Get task file failed.", "main")
		return
	end
	res = getHttp(g_conf_download_complete_url.."?guid="..guid)
	if res == false then
		log("Get download complete failed.", "main")
	end

	local jsdata = readFileString("/sdcard/tmp/ts_task/"..task_id.."/script")
	g_tbl_task = json.decode(jsdata)
	task_type = g_tbl_task["task_type"]
	g_tbl_task["task_id"] = task_id

	if task_type == "wx_vote" then
		os.execute("cp -a /sdcard/tmp/ts_task/"..task_id.."/main.lua "..getPath().."/lua/wx/wx_vote.lua")
		mSleep(100)
--		os.execute("cp -a /sdcard/tmp/ts_task/"..task_id.."/script "..getPath().."/res/task_cmd.json")
--		mSleep(100)
	end

	dofile(getPath().."/lua/do_task.lua")
end

main()
