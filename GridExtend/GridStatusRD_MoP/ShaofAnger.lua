-- local zone = "Kun-Lai Summit"
local zoneid = 809

-- Check Compatibility
local GridStatusRaidDebuff = GridStatusRaidDebuff;
local function import(self)

-- zoneid, debuffID, order, icon_priority, color_priority, timer, stackable, color, default_disable, noicon

--Sha of Anger
GridStatusRaidDebuff:BossNameId(zoneid, 10, "Sha of Anger")
GridStatusRaidDebuff:DebuffId(zoneid, 119626, 11, 3, 3) --Aggressive Behavior [NOTE: this is the MC]
GridStatusRaidDebuff:DebuffId(zoneid, 119488, 12, 3, 3) --Unleashed Wrath [NOTE: Must heal these people. Lots of shadow dmg]
GridStatusRaidDebuff:DebuffId(zoneid, 119610, 13, 3, 3) --Bitter Thoughts (Silence) [NOTE: There are 2 spell IDs in the logs for Bitter Thoughts. which one will Blizzard go with?]
GridStatusRaidDebuff:DebuffId(zoneid, 119601, 14, 3, 3) --Bitter Thoughts (Silence) [NOTE: There are 2 spell IDs in the logs for Bitter Thoughts. which one will Blizzard go with?]
end

GridStatusRaidDebuff:Import(import)
