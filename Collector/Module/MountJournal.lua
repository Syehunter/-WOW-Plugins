
BuildEnv(...)

MountJournal = Addon:NewModule(CreateFrame('Frame'), 'MountJournal', 'AceEvent-3.0', 'AceHook-3.0', 'AceTimer-3.0')

function MountJournal:OnInitialize()
    self:Disable()
    self.mountCache = {}
    self.filterTypes = {}
    self.sortVal = {}
    self.favoriteAtTop = true
    self.planAtTop = true
    self.newAtTop = true
    self.onlyCurrentArea = false
    self.sortKey = 'Name'
    self.recommend = {}

    self:RegisterMessage('COLLECTOR_RECOMMEND_UPDATE')
    self:RegisterMessage('COLLECTOR_FIRST_LOGIN')
end

function MountJournal:OnEnable()
    GUI:Embed(self, 'Refresh', 'Blocker')
    self:SetParent(_G.MountJournal)
    self:SetAllPoints(true)

    for k, v in pairs(MOUNT_JOURNAL_FILTER_TYPES) do
        self.filterTypes[k] = {}
    end
    for k, v in pairs(MOUNT_JOURNAL_CUSTOM_FILTER_TYPES) do
        self.filterTypes[k] = {}
    end

    MountJournalFilterButton:SetScript('OnClick', function(button)
        GUI:ToggleMenu(button, self:GetFilterMenuTable(), 20, 'TOPLEFT', button, 'TOPLEFT', 74, -7)
        self:SendMessage('COLLECTOR_FILTER_CLICK')
    end)

    local PlanButton = CreateFrame('Button', nil, _G.MountJournal, 'UIPanelButtonTemplate') do
        PlanButton:SetSize(140, 22)
        PlanButton:SetPoint('BOTTOMRIGHT')
        MagicButton_OnLoad(PlanButton)
        PlanButton:SetText(L['加入计划任务'])
        PlanButton:SetScript('OnClick', function()
            Profile:AddOrDelPlan(COLLECT_TYPE_MOUNT, self.spellID)
        end)
    end

    local CurrentArea = GUI:GetClass('CheckBox'):New(_G.MountJournal) do
        CurrentArea:SetPoint('LEFT', _G.MountJournal.MountCount, 'RIGHT', 10, 0)
        CurrentArea:SetText(L['仅当前区域'])
        CurrentArea:SetScript('OnClick', function(CurrentArea)
            self:SetOnlyCurrentArea(CurrentArea:GetChecked())
            self:SendMessage('COLLECTOR_CURRENTAREA_CLICK')
        end)
    end

    local Blocker = self:NewBlocker('recommend', 1) do
        Blocker:SetPoint('TOPRIGHT', -3, -60)
        Blocker:SetPoint('BOTTOMLEFT', 2, 2)
        Blocker:SetFrameStrata('DIALOG')
        Blocker:Show()
        Blocker:Hide()

        Blocker:SetCallback('OnInit', function()
            local List = GUI:GetClass('GridView'):New(Blocker) do
                List:SetPoint('TOPLEFT', 5, -5)
                List:SetSize(1, 1)
                List:SetItemClass(Addon:GetClass('RecommendItem'))
                List:SetItemWidth(342)
                List:SetItemHeight(257)
                List:SetColumnCount(2)
                List:SetRowCount(2)
                List:SetItemSpacing(5)
                List:SetAutoSize(true)
                List:SetItemList(self:GetRecommend())
                List:SetCallback('OnItemFormatted', function(_, button, mount)
                    button:SetItem(mount)
                end)
                List:SetCallback('OnItemClick', function(_, _, mount)
                    ToggleFrame(Blocker)
                    Addon:ToggleMountJournal(mount)
                end)
                List:Refresh()
            end
        end)

        local Text = Blocker:CreateFontString(nil, 'OVERLAY', 'GameFontNormal') do
            Text:Hide()
            Text:SetWidth(500)
            Text:SetWordWrap(true)
            Text:SetPoint('CENTER')
        end

        Blocker.Text = Text
        Blocker:HookScript('OnHide', function()
            self:SendMessage('COLLECTOR_RECOMMEND_HIDE')
        end)
    end

    local BlockButton = GUI:GetClass('TitleButton'):New(self) do
        BlockButton:SetTexture([[Interface\AchievementFrame\UI-Achievement-Shields]], 0, 0.5, 0, 0.5)
        BlockButton:SetSize(20, 20)
        BlockButton:SetPoint('TOPRIGHT', -30, -3)
        BlockButton:SetTooltip(L['今日推荐'])
        BlockButton:SetScript('OnClick', function()
            self:SetBlocker(true)
        end)
    end

    local Rarity = CreateFrame('Frame', nil, _G.MountJournal.MountDisplay.InfoButton) do
        Rarity:SetPoint('RIGHT', Rarity:GetParent().Name)
        Rarity:SetSize(100, 20)
        Rarity:Hide()

        local Text = Rarity:CreateFontString(nil, 'OVERLAY', 'GameFontNormalRight') do
            Text:SetAllPoints(true)
            Rarity.Text = Text
        end

        local Tooltip = GUI:GetClass('Tooltip'):New(Rarity)

        Rarity:SetScript('OnEnter', function(self)
            if self.data then
                Tooltip:SetOwner(Rarity, 'ANCHOR_RIGHT')
                Tooltip:AddHeader(self.data.tip)
                Tooltip:Show()
                Tooltip:SetFrameStrata('TOOLTIP')
            end
        end)
        Rarity:SetScript('OnLeave', function(self)
            Tooltip:Hide()
        end)
    end

    local Card = Addon:GetClass('Card'):New(_G.MountJournal) do
        Card:SetAllPoints(_G.MountJournal.RightInset)
        Card:SetFrameLevel(_G.MountJournal.RightInset:GetFrameLevel() + 10)
    end

    self.PlanButton = PlanButton
    self.CurrentArea = CurrentArea
    self.Blocker = Blocker
    self.BlockButton = BlockButton
    self.Rarity = Rarity
    self.Card = Card

    self:InitHook()

    self:RegisterMessage('COLLECTOR_PLANLIST_UPDATE')
    -- self:RegisterMessage('COLLECTOR_TRACKLIST_UPDATE', 'Refresh')
    self:RegisterMessage('COLLECTOR_MOUNT_LEARNED')
    self:RegisterMessage('COLLECTOR_HELP_UPDATE')
end

function MountJournal:InitHook()
    self:SetScript('OnShow', self.OnShow)
    self:SetScript('OnHide', self.OnHide)

    -- ListButton OnClick
    local env = setmetatable({
        MountJournal_GetMountInfo = function(index)
            return nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, true
        end,
        MountJournal_ShowMountDropdown = function(index, owner)
            self:ToggleMountDropDown(index, owner)
        end,
        ---- 这个必须在Hook之前，使用_G 防止出现在_ENV里
        MountJournal_Select = _G.MountJournal_Select,
    }, {__index = _G})

    setfenv(MountListDragButton_OnClick, env)
    setfenv(MountListItem_OnClick, env)

    ---- 这个必须在下面...
    self:SecureHook('MountJournal_Select')

    self:RawHook('MountJournal_UpdateCachedList', 'UpdateCache', true)
    self:RawHook('MountJournal_Pickup', true)

    self:SecureHook('MountJournal_UpdateMountDisplay', 'UpdateDisplay')
    self:SecureHook('MountJournal_UpdateMountList', 'UpdateList', true)
    MountJournalListScrollFrame.update = MountJournal_UpdateMountList

    self:SecureHook(_G.MountJournal, 'SetAlpha', function(_, alpha)
        self:SetShown(alpha ~= 0)
    end)
end

---- Hook

function MountJournal:MountJournal_Select(index)
    C_Timer.After(0, function()
        local visibleIndex = tIndexOf(_G.MountJournal.cachedMounts, index)
        if visibleIndex then
            local buttons = MountJournalListScrollFrame.buttons
            local height = math.max(0, math.floor(MountJournalListScrollFrame.buttonHeight * (visibleIndex - (#buttons)/2)))
            HybridScrollFrame_SetOffset(MountJournalListScrollFrame, height)
            MountJournalListScrollFrame.scrollBar:SetValue(height)
        end
    end)
end

function MountJournal:MountJournal_Pickup(index)
    if not InCombatLockdown() then
        C_MountJournal.Pickup(index)
    end
end

function MountJournal:Update()
    MountJournal_DirtyList(_G.MountJournal)
    MountJournal_UpdateMountList()
end

function MountJournal:OnHide()
    for _, mount in Addon:IterateMounts() do
        mount:SetIsNew(false)
    end
end

function MountJournal:COLLECTOR_FIRST_LOGIN()
    self.needShowTutorial = true
end

function MountJournal:CheckShowRecommend()
    if Profile:IsRecommendShown() then
        return    
    end

    if PanelTemplates_GetSelectedTab(CollectionsJournal) ~= 1 then
        if InCombatLockdown() then
            return
        else
            if CollectionsJournal_SetTab then
                CollectionsJournal_SetTab(CollectionsJournal, 1)
            else
                SetCVar('petJournalTab', 1)
            end
        end
    end

    self:SetBlocker(true)
    self:SendMessage('COLLECTOR_RECOMMEND_SHOW')
end

function MountJournal:COLLECTOR_HELP_UPDATE(_, enable)
    if enable then
        self:SetBlocker(false)
    else
        self:CheckShowRecommend()
    end
end

function MountJournal:SetBlocker(enable)
    if enable then
        ToggleFrame(self.Blocker)
    else
        HideUIPanel(self.Blocker)     
    end
end

function MountJournal:OnShow()
    self:Refresh()
    if self.needShowTutorial then
        if PanelTemplates_GetSelectedTab(CollectionsJournal) == 1 then
            self:SendMessage('COLLECTOR_MOUNTJOURNAL_SHOW')
            self.needShowTutorial = nil
        end
    else
        self:CheckShowRecommend()
    end
end

function MountJournal:COLLECTOR_PLANLIST_UPDATE()
    self:UpdateDisplay()
    self:Refresh()
end

function MountJournal:COLLECTOR_MOUNT_LEARNED(_, id)
    -- print(id)
end

function MountJournal:ResetFilterAndSort()
    for _, v in pairs(self.filterTypes) do
        wipe(v)
    end
    self.favoriteAtTop = true
    self.planAtTop = true
    self.newAtTop = true
    self.onlyCurrentArea = false
    self.sortKey = 'Name'
    self.CurrentArea:SetChecked(false)
    self:Refresh()
end

function MountJournal:SetTypeFilter(filter, id, flag)
    self.filterTypes[filter][id] = not flag or nil
    self:Refresh()
end

function MountJournal:IsTypeFiltered(filter, id)
    return not self.filterTypes[filter][id]
end

function MountJournal:AddAllTypeFilters(filter)
    wipe(self.filterTypes[filter])
    self:Refresh()
end

function MountJournal:ClearAllTypeFilters(filter)
    local data = MOUNT_JOURNAL_FILTER_TYPES[filter] or MOUNT_JOURNAL_CUSTOM_FILTER_TYPES[filter]
    for _, v in ipairs(data) do
        self.filterTypes[filter][v.id] = true
    end
    self:Refresh()
end

function MountJournal:IsAnyTypeFiltered(filter)
    local data = MOUNT_JOURNAL_FILTER_TYPES[filter] or MOUNT_JOURNAL_CUSTOM_FILTER_TYPES[filter]
    for _, v in ipairs(data) do
        if not self.filterTypes[filter][v.id] then
            return true
        end
    end
end

function MountJournal:IsAnyTypeNotFiltered(filter)
    return next(self.filterTypes[filter])
end

function MountJournal:SetFavoriteAtTop(flag)
    self.favoriteAtTop = flag or nil
    self:Refresh()
end

function MountJournal:IsFavoriteAtTop()
    return self.favoriteAtTop
end

function MountJournal:SetPlanAtTop(flag)
    self.planAtTop = flag or nil
    self:Refresh()
end

function MountJournal:IsPlanAtTop()
    return self.planAtTop
end

function MountJournal:SetNewAtTop(flag)
    self.newAtTop = flag or nil
    self:Refresh()
end

function MountJournal:IsNewAtTop()
    return self.newAtTop
end

function MountJournal:SetOnlyCurrentArea(flag)
    self.onlyCurrentArea = flag
    self:Refresh()
end

function MountJournal:IsOnlyCurrentArea()
    return self.onlyCurrentArea
end

function MountJournal:SetSortKey(key)
    self.sortKey = key
    self:Refresh()
end

function MountJournal:GetSortKey()
    return self.sortKey
end

function MountJournal:GetSearchString()
    return _G.MountJournal.searchString
end

function MountJournal:GetSelectedMount()
    local spellID = _G.MountJournal.selectedSpellID

    return spellID and Mount:Get(spellID)
end

function MountJournal:MakeSortValue(mount, isCollected, isFavorite, inPlan)
    local key1 do
        if self:IsNewAtTop() and mount:IsNew() then
            key1 = 1
        elseif self:IsFavoriteAtTop() and isFavorite then
            key1 = 2
        elseif isCollected then
            key1 = 3
        elseif self:IsPlanAtTop() and inPlan then
            key1 = 4
        else
            key1 = 99
        end
    end

    local key2 do
        local sortKey = self:GetSortKey()
        if sortKey == 'Name' then
            key2 = 0
        elseif sortKey == 'Progress' then
            key2 = 999 - (mount:GetProgressRate() or -1) * 100
        else
            key2 = mount:GetAttribute(sortKey)
        end
    end
    self.sortVal[mount:GetIndex()] = format('%02d%04d%s', key1, key2, mount:GetName())
end

function MountJournal:MatchMount(mount, isCollected, isFavorite, inPlan)
    local searchString = self:GetSearchString()
    if searchString then
        return strfind(mount:GetName(), searchString, 1, true)
    end
    if self:IsOnlyCurrentArea() then
        return mount:IsInCurrentArea()
    end
    if isCollected then
        if not self:IsTypeFiltered('Favorite', 1) and isFavorite then
            return false
        end
        if not self:IsTypeFiltered('Favorite', 2) and not isFavorite then
            return false
        end
    else
        if not self:IsTypeFiltered('Plan', 1) and inPlan then
            return false
        end
        if not self:IsTypeFiltered('Plan', 2) and not inPlan then
            return false
        end
    end

    for filter in pairs(MOUNT_JOURNAL_CUSTOM_FILTER_TYPES) do
        if not self:IsTypeFiltered(filter, mount:GetAttribute(filter)) then
            return false
        elseif filter == 'Model' then
            -- print(mount:GetName(), self:GetFilterTypeValue(filter, mount:GetID()))
        end
    end
    return true
end

function MountJournal:UpdateCache(frame)
    if frame.cachedMounts and not frame.dirtyList then
        return
    end

    SetMapToCurrentZone()

    local cachedMounts = {}
    local sortVal = wipe(self.sortVal)
    local numOwned = 0

    for _, mount in Addon:IterateMounts() do
        local hideOnChar, isCollected, isFavorite, inPlan = mount:GetStat()
        if not hideOnChar or IsGMClient() then
            if self:MatchMount(mount, isCollected, isFavorite, inPlan) then
                tinsert(cachedMounts, mount:GetIndex())
                self:MakeSortValue(mount, isCollected, isFavorite, inPlan)
            end

            if isCollected then
                numOwned = numOwned + 1
            end
        end
    end

    table.sort(cachedMounts, function(a, b)
        return sortVal[a] < sortVal[b]
    end)

    frame.cachedMounts = cachedMounts
    frame.numOwned = numOwned
    frame.dirtyList = false
end

function MountJournal:UpdateDisplay()
    local mount = self:GetSelectedMount()

    self:SetRarity(mount)

    local hideOnChar, isCollected, isFavorite, inPlan = mount:GetStat()

    self.PlanButton:SetEnabled(not isCollected)
    self.PlanButton:SetText(inPlan and L['取消计划任务'] or L['加入计划任务'])

    self.Card:SetPlan(Plan:Get(COLLECT_TYPE_MOUNT, mount:GetID()))
    _G.MountJournal.RightInset:Hide()
    _G.MountJournal.MountDisplay:Hide()

    self.spellID = mount:GetID()
    self:SendMessage('COLLECTOR_PLANBUTTON_CHANGED', not isCollected and not inPlan)
end

function MountJournal:SetRarity(mount)
    local t = mount:GetRarityText()
    if type(t) == 'table' then
        self.Rarity.Text:SetText(('|cff%s%s|r'):format(t.color, t.text))
        self.Rarity.data = t
        self.Rarity:Show()
    else
        self.Rarity:Hide()
    end
end

function MountJournal:UpdateList()
    for i, button in ipairs(MountJournalListScrollFrame.buttons) do
        local mount = button.index and button.spellID and Mount:Get(button.spellID)

        if mount and mount:IsInPlan() then
            if not button.PlanLayer then
                local PlanLayer = button:CreateTexture(nil, 'OVERLAY') do
                    PlanLayer:SetAllPoints(button.favorite)
                    PlanLayer:SetTexture([[Interface\COMMON\friendship-FistHuman]])
                    PlanLayer:SetTexCoord(button.favorite:GetTexCoord())
                end
                button.PlanLayer = PlanLayer
            end
            button.PlanLayer:Show()
        elseif button.PlanLayer then
            button.PlanLayer:Hide()
        end

        if mount and mount:IsNew() then
            if not button.NewLayer then
                local NewLayer = CreateFrame('Frame', nil, button) do
                    local Text = NewLayer:CreateFontString(nil, 'OVERLAY', 'GameFontHighlight')
                    Text:SetPoint('CENTER', button.favorite, 'CENTER')
                    Text:SetText(NEW_CAPS)

                    local NewGlow = NewLayer:CreateTexture(nil, 'OVERLAY')
                    NewGlow:SetAtlas('collections-newglow')
                    NewGlow:SetPoint('TOPLEFT', Text, 'TOPLEFT', -20, 10)
                    NewGlow:SetPoint('BOTTOMRIGHT', Text, 'BOTTOMRIGHT', 20, -10)
                end
                button.NewLayer = NewLayer
            end
            button.NewLayer:Show()
        elseif button.NewLayer then
            button.NewLayer:Hide()
        end

        -- if mount and mount:IsInTrack() then
        --     if not button.TrackLayer then
        --         local TrackLayer = button:CreateTexture(nil, 'OVERLAY') do
        --             TrackLayer:SetPoint('TOPLEFT')
        --             TrackLayer:SetTexture([[Interface\BUTTONS\UI-CheckBox-Check]])
        --             TrackLayer:SetSize(16, 16)
        --         end
        --         button.TrackLayer = TrackLayer
        --     end
        --     button.TrackLayer:Show()
        -- elseif button.TrackLayer then
        --     button.TrackLayer:Hide()
        -- end
    end
end

function MountJournal:ToggleMountDropDown(index, owner)
    local _, id, _, isActive, _, _, _, _, _, _, isCollected = C_MountJournal.GetMountInfo(index)

    GUI:ToggleMenu(owner, function()
        return self:GetMountMenuTable(Mount:Get(id), isCollected, isActive)
    end, 20, 'TOPLEFT', owner, 'BOTTOMLEFT')
end

function MountJournal:GetMountMenuTable(mount, isCollected, isActive)
    local menuTable = {}

    if isCollected then
        tinsert(menuTable, {
            text = isActive and PET_DISMISS or BATTLE_PET_SUMMON,
            func = function()
                if isActive then
                    mount:Dismiss()
                else
                    mount:Summon()
                end
            end
        })

        local isFavorite, canFavorite = mount:IsFavorite()
        tinsert(menuTable, {
            text = isFavorite and BATTLE_PET_UNFAVORITE or BATTLE_PET_FAVORITE,
            disabled = not canFavorite,
            func = function()
                mount:SetIsFavorite(not isFavorite)
                self:Refresh()
            end
        })
    else
        tinsert(menuTable, {
            text = mount:IsInPlan() and L['取消计划任务'] or L['加入计划任务'],
            func = function()
                Profile:AddOrDelPlan(COLLECT_TYPE_MOUNT, mount:GetID())
            end,
        })

        if mount:IsInPlan() then
            tinsert(menuTable, {
                text = mount:IsInTrack() and L['取消追踪'] or L['追踪'],
                func = function()
                    Profile:AddOrDelTrack(COLLECT_TYPE_MOUNT, mount:GetID())
                end
            })
        end
    end

    do
        local list = mount:GetAreaList()
        if #list > 1 then
            local node = {
                text = L['查看地图'],
                hasArrow = true,
                menuTable = {},
            }

            for _, area in ipairs(list) do
                tinsert(node.menuTable, {
                    text = area:GetName(),
                    func = function()
                        Addon:ToggleWorldMap(area)
                    end
                })
            end
            tinsert(menuTable, node)
        elseif #list == 1 then
            tinsert(menuTable, {
                text = L['查看地图'],
                func = function()
                    Addon:ToggleWorldMap(list[1])
                end
            })
        else
            tinsert(menuTable, {
                text = L['查看地图'],
                disabled = true,
            })
        end
    end

    do
        local list = mount:GetAchievementMenu()
        -- if #list > 1 then
        --     local node = {
        --         text = L['查看成就'],
        --         hasArrow = true,
        --         menuTable = {},
        --     }

        --     for _, achievement in ipairs(list) do
        --         tinsert(node.menuTable, {
        --             text = achievement:GetName(),
        --             func = function()
        --                 Addon:ToggleAchievement(achievement)
        --             end
        --         })
        --     end
        --     tinsert(menuTable, node)
        -- elseif #list == 1 then
        for i, v in ipairs(mount:GetAchievementMenu()) do
            tinsert(menuTable, v)
        end
        -- if #list == 1 then
        --     tinsert(menuTable, {
        --         text = L['查看成就'],
        --         func = function()
        --             list[1]:TogglePanel()
        --         end
        --     })
        --     tinsert(menuTable, {
        --         text = L['追踪'],
        --         func = function()
        --             AddTrackedAchievement(list[1]:GetID())
        --         end
        --     })
        -- else
        --     local a = {}
        --     local z = {}
        --     for i, v in ipairs(list) do
        --         tinsert(a, v:GetAchievementMenu())
        --         tinsert(z, v:GetTrackMenu())
        --     end
        --     tinsert(menuTable, {
        --         text = L['查看成就'],
        --         disabled = true,
        --     })
        --     tinsert(menuTable, {
        --         text = L['追踪'],
        --         disabled = true,
        --     })
        -- end
    end

    tinsert(menuTable, { text = CANCEL })

    return menuTable
end

function MountJournal:GetFilterMenuTable()
    if not self.menuTable then

        local function MakeFilterTypeMenuTable(filter, name, hasAll, parentCheckable)
            local menuTable = type(name) == 'table' and name or {
                text = name,
                keepShownOnClick = true,
                hasArrow = true,
            }

            if parentCheckable then
                menuTable.checkable = true
                menuTable.isNotRadio = true
                menuTable.refreshParentOnClick = true
                menuTable.checked = function()
                    return self:IsAnyTypeFiltered(filter)
                end
                menuTable.func = function(_, _, _, checked)
                    if checked then
                        self:AddAllTypeFilters(filter)
                    else
                        self:ClearAllTypeFilters(filter)
                    end
                end
            else
                menuTable.fontObject = function()
                    return self:IsAnyTypeNotFiltered(filter) and 'GameFontGreenSmall'
                end
            end

            if hasAll then
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
            else
                menuTable.menuTable = {}
            end

            for _, v in ipairs(MOUNT_JOURNAL_FILTER_TYPES[filter] or MOUNT_JOURNAL_CUSTOM_FILTER_TYPES[filter]) do
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

        local function MakeSortMenuTable(key, name)
            return {
                text = name,
                value = key,
                keepShownOnClick = true,
                refreshParentOnClick = true,
                checkable = true,
                checked = function(data)
                    return self:GetSortKey() == data.value
                end,
                func = function(_, data)
                    self:SetSortKey(data.value)
                end
            }
        end

        self.menuTable = {
            MakeFilterTypeMenuTable('Favorite', COLLECTED, false, true),
            MakeFilterTypeMenuTable('Plan', NOT_COLLECTED, false, true),
            {
                isSeparator = true,
            },
            {
                text = L['过滤器'],
                isTitle = true,
            },
            MakeFilterTypeMenuTable('Rarity',      L['* 稀有度'],   true),
            MakeFilterTypeMenuTable('Model',       L['* 模型'],     true),
            MakeFilterTypeMenuTable('Walk',        L['* 行走方式'], true),
            MakeFilterTypeMenuTable('Passenger',   L['* 乘客类型'], true),
            MakeFilterTypeMenuTable('Source',      SOURCES,       true),
            MakeFilterTypeMenuTable('Faction',     L['阵营'],     true),
            {
                isSeparator = true,
            },
            {
                text = L['* 排序'],
                keepShownOnClick = true,
                hasArrow = true,
                fontObject = function()
                    return (self.sortKey ~= 'Name' or not self.favoriteAtTop or not self.planAtTop or not self.newAtTop) and 'GameFontGreenSmall'
                end,
                menuTable = {
                    MakeSortMenuTable('Name',        L['名称']),
                    MakeSortMenuTable('Rarity',      L['稀有度']),
                    MakeSortMenuTable('Model',       L['模型']),
                    MakeSortMenuTable('Walk',        L['行走方式']),
                    MakeSortMenuTable('Passenger',   L['乘客类型']),
                    MakeSortMenuTable('Source',      SOURCES),
                    MakeSortMenuTable('Faction',     L['阵营']),
                    MakeSortMenuTable('Progress',    L['完成度']),
                    {
                        isSeparator = true,
                    },
                    {
                        text = L['偏好置顶'],
                        keepShownOnClick = true,
                        refreshParentOnClick = true,
                        checkable = true,
                        isNotRadio = true,
                        checked = function()
                            return self:IsFavoriteAtTop()
                        end,
                        func = function(_,_,_,checked)
                            self:SetFavoriteAtTop(checked)
                        end
                    },
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
                },
            },
            {
                isSeparator = true,
            },
            {
                text = RESET,
                keepShownOnClick = true,
                func = function()
                    self:ResetFilterAndSort()
                end
            }
        }
    end
    return self.menuTable
end

function MountJournal:COLLECTOR_RECOMMEND_UPDATE()
    wipe(self.recommend)
    for _, v in Addon:IterateMounts() do
        if v:IsRecommend() then
            tinsert(self.recommend, v)
        end
    end
end

local function GetMount(MOUNT_NUM, GET_MOUNT_CACHE)
    local day = date('%Y-%m-%d')
    while true do
        local num = #RECOMMEND_LIST
        if num == 0 then
            return false
        end
        local key = tremove(RECOMMEND_LIST, random(1, num))
        if not key then
            return false
        end
        key, order = split(key)
        local m = MOUNT_NUM[key]
        if m == nil or m > 0 then
            sort(Addon.mountCache, function(a, b)
                a = a ~= nil and a:GetAttribute(key) or nil
                b = b ~= nil and b:GetAttribute(key) or nil
                if type(a) == 'table' then
                    return #a > #b
                elseif a == nil or b == nil then
                    return a ~= nil and true or false
                elseif order then
                    return a < b
                else
                    return a > b
                end
            end)

            for i = 1, m or #Addon.mountCache do
                local index = m and random(1, m) or random(0, 4) + i
                local v = Addon.mountCache[index]
                if v:GetFaction() ~= NOT_PLAYER_FACTION and not v:IsCollected() and not v:IsInPlan() and v:IsValid() and not GET_MOUNT_CACHE[v] then
                    GET_MOUNT_CACHE[v] = true
                    v:SetRecommend(day, key)
                    return v
                end
            end
        end
    end
end

function MountJournal:GetRecommend()
    if #self.recommend == 0 then
        local Top20List = DataCache:GetObject('top20Data'):GetData()

        local MOUNT_NUM = {
            Easy = 4,
            Cool = 12,
            Top20List = Top20List and Top20List.num or 0,
        }

        local GET_MOUNT_CACHE = {}
        while #self.recommend < 4 do
            local m = GetMount(MOUNT_NUM, GET_MOUNT_CACHE)
            if m == false then
                break
            elseif m then
                tinsert(self.recommend, m)
            end
        end

        if #self.recommend == 0 then
            self.Blocker.Text:SetText(L['恭喜你你已成为坐骑达人了！'])
            self.Blocker.Text:Show()
        end
    end

    return self.recommend
end

