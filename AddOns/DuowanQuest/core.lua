local function CollapseObjective()
	--折叠任务追踪框
	if dwRawGetCVar("QuestMod", "AutoCollapse", 1) ~= 1 then return; end
	
	if IsInInstance() then
		if (not ObjectiveTrackerFrame.collapsed) then
			ObjectiveTracker_Collapse();
		end
	else
		if ObjectiveTrackerFrame.collapsed then
			ObjectiveTracker_Expand();
		end
	end		
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD", CollapseObjective);