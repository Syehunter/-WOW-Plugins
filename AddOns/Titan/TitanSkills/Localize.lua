--[[
	Titan Skills
	Localization File
	Version 1.5
	
	Revision: $Id: Localize.lua 7 2012-12-23 12:19:36 PST Kjasi $
]]

--== enUS & enGB ==--
-- Passed Vars: Color, Skill Name, Current Skill Level, Modifications (+3), Color, Max Skill Level, Skinning Notes, Training Notice
TITANSKILLS_FORMAT_DISPLAY = "%s%s (%s%s%s/%s)%s%s"
TITANSKILLS_FORMAT_DISPLAY_SINGLE = "%s%s (%s%s%s)%s%s"
-- Passed Var: Highest Skinnable Mob Level
TITANSKILLS_FORMAT_SKINMOBLEVEL = " (%sLevel %i%s)"		-- color code, level, color code

-- Coloring Menu
TITANSKILLS_COLORING = "Coloring"
TITANSKILLS_COLORING_NONE = "None"
TITANSKILLS_COLORING_STANDARD = "Standard"
TITANSKILLS_COLORING_BYPLEVEL = "By Player Level"
TITANSKILLS_COLORING_BYMAXIMUM = "By Maximum Skill"

TITANSKILLS_NOSKILLS = "You have no skills to track."
TITANSKILLS_GETTRAINING = "Train!"
TITANSKILLS_GETTRAININGLEVELUP = "Level to %i!"		-- Level number is passed. Example: Level to 20!
TITANSKILLS_SKILLS_CATEGORY = "Skills"

if GetLocale() == 'zhCN' then
	TITANSKILLS_FORMAT_DISPLAY = "%s%s (%s%s%s/%s)%s%s"
	TITANSKILLS_FORMAT_DISPLAY_SINGLE = "%s%s (%s%s%s)%s%s"
	-- Passed Var: Highest Skinnable Mob Level
	TITANSKILLS_FORMAT_SKINMOBLEVEL = " (%s等级 %i%s)"		-- color code, level, color code

	-- Coloring Menu
	TITANSKILLS_COLORING = "颜色"
	TITANSKILLS_COLORING_NONE = "无"
	TITANSKILLS_COLORING_STANDARD = "基本"
	TITANSKILLS_COLORING_BYPLEVEL = "按玩家等级"
	TITANSKILLS_COLORING_BYMAXIMUM = "按技能最大点数"

	TITANSKILLS_NOSKILLS = "你没有专业可追踪."
	TITANSKILLS_GETTRAINING = "训练!"
	TITANSKILLS_GETTRAININGLEVELUP = "等级到 %i!"		-- Level number is passed. Example: Level to 20!
	TITANSKILLS_SKILLS_CATEGORY = "专业技能"
elseif GetLocale() == 'zhTW' then
	TITANSKILLS_FORMAT_DISPLAY = "%s%s (%s%s%s/%s)%s%s"
	TITANSKILLS_FORMAT_DISPLAY_SINGLE = "%s%s (%s%s%s)%s%s"
	-- Passed Var: Highest Skinnable Mob Level
	TITANSKILLS_FORMAT_SKINMOBLEVEL = " (%s等級 %i%s)"		-- color code, level, color code

	-- Coloring Menu
	TITANSKILLS_COLORING = "顏色"
	TITANSKILLS_COLORING_NONE = "無"
	TITANSKILLS_COLORING_STANDARD = "基本"
	TITANSKILLS_COLORING_BYPLEVEL = "按玩家等級"
	TITANSKILLS_COLORING_BYMAXIMUM = "按技能最大點數"

	TITANSKILLS_NOSKILLS = "你沒有專業可追蹤."
	TITANSKILLS_GETTRAINING = "訓練!"
	TITANSKILLS_GETTRAININGLEVELUP = "等級到 %i!"		-- Level number is passed. Example: Level to 20!
	TITANSKILLS_SKILLS_CATEGORY = "專業"
end