

local RA = RaidAssist
local L = LibStub ("AceLocale-3.0"):GetLocale ("RaidAssistAddon")
local _ 
local default_priority = 1

local PlayerCheck = {
	last_data_sent = 0,
	player_data = {},
	version = "v0.1",
	pluginname = "PlayerCheck"
}
PlayerCheck.IsDisabled = true

local default_config = {
	leader_request_interval = 180,
}

local icon_texcoord = {l=0, r=1, t=0, b=1}
local icon_texture = [[Interface\CURSOR\thumbsup]]
local text_color_enabled = {r=1, g=1, b=1, a=1}
local text_color_disabled = {r=0.5, g=0.5, b=0.5, a=1}

local can_install = false

PlayerCheck.menu_text = function (plugin)
	if (PlayerCheck.db.enabled) then
		return icon_texture, icon_texcoord, "Player Check", text_color_enabled
	else
		return icon_texture, icon_texcoord, "Player Check", text_color_disabled
	end
end

PlayerCheck.menu_popup_show = function (plugin, ct_frame, param1, param2)
	RA:AnchorMyPopupFrame (PlayerCheck)
end

PlayerCheck.menu_popup_hide = function (plugin, ct_frame, param1, param2)
	PlayerCheck.popup_frame:Hide()
end

PlayerCheck.menu_on_click = function (plugin)
	--if (not PlayerCheck.options_built) then
	--	PlayerCheck.BuildOptions()
	--	PlayerCheck.options_built = true
	--end
	--PlayerCheck.main_frame:Show()
	
	RA.OpenMainOptions (PlayerCheck)
end

local func_requestdata_ticker = function()
	if (not InCombatLockdown() and not UnitAffectingCombat ("player")) then
		PlayerCheck:SendPluginCommMessage ("PCR", "RAID-NOINSTANCE")
	end
end

function PlayerCheck:StartDataRequestTicker()
	if (not PlayerCheck.LeaderRequestTicker or PlayerCheck.LeaderRequestTicker._cancelled) then
		PlayerCheck.LeaderRequestTicker = C_Timer.NewTicker (PlayerCheck.db.leader_request_interval, func_requestdata_ticker)
	end
end

function PlayerCheck:StopDataRequestTicker()
	if (PlayerCheck.LeaderRequestTicker and not PlayerCheck.LeaderRequestTicker._cancelled) then
		PlayerCheck.LeaderRequestTicker:Cancel()
	end
end

local func_latency_ticker = function()
	local w, h = PlayerCheck:GetLatency()
	PlayerCheck:SendPluginCommMessage ("PCL", "RAID-NOINSTANCE", _, _, GetUnitName ("player", true), 0, 0, w, h)
end

function PlayerCheck:StartLatencyTicker()
	if (not PlayerCheck.LatencyTicker or PlayerCheck.LatencyTicker._cancelled) then
		PlayerCheck.LatencyTicker = C_Timer.NewTicker (30, func_latency_ticker)
	end
end

function PlayerCheck:StopLatencyTicker()
	if (PlayerCheck.LatencyTicker and not PlayerCheck.LatencyTicker._cancelled) then
		PlayerCheck.LatencyTicker:Cancel()
	end
end

function PlayerCheck:CheckLeadership()
	if (UnitIsGroupLeader ("player")) then
		PlayerCheck:StartDataRequestTicker()
	else
		PlayerCheck:StopDataRequestTicker()
	end	
end

function PlayerCheck:GroupUpdate()
	if (IsInRaid (LE_PARTY_CATEGORY_HOME)) then
		if (not PlayerCheck.InGroup) then
			PlayerCheck.InGroup = true
			PlayerCheck:SendData()
			PlayerCheck:StartLatencyTicker()
		end
		PlayerCheck:CheckLeadership()
	else
		if (PlayerCheck.InGroup) then
			PlayerCheck.InGroup = false
			PlayerCheck:StopLatencyTicker()
		end
	end
end

PlayerCheck.OnInstall = function (plugin)

	PlayerCheck.db.menu_priority = default_priority

	local popup_frame = PlayerCheck.popup_frame
	local main_frame = PlayerCheck.main_frame
	
	PlayerCheck:RegisterPluginComm ("PCR", PlayerCheck.PluginCommReceived)
	PlayerCheck:RegisterPluginComm ("PCD", PlayerCheck.PluginCommReceived)
	PlayerCheck:RegisterPluginComm ("PCL", PlayerCheck.PluginCommReceived)
	
	main_frame:RegisterEvent ("GROUP_ROSTER_UPDATE")
	main_frame:SetScript ("OnEvent", function (self, event, ...)
		if (event == "GROUP_ROSTER_UPDATE") then
			PlayerCheck:GroupUpdate()
		end
	end)
	PlayerCheck:GroupUpdate()
end

PlayerCheck.OnEnable = function (plugin)
	-- enabled from the options panel.
	PlayerCheck.OnInstall (plugin)
end

PlayerCheck.OnDisable = function (plugin)
	-- disabled from the options panel.
	PlayerCheck:UnregisterPluginComm ("PCR", PlayerCheck.PluginCommReceived)
	PlayerCheck:UnregisterPluginComm ("PCD", PlayerCheck.PluginCommReceived)
	PlayerCheck:UnregisterPluginComm ("PCL", PlayerCheck.PluginCommReceived)
	PlayerCheck.main_frame:UnregisterEvent ("GROUP_ROSTER_UPDATE")
	PlayerCheck:StopLatencyTicker()
	PlayerCheck:StopDataRequestTicker()
end

PlayerCheck.OnProfileChanged = function (plugin)
	if (plugin.db.enabled) then
		PlayerCheck.OnEnable (plugin)
	else
		PlayerCheck.OnDisable (plugin)
	end
	
	if (plugin.options_built) then
		plugin.main_frame:RefreshOptions()
	end
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--get the player item level
function PlayerCheck:GetItemLevel()
	local overall, equipped = GetAverageItemLevel()
	return equipped, overall
end

--get the player ping
function PlayerCheck:GetLatency()
	local bandwidthIn, bandwidthOut, latencyHome, latencyWorld = GetNetStats()
	return latencyWorld, latencyHome
end

--get the% of repair and missing gems and enchants
function PlayerCheck:GetRepairAndMissingAdds()
	local repair_percent = PlayerCheck:GetRepairStatus()
	local missing_enchants, missing_gems = PlayerCheck:GetSloppyEquipment()
	return repair_percent, missing_enchants, missing_gems
end

--get the player attendance from attendance plugin
function PlayerCheck:GetAttendance()
	
end

--local spec_id, spec_name, spec_description, spec_icon, spec_background, spec_role, spec_class = GetSpecializationInfoByID (spec or 0)
--local talentID, name, texture, selected, available = GetTalentInfoByID (talents [i])

function PlayerCheck:BuildDataToSend()
	local ilvl_e, ilvl_t = PlayerCheck:GetItemLevel()
	local lag_w, lag_l = PlayerCheck:GetLatency()
	local repair, miss_enchants, miss_gems = PlayerCheck:GetRepairAndMissingAdds()
	local spec_and_talents = PlayerCheck:GetTalents()
	
	return {ilvl_e, ilvl_t, lag_w, lag_l, repair, miss_enchants, miss_gems, spec_and_talents, RA.version}
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function PlayerCheck:SendData()

	if (true) then
		return
	end

	if (PlayerCheck.last_data_sent+20 < time()) then
		local data = PlayerCheck:BuildDataToSend()
		PlayerCheck:SendPluginCommMessage ("PCD", "RAID-NOINSTANCE", _, _, PlayerCheck:GetPlayerNameWithRealm(), unpack (data))
		PlayerCheck.last_data_sent = time()
	end
end

function PlayerCheck.PluginCommReceived (data)

	if (true) then
		return
	end

	local null, prefix, player_name, ilvl_e, ilvl_t, lag_w, lag_l, repair, missing_adds, spec_stalents, ra_version = unpack (data)
	
	player_name = Ambiguate (player_name, "none")
	
	if (prefix == "PCR") then
		--leader requested data
		PlayerCheck:SendData()
		
	elseif (prefix == "PCL") then
		--only latency
		local t = PlayerCheck.player_data [player_name] or {}
		t [3] = lag_w
		t [4] = lag_l
		PlayerCheck.player_data [player_name] = t
		
	elseif (prefix == "PCD") then
		--entire data
		local t = PlayerCheck.player_data [player_name] or {}
		
		t [1] = ilvl_e
		t [2] = ilvl_t
		t [3] = lag_w
		t [4] = lag_l
		t [5] = repair
		t [6] = missing_adds
		t [7] = spec_stalents
		t [8] = ra_version
		
		PlayerCheck.player_data [player_name] = t
	end
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function PlayerCheck.OnShowOnOptionsPanel()
	local OptionsPanel = PlayerCheck.OptionsPanel
	PlayerCheck.BuildOptions (OptionsPanel)
end

function PlayerCheck.BuildOptions (frame)

end

if (can_install) then
	local install_status = RA:InstallPlugin ("Player Check", "RAPlayerCheck", PlayerCheck, default_config)
end
