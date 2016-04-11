local addonName, at = ...


local core = CreateFrame('Frame', nil, UIParent)
core:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
at.core = core

local type, pairs = type, pairs

core.callbacks = {}
function core:Callback(name, ...)
	local tab = self.callbacks[name]
	if tab then
		for x, v in pairs(tab) do
			v(self, ...)
		end
	end
end
function core:CallbackKey(name, key, ...)
	local tab = self.callbacks[name]
	if tab[key] then
		tab[key](self, ...)
	end
end
function core:AddCallback(name, key, func)
	local tab = self.callbacks[name] or {}
	tab[key or #tab +1] = func
	self.callbacks[name] = tab
end
function core:RemoveCallback(name, key)
	if self.callbacks[name] then
		self.callbacks[name][key] = nil
	end
end
function core:CallOnce(name, ...)
	local tab = self.callbacks[name]
	for key, v in pairs(tab) do
		v(self, ...)
	end
	self.callbacks[name] = nil
end

function core:CopyTable(t, t2)
	if not t then return {} end
	if t2 then
		t2 = wipe(t2)
		for k,v in pairs(t) do
			if type(v) == 'table' then
				v = self:CopyTable(v, t2[k])
			end
			t2[k] = v
		end
		return t2
	else
		local t3 = {}
		for k,v in pairs(t) do
			if type(v) == 'table' then
				v = self:CopyTable(v)
			end
			t3[k] = v
		end
		return t3
	end
end


--tables
core.plates = {} -- keeps track of namplates
core.units = {} -- stores references to plates using GUID's



--upvalue
local select = select
local WorldFrame = WorldFrame
local UnitPlayerControlled = UnitPlayerControlled
local UnitIsDead = UnitIsDead
local UnitGUID = UnitGUID
local UnitCanAttack = UnitCanAttack
local strfind, ipairs = string.find, ipairs
local rad, ceil = math.rad, math.ceil



--vars
local visible = 0
local hastarget
local targetUpdate = false
local updateMouseover = false
core.PLAYER_GUID = UnitGUID('player')
core.TARGET_GUID = UnitGUID('target')
core.PET_GUID = UnitGUID('pet')
core.MOUSEOVER_GUID = nil





-- upvalues from frame
--   I've seen some authors override these in other parts of the UI...
--	 an example are some Minimap addons.
local GetNumChildren = core.GetNumChildren
local GetChildren = core.GetChildren
local GetName = core.GetName
local GetAlpha = core.GetAlpha



local function OnShow(self)
	core:Callback('NameplateOnShow', self)
	
	visible = visible + 1
	if hasTarget and self:GetAlpha() == 1 then
		targetUpdate = 0
	end
end
local function OnHide(self)
	local tab = core.plates[self]
	tab.isPlayer = nil
	visible = visible - 1
	if hasTarget and self:GetAlpha() == 1 then
		targetUpdate = nil
	end
	
	core:Callback('NameplateOnHide', self, targetUpdate)

	local guid = tab.guid
	if guid then
		core.units[guid] = nil
		tab.guid = nil
	end

	core.plates[self] = tab
end
local function SetNameplateVars(plate, guid, token)
	if guid then
		if not core.units[guid] then
			core.units[guid] = plate
			core.plates[plate].guid = guid
		end
		core.plates[plate].isPlayer = UnitPlayerControlled(token)
		core.plates[plate].canAttack = UnitCanAttack('player', token)
	end
end
local function OnUpdate(self)
	if targetUpdate then
		if hasTarget and targetUpdate > visible and self:GetAlpha() == 1 then
			SetNameplateVars(self, core.TARGET_GUID, 'target')
			core:Callback('NameplateOnTargetUpdate', self)
			targetUpdate = nil
				
		else
			targetUpdate = targetUpdate +1
			
		end
	end
	if updateMouseover and core.plates[self].overlay:IsShown() then
		SetNameplateVars(self, updateMouseover, 'mouseover')
		core:Callback('NameplateOnMouseover', self)
		updateMouseover = nil
		
	end
end

local numWorldChildren = 0
local function ScanFrames(num, ...)
	local frame
	for x = numWorldChildren +1, num do
		frame = select(x, ...)
		if frame.ArtContainer then
			local tab = {}
			local overlay = frame.ArtContainer.Highlight
			local threat = frame.ArtContainer.AggroWarningTexture
			local name = frame.NameContainer.NameText
			local hp = frame.ArtContainer.HealthBar
			tab.overlay = overlay
			tab.threat = threat
			tab.name = name
			tab.hp = hp
			
			core.plates[frame] = tab
			core:Callback('NameplateAdded', frame, hp, threat, overlay, name)

			OnShow(frame)
			OnUpdate(frame)
			frame:HookScript('OnShow', OnShow)
			frame:HookScript('OnHide', OnHide)
			frame:HookScript('OnUpdate', OnUpdate)
		end
	end
end


core:RegisterEvent('PLAYER_TARGET_CHANGED')-- fires before the nameplates are updated
function core:PLAYER_TARGET_CHANGED(var)
	-- since UNIT_AURA also fires this we can ignore it by checking for a variable
	local guid
	if not var then
		--UnitIsDead prevents the first frame to update when looting from corpse
		hasTarget = (UnitExists('target') and not UnitIsDead('target'))
		visible = hasTarget and #core.plates or 0

		guid = UnitGUID('target')
		core.TARGET_GUID = guid
		targetUpdate = 0
		core:Callback('PLAYER_TARGET_CHANGED', not guid or not UnitCanAttack('player', 'target'))
	else
		targetUpdate = 0
	end
end

core:RegisterEvent('UPDATE_MOUSEOVER_UNIT')-- may fire after the nameplates are updated
function core:UPDATE_MOUSEOVER_UNIT(var)
	local guid
	
	--if not var then
		guid = UnitGUID('mouseover')
		core.MOUSEOVER_GUID = guid
	--end
	updateMouseover = guid
end


core.VariableLoadCount = 0
function core:LoadVariables()
	-- this will run for each event that loads some form of variable; only doing anything once they've all loaded.
	self.VariableLoadCount = self.VariableLoadCount +1
	if self.VariableLoadCount > 2 then
		self.PLAYER_GUID = UnitGUID('player')
		self.PET_GUID = UnitGUID('pet')

		JamPlatesAccessoriesDB = self:CopyTable(JamPlatesAccessoriesDB or {default = self.defaults, spells = {}})

		JamPlatesAccessoriesCP = JamPlatesAccessoriesCP or self.PLAYER_GUID
		self.db = self:CopyTable(JamPlatesAccessoriesDB[JamPlatesAccessoriesCP] or self.db)
		
		
		if core.db.name == 'default' and JamPlatesAccessoriesCP == self.PLAYER_GUID then
			self.db.name = UnitName('player')
			self.db.id = self.PLAYER_GUID

			JamPlatesAccessoriesDB[self.PLAYER_GUID] = self:CopyTable(self.db)
		end

		self:CallOnce('VariablesLoaded')
		self:Callback('Toggle')
		self:UnregisterEvent('ADDON_LOADED')
		self:UnregisterEvent('VARIABLES_LOADED')
	end
end

-- these 3 events WoW uses to tell addons that certain variables are loaded
core:RegisterEvent('PLAYER_ENTERING_WORLD')
function core:PLAYER_ENTERING_WORLD()
	if IsAddOnLoaded('JamPlates') then
		hooksecurefunc("JamPlates_ScanFrames", function(num, ...)
			ScanFrames(num, ...)
			numWorldChildren = GetNumChildren(WorldFrame)
		end)
	else
		WorldFrame:HookScript('OnUpdate', function(self, num)
			num = GetNumChildren(self)
			if num ~= numWorldChildren then
				ScanFrames(num, GetChildren(self))
				numWorldChildren = num
			end
		end)
	end
	
	self.db = {}
	self.db.name = 'default'
	self.db.id = 'default'
	
	self:CallOnce('Initialize')

	self.defaults = self:CopyTable(self.db)

	function self:Reset()
		self.db = self:CopyTable(self.defaults)
	end


	self:LoadVariables()
	self.PLAYER_ENTERING_WORLD = self.PLAYER_TARGET_CHANGED
	
--	JamPlatesAccessories_Toggle(dwGetCVar('JAMPLATESACCESSORIES', 'JAMPLATES_OPTION1'))
end

core:RegisterEvent('ADDON_LOADED')
function core:ADDON_LOADED(addon, ...)
	if addon == addonName then
		self:LoadVariables()
	end
end

core:RegisterEvent('VARIABLES_LOADED')
function core:VARIABLES_LOADED()
	self:LoadVariables()
end


-- save variables on logout
core:RegisterEvent('PLAYER_LOGOUT')
function core:PLAYER_LOGOUT()
	if JamPlatesAccessoriesDB then
		JamPlatesAccessoriesDB.spells = self.spells
		JamPlatesAccessoriesDB[JamPlatesAccessoriesCP] = self.db
	end
end

core:RegisterUnitEvent('UNIT_PET', 'player')
function core:UNIT_PET()
	self.PET_GUID = UnitGUID('pet')
end

local unpack = unpack
core.CLEU_Filter = {}
core:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
function core:COMBAT_LOG_EVENT_UNFILTERED(timestamp, event, hideCaster, srcGUID, srcName, srcFlags, srcFlags2, destGUID, destName, destFlags, destFlags2, spellID, spellName, spellFlag, auraType, count)
	--local timestamp, event, hideCaster, srcGUID, srcName, srcFlags, srcFlags2, destGUID, destName, destFlags, destFlags2, spellID, spellName, spellFlag, auraType, count = ...
	
	--if destGUID == self.PLAYER_GUID then print(event, spellID) end
	-- EVERYBODY but yourself, your pet, your target and your mouseover
	if destGUID ~= self.TARGET_GUID and destGUID ~= self.PLAYER_GUID and destGUID ~= self.PET_GUID then
		local nameplate = self.units[destGUID]
		if nameplate then
			self:Callback('COMBAT_LOG_EVENT_UNFILTERED', nameplate, timestamp, event, hideCaster, srcGUID, srcName, srcFlags, srcFlags2, destGUID, destName, destFlags, destFlags2, spellID, spellName, spellFlag, auraType, count)
		end
	end
end
		
function JamPlatesAccessories_Toggle(toggle) --by eui.cc
	if toggle == 1 then
		toggle = true
	else
		toggle = false
	end
	core.db.aura.enabled = toggle
	core.db.tracker.enabled = toggle
	core.db.threat.enabled = toggle
	core.db.cp.enabled = toggle
	core.db.combat.enabled = toggle
		
	core:CallbackKey('Toggle', 'aura')
	core:CallbackKey('Toggle', 'tracker')
	core:CallbackKey('Toggle', 'cp')
	core:CallbackKey('Toggle', 'threat')
	core:CallbackKey('Toggle', 'combat')
end