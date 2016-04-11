function GridClickSets_OnGridLoaded()
	local GridFrame = Grid:GetModule("GridFrame")

	GridClickSets = Grid:NewModule("GridClickSets")
	
	local function GridOnInitializeFrame(gridFrameObj, frame)
		if (not frame.dropDown) then
			frame.dropDown = CreateFrame("Frame", frame:GetName().."DropDown", frame, "UIDropDownMenuTemplate");
			frame.dropDown:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 0, 2);
			tinsert(UnitPopupFrames, frame.dropDown:GetName());
			UIDropDownMenu_Initialize(frame.dropDown, GridFrameDropDown_Initialize, "MENU");
			frame.menu = function()
				ToggleDropDownMenu(1, nil, frame.dropDown, frame:GetName(), 0, 0);
			end
			frame:SetAttribute("*type2", "menu");
			frame.dropDown:Hide();
			GridClickSets_SetAttributes(frame, GridClickSets_Set);
		end	
	end

	hooksecurefunc(GridFrame, "InitializeFrame", function(gridFrameObj, frame)
		GridOnInitializeFrame(gridFrameObj, frame);
	end)
	
	local func_initFrame = function(frame) GridOnInitializeFrame(GridFrame, frame) end
	GridFrame:WithAllFrames(func_initFrame);

	function GridFrameDropDown_Initialize(self)
		local unit = self:GetParent().unit;
		if ( not unit ) then
			return;
		end
		local menu;
		local name;
		local id = nil;
		if ( UnitIsUnit(unit, "player") ) then
			menu = "SELF";
		elseif ( UnitIsUnit(unit, "vehicle") ) then
			-- NOTE: vehicle check must come before pet check for accuracy's sake because
			-- a vehicle may also be considered your pet
			menu = "VEHICLE";
		elseif ( UnitIsUnit(unit, "pet") ) then
			menu = "PET";
		elseif ( UnitIsPlayer(unit) ) then
			id = UnitInRaid(unit);
			if ( id ) then
				menu = "RAID_PLAYER";
				name = GetRaidRosterInfo(id);
			elseif ( UnitInParty(unit) ) then
				menu = "PARTY";
			else
				menu = "PLAYER";
			end
		else
			menu = "TARGET";
			name = RAID_TARGET_ICON;
		end
		if ( menu ) then
			UnitPopup_ShowMenu(self, menu, unit, name, id);
		end
	end

	GridClickSets.options = {
		type = "execute",
		name = GRIDCLICKSETS_MENUNAME,
		desc = GRIDCLICKSETS_MENUTIP,
		order = 1,
		func = function()
			LibStub("AceConfigDialog-3.0"):Close("Grid");
			GridClickSetsFrame:Show();
			GameTooltip:Hide();
		end
	}

	function GridClickSets:OnEnable()
		--the profile no longer work with grid.
	end

	function GridClickSets:Reset()
		--the profile no longer work with grid.
	end

	table.insert(GridClickSetsFrame_Updates, function(set)
		GridFrame:WithAllFrames(function (f) GridClickSets_SetAttributes(f, set) end)
	end);
end

if not Grid then 
	dwAsynCall("Grid", "GridClickSets_OnGridLoaded");
else
	GridClickSets_OnGridLoaded();
end