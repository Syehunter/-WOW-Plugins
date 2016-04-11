
BuildEnv(...)

PetPanel = Addon:NewModule(CreateFrame('Frame', nil, PetJournal), 'PetPanel', 'AceEvent-3.0', 'AceHook-3.0')


local PetGUID = {}

-- local speciesID, customName, level, xp, maxXp, displayID, isFavorite, name, icon, petType = C_PetJournal.GetPetInfoByPetID(petID)

function PetGUID.LevelRange(petID)
    local _, _, level = C_PetJournal.GetPetInfoByPetID(petID)
    if level == 1 then
        return 1
    elseif level <= 10 then
        return 2
    elseif level <= 20 then
        return 3
    elseif level <= 24 then
        return 4
    else
        return 5
    end
end

function PetGUID.Quality(petID)
    return select(5, C_PetJournal.GetPetStats(petID))
end

function PetGUID.Ability(petID, speciesID)
    return Pet:Get(speciesID):GetAbility()
end

function PetGUID.Trade(petID, speciesID)
    return Pet:Get(speciesID):IsTradable() and 1 or 2
end

function PetGUID.Battle(petID, speciesID)
    return Pet:Get(speciesID):IsCanBattle() and 1 or 2
end

function PetPanel:OnInitialize()
    GUI:Embed(self, 'Refresh')

    self.favoriteAtTop = true
    self.planAtTop = true
    self.newAtTop = true
    self.onlyCurrentArea = false
    self.filterTypes = {}
    self.filterBitCache = {}

    for k, v in pairs(PET_JOURNAL_FILTER_TYPES) do
        self.filterTypes[k] = {}
    end

    PetJournalRightInset:SetPoint('TOPRIGHT', -6, -261)
    PetJournalLoadoutBorder:SetHeight(319)
    PetJournalLoadoutBorderSlotHeaderBG:Hide()
    PetJournalLoadoutBorderSlotHeaderText:Hide()
    PetJournalLoadoutBorderSlotHeaderF:Hide()
    PetJournalLoadoutBorderSlotHeaderLeft:Hide()
    PetJournalLoadoutBorderSlotHeaderRight:Hide()
    PetJournalLoadoutPet1:SetHeight(103)
    PetJournalLoadoutPet2:SetHeight(103)
    PetJournalLoadoutPet3:SetHeight(103)
    PetJournalLoadoutPet1BG:SetHeight(103)
    PetJournalLoadoutPet2BG:SetHeight(103)
    PetJournalLoadoutPet3BG:SetHeight(103)
    PetJournalLoadoutPet1HelpFrame:SetHeight(103)
    PetJournalLoadoutPet2HelpFrame:SetHeight(103)
    PetJournalLoadoutPet3HelpFrame:SetHeight(103)
    PetJournalLoadoutPet1HelpFrameHelpPlate:SetHeight(103)
    PetJournalLoadoutPet2HelpFrameHelpPlate:SetHeight(103)
    PetJournalLoadoutPet3HelpFrameHelpPlate:SetHeight(103)

    PetJournalLoadoutPet1HealthFrame:SetPoint('TOPLEFT', PetJournalLoadoutPet1Icon, 'BOTTOMRIGHT', 12, -2)
    PetJournalLoadoutPet2HealthFrame:SetPoint('TOPLEFT', PetJournalLoadoutPet2Icon, 'BOTTOMRIGHT', 12, -2)
    PetJournalLoadoutPet3HealthFrame:SetPoint('TOPLEFT', PetJournalLoadoutPet3Icon, 'BOTTOMRIGHT', 12, -2)

    PetJournalLoadoutPet2:SetPoint('TOP', 0, -107)
    PetJournalLoadoutPet3:SetPoint('TOP', 0, -211)


    PetJournalFilterButton:SetScript('OnClick', function(button)
        GUI:ToggleMenu(button, self:GetFilterMenuTable(), 20, 'TOPLEFT', button, 'TOPLEFT', 74, -7)
    end)
    -- PetJournalLoadoutBorder:Hide()
    -- PetJournalLoadoutBorder:SetFrameLevel(PetJournalLoadout+1000)

    PetJournalLoadout:HookScript('OnShow', function()
        PetJournalLoadoutBorder:Show()
    end)
    PetJournalLoadout:HookScript('OnHide', function()
        PetJournalLoadoutBorder:Hide()
    end)

    local PlanButton = CreateFrame('Button', nil, PetJournal, 'UIPanelButtonTemplate') do
        PlanButton:SetSize(140, 22)
        PlanButton:SetPoint('RIGHT', PetJournalFindBattle, 'LEFT')
        MagicButton_OnLoad(PlanButton)
        PlanButton:SetText(L['加入计划任务'])
        PlanButton:SetScript('OnClick', function()
            if PetJournalPetCard.speciesID then
                Profile:AddOrDelPlan(COLLECT_TYPE_PET, PetJournalPetCard.speciesID)
            end
        end)
    end

    local CardProcessBar = CreateFrame('StatusBar', nil, PetJournalPetCard) do
        CardProcessBar:SetSize(390, 10)
        CardProcessBar:SetPoint('BOTTOM', 0, 8)
        CardProcessBar:SetStatusBarTexture([[Interface\PaperDollInfoFrame\UI-Character-Skills-Bar]], 'ARTWORK')
        CardProcessBar:SetMinMaxValues(0, 100)

        local Left = CardProcessBar:CreateTexture(nil, 'OVERLAY') do
            Left:SetPoint('LEFT', -3, 0)
            Left:SetSize(9, 13)
            Left:SetTexture([[Interface\PaperDollInfoFrame\UI-Character-Skills-BarBorder]])
            Left:SetTexCoord(0.007843, 0.043137, 0.193548, 0.774193)
        end

        local Right = CardProcessBar:CreateTexture(nil, 'OVERLAY') do
            Right:SetPoint('RIGHT', 3, 0)
            Right:SetSize(9, 13)
            Right:SetTexture([[Interface\PaperDollInfoFrame\UI-Character-Skills-BarBorder]])
            Right:SetTexCoord(0.043137, 0.007843, 0.193548, 0.774193)
        end

        local Middle = CardProcessBar:CreateTexture(nil, 'OVERLAY') do
            Middle:SetPoint('TOPLEFT', Left, 'TOPRIGHT')
            Middle:SetPoint('BOTTOMRIGHT', Right, 'BOTTOMLEFT')
            Middle:SetTexture([[Interface\PaperDollInfoFrame\UI-Character-Skills-BarBorder]])
            Middle:SetTexCoord(0.113726, 0.1490196, 0.193548, 0.774193)
        end

        local Bg = CardProcessBar:CreateTexture(nil, 'BACKGROUND') do
            Bg:SetAllPoints(true)
            Bg:SetTexture(0.04, 0.07, 0.18)
        end
    end

    local CardProcessText = CardProcessBar:CreateFontString(nil, 'OVERLAY') do
        CardProcessText:SetPoint('CENTER', 0, 2)
        CardProcessText:SetFont(ChatFontNormal:GetFont(), 12, 'OUTLINE')
    end

    local InfoTab = GUI:GetClass('InTabPanel'):New(PetJournalRightInset) do
        InfoTab:SetPoint('TOPLEFT', 3, -3)
        InfoTab:SetPoint('BOTTOMRIGHT', -3, 3)
    end

    -- InfoTab:RegisterPanel(PetJournalLoadoutBorderSlotHeaderText:GetText(), PetJournalLoadout, 0)
    InfoTab:RegisterPanel(L['战队'], PetJournalLoadout, 0)
    
    local Map = Addon:GetClass('TabMap'):New(PetJournalRightInset) do
        InfoTab:RegisterPanel(L['地图'], Map, 0)
    end

    local Summary = Addon:GetClass('TabSummary'):New(PetJournalRightInset) do
        InfoTab:RegisterPanel(L['详情'], Summary, 0)
    end

    local Feed = Addon:GetClass('TabFeed'):New(PetJournalRightInset) do
        InfoTab:RegisterPanel(L['动态'], Feed, 0)
    end

    self.CardProcessBar = CardProcessBar
    self.CardProcessText = CardProcessText
    self.Map = Map
    self.Feed = Feed
    self.Summary = Summary
    self.InfoTab = InfoTab
    self.PlanButton = PlanButton

    self.cachePets = {}
    self.sortVal = {}

    self:RawHook('PetJournal_ShowPetDropdown', true)
    self:RawHook('PetJournal_UpdatePetList', 'Update', true)

    self:SecureHook('PetJournal_UpdatePetCard', 'UpdateDisplay')

    self:RegisterMessage('COLLECTOR_PLANLIST_UPDATE')

    self:SetScript('OnHide', self.OnHide)

    PetJournal.listScroll.update = function()
        self:UpdateList()
    end

    if PetTrackerTrackToggle then
        PetTrackerTrackToggle:ClearAllPoints()
        PetTrackerTrackToggle:SetPoint('RIGHT', PlanButton, 'LEFT', -80, 0)
    end
end

function PetPanel:OnHide()
    Addon:ClearNewPet()
end

function PetPanel:COLLECTOR_PLANLIST_UPDATE()
    self:UpdateDisplay()
    self:Refresh()
end

function PetPanel:Update()
    if not self:IsVisible() then
        return
    end
    self:UpdateCache()
    self:UpdateList()
end

function PetPanel:GetPetAttr(attr, petID, speciesID)
    return PetGUID[attr](petID, speciesID)
end

function PetPanel:MatchPet(petID, speciesID, isFavorite, inPlan)
    if self:IsOnlyCurrentArea() and not Pet:Get(speciesID):IsInCurrentArea() then
        return false
    end
    for filter, v in pairs(PET_JOURNAL_FILTER_TYPES) do
        if v.isOwned and petID and not self:IsTypeFiltered(filter, self:GetPetAttr(filter, petID, speciesID), v.isBit) then
            return false
        end
        if not v.isOwned and not self:IsTypeFiltered(filter, self:GetPetAttr(filter, petID, speciesID), v.isBit) then
            return false
        end
    end
    return true
end

function PetPanel:MakeSortValue(pet, isCollected, isFavorite, isNew)
    local key1 do
        if self:IsNewAtTop() and isNew then
            key1 = 1
        elseif self:IsFavoriteAtTop() and isFavorite then
            key1 = 2
        elseif isCollected then
            key1 = 3
        elseif self:IsPlanAtTop() and pet:IsInPlan() then
            key1 = 4
        else
            key1 = 99
        end
    end
    return key1
end

function PetPanel:UpdateCache()
    SetMapToCurrentZone()

    local cachePets = wipe(self.cachePets)
    local sortVal = {}

    for i = 1, C_PetJournal.GetNumPets() do
        local petID, speciesID, isOwned, customName, level, isFavorite, isRevoked, name, icon, petType, _, _, _, _, canBattle = C_PetJournal.GetPetInfoByIndex(i)

        local pet = Pet:Get(speciesID)

        if self:MatchPet(petID, speciesID, isOwned, isFavorite) then
            tinsert(cachePets, i)
            sortVal[i] = self:MakeSortValue(pet, isOwned, isFavorite, Addon:IsNewPet(petID))
        end
    end

    table.sort(cachePets, function(a, b)
        if sortVal[a] == sortVal[b] then
            return a < b
        end
        return sortVal[a] < sortVal[b]
    end)
end

function PetPanel:UpdateList()
    local scrollFrame = PetJournal.listScroll
    local offset = HybridScrollFrame_GetOffset(scrollFrame)
    local petButtons = scrollFrame.buttons
    local pet, index
    
    local numPets = #self.cachePets
    local _, numOwned = C_PetJournal.GetNumPets()
    PetJournal.PetCount.Count:SetText(numOwned)
    
    local summonedPetID = C_PetJournal.GetSummonedPetGUID()

    for i = 1,#petButtons do
        pet = petButtons[i]
        index = offset + i
        if index <= numPets then
            index = self.cachePets[index]

            local petID, speciesID, isOwned, customName, level, favorite, isRevoked, name, icon, petType, _, _, _, _, canBattle = C_PetJournal.GetPetInfoByIndex(index)

            if customName then
                pet.name:SetText(customName)
                pet.name:SetHeight(12)
                pet.subName:Show()
                pet.subName:SetText(name)
            else
                pet.name:SetText(name)
                pet.name:SetHeight(30)
                pet.subName:Hide()
            end
            pet.icon:SetTexture(icon)
            pet.petTypeIcon:SetTexture(GetPetTypeTexture(petType))
            
            if (favorite) then
                pet.dragButton.favorite:Show()
            else
                pet.dragButton.favorite:Hide()
            end
            
            if isOwned then
                local health, maxHealth, attack, speed, rarity = C_PetJournal.GetPetStats(petID)

                pet.dragButton.levelBG:SetShown(canBattle)
                pet.dragButton.level:SetShown(canBattle)
                pet.dragButton.level:SetText(level)
                
                pet.icon:SetDesaturated(false)
                pet.name:SetFontObject('GameFontNormal')
                pet.petTypeIcon:SetShown(canBattle)
                pet.petTypeIcon:SetDesaturated(false)
                pet.dragButton:Enable()
                pet.iconBorder:Show()
                pet.iconBorder:SetVertexColor(ITEM_QUALITY_COLORS[rarity-1].r, ITEM_QUALITY_COLORS[rarity-1].g, ITEM_QUALITY_COLORS[rarity-1].b)
                if (health and health <= 0) then
                    pet.isDead:Show()
                else
                    pet.isDead:Hide()
                end
                if(isRevoked) then
                    pet.dragButton.levelBG:Hide()
                    pet.dragButton.level:Hide()
                    pet.iconBorder:Hide()
                    pet.icon:SetDesaturated(true)
                    pet.petTypeIcon:SetDesaturated(true)
                    pet.dragButton:Disable()
                end
            else
                pet.dragButton.levelBG:Hide()
                pet.dragButton.level:Hide()
                pet.icon:SetDesaturated(true)
                pet.iconBorder:Hide()
                pet.name:SetFontObject('GameFontDisable')
                pet.petTypeIcon:SetShown(canBattle)
                pet.petTypeIcon:SetDesaturated(true)
                pet.dragButton:Disable()
                pet.isDead:Hide()
            end
            
            if Pet:Get(speciesID):IsInPlan() then
                if not pet.PlanLayer then
                    local PlanLayer = pet.dragButton:CreateTexture(nil, 'OVERLAY') do
                        PlanLayer:SetAllPoints(pet.dragButton.favorite)
                        PlanLayer:SetTexture([[Interface\COMMON\friendship-FistHuman]])
                        PlanLayer:SetTexCoord(pet.dragButton.favorite:GetTexCoord())
                    end
                    pet.PlanLayer = PlanLayer
                end
                pet.PlanLayer:Show()
            elseif pet.PlanLayer then
                pet.PlanLayer:Hide()
            end

            if petID and Addon:IsNewPet(petID) then
                if not pet.NewLayer then
                    local NewLayer = CreateFrame('Frame', nil, pet.dragButton) do
                        local Text = NewLayer:CreateFontString(nil, 'OVERLAY', 'GameFontHighlight')
                        Text:SetPoint('CENTER', pet.dragButton.favorite, 'CENTER')
                        Text:SetText(NEW_CAPS)

                        local NewGlow = NewLayer:CreateTexture(nil, 'OVERLAY')
                        NewGlow:SetAtlas('collections-newglow')
                        NewGlow:SetPoint('TOPLEFT', Text, 'TOPLEFT', -20, 10)
                        NewGlow:SetPoint('BOTTOMRIGHT', Text, 'BOTTOMRIGHT', 20, -10)
                    end
                    pet.NewLayer = NewLayer
                end
                pet.NewLayer:Show()
            elseif pet.NewLayer then
                pet.NewLayer:Hide()
            end


            if ( petID and petID == summonedPetID ) then
                pet.dragButton.ActiveTexture:Show()
            else
                pet.dragButton.ActiveTexture:Hide()
            end

            pet.petID = petID
            pet.speciesID = speciesID
            pet.index = index
            -- pet.owned = isOwned
            pet.owned = true
            pet:Show()

            --Update Petcard Button
            if PetJournalPetCard.petIndex == index then
                pet.selected = true
                pet.selectedTexture:Show()
            else
                pet.selected = false
                pet.selectedTexture:Hide()
            end
            
            if ( petID ) then
                local start, duration, enable = C_PetJournal.GetPetCooldownByGUID(pet.petID)
                if (start) then
                    CooldownFrame_SetTimer(pet.dragButton.Cooldown, start, duration, enable)
                end
            end
        else
            pet:Hide()
        end
    end
    
    local totalHeight = numPets * 46
    HybridScrollFrame_Update(scrollFrame, totalHeight, scrollFrame:GetHeight())
end

function PetPanel:PetJournal_ShowPetDropdown(index, anchor, x, y, petID)
    local speciesID
    if not petID then
        petID, speciesID = C_PetJournal.GetPetInfoByIndex(index)
    else
        petID, speciesID = C_PetJournal.GetPetInfoByPetID(petID)
    end

    if petID then
        return self.hooks.PetJournal_ShowPetDropdown(index, anchor, x, y, petID)
    else
        GUI:ToggleMenu(anchor, self:GetPetMenuTable(speciesID), 20, 'TOPLEFT', anchor, 'TOPLEFT', x, -y)
    end
end

function PetPanel:GetPetMenuTable(speciesID)
    local menuTable = {
        {
            text = Profile:IsInPlan(COLLECT_TYPE_PET, speciesID) and L['取消计划任务'] or L['加入计划任务'],
            func = function()
                Profile:AddOrDelPlan(COLLECT_TYPE_PET, speciesID)
            end
        },
    }
    for i, v in ipairs(Pet:Get(speciesID):GetAchievementMenu()) do
        tinsert(menuTable, v)
    end
    tinsert(menuTable, { text = CANCEL })
    return menuTable
end

function PetPanel:UpdateDisplay()
    local card = PetJournalPetCard
    if card.speciesID then
        local plan = Plan:Get(COLLECT_TYPE_PET, card.speciesID)
        local pet = plan:GetObject()

        self.PlanButton:SetEnabled(not pet:IsCollected() and not pet:IsHideOnChar())
        self.PlanButton:SetText(pet:IsInPlan() and L['取消计划任务'] or L['加入计划任务'])

        self.Summary:SetPlan(plan)
        self.Map:SetPlan(plan)
        self.Feed:SetPlan(plan)

        self.InfoTab:EnablePanel(self.Map)
        self.InfoTab:EnablePanel(self.Summary)
        self.InfoTab:EnablePanel(self.Feed)

        if not card.petID and pet:GetProgressObject() then
            local color = pet:GetProgressColor()
            local progress = pet:GetProgressRate() * 100
            local name = pet:GetProgressName()

            self.CardProcessText:SetText(format('%s (%d%%)', name, progress))
            self.CardProcessBar:SetValue(progress)
            self.CardProcessBar:SetStatusBarColor(color.r, color.g, color.b)
            self.CardProcessBar:Show()
        else
            self.CardProcessBar:Hide()
        end
    else
        self.CardProcessBar:Hide()
        self.PlanButton:Disable()
        self.PlanButton:SetText(L['加入计划任务'])

        self.InfoTab:DisablePanel(self.Map)
        self.InfoTab:DisablePanel(self.Summary)
        self.InfoTab:DisablePanel(self.Feed)
    end
end

function PetPanel:ResetFilter()
    C_PetJournal.AddAllPetTypesFilter()
    C_PetJournal.AddAllPetSourcesFilter()
    C_PetJournal.ClearSearchFilter()
    C_PetJournal.SetFlagFilter(LE_PET_JOURNAL_FLAG_COLLECTED, true)
    C_PetJournal.SetFlagFilter(LE_PET_JOURNAL_FLAG_NOT_COLLECTED, true)

    for _, v in pairs(self.filterTypes) do
        wipe(v)
    end
    self.favoriteAtTop = true
    self.planAtTop = true
    self.newAtTop = true
    self.onlyCurrentArea = false

    -- self.CurrentArea:SetChecked(false)
    self:Refresh()
end

---- Sort

function PetPanel:SetFavoriteAtTop(flag)
    self.favoriteAtTop = flag or nil
    self:Refresh()
end

function PetPanel:IsFavoriteAtTop()
    return self.favoriteAtTop
end

function PetPanel:SetPlanAtTop(flag)
    self.planAtTop = flag or nil
    self:Refresh()
end

function PetPanel:IsPlanAtTop()
    return self.planAtTop
end

function PetPanel:SetNewAtTop(flag)
    self.newAtTop = flag or nil
    self:Refresh()
end

function PetPanel:IsNewAtTop()
    return self.newAtTop
end

function PetPanel:SetOnlyCurrentArea(flag)
    self.onlyCurrentArea = flag
    self:Refresh()
end

function PetPanel:IsOnlyCurrentArea()
    return self.onlyCurrentArea
end

---- Filter

function PetPanel:SetTypeFilter(filter, id, flag)
    self.filterTypes[filter][id] = not flag or nil
    self.filterBitCache[filter] = nil
    self:Refresh()
end

function PetPanel:IsTypeFiltered(filter, id, isBit)
    if not isBit then
        return not self.filterTypes[filter][id]
    else
        return bit.band(self:GetTypeFilterBit(filter), id) > 0
    end
end

function PetPanel:AddAllTypeFilters(filter)
    wipe(self.filterTypes[filter])
    self.filterBitCache[filter] = nil
    self:Refresh()
end

function PetPanel:ClearAllTypeFilters(filter)
    local data = PET_JOURNAL_FILTER_TYPES[filter]
    for _, v in ipairs(data) do
        self.filterTypes[filter][v.id] = true
    end
    self.filterBitCache[filter] = nil
    self:Refresh()
end

function PetPanel:IsAnyTypeFiltered(filter)
    local data = PET_JOURNAL_FILTER_TYPES[filter]
    for _, v in ipairs(data) do
        if not self.filterTypes[filter][v.id] then
            return true
        end
    end
end

function PetPanel:IsAnyTypeNotFiltered(filter)
    return next(self.filterTypes[filter])
end

function PetPanel:GetTypeFilterBit(filter)
    if not self.filterBitCache[filter] then
        local b = 0 do
            for id in pairs(self.filterTypes[filter]) do
                b = bit.bor(b, bit.lshift(1, id - 1))
            end
            b = bit.bnot(b)
        end
        self.filterBitCache[filter] = b
    end
    return self.filterBitCache[filter]
end

function PetPanel:GetFilterMenuTable()
    if not self.menuTable then
        local function MakeBlizzardFilter(text, all, clear, num, set, is, pn)
            local menuTable = {
                text = text,
                keepShownOnClick = true,
                hasArrow = true,
                fontObject = function()
                    for i = 1, num() do
                        if is(i) then
                            return 'GameFontGreenSmall'
                        end
                    end
                end,
                menuTable = {
                    {
                        text = CHECK_ALL,
                        keepShownOnClick = true,
                        refreshParentOnClick = true,
                        func = function()
                            all()
                        end,
                    },
                    {
                        text = UNCHECK_ALL,
                        keepShownOnClick = true,
                        refreshParentOnClick = true,
                        func = function()
                            clear()
                        end,
                    },
                    {
                        isSeparator = true,
                    },
                },
            }

            for i = 1, num() do
                tinsert(menuTable.menuTable, {
                    text = _G[pn .. i],
                    checkable = true,
                    isNotRadio = true,
                    keepShownOnClick = true,
                    refreshParentOnClick = true,
                    checked = function()
                        return not is(i)
                    end,
                    func = function(_,_,_,value)
                        set(i, value)
                    end,
                })
            end
            return menuTable
        end

        local function MakeFilterTypeMenuTable(filter, name)
            local menuTable = type(name) == 'table' and name or {
                text = name,
                keepShownOnClick = true,
                hasArrow = true,
                fontObject = function()
                    return self:IsAnyTypeNotFiltered(filter) and 'GameFontGreenSmall'
                end
            }

            menuTable.menuTable = {
                {
                    text = CHECK_ALL,
                    keepShownOnClick = true,
                    refreshParentOnClick = true,
                    func = function()
                        self:AddAllTypeFilters(filter)
                    end
                },
                {

                    text = UNCHECK_ALL,
                    keepShownOnClick = true,
                    refreshParentOnClick = true,
                    func = function()
                        self:ClearAllTypeFilters(filter)
                    end
                },
                {
                    isSeparator = true,
                },
            }

            for _, v in ipairs(PET_JOURNAL_FILTER_TYPES[filter]) do
                tinsert(menuTable.menuTable, {
                    text = v.text,
                    keepShownOnClick = true,
                    refreshParentOnClick = true,
                    checkable = true,
                    isNotRadio = true,
                    checked = function()
                        return self:IsTypeFiltered(filter, v.id)
                    end,
                    func = function(_,_,_,checked)
                        self:SetTypeFilter(filter, v.id, checked)
                    end,
                })
            end

            return menuTable
        end

        self.menuTable = {
            {
                text = COLLECTED,
                checkable = true,
                isNotRadio = true,
                keepShownOnClick = true,
                checked = function()
                    return not C_PetJournal.IsFlagFiltered(LE_PET_JOURNAL_FLAG_COLLECTED)
                end,
                func = function(_,_,_,value)
                    C_PetJournal.SetFlagFilter(LE_PET_JOURNAL_FLAG_COLLECTED, value)
                end,
            },
            {
                text = NOT_COLLECTED,
                checkable = true,
                isNotRadio = true,
                keepShownOnClick = true,
                checked = function()
                    return not C_PetJournal.IsFlagFiltered(LE_PET_JOURNAL_FLAG_NOT_COLLECTED)
                end,
                func = function(_,_,_,value)
                    C_PetJournal.SetFlagFilter(LE_PET_JOURNAL_FLAG_NOT_COLLECTED, value)
                end,
            },
            {
                isSeparator = true,
            },
            {
                text = L['过滤器'],
                isTitle = true,
            },
            {
                text = L['仅当前区域'],
                checkable = true,
                isNotRadio = true,
                keepShownOnClick = true,
                checked = function()
                    return self:IsOnlyCurrentArea()
                end,
                func = function(_,_,_,value)
                    self:SetOnlyCurrentArea(value)
                end
            },
            MakeBlizzardFilter(
                PET_FAMILIES,
                C_PetJournal.AddAllPetTypesFilter,
                C_PetJournal.ClearAllPetTypesFilter,
                C_PetJournal.GetNumPetTypes,
                C_PetJournal.SetPetTypeFilter,
                C_PetJournal.IsPetTypeFiltered,
                'BATTLE_PET_NAME_'
            ),
            MakeBlizzardFilter(
                SOURCES,
                C_PetJournal.AddAllPetSourcesFilter,
                C_PetJournal.ClearAllPetSourcesFilter,
                C_PetJournal.GetNumPetSources,
                C_PetJournal.SetPetSourceFilter,
                C_PetJournal.IsPetSourceFiltered,
                'BATTLE_PET_SOURCE_'
            ),
            MakeFilterTypeMenuTable('LevelRange', LEVEL),
            MakeFilterTypeMenuTable('Quality', QUALITY),
            MakeFilterTypeMenuTable('Ability', L['技能']),
            MakeFilterTypeMenuTable('Trade', L['交易']),
            MakeFilterTypeMenuTable('Battle', L['战斗']),
            {
                isSeparator = true,
            },
            {
                text = RAID_FRAME_SORT_LABEL,
                keepShownOnClick = true,
                hasArrow = true,
                menuTable = {
                    {
                        text = NAME,
                        checkable = true,
                        keepShownOnClick = true,
                        checked = function()
                            return C_PetJournal.GetPetSortParameter() == LE_SORT_BY_NAME
                        end,
                        func = function()
                            C_PetJournal.SetPetSortParameter(LE_SORT_BY_NAME)
                            self:Refresh()
                        end,
                    },
                    {
                        text = LEVEL,
                        checkable = true,
                        keepShownOnClick = true,
                        checked = function()
                            return C_PetJournal.GetPetSortParameter() == LE_SORT_BY_LEVEL
                        end,
                        func = function()
                            C_PetJournal.SetPetSortParameter(LE_SORT_BY_LEVEL)
                            self:Refresh()
                        end,
                    },
                    {
                        text = RARITY,
                        checkable = true,
                        keepShownOnClick = true,
                        checked = function()
                            return C_PetJournal.GetPetSortParameter() == LE_SORT_BY_RARITY
                        end,
                        func = function()
                            C_PetJournal.SetPetSortParameter(LE_SORT_BY_RARITY)
                            self:Refresh()
                        end,
                    },
                    {
                        text = TYPE,
                        checkable = true,
                        keepShownOnClick = true,
                        checked = function()
                            return C_PetJournal.GetPetSortParameter() == LE_SORT_BY_PETTYPE
                        end,
                        func = function()
                            C_PetJournal.SetPetSortParameter(LE_SORT_BY_PETTYPE)
                            self:Refresh()
                        end,
                    },
                    {
                        isSeparator = true,
                    },
                    -- {
                    --     text = L['偏好置顶'],
                    --     keepShownOnClick = true,
                    --     refreshParentOnClick = true,
                    --     checkable = true,
                    --     isNotRadio = true,
                    --     checked = function()
                    --         return self:IsFavoriteAtTop()
                    --     end,
                    --     func = function(_,_,_,checked)
                    --         self:SetFavoriteAtTop(checked)
                    --     end
                    -- },
                    {
                        text = L['计划置顶'],
                        keepShownOnClick = true,
                        refreshParentOnClick = true,
                        checkable = true,
                        isNotRadio = true,
                        checked = function()
                            return self:IsPlanAtTop()
                        end,
                        func = function(_,_,_,checked)
                            self:SetPlanAtTop(checked)
                        end
                    },
                    {
                        text = L['新收集置顶'],
                        keepShownOnClick = true,
                        refreshParentOnClick = true,
                        checkable = true,
                        isNotRadio = true,
                        checked = function()
                            return self:IsNewAtTop()
                        end,
                        func = function(_,_,_,checked)
                            self:SetNewAtTop(checked)
                        end
                    },
                }
            },
            {
                isSeparator = true,
            },
            {
                text = RESET,
                keepShownOnClick = true,
                func = function()
                    self:ResetFilter()
                end
            }
        }
    end
    return self.menuTable
end