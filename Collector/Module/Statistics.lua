
BuildEnv(...)

local Statistics = Addon:NewModule('Statistics', 'AceEvent-3.0')

function Statistics:OnInitialize()
    self.events = {
        COLLECTOR_FILTER_CLICK = 1,
        COLLECTOR_CURRENTAREA_CLICK = 2,
        COLLECTOR_PLANPLAN_SHOW = 3,
        COLLECTOR_FRIENDFEED_CLICK = 4,
        COLLECTOR_PRAISE_CLICK = 5,
    }

    for k, v in pairs(self.events) do
        self:RegisterMessage(k, 'Record')
    end
end

function Statistics:Record(event)
    Logic:SendServer('CSL', UnitGUID('player'), GetPlayerBattleTag(), ADDON_VERSION_SHORT, self.events[event])
end