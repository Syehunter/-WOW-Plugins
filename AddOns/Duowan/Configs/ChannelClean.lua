------------------------------------
-- dugu 2009-12-21

if (GetLocale() == "zhCN") then
	CHANNELCLEAN_TITLE = "聊天过滤";
	CHANNELCLEAN_ENABLE = "开启聊天过滤";	
	CHANNELCLEAN_OPTION_DESC = "打开配置";	
	CHANNELCLEAN_OPTION_NAME = "聊天过滤";
	CHANNELCLEAN_FILTER_LOW_LEVEL_TITLE = "过滤低等级玩家世界频道发言";
	HCANNELCLEAN_FILTER_LOW_LEVEL_DESC = "过滤掉等级低于10级的玩家在世\n界频道和转发频道的发言.";
elseif (GetLocale() == "zhTW") then
	CHANNELCLEAN_TITLE = "聊天過濾";
	CHANNELCLEAN_ENABLE = "開啟聊天過濾";	
	CHANNELCLEAN_OPTION_DESC = "打開配置";
	CHANNELCLEAN_OPTION_NAME = "聊天過濾";
	CHANNELCLEAN_FILTER_LOW_LEVEL_TITLE = "過濾低等級玩家世界頻道發言";
	HCANNELCLEAN_FILTER_LOW_LEVEL_DESC = "過濾掉等級低於10級的玩家在世\n界頻道和轉發頻道的發言.";
else
	CHANNELCLEAN_TITLE = "聊天过滤";
	CHANNELCLEAN_ENABLE = "开启聊天过滤";	
	CHANNELCLEAN_OPTION_DESC = "打开配置";
	CHANNELCLEAN_OPTION_NAME = "ChannelClean";
	CHANNELCLEAN_FILTER_LOW_LEVEL_TITLE = "过滤低等级玩家世界频道发言";
	HCANNELCLEAN_FILTER_LOW_LEVEL_DESC = "过滤掉等级低于10级的玩家在世\n界频道和转发频道的发言.";
end

if (dwIsConfigurableAddOn("ChannelClean") --[[or dwIsConfigurableAddOn("DuowanChat")]]) then
	dwRegisterMod(
		"ChannelClean",
		CHANNELCLEAN_TITLE,
		"Channel Clean",
		"",
		"Interface\\ICONS\\Spell_Arcane_ArcaneResilience.blp",		
		nil
	);
end

if (dwIsConfigurableAddOn("ChannelClean")) then
	dwRegisterCheckButton(
		"ChannelClean",
		CHANNELCLEAN_ENABLE,
		"",
		"ChannelCleanEnable",
		1,
		function (arg)			
			if (arg == 1) then
				if (not dwIsAddOnLoaded("ChannelClean")) then
					dwLoadAddOn("ChannelClean");
				end
				
				ChannelClean:Toggle(true);
			else
				if (dwIsAddOnLoaded("ChannelClean")) then
					ChannelClean:Toggle(false);
				end
			end
		end
	);
	
	dwRegisterButton(
		"ChannelClean",
		CHANNELCLEAN_OPTION_DESC, 
		function()			
			if (dwIsAddOnLoaded("ChannelClean")) then
				--HideUIPanel(DuowanConfigFrame);
				--InterfaceOptionsFrame_OpenToCategory(CHANNELCLEAN_OPTION_NAME);
				 LibStub("AceConfigDialog-3.0"):Open(CHANNELCLEAN_OPTION_NAME);
			end
		end, 
		1
	);
end
--[[
if (dwIsConfigurableAddOn("DuowanChat")) then	
	dwRegisterCheckButton(
		"ChannelClean",
		CHANNELCLEAN_FILTER_LOW_LEVEL_TITLE,
		HCANNELCLEAN_FILTER_LOW_LEVEL_DESC,
		"FilterLowLevel",
		1,
		function (arg)			
			if (arg == 1) then
				DuowanChat:LowLevelFilterToggle(true);
			else
				DuowanChat:LowLevelFilterToggle(false);
			end
		end
	);
end
]]

