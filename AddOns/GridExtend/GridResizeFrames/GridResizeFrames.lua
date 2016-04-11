------------------------------
--          Locals          --
------------------------------
local _, addonTable = ...
local L = addonTable.L
local GridL = _G.Grid.L
local select = select

local GetNumSubgroupMembers = GetNumSubgroupMembers
local GetNumGroupMembers = GetNumGroupMembers
local GetRaidRosterInfo = GetRaidRosterInfo
local InCombatLockdown = InCombatLockdown

GridResizeFrames = Grid:NewModule("GridResizeFrames", "AceBucket-3.0")
local GridResizeFrames = GridResizeFrames
local GridLayout = Grid:GetModule("GridLayout")
local GridFrame = Grid:GetModule("GridFrame")


------------------------------
--         Defaults         --
------------------------------
GridResizeFrames.defaultDB = {
  lastSize = nil,
  groupWidth = {
  	[1] = 60,
  	[2] = 55,
  	[3] = 75,
  	[4] = 80,
  	[5] = 60,
  	[6] = 50,
  	[7] = 40,
  	[8] = 37,
  },
  groupHeight = {
  	[1] = 60,
  	[2] = 55,
  	[3] = 75,
  	[4] = 80,
  	[5] = 60,
  	[6] = 50,
  	[7] = 40,
  	[8] = 37,
  },
}


------------------------------
--     Layout Functions     --
------------------------------
-- Create the layout based on max number of groups to show
local function getDynamicLayout(maxGroups)
	local layout = {}
  	local raidSize = GetNumGroupMembers()
  	local currentGroups = {}
  	for i = 1, NUM_RAID_GROUPS, 1 do
    	currentGroups[i] = false;
  	end
  	for i = 1, maxGroups, 1 do
  		currentGroups[i] = true;
  	end
	if IsInRaid() then
    	local group = 1
    	for i = 1, NUM_RAID_GROUPS, 1 do
      		if (currentGroups[i]) then
        		layout[group] = {
          			groupFilter = ""..i,
        		}
        		group = group + 1
      		end
    	end
    	local groupString = ""
    	local first = true
    	for i = 1, NUM_RAID_GROUPS, 1 do
     		if (currentGroups[i]) then
        		if (first) then
          			groupString = groupString..i
          			first = false
        		else
          			groupString = groupString..','..i
        		end
      		end
    	end
  	else
    	layout[1] = {
      		showParty = true,
      		showRaid = false,
      		sortMethod = "INDEX",
    	}
  	end

	return layout
end

-- Determine the max number of groups to show
local function getRaidSize()
	local maxGroups = 1
	local raidSize = GetNumGroupMembers()

	if raidSize > 0 then
    	maxGroups = ceil(raidSize / 5)
    	if IsInRaid() then
    		for i = 1, raidSize do
    			local group = select(3, GetRaidRosterInfo(i))
    			maxGroups = max(maxGroups, group)
    		end
    	end
	elseif GetNumSubgroupMembers() > 0 then
    	maxGroups = 1
  	end

  	return maxGroups
end


-------------------------------
--     OnEvent Functions     --
-------------------------------
-- Initialize the addon and default vars
function GridResizeFrames:OnInitialize()
	self.super.OnInitialize(self)

	self.db.profile.lastSize = getRaidSize()
  	self:Debug(L["DEBUG_MAXGROUPS"], self.db.profile.lastSize)
end

-- Set up the Options pane and register update events
function GridResizeFrames:OnEnable()
  local opt = Grid.options.args
  opt["GridResizeFrames"] = {
    type = "group",
    name = L["GridResizeFrames"],
    desc = L["OPT_DESC"],
    childGroups = "tab",
	args = {
    	width = {
    		name = L["Width"],
			order = 1,
			type = "group",
			args = {
    			OneGroupWidth = {
					name = L["ONE_GROUP"],
					desc = L["ONE_GROUP_DESC"],
					order = 1, width = "double",
					type = "range", min = 10, max = 200, step = 1,
					get = function(info)
						return self.db.profile.groupWidth[1]
					end,
					set = function(info, v)
						self.db.profile.groupWidth[1] = v
						if (self.db.profile.lastSize == 1) then
							GridFrame.db.profile.frameWidth = v
							GridFrame:ResizeAllFrames()
							GridFrame:ScheduleTimer("Grid_ReloadLayout", 0.5)
						end
					end,
				},
				TwoGroupWidth = {
					name = L["TWO_GROUP"],
					desc = L["TWO_GROUP_DESC"],
					order = 2, width = "double",
					type = "range", min = 10, max = 200, step = 1,
					get = function(info)
						return self.db.profile.groupWidth[2]
					end,
					set = function(info, v)
						self.db.profile.groupWidth[2] = v
						if (self.db.profile.lastSize == 2) then
							GridFrame.db.profile.frameWidth = v
							GridFrame:ResizeAllFrames()
							GridFrame:ScheduleTimer("Grid_ReloadLayout", 0.5)
						end
					end,
				},
				ThreeGroupWidth = {
					name = L["THREE_GROUP"],
					desc = L["THREE_GROUP_DESC"],
					order = 3, width = "double",
					type = "range", min = 10, max = 200, step = 1,
					get = function(info)
						return self.db.profile.groupWidth[3]
					end,
					set = function(info, v)
						self.db.profile.groupWidth[3] = v
						if (self.db.profile.lastSize == 3) then
							GridFrame.db.profile.frameWidth = v
							GridFrame:ResizeAllFrames()
							GridFrame:ScheduleTimer("Grid_ReloadLayout", 0.5)
						end
					end,
				},
				FourGroupWidth = {
					name = L["FOUR_GROUP"],
					desc = L["FOUR_GROUP_DESC"],
					order = 4, width = "double",
					type = "range", min = 10, max = 200, step = 1,
					get = function(info)
						return self.db.profile.groupWidth[4]
					end,
					set = function(info, v)
						self.db.profile.groupWidth[4] = v
						if (self.db.profile.lastSize == 4) then
							GridFrame.db.profile.frameWidth = v
							GridFrame:ResizeAllFrames()
							GridFrame:ScheduleTimer("Grid_ReloadLayout", 0.5)
						end
					end,
				},
				FiveGroupWidth = {
					name = L["FIVE_GROUP"],
					desc = L["FIVE_GROUP_DESC"],
					order = 5, width = "double",
					type = "range", min = 10, max = 200, step = 1,
					get = function(info)
						return self.db.profile.groupWidth[5]
					end,
					set = function(info, v)
						self.db.profile.groupWidth[5] = v
						if (self.db.profile.lastSize == 5) then
							GridFrame.db.profile.frameWidth = v
							GridFrame:ResizeAllFrames()
							GridFrame:ScheduleTimer("Grid_ReloadLayout", 0.5)
						end
					end,
				},
				SixGroupWidth = {
					name = L["SIX_GROUP"],
					desc = L["SIX_GROUP_DESC"],
					order = 6, width = "double",
					type = "range", min = 10, max = 200, step = 1,
					get = function(info)
						return self.db.profile.groupWidth[6]
					end,
					set = function(info, v)
						self.db.profile.groupWidth[6] = v
						if (self.db.profile.lastSize == 6) then
							GridFrame.db.profile.frameWidth = v
							GridFrame:ResizeAllFrames()
							GridFrame:ScheduleTimer("Grid_ReloadLayout", 0.5)
						end
					end,
				},
				SevenGroupWidth = {
					name = L["SEVEN_GROUP"],
					desc = L["SEVEN_GROUP_DESC"],
					order = 7, width = "double",
					type = "range", min = 10, max = 200, step = 1,
					get = function(info)
						return self.db.profile.groupWidth[7]
					end,
					set = function(info, v)
						self.db.profile.groupWidth[7] = v
						if (self.db.profile.lastSize == 7) then
							GridFrame.db.profile.frameWidth = v
							GridFrame:ResizeAllFrames()
							GridFrame:ScheduleTimer("Grid_ReloadLayout", 0.5)
						end
					end,
				},
				EightGroupWidth = {
					name = L["EIGHT_GROUP"],
					desc = L["EIGHT_GROUP_DESC"],
					order = 8, width = "double",
					type = "range", min = 10, max = 200, step = 1,
					get = function(info)
						return self.db.profile.groupWidth[8]
					end,
					set = function(info, v)
						self.db.profile.groupWidth[8] = v
						if (self.db.profile.lastSize == 8) then
							GridFrame.db.profile.frameWidth = v
							GridFrame:ResizeAllFrames()
							GridFrame:ScheduleTimer("Grid_ReloadLayout", 0.5)
						end
					end,
				},
		    },
		},
		height = {
			name = L["Height"],
			order = 2,
			type = "group",
			args = {
    			OneGroupHeight = {
					name = L["ONE_GROUP_H"],
					desc = L["ONE_GROUP_DESC_H"],
					order = 1, width = "double",
					type = "range", min = 10, max = 100, step = 1,
					get = function(info)
						return self.db.profile.groupHeight[1]
					end,
					set = function(info, v)
						self.db.profile.groupHeight[1] = v
						if (self.db.profile.lastSize == 1) then
							GridFrame.db.profile.frameHeight = v
							GridFrame:ResizeAllFrames()
							GridFrame:ScheduleTimer("Grid_ReloadLayout", 0.5)
						end
					end,
				},
				TwoGroupHeight = {
					name = L["TWO_GROUP_H"],
					desc = L["TWO_GROUP_DESC_H"],
					order = 2, width = "double",
					type = "range", min = 10, max = 100, step = 1,
					get = function(info)
						return self.db.profile.groupHeight[2]
					end,
					set = function(info, v)
						self.db.profile.groupHeight[2] = v
						if (self.db.profile.lastSize == 2) then
							GridFrame.db.profile.frameHeight = v
							GridFrame:ResizeAllFrames()
							GridFrame:ScheduleTimer("Grid_ReloadLayout", 0.5)
						end
					end,
				},
				ThreeGroupHeight = {
					name = L["THREE_GROUP_H"],
					desc = L["THREE_GROUP_DESC_H"],
					order = 3, width = "double",
					type = "range", min = 10, max = 100, step = 1,
					get = function(info)
						return self.db.profile.groupHeight[3]
					end,
					set = function(info, v)
						self.db.profile.groupHeight[3] = v
						if (self.db.profile.lastSize == 3) then
							GridFrame.db.profile.frameHeight = v
							GridFrame:ResizeAllFrames()
							GridFrame:ScheduleTimer("Grid_ReloadLayout", 0.5)
						end
					end,
				},
				FourGroupHeight = {
					name = L["FOUR_GROUP_H"],
					desc = L["FOUR_GROUP_DESC_H"],
					order = 4, width = "double",
					type = "range", min = 10, max = 100, step = 1,
					get = function(info)
						return self.db.profile.groupHeight[4]
					end,
					set = function(info, v)
						self.db.profile.groupHeight[4] = v
						if (self.db.profile.lastSize == 4) then
							GridFrame.db.profile.frameHeight = v
							GridFrame:ResizeAllFrames()
							GridFrame:ScheduleTimer("Grid_ReloadLayout", 0.5)
						end
					end,
				},
				FiveGroupHeight = {
					name = L["FIVE_GROUP_H"],
					desc = L["FIVE_GROUP_DESC_H"],
					order = 5, width = "double",
					type = "range", min = 10, max = 100, step = 1,
					get = function(info)
						return self.db.profile.groupHeight[5]
					end,
					set = function(info, v)
						self.db.profile.groupHeight[5] = v
						if (self.db.profile.lastSize == 5) then
							GridFrame.db.profile.frameHeight = v
							GridFrame:ResizeAllFrames()
							GridFrame:ScheduleTimer("Grid_ReloadLayout", 0.5)
						end
					end,
				},
				SixGroupHeight = {
					name = L["SIX_GROUP_H"],
					desc = L["SIX_GROUP_DESC_H"],
					order = 6, width = "double",
					type = "range", min = 10, max = 100, step = 1,
					get = function(info)
						return self.db.profile.groupHeight[6]
					end,
					set = function(info, v)
						self.db.profile.groupHeight[6] = v
						if (self.db.profile.lastSize == 6) then
							GridFrame.db.profile.frameHeight = v
							GridFrame:ResizeAllFrames()
							GridFrame:ScheduleTimer("Grid_ReloadLayout", 0.5)
						end
					end,
				},
				SevenGroupHeight = {
					name = L["SEVEN_GROUP_H"],
					desc = L["SEVEN_GROUP_DESC_H"],
					order = 7, width = "double",
					type = "range", min = 10, max = 100, step = 1,
					get = function(info)
						return self.db.profile.groupHeight[7]
					end,
					set = function(info, v)
						self.db.profile.groupHeight[7] = v
						if (self.db.profile.lastSize == 7) then
							GridFrame.db.profile.frameHeight = v
							GridFrame:ResizeAllFrames()
							GridFrame:ScheduleTimer("Grid_ReloadLayout", 0.5)
						end
					end,
				},
				EightGroupHeight = {
					name = L["EIGHT_GROUP_H"],
					desc = L["EIGHT_GROUP_DESC_H"],
					order = 8, width = "double",
					type = "range", min = 10, max = 100, step = 1,
					get = function(info)
						return self.db.profile.groupHeight[8]
					end,
					set = function(info, v)
						self.db.profile.groupHeight[8] = v
						if (self.db.profile.lastSize == 8) then
							GridFrame.db.profile.frameHeight = v
							GridFrame:ResizeAllFrames()
							GridFrame:ScheduleTimer("Grid_ReloadLayout", 0.5)
						end
					end,
				},
		    },
		},
	},
  }

  self.super.OnEnable(self)

  self:RegisterBucketEvent({"GROUP_ROSTER_UPDATE", "PLAYER_ENTERING_WORLD"}, 0.5, "CheckRoster")
  self:RegisterEvent("Grid_LeavingCombat", "ScheduleUpdate")

  self.scheduleUpdate = false
end

-- Unregister all events and stop the scheduler
function GridResizeFrames:OnDisable()
  self.scheduleUpdate = false
  self:UnregisterAllEvents()
end


------------------------------
--     Update Functions     --
------------------------------
-- Scheduler loop to prevent in-combat taint
function GridResizeFrames:ScheduleUpdate()
  if self.scheduleUpdate then
    self:Debug(L["DEBUG_LEAVECOMBAT"])
    self.scheduleUpdate = false
    self:CheckRoster()
  end
end

-- Re-check the roster and update layout/width if necessary
function GridResizeFrames:CheckRoster()
  if self == nil then self = GridResizeFrames end
  if InCombatLockdown() then
  	self.scheduleUpdate = true
  	self:Debug(L["DEBUG_INCOMBAT"])
  	return
  end

  local maxGroups = getRaidSize()
  local layout = getDynamicLayout(maxGroups)
  local currentLayout = GridLayout.db.profile.layout
  local isHorizontal = GridLayout.db.profile.horizontal

  GridLayout:AddLayout(L["LAYOUT_NAME"], layout)

  if (self.db.profile.lastSize ~= maxGroups) and (currentLayout == L["LAYOUT_NAME"]) then
  	self:Debug(L["DEBUG_CHANGEFROM"], self.db.profile.lastSize, L["DEBUG_CHANGETO"], maxGroups)
  	self.db.profile.lastSize = maxGroups
  	if isHorizontal == true then
  		self:Debug("Horizontal Group Update")
  		GridFrame.db.profile.frameHeight = self.db.profile.groupHeight[maxGroups]
  		GridFrame:ResizeAllFrames()
  		GridFrame:ScheduleTimer("Grid_ReloadLayout", 0.5)
  	else
  		self:Debug("Vertical Group Update")
  		GridFrame.db.profile.frameWidth = self.db.profile.groupWidth[maxGroups]
  		GridFrame:ResizeAllFrames()
  		GridFrame:ScheduleTimer("Grid_ReloadLayout", 0.5)
  	end
  else
  	self:Debug(L["DEBUG_NOCHANGE"])
  end

  GridLayout:ReloadLayout()
  GridFrame:ResizeAllFrames()
  GridFrame:UpdateAllFrames()
  GridLayout:ReloadLayout()

end
