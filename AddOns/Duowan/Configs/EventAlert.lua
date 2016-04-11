------------------------------------
-- dugu 2009-12-22

if (GetLocale() == "zhCN") then
	EVENTALERT_TITLE = "技能触发";
	EVENTALERT_ENABLED = "开启技能触发指示器" .. DUOWAN_COLOR["STEELBLUE"] .. " (EventAlertMod)" .. DUOWAN_COLOR["END"];
	EVENTALERT_LOCKFRAME = "锁定指示器图标位置";
	EVENTALERT_OPTION_DESC = "更多设置";
	EVENTALERT_SPELLALERT_DISABLED = "禁用系统中央法术触发报警";
	EVENTALTER_DISPLAY_SPELLID = "在技能和Buff上显示法术ID";
elseif (GetLocale() == "zhTW") then
	EVENTALERT_TITLE = "技能觸發";
	EVENTALERT_ENABLED = "開啟技能觸發指示器" .. DUOWAN_COLOR["STEELBLUE"] .. " (EventAlertMod)" .. DUOWAN_COLOR["END"];
	EVENTALERT_LOCKFRAME = "鎖定指示器圖標位置";
	EVENTALERT_OPTION_DESC = "更多設置";
	EVENTALERT_SPELLALERT_DISABLED = "禁用系統中央法術觸發報警";
	EVENTALTER_DISPLAY_SPELLID = "在技能和Buff上顯示法術ID";
else
	EVENTALERT_TITLE = "技能触发";
	EVENTALERT_ENABLED = "开启技能触发指示器" .. DUOWAN_COLOR["STEELBLUE"] .. " (EventAlertMod)" .. DUOWAN_COLOR["END"];
	EVENTALERT_LOCKFRAME = "锁定指示器图标位置";
	EVENTALERT_OPTION_DESC = "更多设置";
	EVENTALERT_SPELLALERT_DISABLED = "禁用系统中央法术触发报警";
	EVENTALTER_DISPLAY_SPELLID = "在技能和Buff上显示法术ID";
end
dwRegisterMod(
	"EventAlertHistry",
	EVENTALERT_TITLE,
	"EventAlert",
	"",
	"Interface\\ICONS\\Spell_Holy_SummonLightwell",
	nil
);

if (dwIsConfigurableAddOn("EventAlertMod")) then
	dwRegisterCheckButton(
		"EventAlertHistry",
		EVENTALERT_ENABLED,
		nil,		
		"EVENTALERT_ENABLED", --"EventAlertEnable",
		1,
		function (arg)
			if(arg==1)then				
				if (not dwIsAddOnLoaded("EventAlertMod")) then
					dwLoadAddOn("EventAlertMod");
				end
				EventAlert_Toggle(true);
			else
				if (dwIsAddOnLoaded("EventAlertMod")) then
					EventAlert_Toggle(false)	;
				end				
			end
		end
	);
	
	dwRegisterCheckButton(
		"EventAlertHistry",
		EVENTALERT_LOCKFRAME,
		nil,
		"EVENTALERT_LOCKFRAME",
		1,
		function (arg)
			if(arg==1)then				
				if (dwIsAddOnLoaded("EventAlertMod")) then
					EventAlert_ToggleAlertFrameLock(true);
				end	
			else
				if (dwIsAddOnLoaded("EventAlertMod")) then
					EventAlert_ToggleAlertFrameLock(false);
				end				
			end
		end,
		1
	);

	dwRegisterCheckButton(
		"EventAlertHistry",
		EVENTALTER_DISPLAY_SPELLID,
		nil,
		"displaySpellID",
		1,
		function (arg)
			if(arg==1)then				
				if (dwIsAddOnLoaded("EventAlertMod")) then
					EventAlterModSpellID_Toggle(true);
				end	
			else
				if (dwIsAddOnLoaded("EventAlertMod")) then
					EventAlterModSpellID_Toggle(false);
				end				
			end
		end,
		1
	);	
	
	dwRegisterButton(
		"EventAlertHistry",
		EVENTALERT_OPTION_DESC, 
		function()
			if (dwIsAddOnLoaded("EventAlertMod")) then
				ShowUIPanel(EA_Options_Frame);
			end
		end, 
		1
	);	
end

do
local defaultValue = GetCVar("displaySpellActivationOverlays") == "1" and 1 or 0;
dwRegisterCheckButton(
	"EventAlertHistry",
	EVENTALERT_SPELLALERT_DISABLED,
	nil,
	"SpellAlertsDisable",
	defaultValue,
	function (arg)
		if(arg==1)then
			if (GetCVar("displaySpellActivationOverlays") == "1") then
				SetCVar("displaySpellActivationOverlays", "0");
			end
		else
			if (GetCVar("displaySpellActivationOverlays") == "0") then
				SetCVar("displaySpellActivationOverlays", "1");
			end			
		end
	end
);
InterfaceOptionsCombatPanelShowSpellAlerts:SetScript("PostClick", function(self)
	if (self:GetChecked()) then
		dwSetCVar("EventAlertHistry", "SpellAlertsDisable", 0);
	else
		dwSetCVar("EventAlertHistry", "SpellAlertsDisable", 1);
	end
end);
end