
BuildEnv(...)

Mount = Addon:NewClass('Mount', BaseObject)
Mount.COLLECT_TYPE = COLLECT_TYPE_MOUNT
Mount.DB = MOUNT_DATA
Mount.BLIP_KEY = 'mountBlip'

function Mount:Constructor(id, index)
    self.index = index
end

function Mount:GetIndex()
    return self.index
end

function Mount:GetStat()
    local isFavorite, _, _, hideOnChar, isCollected = select(7, C_MountJournal.GetMountInfo(self.index))
    if self.id == 107203 then
        hideOnChar = false
    end
    return hideOnChar, isCollected, isFavorite, Profile:IsInPlan(COLLECT_TYPE_MOUNT, self.id)
end

function Mount:IsFavorite()
    return C_MountJournal.GetIsFavorite(self.index)
end

function Mount:IsHideOnChar()
    return (select(10, C_MountJournal.GetMountInfo(self.index)))
end

function Mount:IsCollected()
    return (select(11, C_MountJournal.GetMountInfo(self.index)))
end

function Mount:SetIsFavorite(flag)
    C_MountJournal.SetIsFavorite(self.index, flag)
end

function Mount:Summon()
    C_MountJournal.Summon(self.index)
end

function Mount:Dismiss()
    C_MountJournal.Dismiss()
end

function Mount.Once:GetName()
    return (C_MountJournal.GetMountInfo(self.index))
end

function Mount.Once:GetIcon()
    return (select(3, C_MountJournal.GetMountInfo(self.index)))
end

function Mount.Once:GetLink()
    return (GetSpellLink(self.id))
end

function Mount.Once:GetDisplay()
    return (C_MountJournal.GetMountInfoExtra(self.index))
end

local Descriptions = {
    { key = 'Rarity',       name = L['稀有度：'] },
    { key = 'Walk',         name = L['行走方式：'] },
    { key = 'Passenger',    name = L['乘客类型：'] },
    { key = 'Model',        name = L['模型：'] },
    { key = 'Faction',      name = L['阵营：'] },
    { key = 'Source',       name = L['来源：'] },
}

function Mount.Once:GetSummary()
    local _, description, source = C_MountJournal.GetMountInfoExtra(self.index)

    local custom do
        local sb = {}
        for i, v in ipairs(Descriptions) do
            if MOUNT_FILTER_DATA[v.key] and MOUNT_FILTER_DATA[v.key][self:GetAttribute(v.key)] then
                local value = MOUNT_FILTER_DATA[v.key][self:GetAttribute(v.key)].text or UNKNOWN
                if value == L['游戏商城'] then
                    value = format('|Hstore:1|h|cff00ffff[%s]|r|h', value)
                end
                tinsert(sb, format('|cffffd200%s|r%s', v.name, value))
            end
        end
        custom = table.concat(sb, '\n')
    end
    -- source = source:gsub('%.[Bb][Ll][Pp]', ''):gsub('|n|n', '|n')

    local link = {}
    for i, v in ipairs(self:GetAchievementList()) do
        -- tinsert(link, format('|Hachieve:%d|h|cff00ffff[%s]|r|h', v:GetID(), v:GetName()))
        tinsert(link, GetAchievementLink(v:GetID()))
    end

    if #link > 0 then
        return custom .. '\n\n' .. source .. '\n' .. L['|cffffd200相关：|r'] .. table.concat(link) .. '\n\n' .. description
    else
        return custom .. '\n\n' .. source .. '\n\n' .. description
    end    
end

function Mount:IsValid()
    return not self:IsOutOfPrint() and not self:IsHideOnChar() and self:IsInHoliday()
end

function Mount.Once:GetSourceText()
    return (select(3, C_MountJournal.GetMountInfoExtra(self.index)))
end

function Mount:TogglePanel()
    return Addon:ToggleMountJournal(self)
end

function Mount:IsCanRecommend()
    return self:IsValid() and not self:IsCollected() and not self:IsInPlan()
end

function Mount.Once:GetRecommendDescription()
    return (select(3, C_MountJournal.GetMountInfoExtra(self.index))):gsub('%.[Bb][Ll][Pp]', ''):gsub('|n|n', '|n') .. '\n\n' .. L[self:GetRecommendKey()]
end

function Mount.Once:GetTop20List()
    local data = DataCache:GetObject('top20Data'):GetData()
    return data and data[self:GetID()] and 1 or 0
end

function Mount:GetBlipIcon()
    return [[Interface\AddOns\Collector\Media\Mount]]
end

function Mount:GetTypeTexture()
    if self:GetAttribute('Faction') == 0 then
        return [[Interface\PetBattles\MountJournalicons]], 0.3828125, 0.7421875, 0.015625, 0.703125
    elseif self:GetAttribute('Faction') == 1 then
        return [[Interface\PetBattles\MountJournalicons]], 0.0078125, 0.3671875, 0.015625, 0.703125
    end
end

function Mount:GetTypeSize()
    return 46, 44
end