-- **************************************************************************
-- * TitanTolBarad.lua
-- *
-- * By: dugu
-- **************************************************************************
local TITAN_TOLBARAD_ID = "TolBarad";
local TITAN_WT_FREQUENCY = 0.5;
local updateTable = {TITAN_TOLBARAD_ID, TITAN_PANEL_UPDATE_BUTTON} ;
local inTolbaradQueue = false;
if (not TitanPerSetting) then
	TitanPerSetting = {};	
end

if (GetLocale() == "zhCN") then
	TITAN_TOLBARAD_WARNING_TEXT = "距托巴拉德战斗开始还有>>%s<<分钟";
	TITAN_TOLBARAD_START = "战斗中...";
	TITAN_TOLBARAD_START_CANT_JION = "战斗中无法加入";
	TITAN_TOLBARAD_CANT_JION = "无法加入托尔巴拉德战场";
	TITAN_TOLBARAD_BEGIN_TEXT = "托巴拉德战斗开始";
	TITAN_TOLBARAD_TOOLTIP_TEXT = "显示距托巴拉德战斗开始的时间";
	TITAN_TOLBARAD_TOOLTIP_TEXT2 = "排队中..."
elseif (GetLocale() == "zhTW") then
	TITAN_TOLBARAD_WARNING_TEXT = "距托巴拉德戰鬥開始還有>>%s<<分鐘";
	TITAN_TOLBARAD_START = "戰鬥中...";
	TITAN_TOLBARAD_START_CANT_JION = "戰鬥中無法加入";
	TITAN_TOLBARAD_CANT_JION = "無法加入托巴拉德战场";
	TITAN_TOLBARAD_BEGIN_TEXT = "托巴拉德戰鬥開始";
	TITAN_TOLBARAD_TOOLTIP_TEXT = "顯示距托巴拉德戰鬥開始的時間";
	TITAN_TOLBARAD_TOOLTIP_TEXT2 = "排隊中..."
else
	TITAN_TOLBARAD_WARNING_TEXT = "距托巴拉德战斗开始还有>>%s<<分钟";
	TITAN_TOLBARAD_START = "战斗中...";
	TITAN_TOLBARAD_START_CANT_JION = "战斗中无法加入";
	TITAN_TOLBARAD_CANT_JION = "无法加入托尔巴拉德战场";
	TITAN_TOLBARAD_BEGIN_TEXT = "托巴拉德战斗开始";
	TITAN_TOLBARAD_TOOLTIP_TEXT = "显示距托巴拉德战斗开始的时间";
	TITAN_TOLBARAD_TOOLTIP_TEXT2 = "排隊中..."
end

function TitanTolBaradButton_OnLoad(self)
	self.registry = {
		id = TITAN_TOLBARAD_ID,
		builtIn = 1,
		version = TITAN_VERSION,
		menuText = TITAN_TOLBARAD_MENU_TEXT,
		buttonTextFunction = "TitanTolBaradButton_GetButtonText",
		tooltipTitle = TITAN_TOLBARAD_TOOLTIP,
		tooltipTextFunction = "TitanTolBaradButton_GetTooltipText",
		icon = "Interface\\Icons\\Ability_DualWield",
		iconWidth = 16,
		savedVariables = {
			ShowIcon = 1,	
			ShowColoredText = 1,
			DisplayOnRightSide = false,
		}
	};

	if (TitanPerSetting.autoJoinTobal) then
		inTolbaradQueue = true;
	end
	self:RegisterForClicks("LeftButtonUp", "RightButtonUp");
end

function TitanPanelTolBaradButtonRightClickMenu_OnLoad(self)
	UIDropDownMenu_Initialize(self, TitanPanelRightClickMenu_PrepareTolBaradMenu, "MENU");
end

function TitanTolBaradButton_OnUpdate(self, elapsed)
	TITAN_WT_FREQUENCY = TITAN_WT_FREQUENCY - elapsed;
	if (TITAN_WT_FREQUENCY < 0) then
		TITAN_WT_FREQUENCY = 0.5;
		TitanPanelPluginHandle_OnUpdate(updateTable);
			
		local _, localizedName, isActive, canQueue, startTime, canEnter = GetWorldPVPAreaInfo(2);
		if (TitanPerSetting.autoJoinTobal) then
			if (canEnter and not inTolbaradQueue) then
				inTolbaradQueue = true;
			end
			if  (canEnter and canQueue) then
				BattlefieldMgrQueueRequest(21);
				TitanPerSetting.autoJoinTobal = false;				
			end
		end
		-- TODO:这里还有些逻辑错误
		if (isActive and inTolbaradQueue) then
			inTolbaradQueue = false;
		end		
	end
end

function TitanTolBaradButton_OnShow(self)
	
end

function TitanTolBaradButton_OnHide(self)
	
end

function TitanTolBarad_Warning(value)
	if (value == "0:15:00") then
		RaidNotice_AddMessage(RaidBossEmoteFrame, format(TITAN_TOLBARAD_WARNING_TEXT, TitanUtils_GetGreenText("15")), ChatTypeInfo["RAID_WARNING"]);
	elseif (value == "0:05:00") then
		RaidNotice_AddMessage(RaidBossEmoteFrame, format(TITAN_TOLBARAD_WARNING_TEXT, TitanUtils_GetGreenText("5")), ChatTypeInfo["RAID_WARNING"]);
	elseif (value == "0:00:01") then
		RaidNotice_AddMessage(RaidBossEmoteFrame, TITAN_TOLBARAD_BEGIN_TEXT, ChatTypeInfo["RAID_WARNING"]);
	end	
end

function TitanTolBaradButton_OnClick(self, button)
	if (button == "RightButton") then
		UIDropDownMenu_Initialize(TitanPanelTolBaradButtonRightClickMenu, TitanPanelRightClickMenu_PrepareTolBaradMenu, "MENU");
		ToggleDropDownMenu(1, nil, TitanPanelTolBaradButtonRightClickMenu, self:GetName(), 5, -10)		
	end
	GameTooltip:Hide();
end

local function TWT_ConvertTime(value)
	local hours = floor(value / 3600)
	local minutes = value - (hours * 3600)
	minutescorrupt = floor(minutes / 60)
	if(minutescorrupt < 10)then minutesfixed = "0"..minutescorrupt..""
	else minutesfixed = minutescorrupt end
	local seconds = floor(value - ((hours * 3600) + (minutescorrupt * 60)))
	if(seconds < 10)then secondsfixed = "0"..seconds..""
	else secondsfixed = seconds end
	if (hours > 0) then
		return hours..":"..minutesfixed..":"..secondsfixed
	elseif (minutescorrupt > 0) then
		return "0:"..minutesfixed..":"..secondsfixed
	else
		return "0:00:"..secondsfixed
	end
end

function TitanTolBaradButton_GetButtonText()
	local timeText;
	local _, localizedName, isActive, canQueue, startTime, canEnter = GetWorldPVPAreaInfo(2);
	if (not isActive) then
		if(IsInInstance())then
			timeText = "|cff00CC00  N/A|r";
		else
			timeText = TWT_ConvertTime(startTime);
			if (canEnter) then
				TitanTolBarad_Warning(timeText);
			end
			if (inTolbaradQueue) then
				timeText = TitanUtils_GetGreenText(timeText);
			end
		end
	else		
		timeText = "|cff00CC00"..TITAN_TOLBARAD_START.."|r";		
	end

	return timeText;
end

function TitanTolBaradButton_GetTooltipText()
	local text = TITAN_TOLBARAD_TOOLTIP_TEXT;
	if (inTolbaradQueue) then
		text = text .. "\n" .. TITAN_TOLBARAD_TOOLTIP_TEXT2
	end
	return TitanUtils_GetGreenText(text);
end

function TITAN_PANEL_MENU_TOLBARAD_JION()
	TitanPerSetting.autoJoinTobal = true;
	inTolbaradQueue = true;
end

function TITAN_PANEL_MENU_TOLBARAD_QUITE()
	TitanPerSetting.autoJoinTobal = false;
	inTolbaradQueue = false;
end

function TitanPanelRightClickMenu_PrepareTolBaradMenu(dropdownFrame, level, menu)
	local info = UIDropDownMenu_CreateInfo();

	info.notCheckable = true
	
	local _, localizedName, isActive, canQueue, startTime, canEnter = GetWorldPVPAreaInfo(2);
	if (canEnter) then
		--if (isActive) then
		--	info.text = "|cffCCCC00"..TITAN_TOLBARAD_START_CANT_JION.."|r";
		--	info.notClickable = 1;
		--	info.isTitle = 1;
		--else
			if (TitanPerSetting.autoJoinTobal) then
				info.text = "取消托尔巴拉德战场排队";
				info.func = TITAN_PANEL_MENU_TOLBARAD_QUITE;
			else
				info.text = "加入托尔巴拉德战场";
				info.func = TITAN_PANEL_MENU_TOLBARAD_JION;
			end
		--end
	else
		info.text = "|cffCCCC00"..TITAN_TOLBARAD_CANT_JION.."|r";
		info.notClickable = 1;
		info.isTitle = 1;
	end

	UIDropDownMenu_AddButton(info, 1);
end