local StatLogic = LibStub("LibStatLogic-1.2")
local InspectLess = LibStub("LibInspectLess-1.0")

local OFFSET_X, OFFSET_Y = 0, 1;

local slots = {
	[1] = "Head",
	[2] = "Neck",
	[3] = "Shoulder",
	[4] = "Shirt",
	[5] = "Chest",
	[6] = "Waist",
	[7] = "Legs",
	[8] = "Feet",
	[9] = "Wrist",
	[10] = "Hands",
	[11] = "Finger0",
	[12] = "Finger1",
	[13] = "Trinket0",
	[14] = "Trinket1",
	[15] = "Back",
	[16] = "MainHand",
	[17] = "SecondaryHand",
	--[18] = "Ranged",
	[18] = "Tabard",
}

local function SetOrHookScript(frame, scriptName, func)
	if( frame:GetScript(scriptName) ) then
		frame:HookScript(scriptName, func);
	else
		frame:SetScript(scriptName, func);
	end
end

function RatingSummary_OnLoad(self)
	InspectLess:RegisterCallback("InspectLess_InspectItemReady", RatingSummary_InspectReady)
	RatingSummaryFrame:RegisterEvent("ADDON_LOADED");
end

function RatingSummary_Toggle(switch)
	if (switch) then
		RatingSummaryEnable = true;		
		RatingSummaryFrame:RegisterEvent("UNIT_INVENTORY_CHANGED");		
		RatingSummaryFrame:RegisterEvent("INSPECT_HONOR_UPDATE");
	else
		RatingSummaryEnable = false;
		RatingSummaryFrame:UnregisterEvent("UNIT_INVENTORY_CHANGED");		
		RatingSummaryFrame:UnregisterEvent("INSPECT_HONOR_UPDATE");

		RatingSummarySelfFrame:Hide();
		RatingSummaryTargetFrame:Hide();
	end
end

function RatingSummary_SetupHook()
	hooksecurefunc("InspectPaperDollFrame_OnShow", RatingSummary_InspectFrame_SetGuild);
	SetOrHookScript(InspectFrame, "OnShow", RatingSummary_InspectFrame_SetGuild);
	SetOrHookScript(InspectFrame, "OnHide", RatingSummary_InspectFrame_OnHide);
	hooksecurefunc("InspectFrame_UnitChanged", RatingSummary_InspectFrame_UnitChanged);
	InspectGuildFrame_Update_Origin = InspectGuildFrame_Update
	InspectGuildFrame_Update = function() 
		if InspectFrame.unit and GetGuildInfo(InspectFrame.unit) then
			InspectGuildFrame_Update_Origin()
		end
	end
end

function RatingSummary_CreateButton(buttonName, parentFrame, width, height, texture, TexCoords)
	local button = CreateFrame("Frame", buttonName, parentFrame or UIParent, "MagicResistanceFrameTemplate");
	
	button.texture = button:CreateTexture(nil, "BACKGROUND")	;
	button.texture:SetAllPoints(button);
	button.texture:SetTexture(texture);
	if TexCoords then
		button.texture:SetTexCoord(strsplit("|",TexCoords));
	end
	
	button.text = button:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall");
	button.text:SetPoint("BOTTOM", button, "BOTTOM", 0, 3);
	button.text:SetTextColor(1, 1, 1);
	button.text:SetText("0");
	
	return button;
end

function RatingSummary_CreateFrame(frameName, parentFrame, width, height, textNum, textL, textY)
	local textNum = textNum or 1;
	local textL = textL or 0; local textY = textY or -1; 
	local frame = CreateFrame("Frame", frameName, parentFrame or UIParent);
	frame:SetWidth(width);  frame:SetHeight(height);
	frame:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 16, edgeSize = 16,
		insets = {left = 5, right = 5, top = 5, bottom = 5}});
	frame:SetBackdropBorderColor(0.6, 0.7, 0.8, 0.4);
	frame:SetBackdropColor(0.2, 0.3, 0.4, 0.6);
	
	frame.title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall");
	frame.title:SetPoint("TOPLEFT", frame, "TOPLEFT", 6, -4);
	frame.title:SetTextColor(0.6,0.8,0.2);

	for i = 1, textNum do
		frame["text"..i] = frame:CreateFontString(nil, "ARTWORK", "GameTooltipTextSmall");
		frame["text"..i]:SetPoint("TOPLEFT", frame["text"..(i-1)] or frame.title, "BOTTOMLEFT", (i == 1) and textL or 0, (i == 1) and -3 or textY);
		frame["text"..i]:SetTextColor(0.9,0.8,0.12);
		frame["stat"..i] = frame:CreateFontString(nil, "ARTWORK", "GameTooltipTextSmall");
		frame["stat"..i]:SetPoint("RIGHT", frame["text"..i], "LEFT", width - textL -14, 0);
		frame["stat"..i]:SetJustifyH("RIGHT");
		frame["stat"..i]:SetTextColor(0.9,0.9,0.9);
	end
	
	return frame
end

function RatingSummary_CreateMainFrame()
	--talent Frame
	local frame = RatingSummary_CreateFrame("RatingSummaryTalent", InspectPaperDollFrame, 110, 56, 2, 32, 0);
	frame:SetFrameLevel(3);
	frame:SetPoint("TOPLEFT", InspectPaperDollFrame, "TOPLEFT", 168, -260);
	frame.icon1 = frame:CreateTexture(nil, "BORDER");
	frame.icon1:SetWidth(24) frame.icon1:SetHeight(24);
	frame.icon1:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark");
	frame.icon1:SetPoint("TOPLEFT", frame.title, "BOTTOMLEFT", 2, -4);
	frame.title:SetText(RATING_SUMMARY_TALENT);
	frame.text2:SetTextColor(0.9,0.9,0.9);

	--pvp Frame
	frame = RatingSummary_CreateFrame("RatingSummaryPVP", InspectPaperDollFrame, 110, 68, 3, 2);
	frame:SetFrameLevel(3);
	frame:SetPoint("TOPLEFT", RatingSummaryTalent, "BOTTOMLEFT", 0, 2);
	frame.title:SetText("PvP:");
	
	--resistance	
	frame = CreateFrame("Frame", "RatingSummaryRES", InspectPaperDollFrame);
	frame:SetFrameLevel(3);
	frame:SetWidth(40); frame:SetHeight(1);
	frame:SetPoint("TOPRIGHT", InspectPaperDollFrame, "TOPLEFT", 282, -77);
	local texture = "Interface\\PaperDollInfoFrame\\UI-Character-ResistanceIcons"
	local TexCoords = {
		"0|1|0.2265625|0.33984375",
		"0|1|0|0.11328125",
		"0|1|0.11328125|0.2265625",
		"0|1|0.33984375|0.453125",
		"0|1|0.453125|0.56640625",}	
	local tooltip = {6, 2, 3, 4, 5};
	local formatText = string.gsub(RATING_SUMMARY_RESISTANCE_TOOLTIP_SUBTEXT, "\n.+", "");
	
	for i = 1, 5 do
		frame["button"..i] = RatingSummary_CreateButton("RatingSummaryRESbutton"..i, frame, 20, 20, texture, TexCoords[i])
		frame["button"..i].tooltip = getglobal("RESISTANCE" .. tooltip[i] .. "_NAME");
		frame["button"..i].tooltipSubtext = format(formatText, _G["RESISTANCE_TYPE" .. tooltip[i]]);
		frame["button"..i]:SetPoint("TOPRIGHT", _G["RatingSummaryRESbutton" .. (i - 1)] or frame, "BOTTOMRIGHT", 0, -1);
	end
	--base effect
	frame = RatingSummary_CreateFrame("RatingSummaryBase", InspectPaperDollFrame, 110, 122, 7, 4)
	frame:SetFrameLevel(3);
	frame:SetPoint("TOPLEFT", InspectPaperDollFrame, "TOPLEFT", 57, -260)
	frame.title:SetText(RATING_SUMMARY_BASE)

	InspectModelFrame:SetHeight(200);

	-- refresh button
	--[[
	local button = CreateFrame("Button", "RatingSummaryRefreshButton", InspectPaperDollFrame, "UIPanelButtonTemplate");
	button:SetWidth(60);
	button:SetHeight(25);
	button:SetText("刷 新");
	button:SetPoint("TOPRIGHT", InspectFrame, "TOPRIGHT", -40, -36);
	button:SetScript("OnClick", function()
		local unit = InspectFrame.unit or "target";
		if (CheckInteractDistance(unit, 1) and CanInspect(unit)) then
			InspectUnit(unit);
		end		
	end);
	button:SetScript("OnEnter", function(self)
		GameTooltip_SetDefaultAnchor(GameTooltip, self);
		GameTooltip:SetText("无法看到装备宝石时点击刷新", 1, 1, 1);
		GameTooltip:Show();
	end);
	button:SetScript("OnLeave", function(self)		
		GameTooltip:Hide();
	end);
	]]
end

dwAsynCall("Blizzard_InspectUI", "RatingSummary_CreateMainFrame");

function RatingSummary_UpdateTalentFrame()
	--[[
	local id, name, iconTexture, point, point1, point2, point3
	point1 = select(5, GetSpecializationInfo(1,true,nil,GetActiveSpecGroup(true)));
	point2 = select(5, GetSpecializationInfo(2,true,nil,GetActiveSpecGroup(true)));
	point3 = select(5, GetSpecializationInfo(3,true,nil,GetActiveSpecGroup(true)));
	point = max(point1, point2, point3);
	if point == point1 then
		id, name, _, iconTexture = GetSpecializationInfo(1,true,nil,GetActiveSpecGroup(true));
	elseif point == point2 then
		id, name, _, iconTexture = GetSpecializationInfo(2,true,nil,GetActiveSpecGroup(true));
	elseif point == point3 then
		id, name, _, iconTexture = GetSpecializationInfo(3,true,nil,GetActiveSpecGroup(true));
	end
	]]
	local _, name, _, icon, _,style = GetSpecializationInfoByID(GetInspectSpecialization("target"))
	if (name and icon) then
		local frame = RatingSummaryTalent;
		frame.text1:SetText(name);
		--frame.text2:SetFormattedText("|cff00ff00%s|r", style and _G[style] or NONE);
		frame.text2:SetFormattedText("%s", style and _G[style] or NONE);
		frame.icon1:SetTexture(icon);
	end	
end

function RatingSummary_ClearPVPFrame()
	local frame = RatingSummaryPVP
	frame.text1:SetFormattedText("%s |cffFFFFFF%s|r |cff666666%s|r", "2v2", "-", "-")
	frame.text2:SetFormattedText("%s |cffFFFFFF%s|r |cff666666%s|r", "3v3", "-", "-")
	frame.text3:SetFormattedText("%s |cffFFFFFF%s|r |cff666666%s|r", "5v5", "-", "-")
	if ( not HasInspectHonorData() ) then
		RequestInspectHonorData()
	else
		RatingSummary_OnEvent(nil, "INSPECT_HONOR_UPDATE");	
	end
end

function RatingSummary_UpdateMainFrame(sum)
	local frame;	

	RatingSummary_ClearPVPFrame();

	frame = RatingSummaryRES;
	frame.button1.text:SetText(sum["ARCANE_RES"] or 0);
	frame.button2.text:SetText(sum["FIRE_RES"] or 0);
	frame.button3.text:SetText(sum["NATURE_RES"] or 0);
	frame.button4.text:SetText(sum["FROST_RES"] or 0);
	frame.button5.text:SetText(sum["SHADOW_RES"] or 0);
	
	frame = RatingSummaryBase
	frame.text1:SetText(RATING_SUMMARY_STRENGTH);
	frame.text2:SetText(RATING_SUMMARY_AGILITY);
	frame.text3:SetText(RATING_SUMMARY_STAMINA);
	frame.text4:SetText(RATING_SUMMARY_INTELLECT);
	frame.text5:SetText(RATING_SUMMARY_SPIRIT);
	frame.text6:SetText(RATING_SUMMARY_RESILIENCE);
	frame.text7:SetText(RATING_SUMMARY_ARMOR);

	frame.stat1:SetText(sum["STR"] or 0);
	frame.stat2:SetText(sum["AGI"] or 0);
	frame.stat3:SetText(sum["STA"] or 0);
	frame.stat4:SetText(sum["INT"] or 0);
	frame.stat5:SetText(sum["SPI"] or 0);
	frame.stat6:SetText(sum["RESILIENCE_RATING"] or 0);
	frame.stat7:SetText(sum["ARMOR"] or 0);
end

function RatingSummary_UpdateAnchor(doll, insp, gear)
	if not doll then 
		doll = PaperDollFrame:IsVisible() 
	elseif doll<0 then 
		doll = nil 
	end
	if not insp then 
		insp = InspectFrame and InspectFrame:IsVisible() 
	elseif 	insp<0 then 
		insp = nil 
	end

	local at, ax, ay = nil, 0, 0
	if(doll) then
		at = PaperDollFrame; ax=OFFSET_X; ay=OFFSET_Y
	elseif(insp) then
		at = InspectFrame; ax=OFFSET_X; ay=OFFSET_Y
	end
		
	local af = nil;
	if RatingSummaryTargetFrame:IsVisible() then
		RatingSummarySelfFrame:ClearAllPoints()
		RatingSummarySelfFrame:SetPoint("TOPLEFT", RatingSummaryTargetFrame, "TOPRIGHT", 0, 0)
		af = RatingSummaryTargetFrame
	elseif RatingSummarySelfFrame:IsVisible() then
		af = RatingSummarySelfFrame
	end

	if(at and af) then
		af:ClearAllPoints();
		af:SetPoint("TOPLEFT", at, "TOPRIGHT", ax, ay)
	end
end

function RatingSummary_OnEvent(self, event, ...)
	local arg1, arg2, arg3 = ...;
	
	if (event == "INSPECT_HONOR_UPDATE") then
		local frame = RatingSummaryPVP
		for i = 1, MAX_ARENA_TEAMS do
			local _, teamSize, teamRating, _, _, _, playerRating = GetInspectArenaTeamData(i)
			if teamSize == 2 then
				frame.text1:SetFormattedText("%s |cffFFFFFF%s|r |cff666666%s|r", "2v2", teamRating, playerRating)
			elseif teamSize == 3 then
				frame.text2:SetFormattedText("%s |cffFFFFFF%s|r |cff666666%s|r", "3v3", teamRating, playerRating)
			elseif teamSize == 5 then
				frame.text3:SetFormattedText("%s |cffFFFFFF%s|r |cff666666%s|r", "5v5", teamRating, playerRating)
			end
		end
	end

	if event == "ADDON_LOADED" then
		if (arg1 == "Blizzard_InspectUI") then
			RatingSummary_SetupHook();
		elseif (arg1 == "RatingSummary") then
			RatingSummarySelfFrame:SetScale(0.90)
			RatingSummaryTargetFrame:SetScale(0.90)

			SetOrHookScript(PaperDollFrame, "OnShow", RatingSummary_PaperDollFrame_OnShow);
			SetOrHookScript(PaperDollFrame, "OnHide", RatingSummary_PaperDollFrame_OnHide);
			--SetOrHookScript(GearManagerDialog, "OnShow", function() RatingSummary_UpdateAnchor(nil, nil, 1) end)
			--SetOrHookScript(GearManagerDialog, "OnHide", function() RatingSummary_UpdateAnchor(nil, nil, -1) end)
			
			-- 如果系统的观察窗口已经启用
			if (IsAddOnLoaded("Blizzard_InspectUI")) then
				RatingSummary_SetupHook();
			end
		end		
	end

	if  event == "UNIT_INVENTORY_CHANGED" then
		if ((arg1 == "player") and RatingSummarySelfFrame:IsVisible()) then
			RatingSummary_HideFrame(RatingSummarySelfFrame);
			if (RatingSummaryTargetFrame:IsVisible()) then
				RatingSummary_ShowFrame(RatingSummarySelfFrame,RatingSummaryTargetFrame,UnitName("player"),tiptext,0,0);
			else
				RatingSummary_ShowFrame(RatingSummarySelfFrame,PaperDollFrame,UnitName("player"),tiptext,OFFSET_X,OFFSET_Y);
			end
		elseif ( InspectFrame and InspectFrame:IsVisible() and arg1 == InspectFrame.unit and RatingSummaryTargetFrame:IsVisible()) then
			RatingSummary_HideFrame(RatingSummaryTargetFrame);
			RatingSummary_ShowFrame(RatingSummaryTargetFrame,InspectFrame,UnitName(InspectFrame.unit),tiptext,OFFSET_X,OFFSET_Y);
			RatingSummary_ShowFrame(RatingSummarySelfFrame,RatingSummaryTargetFrame,UnitName("player"),tiptext,0,0);
		end
	end
end

function RatingSummary_PaperDollFrame_OnShow()
	if not InspectFrame or not InspectFrame:IsVisible() then
		--RatingSummary_ShowFrame(RatingSummarySelfFrame,PaperDollFrame,UnitName("player"),tiptext,OFFSET_X,OFFSET_Y);
	end
	RatingSummary_UpdateAnchor(1)
end

function RatingSummary_PaperDollFrame_OnHide()
	if not InspectFrame or not InspectFrame:IsVisible() then
		RatingSummary_HideFrame(RatingSummarySelfFrame);
	end
	RatingSummary_UpdateAnchor(-1)
end

function RatingSummary_InspectFrame_SetGuild(self)
	if InspectLess:IsDone() and InspectLess:GetGUID()==UnitGUID(self.unit) then
		RatingSummary_InspectReady()
	end
	local guild, level, levelid = GetGuildInfo(self.unit)
	if(guild) then 
		InspectTitleText:Show();
		InspectTitleText:SetText("<"..guild.."> "..level); 
	else
		InspectTitleText:SetText("");
	end
end

function RatingSummary_InspectReady()
	if(not InspectFrame or not InspectFrame:IsVisible() or not RatingSummaryEnable) then return end;
	RatingSummary_ShowFrame(RatingSummaryTargetFrame,InspectFrame,UnitName(InspectFrame.unit),tiptext,OFFSET_X,OFFSET_Y);
	RatingSummary_ShowFrame(RatingSummarySelfFrame,RatingSummaryTargetFrame,UnitName("player"),tiptext,0,0);
	RatingSummary_UpdateAnchor(nil, 1, nil)

	local frame = RatingSummaryTargetFrame;
	RatingSummary_UpdateTalentFrame();
	if frame:IsVisible() and not frame.talented then
		local tiptext = getglobal(frame:GetName().."Text"):GetText();
		--tiptext = tiptext.."\n\n"..RatingSummary_GetTalentString(true, 1)..RatingSummary_GetTalentString(true, 2)
		--RatingSummary_SetFrameText(frame, nil, tiptext);
		frame.talented = true;
	end
end

function RatingSummary_InspectFrame_OnHide()
	RatingSummary_HideFrame(RatingSummaryTargetFrame);
	RatingSummary_HideFrame(RatingSummarySelfFrame);
	RatingSummary_UpdateAnchor(nil, -1, nil)
end

function RatingSummary_InspectFrame_UnitChanged()
	if ( InspectFrame and InspectFrame:IsVisible() and RatingSummaryTargetFrame:IsVisible()) then
		RatingSummary_HideFrame(RatingSummaryTargetFrame);
		RatingSummary_ShowFrame(RatingSummaryTargetFrame,InspectFrame,UnitName(InspectFrame.unit),tiptext,OFFSET_X,OFFSET_Y);
		RatingSummary_ShowFrame(RatingSummarySelfFrame,RatingSummaryTargetFrame,UnitName("player"),tiptext,0,0);
	end
end

function RatingSummary_GetTalentString(isInspecting, idx) 
	if(idx==2 and GetNumSpecGroups(isInspecting)==1) then
		return "";
	end
	local talentString = "";
	local main = "";
	local max = 0;
	local isMain = (GetActiveSpecGroup(isInspecting) == idx)

	for v = 1,3 do
		local id, tn, description, iconTexture, num, background, previewPointsSpent, isUnlocked = GetSpecializationInfo(v, isInspecting, false, idx)
		if num > max then
			max = num;
			main = tn;
		end
		if #talentString > 0 then talentString = talentString.."/"; end
		talentString = talentString..num;
	end

	if(isMain) then
		return (idx==2 and "\n" or "")..TALENTS..":"..NORMAL_FONT_COLOR_CODE..main..FONT_COLOR_CODE_CLOSE..GREEN_FONT_COLOR_CODE.."("..talentString..")"..FONT_COLOR_CODE_CLOSE;
	else
		return (idx==2 and "\n" or "")..GRAY_FONT_COLOR_CODE..TALENTS..":"..main.."("..talentString..")"..FONT_COLOR_CODE_CLOSE;
	end
end

function RatingSummary_SetFrameText(frame, tiptitle, tiptext)

	local text = getglobal(frame:GetName().."Text");
	local title = getglobal(frame:GetName().."Title");

	if(tiptitle) then title:SetText(tiptitle); end

	text:SetText(tiptext);
	height = text:GetHeight();
	width = text:GetWidth();
	if(width < title:GetWidth()) then
		width = title:GetWidth();
	end
	frame:SetHeight(height+30);
	frame:SetWidth(width+2);
end

function RatingSummary_ShowFrame(frame,target,tiptitle,tiptext,anchorx,anchory)
	local unit = "player";
	if(RatingSummaryTargetFrame == frame) then
		if(InspectFrame.unit) then
			unit = InspectFrame.unit;
		else
			return;
		end
	end
	local sum = RatingSummary_Sum(not (unit == "player") );
	local _, uc = UnitClass(unit)
	local _, ur = UnitRace(unit)
	local ul = UnitLevel(unit)

	--DevTools_Dump(sum);
	tiptext = "";

	if (InspectFrame and unit == InspectFrame.unit) then
		RatingSummary_UpdateMainFrame(sum);
	end	

	local cat, v;
	for _, cat in pairs(RatingSummary_CLASS_STAT[uc]) do
		local catStr = "";
		for _, stat in pairs(RatingSummary_STAT[cat]) do
			--ChatFrame1:AddMessage(stat);
			local func = RatingSummary_Calc[stat]
			local s1,s2,s3,s4;
			if not func then
				s1 = sum[stat] or 0
			else
				s1,s2,s3,s4 = func(sum, stat, sum[stat] or 0, uc, ul) 
			end

			local ff = RatingSummary_FORMAT[stat] or GREEN_FONT_COLOR_CODE.."%d"..FONT_COLOR_CODE_CLOSE;
			if(type(s1)~="number") then 
				ChatFrame1:AddMessage(stat..":"..tostring(s1))
			elseif(s1 and s1>0) then
				local _, sname = StatLogic:GetStatNameFromID(stat);
				if stat=="TOTAL_AVOID" then
					sname = RATING_SUMMARY_TOTAL_AVOID
				elseif not sname then
					sname = stat;
				else
					sname = string.gsub(sname, "%(%%%)", "");
					sname = string.gsub(sname, "%%", "%%%%");
				end
				sname = NORMAL_FONT_COLOR_CODE..sname..":"..FONT_COLOR_CODE_CLOSE;

				ff = sname..ff;
				catStr = catStr.."\n"..format(ff, s1, s2, s3, s4)
				--ChatFrame1:AddMessage(format(ff, s1, s2, s3, s4))	
			end
		
		end
		if catStr ~="" then
			if tiptext ~= "" then tiptext = tiptext.."\n"; end
			tiptext = tiptext.."\n"..HIGHLIGHT_FONT_COLOR_CODE..(WB_STATS_CAT[cat] or cat)..":"..FONT_COLOR_CODE_CLOSE;
			tiptext = tiptext..catStr;
		end
	end

	--item levels
	if tiptext ~= "" then tiptext = tiptext.."\n"; end
	tiptext = tiptext.."\n"..HIGHLIGHT_FONT_COLOR_CODE..RATING_SUMMARY_ITEM_LEVEL_TITLE..":"..FONT_COLOR_CODE_CLOSE;
	for v = 7, 2, -1 do
		if(sum["ITEMCOUNT"..v]) then
			local _,_,_,colorCode = GetItemQualityColor(v)
			tiptext = tiptext.."\n|c"..format(colorCode.."%s "..RATING_SUMMARY_ITEM_LEVEL_FORMAT.."|r", RATING_SUMMARY_ITEM_QUANLITY_NAME[v], sum["ITEMCOUNT"..v], sum["ITEMLEVEL"..v]/sum["ITEMCOUNT"..v])
		end
	end

	--talent
	--[[
	if unit=="player" then
		tiptext = tiptext.."\n\n"..RatingSummary_GetTalentString(false, 1)..RatingSummary_GetTalentString(false, 2);
	else
		frame.talented=false;
	end
	]]

	RatingSummary_SetFrameText(frame, tiptitle, tiptext);

	frame:Show();
end

function RatingSummary_HideFrame(frame)
	frame:Hide();
end

function RatingSummary_Sum(inspecting, tipUnit)
	local slotID;
	--[[ 0 = ammo 1 = head 2 = neck 3 = shoulder 4 = shirt 5 = chest 6 = belt 7 = legs 8 = feet 9 = wrist 10 = gloves 11 = finger 1 12 = finger 2 13 = trinket 1 14 = trinket 2 15 = back 16 = main hand 17 = off hand 18 = ranged 19 = tabard ]]--

	local unit = "player";
	if(inspecting) then unit=InspectFrame.unit end
	if(tipUnit) then unit=tipUnit end
	local _, uc = UnitClass(unit)
	local _, ur = UnitRace(unit)
	local ul = UnitLevel(unit)


	local sum = {};

	for i=1, 17 ,1 do
		if i~=4 then
			local slotButton, slotBorder;
			if(not tipUnit) then
				slotButton = getglobal( (inspecting and "Inspect" or "Character")..slots[i].."Slot");
				slotBorder = getglobal(slotButton:GetName()):GetNormalTexture();
--[[
				slotBorder = getglobal(slotButton:GetName().."Border");
				if(not slotBorder) then
					slotBorder = slotButton:CreateTexture(slotButton:GetName().."Border","OVERLAY");
					slotBorder:SetTexture("Interface\\Buttons\\UI-ActionButton-Border");
					slotBorder:SetPoint("CENTER");
					slotBorder:SetBlendMode("ADD");
					slotBorder:SetAlpha(0.5);
					slotBorder:SetHeight(70);
					slotBorder:SetWidth(70);
					slotBorder:Hide();
				end
]]
			end

			local link = GetInventoryItemLink(unit, i);
			--if inspecting then ChatFrame1:AddMessage(slots[i].." "..(link or "nil")); end
			if (link) then
				local _, _, quality, iLevel = GetItemInfo(link);
				if(slotBorder) then slotBorder:SetVertexColor(GetItemQualityColor(quality)) end
				--slotBorder:Show();

				--[[# 2 - Uncommon # 3 - Rare # 4 - Epic # 5 - Legendary # 7 Account]]
				if(quality >=2 and quality <=7) then
					sum["ITEMCOUNT"..quality] = (sum["ITEMCOUNT"..quality] or 0) + 1;
					sum["ITEMLEVEL"..quality] = (sum["ITEMLEVEL"..quality] or 0) + iLevel; 
				end

				local itemStat = StatLogic:GetSum(link);

				for k,v in pairs(itemStat) do
					if(k~="itemType" and k~="link") then --if(type(v)=="number") then
						if(not sum[k]) then sum[k] = 0 end
						sum[k] = sum[k] + v;
					end
				end
			else
				if(slotBorder) then slotBorder:SetVertexColor(GetItemQualityColor(1,1,1,1)) end
				--slotBorder:Hide();
			end
		end
	end

	return sum;
end

WB_STATS_CAT = {
	BASE = PLAYERSTAT_BASE_STATS,
	MELEE = PLAYERSTAT_MELEE_COMBAT,
	RANGED = PLAYERSTAT_RANGED_COMBAT,
	TANK = PLAYERSTAT_DEFENSES,
	SPELL = PLAYERSTAT_SPELL_COMBAT,
	OTHER = RATING_SUMMARY_OTHER,
}

RatingSummary_STAT = {
	BASE = { "ARMOR", "STR", "AGI", "STA", "INT", "SPI", "MASTERY_RATING", },
	MELEE = { "AP", "FERAL_AP", "MELEE_HIT", "MELEE_CRIT", "MELEE_HASTE", "EXPERTISE_RATING",  },
	RANGED = { "RANGED_AP", "RANGED_HIT", "RANGED_CRIT", "RANGED_HASTE", },
	TANK = { "DEFENSE", "DODGE", "PARRY", "BLOCK", "BLOCK_VALUE", "TOTAL_AVOID" },
	SPELL = { "SPELL_DMG", "SPELL_HIT", "SPELL_CRIT", "SPELL_HASTE", "SPELLPEN", "MANA_REG",  },
	OTHER = { "RESILIENCE_RATING", "ARMOR_PENETRATION", "ARCANE_RES", "FIRE_RES", "NATURE_RES", "FROST_RES", "SHADOW_RES" }
}

RatingSummary_CLASS_STAT = {
	HUNTER = { "BASE", "MELEE", "RANGED", "OTHER" },
	ROGUE = { "BASE", "MELEE", "OTHER" },
	WARRIOR = { "BASE", "MELEE", "TANK", "OTHER" },
	DEATHKNIGHT = { "BASE", "MELEE", "TANK", "OTHER" },
	DRUID = { "BASE", "MELEE", "TANK", "SPELL", "OTHER" },
	PALADIN = { "BASE", "MELEE", "TANK", "SPELL", "OTHER" },
	SHAMAN = { "BASE", "MELEE", "SPELL", "OTHER" },
	WARLOCK = { "BASE", "SPELL", "OTHER" },
	PRIEST = { "BASE", "SPELL", "OTHER" },
	MAGE = { "BASE", "SPELL", "OTHER" },
	MONK = { "BASE", "MELEE", "TANK", "OTHER" },
}

local ratingToEffect = function(sum, stat, val, class, level) val = sum[stat.."_RATING"] or 0; val=StatLogic:GetEffectFromRating( val, stat.."_RATING", level ) return val, sum[stat.."_RATING"] or 0 end

local SL = StatLogic;
RatingSummary_Calc = {
	STR = nil,
	AGI = function(sum, stat, val, class, level) return val, SL:GetCritFromAgi(val, class, level) end,
	STA = nil,
	INT = function(sum, stat, val, class, level) return val, SL:GetSpellCritFromInt(val, class, level) end,
	SPI = function(sum, stat, val, class, level) return val, SL:GetNormalManaRegenFromSpi(val) end,

	MASTERY_RATING = function(sum, stat, val, class, level) local e = SL:GetEffectFromRating( val, stat, level ); return e,val end,

	AP = function(sum, stat, val, class, level) return val + SL:GetAPFromAgi(sum["AGI"] or 0, class) + SL:GetAPFromStr(sum["STR"] or 0, class), val end,
	FERAL_AP = nil,
	MELEE_HIT = ratingToEffect,
	MELEE_CRIT = function(sum, stat, val, class, level) val=sum[stat.."_RATING"] or 0 local e = SL:GetEffectFromRating( val, stat.."_RATING", level ) return --[[e,]] e + SL:GetCritFromAgi(sum["AGI"] or 0, class, level), val end,
	MELEE_HASTE = ratingToEffect,
	EXPERTISE_RATING = function(sum, stat, val, class, level) local e = SL:GetEffectFromRating( val, stat, level ); return e,val  end,
	ARMOR_PENETRATION = ratingToEffect,

	RANGED_AP = function(sum, stat, val, class, level) return val + (sum["AP"] or 0) + SL:GetRAPFromAgi(sum["AGI"] or 0, class),val end,
	RANGED_HIT = ratingToEffect,
	RANGED_CRIT = function(sum, stat, val, class, level) val=sum[stat.."_RATING"] or 0 local e = SL:GetEffectFromRating((sum["MELEE_CRIT_RATING"] or 0), "MELEE_CRIT_RATING", level) + SL:GetEffectFromRating( val, stat.."_RATING", level ) return --[[e,]] e + SL:GetCritFromAgi(sum["AGI"] or 0, class, level), val end,
	RANGED_HASTE = ratingToEffect,

	ARMOR = function(sum, stat, val, class, level) return (sum["ARMOR"] or 0), (sum["ARMOR_BONUS"] or 0) end,
	DEFENSE = function(sum, stat, val, class, level) 
			local e = SL:GetEffectFromRating( sum[stat.."_RATING"] or 0, stat.."_RATING", level ); 
			if(e>0) then return e+level*5,e*0.04 else return 0 end
		end,
	DODGE = ratingToEffect,
	PARRY = ratingToEffect,
	BLOCK = ratingToEffect,
	BLOCK_VALUE = nil,
	TOTAL_AVOID = function(sum, stat, val, class, level) 
			local dr = SL:GetEffectFromRating( sum["DEFENSE_RATING"] or 0, "DEFENSE_RATING", level ) * 0.04
			local parry = SL:GetEffectFromRating( sum["PARRY_RATING"] or 0, "PARRY_RATING", level ) + dr
			local dodge = SL:GetEffectFromRating( sum["DODGE_RATING"] or 0, "DODGE_RATING", level ) + dr
			local block = SL:GetEffectFromRating( sum["BLOCK_RATING"] or 0, "BLOCK_RATING", level ) + dr
			--local missing = 5 - 0.6 + dr
			local hasParry = (class=="WARRIOR" or class=="PALADIN" or class=="SHAMAN" or class=="ROGUE" or class=="HUNTER" or class=="DEATHKNIGHT")
			local hasBlock = (class=="WARRIOR" or class=="PALADIN" or class=="SHAMAN")
			if(not hasParry and not hasBlock) then return 0 end
			return (hasParry and parry or 0) + dodge, (hasBlock and block or 0);
		end,
	RESILIENCE_RATING = function(sum, stat, val, class, level) local e = SL:GetEffectFromRating( val, stat, level ); return e,val end,

	SPELL_DMG = nil,
	HEAL = nil,
	SPELL_HIT = ratingToEffect,
	SPELL_CRIT = function(sum, stat, val, class, level) val=sum[stat.."_RATING"] or 0 local e = SL:GetEffectFromRating( val, stat.."_RATING", level ) return --[[e,]] e + SL:GetSpellCritFromInt(sum["INT"] or 0, class, level), val end,
	SPELL_HASTE = ratingToEffect,
	SPELLPEN = nil, 
	MANA_REG = nil
}

local FI = "%d";
local FP = "%.2f%%";
local FL = "%.1f";
local FR = GREEN_FONT_COLOR_CODE..FP..FONT_COLOR_CODE_CLOSE.."("..FI..")";
local CFI = GREEN_FONT_COLOR_CODE..FI..FONT_COLOR_CODE_CLOSE
local BFI = GREEN_FONT_COLOR_CODE.."%d"..FONT_COLOR_CODE_CLOSE
local FCRI = GREEN_FONT_COLOR_CODE..FP..FONT_COLOR_CODE_CLOSE.."("..FI..")";

RatingSummary_FORMAT = {
	STR = BFI,
	AGI = BFI.."("..NORMAL_FONT_COLOR_CODE..RATING_SUMMARY_MELEE_CRIT..FONT_COLOR_CODE_CLOSE.."%.2f%%"..")",
	STA = BFI,
	INT = BFI.."("..NORMAL_FONT_COLOR_CODE..RATING_SUMMARY_SPELL_CRIT..FONT_COLOR_CODE_CLOSE.."%.2f%%"..")",
	SPI = BFI.."("..NORMAL_FONT_COLOR_CODE..RATING_SUMMARY_MANA_REGEN..FONT_COLOR_CODE_CLOSE..FI..")",

	MASTERY_RATING = GREEN_FONT_COLOR_CODE.."%.2f"..FONT_COLOR_CODE_CLOSE.."("..FI..")",

	AP = CFI.."("..FI..")",
	FERAL_AP = CFI,
	MELEE_HIT = FR,
	MELEE_CRIT = FCRI,
	MELEE_HASTE = FR,
	EXPERTISE_RATING = GREEN_FONT_COLOR_CODE.."%.1f"..FONT_COLOR_CODE_CLOSE.."("..FI..")",
	ARMOR_PENETRATION = FR,

	RANGED_AP = CFI.."("..FI..")",
	RANGED_HIT = FR,
	RANGED_CRIT = FCRI,
	RANGED_HASTE = FR,

	ARMOR = CFI,
	DEFENSE = ""..CFI.."("..FP..")",
	DODGE = FR,
	PARRY = FR,
	BLOCK = FR,
	BLOCK_VALUE = CFI,
	TOTAL_AVOID = GREEN_FONT_COLOR_CODE..FP..FONT_COLOR_CODE_CLOSE.."(".."%.1f%%"..")",
	RESILIENCE_RATING = FR,

	SPELL_DMG = CFI,
	HEAL = CFI,
	SPELL_HIT = FR,
	SPELL_CRIT = FCRI,
	SPELL_HASTE = FR,
	SPELLPEN = CFI, 
	MANA_REG = CFI.."/MP5",
}