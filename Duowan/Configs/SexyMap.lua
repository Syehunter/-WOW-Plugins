------------------------------------
-- dugu 2009-12-22

if (GetLocale() == "zhCN") then
	SEXYMAP_TITLE = "地图增强";
	SEXYMAP_OPT = "打开配置"
	SEXYMAP_OPTION1 = "开启小地图增强" .. DUOWAN_COLOR["STEELBLUE"] .. " (SexyMap)" .. DUOWAN_COLOR["END"];
	SEXYMAP_BUTTON1 = "开启助手界面";
	CARTOGRAPHER_ENABLE = "开启地图增强" .. DUOWAN_COLOR["STEELBLUE"] .. " (Mapster)" .. DUOWAN_COLOR["END"];
	CARTOGRAPHER_INSTANCEMAPS_ENABLE = "开启副本地图和BOSS掉落查询";
	INSTANCEMAPS_ENABLE_TEXT = "开启副本掉落" .. DUOWAN_COLOR["STEELBLUE"] .. " (YssBossLoot)" .. DUOWAN_COLOR["END"];
	NPCSCAN_ENABLE_TITLE = "开启稀有精英探测";
	NPCSCAN_ENABLE_DESC = "在地图上描绘稀有精英可能出现的位置";
	NPCSCAN_MINIMAP_ENABLE_TITLE = "显示小地图稀有精英路径";
	ENABLE_ARCHY_TEXT ="启用考古助手" .. DUOWAN_COLOR["STEELBLUE"] .. " (Archy)" .. DUOWAN_COLOR["END"];
	WORLDFLIGHTMAP_ENABLE = "启用飞行世界地图";
	WORLDFLIGHTMAP_DESC = "不再使用飞行地图,而是直接在大地图上显示飞行点.";	
	NPCSCAN_OPTION = "更多选项";
elseif (GetLocale() == "zhTW") then
	SEXYMAP_TITLE = "地圖增強";
	SEXYMAP_OPT = "打開配置"
	SEXYMAP_OPTION1 = "開啟小地圖增強"  .. DUOWAN_COLOR["STEELBLUE"] .. " (SexyMap)" .. DUOWAN_COLOR["END"];
	SEXYMAP_BUTTON1 = "開啟助手界面";	
	CARTOGRAPHER_ENABLE = "開啟地圖增強" .. DUOWAN_COLOR["STEELBLUE"] .. " (Mapster)" .. DUOWAN_COLOR["END"];
	CARTOGRAPHER_INSTANCEMAPS_ENABLE = "開啟副本地圖和BOSS掉落查詢";
	INSTANCEMAPS_ENABLE_TEXT = "開啟副本掉落" .. DUOWAN_COLOR["STEELBLUE"] .. " (YssBossLoot)" .. DUOWAN_COLOR["END"];
	NPCSCAN_ENABLE_TITLE = "開啟稀有精英探測";
	NPCSCAN_ENABLE_DESC = "在地圖上描繪稀有精英可能出現的位置";
	ENABLE_ARCHY_TEXT ="啟用考古助手" .. DUOWAN_COLOR["STEELBLUE"] .. " (Archy)" .. DUOWAN_COLOR["END"];
	NPCSCAN_MINIMAP_ENABLE_TITLE = "顯示小地圖稀有精英路徑";
	WORLDFLIGHTMAP_ENABLE = "啟用飛行世界地圖";
	WORLDFLIGHTMAP_DESC = "不再使用飛行地圖,而是直接在大地圖上顯示飛行點.";	
	NPCSCAN_OPTION = "更多選項";
else
	SEXYMAP_TITLE = "地图增强";
	SEXYMAP_OPT = "打开配置"
	SEXYMAP_OPTION1 = "开启小地图增强" .. DUOWAN_COLOR["STEELBLUE"] .. " (SexyMap)" .. DUOWAN_COLOR["END"];
	SEXYMAP_BUTTON1 = "开启助手界面";
	CARTOGRAPHER_ENABLE = "开启地图增强" .. DUOWAN_COLOR["STEELBLUE"] .. " (Mapster)" .. DUOWAN_COLOR["END"];
	CARTOGRAPHER_INSTANCEMAPS_ENABLE = "开启副本地图和BOSS掉落查询";
	INSTANCEMAPS_ENABLE_TEXT = "开启副本掉落" .. DUOWAN_COLOR["STEELBLUE"] .. " (YssBossLoot)" .. DUOWAN_COLOR["END"];
	NPCSCAN_ENABLE_TITLE = "开启稀有精英探测";
	NPCSCAN_ENABLE_DESC = "在地图上描绘稀有精英可能出现的位置";
	NPCSCAN_MINIMAP_ENABLE_TITLE = "显示小地图稀有精英路径";
	ENABLE_ARCHY_TEXT ="启用考古助手" .. DUOWAN_COLOR["STEELBLUE"] .. " (Archy)" .. DUOWAN_COLOR["END"];
	WORLDFLIGHTMAP_ENABLE = "启用飞行世界地图";
	WORLDFLIGHTMAP_DESC = "不再使用飞行地图,而是直接在大地图上显示飞行点.";		
	NPCSCAN_OPTION = "更多选项";
end

if (dwIsConfigurableAddOn("SexyMap") or dwIsConfigurableAddOn("Mapster") or dwIsConfigurableAddOn("YssBossLoot") or dwIsConfigurableAddOn("Archy") or dwIsConfigurableAddOn("_NPCScan"))then	
	dwRegisterMod(
		"MiniMapMod",
		SEXYMAP_TITLE,
		"SEXYMAP",
		"",
		"Interface\\ICONS\\Spell_Arcane_TeleportExodar",
		nil
	);
end


if (dwIsConfigurableAddOn("Archy")) then
	dwRegisterCheckButton(
		"MiniMapMod",
		ENABLE_ARCHY_TEXT,
		DUOWAN_RELOAD_DESC,
		"ArchyEnable",
		0,
		function (arg)
			if(arg==1)then
				if (not (dwIsAddOnLoaded("Archy"))) then
					dwLoadAddOn("Archy");
				end				
			else
				if (dwIsAddOnLoaded("Archy")) then
					dwRequestReloadUI(nil);
				end
			end
		end
	);
end

if (dwIsConfigurableAddOn("SexyMap")) then
	dwRegisterCheckButton(
		"MiniMapMod",
		SEXYMAP_OPTION1,
		DUOWAN_RELOAD_DESC,
		"SEXYMAP_OPTION1",
		1,
		function (arg)
			local IsNewSimpleMode = dwRawGetCVar("DuowanConfig", "IsNewSimpleMode", false);
			if(arg==1)then
				if (not (dwIsAddOnLoaded("SexyMap") and IsNewSimpleMode)) then
					dwLoadAddOn("SexyMap");
				end				
			else
				if (dwIsAddOnLoaded("SexyMap")) then
					dwRequestReloadUI(nil);
				end
			end
		end
	);
	dwRegisterButton(
		"MiniMapMod",
		SEXYMAP_OPT, 
		function()
			if (dwIsAddOnLoaded("SexyMap")) then
				--HideUIPanel(DuowanConfigFrame);
				SlashCmdList.SexyMap()
			end
		end, 
		1
	);	
end

if (dwIsConfigurableAddOn("Mapster")) then
	dwRegisterCheckButton(
		"MiniMapMod",
		CARTOGRAPHER_ENABLE,
		DUOWAN_RELOAD_DESC,
		"MapsterEnable",
		1,
		function (arg)
			if (arg == 1) then
				if (not dwIsAddOnLoaded("Mapster")) then
					dwLoadAddOn("Mapster");
				end
			
			else
				if (dwIsAddOnLoaded("Mapster")) then
					dwRequestReloadUI(nil);
				end
			end
		end
	);
	dwRegisterCheckButton(
		"MiniMapMod",
		WORLDFLIGHTMAP_ENABLE,
		WORLDFLIGHTMAP_DESC,
		"WorldFlightMapEnable",
		1,
		function (arg)
			DWWorldFlightMap_Toggle(arg)
		end,
		1
	);	
end

if (dwIsConfigurableAddOn("YssBossLoot")) then
	dwRegisterCheckButton(
		"MiniMapMod",
		INSTANCEMAPS_ENABLE_TEXT,
		DUOWAN_RELOAD_DESC,
		"EnableYssBossLoot",
		1,
		function (arg)	
			if(arg==1)then	
				if (not dwIsAddOnLoaded("YssBossLoot")) then
					dwLoadAddOn("YssBossLoot");
				end
			else
				if (dwIsAddOnLoaded("YssBossLoot")) then
					dwRequestReloadUI(nil);
				end
			end
		end
	);	
end

if (dwIsConfigurableAddOn("_NPCScan")) then
	dwRegisterCheckButton(
		"MiniMapMod",
		NPCSCAN_ENABLE_TITLE,
		NPCSCAN_ENABLE_DESC,
		"NPCScanEnable",
		1,
		function (arg)		
			if (arg == 1) then				
				if (not dwIsAddOnLoaded("_NPCScan.Overlay")) then					
					dwLoadAddOn("_NPCScan.Overlay");
				end
				
				_NPCScan:Toggle(true);
			else
				if (dwIsAddOnLoaded("_NPCScan")) then
					_NPCScan:Toggle(false);
				end
			end
		end
	);

	dwRegisterCheckButton(
		"MiniMapMod",
		NPCSCAN_MINIMAP_ENABLE_TITLE,
		nil,
		"NPCScanMinimap",
		0,
		function (arg)		
			if (arg == 1) then
				if (dwIsAddOnLoaded("_NPCScan")) then
					_NPCScan:Minimap_Toggle(true);
				end
			else
				if (dwIsAddOnLoaded("_NPCScan")) then
					_NPCScan:Minimap_Toggle(false);
				end
			end
		end,
		1
	);

	dwRegisterButton(
		"MiniMapMod",
		NPCSCAN_OPTION, 
		function()
			if (dwIsAddOnLoaded("_NPCScan")) then
				_NPCScan:OpenConfig();
			end
		end, 
		1
	);
end