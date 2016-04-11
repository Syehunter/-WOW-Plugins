------------------------------------------------------------------------------------------
-- LibVoice-3.0 ver 1.0
-- 日期：2010-09-14
-- 作者：独孤傲雪
-- 描述：提供信息传输的编解码技术
-- 版权所有：duowan.com
------------------------------------------------------------------------------------------
local vmajor, vminor = "LibVoice-3.0", 1;

local lib = LibStub:NewLibrary(vmajor, vminor);
if not lib then
	return;
end

local function transfer_new(index,info)
	--ChatFrame1:AddMessage("lib:transfer_new > " .. tostring(info))
	assert(type(info) == "string", "bad argument #1 to 'LibVoice-3.0:Transfer' (string expected, got ".. type(info).. ")", "Master");

	byteInfo = info:byte(index);
	PlaySoundFile(format("Interface\\AddOns\\Duowan\\Acelibs\\LibVoice-3.0\\sounds\\%d.mp3", byteInfo));
	--ChatFrame1:AddMessage("lib:transfer_new > " .. format("Interface\\AddOns\\Duowan\\Acelibs\\LibVoice-3.0\\sounds\\%d.mp3", byteInfo))
end

local function transfer(info)
	assert(type(info) == "string", "bad argument #1 to 'LibVoice-3.0:Transfer' (string expected, got ".. type(info).. ")", "Master");

	local length = info:len();
	local byteInfo;
	for i=1, length do
		byteInfo = info:byte(i);
		PlaySoundFile(format("Interface\\AddOns\\Duowan\\Acelibs\\LibVoice-3.0\\sounds\\%d.mp3", byteInfo));
	end
end

function lib:Transfer(info)
	assert(type(info) == "string", "bad argument #1 to 'LibVoice-3.0:Transfer' (string expected, got ".. type(info).. ")");
	local orgVar = GetCVar("Sound_EnableAllSound");
	if (orgVar ~= "1") then
		SetCVar("Sound_EnableAllSound", "1");
	end	
	
	transfer("WOWBOX@");
	transfer(info);
	PlaySoundFile("Interface\\AddOns\\Duowan\\Acelibs\\LibVoice-3.0\\sounds\\0.mp3", "Master");

	if (orgVar ~= "1") then
		SetCVar("Sound_EnableAllSound", orgVar);
	end
end



--local info = "wow_ticket://NV_GROUPINFO:id^=^123456^&^name^=^我勒个去^&^master^=^1^&^type^=^0"
--local length = info:len();
local info_arry = {}
local index 	= 1
local delay 	= 0.1;
local counter 	= 0;
local function OnUpdate(self , elapsed)
	if #info_arry == 0 then self:Hide(); return; end
	counter = counter + elapsed
	if counter >= delay then
		counter = 0;
		
		local info = info_arry[1]
		local length = info:len();
		
		if index <= length then
			transfer_new(index,info)
			index = index + 1
		else
			PlaySoundFile("Interface\\AddOns\\Duowan\\Acelibs\\LibVoice-3.0\\sounds\\0.mp3", "Master");
			index = 1
			table.remove(info_arry, 1)
			if #info_arry == 0 then
				self:Hide()
			end
		end
	end  
end

function lib:Transfer_New(info)
	assert(type(info) == "string", "bad argument #1 to 'LibVoice-3.0:Transfer' (string expected, got ".. type(info).. ")");
	local orgVar = GetCVar("Sound_EnableAllSound");
	if (orgVar ~= "1") then
		SetCVar("Sound_EnableAllSound", "1");
	end	
	local full_info = "WOWBOX@" .. info
	table.insert(info_arry, full_info)
	
	if not TimerFrame then TimerFrame = CreateFrame("Frame") end
	TimerFrame:SetScript("OnUpdate",OnUpdate)
	TimerFrame:Show()
	--[[
	if (orgVar ~= "1") then
		SetCVar("Sound_EnableAllSound", orgVar);
	end]]
end