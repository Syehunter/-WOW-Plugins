--[[
	Titan Skills
	Version 1.5

	Revision: $Id: skills.lua 11 2012-12-23 12:20:00 PST Kjasi $
]]

Titan_Skills_list = {}
local Skills_ID = "Skills"
local Skills_Name = TITANSKILLS_SKILLS_CATEGORY
local Skills_Version = "1.5"

local hasTimer = nil
local AceTimer = LibStub("AceTimer-3.0")

-- My Colors
local ORANGE_COLOR_CODE = "|cffff9900"
local BLUE_COLOR_CODE = "|cff8080FF"

--[[
	Skinning Database
	As described at http://www.wowpedia.org/Skinning
	
	1-365 can be done with simple math. The rest uses this database.
]]
local SkinningData = {
	["365"] = 73,		-- LVL*5
	["375"] = 74,		-- (LVL*5)+5
	["385"] = 75,		-- (LVL*5)+10
	["395"] = 76,		-- (LVL*5)+15
	["405"] = 77,		-- (LVL*5)+20
	["415"] = 78,		-- (LVL*5)+25
	["425"] = 79,		-- (LVL*5)+30
	["435"] = 80,		-- (LVL*5)+35
	["440"] = 81,		-- (LVL*5)+35
	["445"] = 82,		-- (LVL*5)+35
	["450"] = 83,		-- (LVL*5)+35
	["470"] = 84,		-- (LVL*5)+50
	["490"] = 85,		-- (LVL*5)+65
	["510"] = 86,		-- (LVL*5)+80
	["530"] = 87,		-- (LVL*5)+95
}

function Titan_Skills_OnLoad(self)
	if not TitanPanelButton_UpdateButton then
		return
	end

	self.registry = {
		id = Skills_ID,
		menuText = Skills_Name,
		version = Skills_Version,
		category = "Information",
		tooltipTitle = "Skills Info",
		buttonTextFunction = "TitanPanelSkillsButton_GetButtonText", 
		tooltipTextFunction = "TitanPanelSkillsButton_GetTooltipText",
		icon = "Interface\\Icons\\Ability_Parry",
		iconButtonWidth = 16,
		iconWidth = 16,
		updateType = TITAN_PANEL_UPDATE_TOOLTIP,
		savedVariables = {
			ShowIcon = 1,
			ShowLabelText = 1,
			UseColor = 1,
			DisplayOnRightSide = 0,
		}
	}
end

function Titan_Skills_OnClick(self, button)
	if ( button == "LeftButton" ) then
	end
end

function Titan_Skills_OnEvent(self, event, ...)
	TitanPanelSkillsButton_GetTooltipText()
	TitanPanelButton_UpdateButton(Skills_ID)
end

function TitanPanelSkillsButton_GetButtonText()
	local Returned = ""

	if (TitanGetVar(Skills_ID, "ShowLabelText") == 1) then
		Returned = Skills_Name
	end

	return Returned
end

function Titan_Skills_GetTopMax()
	local expansion = GetAccountExpansionLevel()
	local skills = 300
	local prof = 300
	
	-- Mists of Pandaria
	if (expansion == 4) then
		prof = 600
		skills = 450
	-- Cataclysm
	elseif (expansion == 3) then
		prof = 525
		skills = 425
	-- WotLK
	elseif (expansion == 2) then
		prof = 450
		skills = 400
	-- Burning Cursade
	elseif (expansion == 1) then
		prof = 375
		skills = 350
	end
	
	return skills, prof
end

function TitanSkills_GetColor(min,max,header,skillname)
	local level = UnitLevel("player")
	local color = HIGHLIGHT_FONT_COLOR_CODE
	local lvlskill = (5*level)
	local topmax = Titan_Skills_GetTopMax()
	
	if (TitanGetVar(Skills_ID, "UseColor") == nil)or(TitanGetVar(Skills_ID, "UseColor") == 0) then
		return color
	end

	if (min == max) then
		return BLUE_COLOR_CODE
	end
	if (min == 1) then
		return GRAY_FONT_COLOR_CODE
	end

	if (TitanGetVar(Skills_ID, "UseColor") == 3) then
		if (header == "Class Skills") then
			max = topmax
		end
	end

	if (TitanGetVar(Skills_ID, "UseColor") == 2) then
		max = lvlskill
	end

	local percent = min/max

	if (percent >= 0.8) then
		local p = (percent-0.8)/0.2
		color = TitanSkills_ColorMix(p,YELLOW_FONT_COLOR,GREEN_FONT_COLOR)		-- Color Green if above or equal to 80%.
	elseif (percent >= 0.60) then
		local p = (percent-0.6)/0.2
		color = TitanSkills_ColorMix(p,ORANGE_FONT_COLOR,YELLOW_FONT_COLOR)		-- Color Yellow if above or equal to 60%.
	elseif (percent >= 0.35) then
		local p = (percent-0.35)/0.25
		color = TitanSkills_ColorMix(p,RED_FONT_COLOR,ORANGE_FONT_COLOR)		-- Color Orange if above or equal to 35%.
	elseif (percent >= 0.10) then
		local p = (percent-0.1)/0.25
		color = TitanSkills_ColorMix(p,GRAY_FONT_COLOR,RED_FONT_COLOR)		-- Color Red if above or equal to 10%.
	elseif (percent < 0.10) then
		color = GRAY_FONT_COLOR_CODE		-- Color Gray if below 10%
	else
		color = HIGHLIGHT_FONT_COLOR_CODE	-- If everything should fail, color white.
	end

	return color
end

function TitanPanelSkillsButton_GetTooltipText()
	Titan_Skills_GenerateList()

	local result = " \n"
	local a = Titan_Skills_list
	local count = 0
	
	for group,gv in pairs(a) do
		result = result..TitanUtils_GetNormalText(group).."\n"
		for skill,sv in pairs(a[group]) do
			if a[group][skill]["maxrank"] >= 5 then
				result = result.."    "..Titan_Skills_GetSkill(skill).."\n"
				count = count + 1
			end
		end
	end
	
	if count == 0 then
		return " \n"..TITANSKILLS_NOSKILLS
	end
	
	return result
end

function Titan_Skills_GetRacialBonus(profid)
	-- Alchemy			171
	-- Archaeology		794
	-- Blacksmithing	164
	-- Cooking			185
	-- Enchanting		333
	-- Engineering		202
	-- First Aid		129
	-- Fishing			356
	-- Herbalism		182
	-- Inscription		773
	-- Jewelcrafting	755
	-- Leatherworking	165
	-- Mining			186
	-- Skinning			393
	-- Tailoring		197

	-- Alchemy
	if (profid == 171) then
		-- Goblins
		if (IsSpellKnown(69045)) then
			return 15
		end

	-- Cooking
	elseif (profid == 185) then
		-- Panderans
		if (IsSpellKnown(107073)) then
			return 15
		end
		
	-- Enchanting
	elseif (profid == 333) then
		-- Blood Elves
		if (IsSpellKnown(28877)) then
			return 10
		end
	
	-- Engineering
	elseif (profid == 202) then
		-- Gnomes
		if (IsSpellKnown(20593)) then
			return 15
		end
	
	-- Herbalism
	elseif (profid == 182) then
		-- Tauren
		if (IsSpellKnown(20552)) then
			return 15
		end
	
	-- Jewelcrafting
	elseif (profid == 755) then
		-- Draenei
		if (IsSpellKnown(28875)) then
			return 10
		end
	
	-- Skinning
	elseif (profid == 393) then
		-- Worgen
		if (IsSpellKnown(68978)) then
			return 15
		end
	end
	
	return 0
end

local function isGatheringProf(skillid)
	-- Herbalism
	if (skillid == 182) then
		return true
	end
	-- Skinning
	if (skillid == 393) then
		return true
	end
	-- Mining
	if (skillid == 186) then
		return true
	end
	-- Mining
	if (skillid == 356) then
		return true
	end
	return
end

function Titan_Skills_GetSkill(skillname)
	local a = Titan_Skills_list
	local clevel = UnitLevel("player")
	local lockpick = GetSpellInfo(1804)		-- Pick Lock (Lockpicking) skill
	
	for group,v in pairs(a) do
		for skill,v in pairs(a[group]) do
			if (skill == skillname) then
				local profid = a[group][skill]["profid"]
				local racialbonus = Titan_Skills_GetRacialBonus(profid)
				
				local rank = a[group][skill]["rank"]
				local maxrank = a[group][skill]["maxrank"]
				local modnum = a[group][skill]["modifier"]
	
				local mod =""
				if modnum > 0 then
					mod = TitanUtils_GetGreenText("+"..modnum)
				end
				local color = TitanSkills_GetColor(rank,maxrank,group,skill)
				local skinlvl = ""				
				
				-- All "Skinning" professions, Skinning, Engineering, Herbalism and Mining.
				if ((profid == 393)			-- Skinning
					or (profid == 202)		-- Engineering
					or (profid == 182)		-- Herbalism
					or (profid == 186)		-- Mining
				) then
					-- Get Skinning Level
					local sknl = 1
					local r = tonumber(rank) + modnum
					if (r<100) then
						sknl = floor(r/10)+10
					elseif (r<375) then
						sknl = floor(r/5)
					else
						local skd = floor(r/5)*5
						while ((not SkinningData[tostring(skd)]) and (skd>365)) do
							skd = skd-5
						end
						sknl = SkinningData[tostring(skd)]
					end
					-- Determine Grey Level
					local grylvl = 0	-- lvl 1-5
					if (clevel >= 60) then
						grylvl = clevel-9
					elseif (clevel >= 51) then
						grylvl = clevel-floor(clevel/5)-1
					elseif (clevel == 50) then
						grylvl = clevel-10
					elseif (clevel >= 6) then
						grylvl = clevel-floor(clevel/10)-5
					end
					
					-- Color Mob Level Difficulty
					local lvlcolor = ""
					if (sknl >= clevel+5) then
						lvlcolor = RED_FONT_COLOR_CODE
					elseif (sknl >= clevel+3) then
						lvlcolor = ORANGE_FONT_COLOR_CODE
					elseif (sknl >= clevel-2) then
						lvlcolor = YELLOW_FONT_COLOR_CODE
					elseif (sknl <= grylvl) then
						lvlcolor = GRAY_FONT_COLOR_CODE
					else
						lvlcolor = GREEN_FONT_COLOR_CODE
					end
					
					skinlvl = format(TITANSKILLS_FORMAT_SKINMOBLEVEL,lvlcolor,tonumber(sknl),color)
				end
				-- Training Message
				local training = ""
				if (skill ~= lockpick) then	-- If not Pick Lock (Lockpicking)...
					local _, topmax = Titan_Skills_GetTopMax()
					local adjustedmax = maxrank-racialbonus
					
					if (adjustedmax < topmax) then
						-- Maxrank 75
						local trainlvl = 50
						local charlvl = 10
						-- First Aid
						if (profid == 129) then
							charlvl = 1
						end
						if (adjustedmax >= 525) then
							trainlvl = 500
							charlvl = 80
						elseif (adjustedmax >= 450) then
							trainlvl = 425
							charlvl = 75
						elseif (adjustedmax >= 375) then
							trainlvl = 350
							charlvl = 65
							if (isGatheringProf(profid)) then
								charlvl = 55
							end
						elseif (adjustedmax >= 300) then
							trainlvl = 275
							charlvl = 50
							if (isGatheringProf(profid)) then
								charlvl = 40
							end
						elseif (adjustedmax >= 225) then
							trainlvl = 200
							charlvl = 35
						elseif (adjustedmax >= 150) then
							trainlvl = 125
							charlvl = 20
						end
						
						--print(format("For %s, Racial: %s, Rank: %s, Max: %s, Adj: %s, Train: %i, Char: %i",skill,tostring(racialbonus),tostring(rank),tostring(maxrank),tostring(adjustedmax),trainlvl,charlvl))
						
						if (rank >= trainlvl) then
							if (clevel < charlvl)
								and (profid ~= 356)									-- Fishing has no level requirement
								and ((profid ~= 129) or (trainlvl >= 200))			-- nor First Aid below Artisan
								and ((profid ~= 185) or (trainlvl >= 500)) then		-- nor Cooking below Zen Master
								training = format(" "..HIGHLIGHT_FONT_COLOR_CODE..TITANSKILLS_GETTRAININGLEVELUP..color,charlvl)
							else
								training = " "..HIGHLIGHT_FONT_COLOR_CODE..TITANSKILLS_GETTRAINING..color
							end
						end
					end
				end
				if (skill == lockpick) then	-- If Pick Lock (Lockpicking)...
					result = format(TITANSKILLS_FORMAT_DISPLAY_SINGLE,color,skill,rank,mod,color,skinlvl,training)..FONT_COLOR_CODE_CLOSE
				else
					result = format(TITANSKILLS_FORMAT_DISPLAY,color,skill,rank,mod,color,maxrank,skinlvl,training)..FONT_COLOR_CODE_CLOSE
				end
				return result
			end
		end
	end
end

function Titan_Skills_GetProf(profID)
	if (not Titan_Skills_list["Professions"]) then
		Titan_Skills_list["Professions"] = {}
	end
	local name, icon, skillLevel, maxSkillLevel, numAbilites, Spelloffset, skillLine, skillModifier = GetProfessionInfo(profID)
	Titan_Skills_list["Professions"][name] = {
		["rank"] = skillLevel,
		["modifier"] = skillModifier,
		["maxrank"] =  maxSkillLevel,
		["profid"] = skillLine,
	}
end

function Titan_Skills_GenerateList()
	Titan_Skills_list = {}
	local Current_Header
	local hasClassSkills

	local prof1, prof2, archaeology, fishing, cooking, firstaid = GetProfessions()

	if (prof1) then
		Titan_Skills_GetProf(prof1)
	end
	if (prof2) then
		Titan_Skills_GetProf(prof2)
	end
	if (archaeology) then
		Titan_Skills_GetProf(archaeology)
	end
	if (fishing) then
		Titan_Skills_GetProf(fishing)
	end
	if (cooking) then
		Titan_Skills_GetProf(cooking)
	end
	if (firstaid) then
		Titan_Skills_GetProf(firstaid)
	end

	-- Test for Lockpicking
	local Lockpick_Name = GetSpellInfo(1804)
	local Test_Lockpicking = GetSpellInfo(Lockpick_Name)
	if (Test_Lockpicking ~= nil) then
		hasClassSkills = 1
		local lplevel = UnitLevel("player") * 5
		Titan_Skills_list["Class Skills"] = {}
		Titan_Skills_list["Class Skills"][Test_Lockpicking] = {
			["rank"] = lplevel,
			["modifier"] = 0,
			["maxrank"] =  lplevel,
		}
	end

--[[

	-- Pre-scan for Class Skills
	for i=1, GetNumSkillLines() do
		skillName, isHeader, _, skillRank, numTempPoints, skillModifier, skillMaxRank, _, stepCost, rankCost, minLevel, skillCostType, skillDescription = GetSkillLineInfo(i)

		if (isHeader~=nil) then
			Current_Header = skillName
		end

		if (Current_Header == "Class Skills") then
			if (skillMaxRank > 1) then
				hasClassSkills = 1
			end
		end
	end

	-- Main Scan
	Current_Header = nil

	for i=1, GetNumSkillLines() do
		skillName, isHeader, _, skillRank, numTempPoints, skillModifier, skillMaxRank, _, stepCost, rankCost, minLevel, skillCostType, skillDescription = GetSkillLineInfo(i)

		if (isHeader~=nil) then
			Current_Header = skillName
			if ((Current_Header == "Class Skills") and (hasClassSkills ~= nil)) or (Current_Header ~= "Class Skills" and Current_Header ~= "Armor Proficiencies" and Current_Header ~= "Languages") then
				if not (Titan_Skills_list[Current_Header]) then
					Titan_Skills_list[Current_Header] = {}
				end
			end
		elseif (isHeader == nil) then
			if ((Current_Header == "Class Skills") and (hasClassSkills ~= nil)) or (Current_Header ~= "Class Skills" and Current_Header ~= "Armor Proficiencies" and Current_Header ~= "Languages") then
				Titan_Skills_list[Current_Header][skillName] = {
					["rank"] = skillRank,
					["numtemp"] = numTempPoints,
					["modifier"] = skillModifier,
					["maxrank"] =  skillMaxRank,
					["desc"] = skillDescription,
				}
			end
		end
	end
]]
end

function Titan_SKills_OnShow(self)
	if not hasTimer then
		hasTimer = AceTimer.ScheduleRepeatingTimer("TitanPanel"..Skills_ID, TitanPanelPluginHandle_OnUpdate, 1, {Skills_ID, TITAN_PANEL_UPDATE_TOOLTIP})
	end
end

function Titan_SKills_OnHide(self)
	AceTimer.CancelTimer("TitanPanel"..Skills_ID, hasTimer, true)
	hasTimer = nil
end

function Titan_Skills_GetColorCB(mode)
	local temp = TitanGetVar(Skills_ID, "UseColor")
	if temp == mode then
		return 1
	end
	return nil
end

function TitanPanelRightClickMenu_PrepareSkillsMenu()
	local L = LibStub("AceLocale-3.0"):GetLocale("Titan", true)
	local info
	if ( UIDROPDOWNMENU_MENU_LEVEL == 2 ) then
		-- Do Not Color
		info = {}
		info.text = TITANSKILLS_COLORING_NONE
		info.value = 0
		info.func = function () TitanSkills_UseColor(0) end
		info.checked = Titan_Skills_GetColorCB(info.value)
		UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL)

		-- Color by Skill Level (Standard Coloring)
		info = {}
		info.text = TITANSKILLS_COLORING_STANDARD
		info.value = 1
		info.func = function () TitanSkills_UseColor(1) end
		info.checked = Titan_Skills_GetColorCB(info.value)
		UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL)

		-- Color by Character Level
		info = {}
		info.text = TITANSKILLS_COLORING_BYPLEVEL
		info.value = 2
		info.func = function () TitanSkills_UseColor(2) end
		info.checked = Titan_Skills_GetColorCB(info.value)
		UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL)

		-- Color by Maximum
		info = {}
		info.text = TITANSKILLS_COLORING_BYMAXIMUM
		info.value = 3
		info.func = function () TitanSkills_UseColor(3) end
		info.checked = Titan_Skills_GetColorCB(info.value)
		UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL)
	else
		TitanPanelRightClickMenu_AddTitle(TitanPlugins[Skills_ID].menuText.." "..Skills_Version)

		TitanPanelRightClickMenu_AddSpacer()

		-- Color Dropdown
		info = {}
		info.text = TITANSKILLS_COLORING
		info.hasArrow = 1
		UIDropDownMenu_AddButton(info)

		TitanPanelRightClickMenu_AddSpacer()
		TitanPanelRightClickMenu_AddToggleIcon(Skills_ID)
		TitanPanelRightClickMenu_AddToggleLabelText(Skills_ID)
		TitanPanelRightClickMenu_AddCommand(L["TITAN_PANEL_MENU_HIDE"], Skills_ID, TITAN_PANEL_MENU_FUNC_HIDE)
	end
end

function TitanSkills_UseColor(mode)
	TitanSetVar(Skills_ID, "UseColor", mode)
	TitanPanelButton_UpdateButton(Skills_ID)
	
end

function TitanSkills_ColorToLevel()
	TitanToggleVar(Skills_ID, "ColorToLevel")
	TitanPanelButton_UpdateButton(Skills_ID)
end

function TitanSkills_ColorMix(percent,color1,color2)
	if (type(color1) == "string") then
		local temp = {r=0, g=0, b=0}
		temp.r = 255/(tonumber(strsub(color1,5,6),16))
		temp.g = 255/(tonumber(strsub(color1,7,8),16))
		temp.b = 255/(tonumber(strsub(color1,9,10),16))
		color1 = temp
	end
	if (type(color2) == "string") then
		local temp = {r=0, g=0, b=0}
		temp.r = 255/(tonumber(strsub(color2,5,6),16))
		temp.g = 255/(tonumber(strsub(color2,7,8),16))
		temp.b = 255/(tonumber(strsub(color2,9,10),16))
		color2 = temp
	end

	local newcolor = {r=0, g=0, b=0}

	if (p == 0) then
		newcolor = color1
	elseif (p == 1) then
		newcolor = color2
	else
		newcolor.r = (color1.r + (percent * (color2.r - color1.r)))
		newcolor.g = (color1.g + (percent * (color2.g - color1.g)))
		newcolor.b = (color1.b + (percent * (color2.b - color1.b)))

		if newcolor.r > 1 then newcolor.r = 1 end
		if newcolor.g > 1 then newcolor.g = 1 end
		if newcolor.b > 1 then newcolor.b = 1 end
		if newcolor.r < 0 then newcolor.r = 0 end
		if newcolor.g < 0 then newcolor.g = 0 end
		if newcolor.b < 0 then newcolor.b = 0 end
	end

	local text = format("|c%02X%02X%02X%02X", 255, (newcolor.r * 255), (newcolor.g * 255), (newcolor.b * 255))

	return tostring(text)
end