
BuildEnv(...)

local TutorialPointerFrame = Addon:NewClass('TutorialPointerFrame', 'Frame.TutorialPointerFrame')

function TutorialPointerFrame:Constructor()
    self.Arrow = {
        UP1 = self.Arrow_UP1,
        UP2 = self.Arrow_UP2,
        DOWN1 = self.Arrow_DOWN1,
        DOWN2 = self.Arrow_DOWN2,
        LEFT1 = self.Arrow_LEFT1,
        LEFT2 = self.Arrow_LEFT2,
        RIGHT1 = self.Arrow_RIGHT1,
        RIGHT2 = self.Arrow_RIGHT2,
    }
    self:SetFrameStrata('DIALOG')
end

function TutorialPointerFrame:Play()
    self:Play()
end

function TutorialPointerFrame:Open(direction)
    local arrow = self.Arrow[direction .. 1]
    arrow:Show()
    arrow.Anim:Play()

    self.AnimDelayTimer = C_Timer.NewTimer(0.5, function()
        local arrow = self.Arrow[direction .. 2]
        arrow:Show()
        arrow.Anim:Play()
    end)

    self:Show()
end

function TutorialPointerFrame:Close()
    if self.AnimDelayTimer then
        self.AnimDelayTimer:Cancel() 
        self.AnimDelayTimer = nil
    end

    for k, v in pairs(self.Arrow) do
        v:Hide()
        v.Anim:Stop()
    end

    self:Hide()
end

TutorialPointerManager = Addon:NewModule('TutorialPointerManager', 'AceEvent-3.0')

function TutorialPointerManager:OnInitialize()
    self.pointerCache = {}
    self.usedCache = {}
    self.DirectionData = {
        UP = {
            Anchor          = 'TOP',
            RelativePoint   = 'BOTTOM',
            ContentOffsetY  = 5,
            Opposite        = 'DOWN',
        },
        DOWN = {
            Anchor          = 'BOTTOM',
            RelativePoint   = 'TOP',
            ContentOffsetY  = -5,
            Opposite        = 'UP',
        },
        LEFT = {
            Anchor          = 'LEFT',
            RelativePoint   = 'RIGHT',
            ContentOffsetX  = -5,
            Opposite        = 'RIGHT',
        },
        RIGHT = {
            Anchor          = 'RIGHT',
            RelativePoint   = 'LEFT',
            ContentOffsetX  = 5,
            Opposite        = 'LEFT',
        },
    }
end

function TutorialPointerManager:GetPointer(anchorFrame)
    return tremove(self.pointerCache) or TutorialPointerFrame:New(anchorFrame)
end

function TutorialPointerManager:Toggle(content, event, direction, anchorFrame, ofsX, ofsY, relativePoint)
    ofsX = ofsX or 0
    ofsY = ofsY or 0

    local arrow = self.DirectionData[direction]

    if not arrow then
        error(([[bad argument #1 to 'function' (string expected, got %s)]]):format(type(direction)), 2)
    end

    local frame = self:GetPointer(anchorFrame)
    self.usedCache[event] = frame

    frame:ClearAllPoints()
    frame:SetParent(anchorFrame)

    frame:SetPoint(arrow.Anchor, anchorFrame, relativePoint or arrow.RelativePoint, ofsX, ofsY)
    frame.Content:ClearAllPoints()
    frame.Content:SetPoint(arrow.Anchor, frame, arrow.RelativePoint, arrow.ContentOffsetX or 0, arrow.ContentOffsetY or 0)

    frame.Content.Text:SetText(content)
    frame.Content:SetHeight(frame.Content.Text:GetHeight() + 40)

    frame:Open(direction)

    self:RegisterMessage(event, 'OnEvent')
end

function TutorialPointerManager:OnEvent(event, ...)
    self:UnregisterMessage(event)
    local frame = self.usedCache[event]
    if frame then
        frame:Close()
        self.usedCache[event] = nil
        tinsert(self.pointerCache, frame)
    end
end