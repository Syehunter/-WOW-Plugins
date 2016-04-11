
BuildEnv(...)

function tIndexOf(t, item)
    for i, v in ipairs(t) do
        if v == item then
            return i
        end
    end
end

function GetAddonSource()
end

function GetPlayerBattleTag()
    return (select(2, BNGetInfo()))
end

function GetFullName(name, realm)
    if strfind(name, '-', nil, true) then
        return name
    else
        return name .. '-' .. (realm or GetRealmName()):gsub('%s+', '')
    end
end

local function tolist(data)
    if type(data) == 'string' then
        return data ~= '' and {strsplit(';', data)} or nil
    elseif type(data) == 'table' then
        return data
    else
        return {}
    end
end

function split(data, c)
    local args = {strsplit(c or ':', data)}
    for i, v in ipairs(args) do
        args[i] = tonumber(v) or v
    end
    return unpack(args)
end

function DecodeCollectList(data)
    local data = tolist(data)
    local list = {}
    for i, v in ipairs(data) do
        list[i] = Collect:New(split(v))
    end
    return list
end

function DecodeTargetList(list)
    local list = tolist(list)
    for i, v in ipairs(list) do
        local target, stamp = split(v)
        list[i] = {
            target = target,
            stamp = stamp,
        }
    end
    return list
end

function EncodeTargetList(list)
    local results = {}
    for i, v in ipairs(list) do
        results[i] = format('%s:%d', v.target, v.stamp)
    end
    return results
end

function IsBossCanKill(instance, boss, difficulty)
    if not instance and not boss then
        return
    end
    if instance then
        difficulty = difficulty and CopyTable(difficulty)

        for i = 1, GetNumSavedInstances() do
            local instanceName, _, _, diff, locked, extended, _, _, _, _, maxBosses = GetSavedInstanceInfo(i)
            if instanceName == instance and (not difficulty or difficulty[diff]) then
                if not locked then
                    return true
                end
                for j = 1, maxBosses do
                    local bossName, _, locked = GetSavedInstanceEncounterInfo(i, j)
                    if not boss and not locked then
                        return true
                    end
                    if bossName == boss then
                        if not locked then
                            return true
                        elseif not difficulty then
                            return false
                        else
                            difficulty[diff] = nil
                        end
                    end
                end
            end 
        end

        if difficulty then
            return not not next(difficulty)
        end
    else
        for i = 1, GetNumSavedWorldBosses() do
            if GetSavedWorldBossInfo(i) == boss then
                return false
            end
        end
    end
    return true
end

local _TYPES = {
    Acquire = {
        drop = 'Npc',
        sold = 'Npc',
        achievement = 'Achievement',
        object = 'GameObject',
    },
    Achievement = {
        achievement = 'Achievement',
    },
    Sold = {
        sold = 'Npc',
    },
    Drop = {
        drop = 'Npc',
    },
}

function IsItemType(t)
    return t == 'item' or t == 'contain'
end

function GetAcquireList(tbl, id, types, results)
    local data = tbl[id]
    types = type(types) == 'table' and types or _TYPES[types]
    results = results or {}

    if data and data.Acquire and types then
        for i, v in ipairs(data.Acquire) do
            local type, id = split(v, ':')

            if IsItemType(type) then
                GetAcquireList(ITEM_DATA, id, types, results)
            elseif types[type] then
                tinsert(results, Addon:GetClass(types[type]):Get(id))
            end
        end
    end
    return results
end

function GetPlayerSide()
    local side = UnitFactionGroup('player')
    if side == 'Alliance' then
        return 1
    elseif side == 'Horde' then
        return 2
    else
        return 3
    end
end

function GetItemData(tbl, id)
    local data = tbl[id]
    if not data or not data.Acquire then
        return
    end

    local side = GetPlayerSide()

    for i, v in ipairs(data.Acquire) do
        local type, id = split(v)
        if IsItemType(type) then
            local item = ITEM_DATA[id]    
            if item and (not item.Side or item.Side == side) then
                -- return item
                return id
            end
        end
    end
end

local function FillDropList(token, acquire, object, results)
    if not acquire or not results then
        return
    end

    for _, v in ipairs(acquire) do
        local type, item = split(v)
        if IsItemType(type) and ITEM_DATA[item] then
            FillDropList(token, ITEM_DATA[item].Acquire, object, results)
        elseif v == token then
            tinsert(results, object)
        end
    end
end

function GetDropList(prefix, id)
    local results = {}
    local token = prefix .. id
    for klass, v in pairs(COLLECTIONS_DATAS) do
        for id, v in pairs(v) do
            FillDropList(token, v.Acquire, Addon:GetClass(klass):Get(id), results)
        end
    end
    return results
end

function InvokeForEachi(list, callback)
    if type(list) ~= 'table' then
        error(([[bad argument #1 to 'InvokeForEachi' (table expected, got %s)]]):format(type(list)), 2)
    end
    if type(callback) ~= 'function' then
        error(([[bad argument #2 to 'InvokeForEachi' (function expected, got %s)]]):format(type(callback)), 2)
    end

    for i, v in ipairs(list) do
        C_Timer.After(0, function()
            callback(i, v)
        end)
    end
end

function InvokeForEach(list, callback)
    if type(list) ~= 'table' then
        error(([[bad argument #1 to 'InvokeForEach' (table expected, got %s)]]):format(type(list)), 2)
    end
    if type(callback) ~= 'function' then
        error(([[bad argument #2 to 'InvokeForEach' (function expected, got %s)]]):format(type(callback)), 2)
    end

    for k, v in pairs(list) do
        C_Timer.After(0, function()
            callback(k, v)
        end)
    end
end

function IsInHoliday(holiday)
    local _, month, day, year = CalendarGetDate()
    CalendarSetAbsMonth(month, year)

    for i = 1, CalendarGetNumDayEvents(0, day) do
        if holiday == CalendarGetHolidayInfo(0, day, i) then
            return true
        end
    end
end