-------------------
-- 自动取消豹守、误导喊话
-------------------
AntiDaze = HunterMod:NewModule("AntiDaze", "AceEvent-3.0", "AceHook-3.0");
local L = LibStub("AceLocale-3.0"):GetLocale("HunterMod");

local last_daze_info = {};

local class_Color_table={
	MAGE="69CCF0", 
	DRUID="FF7D0A",
	HUNTER="ABD473", 
	PALADIN="F58CBA", 
	PRIEST="FFFFFF",
	ROGUE="FFF569", 
	SHAMAN="2459FF", 
	WARLOCK="9482C9",
	WARRIOR="C79C6E",
	DEATHKNIGHT="C41F3B", 
} 

local groupmate = bit.bor( 
	COMBATLOG_OBJECT_AFFILIATION_MINE, 
	COMBATLOG_OBJECT_AFFILIATION_PARTY,
	COMBATLOG_OBJECT_REACTION_FRIENDLY, 
	COMBATLOG_OBJECT_CONTROL_PLAYER, 
	COMBATLOG_OBJECT_CONTROL_NPC, 
	COMBATLOG_OBJECT_TYPE_PLAYER, 
	COMBATLOG_OBJECT_TYPE_PET, 
	COMBATLOG_OBJECT_TYPE_GUARDIAN, 
	COMBATLOG_OBJECT_TYPE_OBJECT
);
 
local function UnitIsA(unitFlags, flagType) 
	if (bit.band(bit.band(unitFlags, flagType), COMBATLOG_OBJECT_AFFILIATION_MASK) > 0 and
		bit.band(bit.band(unitFlags, flagType), COMBATLOG_OBJECT_REACTION_MASK) > 0 and 
		bit.band(bit.band(unitFlags, flagType), COMBATLOG_OBJECT_CONTROL_MASK) > 0 and 
		bit.band(bit.band(unitFlags, flagType), COMBATLOG_OBJECT_TYPE_MASK) > 0) or 
		bit.band(bit.band(unitFlags, flagType), COMBATLOG_OBJECT_SPECIAL_MASK) > 0 then 
		
		return true 
	end 
	return false 
end 

function AntiDaze:IsBuffActive(name)
	local i = 1;
	local buffName = UnitBuff("player", i);
	while (buffName) do
		if (buffName == name) then
			return i; 
		end 
		i = i + 1; 
		buffName = UnitBuff("player", i);
	end 
	return 0; 
end 

function AntiDaze:AntiDaze(guid) 
	local locClass, engClass, locRace, engRace, gender, name = GetPlayerInfoByGUID(guid);
	local buffID = self:IsBuffActive(L["ASPECT_PACK"]);
	local buffName = L["ASPECT_PACK"];
	if (guid == UnitGUID("player") and (buffID == 0)) then
		name = L["You"];
		buffID = self:IsBuffActive(L["ASPECT_CHEETAH"]);
		buffName = L["ASPECT_CHEETAH"];
	end
	
	if (buffID > 0 and class_Color_table[engClass] and (not last_daze_info.time or ((GetTime()-last_daze_info.time) > 60))) then	
		-- 保存上次信息
		last_daze_info.time = GetTime();
		last_daze_info.guid = guid;
		-- 发布通告
		local text = string.format(L["AntiDaze Warning"], class_Color_table[engClass], name, class_Color_table[engClass], buffName);
		RaidNotice_AddMessage(RaidWarningFrame, text, ChatTypeInfo["RAID_WARNING"])
	end
end

--------------
-- OnX

function AntiDaze:OnModuleEnable()	
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "OnCombatEvent"); 
end

function AntiDaze:OnModuleDisable()
	self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED"); 
end

function AntiDaze:OnInitialize()	
	
end

function AntiDaze:OnCombatEvent(_, timestamp, event, _, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, ...)
	if (event == "SPELL_AURA_APPLIED" or event == "SPELL_AURA_APPLIED_DOSE") then		
		if (UnitIsA(destFlags, groupmate)) then 
			local spellName, spellSchool, auraType, amount = select(2, ...); 
			if (strupper(auraType) == "DEBUFF" and spellName == L["Daze"]) then
				self:AntiDaze(destGUID); 
			end
		end
	end
end

if (DUOWAN_ADDON_VERION >= 40200) then
	local oldFunc = AntiDaze.OnCombatEvent;
	AntiDaze.OnCombatEvent = function(self, e, timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceFlags2, destGUID, destName, destFlags, destFlags2, ...)
		oldFunc(self, _, timestamp, event, e, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, ...);
	end
end

function AntiDaze:Toggle(switch)
	if (switch) then
		self:OnModuleEnable();
	else
		self:OnModuleDisable();
	end
end

-------------------------------
-- 误导喊话
misDirectYell = HunterMod:NewModule("misDirectYell", "AceEvent-3.0", "AceHook-3.0");
local misDirect = GetSpellInfo(34477); 
local misDirectPlayer; 

function misDirectYell:Yell(msg)
	SendChatMessage(msg, "yell"); 
end 

function misDirectYell:UNIT_SPELLCAST_SENT(event, unit, spell, _, player)
	if (strlower(unit) == "player" and spell == misDirect ) then 
		misDirectPlayer = player; 
	end 
end 

function misDirectYell:UNIT_SPELLCAST_SUCCEEDED(event, unit, spell) 
	if (strlower(unit) == "player" and spell == misDirect and IsInInstance()) then 
		self:Yell(string.gsub(L["MISDIRECT_PATTERN"], "$player", misDirectPlayer)); 
	end 
end

function misDirectYell:Toggle(switch) 
	if (switch) then 
		self:RegisterEvent("UNIT_SPELLCAST_SENT");
		self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED"); 
	else
		self:UnregisterEvent("UNIT_SPELLCAST_SENT");
		self:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED");
	end 
end 