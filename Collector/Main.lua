
BuildEnv(...)

GUI = LibStub('NetEaseGUI-2.0')

Addon = LibStub('AceAddon-3.0'):NewAddon('Collector', 'AceEvent-3.0', 'LibModule-1.0', 'LibClass-2.0', 'AceHook-3.0')

function Addon:OnInitialize()
    self.mountCache = {}
    self.mountCollectedCache = {}
    self.petCollectedCache = {}
    self.petGUIDCollectedCache = {}
    self.newPetCache = {}

    self:RegisterEvent('FRIENDLIST_UPDATE')
    self:RegisterEvent('ZONE_CHANGED')
    self:RegisterEvent('ZONE_CHANGED_NEW_AREA', 'ZONE_CHANGED')
    self:RegisterEvent('COMPANION_LEARNED', 'CacheCollectedMount')

    self:HookScript(WorldMapFrame, 'OnHide', 'ZONE_CHANGED')
    self:RegisterMessage('COLLECTOR_SETTING_UPDATE')

    do
        local searchFilter

        self:SecureHook(C_PetJournal, 'SetSearchFilter', function(text)
            searchFilter = text
        end)
        self:SecureHook(C_PetJournal, 'ClearSearchFilter', function()
            searchFilter = nil
        end)

        local PickupPet = C_PetJournal.PickupPet
        function C_PetJournal.PickupPet(id)
            if InCombatLockdown() then
                C_Timer.After(0, function()
                    for i = 1, 3 do
                        PetJournal.Loadout['Pet'..i].setButton:Hide()
                    end
                end)
                return
            end
            PickupPet(id)
        end

        function C_PetJournal.GetSearchFilter()
            return searchFilter or ''
        end
    end
end

function Addon:OnEnable()
    PetJournal:UnregisterEvent('PET_JOURNAL_LIST_UPDATE')
    self:RegisterEvent('PET_JOURNAL_LIST_UPDATE', function(...)
        local firstPetCache = true
        self:RegisterEvent('PET_JOURNAL_LIST_UPDATE', function(...)
            self:CacheCollectedPet(firstPetCache)
            firstPetCache = nil
            PetJournal:GetScript('OnEvent')(PetJournal, ...)
        end)
    end)

    self:CacheMount()
    self:ZONE_CHANGED()
end

function Addon:COLLECTOR_SETTING_UPDATE(_, key, value)
    if key == 'objectives' then
        if value then
            self:EnableModule('Objectives')
        else
            self:DisableModule('Objectives')
        end
    end
end

function Addon:FRIENDLIST_UPDATE()
    wipe(WOW_FRIEND_NAME_TO_INDEX)
    for i = 1, GetNumFriends() do
        if GetFriendInfo(i) then --by eui.cc
			WOW_FRIEND_NAME_TO_INDEX[GetFriendInfo(i)] = i
		end
    end
end

function Addon:ZONE_CHANGED()
    if self:UpdateCurrentArea() then
        self:SendMessage('COLLECTOR_AREA_CHANGED')
    end
end

function Addon:UpdateCurrentArea()
    if WorldMapFrame:IsShown() then
        return false
    end

    SetMapToCurrentZone()

    local area = self.area
    self.area = Area:Get(self:GetCurrentAreaInfo())
    return self.area ~= area
end

function Addon:Toggle()
    PlanPanel:Toggle()
end

function Addon:ToggleAchievement(achievement)
    if not AchievementFrame then
        AchievementFrame_LoadUI()
    end 
    if not AchievementFrame:IsShown() then
        AchievementFrame_ToggleAchievementFrame(false, achievement:IsGuild())
    end
    AchievementFrame_SelectAchievement(achievement:GetID())
end

function Addon:ToggleWorldMap(area)
    ShowUIPanel(WorldMapFrame)
    SetMapByID(area:GetMapID())
    SetDungeonMapLevel(area:GetLevel() + (DungeonUsesTerrainMap() and 1 or 0))
end

function Addon:ToggleMountJournal(mount)
    if InCombatLockdown() then
        UIErrorsFrame:AddMessage(L['不能在战斗中这样做'], 1, 0, 0)
    else
        HideUIPanel(WorldMapFrame)
        ShowUIPanel(CollectionsJournal)
        CollectionsJournal_SetTab(CollectionsJournal, 1)
        MountJournal_Select(mount:GetIndex())
        self:SendMessage('COLLECTOR_FRIENDFEED_CLICK')
    end
end

function Addon:TogglePetJournal(pet)
    if InCombatLockdown() then
        UIErrorsFrame:AddMessage(L['不能在战斗中这样做'], 1, 0, 0)
    else
        HideUIPanel(WorldMapFrame)
        ShowUIPanel(CollectionsJournal)
        CollectionsJournal_SetTab(CollectionsJournal, 2)
        PetJournal_SelectSpecies(PetJournal, pet:GetID())
    end
end

function Addon:ToggleObjectPanel(object)
    -- body
end

function Addon:GetCurrentAreaInfo()
    local map = select(2, GetAreaMapInfo(GetCurrentMapAreaID()))
    local lvl = GetCurrentMapDungeonLevel()
    if DungeonUsesTerrainMap() then
        lvl = lvl - 1
    end
    return map, lvl
end

function Addon:GetCurrentAreaToken()
    return self:GetAreaToken(self:GetCurrentAreaInfo())
end

function Addon:GetAreaToken(map, lvl)
    return format('%s:%d', map, lvl)
end

function Addon:IterateMounts()
    return ipairs(self.mountCache)
end

function Addon:CacheMount()
    for i = 1, C_MountJournal.GetNumMounts() do
        local name, id, _, _, _, _, _, _, _, _, isCollected = C_MountJournal.GetMountInfo(i)

        tinsert(self.mountCache, Mount:Get(id, i))

        self.mountCollectedCache[id] = isCollected or nil
    end
end

function Addon:CacheCollectedPet(firstPetCache)
    local search = C_PetJournal.GetSearchFilter()
    local collect = C_PetJournal.IsFlagFiltered(LE_PET_JOURNAL_FLAG_COLLECTED)
    local notCollect = C_PetJournal.IsFlagFiltered(LE_PET_JOURNAL_FLAG_NOT_COLLECTED)
    local petTypeFilters = {} do
        for i = 1, C_PetJournal.GetNumPetTypes() do
            petTypeFilters[i] = C_PetJournal.IsPetTypeFiltered(i)
        end
    end
    local petSourceFilters = {} do
        for i = 1, C_PetJournal.GetNumPetSources() do
            petSourceFilters[i] = C_PetJournal.IsPetSourceFiltered(i)
        end
    end

    C_PetJournal.SetFlagFilter(LE_PET_JOURNAL_FLAG_COLLECTED, true)
    C_PetJournal.SetFlagFilter(LE_PET_JOURNAL_FLAG_NOT_COLLECTED, true)
    C_PetJournal.ClearSearchFilter()
    C_PetJournal.AddAllPetTypesFilter()
    C_PetJournal.AddAllPetSourcesFilter()

    local old = self.petGUIDCollectedCache
    local new = {}

    for i = 1, C_PetJournal.GetNumPets() do
        local petID, speciesID, isOwned = C_PetJournal.GetPetInfoByIndex(i)

        if isOwned then
            Profile:DelPlan(COLLECT_TYPE_PET, speciesID)

            if not firstPetCache and not old[petID] then
                self.newPetCache[petID] = true
                self:SendMessage('COLLECTOR_LEARNED', COLLECT_TYPE_PET, speciesID, petID)
            end

            new[petID] = true
        end
        self.petCollectedCache[speciesID] = isOwned or nil
    end

    self.petGUIDCollectedCache = new

    C_PetJournal.SetFlagFilter(LE_PET_JOURNAL_FLAG_COLLECTED, not collect)
    C_PetJournal.SetFlagFilter(LE_PET_JOURNAL_FLAG_NOT_COLLECTED, not notCollect)
    C_PetJournal.SetSearchFilter(search)

    for i, v in ipairs(petTypeFilters) do
        C_PetJournal.SetPetTypeFilter(i, not v)
    end
    for i, v in ipairs(petSourceFilters) do
        C_PetJournal.SetPetSourceFilter(i, not v)
    end
end

function Addon:ClearNewPet()
    wipe(self.newPetCache)
end

function Addon:IsNewPet(guid)
    return self.newPetCache[guid]
end

function Addon:IsPetCollected(speciesID)
    return self.petCollectedCache[speciesID]
end

function Addon:CacheCollectedMount()
    for _, mount in ipairs(self.mountCache) do
        if mount:IsCollected() and not self.mountCollectedCache[mount:GetID()] then
            mount:SetIsNew(true)
            Profile:DelPlan(COLLECT_TYPE_MOUNT, mount:GetID())

            self.mountCollectedCache[mount:GetID()] = true
            self:SendMessage('COLLECTOR_LEARNED', COLLECT_TYPE_MOUNT, mount:GetID())
        end
    end
    self:SendMessage('COLLECTOR_MOUNTLIST_UPDATE')
end

function Addon:GetCollectTypeClass(collectType)
    if collectType == COLLECT_TYPE_MOUNT then
        return Mount
    elseif collectType == COLLECT_TYPE_PET then
        return Pet
    end
end

function Addon:GetMountCount()
    local count = 0
    for k, v in pairs(self.mountCollectedCache) do
        count = count + 1
    end
    return count
end

function Addon:IsFriend(target)
    return WOW_FRIEND_NAME_TO_INDEX[target]
end

function Addon:MakeChatMessage(event, ...)
    for i, v in ipairs(CHAT_FRAMES) do
        local frame = _G[v]
        local script = frame:IsEventRegistered(event) and frame:GetScript('OnEvent')
        if script then
            script(frame, event, ...)
        end
    end 
end