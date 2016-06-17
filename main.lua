package.path = "/mnt/sdcard/TouchSprite/lua/common/?.lua;"..package.path

require("TSLib")
require("TSLibEx")

--getHttpFile("http://ip:3002/task_file?id=guid", "/sdcard/tmp/task_file.tar");
--os.execute("tar -xf /sdcard/tmp/task_file.tar -C /sdcard/TouchSprite/lua/")

dofile(getPath().."/lua/do_task.lua")