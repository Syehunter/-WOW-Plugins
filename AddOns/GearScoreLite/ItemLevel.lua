--[[
local SyItemLevel;
if (GetLocale() == "zhCN") then
	SyItemLevel = "◇装备等级: ";
elseif (GetLocale() == "zhTW") then
	SyItemLevel = "◇裝備等級: ";
else
	SyItemLevel = "◇ItemLevel: ";
end
local targetItemLevelInfo = {["未知目标"] = {},["小精灵"] = {}};

local f = CreateFrame'Frame';
local events = {
	'CHAT_MSG_ADDON',
	'UPDATE_MOUSEOVER_UNIT',
	'PLAYER_ENTERING_WORLD',
}

for _, event in pairs(events) do
	f:RegisterEvent(event);
end

f:SetScript('OnEvent', function(self, event, ...)
	if floor(GetAverageItemLevel()) then
		if event == "UPDATE_MOUSEOVER_UNIT" then
			if UnitExists("mouseover") and UnitIsPlayer("mouseover") and UnitIsFriend("player","mouseover") then
				local target,serverName = UnitName("mouseover")
				if serverName then
					target = target.."-"..serverName;
				end
				if not targetItemLevelInfo[target] or
				(targetItemLevelInfo[target] and targetItemLevelInfo[target].refresh and targetItemLevelInfo[target].refresh <= GetTime()) then
					targetItemLevelInfo[target] = {};
					if UnitInBattleground("mouseover") then
						SendAddonMessage("MyItemLevel","MyItemLevel@"..floor(GetAverageItemLevel()),'BATTLEGROUND')
					elseif UnitInRaid("mouseover") then						
						SendAddonMessage("MyItemLevel","MyItemLevel@"..floor(GetAverageItemLevel()),'RAID')
					elseif UnitInParty("mouseover") and UnitName("mouseover") ~= UnitName("player") then
						SendAddonMessage("MyItemLevel","MyItemLevel@"..floor(GetAverageItemLevel()),'PARTY')
					else	
						SendAddonMessage("MyItemLevel","ShowMeLevel@"..floor(GetAverageItemLevel()),'WHISPER',target)
					end
				end
			end			
		elseif event == "CHAT_MSG_ADDON" then
			local _,message,channel,sender = ...;
			local prefix, level = strsplit("@", message);
			if prefix and message and sender then
				if prefix == "MyItemLevel" or prefix == "ShowMeLevel" then
					targetItemLevelInfo[sender] = targetItemLevelInfo[sender] or {};
					targetItemLevelInfo[sender].itemLevel = level
					targetItemLevelInfo[sender].refresh = GetTime() + 1000;
					if prefix == "ShowMeLevel" then
						SendAddonMessage("MyItemLevel","MyItemLevel@"..floor(GetAverageItemLevel()),'WHISPER',sender)
					end
				end
			end
		elseif (event == "PLAYER_ENTERING_WORLD") then
			RegisterAddonMessagePrefix("MyItemLevel");
		end
	end
end)

local showItemLv = true;
function ItemLevelShow()
	if not showItemLv then return end

	local target,serverName = UnitName("mouseover")
	if serverName then
		target = target.."-"..serverName;
	end
	if targetItemLevelInfo[target] and targetItemLevelInfo[target].itemLevel and targetItemLevelInfo[target].refresh and targetItemLevelInfo[target].refresh > GetTime() then
		if UnitExists("mouseover") and UnitIsPlayer("mouseover") and UnitIsFriend("player","mouseover") and (CanInspect("mouseover")) then
			GameTooltip:AddLine(SyItemLevel..targetItemLevelInfo[target].itemLevel, 1, 1, 1)
		end
	end
end

function ItemLevel_Toggle(switch)
	if (switch) then
		showItemLv = true;
	else
		showItemLv = false;
	end
end

GameTooltip:HookScript("OnTooltipSetUnit", ItemLevelShow)
]]
