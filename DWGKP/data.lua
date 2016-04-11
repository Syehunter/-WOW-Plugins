--------------------------------------------------------
-- data.lua ver 1.0
-- 日期: 2010-6-7
-- 作者: dugu@bigfoot
-- 描述: Raid数据
-- 版权所有 (c) duowan.com
--------------------------------------------------------
local L =  LibStub("AceLocale-3.0"):GetLocale("DWGKP");

DWGKP_MAP_DATA = {
	--[[
	L["Eye of Eternity"],
	L["Naxxramas"],
	L["The Obsidian Sanctum"],
	L["Archavons Kammer"],
	L["Onyxia's Lair"],
	L["Ulduar"],
	L["Crusader's Coliseum"],
	L["Icecrown Citadel"],
	L["The Ruby Sanctum"],
	L["Baradin Hold"],
	L["Blackwing Descent"],
	L["Throne of the Four Winds"],
	L["The Bastion of Twilight"],
	L["Fire Lands"],
	L["Dragon Soul"],

	-- mop
	L["Heart of Fear"],
	L["MogushanVaults"],
	L["TerraceofEndlessSpring"],
	L["ThroneofThunder"],	]]
	--wod
	L["Highmaul"],
	L["BlackrockFoundry"],
	L["HellfireCitadel"],
};

DWGKP_DEFAULT_CLASS_FILTER = {
	"Mage", 
	"Warlock", 
	"Priest", 
	"Druid", 
	"Paladin",
	"Rogue", 
	"Shaman", 
	"Hunter", 
	"Warrior", 
	"DeathKnight",
	"Monk",
};

DWGKP_CLASS_DATA = {
	L["Warrior"],
	L["DeathKnight"],
	L["Paladin"],
	L["Priest"],
	L["Shaman"],
	L["Druid"],
	L["Rogue"],
	L["Mage"],
	L["Warlock"],
	L["Hunter"],
	L["Monk"],
};

DWGKP_CLASS_SORT_DATA = {
	[L["Warrior"]] = 1,
	[L["DeathKnight"]] = 2,
	[L["Paladin"]] = 3,
	[L["Priest"]] = 4,
	[L["Shaman"]] = 5,
	[L["Druid"]] = 6,
	[L["Rogue"]] = 7,
	[L["Mage"]] = 8,
	[L["Warlock"]] = 9,
	[L["Hunter"]] = 10,
	[L["Monk"]] = 11,
};

DWGKP_CLASS_ENGLISH = {
	[L["Mage"]] = "MAGE",
	[L["Warlock"]] = "WARLOCK",
	[L["Priest"]] = "PRIEST",
	[L["Druid"]] = "DRUID",
	[L["Paladin"]] = "PALADIN",
	[L["Rogue"]] = "ROGUE",
	[L["Shaman"]] = "SHAMAN",
	[L["Hunter"]] = "HUNTER",
	[L["Warrior"]] = "WARRIOR",
	[L["Monk"]] = "MONK",
	[L["DeathKnight"]] = "DEATHKNIGHT",
};

DWGKP_TAB_INDEX = {
	["member"] = {
		"DWGKPMemberEditFrameName",
		"DWGKPMemberEditFrameClass",
	},
	["item"] = {
		"DWGKPItemEditFrameItemName",
		"DWGKPItemEditFramePlayerName",
		"DWGKPItemEditFrameItemCount",
	},
	["event"] = {
		"DWGKPEventEditFrameDscription",
		"DWGKPEventEditFrameIncome",
		"DWGKPEventEditFrameOutcome",
		"DWGKPEventEditFramePlayerName",
	},
};

DWGKP_QUALITY_LOW = {[2] = L["Uncommon"], [3] = L["Rare"], [4] = L["Epic"],};
DWGKP_DEFAULT_DIST = {["five"] = L["Five"], ["all"] = L["AllGroup"]};
DWGKP_REPORT_CHANNEL = {["Say"] = L["Say"], ["Raid"] = L["Raid"], ["Party"] = L["Party"],};

DWGKP_QUALITY_LIST_MAP =  {[L["GreenQuality"]] = 2, [L["BlueQuality"]] = 3, [L["PurpleQuality"]] = 4,};
DWGKP_DISTRIBUTE_LIST_MAP = {[L["Five"]] = "five", [L["AllGroup"]] = "all",};
DWGKP_REPORT_CHANNEL = {[L["Say"]] = "Say", [L["Raid"]] = "Raid", [L["Party"]] = "Party", [L["Instance"]] = "Instance",};