local addonName, at = ...
local core = at.core

local comboframe = CreateFrame('Frame', nil, UIParent)
comboframe:SetFrameStrata('MEDIUM')
comboframe:SetScript("OnEvent", function(self, event, ...)
	self[event](self, ...)
end)

local hasCP, CLASS
local TextureIsShown
local TextureGetVertexColor

core:AddCallback('Initialize', 'combopoints', function(self, ...)
	local tab = {}

	-- no growth direction this time... it just seems like too much for a simple feature and detracts from the idea of the addon.
	tab.enabled = true
	tab.anchor = 'CENTER'
	tab.relative = 'BOTTOM'
	tab.x = 0
	tab.y = -2
	tab.width = 12
	tab.height = 16
	tab.scale = 1
	
	self.db.cp = tab
end)
core:AddCallback('VariablesLoaded', 'combopoints', function(self, frame)
	local _, class = UnitClass('player')
	CLASS = class
	hasCP = class == 'ROGUE' or class == 'DRUID' or false
	if hasCP then
		if class == 'DRUID' then
			comboframe:RegisterEvent('UPDATE_SHAPESHIFT_FORM')
			function comboframe:UPDATE_SHAPESHIFT_FORM()
				--  Thanks to Talasonx over at WoWInterface.com for bringing this up.
				hasCP = GetShapeshiftFormID() == CAT_FORM
			end
			comboframe:UPDATE_SHAPESHIFT_FORM()
		end
		
		comboframe:ClearAllPoints()
		comboframe:SetSize(MAX_COMBO_POINTS * 16, 16) -- 12, 16
		comboframe:SetScale(self.db.cp.scale)
		comboframe:Hide()
		comboframe.point = {}
		
		local width, height = self.db.cp.width, self.db.cp.height
		
		local prev = comboframe -- previous frame/texture
		for x = 1, MAX_COMBO_POINTS do
			local bg = comboframe:CreateTexture(nil, 'BACKGROUND')
			bg:SetTexture("Interface\\ComboFrame\\ComboPoint")
			bg:SetTexCoord(0, 0.375, 0, 1)
			bg:SetSize(width, height)
			if x == 1 then
				bg:SetPoint('LEFT', prev, 'LEFT')
			else
				bg:SetPoint('LEFT', prev, 'RIGHT', 4, 0)-- TODO: check this again later
			end
			bg:Show()
			
			local texture = comboframe:CreateTexture(nil, 'ARTWORK')
			texture:SetTexture("Interface\\ComboFrame\\ComboPoint")
			texture:SetTexCoord(0.375, 0.5625, 0, 1)
			texture:SetSize(width -4, height)
			texture:SetPoint('CENTER', bg, 'CENTER', 0, 0)
			texture:Hide()
			
			local shine = comboframe:CreateTexture(nil, 'OVERLAY')
			shine:SetTexture("Interface\\ComboFrame\\ComboPoint")
			shine:SetTexCoord(0.5625, 1, 0, 1)
			shine:SetBlendMode('ADD')
			shine:SetAlpha(0)
			shine:SetSize(width -2, height)
			shine:SetPoint('CENTER', bg, 'CENTER', 0, 4)
			
			comboframe.point[x] = {
				background = bg,
				texture = texture,
				shine = shine,
			}
			prev = bg
		end
		TextureIsShown = prev.IsShown
		TextureGetVertexColor = prev.GetVertexColor
	end
end)

function comboframe:PLAYER_ENTERING_WORLD()
	comboframe:Hide()
end

function comboframe:PLAYER_TARGET_CHANGED()
	if not UnitExists('target') then
		self:Hide()
		--comboframe:SetParent(nil)
		self.Parent = nil
	end
end

core:AddCallback('Toggle', 'cp', function(self, ...)
	if hasCP then
		local state = 'RemoveCallback'
		local reg = 'UnregisterEvent'
		if self.db.cp.enabled then
			state = 'AddCallback'
			reg = 'RegisterEvent'
		end
		if CLASS == 'DRUID' then comboframe[reg](comboframe, 'UPDATE_SHAPESHIFT_FORM') end
		comboframe[reg](comboframe, 'UNIT_COMBO_POINTS', 'player')
		comboframe[reg](comboframe, 'PLAYER_ENTERING_WORLD')
		--comboframe[reg](comboframe, 'PLAYER_TARGET_CHANGED')
		
		self[state](self, 'NameplateOnHide', 'combopoints', function(self, frame, hastarget)
			if frame == comboframe.Parent then
				comboframe:PLAYER_TARGET_CHANGED()
			end
		end)

		self[state](self, 'NameplateOnTargetUpdate', 'combopoints', function(self, frame)
			if hasCP and UnitCanAttack('player', 'target') then
				comboframe:Show()
				comboframe:ClearAllPoints()
				comboframe:SetPoint(self.db.cp.anchor, frame, self.db.cp.relative, self.db.cp.x, self.db.cp.y)
				comboframe:SetScale(self.db.cp.scale)
				comboframe:SetParent(frame)
				comboframe.Parent = frame
			end
		end)
	end
end)







do
	local NewTimer = C_Timer.NewTimer

	local UIFrameFadeOut = UIFrameFadeOut
	local UIFrameFadeIn = UIFrameFadeIn
	
	local COMBO_LAST_NUM_POINTS = 0
	local animationGroup = comboframe:CreateAnimationGroup()
	local flash = animationGroup:CreateAnimation('Animation')
	flash:SetDuration(COMBOFRAME_SHINE_FADE_IN)
	local function fadeout(self)
		UIFrameFadeOut(comboframe.point[self.num].shine, COMBOFRAME_SHINE_FADE_OUT, 1, 0)
	end
	flash:SetScript('OnPlay', function()
		UIFrameFadeIn(comboframe.point[COMBO_LAST_NUM_POINTS].shine, COMBOFRAME_SHINE_FADE_IN, 0, 1)
		local sub = NewTimer(COMBOFRAME_SHINE_FADE_IN, fadeout)
		sub.num = COMBO_LAST_NUM_POINTS
		
	end)
	animationGroup:SetLooping('NONE')
	
	
	function comboframe:UNIT_COMBO_POINTS()
		local prevPoint = COMBO_LAST_NUM_POINTS
		local count = GetComboPoints('player', 'target')
		for x = 1, MAX_COMBO_POINTS do
			if x <= count then
				self.point[x].texture:Show()
			else
				self.point[x].texture:Hide()
			end
			
		end
		COMBO_LAST_NUM_POINTS = count
		if count > 0 then
			if prevPoint > 0 then
				animationGroup:Play()
			end
		else
			COMBO_LAST_NUM_POINTS = 1
		end
		core:PLAYER_TARGET_CHANGED() -- trigger an update
	end
end
