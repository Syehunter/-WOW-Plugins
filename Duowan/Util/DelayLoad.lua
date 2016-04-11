 -----------------------------------------------------------------------------
 -- 文件名: DelayLoad.lua
 -- 日期: 2011-12-25
 -- 作者: dugu@wowbox
 -- 描述: 实现自己的动态载入功能
 -- 版权所有 (c) 多玩游戏网
 -----------------------------------------------------------------------------

----------------------
-- 延迟载入的插件(非动态载入)
local DELAY_LOAD_ADDONS = {
	--["Titan"] = true,
};

local Duowan_Disabled_AddOns = {};

function dwIsDisabledAddOn(addon)
	local name;	
	for i, id in ipairs(Duowan_Disabled_AddOns) do
		name = GetAddOnInfo(id);
		--print(name, addon, name == addon)
		if (name == addon) then
			return true;
		end
	end

	return false;
end

function dwDisableAllAddOns()
	local name, revision, IsEnable, bLoadOnDemand, _;

	for i=1, GetNumAddOns() do
		name, _, _, IsEnable = GetAddOnInfo(i);
		bLoadOnDemand = IsAddOnLoadOnDemand(i);
		revision = GetAddOnMetadata(i, "X-Revision");
		if revision == "Duowan" and DELAY_LOAD_ADDONS[name] then 
			table.insert(Duowan_Disabled_AddOns, i);
			DisableAddOn(i);
		end
	end 
end

function dwDelayEnableAddOns()
	for k, index in ipairs(Duowan_Disabled_AddOns) do
		EnableAddOn(index);	
	end
end

function dwDelayLoadAddOns()
	for k, index in ipairs(Duowan_Disabled_AddOns) do
		LoadAddOn(index);
	end
end

--[[
local frame = CreateFrame("Frame");
frame:RegisterAllEvents();

frame:SetScript("OnEvent", function(self, event, ...)
	print(event)
	if (event == "PLAYER_ENTERING_WORLD") then
		frame:UnregisterAllEvents();
	end
end)
]]