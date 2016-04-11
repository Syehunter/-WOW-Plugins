
if (GetLocale() == "zhCN") then
	PETBATTLE_MOD_NAME = "宠物战斗";
	DWPET_ENABLE = "启用宠物战斗增强";
	DWPET_OPEN_OPTION = '打开设置';
	PETBATTLE_MOD_ENABLE_INFO = "显示对战宠物的品质信息"
	PETBATTLE_MOD_ENABLE_FILTER = "增强宠物面板的过滤信息"
	PETBATTLE_MOD_ENABLE_SORT = "允许更多的排序方式"
	PETBATTLE_MOD_ENABLE_SORT_DESC = "该功能会占用大量内存"
elseif (GetLocale() == "zhTW") then
	PETBATTLE_MOD_NAME = "寵物戰鬥";
	DWPET_ENABLE = "啓用寵物戰鬥增強";
	DWPET_OPEN_OPTION = '打開設置';	
	PETBATTLE_MOD_ENABLE_INFO = "顯示對戰寵物的品質資訊"
	PETBATTLE_MOD_ENABLE_FILTER = "增強寵物面板的過濾資訊"
	PETBATTLE_MOD_ENABLE_SORT = "允許更多的排序方式"
	PETBATTLE_MOD_ENABLE_SORT_DESC = "該功能會佔用大量記憶體"
else
	DWPET_ENABLE = "启用宠物战斗增强";
	DWPET_OPEN_OPTION = '打开设置';
	PETBATTLE_MOD_NAME = "宠物战斗";
	PETBATTLE_MOD_ENABLE_INFO = "显示对战宠物的品质信息"
	PETBATTLE_MOD_ENABLE_FILTER = "增强宠物面板的过滤信息"
	PETBATTLE_MOD_ENABLE_SORT = "允许更多的排序方式"
	PETBATTLE_MOD_ENABLE_SORT_DESC = "该功能会占用大量内存"
end

if (dwIsConfigurableAddOn("HPetBattleAny")) then
	dwRegisterMod(
		"HPetBattleAny",
		PETBATTLE_MOD_NAME,
		"HPetBattleAny",
		"",
		"Interface\\ICONS\\Ability_Hunter_Pet_GoTo",
		nil
	);
	dwRegisterCheckButton(
		"HPetBattleAny",
		DWPET_ENABLE,
		DUOWAN_RELOAD_DESC,
		"DWDKPEnable",
		1,
		function (arg)			
			if (arg == 1) then
				if (not dwIsAddOnLoaded("HPetBattleAny")) then
					dwLoadAddOn("HPetBattleAny");
					HPetBattleAny:PLAYER_ENTERING_WORLD()
				end				
			else
				if (dwIsAddOnLoaded("HPetBattleAny")) then	
					dwRequestReloadUI(nil);
				end			
			end
		end
	);	
	dwRegisterButton(
		"HPetBattleAny",
		DWPET_OPEN_OPTION, 
		function()			
			if (dwIsAddOnLoaded("HPetBattleAny")) then
				HideUIPanel(DuowanConfigFrame);
				HPetOption:Toggle()
			end
		end, 
		1
	);
end