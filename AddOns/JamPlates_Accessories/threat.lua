local addonName, at = ...
local core = at.core

core:AddCallback('Initialize', 'threat', function(self, ...)
	local tab = {}

	tab.enabled = false
	tab.anchor = 'LEFT'
	tab.relative = 'BOTTOMRIGHT'
	tab.x = -1
	tab.y = 10
	tab.width = 32
	tab.height = 32
	tab.scale = 1
	
	self.db.threat = tab
end)


local adapted = {}
core.threat = {} -- table to store excess threat textures

local threatStates = {
	-- TODO: maybe change color
	[1] = "Interface\\AddOns\\" .. addonName .. "\\Media\\Threat_Low",
	[2] = "Interface\\AddOns\\" .. addonName .. "\\Media\\Threat_Medium",
	[3] = "Interface\\AddOns\\" .. addonName .. "\\Media\\Threat_Medium",
	[4] = "Interface\\AddOns\\" .. addonName .. "\\Media\\Threat_High",
}
local function Frame_SetTexture(self, state)
	self.texture:SetTexture(threatStates[state])
	self:Show()
end

-- Being green ain't easy.
local function RecyctableThreat(tab)
	if tab then
		-- put frame back into free frames
		tab:Hide()
		core.threat[#core.threat +1] = tab
		return nil

	elseif #core.threat > 0 then
		-- get a frame and send it out; there's no need for it to stick around either
		tab = core.threat[#core.threat]
		tab:SetSize(core.db.threat.width, core.db.threat.height)
		tab:SetScale(core.db.threat.scale)

		core.threat[#core.threat] = nil
		return tab

	else
		-- if nothing else just send a fresh frame; it should be returned later
		local frame = CreateFrame('Frame', nil, UIParent)
		frame:SetSize(core.db.threat.width, core.db.threat.height)
		frame:SetScale(core.db.threat.scale)
		frame:Hide()

		local texture = frame:CreateTexture()
		texture:SetTexture(threatStates[1])
		texture:SetAllPoints(frame)
		frame.texture = texture


		frame.SetThreatTexture = Frame_SetTexture

		frame.states = threatStates
		return frame

	end
end


local function Nameplate_OnUpdate(self, state, red, green, blue, alpha)
	--if self.threatFrame then
		if self.threat:IsShown() then
			red, green, blue, alpha = self.threat:GetVertexColor()

			if red > 0 then
				if green > 0 then
					if blue > 0 then
						state = 2
					else
						state = 3
					end
				else
					state = 4
				end
			else
				state = 1
			end
			if state ~= self.threatState then
				self.threatFrame:SetThreatTexture(state)
			end
			self.threatState = state

		elseif self.threatState then
			self.threatFrame:Hide()
			self.threatState = nil

		end
	--end
end

core:AddCallback('Toggle', 'threat', function(self, ...)
	local state = 'RemoveCallback'
	if self.db.threat.enabled then
		state = 'AddCallback'
		for plate, frame in pairs(adapted) do
			frame:Show()
			frame.threatFrame = RecyctableThreat()
		end
	else
		for plate, frame in pairs(adapted) do
			frame:Hide()
			frame.threatFrame = RecyctableThreat(frame.threatFrame)
		end
	end
	
	self[state](self, 'NameplateOnShow', 'threat', function(self, frame)
		local tab = adapted[frame]
		tab.threatFrame = RecyctableThreat()
		tab.threatFrame:SetParent(frame)
		tab.threatFrame:SetPoint(self.db.threat.anchor, frame, self.db.threat.relative, self.db.threat.x, self.db.threat.y)
		
		adapted[frame] = tab
	end)
	
	self[state](self, 'NameplateOnHide', 'threat', function(self, frame)
		adapted[frame].threatFrame = RecyctableThreat(adapted[frame].threatFrame)
		adapted[frame].threatState = nil
	end)
	
end)

core:AddCallback('VariablesLoaded', 'threat', function(self, frame)
	self:AddCallback('NameplateAdded', 'threat', function(self, frame, _, threat)
		local sub = CreateFrame('Frame', nil, frame)
		sub.threat = threat
		local visibility = self.db.threat.enabled and self.Show or self.Hide
		visibility(sub)
		sub:HookScript('OnUpdate', Nameplate_OnUpdate)
		adapted[frame] = sub
	end)
end)
