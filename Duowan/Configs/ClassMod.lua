------------------------------------
-- dugu 2009-12-21
local DC = DUOWAN_COLOR;
if (GetLocale() == "zhCN") then
	CLASSMOD_TITLE = "职业辅助";
	CLASSMOD_TOTEMTIMERS_NAME = "图腾助手";
	CLASSMOD_TOTEMTIMERS_ENABLE = "开启图腾助手" .. DUOWAN_COLOR["STEELBLUE"] .. "(TotemTimers)" .. DUOWAN_COLOR["END"];
	CLASSMOD_TOTEMTIMERS_TIMER = "启用图腾动作条" .. DUOWAN_COLOR["STEELBLUE"] .. "(计时器)" .. DUOWAN_COLOR["END"];
	CLASSMOD_TOTEMTIMERS_TRACKER = "启用追踪器" .. DUOWAN_COLOR["STEELBLUE"] .. "(复生、盾和武器特效)" .. DUOWAN_COLOR["END"];
	CLASSMOD_TOTEMTIMERS_ENHANCE = "启用萨满增强冷却计时器";
	CLASSMOD_TOTEMTIMERS_OPTION = "更多设置";
	CLASSMOD_HUNTERMOD_ENABLE = "开启猎人助手";
	CLASSMOD_HUNTERMOD_AUTOSHOT_ENABLE = "开启自动射击条";
	CLASSMOD_HUNTERMOD_AUTOSHOT_LOCK = "锁定自动射击条";
	CLASSMOD_HUNTERMOD_ZFEEDER_ENABLE = "开启猎人喂食按键";	
	CLASSMOD_HUNTERMOD_ASPECTBAR_ENABLE = "开启猎人守护动作条";
	CLASSMOD_HUNTERMOD_AUTOTRACK_ENABLE = "开启自动追踪切换";
	CLASSMOD_HUNTERMOD_ANTIDAZE_ENABLE = "眩晕时提示取消豹守";
	CLASSMOD_HUNTERMOD_MISDIRECTYELL_ENABLE = "开启误导喊话通报";
	CLASSMOD_ROGUEMOD_ASPECTPOSIONBAR_ENABLE = "开启盗贼毒药守护动作条";	
	CLASSMOD_MAGEMOD_TELEPORTBAR_ENABLE = "开启法师传送门动作条";
	CLASSMOD_WARLOCKMOD_PETBAR_ENABLE = "开启术士宠物召唤条";
	CLASSMOD_CLASSBAR_BINDING = "按键绑定";
	CLASSMOD_PALADINMOD_PALLPOWER_ENABLE = "开启圣骑士祝福管理" .. DUOWAN_COLOR["STEELBLUE"] .. " (PallyPower)" .. DUOWAN_COLOR["END"];
	CLASSMOD_RUNFRAME_ENABLE = "开启多玩DK符文条";
	CLASSMOD_RUNFRAME_ALPHA = "没有目标时半透明显示";
	CLASSMOD_ECLIPSEBARFRAME_ENABLE = "开启德鲁伊蚀能条助手";
	CLASSMOD_ECLIPSEBARFRAME_ALPHA = "没有目标时半透明蚀能条";
	CLASSMOD_PALADIN_POWERBAR_ENABLE = "开启多玩圣能条";
	CLASSMOD_PALADIN_POWERBAR_ALPHA = "没有目标时半透明圣能条";
	CLASSMOD_FIVECOMBO_ENABLE = "满星技能高亮提示";
	CLASSMOD_MONK_MOD_ENABLE = "开启武僧术士助手";
	CLASSMOD_MONK_MOD_TANK_ENABLE = "开启武僧坦克增强";
	CLASSMOD_TELEPORTIE_MOD_ENABLE = "开启武僧分身和术士法阵助手";
	CLASSMOD_TELEPORTIE_MOD_TANK_ENABLE = "监视魂体双分和恶魔法阵的距离";
elseif (GetLocale() == "zhTW") then
	CLASSMOD_TITLE = "職業輔助";
	CLASSMOD_TOTEMTIMERS_NAME = "圖騰助手";
	CLASSMOD_TOTEMTIMERS_ENABLE = "開啟圖騰助手" .. DUOWAN_COLOR["STEELBLUE"] .. " (TotemTimers)" .. DUOWAN_COLOR["END"];
	CLASSMOD_TOTEMTIMERS_TIMER = "啟用圖騰動作條" .. DUOWAN_COLOR["STEELBLUE"] .. "(計時器)" .. DUOWAN_COLOR["END"];
	CLASSMOD_TOTEMTIMERS_TRACKER = "啟用追蹤器" .. DUOWAN_COLOR["STEELBLUE"] .. "(複生、盾和武器特效)" .. DUOWAN_COLOR["END"];
	CLASSMOD_TOTEMTIMERS_ENHANCE = "啟用薩滿增強冷卻計時器";
	CLASSMOD_TOTEMTIMERS_OPTION = "更多設置";
	CLASSMOD_HUNTERMOD_ENABLE = "開啟獵人助手";
	CLASSMOD_HUNTERMOD_AUTOSHOT_ENABLE = "開啟自動射擊條";	
	CLASSMOD_HUNTERMOD_AUTOSHOT_LOCK = "鎖定自動射擊條";
	CLASSMOD_HUNTERMOD_ZFEEDER_ENABLE = "開啟獵人餵食按鍵";	
	CLASSMOD_HUNTERMOD_ASPECTBAR_ENABLE = "開啟獵人守護動作條";
	CLASSMOD_HUNTERMOD_AUTOTRACK_ENABLE = "開啟自動追蹤切換";
	CLASSMOD_HUNTERMOD_ANTIDAZE_ENABLE = "眩暈時提示取消豹守";
	CLASSMOD_HUNTERMOD_MISDIRECTYELL_ENABLE = "開啟誤導喊話通報";
	CLASSMOD_ROGUEMOD_ASPECTPOSIONBAR_ENABLE = "開啟盜賊毒藥守護動作條";	
	CLASSMOD_MAGEMOD_TELEPORTBAR_ENABLE = "開啟法師傳送門動作條";
	CLASSMOD_WARLOCKMOD_PETBAR_ENABLE = "開啟術士寵物召喚條";
	CLASSMOD_CLASSBAR_BINDING = "按鍵綁定";
	CLASSMOD_RUNFRAME_ENABLE = "開啟多玩DK符文條";
	CLASSMOD_RUNFRAME_ALPHA = "沒有目標時半透明顯示";
	CLASSMOD_PALADINMOD_PALLPOWER_ENABLE = "開啟聖騎士祝福管理" .. DUOWAN_COLOR["STEELBLUE"] .. " (PallyPower)" .. DUOWAN_COLOR["END"];
	CLASSMOD_ECLIPSEBARFRAME_ENABLE = "開啟德魯伊蝕能條助手";
	CLASSMOD_ECLIPSEBARFRAME_ALPHA = "沒有目標時半透明蝕能條";
	CLASSMOD_PALADIN_POWERBAR_ENABLE = "開啟多玩聖能條";
	CLASSMOD_PALADIN_POWERBAR_ALPHA = "沒有目標時半透明聖能條";
	CLASSMOD_FIVECOMBO_ENABLE = "滿星技能高亮提示";
	CLASSMOD_MONK_MOD_ENABLE = "開啟武僧術士助手";
	CLASSMOD_MONK_MOD_TANK_ENABLE = "開啟武僧坦克增強";
	CLASSMOD_TELEPORTIE_MOD_ENABLE = "開啟武僧分身和術士法陣助手";
	CLASSMOD_TELEPORTIE_MOD_TANK_ENABLE = "監視魂體雙分和惡魔法陣的距離";	
else
	CLASSMOD_TITLE = "职业辅助";
	CLASSMOD_TOTEMTIMERS_NAME = "图腾助手";
	CLASSMOD_TOTEMTIMERS_ENABLE = "开启图腾助手" .. DUOWAN_COLOR["STEELBLUE"] .. " (TotemTimers)" .. DUOWAN_COLOR["END"];
	CLASSMOD_TOTEMTIMERS_TIMER = "启用图腾动作条(计时器)";
	CLASSMOD_TOTEMTIMERS_TRACKER = "启用追踪器(复生、盾和武器特效)";
	CLASSMOD_TOTEMTIMERS_ENHANCE = "启用萨满增强冷却计时器";
	CLASSMOD_TOTEMTIMERS_OPTION = "更多设置";
	CLASSMOD_HUNTERMOD_ENABLE = "开启猎人助手";
	CLASSMOD_HUNTERMOD_AUTOSHOT_ENABLE = "开启自动射击条";	
	CLASSMOD_HUNTERMOD_AUTOSHOT_LOCK = "锁定自动射击条";
	CLASSMOD_HUNTERMOD_ZFEEDER_ENABLE = "开启猎人喂食按键";	
	CLASSMOD_HUNTERMOD_ASPECTBAR_ENABLE = "开启猎人守护动作条";
	CLASSMOD_HUNTERMOD_AUTOTRACK_ENABLE = "开启自动追踪切换";
	CLASSMOD_HUNTERMOD_ANTIDAZE_ENABLE = "眩晕时提示取消豹守";
	CLASSMOD_HUNTERMOD_MISDIRECTYELL_ENABLE = "开启误导喊话通报";
	CLASSMOD_ROGUEMOD_ASPECTPOSIONBAR_ENABLE = "开启盗贼毒药守护动作条";	
	CLASSMOD_MAGEMOD_TELEPORTBAR_ENABLE = "开启法师传送门动作条";
	CLASSMOD_WARLOCKMOD_PETBAR_ENABLE = "开启术士宠物召唤条";
	CLASSMOD_CLASSBAR_BINDING = "按键绑定";
	CLASSMOD_RUNFRAME_ENABLE = "开启多玩DK符文条";
	CLASSMOD_RUNFRAME_ALPHA = "没有目标时半透明显示";
	CLASSMOD_PALADINMOD_PALLPOWER_ENABLE = "开启圣骑士祝福管理" .. DUOWAN_COLOR["STEELBLUE"] .. " (PallyPower)" .. DUOWAN_COLOR["END"];
	CLASSMOD_ECLIPSEBARFRAME_ENABLE = "开启德鲁伊蚀能条助手";
	CLASSMOD_ECLIPSEBARFRAME_ALPHA = "没有目标时半透明蚀能条";
	CLASSMOD_PALADIN_POWERBAR_ENABLE = "开启多玩圣能条";
	CLASSMOD_PALADIN_POWERBAR_ALPHA = "没有目标时半透明圣能条";
	CLASSMOD_FIVECOMBO_ENABLE = "满星技能高亮提示";
	CLASSMOD_MONK_MOD_ENABLE = "开启武僧术士助手";
	CLASSMOD_MONK_MOD_TANK_ENABLE = "开启武僧坦克增强";
	CLASSMOD_TELEPORTIE_MOD_ENABLE = "開啟武僧分身和術士法陣助手";
	CLASSMOD_TELEPORTIE_MOD_TANK_ENABLE = "監視魂體雙分和惡魔法陣的距離";	
end

local _, class = UnitClass("player");

if ((dwIsConfigurableAddOn("TotemTimers") and class == "SHAMAN") or
	(dwIsConfigurableAddOn("AspectPosionBar") and (class == "ROGUE" --[[or class == "HUNTER" ]] or class == "MAGE" or class == "WARLOCK")) or	
	(dwIsConfigurableAddOn("HunterMod") and class == "HUNTER") or
	(class == "DEATHKNIGHT" and not dwRuneFrameHasOtherAddOn()) or 
	(class == "DRUID" and not dwEclipseBarHasOtherAddOn()) or
	(class == "PALADIN") or 
	(dwIsConfigurableAddOn("BMHelper") and class == "MONK") or
	((class == "ROGUE" or class == "DRUID") and dwIsConfigurableAddOn("BlinkHealthText"))) then
	
	dwRegisterMod(
		"ClassModule",
		CLASSMOD_TITLE,
		"ClassModule",
		"",
		{"Interface\\GLUES\\CHARACTERCREATE\\UI-CHARACTERCREATE-CLASSES",  CLASS_ICON_TCOORDS[class]},		
		nil
	);
end

if (dwIsConfigurableAddOn("BMHelper") and (class == "MONK" or class == "WARLOCK")) then
	dwLoadAddOn("BMHelper");
	dwRegisterCheckButton(
		"ClassModule",
		CLASSMOD_MONK_MOD_ENABLE,
		nil,
		"BMHelperEnable",
		1,
		function (arg)
			if (arg == 1) then	
				if (dwIsAddOnLoaded("BMHelper")) then
					dwBMHelper_Toggle(true);
				end
			else
				if (dwIsAddOnLoaded("BMHelper")) then
					dwBMHelper_Toggle(false);
				end
			end
		end
	);
	
	if class == "MONK" then
	dwRegisterCheckButton(
		"ClassModule",
		CLASSMOD_MONK_MOD_TANK_ENABLE,
		"",
		"BMHelperTank",
		1,
		function (arg)			
			if (arg == 1) then
				if (dwIsAddOnLoaded("BMHelper")) then
					dwBMHelperTank_Toggle(true);
				end
			else
				if (dwIsAddOnLoaded("BMHelper")) then
					dwBMHelperTank_Toggle(false);
				end
			end
		end,
		1
	);
	end
	
	if class == "MONK" or class == "WARLOCK" then
	dwRegisterCheckButton(
		"ClassModule",
		CLASSMOD_TELEPORTIE_MOD_ENABLE,
		CLASSMOD_TELEPORTIE_MOD_TANK_ENABLE,
		"BMTeleportie",
		1,
		function (arg)			
			if (arg == 1) then
				if (dwIsAddOnLoaded("BMHelper")) then
					Teleportie_Toggle(true);
				end
			else
				if (dwIsAddOnLoaded("BMHelper")) then
					Teleportie_Toggle(false);
				end
			end
		end,
		1
	);	
	end
end

if (dwIsConfigurableAddOn("TotemTimers") and class == "SHAMAN") then
	dwRegisterCheckButton(
		"ClassModule",
		CLASSMOD_TOTEMTIMERS_ENABLE,
		DUOWAN_RELOAD_DESC,
		"TotemTimersEnable",
		1,
		function (arg)			
			if (arg == 1) then
				dwLoadAddOn("TotemTimers");
			else
				if (dwIsAddOnLoaded("TotemTimers")) then
					dwRequestReloadUI(nil);
				end
			end
		end
	);
	
	dwRegisterCheckButton(
		"ClassModule",
		CLASSMOD_TOTEMTIMERS_TIMER,
		"",
		"TotemTimersTimer",
		1,
		function (arg)			
			if (arg == 1) then
				if (dwIsAddOnLoaded("TotemTimers")) then
					TT_Timer_Toggle(true);
				end
			else
				if (dwIsAddOnLoaded("TotemTimers")) then
					TT_Timer_Toggle(false);
				end
			end
		end,
		1
	);

	dwRegisterCheckButton(
		"ClassModule",
		CLASSMOD_TOTEMTIMERS_TRACKER,
		"",
		"TotemTimersTracker",
		1,
		function (arg)			
			if (arg == 1) then
				if (dwIsAddOnLoaded("TotemTimers")) then
					TT_Tracker_Toggle(true);
				end
			else
				if (dwIsAddOnLoaded("TotemTimers")) then
					TT_Tracker_Toggle(false);
				end
			end
		end,
		1
	);
	
	dwRegisterCheckButton(
		"ClassModule",
		CLASSMOD_TOTEMTIMERS_ENHANCE,
		"",
		"TotemTimersEnhance",
		0,
		function (arg)			
			if (arg == 1) then
				if (dwIsAddOnLoaded("TotemTimers")) then
					TT_EnhanceCD_Toggle(true);
				end
			else
				if (dwIsAddOnLoaded("TotemTimers")) then
					TT_EnhanceCD_Toggle(false);
				end
			end
		end,
		1
	);

	dwRegisterButton(
		"ClassModule",
		CLASSMOD_TOTEMTIMERS_OPTION, 
		function()
			if (dwIsAddOnLoaded("TotemTimers")) then				
				InterfaceOptionsFrame_OpenToCategory(CLASSMOD_TOTEMTIMERS_NAME);
			end
		end, 
		1
	);
end

if (dwIsConfigurableAddOn("HunterMod") and class == "HUNTER") then
	dwRegisterCheckButton(
		"ClassModule",
		CLASSMOD_HUNTERMOD_ENABLE,
		DUOWAN_RELOAD_DESC,
		"HunterModEnable",
		1,
		function (arg)			
			if (arg == 1) then
				dwLoadAddOn("HunterMod");
			else
				
			end
		end
	);
	
	dwRegisterCheckButton(
		"ClassModule",
		CLASSMOD_HUNTERMOD_AUTOSHOT_ENABLE,
		"",
		"HunterModAutoShotEnable",
		1,
		function (arg)			
			if (arg == 1) then
				if (dwIsAddOnLoaded("HunterMod")) then
					AutoShot:Toggle(true);
				end			
			else
				if (dwIsAddOnLoaded("HunterMod")) then
					AutoShot:Toggle(false);
				end
			end
		end,
		1
	);
	dwRegisterCheckButton(
		"ClassModule",
		CLASSMOD_HUNTERMOD_AUTOSHOT_LOCK,
		"",
		"HunterModAutoShotLock",
		0,
		function (arg)			
			if (arg == 1) then
				if (dwIsAddOnLoaded("HunterMod")) then
					AutoShot:ToggleLock(true);
				end			
			else
				if (dwIsAddOnLoaded("HunterMod")) then
				AutoShot:ToggleLock(false);
				end
			end
		end,
		2
	);

	dwRegisterCheckButton(
		"ClassModule",
		CLASSMOD_HUNTERMOD_ZFEEDER_ENABLE,
		"",
		"HunterModFeeder",
		1,
		function (arg)			
			if (arg == 1) then
				if (dwIsAddOnLoaded("HunterMod")) then
					zFeeder:Toggle(true);
				end			
			else
				if (dwIsAddOnLoaded("HunterMod")) then
					zFeeder:Toggle(false);
				end
			end
		end,
		1
	);
	--[[
	dwRegisterCheckButton(
		"ClassModule",
		CLASSMOD_HUNTERMOD_AUTOTRACK_ENABLE,
		"",
		"AutoTrack",
		1,
		function (arg)			
			if (arg == 1) then
				if (dwIsAddOnLoaded("HunterMod")) then
					AutoTrack:Toggle(true);
				end			
			else
				if (dwIsAddOnLoaded("HunterMod")) then
					AutoTrack:Toggle(false);
				end
			end
		end,
		1
	);
	]]
	dwRegisterCheckButton(
		"ClassModule",
		CLASSMOD_HUNTERMOD_ANTIDAZE_ENABLE,
		"",
		"AntiDaze",
		1,
		function (arg)			
			if (arg == 1) then
				if (dwIsAddOnLoaded("HunterMod")) then
					AntiDaze:Toggle(true);
				end			
			else
				if (dwIsAddOnLoaded("HunterMod")) then
					AntiDaze:Toggle(false);
				end
			end
		end,
		1
	);
	
	dwRegisterCheckButton(
		"ClassModule",
		CLASSMOD_HUNTERMOD_MISDIRECTYELL_ENABLE,
		"",
		"misDirectYell",
		1,
		function (arg)			
			if (arg == 1) then
				if (dwIsAddOnLoaded("HunterMod")) then
					misDirectYell:Toggle(true);
				end			
			else
				if (dwIsAddOnLoaded("HunterMod")) then
					misDirectYell:Toggle(false);
				end
			end
		end,
		1
	);
end

if (dwIsConfigurableAddOn("AspectPosionBar") and  (class == "ROGUE" --[[or class == "HUNTER"]] or class == "MAGE" or class == "WARLOCK")) then
	local desc;
	--if (class == "HUNTER") then
	--	desc = CLASSMOD_HUNTERMOD_ASPECTBAR_ENABLE;
	if (class == "ROGUE") then
		desc = CLASSMOD_ROGUEMOD_ASPECTPOSIONBAR_ENABLE;
	elseif (class == "MAGE") then		
		desc = CLASSMOD_MAGEMOD_TELEPORTBAR_ENABLE;
	elseif (class == "WARLOCK") then
		desc = CLASSMOD_WARLOCKMOD_PETBAR_ENABLE;
	end

	dwRegisterCheckButton(
		"ClassModule",
		desc,
		"",
		"EnableAspectBar",
		1,
		function (arg)			
			if (arg == 1) then
				dwLoadAddOn("AspectPosionBar");	
				
				AspectPosionBar_Toggle(true);
			else
				if (dwIsAddOnLoaded("AspectPosionBar")) then
					AspectPosionBar_Toggle(false);
				end
			end
		end
	);

	dwRegisterButton(
		"ClassModule",
		CLASSMOD_CLASSBAR_BINDING, 
		function()
			if (dwIsAddOnLoaded("AspectPosionBar")) then				
				--dwShowKeyBindingFrame("HEADER_ASPECTBAR");
				dwShowKeyBindingFrame("SHAPESHIFTBUTTON1");
				
			end
		end, 
		1
	);
	
end

-----------
-- DK
if (class == "DEATHKNIGHT" and not dwRuneFrameHasOtherAddOn()) then
	RuneFrame:SetMovable(true);
	local EnableDkMod = true;
	local function RuneFrameOnStartMove()
		local value = dwRawGetCVar("DuowanConfig", "RuneFrameScale", 1);
		dwSetScale(RuneFrame, value);
		dwSetCVar("DuowanConfig", "isRuneFrameMove", 1);
		RuneFrame:StartMoving();
		RuneFrame.isMoving = true;
	end

	local function RuneFrameOnResetPos()
		dwSetCVar("DuowanConfig", "RuneFrameScale", 1);
		dwSetCVar("DuowanConfig", "isRuneFrameMove", 0);
		RuneFrame.isMoving = false;
		dwUpdateRuneFrame();
	end

	local function RuneFrameOnStopMove()
		RuneFrame:StopMovingOrSizing();
		RuneFrame.isMoving = false;
		local pos = {RuneFrame:GetPoint()};
		dwSetCVar("DuowanConfig", "RuneFramePos", pos);
	end

	local Dropdown_Options = {	
		{
			text = RUNEFRAME_MENU_TITLE_TEXT,			
			notCheckable = true,
			isTitle = true,
		},		
		{
			text = RUNEFRAME_MENU_SCALE_TEXT,
			arg1 = 0.5,	-- min value
			arg2 = 2,	-- max value
			notCheckable = true,
			func = function(self, arg1, arg2)	
				Duowan_ShowPopRange(
					arg1, 
					arg2, 
					dwRawGetCVar("DuowanConfig", "RuneFrameScale", 1), 
					0.05, 
					true, 
					function(value)
						dwSetScale(RuneFrame, value);
						dwSetCVar("DuowanConfig", "RuneFrameScale", value);
					end,
					nil,
					function(value)
						dwSetCVar("DuowanConfig", "RuneFrameScale", value);
					end,
					nil
				);
			end,
		},
		{
			text = CANCEL,	
			notCheckable = true,
			func = function()			
			end,
		},
	};
		
	for i=1, 6 do
		rune = _G["RuneButtonIndividual"..i];
		rune:RegisterForClicks("LeftButtonDown", "RightButtonDown");
		rune:SetScript("OnMouseDown", function(self, button)
			if (not (EnableDkMod and IsShiftKeyDown())) then
				return;
			end

			if (button == "LeftButton") then
				RuneFrameOnStartMove();		
			end
		end);
		DWEasyMenu_Register(rune, Dropdown_Options);
		rune:SetScript("OnMouseUp", function(self, button)
			if (RuneFrame.isMoving) then
				RuneFrameOnStopMove();
			end
		end);
	end

	local runePowerText = RuneFrame:CreateFontString("dwRunePowerText", "ARTWORK");
	runePowerText:SetFont(STANDARD_TEXT_FONT, 18, "OUTLINE");
	runePowerText:SetJustifyH("CENTER");
	runePowerText:SetTextColor(0, 82, 1);
	runePowerText:SetPoint("BOTTOM", RuneFrame, "TOP", 0, -1);

	hooksecurefunc("RuneButton_OnEnter", function(self)
		if (EnableDkMod) then
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT");
			GameTooltip:ClearLines();
			GameTooltip:SetText(self.tooltipText);
			GameTooltip:AddLine("|cff00aeff".. RUNEFRAME_MENU_TIP_TEXT1.."|r");		
			GameTooltip:Show();
		end		
	end);

	hooksecurefunc("UnitFrame_SetUnit", function(self, unit, healthbar, manabar)
		if ((self==PlayerFrame or self==PetFrame) and unit=="player") then
			dwUpdateRuneFrame();
		end
	end)
	
	local function RuneFrameCenterPos()
		local value = dwRawGetCVar("DuowanConfig", "isRuneFrameMove", 0);
		if (value == 0) then
			dwSetCVar("DuowanConfig", "RuneFrameScale", 1.2);
			RuneFrameOnStartMove();
			RuneFrame:ClearAllPoints();
			RuneFrame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 175);
			RuneFrameOnStopMove();	
		end			
	end
	
	function DKMod_Toggle(switch)
		local rune;
		if (switch) then
			EnableDkMod = true;	
			RuneFrameCenterPos();
		else
			EnableDkMod = false;			
			RuneFrameOnResetPos();
		end
	end

	local frame = CreateFrame("Frame");
	frame.time = 0;
	local enableAlpha = false;
	frame:SetScript("OnUpdate", function(self, elapsed)
		self.time = self.time + elapsed;
		if (self.time > 0.05) then
			if (enableAlpha) then
				if (UnitExists("target")) then
					RuneFrame:SetAlpha(1);
				else
					RuneFrame:SetAlpha(0.2);
				end
			end			

			-- 显示符文能量
			local value = UnitPower("player");
			runePowerText:SetText(value);
			if (value == 0) then
				runePowerText:Hide();
			else
				runePowerText:Show();
			end
		end
	end);

	dwRegisterCheckButton(
		"ClassModule",
		CLASSMOD_RUNFRAME_ENABLE,
		"",
		"EnableDkMod",
		1,
		function (arg)
			if (arg == 1) then
				DKMod_Toggle(true);
			else
				DKMod_Toggle(false);
			end
		end
	);

	dwRegisterCheckButton(
		"ClassModule",
		CLASSMOD_RUNFRAME_ALPHA,
		"",
		"DkModAlpha",
		1,
		function (arg)
			if (arg == 1) then
				enableAlpha = true;
			else				
				enableAlpha = false;
				RuneFrame:SetAlpha(1);
			end
		end,
		1
	);
end

-----------
-- 德鲁伊
if (class == "DRUID" and not dwEclipseBarHasOtherAddOn()) then
	EclipseBarFrame:SetMovable(true);
	local EnableDLYMod = true;
	local function EclipseBarFrameOnStartMove()
		local value = dwRawGetCVar("DuowanConfig", "EclipseBarFrameScale", 1);
		dwSetScale(EclipseBarFrame, value);
		dwSetCVar("DuowanConfig", "isEclipseBarFrameMove", 1);
		EclipseBarFrame:StartMoving();
		EclipseBarFrame.isMoving = true;
	end

	local function EclipseBarFrameOnResetPos()
		dwSetCVar("DuowanConfig", "EclipseBarFrameScale", 1);
		dwSetCVar("DuowanConfig", "isEclipseBarFrameMove", 0);
		EclipseBarFrame.isMoving = false;
		dwUpdateEclipseBarFrame();
	end

	local function EclipseBarFrameOnStopMove()
		EclipseBarFrame:StopMovingOrSizing();
		EclipseBarFrame.isMoving = false;
		local pos = {EclipseBarFrame:GetPoint()};
		dwSetCVar("DuowanConfig", "EclipseBarFramePos", pos);
	end
	
	--------------
	-- 可移動
	EclipseBarFrame:EnableMouse(true);
	--EclipseBarFrame:RegisterForClicks("LeftButtonDown", "RightButtonDown");
	EclipseBarFrame:SetScript("OnMouseDown", function(self, button)
		if (not (EnableDLYMod and IsShiftKeyDown())) then
			return;
		end

		if (button == "LeftButton") then
			EclipseBarFrameOnStartMove();
		elseif (button == "RightButton") then
			EclipseBarFrameOnResetPos();
		end
	end);
	
	EclipseBarFrame:SetScript("OnMouseUp", function(self, button)
		if (EclipseBarFrame.isMoving) then
			EclipseBarFrameOnStopMove();
		end
	end);

	EclipseBarFrame:HookScript("OnEnter", function(self)
		self.PowerText:Show();
		if (EnableDLYMod) then
			--GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT");
			GameTooltip_SetDefaultAnchor(GameTooltip, self);
			GameTooltip:ClearLines();
			GameTooltip:SetText(ECLIPSEBARFRAME_TOOLTIP_TEXT);
			GameTooltip:AddLine("|cff00aeff".. ECLIPSEBARFRAME_MOVE_TIP_TEXT.."|r");		
			GameTooltip:Show();
		end		
	end);

	EclipseBarFrame:HookScript("OnLeave", function(self)
		GameTooltip:Hide();
		if not self.lockShow then
			self.PowerText:Hide();
		end
	end)
	
	local function EclipseBarFrameCenterPos()
		local value = dwRawGetCVar("DuowanConfig", "isEclipseBarFrameMove", 0);
		if (value == 0) then
			dwSetCVar("DuowanConfig", "EclipseBarFrameScale", 1.2);
			EclipseBarFrameOnStartMove();
			EclipseBarFrame:ClearAllPoints();
			EclipseBarFrame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 175);
			EclipseBarFrameOnStopMove();	
		end			
	end
	
	function DLYMod_Toggle(switch)
		local rune;
		if (switch) then
			EnableDLYMod = true;	
			EclipseBarFrameCenterPos();
		else
			EnableDLYMod = false;
			EclipseBarFrameOnResetPos();
		end
	end

	local frame = CreateFrame("Frame");
	frame.time = 0;
	dwRegisterCheckButton(
		"ClassModule",
		CLASSMOD_ECLIPSEBARFRAME_ENABLE,
		"",
		"EnableDLYMod",
		1,
		function (arg)
			if (arg == 1) then
				DLYMod_Toggle(true);
			else
				DLYMod_Toggle(false);
			end
		end
	);

	dwRegisterCheckButton(
		"ClassModule",
		CLASSMOD_ECLIPSEBARFRAME_ALPHA,
		"",
		"DLYModAlpha",
		1,
		function (arg)
			if (arg == 1) then
				frame:SetScript("OnUpdate", function(self, elapsed)
					self.time = self.time + elapsed;
					if (self.time > 0.05) then
						self.time = 0;
						if (UnitExists("target")) then
							EclipseBarFrame:SetAlpha(1);							
						else
							EclipseBarFrame:SetAlpha(0.2);							
						end
					end
				end);
			else				
				frame:SetScript("OnUpdate", nil);
				EclipseBarFrame:SetAlpha(1);
			end
		end,
		1
	);
end

if (class == "PALADIN") then
	PaladinPowerBar:SetMovable(true);
	local EnablePaladinMod = false;
	local function PaladinPowerBarOnStartMove()
		local value = dwRawGetCVar("DuowanConfig", "PaladinFrameScale", 1);
		dwSetScale(PaladinPowerBar, value);
		dwSetCVar("DuowanConfig", "isPaladinFrameMove", 1);
		PaladinPowerBar:StartMoving();
		PaladinPowerBar.isMoving = true;
		
		PaladinPowerBarBG:SetTexture("Interface\\AddOns\\Duowan\\textures\\PaladinPowerNormal");
		PaladinPowerBarBG:SetTexCoord(0.00390625, 0.53515625, 0.32812500, 0.63281250);
		PaladinPowerBarGlowBGTexture:SetTexture("Interface\\AddOns\\Duowan\\textures\\PaladinPowerGlow");
		PaladinPowerBarGlowBGTexture:SetTexCoord(0.00390625, 0.53515625, 0.32812500, 0.63281250);		
	end

	local function PaladinPowerBarOnResetPos()
		dwSetCVar("DuowanConfig", "isPaladinFrameMove", 2);
		PaladinPowerBar.isMoving = false;
		dwUpdatePaladinPowerFrame();
	end

	local function PaladinPowerBarOnStopMove(nosave)
		if (PaladinPowerBar.isMoving) then		
			PaladinPowerBar:StopMovingOrSizing();
			PaladinPowerBar.isMoving = false;
			if (nosave) then
				return;
			end
			local pos = {PaladinPowerBar:GetPoint()};
			dwSetCVar("DuowanConfig", "PaladinFramePos", pos);
		end
	end

	PaladinPowerBar:EnableMouse(true);
	--PaladinPowerBarGlowBG:RegisterForClicks("LeftButtonDown", "RightButtonDown");
	PaladinPowerBar:SetScript("OnMouseDown", function(self, button)
		if (not EnablePaladinMod or not IsShiftKeyDown()) then
			return;
		end

		if (button == "LeftButton") then
			PaladinPowerBarOnStartMove();
		else
			PaladinPowerBarOnResetPos();
		end
	end);
	
	PaladinPowerBar:SetScript("OnMouseUp", function(self, button)
		if (PaladinPowerBar.isMoving) then
			PaladinPowerBarOnStopMove();
		end
	end);

	PaladinPowerBar:SetScript("OnEnter", function(self)
		if (EnablePaladinMod) then
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT");
			GameTooltip:SetText(DUOWAN_PALADIN_POWERBAR, 1, 1, 1);
			GameTooltip:AddLine("|cff00aeff".. RUNEFRAME_MENU_TIP_TEXT1.."|r");
			GameTooltip:AddLine("|cff00aeff".. RUNEFRAME_MENU_TIP_TEXT2.."|r");
			GameTooltip:Show();
		end
	end)
	
	PaladinPowerBar:SetScript("OnLeave", function(self)
		GameTooltip:Hide();
	end);

	local function PaladinPowerBarFrameCenterPos()
		local value = dwRawGetCVar("DuowanConfig", "isPaladinFrameMove", 0);
		if (value == 0) then
			dwSetCVar("DuowanConfig", "PaladinFrameScale", 1.0);
			PaladinPowerBarOnStartMove();
			PaladinPowerBar:ClearAllPoints();
			PaladinPowerBar:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 225);
			PaladinPowerBarOnStopMove(true);	
		end			
	end
	
	function PaladinMod_Toggle(switch)
		if (switch) then
			EnablePaladinMod = true;	
			PaladinPowerBarFrameCenterPos();
		else
			EnablePaladinMod = false;
			PaladinPowerBarOnResetPos();
		end
	end

	local frame = CreateFrame("Frame");
	frame.time = 0;
	dwRegisterCheckButton(
		"ClassModule",
		CLASSMOD_PALADIN_POWERBAR_ENABLE,
		"",
		"EnablePaladinMod",
		1,
		function (arg)
			if (arg == 1) then
				PaladinMod_Toggle(true);
			else
				PaladinMod_Toggle(false);
			end
		end
	);

	dwRegisterCheckButton(
		"ClassModule",
		CLASSMOD_PALADIN_POWERBAR_ALPHA,
		"",
		"PaladinModAlpha",
		1,
		function (arg)
			local value = dwRawGetCVar("DuowanConfig", "isPaladinFrameMove", 0);
			if (arg == 1) then
				frame:SetScript("OnUpdate", function(self, elapsed)
					self.time = self.time + elapsed;					

					if (self.time > 0.05) then
						self.time = 0;						
						if (value == 2 or UnitExists("target")) then
							PaladinPowerBar:SetAlpha(1);							
						else
							PaladinPowerBar:SetAlpha(0.2);							
						end
					end
				end);
			else				
				frame:SetScript("OnUpdate", nil);
				PaladinPowerBar:SetAlpha(1);
			end
		end,
		1
	);
end

if ((class == "ROGUE" or class == "DRUID") and dwIsConfigurableAddOn("BlinkHealthText")) then
	dwRegisterCheckButton(
		"ClassModule",
		CLASSMOD_FIVECOMBO_ENABLE,
		"",
		"EnableFiveCombo",
		1,
		function (arg)
			if (arg == 1) then
				FiveCombo_Toggle(true);
			else
				FiveCombo_Toggle(false);
			end
		end
	);
end

