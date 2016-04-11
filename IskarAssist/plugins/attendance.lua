


local RA = RaidAssist
local L = LibStub ("AceLocale-3.0"):GetLocale ("RaidAssistAddon")
local _
local default_priority = 5

local GetUnitName = GetUnitName
local GetGuildInfo = GetGuildInfo

local week1, week2, week3, week4, week5, week6, week7 = "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"

local empty_func = function()end

local default_config = {
	raidschedules = {},
	playerids = {},
	menu_priority = 2,
}

local Attendance = {version = "v0.1", pluginname = "Attendance"}
Attendance.debug = false
--Attendance.debug = true

local RaidSchedule

_G ["RaidAssistAttendance"] = Attendance

local icon_texcoord = {l=50/512, r=86/512, t=362/512, b=406/512}
local icon_texture = [[Interface\Scenarios\ScenariosParts]]
local text_color_enabled = {r=1, g=1, b=1, a=1}
local text_color_disabled = {r=0.5, g=0.5, b=0.5, a=1}

Attendance.menu_text = function (plugin)
	if (Attendance.db.enabled) then
		return icon_texture, icon_texcoord, L["S_PLUGIN_ATTENDANCE_NAME"], text_color_enabled
	else
		return icon_texture, icon_texcoord, L["S_PLUGIN_ATTENDANCE_NAME"], text_color_disabled
	end
end

Attendance.menu_popup_hide = function (plugin, ct_frame, param1, param2)
	local popup_frame = Attendance.popup_frame
	popup_frame:Hide()
end

Attendance.menu_on_click = function (plugin)
	--if (not Attendance.options_built) then
	--	Attendance.BuildOptions()
	--	Attendance.options_built = true
	--end
	--Attendance.main_frame:Show()
	
	RA.OpenMainOptions (Attendance)
end

Attendance.StartUp = function()
	Attendance.player_name = GetUnitName ("player")
	
	--Attendance:Msg ("Attendance.StartUp() -> is capturing:", Attendance.is_capturing)
	RaidSchedule = _G ["RaidAssistRaidSchedule"]
	if (not RaidSchedule) then
		C_Timer.After (0.5, function() Attendance.StartUp() end)
		return
	end
	
	Attendance:CheckForNextEvent()
	Attendance:CheckOldTables()
	Attendance.need_popup_update = true
end

Attendance.OnInstall = function (plugin)
	local popup_frame = Attendance.popup_frame
	popup_frame.label_no_data = RA:CreateLabel (popup_frame, L["S_PLUGIN_ATTENDANCE_NO_DATA"], Attendance:GetTemplate ("font", "ORANGE_FONT_TEMPLATE"))
	popup_frame.label_no_data:SetPoint ("center", popup_frame, "center")
	popup_frame.label_no_data.width = 130
	popup_frame.label_no_data.height = 40
	
	Attendance.db.menu_priority = default_priority
	
	C_Timer.After (20, Attendance.StartUp)
end

function Attendance:CheckOldTables()
	local removed = 0
	for id, att_table in pairs (Attendance.db.raidschedules) do
		for day, day_table in pairs (att_table) do 
			if (day_table.t + 2592000 < time()) then
				att_table [day] = nil
				removed = removed + 1
			end
		end
	end

	Attendance:Msg ("Removed", removed, "attendance tables outdated.")
end

Attendance.OnEnable = function (plugin)

end

Attendance.OnDisable = function (plugin)

end

Attendance.OnProfileChanged = function (plugin)

end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function Attendance:GetAttendanceTable (index)
	return Attendance.db.raidschedules [index]
end

function Attendance:OnFinishCapture()
	Attendance:Msg ("raid time ended.")
	Attendance.need_popup_update = true
end

function Attendance:Msg (...)
	if (Attendance.debug) then
		print ("|cFFFFDD00Attendance|r:", ...)
	end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--doo

function Attendance.OnShowOnOptionsPanel()
	local OptionsPanel = Attendance.OptionsPanel
	Attendance.BuildOptions (OptionsPanel)
end

function Attendance.BuildOptions (frame)

	if (frame.FirstRun) then
		Attendance.update_attendance()
		return
	end
	frame.FirstRun = true
	
	local fill_panel = Attendance:CreateFillPanel (frame, {}, 790, 460, false, false, false, {rowheight = 16}, "fill_panel", "AttendanceFillPanel")
	fill_panel:SetPoint ("topleft", frame, "topleft", 10, 0)
	
	-- captura toda e qualquer attendance de todos os cores registrados
	-- precisa estar em guilda
	
	--dropdown to select which attendance to show
	
	
	--box with the attendance tables
	Attendance.update_attendance = function()
	
		local _, current_db = next (Attendance.db.raidschedules) -- Attendance.db.raidschedules = scheduleId - days table

		if (current_db) then
		
			--> short from oldest to newer
			local alphabetical_months = {}
			for key, table in pairs (current_db) do
				local m, d = key:match ("(%d+)-(%d+)")
				if (string.len (d) == 1) then
					d = "0" .. d
				end
				local value = tonumber (m .. d)
				tinsert (alphabetical_months, {key, table, value})
			end
			
			table.sort (alphabetical_months, function (t1, t2) return t2[3] < t1[3] end)			
	
			--add the two initial headers for player name and total attendance
			local header = {{name = "Player Name", type = "text", width = 120}, {name = "ATT", type = "text", width = 60}}
			local players = {}
			local players_index = {}
			local amt_days = 0
			local sort = table.sort
			
			for i, table in ipairs (alphabetical_months) do
				
				local month = table [1]
				local att_table = table [2]
			
				amt_days = amt_days + 1
				
				--add the header for this vertical row
				local time_at = date ("%a", att_table.t)
				
				tinsert (header, {name = table[1] .. " (" .. time_at .. ")", type = "text", width = 60})
				
				for player_id, player_points in pairs (att_table.players) do
					local index = players_index [player_id]
					local player
					
					if (not index) then
						local player_name = Attendance:GetPlayerNameFromId (player_id)
						
						--first match for this player, fill the previous days with "-"
						player = {player_name, 0}
						for o = 1, i-1 do
							tinsert (player, "-")
						end
						tinsert (player, player_points)
						player[2] = player[2] + player_points
						tinsert (players, player)
						players_index [player_id] = #players
					else
						player = players [index]
						
						--fill the player table if he missed some days
						for o = #player+1, i-1 do
							tinsert (player, "-")
						end
						
						player[2] = player[2] + player_points
						tinsert (player, player_points)
					end					
				end
			end
			
			--fill the player table is he missed all days until the end
			for index, player_table in ipairs (players) do
				for i = #player_table-1, amt_days do
					tinsert (player_table, "-")
				end
			end

			local sort_alphabetical = function(a,b) return a[1] < b[1] end
			sort (players, sort_alphabetical)

			frame.fill_panel:SetFillFunction (function (index) return players [index] end)
			frame.fill_panel:SetTotalFunction (function() return #players end)
			
			--frame:SetSize (math.min (GetScreenWidth()-200, #header*100), (#players*16) + 32)
			frame:SetSize (math.min (GetScreenWidth()-200, (#header*60) + 60), 450)
			--frame.fill_panel:SetSize (math.min (GetScreenWidth()-200, #header*100), (#players*16) + 32)
			frame.fill_panel:SetSize (math.min (GetScreenWidth()-200, (#header*60) + 60), 450)
			
			frame.fill_panel:UpdateRows (header)
			frame.fill_panel:Refresh()

		else
			
		end

	end
	
	frame:SetScript ("OnShow", function()
		Attendance.update_attendance()
	end)
	
	Attendance.update_attendance()
	
end

local install_status = RA:InstallPlugin (L["S_PLUGIN_ATTENDANCE_NAME"], "RAAttendance", Attendance, default_config)


------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function Attendance:CheckForNextEvent()
	local next_event_in, start_time, end_time, day, month_number, month_day, index = RaidSchedule:GetNextEventTime()
	if (next_event_in) then
	
		Attendance:Msg ("Attendance Next Event:", next_event_in)
		
		local now = time()
		if (now < next_event_in) then
			C_Timer.After (next_event_in+1, Attendance.CheckForNextEvent)
			Attendance:Msg ("Nop, next event is too far away.")
		elseif (next_event_in == 0) then --return 0 if time() is bigger than the start time
			if (Attendance.is_capturing) then
				Attendance:Msg ("Is already capturing.")
				return
			else
				Attendance:Msg ("Need to start capturing.")
				Attendance:StartNewCapture (start_time, end_time, now, day, month_number, month_day, index)
			end
		end
	end
end

function Attendance:CaptureIsOver()
	--> clean up
	Attendance.capture_ticker = nil
	Attendance.is_capturing = nil
	Attendance.db_table = nil
	Attendance.player_table = nil
	Attendance.guild_name = nil
	
	--> on finish
	Attendance:OnFinishCapture()
	
	--> check next event
	C_Timer.After (5, Attendance.CheckForNextEvent)
end

function Attendance:GetPlayerID (unitid)
	local guid = UnitGUID (unitid)
	if (guid) then
		return guid:gsub ("^.*-", "")
	end
end

function Attendance:GetPlayerNameFromId (id)
	return Attendance.db.playerids [id] or id
end

function Attendance:StartNewCapture (start_time, end_time, now, day, month_number, month_day, raidschedule_index)

	--> get the raidschedule table from the database
	local db = Attendance.db.raidschedules [raidschedule_index]
	if (not db) then
		Attendance.db.raidschedules [raidschedule_index] = {}
		db = Attendance.db.raidschedules [raidschedule_index]
	end

	--> get 'todays' ket id
	local key = "" .. month_number .. "-" .. month_day

	--> get the GUID table with the 'todays' attendance
	local ctable = db [key]
	if (not ctable) then
		db [key] = {t = time(), players = {}}
		ctable = db [key]
	end

	Attendance.is_capturing = true
	Attendance.db_table = db
	Attendance.player_table = ctable
	Attendance.guild_name = GetGuildInfo ("player")
	
	local ticks = floor ((end_time - start_time) / 60)

	Attendance:StartCapture (ticks)
	
	Attendance:Msg ("Raid time started.", ticks)
end

local do_capture_tick = function (tick_object)

	local amt_player = 0

	if (IsInRaid()) then
		local guild_name = Attendance.guild_name --string guild name
		local player_table = Attendance.player_table.players --holds [player id] = number
		local name_pool = Attendance.db.playerids
		
		for i = 1, GetNumGroupMembers() do
			local player_guild = GetGuildInfo ("raid" .. i)
			--if (player_guild == Attendance.guild_name) then
				local id = Attendance:GetPlayerID ("raid" .. i)
				if (id) then
					player_table [id] = (player_table [id] or 0) + 1
					amt_player = amt_player + 1
					if (not name_pool [id]) then
						name_pool [id] = GetUnitName ("raid" .. i, true)
					end
				end
			--end
		end
	end
	
	Attendance:Msg ("Tick", amt_player, "counted.")
	
	if (tick_object._remainingIterations == 1) then
		--> it's over
		Attendance:CaptureIsOver()
	end
end

function Attendance:StartCapture (ticks)
	-- cancel any tick ongoing
	if (Attendance.capture_ticker and not Attendance.capture_ticker._cancelled) then
		Attendance.capture_ticker:Cancel()
		Attendance:Msg ("Capture ticker is true, cancelling and starting a new one.")
	end
	
	-- start the ticker
	Attendance.capture_ticker = C_Timer.NewTicker (60, do_capture_tick, ticks-1)
	Attendance:Msg ("Capture ticker has been started.")
end


-- ao receber NEW verifica se quem mandou é guild master, somente GM pode criar novas tabelas.
-- NEW todos criam as tabelas.

-- ao receber EDIT verifica se quem mandou é officer do attendance ou guild master.
-- GM pode editar todas as tabelas, officer apenas as deles.

-- ao receber DELETE verifica se quem mandou é officer/gm ou se a guilda que o player esta é difirente da tabela.

-- SHAREAR INDEXES

-- somente officer mandam informações
-- officers somente recebem informações de outro officer para sincronizar as tabelas

-- officer manda o index do dia e espera alguem pedir
-- e vai mandando e shariando com todos na raide

