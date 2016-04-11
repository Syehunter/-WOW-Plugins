--============================================
-- 名称: DuowanPatch
-- 日期: 2009-12-16
-- 描述: 修复系统和其他插件的一些bug
-- 作者: dugu
-- 鸣谢: CWDG
-- 版权所有 (C) duowan
--============================================
-- 修复团队框架和宠物动作条bug

function cwdg_WatchRaidGroupButtons()
	local i;
	local button;
	for i=1, 40 do
		button = getglobal("RaidGroupButton"..i);
		button:SetAttribute("type", "target");
		button:SetAttribute("unit", button.unit);
	end
end

function cwdg_WatchPetActionBar()
--	PetActionBarFrame:SetAttribute("unit", "pet");
--	RegisterUnitWatch(PetActionBarFrame);
end

local cwdg_button = CreateFrame("Frame");
cwdg_button:RegisterEvent("VARIABLES_LOADED");
cwdg_button:RegisterEvent("ADDON_LOADED");
cwdg_button:RegisterEvent("PLAYER_TARGET_CHANGED");
cwdg_button:SetScript("OnEvent", function(self, event, modname)
	if (event == "ADDON_LOADED" and modname == "Blizzard_RaidUI") then		
		dwSecureCall(cwdg_WatchRaidGroupButtons);
	elseif (event == "VARIABLES_LOADED") then		
		dwSecureCall(cwdg_WatchPetActionBar);
		
		--TargetFrame.totFrame = nil;
		--TargetFrameToT:SetAttribute("unit", "targettarget");
		--RegisterUnitWatch(TargetFrameToT);
	end
end);

-- 屏蔽界面失效的提醒
UIParent:UnregisterEvent("ADDON_ACTION_BLOCKED");


if (not VoiceOptionsFrameAudioLabel) then
	CreateFrame("Frame", "VoiceOptionsFrameAudioLabel", UIParent);
end

--------------------
-- 交易和转让会长时提示

DWSecure_MoneyAmount = 1000000;

dwStaticPopupDialogs["DW_TRADE_MONEY"] = {
	text = DW_TRADEMONEY_CONFIRMATION,
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function(self)
		AcceptTrade()
	end,
	OnCancel = function(self)
	end,
	OnShow = function(self)
		MoneyFrame_Update(self.moneyFrame, MoneyInputFrame_GetCopper(TradePlayerInputMoneyFrame));
	end,
	hasMoneyFrame = 1,
	timeout = 0,
	hideOnEscape = 1,
};

TradeFrameTradeButton:SetScript("OnClick",function()
	local copper=MoneyInputFrame_GetCopper(TradePlayerInputMoneyFrame);
	if copper>=DWSecure_MoneyAmount then-- if copper >100G
		dwStaticPopup_Show("DW_TRADE_MONEY", UnitName("NPC"));
	else
		AcceptTrade()
	end
end);

SlashCmdList["GUILD_LEADER"] = function (msg)
	if( msg and (strlen(msg) > MAX_CHARACTER_NAME_BYTES) ) then
		ChatFrame_DisplayUsageError(ERR_NAME_TOO_LONG2);
		return;
	end
	if strlen(msg)>0 then
		StaticPopup_Show("CONFIRM_GUILD_PROMOTE", msg, "", msg)
	elseif UnitName("target") then
		StaticPopup_Show("CONFIRM_GUILD_PROMOTE", UnitName("target"), "", UnitName("target"))
	end
end

---------------------
-- LUA报错

function FixLuaDebugError()	
	ScriptErrorsFrameScrollFrameText.cursorOffset = 0;
end

dwAsynCall("Blizzard_DebugTools", "FixLuaDebugError");

----------------------
--  修复AtlastLoot报错

local function SetTranslations(...)
	local L = {}
	for i=1, select("#",...), 2 do
		local v, k = select(i,...)
		L[k] = v
	end
	LOCALIZED_CLASS_NAMES_MALE = L
end

if GetLocale() == "zhCN" then
	SetTranslations( "术士", "WARLOCK", "战士", "WARRIOR", "猎人", "HUNTER", "法师", "MAGE", "牧师", "PRIEST", "德鲁伊", "DRUID", "圣骑士", "PALADIN", "萨满祭司", "SHAMAN", "潜行者", "ROGUE", "死亡骑士", "DEATHKNIGHT", "术士", "WARLOCK", "战士", "WARRIOR", "猎人", "HUNTER", "法师", "MAGE", "牧师", "PRIEST", "德鲁伊", "DRUID", "圣骑士", "PALADIN", "萨满祭司", "SHAMAN", "潜行者", "ROGUE", "死亡骑士", "DEATHKNIGHT" )
elseif GetLocale()  == "zhTW" then
	SetTranslations( "術士", "WARLOCK", "戰士", "WARRIOR", "獵人", "HUNTER", "法師", "MAGE", "牧師", "PRIEST", "德魯伊", "DRUID", "聖騎士", "PALADIN", "薩滿", "SHAMAN", "盜賊", "ROGUE", "死亡騎士", "DEATHKNIGHT", "術士", "WARLOCK", "戰士", "WARRIOR", "獵人", "HUNTER", "法師", "MAGE", "牧師", "PRIEST", "德魯伊", "DRUID", "聖騎士", "PALADIN", "薩滿", "SHAMAN", "盜賊", "ROGUE", "死亡騎士", "DEATHKNIGHT" )
end

----------------------
-- 修复聊天记录上次发言
ChatTypeInfo.WHISPER.sticky = 0   -----将"1"全改为"0"即可
ChatTypeInfo.OFFICER.sticky = 0
ChatTypeInfo.RAID_WARNING.sticky = 0
ChatTypeInfo.CHANNEL.sticky = 1
ChatTypeInfo.BN_WHISPER.sticky = 0

-----------------------
-- 获得金钱显示字符串
-----------------------
function GetMoneyString(money)
	local goldString, silverString, copperString;
	local gold = floor(money / (COPPER_PER_SILVER * SILVER_PER_GOLD));
	local silver = floor((money - (gold * COPPER_PER_SILVER * SILVER_PER_GOLD)) / COPPER_PER_SILVER);
	local copper = mod(money, COPPER_PER_SILVER);
	
	if ( ENABLE_COLORBLIND_MODE == "1" ) then
		goldString = gold..GOLD_AMOUNT_SYMBOL;
		silverString = silver..SILVER_AMOUNT_SYMBOL;
		copperString = copper..COPPER_AMOUNT_SYMBOL;
	else
		goldString = format(GOLD_AMOUNT_TEXTURE, gold, 0, 0);
		silverString = format(SILVER_AMOUNT_TEXTURE, silver, 0, 0);
		copperString = format(COPPER_AMOUNT_TEXTURE, copper, 0, 0);
	end
	
	local moneyString = "";
	local separator = "";	
	if ( gold > 0 ) then
		moneyString = goldString;
		separator = " ";
	end
	if ( silver > 0 ) then
		moneyString = moneyString..separator..silverString;
		separator = " ";
	end
	if ( copper > 0 or moneyString == "" ) then
		moneyString = moneyString..separator..copperString;
	end
	
	return moneyString;
end

-----------------------
-- GetCurrentDungeonDifficulty
function GetCurrentDungeonDifficulty()
	local SysDif = 1;	--小队：1=普通 2=英雄		团队：1=10人  2=25人  3=10人(英雄)  4=25人(英雄)
	local EQDif = 0;	--返回值：1=普通  2=英雄  0=未知
	if UnitInRaid("player") then
		SysDif = GetRaidDifficulty();
		if not SysDif then return 0;end
		if SysDif == 1 or SysDif == 2 then
			EQDif = 1;
		else
			EQDif = 2;
		end
	elseif GetNumSubgroupMembers() > 0 then
		SysDif = GetDungeonDifficulty();
		if not SysDif then return 0;end
		if SysDif == 1 then
			EQDif = 1;
		else
			EQDif = 2;
		end
	end
	return EQDif;
end

-------------
-- 反和谐大脚的和谐
local oldSendChatMessage = SendChatMessage;
local dw2hx = {
	["多玩"] = "多·玩",
	["魔盒"] = "魔·盒",
	["盒子"] = "盒·子",
	["duowan"] = "duo-wan",
	["wowbox"] = "wow-box",
};

function SendChatMessage(msg, ...)
	local chatType, language, channel = ...;
	local msg = msg:gsub("多玩魔盒", "多·玩·魔·盒");
	for k, v in pairs(dw2hx) do
		msg = msg:gsub(k, v);
	end

	if (chatType and chatType == "WHISPER") then
		channel = channel:gsub("·", "");
	end
	oldSendChatMessage(msg, chatType, language, channel);
end

-------------
-- 拍卖行
function dwFixAuctionFrame()		
	AuctionFrame:SetAttribute("UIPanelLayout-earea", false);
	local oldSetAttribute = AuctionFrame.SetAttribute;
	hooksecurefunc(AuctionFrame, "SetAttribute", function(self, arg1, value)
		if (arg1 == "UIPanelLayout-area" and AuctionFrame:GetAttribute("UIPanelLayout-area")) then
			oldSetAttribute(self, "UIPanelLayout-area", false);
		end		
	end)	
end
tinsert(UISpecialFrames, "AuctionFrame");
dwAsynCall("Blizzard_AuctionUI", "dwFixAuctionFrame");

----------------------
-- 修复战斗记录溢出问题
do
local frame = CreateFrame("Frame");
frame.time = 0;
frame:SetScript("OnUpdate", function(self, elapsed)
	self.time = self.time + elapsed;
	if (self.time > 300) then
		self.time = 0;
		CombatLogClearEntries();
	end
end);
end
--------------
-- getglobal

function getglobal(name)
	return _G[name];
end
----------------------
-- DK 符文条
do
local AddOns = {"RuneHUD", "MagicRunes", "RuneWatch", "XPerl"};
local hasAddOn = false;
function dwRuneFrameHasOtherAddOn()
	local name, title, notes, enabled;
	if (hasAddOn) then
		return true;
	end
	for k, n in pairs(AddOns) do
		name, title, notes, enabled = GetAddOnInfo(n);
		if (name and enabled) then
			hasAddOn = true;
			return true;
		end
	end

	return false;
end

function dwUpdateRuneFrame()
	local _,class = UnitClass("player");
	if (class~="DEATHKNIGHT" or dwRuneFrameHasOtherAddOn()) then
		return;
	end
	local value = dwRawGetCVar("DuowanConfig", "isRuneFrameMove", 0);
	local scale = dwRawGetCVar("DuowanConfig", "RuneFrameScale", 1);
	dwSetScale(RuneFrame, scale);
	if (value == 0) then		
		if (PetFrame:IsVisible()) then			
			RuneFrame:ClearAllPoints();
			RuneFrame:SetPoint("TOP","PetFrame","BOTTOM", 25, 4);
		else
			RuneFrame:ClearAllPoints();
			RuneFrame:SetPoint("TOP", "PlayerFrame","BOTTOM", 90, 15);
		end
	else
		local pos = dwRawGetCVar("DuowanConfig", "RuneFramePos", nil);
		if (pos and type(pos) == "table" and not RuneFrame.isMoving) then
			RuneFrame:ClearAllPoints();
			RuneFrame:SetPoint(unpack(pos));
		end
	end
end
end

-----------------
-- 圣骑士豆豆条
do
function dwUpdatePaladinPowerFrame()
	if (select(2, UnitClass("player"))~="PALADIN") then
		return;
	end

	local value = dwRawGetCVar("DuowanConfig", "isPaladinFrameMove", 0);
	local scale = dwRawGetCVar("DuowanConfig", "PaladinFrameScale", 1);
	dwSetScale(PaladinPowerBar, scale);
	if (value == 2) then
		PaladinPowerBar:ClearAllPoints();
		if (EUF_PlayerFrameXPBar and EUF_PlayerFrameXPBar:IsVisible()) then			
			PaladinPowerBar:SetPoint("TOP", "PlayerFrame", "BOTTOM", 85, 22);
		else
			PaladinPowerBar:SetPoint("TOP", "PlayerFrame", "BOTTOM", 43, 39);
		end
		PaladinPowerBarBG:SetTexture("Interface\\PlayerFrame\\PaladinPowerTextures");
		PaladinPowerBarBG:SetTexCoord(0.00390625, 0.53515625, 0.32812500, 0.63281250);
		PaladinPowerBarGlowBGTexture:SetTexture("Interface\\PlayerFrame\\PaladinPowerTextures");
		PaladinPowerBarGlowBGTexture:SetTexCoord(0.00390625, 0.53515625, 0.00781250, 0.31250000);
	else
		local pos = dwRawGetCVar("DuowanConfig", "PaladinFramePos", nil);
		if (pos and type(pos) == "table" and not PaladinPowerBar.isMoving) then
			PaladinPowerBar:ClearAllPoints();
			PaladinPowerBar:SetPoint(unpack(pos));

			PaladinPowerBarBG:SetTexture("Interface\\AddOns\\Duowan\\textures\\PaladinPowerNormal");
			PaladinPowerBarBG:SetTexCoord(0.00390625, 0.53515625, 0.32812500, 0.63281250);
			PaladinPowerBarGlowBGTexture:SetTexture("Interface\\AddOns\\Duowan\\textures\\PaladinPowerGlow");
			PaladinPowerBarGlowBGTexture:SetTexCoord(0.00390625, 0.53515625, 0.32812500, 0.63281250);
		end
	end
end
end

----------------------
-- 小德日月蚀条
do
local AddOns = {};
local hasAddOn = false;

function dwEclipseBarHasOtherAddOn()
	local name, title, notes, enabled;
	if (hasAddOn) then
		return true;
	end
	for k, n in pairs(AddOns) do
		name, title, notes, enabled = GetAddOnInfo(n);
		if (name and enabled) then
			hasAddOn = true;
			return true;
		end
	end

	return false;
end

function dwUpdateEclipseBarFrame()
	local _,class = UnitClass("player");
	if (class~="DRUID" or dwEclipseBarHasOtherAddOn()) then
		return;
	end
	local value = dwRawGetCVar("DuowanConfig", "isEclipseBarFrameMove", 0);
	local scale = dwRawGetCVar("DuowanConfig", "EclipseBarFrameScale", 1);
	dwSetScale(EclipseBarFrame, scale);
	if (value == 0) then
		EclipseBarFrame:ClearAllPoints();
		EclipseBarFrame:SetPoint("TOP", "PlayerFrame","BOTTOM", 90, 15);
	else
		local pos = dwRawGetCVar("DuowanConfig", "EclipseBarFramePos", nil);
		if (pos and type(pos) == "table" and not EclipseBarFrame.isMoving) then
			EclipseBarFrame:ClearAllPoints();
			EclipseBarFrame:SetPoint(unpack(pos));
		end
	end
end
end
---------------
-- baseAlpha错误

--WatchFrame_SetBaseAlpha (1);

---------------
-- 使聊天栏可交互
do
	for i=1, 10 do
		local chatFrame = _G["ChatFrame"..i];
		FCF_SetUninteractable(chatFrame, false);
	end
	
	hooksecurefunc("FloatingChatFrame_Update", function (id, onUpdateEvent)
		local chatFrame = _G["ChatFrame"..id];
		FCF_SetUninteractable(chatFrame, false);
	end);
end

------------------
-- 屏蔽大脚世界频道进进出出的消息
--ChatFrame_RemoveMessageGroup(ChatFrame1, "CHANNEL")

------------------
-- 调高连接点图层
--ComboFrame:SetFrameStrata("HIGH");
ComboFrame:SetFrameLevel(ComboFrame:GetFrameLevel()+5);
------------------
-- 开启全屏泛光特效(DX11关闭该效果会导致黑屏)
--SetCVar("ffxGlow", 1);	
--SetCVar("ffxDeath", 0);
--------------------
-- 创建原来的大地图按钮
--[[do
	local button = CreateFrame("Button", "dwMiniMapWorldMapButton", Minimap, "MiniMapButtonTemplate");
	button:SetWidth(33);
	button:SetHeight(33);
	button:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", -10, -1);
	button:SetFrameLevel(button:GetFrameLevel()+5);
	button.icon = button:CreateTexture("dwMiniMapWorldMapButtonIcon", "BORDER");
	button.icon:SetWidth(20);
	button.icon:SetHeight(20);
	button.icon:SetPoint("CENTER", button, "CENTER", -2, 2);
	button.icon:SetTexture("Interface\\WorldMap\\UI-World-Icon");
	button.border = button:CreateTexture("dwMiniMapWorldBorder", "OVERLAY");
	button.border:SetHeight(52);
	button.border:SetWidth(52);
	button.border:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0);
	button.border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder");
	button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight", "ADD");
	button:SetScript("OnClick", function(self, button) 
		ToggleFrame(WorldMapFrame);
	end);

	button.tooltipText = MicroButtonTooltipText(WORLDMAP_BUTTON, "TOGGLEWORLDMAP");
	button.newbieText = NEWBIE_TOOLTIP_WORLDMAP;
	button:RegisterEvent("UPDATE_BINDINGS");
	
	button:SetScript("OnEnter", function(self) 
		GameTooltip_AddNewbieTip(self, self.tooltipText, 1.0, 1.0, 1.0, self.newbieText);
	end);
	button:SetScript("OnLeave", function(self) 
		GameTooltip_Hide();
	end);
	button:SetScript("OnEvent", function(self, event) 
		self.tooltipText = MicroButtonTooltipText(WORLDMAP_BUTTON, "TOGGLEWORLDMAP");
			self.newbieText = NEWBIE_TOOLTIP_WORLDMAP;
	end);
end
]]
----------------------------
-- 公会标签
do
	local tab = CreateFrame("Button", "FriendsFrameTab5", FriendsFrame, "FriendsFrameTabTemplate");
	tab:SetText(GUILD);
	tab:SetID(5);
	tab:SetScript("OnClick", function(self)
		local id = PanelTemplates_GetSelectedTab(FriendsFrame);
		PanelTemplates_Tab_OnClick(self, FriendsFrame);
		ToggleGuildFrame();
		PanelTemplates_SetTab(FriendsFrame, id)
	end);
	tab:SetPoint("LEFT", "FriendsFrameTab4", "RIGHT", -15, 0);
	PanelTemplates_SetNumTabs(FriendsFrame, 5);
	PanelTemplates_UpdateTabs(FriendsFrame);
end

------------------------------------------------
-- 幻化装备操作提示
do
	function dwOnItemAlterationFirstRun()
		local value = dwRawGetCVar("DuowanConfig", "ItemAlterationTurist", 0);
		if (value == 1) then return end

		local frame = CreateFrame("Frame", "ItemAlterationHelpBox", TransmogrifyFrame, "GlowBoxTemplate");
		frame:SetSize(190, 150);
		frame:SetPoint("BOTTOMLEFT", TransmogrifyFrame, "BOTTOMLEFT", 75,100);
		frame:SetFrameLevel(frame:GetFrameLevel() + 5);
		
		frame.title = frame:CreateFontString("TransmogrifyFrameBigText", "ARTWORK", "GameFontHighlight");
		frame.title:SetSize(176, 0);
		frame.title:SetPoint("TOP", frame, "TOP", 0, -12);
		frame.title:SetText(DUOWAN_WOWBOX_NOTICE);
		frame.text = frame:CreateFontString("TransmogrifyFrameSmallText", "ARTWORK", "GameFontHighlightSmall");
		frame.text:SetSize(176, 0);
		frame.text:SetPoint("TOP", frame.title, "BOTTOM", 0, -12);
		frame.text:SetText(DUOWAN_WOWBOX_HUANHUA);
		
		frame.arrow = CreateFrame("Frame", "TransmogrifyFrameArrow", frame, "GlowBoxArrowTemplate");
		frame.arrow:SetPoint("TOP", frame, "BOTTOM", 0, 1);
		frame.btn = CreateFrame("Button", "TransmogrifyFrameButton", frame, "UIPanelButtonTemplate2");
		frame.btn:SetSize(110, 22);
		frame.btn:SetPoint("BOTTOM", frame, "BOTTOM", 0, 12);
		frame.btn:SetText(OKAY);
		frame.btn:SetScript("OnClick", function(self, button)
			PlaySound("igMainMenuOptionCheckBoxOn");
			dwSetCVar("DuowanConfig", "ItemAlterationTurist", 1);
			frame:Hide();
		end);

	end	

	dwAsynCall("Blizzard_ItemAlterationUI", "dwOnItemAlterationFirstRun");
end

----------------------------------
-- 载入公会插件
do
--LoadAddOn("Blizzard_Calendar");
local frame = CreateFrame("Frame");
frame:RegisterEvent("PLAYER_LOGIN");
frame:SetScript("OnEvent", function ()
	dwDelayCall("LoadAddOn", 2, "Blizzard_GuildUI");
end)
end

----------------------------------
-- Tooltip不消失的BUG
local function GameTooltip_FadeOut(self)
	dwFadeOut(self, 0.3, 1.0, 1.0);	
end

--GameTooltip.FadeOut = GameTooltip_FadeOut;
--hooksecurefunc(GameTooltip, "FadeOut", GameTooltip_FadeOut);
----------------------------------
-- 武僧兼容
if (not _G.LOCALIZED_CLASS_NAMES_MALE["MONK"]) then
	if (GetLocale() == "zhCN") then
		_G.LOCALIZED_CLASS_NAMES_MALE["MONK"] = "武僧"
	elseif(GetLocale() == "zhTW") then
		_G.LOCALIZED_CLASS_NAMES_MALE["MONK"] = "武僧"
	else
		_G.LOCALIZED_CLASS_NAMES_MALE["MONK"] = "MONK"
	end	
end
----------------------------------
-- 兼容久函数
--[[
GetNumPartyMembers = GetNumSubgroupMembers;
GetRealNumPartyMembers  = GetNumSubgroupMembers;
UnitIsPartyLeader = UnitIsGroupLeader;

UnitIsRaidOfficer = UnitIsGroupAssistant;
GetNumRaidMembers = GetNumGroupMembers;
GetRealNumRaidMembers = GetNumGroupMembers;

GetActiveTalentGroup = GetActiveSpecGroup;
SetActiveTalentGroup = SetActiveSpecGroup;
GetNumTalentGroups = GetNumSpecGroups;
GetPrimaryTalentTree = GetSpecialization;
GetUnspentTalentPoints = GetNumUnspentTalents;
GetNumTalentTabs = GetNumSpecializations;
GetTalentTabInfo = GetSpecializationInfo;
GetTalentTreeRoles = GetSpecializationRole;
]]
IsPartyLeader = function(unit)
	local unit = unit or "player";
	return UnitIsGroupLeader(unit);
end

IsRaidLeader = function(unit)
	local unit = unit or "player";
	return UnitIsGroupLeader(unit);
end

IsRaidOfficer = function(unit)
	local unit = unit or "player"
	return UnitIsGroupAssistant(unit);
end;

---------------------------------------------
-- 创建一个重载按钮, 变相解决无法切换雕文问题
function dwFixRemoveTalent()
	-- 创建重载按钮
	local button = CreateFrame("Button", "dwTalentReloadButton", PlayerTalentFrame, "UIPanelButtonTemplate");
	button:SetSize(90, 25);
	button:SetText(DUOWAN_WOWBOX_RELOADUI);
	button:SetPoint("BOTTOMLEFT", PlayerTalentFrame, "BOTTOMRIGHT", -200, 3);
	button:SetScript("OnClick", function(this)
		dwReloadUI();
	end);
	button:SetScript("OnEnter", function(this)
		GameTooltip:SetOwner(this, "ANCHOR_BOTTOM", 42, -10);
		GameTooltip:SetText(DUOWAN_WOWBOX_RELOADUI);
		GameTooltip:AddLine(DUOWAN_WOWBOX_RELOADUI_TIPS, 1.0, 1.0, 1.0);
		GameTooltip:Show();
	end);
	button:SetScript("OnLeave", function(this)
		GameTooltip:Hide();
	end);

	-- 创建提示信息
	local value = dwRawGetCVar("DuowanConfig", "FixRemoveTalentTurist", 0);
	if (value == 1) then return end

	local frame = CreateFrame("Frame", "FixRemoveTalentTuristHelpBox", PlayerTalentFrame, "GlowBoxTemplate");
	frame:SetSize(190, 150);
	frame:SetPoint("BOTTOM", dwTalentReloadButton, "TOP", 0, 14);
	frame:SetFrameLevel(frame:GetFrameLevel() + 5);
	
	frame.title = frame:CreateFontString("FixRemoveTalentTuristBigText", "ARTWORK", "GameFontHighlight");
	frame.title:SetSize(176, 0);
	frame.title:SetPoint("TOP", frame, "TOP", 0, -12);
	frame.title:SetText(DUOWAN_WOWBOX_NOTICE);
	frame.text = frame:CreateFontString("FixRemoveTalentTuristSmallText", "ARTWORK", "GameFontHighlightSmall");
	frame.text:SetSize(176, 0);
	frame.text:SetPoint("TOP", frame.title, "BOTTOM", 0, -12);
	frame.text:SetText(DUOWAN_WOWBOX_RELOADUI_TIPS);
	
	frame.arrow = CreateFrame("Frame", "FixRemoveTalentTuristArrow", frame, "GlowBoxArrowTemplate");
	frame.arrow:SetPoint("TOP", frame, "BOTTOM", 0, 1);
	frame.btn = CreateFrame("Button", "FixRemoveTalentTuristButton", frame, "UIPanelButtonTemplate");
	frame.btn:SetSize(110, 22);
	frame.btn:SetPoint("BOTTOM", frame, "BOTTOM", 0, 12);
	frame.btn:SetText(CLOSE);
	frame.btn:SetScript("OnClick", function(self, button)
		PlaySound("igMainMenuOptionCheckBoxOn");
		dwSetCVar("DuowanConfig", "FixRemoveTalentTurist", 1);
		frame:Hide();
	end);
end

dwAsynCall("Blizzard_TalentUI", "dwFixRemoveTalent");

------------------------------
-- 缺省关掉冷却计时条
do
if (dwIsConfigurableAddOn("BMHelper") and select(2, UnitClass("player")) == "MONK") then
	-- 缺省禁用冷却计时条
	function dwFirsetHideCoolLine()
		local value = dwRawGetCVar("DuowanConfig", "disableCoolLine", 0);
		if (value == 0) then
			if (IsAddOnLoaded("tdCooldown2")) then
				CoolLine_Toggle(false);
			end
			dwSetCVar("Action Button", "EnableCoolLine", 0);
			dwSetCVar("DuowanConfig", "disableCoolLine", 1);
		end
	end
	dwAsynCall("tdCooldown2", "dwFirsetHideCoolLine");
end
end

do	
	-- 低等级玩家缺省显示任务指引
	local function CheckQuestHelper()
		local firstLoad = dwRawGetCVar("DuowanConfig", "QuestHelperFirstLoad", 0);
		local enableValue = dwRawGetCVar("QuestMod", "QuestHelperLiteEnable", 0);	
		if (firstLoad == 0) then		
			if (enableValue == 0) then
				local level = UnitLevel("player")
				local enableValue = (level < 90) and 1 or 0			
				dwSetCVar("QuestMod", "QuestHelperLiteEnable", enableValue)
				dwLoadAddOn("QuestHelperLite");
			end
			dwSetCVar("DuowanConfig", "QuestHelperFirstLoad", 1)
		end

		return enableValue
	end

	-----------------------------------
	-- 显示敌对目标的debuff
	local function CheckEnemyDebuff()
		local value = dwRawGetCVar("DuowanConfig", "showAllEnemyDebuffs", 0);		
		if (value == 0) then
			SetCVar("showAllEnemyDebuffs", "1");
			dwSetCVar("DuowanConfig", "showAllEnemyDebuffs", 1);
		end
	end

	----------------------------------
	-- 禁用语言过滤器
	local function CheckSocialFilter()
		local value = dwRawGetCVar("DuowanConfig", "disableFilter", 0);
		if (value == 0) then
			SetCVar("profanityFilter", "0");
			dwSetCVar("DuowanConfig", "disableFilter", 1);
		end
		InterfaceOptionsSocialPanelProfanityFilter:Enable();
	end

	local EVENT_FRAME = CreateFrame("Frame")
	EVENT_FRAME:RegisterEvent("PLAYER_LOGIN")
	EVENT_FRAME:SetScript("OnEvent", function(self, event, ...)			
		CheckQuestHelper()
		CheckEnemyDebuff()
		CheckSocialFilter()
	end)
end