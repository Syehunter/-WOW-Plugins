------------------------------------
-- eui.cc 2014-11-30
local ACD = LibStub("AceConfigDialog-3.0")
if (GetLocale() == "zhCN") then
	GARRISON_MOD_TITLE = "要塞助手";
	MasterPlan_ENABLE_TEXT = "启用追随者助手";
	HandyNotes_DraenorTreasures_ENABLE_TEXT = "德拉诺宝箱显示";
	Broker_Garrison_ENABLE_TEXT = "启用要塞资讯";
	HandyNotes_DraenorTreasures_Open_Cfg = "打开宝箱设置"
	DWBODYGUARDAWAY_ENABLE = "隐藏保镖对话框"
	DWBODYGUARDAWAY_ENABLE_TOOLTIP = "按Ctrl点击保镖出现对话框"	
elseif (GetLocale() == "zhTW") then
	GARRISON_MOD_TITLE = "要塞助手";
	MasterPlan_ENABLE_TEXT = "啟用追隨者助手";	
	HandyNotes_DraenorTreasures_ENABLE_TEXT = "德拉諾寶箱顯示";
	Broker_Garrison_ENABLE_TEXT = "啓用要塞資訊";
	HandyNotes_DraenorTreasures_Open_Cfg = "打開寶箱設置"
	DWBODYGUARDAWAY_ENABLE = "隱藏保鏢對話方塊"
	DWBODYGUARDAWAY_ENABLE_TOOLTIP = "按Ctrl點擊保鏢出現對話方塊"	
else
	GARRISON_MOD_TITLE = "DuowanGarrison";
	MasterPlan_ENABLE_TEXT = "Enable DuowanGarrison";	
	HandyNotes_DraenorTreasures_ENABLE_TEXT = "Draenor Treasures";
	Broker_Garrison_ENABLE_TEXT = "Enable Broker_Garrison";
	HandyNotes_DraenorTreasures_Open_Cfg = "Open HandyNotes_DraenorTreasures Cfg";
	DWBODYGUARDAWAY_ENABLE = "隐藏保镖对话框"
	DWBODYGUARDAWAY_ENABLE_TOOLTIP = "按Ctrl点击保镖出现对话框"		
end

	dwRegisterMod(
		"Garrison",
		GARRISON_MOD_TITLE,
		"Garrison",
		"",
		"Interface\\Icons\\ability_mount_charger",
		nil
	);

if dwIsConfigurableAddOn("DuowanGarrison") then
	dwRegisterCheckButton(
		"Garrison",
		MasterPlan_ENABLE_TEXT,
		nil,
		"EnableDuowanGarrison",
		1,
		function (arg)
			if ( arg == 1 ) then
				if not dwIsAddOnLoaded("DuowanGarrison") then
				--	dwLoadAddOn("DuowanGarrison");
				end
			else
				if dwIsAddOnLoaded("DuowanGarrison") then
					DisableAddon("DuowanGarrison");
					dwRequestReloadUI(nil);
				end
			end
		end
	);
	dwRegisterCheckButton(
		"Garrison",
		DWBODYGUARDAWAY_ENABLE,
		DWBODYGUARDAWAY_ENABLE_TOOLTIP,
		"EnableDWBODYGUARDAWAY",
		0,
		function (arg)
			if ( arg == 1 ) then
				DWBODYGUARDAWAY:Toggle(1)
			else
				DWBODYGUARDAWAY:Toggle(0)
			end
		end,
		1
	);	
end

if dwIsConfigurableAddOn("Broker_Garrison") then
	dwRegisterCheckButton(
		"Garrison",
		Broker_Garrison_ENABLE_TEXT,
		nil,
		"EnableBroker_Garrison",
		1,
		function (arg)
			if ( arg == 1 ) then
				if not dwIsAddOnLoaded("Broker_Garrison") then
					dwLoadAddOn("Broker_Garrison");
				end
			else
				if dwIsAddOnLoaded("Broker_Garrison") then
					dwRequestReloadUI(nil);
				end
			end
		end
	);
end

if dwIsConfigurableAddOn("HandyNotes_DraenorTreasures") and dwIsConfigurableAddOn("HandyNotes") then
	dwRegisterCheckButton(
		"Garrison",
		HandyNotes_DraenorTreasures_ENABLE_TEXT,
		nil,
		"EnableDraenorTreasures",
		0,
		function (arg)
			if ( arg == 1 ) then
				if not dwLoadAddOn("HandyNotes") then
					dwLoadAddOn("HandyNotes");
				end
				if not dwIsAddOnLoaded("HandyNotes_DraenorTreasures") then
					dwLoadAddOn("HandyNotes_DraenorTreasures");
					if not HandyNotes.plugins["DraenorTreasures"] then
						DraenorTreasures:RegisterWithHandyNotes();
					end
				end
			else
				if dwIsAddOnLoaded("HandyNotes_DraenorTreasures") then
					dwRequestReloadUI(nil);
				end
			end
		end
	);
	dwRegisterButton(
		"Garrison",
		HandyNotes_DraenorTreasures_Open_Cfg, 
		function()			
			if (dwIsAddOnLoaded("HandyNotes_DraenorTreasures")) then
				ACD:Open("HandyNotes");
			end
		end, 
		1
	);	
end
