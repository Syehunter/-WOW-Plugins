------------------------------------
-- dugu 2009-12-22
local TRINKET_TITLE, TRINKET_ENABLE, TRINKET_OPEN_OPTIONS

if (GetLocale() == "zhCN") then
	TRINKET_TITLE = "姓名版增强";
	TRINKET_ENABLE = "启用姓名版增强";
	TRINKET_OPEN_OPTIONS = "打开设置界面";
elseif (GetLocale() == "zhTW") then
	TRINKET_TITLE = "姓名版增强";
	TRINKET_ENABLE = "啟用姓名版增强";
	TRINKET_OPEN_OPTIONS = "打開設定介面";
else
	TRINKET_TITLE = "姓名版增强";
	TRINKET_ENABLE = "启用姓名版增强";
	TRINKET_OPEN_OPTIONS = "打开设置界面";
end

if (dwIsConfigurableAddOn("JamPlates_Accessories")) then
	dwRegisterMod(
		"JAMPLATESACCESSORIES",
		TRINKET_TITLE,
		"JAMPLATES",
		"",
		"Interface\\ICONS\\INV_Jewelry_Necklace_15",
		nil
	);
	dwRegisterCheckButton(
		"JAMPLATESACCESSORIES",
		TRINKET_ENABLE,
		nil,
		"JAMPLATES_OPTION1",
		1,
		function (arg)	
			if (arg == 1) then
			--	if (not dwIsAddOnLoaded("JamPlates Accessories")) then
			--		dwLoadAddOn("JamPlates Accessories");
			--	end
			--	TrinketMenu_Toggle(true);
			--	JamPlatesAccessories_Toggle(true)
				if dwIsAddOnLoaded("JamPlates_Accessories") then
					JamPlatesAccessories_Toggle(true)
				end
			else
			--	if (dwIsAddOnLoaded("JamPlates Accessories")) then
			--		TrinketMenu_Toggle(false);
			--		JamPlatesAccessories_Toggle(false)				
			--	end
				if dwIsAddOnLoaded("JamPlates_Accessories") then
					JamPlatesAccessories_Toggle(false)
				end
			end
		end
	);
	dwRegisterButton(
		"JAMPLATESACCESSORIES",
		TRINKET_OPEN_OPTIONS, 
		function()			
			if (dwIsAddOnLoaded("JamPlates_Accessories")) then
				InterfaceOptionsFrame_Show() -- redundant, yes; safer, also yes.
				InterfaceOptionsFrame_OpenToCategory("JamPlates Accessories")
			end
		end, 
		1
	);
end