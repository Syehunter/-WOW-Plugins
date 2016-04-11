
BuildEnv(...)

local Card = Addon:NewClass('Card', 'Frame')

GUI:Embed(Card, 'Refresh')

function Card:Constructor()
    local CardInset = CreateFrame('Frame', nil, self, 'InsetFrameTemplate') do
        CardInset:SetPoint('TOPLEFT')
        CardInset:SetPoint('TOPRIGHT')
        CardInset:SetHeight(171)
        CardInset.Bg:SetHorizTile(false)
        CardInset.Bg:SetVertTile(false)
        CardInset.Bg:SetAtlas('PetJournal-PetCard-BG')
    end

    local CardIcon = CardInset:CreateTexture(nil, 'ARTWORK') do
        CardIcon:SetPoint('TOPLEFT', 20, -20)
        CardIcon:SetSize(32, 32)
    end

    local CardName = CardInset:CreateFontString(nil, 'ARTWORK', 'GameFontNormal') do
        CardName:SetPoint('LEFT', CardIcon, 'RIGHT', 5, 0)
    end

    local CardModel = CreateFrame('PlayerModel', nil, CardInset, 'ModelTemplate') do
        CardModel:SetSize(CardInset:GetHeight() * 1.3, CardInset:GetHeight() -25)
        CardModel:SetPoint('RIGHT', -20, 10)
        CardModel.defaultRotation = -MODELFRAME_DEFAULT_ROTATION
        CardModel.rotation = -MODELFRAME_DEFAULT_ROTATION
    end

    local CardRarity = CreateFrame('Frame', nil, CardInset) do
        CardRarity:SetFrameLevel(CardModel:GetFrameLevel() + 10)
        CardRarity:SetPoint('TOPRIGHT', -20, -20)
        CardRarity:SetSize(100, 20)
        CardRarity:Hide()

        local Text = CardRarity:CreateFontString(nil, 'OVERLAY', 'GameFontNormalRight') do
            Text:SetAllPoints(true)
            CardRarity.Text = Text
        end

        CardRarity:SetScript('OnEnter', function(self)
            if self.tip then
                GameTooltip:SetOwner(CardRarity, 'ANCHOR_RIGHT')
                GameTooltip:SetText(self.tip)
                GameTooltip:Show()
            end
        end)
        CardRarity:SetScript('OnLeave', function(self)
            GameTooltip:Hide()
        end)
    end

    local CardProcessBar = CreateFrame('StatusBar', nil, CardInset) do
        CardProcessBar:SetSize(390, 10)
        CardProcessBar:SetPoint('BOTTOM', 0, 10)
        CardProcessBar:SetStatusBarTexture([[Interface\PaperDollInfoFrame\UI-Character-Skills-Bar]], 'ARTWORK')
        CardProcessBar:SetMinMaxValues(0, 100)

        local Left = CardProcessBar:CreateTexture(nil, 'OVERLAY') do
            Left:SetPoint('LEFT', -3, 0)
            Left:SetSize(9, 13)
            Left:SetTexture([[Interface\PaperDollInfoFrame\UI-Character-Skills-BarBorder]])
            Left:SetTexCoord(0.007843, 0.043137, 0.193548, 0.774193)
        end

        local Right = CardProcessBar:CreateTexture(nil, 'OVERLAY') do
            Right:SetPoint('RIGHT', 3, 0)
            Right:SetSize(9, 13)
            Right:SetTexture([[Interface\PaperDollInfoFrame\UI-Character-Skills-BarBorder]])
            Right:SetTexCoord(0.043137, 0.007843, 0.193548, 0.774193)
        end

        local Middle = CardProcessBar:CreateTexture(nil, 'OVERLAY') do
            Middle:SetPoint('TOPLEFT', Left, 'TOPRIGHT')
            Middle:SetPoint('BOTTOMRIGHT', Right, 'BOTTOMLEFT')
            Middle:SetTexture([[Interface\PaperDollInfoFrame\UI-Character-Skills-BarBorder]])
            Middle:SetTexCoord(0.113726, 0.1490196, 0.193548, 0.774193)
        end

        local Bg = CardProcessBar:CreateTexture(nil, 'BACKGROUND') do
            Bg:SetAllPoints(true)
            Bg:SetTexture(0.04, 0.07, 0.18)
        end
    end

    local CardProcessText = CardProcessBar:CreateFontString(nil, 'OVERLAY') do
        CardProcessText:SetPoint('CENTER', 0, 2)
        CardProcessText:SetFont(ChatFontNormal:GetFont(), 12, 'OUTLINE')
    end

    local InfoInset = CreateFrame('Frame', nil, self, 'InsetFrameTemplate') do
        InfoInset:SetPoint('TOPLEFT', CardInset, 'BOTTOMLEFT', 0, -30)
        InfoInset:SetPoint('BOTTOMRIGHT')
    end

    local InfoTab = GUI:GetClass('InTabPanel'):New(InfoInset) do
        InfoTab:SetPoint('TOPLEFT', 3, -3)
        InfoTab:SetPoint('BOTTOMRIGHT', -3, 3)
    end

    local Map = Addon:GetClass('TabMap'):New(self) do
        InfoTab:RegisterPanel(L['地图'], Map, 0)
    end

    local Summary = Addon:GetClass('TabSummary'):New(self) do
        InfoTab:RegisterPanel(L['详情'], Summary, 0)
    end

    local Feed = Addon:GetClass('TabFeed'):New(self) do
        InfoTab:RegisterPanel(L['动态'], Feed, 0)
    end

    self.CardInset = CardInset
    self.InfoInset = InfoInset

    self.CardIcon = CardIcon
    self.CardName = CardName
    self.CardRarity = CardRarity
    self.CardModel = CardModel
    self.CardProcessBar = CardProcessBar
    self.CardProcessText = CardProcessText

    self.Feed = Feed
    self.Map = Map
    self.Summary = Summary
end

function Card:SetRarity(item)
    local rarity = item:GetAttribute('Rarity')
    local rarityData = rarity and RARITY_DATA[rarity]
    if rarityData then
        self.CardRarity.Text:SetText(rarityData.text)
        self.CardRarity.tip = rarityData.tip
        self.CardRarity:Show()
    else
        self.CardRarity:Hide()
    end
end

function Card:SetPlan(plan)
    self.plan = plan
    self:Refresh()
end

function Card:Update()
    local plan = self.plan
    local item = plan:GetObject()

    self.CardIcon:SetTexture(item:GetIcon())

    if IsGMClient() then
        self.CardName:SetText(item:GetName() .. ' |cffffd200(' .. item:GetID() .. ')|r')
    else
        self.CardName:SetText(item:GetName())
    end

    self:SetRarity(item)
    self.CardModel:SetDisplayInfo(item:GetDisplay())
    Model_Reset(self.CardModel)
    self.CardModel:SetDoBlend(false)

    if not item:IsCollected() and item:GetProgressObject() then
        local color = item:GetProgressColor()
        local progress = item:GetProgressRate() * 100
        local name = item:GetProgressName()

        self.CardProcessText:SetText(format('%s (%d%%)', name, progress))
        self.CardProcessBar:SetValue(progress)
        self.CardProcessBar:SetStatusBarColor(color.r, color.g, color.b)
        self.CardProcessBar:Show()
    else
        self.CardProcessBar:Hide()
    end

    self.Map:SetPlan(plan)
    self.Summary:SetPlan(plan)
    self.Feed:SetPlan(plan)
end