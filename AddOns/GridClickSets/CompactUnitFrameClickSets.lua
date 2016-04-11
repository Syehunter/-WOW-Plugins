hooksecurefunc("CompactUnitFrame_SetUpClicks", function(frame)
	if InCombatLockdown() then
		GridClickSetsFrame_UpdateAll(true)
	else
		frame:RegisterForClicks("AnyUp");
		GridClickSets_SetAttributes(frame, GridClickSets_Set);
	end
end);

--[[
hooksecurefunc("CompactPartyFrame_UpdateShown", function(self)
	if ( GetCVarBool("useCompactPartyFrames") and GetNumGroupMembers() == 0 and not InCombatLockdown() ) then
		self:Show();
	end	
end)
]]

local button = CreateFrame("Button", "CompactClickSetsButton", CompactRaidFrameManagerDisplayFrame, "UIMenuButtonStretchTemplate");
button:SetHeight(21);
button:SetText(GRIDCLICKSETS_TITLE);
button:SetPoint("LEFT", button:GetParent(), "LEFT", 8, 0);
button:SetPoint("RIGHT", button:GetParent(), "RIGHT", -5, 0);
button:SetPoint("TOP", button:GetParent(), "BOTTOM", 0, 6);
button:SetScript("OnClick", function() if GridClickSetsFrame:IsVisible() then GridClickSetsFrame:Hide() else GridClickSetsFrame:Show() end end)

function CompactUnitFrameClickSets_UpdateAll(set)
	for i=1, MEMBERS_PER_RAID_GROUP do
		local frame = _G["CompactPartyFrameMember"..i]
		if not frame then break; end
		frame:RegisterForClicks("AnyUp");
		GridClickSets_SetAttributes(frame, set);
	end

	for i=1, MAX_RAID_MEMBERS do
		local frame = _G["CompactRaidFrame"..i]
		if not frame then break; end
		frame:RegisterForClicks("AnyUp");
		GridClickSets_SetAttributes(frame, set);
	end
end

if GridClickSetsFrame_Updates then 
	table.insert(GridClickSetsFrame_Updates, CompactUnitFrameClickSets_UpdateAll);
end