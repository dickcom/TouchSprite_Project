Log = {strLogFile = ""}
Log.__index = Log

function Log:new(strLogFile, iType) 
	iType = iType or 0
	local self = {}     
	setmetatable(self, Log)
	self.strLogFile = strLogFile
	initLog(strLogFile, iType)
	return self    
end

function Log:log(str)
	wLog(self.strLogFile, str);
	toast(str)
	coMSleep(300)
end

function Log:close()
	closeLog(self.strLogFile)
end
