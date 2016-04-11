local addonName, at = ...
local core = at.core

-- basic combat indicator

core:AddCallback('Initialize', 'combat', function(self, ...)
	local tab = {}

	tab.enabled = true
	tab.anchor = 'BOTTOM'
	tab.relative = 'BOTTOM'
	tab.x = 0
	tab.y = -4
	tab.width = 25
	tab.height = 25
	tab.scale = 1
	
	self.db.combat = tab
end)

local adapted = {}

local function Combat_OnShow(self)
	local db = core.db.combat
	local tab = adapted[self]
	local frame = tab.combat
	frame:SetSize(db.width, db.height)
	frame:SetScale(db.scale)
	frame:ClearAllPoints()
	frame:SetPoint(db.anchor, tab.parent, db.relative, db.x, db.y)
end

core:AddCallback('Toggle', 'combat', function(self, ...)
	local state = 'RemoveCallback'
	local reg = 'UnregisterEvent'
	if self.db.combat.enabled then
		state = 'AddCallback'
		ref = 'RegisterEvent'
	end
	
	self[state](self, 'NameplateOnHide', 'combatindicator', function(self, frame, hastarget)
		adapted[frame].combat:Hide()
	end)

	self[state](self, 'NameplateOnTargetUpdate', 'combatindicator', function(self, frame)
		adapted[frame].combat:SetShown(UnitAffectingCombat('target'))
		Combat_OnShow(frame)
	end)

	self[state](self, 'NameplateOnMouseover', 'combatindicator', function(self, frame)
		adapted[frame].combat:SetShown(UnitAffectingCombat('mouseover'))
		Combat_OnShow(frame)
	end)
	
end)
core:AddCallback('VariablesLoaded', 'combatindicator', function(self, frame)
	self:AddCallback('NameplateAdded', 'combatindicator', function(self, plate, hp, threat, overlay, name)
		local frame = CreateFrame('Frame', nil, plate)
		
		local texture = frame:CreateTexture()
		texture:SetAllPoints()
		texture:SetTexture("Interface\\CharacterFrame\\UI-StateIcon")
		texture:SetTexCoord(0.5, 1.0, 0, 0.5)
		frame:Hide()
		
		local tab = {}
		tab.combat = frame
		tab.parent = plate
		adapted[plate] = tab
		
		frame:SetFrameStrata('HIGH')
		
		Combat_OnShow(plate)
	end)
end)
