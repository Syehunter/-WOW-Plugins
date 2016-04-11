
BuildEnv(...)

CurrentActivity = Addon:NewClass('CurrentActivity', BaseActivity)

CurrentActivity:InitAttr{
    'Title',
}

function CurrentActivity:Constructor(...)
    local data = ...
    if type(data) == 'table' then
        self:FromAddon(...)
    elseif data then
        self:FromSystem(...)
    end
end

function CurrentActivity:FromAddon(data)
    for k, v in pairs(data) do
        local func = self['Set' .. k]
        if type(func) == 'function' then
            func(self, v)
        end
    end
end

function CurrentActivity:FromSystem(activityId, ilvl, title, comment, voiceChat)
    self:SetActivityID(activityId)
    self:SetItemLevel(ilvl)
    self:SetVoiceChat(voiceChat)
    self:UpdateCustomData(comment, title)
end

function CurrentActivity:GetTitle()
    return format('%s-%s-%s-%s', L['集合石'], self:GetLootText(), self:GetModeText(), self:GetName())
end

function CurrentActivity:GetCreateArguments(autoAccept)
    local comment = CodeCommentData(self)
    return  self:GetActivityID(),
            self:GetTitle(),
            self:GetItemLevel(),
            self:GetVoiceChat(),
            self:GetSummary() .. comment,
            autoAccept
end