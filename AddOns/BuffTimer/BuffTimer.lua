------------------------------------------------------------------------------------------
-- BuffTimer ver 1.0
-- 日期: 2010-3-31
-- 作者: dugu@bigfoot
-- 描述: 显示玩家Buff的详细时间, 无时间的显示N/A. 显示武器buff次数.
-- 版权所有 (c) duowan.com
-------------------------------------------------------------------------------------------

local BuffTimer = LibStub("AceAddon-3.0"):NewAddon("BuffTimer", "AceHook-3.0");
local B = BuffTimer;
local _G = _G;
B.enable = false;
B.displayCaster = false;
B.displayMountSource = true;
local L = {};
--local MountsDB = {};
if (GetLocale() == "zhCN") then
	L["施法者:"] = "施法者: "
	L["Achivment"] = "坐骑来源(成就):"
	L["Drop"] = "坐骑来源:"
	L["Sold"] = "坐骑来源(声望):"
--	MountsDB = MountsDBCN
elseif (GetLocale() == "zhTW") then
	L["施法者:"] = "施法者: "
	L["Achivment"] = "坐騎來源(成就):"
	L["Drop"] = "坐騎來源(首領):"
	L["Sold"] = "坐騎來源(聲望):"
--	MountsDB = MountsDBTW
else
	L["施法者:"] = "caster: "
	L["Achivment"] = "坐骑来源(成就):"
	L["Drop"] = "坐骑来源:"
	L["Sold"] = "坐骑来源(声望):"
--	MountsDB = {}
end

function B:OnInitialize()
	self:SecureHook("AuraButton_UpdateDuration");
	self:SecureHook("AuraButton_Update");
	self:SecureHook("TempEnchantButton_OnUpdate");
	--self:RawHook("FocusFrame_UpdateAuras", true);
	-- self:RawHook("Focus_Spellbar_AdjustPosition", true);
end

function B:GetFormatText(seconds)
	local tempTime, second;
	if (seconds) then
		if (seconds >= 86400) then
			tempTime = ceil(seconds / 86400);
			return format(DAY_ONELETTER_ABBR, tempTime);
		elseif (seconds >= 3600) then
			tempTime = ceil(seconds / 3600);
			return format(HOUR_ONELETTER_ABBR, tempTime);
		elseif (seconds >= 600) then
			tempTime = ceil(seconds / 60);
			return format(MINUTE_ONELETTER_ABBR, tempTime);
		else
			tempTime = floor(seconds / 60);
			second = seconds - tempTime * 60;
			return format("%2d:%02d", tempTime, second);
		end
	end
end

-- 显示详细时间
function B:AuraButton_UpdateDuration(auraButton, timeLeft)
	-- 让系统自己的duration不可见
	local duration = _G[auraButton:GetName().."Duration"];
	if (B.enable)then
		duration:SetAlpha(0);
	else
		duration:SetAlpha(1.0);
	end

	-- 创建并显示时间
	local timerName = auraButton:GetName().."LeftTimer"
	local timer = _G[timerName];
	if (not timer) then
		timer = auraButton:CreateFontString(timerName, "BACKGROUND", "GameFontNormalSmall");
		timer:SetPoint("TOP", auraButton, "BOTTOM");
	end

	if (B.enable and timeLeft) then
		timer:SetText(self:GetFormatText(timeLeft));
		if (timeLeft < BUFF_WARNING_TIME) then
			timer:SetVertexColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b);
		elseif ( timeLeft < BUFF_DURATION_WARNING_TIME ) then
			timer:SetVertexColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
		else
			timer:SetVertexColor(GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b);
		end
		timer:Show();
	else
		timer:Hide();
	end
end

-- 显示"N/A"
function B:AuraButton_Update(buttonName, _index, filter)
	local buffName = buttonName.._index;
	local buff = _G[buffName];
	local buffDuration;
	if (buff) then
		buffDuration = _G[buffName.."Duration"];
		if (B.enable) then
			buffDuration:SetAlpha(0);
		else
			buffDuration:SetAlpha(1);
		end

		local unit = PlayerFrame.unit;
		local timerName = buff:GetName().."LeftTimer"
		local timer = _G[timerName];
		if (not timer) then
			timer = buff:CreateFontString(timerName, "BACKGROUND", "GameFontNormalSmall");
			timer:SetPoint("TOP", buff, "BOTTOM");
		end

		local name, rank, texture, count, debuffType, duration, expirationTime = UnitAura(unit, _index, filter);
		if (B.enable and name and (not expirationTime or expirationTime == 0)) then
			timer:Show();
			timer:SetText("|cff00ff00N/A|r");
		else
			timer:Hide();
		end
	end
end

-- 显示次数
function B:TempEnchantButton_OnUpdate(self, elapsed)
	local hasMainHandEnchant, mainHandExpiration, mainHandCharges, hasOffHandEnchant, offHandExpiration, offHandCharges = GetWeaponEnchantInfo();
	if ( hasOffHandEnchant ) then
		if (B.enable and offHandCharges > 0) then
			TempEnchant1Count:SetText("|cff00ff00"..offHandCharges.."|r");
			TempEnchant1Count:Show();
		else
			TempEnchant1Count:Hide();
		end
	end
	if ( hasMainHandEnchant ) then
		if (B.enable and mainHandCharges > 0) then
			TempEnchant2Count:SetText("|cff00ff00"..mainHandCharges.."|r");
			TempEnchant2Count:Show();
		else
			TempEnchant2Count:Hide();
		end
	end
end

------------------------
-- 调整Buff大小
local NUM_TOT_AURA_ROWS=3;
local AURA_ROW_WIDTH=125;
local EUF_MYBUFF_SIZE, EUF_OTHERBUFF_SIZE = 23, 17;
local Enable_AdjustBuffSize = false;
function EUF_ToggleAdjustBuffSize(toggle)
	if toggle then
		Enable_AdjustBuffSize = true;
	else
		Enable_AdjustBuffSize = false;
	end

	TargetFrame_UpdateAuras(TargetFrame);
end

function EUF_SetAdjustBuffSize(size)
	EUF_MYBUFF_SIZE = size;
	TargetFrame_UpdateAuras(TargetFrame);
end

function B:TargetFrame_UpdateAuraPositions(this, auraName, numAuras, numOppositeAuras, largeAuraList, updateFunc, maxRowWidth, offsetX)
	if ((dwToTFrame and this:GetName() == "TargetFrame") or (dwFocusToTFrame and this:GetName() == "FocusFrame")) then
		maxRowWidth = (dwToTFrame:IsShown() and this.TOT_AURA_ROW_WIDTH) or maxRowWidth;
	end

	if (not Enable_AdjustBuffSize) then
		self.hooks.TargetFrame_UpdateAuraPositions(this, auraName, numAuras, numOppositeAuras, largeAuraList, updateFunc, maxRowWidth, offsetX);
	else
		local AURA_OFFSET_Y=EUF_MYBUFF_SIZE-EUF_OTHERBUFF_SIZE;
		local size;
		local offsetY = AURA_OFFSET_Y;
		local rowWidth = 0;
		local firstBuffOnRow = 1;
		for i=1, numAuras do
			if ( largeAuraList[i] ) then
				size = EUF_MYBUFF_SIZE;
			else
				size = EUF_OTHERBUFF_SIZE;
			end

			if ( i == 1 ) then
				rowWidth = size;
				this.auraRows = this.auraRows + 1;
			else
				rowWidth = rowWidth + size + offsetX;
			end

			if ( rowWidth > maxRowWidth ) then
				updateFunc(this, auraName, i, numOppositeAuras, firstBuffOnRow, size, offsetX, offsetY);
				rowWidth = size;
				this.auraRows = this.auraRows + 1;
				firstBuffOnRow = i;
				offsetY = AURA_OFFSET_Y;
				if ( this.auraRows > NUM_TOT_AURA_ROWS ) then
					maxRowWidth = AURA_ROW_WIDTH;
				end
			else
				updateFunc(this, auraName, i, numOppositeAuras, i - 1, size, offsetX, offsetY);
			end
		end
	end
end

B:RawHook("TargetFrame_UpdateAuraPositions", true);

----------------------------------------------------
-- 显示谁施放的该法术
local a, b, d = _G.GameTooltip.SetUnitAura, _G.GameTooltip.SetUnitBuff, _G.GameTooltip.SetUnitDebuff;
local function getClassColor(class)
	local colorHex = "ffffff";
	local RC = RAID_CLASS_COLORS[class];
	if (RC) then
		colorHex = ("%02x%02x%02x"):format(RC.r*255, RC.g*255, RC.b*255);
	end
	return colorHex;
end

local function HookBuffCaster(o, ...)
	if (not B.displayCaster) then return end

	local _, uid, id, f = ...;
	if o == b then
		f = "HELPFUL " .. (f or "");
	elseif o == d then
		f = "HARMFUL " .. (f or "");
	end
	local _, _, _, _, _, _, _, casterUnit = UnitAura(uid, id, f);
	local classEN, str
	if(casterUnit) then
		if not UnitIsPlayer(casterUnit) and UnitPlayerControlled(casterUnit) then
			local n;
			_, n = UnitVehicleSeatInfo(casterUnit, 1);
			if n then
				_, classEN = UnitClass(n);
				str=("|cff%s%s|r"):format(getClassColor(classEN), n);

				_, n = UnitVehicleSeatInfo(casterUnit, 2);
				if n then
					_, cl = UnitClass(n);
					str=str.." & "..("|cff%s%s|r"):format(getClassColor(classEN), n);
				end
			else
				local playerClass, n2;
				if casterUnit=="pet" then
					_, classEN=UnitClass(casterUnit);
					_, playerClass=UnitClass("player");
					n, n2 = UnitName(casterUnit), UnitName("player");
				elseif string.sub(casterUnit,1,8)=="partypet" then
					id = string.sub(casterUnit, 9);
					_, classEN=UnitClass(casterUnit);
					_, playerClass=UnitClass("party"..id);
					n, n2 = UnitName(casterUnit), UnitName("party"..id);
				elseif string.sub(casterUnit,1,7)=="raidpet" then
					id = string.sub(casterUnit, 8);
					_, classEN=UnitClass(casterUnit);
					_, playerClass=UnitClass("raid"..id);
					n, n2 = UnitName(casterUnit), UnitName("raid"..id);
				end
				if(classEN) then
					str=("|cff%s%s|r (|cff%s%s|r)"):format(getClassColor(classEN), n, getClassColor(cl2), n2);
				else
					_, classEN = UnitClass(casterUnit);
					str = ("|cff%s%s|r"):format(getClassColor(classEN), UnitName(casterUnit));
				end
			end
		else
			_, classEN = UnitClass(casterUnit);
			str = ("|cff%s%s|r"):format(getClassColor(classEN), UnitName(casterUnit));
		end
	end
	if(str) then
		GameTooltip:AddLine(L["施法者:"]..str);
		GameTooltip:Show();
	end
end

-----------------------------
-- 坐骑来源
-- local function MountsDBReader(SpellId)
	-- local itemId,drops,achivment,sold_by,sold_name,drop_name,instance_name
	-- for i ,k in pairs(MountsDB) do
		-- if k[1] == SpellId then
			-- -- print(k)
			-- itemId = k[4]
			-- drops = k[7]
			-- drop_name = k[10]
			-- achivment = k[8]
			-- sold_by = k[9]
			-- sold_name = k[12]
			-- instance_name = k[13]
			-- return itemId,drops,achivment,sold_by,drop_name,sold_name,instance_name
		-- end
	-- end
-- end

local function GetMountInfo(SpellId)
	for i = 1, C_MountJournal.GetNumMounts() do
		local creatureName, spellID, icon, active, isUsable, sourceType, isFavorite, isFactionSpecific, faction, hideOnChar, isCollected = C_MountJournal.GetMountInfo(i)
		if spellID == SpellId then
			local creatureDisplayID, descriptionText, sourceText, isSelfMount = C_MountJournal.GetMountInfoExtra(i)
			return sourceText, isCollected
		end
	end

	-- local itemId,drops,achivment,sold_by,drop_name,sold_name,instance_name= MountsDBReader(SpellId)
	-- local ach,args,text
	-- if itemId then
		-- -- print(itemId,drops,achivment,sold_by,sold_name,drop_name )
		-- if achivment~="0" then
			-- args, ach = GetAchievementInfo(achivment)
			-- text = L["Achivment"] .. ach
			-- return text
		-- end

		-- if drops~="0" and drop_name~="0"  then
			-- if instance_name~="0" then
				-- text = L["Drop"] .. instance_name .. "-" .. drop_name
			-- else
				-- text = L["Drop"] .. drop_name
			-- end
			-- return text
		-- end

		-- if sold_by~="0" and sold_name~="0" then
			-- text = L["Sold"] .. sold_name
			-- return text
		-- end
	-- end
end

local function HookTargetMounts(o, ...)
	if (not B.displayMountSource) then return end

	local _, uid, id, f = ...;
	if o == b then
		f = "HELPFUL " .. (f or "");
	elseif o == d then
		f = "HARMFUL " .. (f or "");
	end
	local id = select(11,UnitAura(uid, id, f))
	if id then
		local text, isCollected = GetMountInfo(id)
		if text then
			GameTooltip:AddLine(L["Drop"])
			if isCollected then
				GameTooltip:AddLine(text, GREEN_FONT_COLOR.r, GREEN_FONT_COLOR.g, GREEN_FONT_COLOR.b)
			else
				GameTooltip:AddLine(text, RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
			end
			GameTooltip:Show()
		end
	end
end

hooksecurefunc(GameTooltip, "SetUnitAura", function(...)
	HookBuffCaster(a, ...);
	HookTargetMounts(a, ...);
end);
hooksecurefunc(GameTooltip, "SetUnitBuff", function(...)
	HookBuffCaster(b, ...);
	HookTargetMounts(b, ...);
end);
hooksecurefunc(GameTooltip, "SetUnitDebuff", function(...)
	HookBuffCaster(d, ...);
	HookTargetMounts(d, ...);
end);

function BuffTimer_Toggle(switch)
	if (switch) then
		SetCVar("buffDurations", "1");
		B.enable = true;
	else
		B.enable = false;
	end
	--BuffFrame_Update();
end

function buffTimer_ToggleBuffSize(switch)
	if (switch) then
		EUF_ToggleAdjustBuffSize(true);
	else
		EUF_ToggleAdjustBuffSize(false);
	end
end

function BuffTimer_DisplayCasterToggle(switch)
	if (switch) then
		B.displayCaster = true;
	else
		B.displayCaster = false;
	end
end

function BuffTimer_DisplayMountSource(switch)
	if (switch) then
		B.displayMountSource = true;
	else
		B.displayMountSource = false;
	end
end