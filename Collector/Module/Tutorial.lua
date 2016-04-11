
BuildEnv(...)

local Tutorial = Addon:NewModule('Tutorial', 'AceEvent-3.0', 'AceHook-3.0', 'AceTimer-3.0')

function Tutorial:OnInitialize()
    GUI:Embed(self, 'Help')

    local MountJournalHelpList = {
        FramePos = { x = 0,          y = -22 },
        FrameSize = { width = 700, height = 580 },
        { ButtonPos = { x = 106,   y = -35 }, HighLightBox = { x = 10, y = -45, width = 247, height = 30 },   ToolTipDir = "DOWN",  ToolTipText = L.MJHelp1 },
        { ButtonPos = { x = 105,  y = -300 }, HighLightBox = { x = 10, y = -78, width = 247, height = 477 },  ToolTipDir = "DOWN",  ToolTipText = L.MJHelp2 },
        { ButtonPos = { x = 525,  y = -546},  HighLightBox = { x = 550, y = -556, width = 150, height = 26 }, ToolTipDir = "UP",    ToolTipText = L.MJHelp3 },
        { ButtonPos = { x = 470,  y = -95 },  HighLightBox = { x = 290, y = -45, width = 400, height = 160 }, ToolTipDir = "RIGHT", ToolTipText = L.MJHelp4 },
        { ButtonPos = { x = 175,  y = 0 },    HighLightBox = { x = 200, y = 0, width = 150, height = 40 },    ToolTipDir = "UP",    ToolTipText = L.MJHelp5 },
    }

    local PlanPanelHelpList = {
        FramePos = { x = 0,          y = 0 },
        FrameSize = { width = 700, height = 530 },
        { ButtonPos = { x = 105,  y = -200 }, HighLightBox = { x = 5, y = -5, width = 250, height = 510 },    ToolTipDir = "DOWN",  ToolTipText = L.PPHelp1 },
        { ButtonPos = { x = 450,  y = -55 },  HighLightBox = { x = 270, y = -5, width = 420, height = 165 },  ToolTipDir = "RIGHT", ToolTipText = L.PPHelp2 },
        { ButtonPos = { x = 450,  y = -295 }, HighLightBox = { x = 270, y = -172, width = 420, height = 343 },ToolTipDir = "UP",    ToolTipText = L.PPHelp3 },
    }

    local FriendFeedHelpList = {
        FramePos = { x = 0,          y = 0 },
        FrameSize = { width = 250, height = 394 },
        { ButtonPos = { x = 105,  y = -50 },  HighLightBox = { x = 15, y = -50, width = 220, height = 40 },   ToolTipDir = "DOWN",  ToolTipText = L.FFHelp1 },
        { ButtonPos = { x = 105,  y = -200 }, HighLightBox = { x = 15, y = -110, width = 220, height = 270 }, ToolTipDir = "DOWN",  ToolTipText = L.FFHelp2 },
    }


    self:AddHelpButton(FriendFeed, FriendFeedHelpList, nil, FriendsFrame)
    self:AddHelpButton(MountJournal, MountJournalHelpList, function(enable)
        self:SendMessage('COLLECTOR_HELP_UPDATE', enable)
    end, CollectionsJournal)
    self:AddHelpButton(PlanPanel, PlanPanelHelpList, nil, CollectionsJournal)

    self:RegisterMessage('COLLECTOR_FIRST_LOGIN')
end

function Tutorial:ShowHelp(...)
    self:ScheduleTimer(self.ShowHelpPlate, 0.04, self, ...)
end

function Tutorial:COLLECTOR_FIRST_LOGIN()
    TutorialPointerManager:Toggle(L.FHelp1, 'COLLECTOR_MOUNTJOURNAL_SHOW', 'DOWN', CollectionsMicroButton)
    if CollectionsJournal_SetTab then
        CollectionsJournal_SetTab(CollectionsJournal, 1)
    else
        SetCVar('petJournalTab', 1)
    end

    self:RegisterMessage('COLLECTOR_MOUNTJOURNAL_SHOW', function(event)
        self:UnregisterMessage('COLLECTOR_MOUNTJOURNAL_SHOW')
        self:ShowHelp(MountJournal)
        TutorialPointerManager:Toggle(L.FHelp5, 'COLLECTOR_HELP_UPDATE', 'DOWN', self.helpButtons[MountJournal])
        self:RegisterMessage('COLLECTOR_RECOMMEND_SHOW', function()
            self:UnregisterMessage('COLLECTOR_RECOMMEND_SHOW')
            TutorialPointerManager:Toggle(L.FHelp4, 'COLLECTOR_RECOMMEND_HIDE', 'DOWN', MountPanel.BlockButton)
        end)
    end)

    self:RegisterMessage('COLLECTOR_PLANPLAN_SHOW', function(event)
        self:UnregisterMessage(event)
        self:ShowHelp(PlanPanel)
    end)

    self:RegisterMessage('COLLECTOR_FRIENDFEED_SHOW', function(event)
        self:UnregisterMessage(event)
        self:ShowHelp(FriendFeed)
    end)

    self:RegisterMessage('COLLECTOR_PLANBUTTON_CHANGED', function(event, enable)
        if not enable then
            return
        end
        self:UnregisterMessage(event)
        TutorialPointerManager:Toggle(L.FHelp2, 'COLLECTOR_PLANLIST_UPDATE', 'UP', MountPanel.PlanButton)
    end)

    self:RegisterMessage('COLLECTOR_PLANLIST_UPDATE', function(event)
        self:UnregisterMessage(event)
        TutorialPointerManager:Toggle(L.FHelp3, 'COLLECTOR_PLANPLAN_SHOW', 'UP', PlanPanel.Tab)
    end)

    self:RegisterMessage('COLLECTOR_WORLDMAP_SHOW', function(event)
        self:UnregisterMessage(event)
        TutorialPointerManager:Toggle(L.MapHelp1, 'COLLECTOR_WORLDMAPBUTTON_CLICK', 'UP', WorldMap.Button)
    end)
end