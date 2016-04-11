-- Version: 1.0.1
-- Author: ldz5 and Jai
-- Title: |cffff565e[NetEase]|r Achievement Search
-- modify by eui.cc at 2015.01.29
local strmatch = string.match
local filterText, filterText2
local filterList = {}

local function safefind(source, pattern)
	local ok, result = pcall(strmatch, source, pattern)
	return ok and result
end

-- hook native api
local function MakeGetCategoryNumAchievements(name)
	local old = _G[name]
	_G[name] = function(categoryID)
		local numAchievements, numCompleted, completedOffset = old(categoryID)
		if not filterText then
			return numAchievements, numCompleted, completedOffset
		else
			wipe(filterList)
			for i = 1 + completedOffset, numAchievements + completedOffset do
				local id, name, points, completed, month, day, year, description, flags, icon, rewardText, isGuild, wasEarnedByMe, earnedBy = GetAchievementInfo(categoryID, i)
				if id and (safefind(name, filterText) or safefind(description, filterText) or safefind(rewardText, filterText)) then
					tinsert(filterList, i)
				end
			end
			local num = #filterList
			if num > 0 then
			--    debug('achievement found: ' .. num .. ', keyword: ' .. filterText)
			else
			--    debug('achievement not found, keyword: ' .. filterText)
			end
			return num, 0--[[not used]], 0
		end
	end
end
		
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, name)
	if name == 'Blizzard_AchievementUI' then
		MakeGetCategoryNumAchievements('AchievementFrame_GetCategoryNumAchievements_All')
		MakeGetCategoryNumAchievements('AchievementFrame_GetCategoryNumAchievements_Complete')
		MakeGetCategoryNumAchievements('AchievementFrame_GetCategoryNumAchievements_Incomplete')

		ACHIEVEMENTUI_SELECTEDFILTER = AchievementFrame_GetCategoryNumAchievements_All
		AchievementFrameFilters[1].func = AchievementFrame_GetCategoryNumAchievements_All
		AchievementFrameFilters[2].func = AchievementFrame_GetCategoryNumAchievements_Complete
		AchievementFrameFilters[3].func = AchievementFrame_GetCategoryNumAchievements_Incomplete

		setfenv(AchievementFrameAchievements_Update, setmetatable({
			AchievementButton_DisplayAchievement = function(button, category, achievement, selectionID)
				return AchievementButton_DisplayAchievement(button, category, filterText and filterList[achievement] or achievement, selectionID)
			end
		}, {__index = _G}))

		-- create search box
		local SearchBox = CreateFrame('EditBox', "EuiAchievementSearch1", AchievementFrameFilterDropDown, 'SearchBoxTemplate') do
			SearchBox:SetPoint('TOPLEFT', AchievementFrame, 148, 7)
			SearchBox:SetSize(108, 15)
			SearchBox.Left:Hide()
			SearchBox.Right:Hide()
			SearchBox.Middle:Hide()
			SearchBox:HookScript('OnTextChanged', function(SearchBox)
				filterText = SearchBox:GetText()
				filterText = filterText ~= '' and filterText or nil
				AchievementFrameAchievements_Update()
			end)
			SearchBox:SetScript('OnHide', function(SearchBox)
				filterText = nil
				AchievementFrameAchievements_Update()
			end)
			SearchBox:SetScript('OnShow', SearchBox:GetScript('OnTextChanged'))

			local SearchInset = SearchBox.Left do
				SearchInset:Show()
				SearchInset:SetSize(128, 32)
				SearchInset:ClearAllPoints()
				SearchInset:SetPoint('TOPLEFT', AchievementFrameHeader, 'TOPLEFT', 111, -56)
				SearchInset:SetTexture([[Interface\AchievementFrame\UI-Achievement-RightDDLInset]])
				SearchInset:SetTexCoord(0, 1, 0, 1)
			end
		end

		--Stats
		local achievementNames = setmetatable({}, {__index = function(t, id)
			t[id] = select(2, GetAchievementInfo(id)) or false
			return t[id]
		end})

		setfenv(AchievementFrameStats_Update, setmetatable({
			GetStatistic = function(...)
				local quantity, skip, id = GetStatistic(...)
				if filterText2 then
					local name = achievementNames[id]
					if name and not safefind(name, filterText2) then
						skip = true
					end
				end
				return quantity, skip, id
			end
		}, {__index = _G}))

		local SearchBox2 = CreateFrame('EditBox', "EuiAchievementSearch2", AchievementFrameStats, 'SearchBoxTemplate') do
			SearchBox2:SetPoint('TOPLEFT', AchievementFrame, 148, 7)
			SearchBox2:SetSize(108, 15)
			SearchBox2.Left:Hide()
			SearchBox2.Right:Hide()
			SearchBox2.Middle:Hide()
			SearchBox2:HookScript('OnTextChanged', function(SearchBox2)
				filterText2 = SearchBox2:GetText()
				filterText2 = filterText2 ~= '' and filterText2 or nil
				STAT_FUNCTIONS.lastCategory = nil
				AchievementFrameStats_Update()
			end)

			local SearchInset = SearchBox2.Left do
				SearchInset:Show()
				SearchInset:SetSize(128, 32)
				SearchInset:ClearAllPoints()
				SearchInset:SetPoint('TOPLEFT', AchievementFrameHeader, 'TOPLEFT', 111, -56)
				SearchInset:SetTexture([[Interface\AchievementFrame\UI-Achievement-RightDDLInset]])
				SearchInset:SetTexCoord(0, 1, 0, 1)
			end
		end
	end
end)