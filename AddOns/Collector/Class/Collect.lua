
BuildEnv(...)

Collect = Addon:NewClass('Collect')

Collect._Meta.__lt = function(a, b)
    return a:GetStamp() > b:GetStamp()
end

function Collect:Constructor(collectType, id, stamp)
    self.collectType = collectType
    self.id = id
    self.stamp = stamp
end

function Collect:GetCollectType()
    return self.collectType
end

function Collect:GetID()
    return self.id
end

function Collect:GetObject()
    return Addon:GetCollectTypeClass(self.collectType):Get(self.id)
end

-- function Collect:GetLink()
--     return self:GetObject():GetLink()
-- end

-- function Collect:GetDisplay()
--     return self:GetObject():GetDisplay()
-- end

-- function Collect:GetIcon()
--     return self:GetObject():GetIcon()
-- end

function Collect:GetStamp()
    return self.stamp
end

function Collect:GetStampText()
    return FriendsFrame_GetLastOnline(self.stamp)
end

-- function Collect:IsCollected()
--     return self:GetObject():IsCollected()
-- end

function Collect:ToDB()
    return table.concat({self.collectType, self.id, self.stamp}, ':')
end