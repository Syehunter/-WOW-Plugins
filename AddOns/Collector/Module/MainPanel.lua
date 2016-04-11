
BuildEnv(...)

MainPanel = Addon:NewModule(GUI:GetClass('Panel'):New(UIParent), 'MainPanel', 'AceEvent-3.0')

function MainPanel:OnInitialize()
    self:SetSize(338, 424)
    self:SetText(L['收藏家'])
    self:SetIcon([[Interface\ICONS\Achievement_BG_winbyten]])
    self:EnableUIPanel(true)
    self:SetTabStyle('BOTTOM')
end