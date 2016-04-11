-- **************************************************************************
-- * TitanWinterTimer.lua
-- *
-- * By: dugu
-- **************************************************************************

local TITAN_WINTERTIMER_ID = "WinterTimer";
local TITAN_WT_FREQUENCY = 0.5;
local updateTable = {TITAN_WINTERTIMER_ID, TITAN_PANEL_UPDATE_BUTTON} ;
local AceTimer = LibStub("AceTimer-3.0")
local inWinterTimerQueue = false;
if (not TitanPerSetting) then
	TitanPerSetting = {};
end

if (GetLocale() == "zhCN") then
	TITAN_WINTERTIMER_WARNING_TEXT = "距冬拥湖战斗开始还有>>%s<<分钟";
	TITAN_WINTERTIMER_START = "战斗中...";	
	TITAN_WINTERTIMER_START_CANT_JION = "战斗进行中无法加入";
	TITAN_WINTERTIMER_CANT_JION = "无法加入冬拥湖战场";
	TITAN_WINTERTIMER_BEGIN_TEXT = "冬拥湖战斗开始";
	TITAN_WINTERTIMER_TOOLTIP_TEXT = "显示距冬拥湖战斗开始的时间";
	TITAN_WINTERTIMER_TOOLTIP_TEXT2 = "排队中..."
elseif (GetLocale() == "zhTW") then
	TITAN_WINTERTIMER_WARNING_TEXT = "距冬握湖戰鬥開始還有>>%s<<分鐘";
	TITAN_WINTERTIMER_START = "戰鬥中...";
	TITAN_WINTERTIMER_START_CANT_JION = "戰鬥進行中無法加入";
	TITAN_WINTERTIMER_CANT_JION = "無法加入冬握湖戰場";
	TITAN_WINTERTIMER_BEGIN_TEXT = "冬握湖戰鬥開始";
	TITAN_WINTERTIMER_TOOLTIP_TEXT = "顯示距冬握湖戰鬥開始的時間";
	TITAN_WINTERTIMER_TOOLTIP_TEXT2 = "排隊中..."
else
	TITAN_WINTERTIMER_WARNING_TEXT = "距冬拥湖战斗开始还有>>%s<<分钟";
	TITAN_WINTERTIMER_START = "战斗中...";
	TITAN_WINTERTIMER_START_CANT_JION = "战斗进行中无法加入";
	TITAN_WINTERTIMER_CANT_JION = "无法加入冬拥湖战场";
	TITAN_WINTERTIMER_BEGIN_TEXT = "冬拥湖战斗开始";
	TITAN_WINTERTIMER_TOOLTIP_TEXT = "显示距冬拥湖战斗开始的时间";
	TITAN_WINTERTIMER_TOOLTIP_TEXT2 = "排队中..."
end

function TitanWinterTimerButton_OnLoad(self)
	self.registry = {
		id = TITAN_WINTERTIMER_ID,
		builtIn = 1,
		version = TITAN_VERSION,
		menuText = TITAN_WINTERTIMER_MENU_TEXT,
		buttonTextFunction = "TitanWinterTimerButton_GetButtonText",
		tooltipTitle = TITAN_WINTERTIMER_TOOLTIP,
		tooltipTextFunction = "TitanWinterTimerButton_GetTooltipText",
		icon = "Interface\\Icons\\Spell_Frost_WizardMark",
		iconWidth = 16,
		savedVariables = {
			ShowIcon = 1,	
			ShowColoredText = 1,
			DisplayOnRightSide = false,
		}
	};	

	if (TitanPerSetting.autoWinterTimer) then
		inWinterTimerQueue = true;
	end
	self:RegisterForClicks("LeftButtonUp", "RightButtonUp");
end

function TitanPanelWinterTimerButtonRightClickMenu_OnLoad(self)
	UIDropDownMenu_Initialize(self, TitanPanelRightClickMenu_PrepareWinterTimerMenu, "MENU");
end

function TitanWinterTimerButton_OnUpdate(self, elapsed)
	TITAN_WT_FREQUENCY = TITAN_WT_FREQUENCY - elapsed;
	if (TITAN_WT_FREQUENCY < 0) then
		TITAN_WT_FREQUENCY = 0.5;
		TitanPanelPluginHandle_OnUpdate(updateTable);
				
		local _, localizedName, isActive, canQueue, startTime, canEnter = GetWorldPVPAreaInfo(1);
		if (TitanPerSetting.autoWinterTimer) then	
			if (canEnter and not inWinterTimerQueue) then
				inWinterTimerQueue = true;
			end
			if  (canEnter and canQueue) then
				BattlefieldMgrQueueRequest(1);
				TitanPerSetting.autoJoinTobal = false;				
			end
		end
		if (isActive and inWinterTimerQueue) then
			inWinterTimerQueue = false;
		end	
	end
end

function TitanWinterTimerButton_OnShow(self)
	
end

function TitanWinterTimerButton_OnHide(self)
	
end


function TitanWinterTimerButton_OnClick(self, button)
	if (button == "RightButton") then
		UIDropDownMenu_Initialize(TitanPanelWinterTimerButtonRightClickMenu, TitanPanelRightClickMenu_PrepareWinterTimerMenu, "MENU");
		ToggleDropDownMenu(1, nil, TitanPanelWinterTimerButtonRightClickMenu, self:GetName(), 5, -10)		
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

function TitanWinterTimerButton_GetButtonText()
	local timeText;
	local _, localizedName, isActive, canQueue, startTime, canEnter = GetWorldPVPAreaInfo(1);
	if (not isActive) then
		if(IsInInstance())then
			timeText = "|cff00CC00  N/A|r";
		else
			timeText = TWT_ConvertTime(startTime);
			if (inWinterTimerQueue) then
				timeText = TitanUtils_GetGreenText(timeText);
			end
		end
	else
		timeText = "|cff00CC00"..TITAN_WINTERTIMER_START.."|r";
	end
	
	return timeText;
end

function TitanWinterTimerButton_GetTooltipText()
	local text = TITAN_WINTERTIMER_TOOLTIP_TEXT;
	if (inWinterTimerQueue) then
		text = text.."\n"..TITAN_WINTERTIMER_TOOLTIP_TEXT2;	
	end	
	return TitanUtils_GetGreenText(text);	
end

function TITAN_PANEL_MENU_WINTERTIMER_JION()
	TitanPerSetting.autoWinterTimer = true;
	inWinterTimerQueue = true;
end

function TITAN_PANEL_MENU_WINTERTIMER_QUITE()
	TitanPerSetting.autoWinterTimer = false;
	inWinterTimerQueue = false;
end

function TitanPanelRightClickMenu_PrepareWinterTimerMenu()
	local info = UIDropDownMenu_CreateInfo();

	info.notCheckable = true
	
	local _, localizedName, isActive, canQueue, startTime, canEnter = GetWorldPVPAreaInfo(1);
	if (canEnter) then
		--if (isActive) then
		--	info.text = "|cffCCCC00"..TITAN_WINTERTIMER_START_CANT_JION.."|r";
		--	info.notClickable = 1;
		--	info.isTitle = 1;
		--else
			if (TitanPerSetting.autoWinterTimer) then
				info.text = "取消冬拥湖战场排队";
				info.func = TITAN_PANEL_MENU_WINTERTIMER_QUITE;
			else
				info.text = "加入冬拥湖战场";
				info.func = TITAN_PANEL_MENU_WINTERTIMER_JION;
			end
		--end
	else
		info.text = "|cffCCCC00"..TITAN_WINTERTIMER_CANT_JION.."|r";
		info.notClickable = 1;
		info.isTitle = 1;
	end

	UIDropDownMenu_AddButton(info, 1);
end