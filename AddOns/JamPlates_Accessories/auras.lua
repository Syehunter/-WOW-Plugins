local addonName, at = ...
local core = at.core

local main = CreateFrame('Frame', nil, UIParent)
main:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)

core:AddCallback('Initialize', nil, function(self, ...)
	local tab = {}

	tab.enabled = true
	tab.invert = false
	tab.ShowPet = true
	tab.ShowBorder = true
	tab.BPR = 6
	tab.scale = 1
	tab.width = 17
	tab.height = 17
	tab.anchor = 'BOTTOMLEFT'
	tab.relative = 'TOPLEFT'
	tab.growth = false
	tab.direction = false
	tab.x = 0
	tab.y = 0
	tab.filter = {
		--[1459] = true, -- mage: arcane brilliance
		--[21562] = true, -- priest: Power word: fortitude
	}
	
	self.db.aura = self:CopyTable(tab)

	self:AddCallback('VariablesLoaded', 'aura', function(self)
		self.spells = JamPlatesAccessoriesDB.spells or {}
		if not self.db.aura then
			self.db.aura = self:CopyTable(tab)
		else
			self.db.aura.filter = self:CopyTable(JamPlatesAccessoriesDB[JamPlatesAccessoriesCP].aura.filter)
		end
	end)


	tab = {}

	tab.enabled = true
	tab.ShowPet = true
	tab.BPR = 6
	tab.scale = 1
	tab.width = 17
	tab.height = 17
	tab.anchor = 'RIGHT'
	tab.relative = 'LEFT'
	tab.growth = false
	tab.direction = true
	tab.x = 0
	tab.y = 0
	tab.filter = {
		--[1459] = true, -- mage: arcane brilliance
		--[21562] = true, -- priest: Power word: fortitude
	}
	
	self.db.tracker = self:CopyTable(tab)
	
	self:AddCallback('VariablesLoaded', 'tracker', function(self)
		if not self.db.tracker then
			self.db.tracker = self:CopyTable(tab)
		else
			self.db.tracker.filter = self:CopyTable(JamPlatesAccessoriesDB[JamPlatesAccessoriesCP].tracker.filter)
		end
	end)
end)


core.auras = {}
core.tracker = {}
core.spells = {}

--upvalue
local select = select
local UnitPlayerControlled = UnitPlayerControlled
local UnitIsDead = UnitIsDead
local UnitAura = UnitAura
local UnitCanAttack = UnitCanAttack
local strfind, ipairs = string.find, ipairs
local rad, ceil = math.rad, math.ceil
local NumberFontNormalYellow = NumberFontNormalYellow
local SystemFont_Shadow_Med1 = SystemFont_Shadow_Med1



-- functions
--[[
	Draws both the timer and spiral on every frame update.

		Rather than create a giant iteration over a giant table,
		creating a stop gap method, I draw things on their individual
		updates.  That means it will only do things when visible(no
		need for giant IF/ELSEIF statements) with no iteration over
		multiple tables.

--]]
local function Cooldown_OnUpdate(self, elapsed)
	-- make sure it even needs a timer
	if self.time then
		elapsed = self.time - GetTime()

		-- check if time remaining is greater than a hour, a minute or a second;
		-- hide the timer if none of the above
		if elapsed >= 3600 then
			self.timer:SetFormattedText("%d h", ceil(elapsed / 3600))

		elseif elapsed > 60 then
			self.timer:SetFormattedText("%d m", ceil(elapsed / 60))

		elseif elapsed > 0 then
			self.timer:SetFormattedText("%d s", ceil(elapsed))

		else
			self.timer:SetText("")
			self.time = nil
			self.Parent:Hide()
		end

		-- get a radial to determine rotational position of spiral
		-- this also determines if the solid half is displayed
		local p = ( elapsed /1e3) / (self.duration /1e3)
		if p > 0.5 then
		  if self.inverse then
			self.stationary:Hide()
			self.scrollframe:ClearAllPoints()
			self.scrollframe:SetPoint('LEFT', self, 'CENTER')
			self.inverse = false
		  end

		else
		  if not self.inverse then
			self.stationary:Show()
			self.scrollframe:ClearAllPoints()
			self.scrollframe:SetPoint('RIGHT', self, 'CENTER')
			self.inverse = true
		  end
		  
		end

		self.rotatable:SetRotation(rad(180*(p*2)))
	end
end
local function Cooldown_OnHide(self, elapsed)
	self.stationary:Hide()
	self.scrollframe:ClearAllPoints()
	self.scrollframe:SetPoint('LEFT', self, 'CENTER')
	self.inverse = false
end

--[[
	Create a CoolDown Frame of my own design.
	Using a scroll frame to hide components that fall outside its region
		makes the rotating block appear to only affect the visible area.
		Zork inspired this with his take on Ring Thoery on
		WoWInterface.com.
--]]
local function CreateCooldown(frame)
	local main = CreateFrame('Frame', nil, frame)
	main:SetAllPoints(frame)

	local scrollFrame = CreateFrame("ScrollFrame", nil, main)
	scrollFrame:SetSize(core.db.aura.width/2, core.db.aura.height)
	scrollFrame:SetPoint('LEFT', frame, 'CENTER')
	main.scrollframe = scrollFrame

	local scrollChild = CreateFrame("Frame", nil, scrollFrame)
	scrollChild:SetAllPoints(frame)
	scrollFrame:SetScrollChild(scrollChild)
	main.scrollchild = scrollChild

	local half_1 = scrollChild:CreateTexture()
	half_1:SetTexture("Interface\\AddOns\\" .. addonName .. "\\Media\\simple_cooldown")
	half_1:SetBlendMode('BLEND')
	half_1:SetAllPoints(frame)
	half_1:SetVertexColor(0, 0, 0, 0.6)
	main.rotatable = half_1


	local half_2 = main:CreateTexture()
	half_2:SetTexture("Interface\\AddOns\\" .. addonName .. "\\Media\\simple_cooldown")
	half_2:SetBlendMode('BLEND')
	half_2:SetAllPoints(frame)
	half_2:SetVertexColor(0, 0, 0, 0.6)
	half_2:SetRotation( math.rad(180) )
	half_2:Hide()
	main.stationary = half_2

	main.inverse = false

	return main
end


-- font objects
local TIMER_FONT = CreateFont(addonName.. "AuraTimerFont_Shadowed")
TIMER_FONT:SetFont([[Fonts\FRIZQT__.TTF]], 8)
TIMER_FONT:SetTextColor(NumberFontNormalYellow:GetTextColor())
TIMER_FONT:SetShadowColor(0, 0, 0, 1)
TIMER_FONT:SetShadowOffset(SystemFont_Shadow_Med1:GetShadowOffset())

local COUNT_FONT = CreateFont(addonName.. "AuraCountFont")
COUNT_FONT:SetFont([[Fonts\FRIZQT__.TTF]], 8)


-- Being green ain't easy.
local function RecyctableAuras(tab)
	if tab then
		-- put table back into free tables; they may have debuff frames in them so hide them
		for x = 1, #tab do
			local frame = tab[x]
			frame:Hide()
			frame:SetSize(core.db.aura.width, core.db.aura.height)
			frame:SetScale(core.db.aura.scale)

			frame.border:SetSize(core.db.aura.width +3, core.db.aura.height +2)

			frame.cooldown.scrollframe:SetSize(core.db.aura.width/2, core.db.aura.height)
		end
		core.auras[#core.auras +1] = tab
		return nil

	elseif #core.auras > 0 then
		-- get a table and send it out; there's no need for it to stick around either
		tab = core.auras[#core.auras]
		core.auras[#core.auras] = nil
		return tab

	else
		-- if nothing else just send a fresh table; it should be returned later
		return {visible = 0}
	end
end
local function RecyctableCCs(tab)
	if tab then
		for x = 1, #tab do
			local frame = tab[x]
			frame:Hide()
			frame:SetSize(core.db.tracker.width, core.db.tracker.height)
			frame:SetScale(core.db.tracker.scale)

			frame.border:SetSize(core.db.tracker.width +3, core.db.tracker.height +2)

			frame.cooldown.scrollframe:SetSize(core.db.tracker.width/2, core.db.tracker.height)
		end
		core.tracker[#core.tracker +1] = tab
		return nil

	elseif #core.tracker > 0 then
		tab = core.tracker[#core.tracker]
		core.tracker[#core.tracker] = nil
		return tab

	else
		return {}
	end
end


local function Aura_OnHide(self)
	self.spellID = nil
end
local function CreateButton()
	local frame = CreateFrame('Frame')
	frame:SetSize(core.db.aura.width, core.db.aura.height)
	frame:SetScale(core.db.aura.scale)

	local border = frame:CreateTexture()
	border:SetTexture("Interface\\Buttons\\UI-Debuff-Overlays")
	border:SetTexCoord(0.296875, 0.5703125, 0, 0.515625)
	border:SetSize(core.db.aura.width +3, core.db.aura.height +2)
	border:SetPoint('CENTER', frame, 'CENTER')
	frame.border = border

	local texture = frame:CreateTexture()
	texture:SetAllPoints(frame)
	frame.texture = texture

	local timer = frame:CreateFontString()
	timer:SetPoint('TOP', frame, 'BOTTOM', 0 , -1)
	timer:SetFontObject(TIMER_FONT)
	timer:SetJustifyH('CENTER')
	frame.timer = timer

	-- keep this, in case they decide to make it work
	--local cooldown = CreateFrame('Cooldown', nil, frame, "CooldownFrameTemplate")
	--cooldown:SetAllPoints(frame)
	local cooldown = CreateCooldown(frame)
	cooldown.timer = timer
	cooldown:HookScript('OnUpdate', Cooldown_OnUpdate)
	cooldown:HookScript('OnHide', Cooldown_OnHide)
	cooldown.Parent = frame
	frame.cooldown = cooldown

	local count = frame:CreateFontString()
	count:SetPoint('BOTTOMRIGHT', frame, 'BOTTOMRIGHT')
	count:SetFontObject(COUNT_FONT)
	count:SetJustifyH('RIGHT')
	count:Hide()
	frame.count = count
	
	frame:HookScript('OnHide', Aura_OnHide)

	return frame
end


local function AdjustAuraTraits(frame, spellID, icon, debuffType, duration, expirationTime, count)
	frame.spellID = spellID

	frame.texture:SetTexture(icon)
	
	frame.debuffType = debuffType
	if core.db.aura.ShowBorder then
		frame.border:Show()
		local color = DebuffTypeColor[debuffType or 'none']
		frame.border:SetVertexColor(color.r, color.g, color.b)
		
	else
		frame.border:Hide()

	end
	
	if count and count > 1 then
		frame.count:SetText(count)
		frame.count:Show()

	else
		frame.count:Hide()

	end
	
	if duration and ( duration > 0 ) then
		frame.cooldown:Show()
		frame.timer:Show()

		frame.cooldown.time = expirationTime
		frame.cooldown.duration = duration

	else
		frame.cooldown:Hide()
		frame.timer:Hide()

		frame.cooldown.time = nil
		frame.cooldown.duration = nil
		frame.cooldown.inverse = false

	end
end

local Growth = {
	Row = {
		[false] = {
			'BOTTOMLEFT',
			'TOPLEFT'
		},
		[true] = {
			'TOPLEFT',
			'BOTTOMLEFT',
		},
	},
	Column = {
		[false] = {
			'BOTTOMLEFT',
			'BOTTOMRIGHT'
		},
		[true] = {
			'BOTTOMRIGHT',
			'BOTTOMLEFT',
		},
	},
}

local function AddAura(self, nameplate, isCC, spellID, icon, debuffType, duration, expirationTime, count)
	local buffs = not isCC and self.plates[nameplate].auras or self.plates[nameplate].tracker
	local index = buffs.visible +1
	buffs.visible = index
	local frame = buffs[index]
	if not frame then
		frame = CreateButton()
		if isCC then
			self.plates[nameplate].tracker[index] = frame
		else
			self.plates[nameplate].auras[index] = frame
		end
	end
	AdjustAuraTraits(frame, spellID, icon, debuffType, duration, expirationTime, count)
	frame:SetParent(nameplate)

	index = index -1
	frame:ClearAllPoints()
	if not isCC then
		if not self.db.aura.enabled then
			frame:Hide()
		else
			if index == 0 then
				frame:SetPoint(self.db.aura.anchor, nameplate, self.db.aura.relative, self.db.aura.x, self.db.aura.y)

			else
				local bpr = self.db.aura.BPR
				local growth
				if ceil(index / bpr) == index / bpr then
					growth = self.db.aura.growth
					--frame:SetPoint('BOTTOMLEFT', buffs[index - self.db.aura.BPR + 1], 'TOPLEFT', 0, 14)
					frame:SetPoint(Growth.Row[growth][1], buffs[index - bpr + 1], Growth.Row[growth][2], 0, 14 * (growth and -1 or 1))

				else
					growth = self.db.aura.direction
					frame:SetPoint(Growth.Column[growth][1], buffs[index], Growth.Column[growth][2], BUFF_HORIZ_SPACING  * (growth and 1 or -1), 0)
					
				end
			end
		end
		self.plates[nameplate].auras.visible = buffs.visible
		
	else
		if not self.db.tracker.enabled then
			frame:Hide()
		else
			if index == 0 then
				frame:SetPoint(self.db.tracker.anchor, nameplate, self.db.tracker.relative, self.db.tracker.x, self.db.tracker.y)

			else
				local bpr = self.db.tracker.BPR
				local growth
				if ceil(index / bpr) == index / bpr then
					growth = self.db.tracker.growth
					frame:SetPoint(Growth.Row[growth][1], buffs[index - bpr + 1], Growth.Row[growth][2], 0, 14 * (growth and -1 or 1))

				else
					growth = self.db.tracker.direction
					frame:SetPoint(Growth.Column[growth][1], buffs[index], Growth.Column[growth][2], BUFF_HORIZ_SPACING * (growth and 1 or -1), 0)
					
				end
			end
		end
		self.plates[nameplate].tracker.visible = buffs.visible
	
	end
	frame:Show()
	return frame
end
local function DoseAura(self, nameplate, isCC, spellID, icon, debuffType, duration, expirationTime, count)
	local buffs = self.plates[nameplate].auras
	if isCC then buffs = self.plates[nameplate].tracker end
	local v
	for x = 1, buffs.visible do
		v = buffs[x]
		if v.spellID == spellID then
			if count and count > 1 then
				v.count:SetText(count)
				v.count:Show()
				v.count.value = count

			else
				v.count:Hide()

			end
			break
		end
	end
end
local function RefreshAura(self, nameplate, isCC, spellID, icon, debuffType, duration, expirationTime, count)
	local buffs = self.plates[nameplate].auras
	if isCC then buffs = self.plates[nameplate].tracker end
	for x, v in ipairs(buffs) do
		if v.spellID == spellID then
			if count and count > 1 then
				v.count:SetText(count)
				v.count:Show()

			else
				v.count:Hide()

			end
			v.cooldown.time = expirationTime
			v.cooldown.duration = duration
			break
		end
	end
end
local function RemoveAura(self, nameplate, isCC, spellID)
	local buffs = self.plates[nameplate].auras
	if isCC then buffs = self.plates[nameplate].tracker end
	local frame, v, icon, debuffType, duration, expirationTime, count
	for x=1, buffs.visible do
		v = buffs[x]
		if v.spellID == spellID then
			frame = v
		elseif frame then
			AdjustAuraTraits(frame, v.spellID, v.texture:GetTexture(), v.debuffType, v.cooldown.duration, v.cooldown.time, v.count.value)
		end
	end
	if buffs[buffs.visible] then
		buffs[buffs.visible]:Hide()
	end
	self.plates[nameplate].auras.visible = buffs.visible -1

end

-- Oh ma gurd... there's got to be an easier way.
local function ShowPlayerDebuffsOnly(IsHarmful, IsInverted, IsEnemy, IsPlayerCaster)
	if IsInverted then
		return false
	elseif IsEnemy and IsHarmful and IsPlayerCaster then
		return true
	end
	return false
end

local function ShowPlayerBuffsOnly(IsHarmful, IsInverted, IsEnemy, IsPlayerCaster)
	if IsHarmful or IsInverted or IsEnemy then
		return false
	elseif IsPlayerCaster then
		return true
	end
	return false
end

local function ShowOtherDebuffsOnly(IsHarmful, IsInverted, IsEnemy, IsPlayerCaster)
	if IsHarmful and IsInverted and IsEnemy and not IsPlayerCaster then
		return true
	else
		return false
	end
	--return false
end

local function ShowOtherBuffsOnly(IsHarmful, IsInverted, IsEnemy, IsPlayerCaster)
	if IsEnemy or IsHarmful or not IsInverted or IsPlayerCaster then
		return false
	else
		return true
	end
	--return true
end

local function ScanAuras(self, nameplate, token)
	local tab = self.plates[nameplate]
	local aura = self.db.aura
	local trac = self.db.tracker
	
	local auras, frame
	local index, visible = 1
	local canAttack = tab.canAttack
	local invert = aura.invert

	if tab.auras then tab.auras.visible = 0 end
	if tab.tracker then tab.tracker.visible = 0 end
	
	local filter = 'HARMFUL'
	
	local spellID, icon, count, debuffType, duration, expirationTime, caster = true
	
	while spellID do
		_, _, icon, count, debuffType, duration, expirationTime, caster, _, _, spellID = UnitAura(token, index, filter)
		if spellID and not aura.filter[spellID] then
			local tmp = self.spells[spellID] or {}
			tmp.icon = icon
			tmp.debuffType = debuffType
			tmp.duration = duration
			self.spells[spellID] = tmp
			
			local isCC = trac.filter[spellID]
			if isCC
				--  This had been a long standing error, that apparently didn't affect me...
				--		Thank you, Talasonx, for helping me spot it.
				or (filter and ShowPlayerDebuffsOnly(filter, invert, canAttack, caster == 'player'))
				or (filter and ShowOtherDebuffsOnly(filter, invert, canAttack, caster == 'player'))
				or (not filter and ShowPlayerBuffsOnly(filter, invert, canAttack, caster == 'player'))
				or (not filter and ShowOtherBuffsOnly(filter, invert, canAttack, caster == 'player')) then
				
				
				
				AddAura(self, nameplate, isCC, spellID, icon, debuffType, duration, expirationTime, count)

			end
		end
		
		if filter and not spellID then
			spellID = true
			index = 1
			filter = nil
		else
			index = index + 1
		end

	end
	auras = tab.auras
	if auras then
		for x = auras.visible +1, #auras do
			auras[x]:Hide()
		end
	end
	
	auras = tab.tracker
	if auras then
		for x = auras.visible +1, #auras do
			auras[x]:Hide()
		end
	end
end


-- update target auras by triggering a target update
main.UNIT_AURA = core.PLAYER_TARGET_CHANGED


-- a dummy frame just to ensure there's no overlapping of events
local dub = CreateFrame('Frame', nil, UIParent)
dub:SetScript('OnEvent', core.UPDATE_MOUSEOVER_UNIT)


-- the list of applicable CLEU events and corresponding functions
local CLEU_Filter = {
	--[subevent] = function,
	['SPELL_AURA_APPLIED'] = AddAura,
	['SPELL_AURA_REFRESH'] = RefreshAura,
	['SPELL_AURA_APPLIED_DOSE'] = DoseAura,
	['SPELL_AURA_REMOVED_DOSE'] = DoseAura,
	['SPELL_AURA_STOLEN'] = RemoveAura,
	['SPELL_AURA_REMOVED'] = RemoveAura,
	['SPELL_AURA_BROKEN'] = RemoveAura,
	['SPELL_AURA_BROKEN_SPELL'] = RemoveAura,
}

local function OnCLEU(self, plate, timestamp, event, hideCaster, srcGUID, srcName, srcFlags, srcFlags2, destGUID, destName, destFlags, destFlags2, spellID, spellName, spellFlag, auraType, count)
	if CLEU_Filter[event] then
		local flag = self.db.aura.invert
		if (flag and srcGUID ~= self.PLAYER_GUID) or (not flag and (srcGUID == self.PLAYER_GUID or (self.db.aura.ShowPet and srcGUID == self.PET_GUID))) then
			if not self.db.aura.filter[spellID] then
				local spell = self.spells[spellID]
				if spell then
					CLEU_Filter[event](self, plate, self.db.tracker.filter[spellID], spellID, spell.icon, spell.debuffType, spell.duration, GetTime() + spell.duration, count)
				end
			end
		end
	end
end

local function ToggleEvents(self)
	local state = core.db.aura.enabled or core.db.tracker.enabled
	if state then
		state = 'AddCallback'
		main:RegisterUnitEvent('UNIT_AURA', 'target')
		dub:RegisterUnitEvent('UNIT_AURA', 'mouseover')
	else
		state = 'RemoveCallback'
		main:UnregisterEvent('UNIT_AURA')
		dub:UnregisterEvent('UNIT_AURA')
	end
	
	self[state](self, 'NameplateOnTargetUpdate', 'aura', function(self, frame)
		ScanAuras(self, frame, 'target')
	end)
	
	self[state](self, 'NameplateOnMouseover', 'aura', function(self, frame)
		ScanAuras(self, frame, 'mouseover')
	end)
	self[state](self, 'COMBAT_LOG_EVENT_UNFILTERED', 'aura', OnCLEU)
end


core:AddCallback('Toggle', 'aura', function(self, ...)
	local state = 'RemoveCallback'
	if self.db.aura.enabled then
		state = 'AddCallback'
	end
	ToggleEvents(self)
	
	self[state](self, 'NameplateOnShow', 'aura', function(self, frame)
		self.plates[frame].auras = RecyctableAuras()
	end)

	self[state](self, 'NameplateOnHide', 'aura', function(self, frame)
		self.plates[frame].auras = RecyctableAuras(self.plates[frame].auras)
	end)
end)

core:AddCallback('Toggle', 'tracker', function(self, ...)
	local state = 'RemoveCallback'
	if self.db.tracker.enabled then
		state = 'AddCallback'
	end
	ToggleEvents(self)
	
	
	self[state](self, 'NameplateOnShow', 'tracker', function(self, frame)
		self.plates[frame].tracker = RecyctableCCs()
	end)

	self[state](self, 'NameplateOnHide', 'tracker', function(self, frame)
		self.plates[frame].tracker = RecyctableCCs(self.plates[frame].tracker)
	end)
end)
