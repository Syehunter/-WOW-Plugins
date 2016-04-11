local cfg;
local LibQTip = LibStub('LibQTip-1.0');
local otooltip
local ssHeaderFont = CreateFont("ssHeaderFont")
ssHeaderFont:SetTextColor(1,0.823529,0)
ssHeaderFont:SetFont(GameTooltipHeaderText:GetFont(), 12)
local ssRegFont = CreateFont("ssRegFont")
ssRegFont:SetTextColor(1,0.823529,0)
ssRegFont:SetFont(GameTooltipText:GetFont(), 12)

local LDB = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("Valor",
{
	type	= "data source",
	icon	= "Interface\\Icons\\pvecurrency-valor",
	label	= "Valor",
	text	= "Valor",
})
local LDB_ANCHOR;

local mythicdungeonid = {547,385,536,558,537,476,556,559}
local mythicdungeonmapid = {1182,1175,1208,1195,1176,1209,1279,1358}
local mythicdungeonloc = {
	[547] = {946,0.4628,0.7394,"Draenor-Talador"},
	[385] = {941,0.4993,0.248,"Draenor-Frostfire Ridge"},
	[536] = {949,0.551,0.3156,"Draenor-Gorgrond"},
	[558] = {949,0.4522,0.1352,"Draenor-Gorgrond"},
	[537] = {947,0.3188,0.4251,"Draenor-Shadowmoon Valley"},
	[476] = {948,0.3556,0.3354,"Draenor-Spires of Arak"},
	[556] = {949,0.5957,0.4549,"Draenor-Gorgrond"},
	[559] = {29,0.2126,0.4032,"Orgrimmar-Blasted Land Portal-Burning Stepps-Blackrock Mountain"}
}
local lfrWoDValor = {
  {849,3,false}, -- Highmaul1: Walled City
  {850,6,false}, -- Highmaul2: Arcane Sanctum
  {851,7,false}, -- Highmaul3: Imperator's Rise
  {847,7,false}, -- BRF1: Slagworks
  {846,8,false}, -- BRF2: The Black Forge
  {848,9,false}, -- BRF3: Iron Assembly
  {823,10,false}, -- BRF4: Blackhand's Crucible
  {982,3,false}, -- Hellfire1: Hellbreach
  {983,6,false}, -- Hellfire2: Halls of Blood
  {984,11,false}, -- Hellfire3: Bastion of Shadows
  {985,12,false}, -- Hellfire4: Destructor's Rise
  {986,13,false}, -- Hellfire5: Black Gate
}
local weeklyquestvalor = {
	{"calendar_weekendapexis",39033},
	{"calendar_weekendbattlegrounds",39040},
	{"calendar_weekendpvpskirmish",39041},
	{"calendar_weekendburningcrusade",39020},
	{"calendar_weekendwrathofthelichking",39021},
	{"calendar_weekendcataclysm",40792},
	{"calendar_weekendwarlordsofdraenor",39034},
}

function OLFRInstanceFrame(instanceid)
    if RaidFinderFrame and RaidFinderFrame:IsVisible() and RaidFinderQueueFrame.raid ~= instanceid then
      -- changing entries
    else
      PVEFrame_ToggleFrame("GroupFinderFrame", RaidFinderFrame)
    end
    if RaidFinderFrame and RaidFinderFrame:IsVisible() and RaidFinderQueueFrame_SetRaid then
      RaidFinderQueueFrame_SetRaid(instanceid)
    end
end

function OLFDInstanceFrame()
    if LFDParentFrame and LFDParentFrame:IsVisible() and LFDQueueFrame.type ~= 789 then
      -- changing entries
    else
      PVEFrame_ToggleFrame("GroupFinderFrame", LFDParentFrame)
    end
    if LFDParentFrame and LFDParentFrame:IsVisible() and LFDQueueFrame_SetType then
      LFDQueueFrame_SetType(789)
    end
end

local fsearch = CreateFrame("Frame")
fsearch:SetScript("OnEvent",function(self,event)
	self:UnregisterEvent("LFG_LIST_SEARCH_RESULTS_RECEIVED")
	LFGListFrame.SearchPanel.SearchBox:SetText(self.search)
	C_LFGList.Search(2,self.search)
end)

function PremadeGroupFrame(msg)
    if LFGListPVEStub and LFGListPVEStub:IsVisible() then
      -- changing entries
    else
      PVEFrame_ToggleFrame("GroupFinderFrame", LFGListPVEStub)
    end
    if LFGListPVEStub and LFGListPVEStub:IsVisible() and LFGListCategorySelection_SelectCategory then
      LFGListCategorySelection_SelectCategory(LFGListFrame.CategorySelection,2,0)
	  LFGListCategorySelectionFindGroupButton_OnClick(LFGListFrame.CategorySelection.FindGroupButton)
	  fsearch.search = msg
	  fsearch.time = GetTime()
	  fsearch:RegisterEvent("LFG_LIST_SEARCH_RESULTS_RECEIVED")
    end
end


function AddTomTomMythicDungeon(dungeonID)
	if TomTom then
	TomTom:AddMFWaypoint(	mythicdungeonloc[dungeonID][1],0,
							mythicdungeonloc[dungeonID][2],
							mythicdungeonloc[dungeonID][3],
							{title=EJ_GetInstanceInfo(dungeonID).."\n"..mythicdungeonloc[dungeonID][4]})
	end
end

function LDB.OnEnter(self)	
	LDB_ANCHOR = self;
	OValorTooltip();
end

function LDB.OnClick(self)
end

local bossFrame = CreateFrame('GameTooltip', 'bossFrame', UIParent, 'GameTooltipTemplate');
local function CheckLastBossKill(itemLink,n)
	bossFrame:SetOwner(UIParent, 'ANCHOR_NONE');
	bossFrame:ClearLines();
	bossFrame:SetHyperlink(itemLink);
	if _G["bossFrameTextRight"..(n+1)]:GetText() == BOSS_DEAD then
		return true
	else
		return false
	end
end

function OValorTooltip()
	local self = LDB_ANCHOR;
	if otooltip ~= nil then
		if LibQTip:IsAcquired("ValorDB") then otooltip:Clear() end
		otooltip:Hide()
		LibQTip:Release(otooltip)
		otooltip = nil
	end
	collectgarbage()
if not UnitAffectingCombat("player") then
	otooltip = LibQTip:Acquire("ValorDB", 2, "LEFT", "CENTER")
	otooltip:SetBackdropColor(0,0,0,1)
	otooltip:SetHeaderFont(ssHeaderFont)
	otooltip:SetFont(ssRegFont)
	otooltip:SmartAnchorTo(self)
	otooltip:SetAutoHideDelay(0.25,self,function()
		otooltip:Hide() 
		if otooltip ~= nil then
			LibQTip:Release(otooltip)
			otooltip = nil
		end
	end)
	-- Valor
	local _, valora, _ = GetCurrencyInfo(1191)
	local line = otooltip:AddLine("|TInterface\\Icons\\pvecurrency-valor:0:0:0:0|t",valora)
	otooltip:AddSeparator();
	local raiddungeon = {}
	for i = 1, GetNumSavedInstances() do
		raiddungeon[i] = {}
		_,_,_,raiddungeon[i][3],raiddungeon[i][2],_,_,_,_,_,raiddungeon[i][4],_ = GetSavedInstanceInfo(i)
		local link = GetSavedInstanceChatLink(i) or ""
		raiddungeon[i][1] = link:match(":(%d+):%d+:%d+\124h%[.+%]\124h")
		raiddungeon[i][5] = CheckLastBossKill(link,raiddungeon[i][4])
	end
	local MythicDungeonName = {}
	for i = 1, 8 do MythicDungeonName[i] = {EJ_GetInstanceInfo(mythicdungeonid[i]),false} end
	for i = 1, GetNumSavedInstances() do
		for j = 1, 8 do
			if tonumber(raiddungeon[i][1]) ==  mythicdungeonmapid[j] and raiddungeon[i][2] and raiddungeon[i][3] == 23 and raiddungeon[i][5] then
				MythicDungeonName[j][2] = true
			end
		end
	end	
	for i = 1, 8 do
		if MythicDungeonName[i][2] then
			line = otooltip:AddLine(PLAYER_DIFFICULTY6.." - "..MythicDungeonName[i][1],"|TInterface\\RAIDFRAME\\ReadyCheck-Ready:0:0:0:0|t")
		else
			line = otooltip:AddLine(PLAYER_DIFFICULTY6.." - "..MythicDungeonName[i][1],"|TInterface\\RAIDFRAME\\ReadyCheck-NotReady:0:0:0:0|t")
		end
		otooltip:SetLineScript(line, "OnMouseUp", function(self,info,button) 
			if button == "RightButton" then
				AddTomTomMythicDungeon(mythicdungeonid[i])
			else
				PremadeGroupFrame(MythicDungeonName[i][1].." ("..PLAYER_DIFFICULTY6..")")
			end
		end)
	end
	otooltip:AddSeparator();
	-- Check LFR
	for i = 1, 12 do
		lfrWoDValor[i][3], _ = select(3,GetLFGDungeonEncounterInfo(lfrWoDValor[i][1],lfrWoDValor[i][2]))
	end
	for i = 1, 12 do
		local name = GetLFGDungeonInfo(lfrWoDValor[i][1])
		if lfrWoDValor[i][3] then
			line = otooltip:AddLine(PLAYER_DIFFICULTY3.." - "..name,"|TInterface\\RAIDFRAME\\ReadyCheck-Ready:0:0:0:0|t")
		else
			line = otooltip:AddLine(PLAYER_DIFFICULTY3.." - "..name,"|TInterface\\RAIDFRAME\\ReadyCheck-NotReady:0:0:0:0|t")
		end
		otooltip:SetLineScript(line, "OnMouseUp", function() OLFRInstanceFrame(lfrWoDValor[i][1]) end)
		if i == 3 or i == 7 then otooltip:AddSeparator(); end
	end
	otooltip:AddSeparator();
	-- Check Random Heroic Dungeon
	local ranHDname, _ = GetLFGDungeonInfo(789)
	local rdone, _ = GetLFGDungeonRewards(789)
	if rdone then
		line = otooltip:AddLine(ranHDname,"|TInterface\\RAIDFRAME\\ReadyCheck-Ready:0:0:0:0|t")
	else
		line = otooltip:AddLine(ranHDname,"|TInterface\\RAIDFRAME\\ReadyCheck-NotReady:0:0:0:0|t")
	end
	otooltip:SetLineScript(line, "OnMouseUp", function() OLFDInstanceFrame() end)
	otooltip:AddSeparator();
	-- Check Bonus Event
	if not CalendarFrame then ToggleCalendar() ToggleCalendar() end
	local _, month, day, _ = CalendarGetDate()
	CalendarSetAbsMonth(month)
	for i = 1, CalendarGetNumDayEvents(0,day) do
		local title,bhour,_,_,btime,_,texture,_=CalendarGetDayEvent(0,day,i)
		local chour,_ = GetGameTime()
		for j = 1, 7 do
			if weeklyquestvalor[j][1] == texture and 
				(btime == "ONGOING" or (btime == "START" and chour >= bhour) or (btime == "END" and chour < bhour)) then
				if IsQuestFlaggedCompleted(weeklyquestvalor[j][2]) then
					line = otooltip:AddLine(title,"|TInterface\\RAIDFRAME\\ReadyCheck-Ready:0:0:0:0|t")
				else
					line = otooltip:AddLine(title,"|TInterface\\RAIDFRAME\\ReadyCheck-NotReady:0:0:0:0|t")
				end
			end
		end
	end
	otooltip:Show();
end
end

function OValorS(self,event, ...)
	if event == "CURRENCY_DISPLAY_UPDATE" then
		local name,v=GetCurrencyInfo(1191) 
		--LDB.text = "|TInterface\\Icons\\pvecurrency-valor:0:0:0:0|t"..v
		LDB.text = v
		LDB.label = name
	end
end

local OValor = CreateFrame("Frame");
OValor:SetScript("OnEvent", OValorS)
OValor:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
