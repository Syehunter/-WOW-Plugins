----------------------------------------------------------------------
-- 名称：BattlePetTooltip
-- 作者：wowbox
-- 日期：2012-11-01
-- 描述：自定义 一个小宠物对战的tip
-- 多玩游戏网 （c）版权所有
----------------------------------------------------------------------

dwBattlePetTooltip = LibStub("AceAddon-3.0"):NewAddon("BattlePetTooltip", "AceHook-3.0", "AceEvent-3.0");
local BattlePetTooltip = dwBattlePetTooltip;

function BattlePetTooltip:OnInitialize()
	self.tooltip = CreateFrame("Frame", "dwBattlePetTooltip", UIParent, "BattlePetTooltipTemplate");
	self.tooltip:SetHeight(130);
	self.data = {};
	self.owner = nil;
	self.anchor = nil;
	self.cx = 0;
	self.cy = 0;	
	self.isCursor = false;
end

function BattlePetTooltip:OnEnable()
	
end

function BattlePetTooltip:OnDisable()
	
end

function BattlePetTooltip:SetOwner(owner, anchor, x, y)
	if (not owner) then return end

	self.cx = x or 0;
	self.cy = y or 0;
	self.owner = owner;
	self.anchor = anchor or "ANCHOR_CURSOR";
	
	self.tooltip:ClearAllPoints();
	self.isCursor = false;
	if (anchor == "ANCHOR_TOPRIGHT") then
		self.tooltip:SetPoint("BOTTOMRIGHT", self.owner, "TOPRIGHT", self.cx, self.cy);
	elseif (anchor == "ANCHOR_RIGHT") then
		self.tooltip:SetPoint("BOTTOMLEFT", self.owner, "TOPRIGHT", self.cx, self.cy);
	elseif (anchor == "ANCHOR_BOTTOMRIGHT") then
		self.tooltip:SetPoint("TOPLEFT", self.owner, "BOTTOMRIGHT", self.cx, self.cy);
	elseif (anchor == "ANCHOR_TOPLEFT") then
		self.tooltip:SetPoint("BOTTOMLEFT", self.owner, "TOPLEFT", self.cx, self.cy);
	elseif (anchor == "ANCHOR_LEFT") then
		self.tooltip:SetPoint("BOTTOMRIGHT", self.owner, "TOPLEFT", self.cx, self.cy);
	elseif (anchor == "ANCHOR_BOTTOMLEFT") then
		self.tooltip:SetPoint("TOPRIGHT", self.owner, "BOTTOMLEFT", self.cx, self.cy);
	else
		self.isCursor = true;
	end
end

function BattlePetTooltip:SetPoint(...)
	self.tooltip:SetPoint(...);
end

function BattlePetTooltip:SetHyperlink(link)
	if (not link:find("|Hbattlepet")) then return end	
	local _, speciesID, level, breedQuality, maxHealth, power, speed = strsplit(":", link);
	local customName = strmatch(link, "|h%[(.+)%]|h");
	speciesID = tonumber(speciesID);
	if (speciesID and speciesID > 0) then
		local name, icon, petType = C_PetJournal.GetPetInfoBySpeciesID(speciesID);
		self.data.speciesID = speciesID;
		self.data.name = name;
		self.data.level = tonumber(level);
		self.data.breedQuality = tonumber(breedQuality);
		self.data.petType = tonumber(petType);
		self.data.maxHealth = tonumber(maxHealth);
		self.data.power = tonumber(power);
		self.data.speed = tonumber(speed);
		if (name ~= customName) then
			self.data.customName = customName;
		else
			self.data.customName = nil;
		end
		BattlePetTooltipTemplate_SetBattlePet(self.tooltip, self.data);
		self.tooltip:Show();
	end
end

function BattlePetTooltip:Show()
	self.tooltip:Show();
end

function BattlePetTooltip:Hide()
	self.tooltip:Hide();
end