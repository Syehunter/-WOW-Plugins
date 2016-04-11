---------------------------------------------------------------------
-- 文件: RaidMark.lua
-- 日期: 2011-08-31
-- 作者: dugu@wowbox
-- 描述: 给团队助理增加更直观的团队标记功能
-- 多玩游戏网 (c) 版权所有
---------------------------------------------------------------------

RaidMark = LibStub("AceAddon-3.0"):NewAddon("RaidMark", "AceEvent-3.0", "AceConsole-3.0", "AceTimer-3.0");


RaidMark.Texcoords = {
--[[
	-- 添加第五项为颜色对应的索引
	[1] = {0.75,0.875,0,0.25 ,3},	-- BLUE
	[2] = {0.25,0.375,0,0.25 ,5},	-- GREEN
	[3] = {0,0.125,0.25,0.5 ,6},	-- PURPLE
	[4] = {0.625,0.75,0,0.25 ,2},	-- RED
	[5] = {0.375,0.5,0,0.25 ,8},	-- YELLOW
	[6] = {0.375,0.5,0,0.25 ,7},	-- 橙色
	[7] = {0.375,0.5,0,0.25 ,4},	-- 银色
	[8] = {0.375,0.5,0,0.25 ,1},	-- 白色
]]	
	-- 第五项为对应的TOOLTIPS索引
	[1] = {0.5,0.625,0,0.25, 8},	-- 白(银)
	[2] = {0.625,0.75,0,0.25, 4},	-- 红
	[3] = {0.75,0.875,0,0.25, 1},	-- 蓝
	[4] = {0.5,0.625,0,0.25, 7},	-- 银(白)
	[5] = {0.25,0.375,0,0.25, 2},	-- 绿
	[6] = {0,0.125,0.25,0.5, 3},	-- 紫
	[7] = {0.25,0.375,0.25,0.5, 6},	-- 橙
	[8] = {0.375,0.5,0,0.25, 5},	-- 黄

};

function RaidMark:OnInitialize()
	self.config = {};
	self.config.show = true;
	self.config.party = true;
	self:CreateMarkFrame();

	palyerName = UnitName("player");
	curRealm = GetRealmName();
	playerFaction = UnitFactionGroup("player");		
	ident =  string.format("%s_%s_%s", curRealm, playerFaction, palyerName);
	LoveDB = LoveDB or {};
	LoveDB[ident] = LoveDB[ident] or {};
	LoveDB[ident]["RaidMark"] = LoveDB[ident]["RaidMark"] or {};
	self.db = LoveDB[ident]["RaidMark"];
	self.db.locked = self.db.locked or false;
end

function RaidMark:OnEnable()
	self:RegisterEvent("PARTY_LEADER_CHANGED", "OnEvent");
	self:RegisterEvent("GROUP_ROSTER_UPDATE", "OnEvent");
	self:RegisterEvent("PARTY_MEMBERS_CHANGED", "OnEvent");
	self:RegisterEvent("RAID_ROSTER_UPDATE", "OnEvent");
	self:RegisterEvent("PLAYER_TARGET_CHANGED", "OnEvent");
	self:RegisterEvent("PARTY_CONVERTED_TO_RAID", "OnEvent");	
	self.config.show = true;	
end

function RaidMark:OnDisable()
	self:UnregisterAllEvents();
	self.config.show = false;
	dwSecureCall(self.main.Hide, self.main);
end

function RaidMark:PartyToggle(switch)
	if (switch) then
		self.config.party = true;
	else
		self.config.party = false;
	end
	self:UpdateVisiblity();
end

function RaidMark:OnEvent(event)
	self:UpdateVisiblity();
end

function RaidMark:UpdateVisiblity()
	if (self.config.show) then
		if ((GetNumGroupMembers() > 1 and not UnitInRaid("player")) or (UnitInRaid("player") and (UnitIsGroupAssistant("player") or UnitIsGroupLeader("player")))) then			
			dwSecureCall(self.main.Show, self.main); 
		else			
			dwSecureCall(self.main.Hide, self.main);
		end
	else
		dwSecureCall(self.main.Hide, self.main); 
	end
end

function RaidMark:CreateMarkButton(index, parent)
	local button = CreateFrame("Button", "RaidMarkMainFrameButton"..index, parent, "SecureActionButtonTemplate");
	button:SetSize(20,20);
	button:SetNormalTexture("interface\\minimap\\partyraidblips");
	local tex = self.Texcoords[index];
	button:GetNormalTexture():SetTexCoord(tex[1],tex[2],tex[3],tex[4]);
	button:SetAttribute("type", "macro")
	button:SetAttribute("macrotext1", "/click CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton\n/click DropDownList1Button"..index)
	button:SetScript("OnEnter", function(this)
		GameTooltip:SetOwner(this, "ANCHOR_RIGHT"); 
		GameTooltip:ClearLines(); 
		GameTooltip:AddLine(_G["WORLD_MARKER"..tex[5]],0.88,0.65,0); 
		GameTooltip:Show();
	end);
	button:SetScript("OnLeave", function(this) 
		GameTooltip:Hide() ;
	end);
	return button;
end

function RaidMark:CreateMarkFrame()
	self.main = CreateFrame("Frame", "RaidMarkMainFrame", UIParent);
	self.main:SetSize(198,25);	

	self.main:EnableMouse(true);
	self.main:SetMovable(true);
	self.main:SetPoint("BOTTOM", UIParent, "BOTTOM", 300, 100);

	self.main.bgLeft = self.main:CreateTexture("RaidMarkMainFrameBgLeft", "BACKGROUND");
	self.main.bgLeft:SetSize(7, 32);
	self.main.bgLeft:SetPoint("TOPLEFT", self.main, "TOPLEFT", 0, 0);
	self.main.bgLeft:SetTexture("Interface\\AddOns\\Love\\textures\\dwRaidMark");
	self.main.bgLeft:SetTexCoord(0, 0.0546875, 0, 1);
	self.main.bgLeft:SetAlpha(0.2);

	self.main.bgRight = self.main:CreateTexture("RaidMarkMainFrameBgRight", "BACKGROUND");
	self.main.bgRight:SetSize(7, 32);
	self.main.bgRight:SetPoint("TOPRIGHT", self.main, "TOPRIGHT", 0, 0);
	self.main.bgRight:SetTexture("Interface\\AddOns\\Love\\textures\\dwRaidMark");
	self.main.bgRight:SetTexCoord(0.9453125, 1, 0, 1);
	self.main.bgRight:SetAlpha(0.2);

	self.main.bgCenter = self.main:CreateTexture("RaidMarkMainFrameBgCenter", "BACKGROUND");
	self.main.bgCenter:SetSize(167, 32);
	self.main.bgCenter:SetPoint("TOPLEFT", self.main.bgLeft, "TOPRIGHT", 0, 0);
	self.main.bgCenter:SetPoint("TOPRIGHT", self.main.bgRight, "TOPLEFT", 0, 0);
	self.main.bgCenter:SetTexture("Interface\\AddOns\\Love\\textures\\dwRaidMark");
	self.main.bgCenter:SetTexCoord(0.0546875, 0.9453125, 0, 1);
	self.main.bgCenter:SetAlpha(0.2);

	self.mover = CreateFrame("Button", "RaidMarkMainFrameMover", self.main, "dwRaidMarkTabTemplate");	
	self.mover:EnableMouse(true);
	self.mover:SetMovable(true);	
	self.mover:SetPoint("RIGHT", self.main, "LEFT", 0, 0);
	self.mover:SetScript("OnMouseDown", function(this, button)
		if (button=="LeftButton") then
			if (not self.db.locked) then
				self.main:StartMoving() 
			end
		elseif (button == "RightButton") then
			ToggleDropDownMenu(1, nil, self.mover.menu, "cursor", 5, -10)
		end 
	end);
	self.mover:SetScript("OnMouseUp",	function(this) 
		self.main:StopMovingOrSizing() 
	end);
	self.mover.menu = CreateFrame("Frame", "RaidMarkMainFrameMoverMenu", self.mover, "UIDropDownMenuTemplate");
	self.mover.menu:Hide();
	UIDropDownMenu_Initialize(self.mover.menu, dwRaidMarkInitMenu, "MENU");
		
	self.main.buttons = {};
	for i=1, #(self.Texcoords) do
		self.main.buttons[i] = self:CreateMarkButton(i, self.main);
		if (i == 1) then
			self.main.buttons[i]:SetPoint("TOPLEFT", self.main, "TOPLEFT", 8, -4);
		else
			self.main.buttons[i]:SetPoint("LEFT", self.main.buttons[i-1], "RIGHT", 0, 0);
		end
	end

	self.main.clear = CreateFrame("Button", "RaidMarkMainFrameClearButton", self.main, "SecureActionButtonTemplate");
	self.main.clear:SetSize(15,15)
	self.main.clear:SetNormalTexture("interface\\glues\\loadingscreens\\dynamicelements")
	self.main.clear:GetNormalTexture():SetTexCoord(0,0.5,0,0.5)
	self.main.clear:SetPoint("LEFT", self.main.buttons[8], "RIGHT",3,1)
	self.main.clear:SetAttribute("type", "macro")
	self.main.clear:SetAttribute("macrotext1", "/click CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton\n/click DropDownList1Button9")
	self.main.clear:SetScript("OnEnter", function(this) 
		GameTooltip:SetOwner(self.main, "ANCHOR_RIGHT"); 
		GameTooltip:ClearLines(); 
		GameTooltip:AddLine(REMOVE_WORLD_MARKERS,0.88,0.65,0); 
		GameTooltip:Show();
	end);
	self.main.clear:SetScript("OnLeave", function(self) 
		GameTooltip:Hide();
	end);

	dwRegisterForSaveFrame(self.main, nil, true);
end

function dwRaidMarkInitMenu(dropdownFrame, level, menu)
	local info = UIDropDownMenu_CreateInfo();
	info.notCheckable = true
	if (RaidMark.db and RaidMark.db.locked) then
		info.text = "解除锁定";
		info.func = function()
			RaidMark.db.locked = false;		
		end
	else
		info.text = "锁定位置";
		info.func = function()
			RaidMark.db.locked = true;		
		end
	end
	
	UIDropDownMenu_AddButton(info, 1);
end