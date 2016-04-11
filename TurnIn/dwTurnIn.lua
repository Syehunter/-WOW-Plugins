
local switchbtns = {};
local L = TURNIN_LOCALIZATION_INFO;
---------------------------------
-- 是否启用自动交接任务
local function isTurnInEnable()
	return dwRawGetCVar("QuestMod", "EnableTurnIn", 0) == 1 and true or false;
end

---------------------------------
-- 创建开关按钮
local function CreateTurnInSwitch(name, parent, x, y)	
	local checkbox = _G[name];
	if (not checkbox) then
		checkbox = CreateFrame("CheckButton", name, parent, "dwCheckButtonTemplate");
		checkbox:SetSize(24, 24);
		checkbox.text:SetText(L["turn in title"]);		
		checkbox:SetScript("OnClick", function(this, button)
			dwTurnIn_Toggle(not isTurnInEnable());
		end);
		checkbox.hitArea:SetScript("OnEnter", function(this, button)
			checkbox.text:SetTextColor(1, 1, 1);
			GameTooltip:SetOwner(this, "ANCHOR_RIGHT", -180, 0);		
			GameTooltip:SetText(L["turn in title"]);
			GameTooltip:AddLine(L["turn in tooltip"], 1, 1, 1);
			GameTooltip:Show();
		end);
		checkbox.hitArea:SetScript("OnLeave", function(this, button)
			checkbox.text:SetTextColor(1, 0.82, 0);
			GameTooltip:Hide();
		end);
		checkbox.hitArea:SetScript("OnClick", function(this, button)
			this:GetParent():Click();
		end);
		table.insert(switchbtns, checkbox);
	end
	checkbox:ClearAllPoints();
	checkbox:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y);
	return checkbox;
end

--------------------------------
-- 刷新开关的状态
local function UpdateTurnInSwitch()
	local state = isTurnInEnable();
	for k, v in pairs(switchbtns) do
		if (state) then
			v:SetChecked(true);
		else
			v:SetChecked(false);
		end
	end
end

do
	--CreateTurnInSwitch("dwQuestLogTurnInSwitch", QuestLogFrame, 330, -30);
	--CreateTurnInSwitch("dwQuestLogDetailTurnInSwitch", QuestLogDetailFrame, 65, -30);
	CreateTurnInSwitch("dwQuestFrameTurnInSwitch", ObjectiveTrackerFrame, -15, 30);	
end

function dwTurnIn_Toggle(switch)
	if switch then		
		TI_status.state = true;
		TI_status.usedefault = true;
		TI_LoadEvents();
	else
		TI_status.state = false;
		TI_status.usedefault = false;
		TI_UnloadEvents();
		TI_ResetPointers();
	end
	
	dwSetCVar("QuestMod", "EnableTurnIn", switch and 1 or 0);
	TI_StatusIndicatorUpdate();
	UpdateTurnInSwitch();
end

function TI_message(...)

end
