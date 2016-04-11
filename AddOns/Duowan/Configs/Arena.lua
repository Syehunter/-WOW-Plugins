------------------------------------
-- dugu 2009-12-22

if (GetLocale() == "zhCN") then
	ARENA_MOD_TITLE = "竞技大师";
	ARENA_MOD_GLADIUS_ENABLE = "开启竞技场助手" .. DUOWAN_COLOR["STEELBLUE"] .. " (Gladius)" .. DUOWAN_COLOR["END"];
	ARENA_MOD_GLADIUS_OPTION ="打开配置";
	ARENA_MOD_GLADIATORLOSSA_ENABLE = "开启竞技场技能语音提示" .. DUOWAN_COLOR["STEELBLUE"] .. " (GladiatorlosSA)" .. DUOWAN_COLOR["END"];
	ARENA_MOD_GLADIATORLOSSA_OPTION ="打开配置";
	ARENA_MOD_FIRE_ALERTER = "开启被集火警告";
elseif (GetLocale() == "zhTW") then
	ARENA_MOD_TITLE = "競技大師";
	ARENA_MOD_GLADIUS_ENABLE = "開啟競技場助手" .. DUOWAN_COLOR["STEELBLUE"] .. " (Gladius)" .. DUOWAN_COLOR["END"];
	ARENA_MOD_GLADIUS_OPTION ="打開配置";
	ARENA_MOD_GLADIATORLOSSA_ENABLE = "開啟競技場技能語音提示" .. DUOWAN_COLOR["STEELBLUE"] .. " (GladiatorlosSA)" .. DUOWAN_COLOR["END"];
	ARENA_MOD_GLADIATORLOSSA_OPTION ="打開配置";
	ARENA_MOD_FIRE_ALERTER = "開啟被集火警告";
else
	ARENA_MOD_TITLE = "竞技大师";
	ARENA_MOD_GLADIUS_ENABLE = "开启竞技场助手" .. DUOWAN_COLOR["STEELBLUE"] .. " (Gladius)" .. DUOWAN_COLOR["END"];
	ARENA_MOD_GLADIUS_OPTION ="打开配置";
	ARENA_MOD_GLADIATORLOSSA_ENABLE = "开启竞技场技能语音提示" .. DUOWAN_COLOR["STEELBLUE"] .. " (GladiatorlosSA)" .. DUOWAN_COLOR["END"];
	ARENA_MOD_GLADIATORLOSSA_OPTION ="打开配置";
	ARENA_MOD_FIRE_ALERTER = "开启被集火警告";
end

if (dwIsConfigurableAddOn("Gladius") or dwIsConfigurableAddOn("GladiatorlosSA")) then
	dwRegisterMod(
		"ArenaMod",
		ARENA_MOD_TITLE,
		"ArenaMod",
		"",
		"Interface\\ICONS\\Ability_Hunter_Displacement",
		nil
	);
end

local lGladiusEnable, lGladiatorlosSAEnable, lGadiatorlosSAFireEnable, IsInArena = false, false, false, false;
local frame = CreateFrame("Frame");
frame:RegisterEvent("ZONE_CHANGED_NEW_AREA");
frame:RegisterEvent("PLAYER_ENTERING_WORLD");
frame:SetScript("OnEvent", function(self, event)
	local _, currentZoneType = IsInInstance();
	if (currentZoneType == "arena"--[[ or currentZoneType == "pvp"]]) then
		if (lGladiusEnable and not dwIsAddOnLoaded("Gladius")) then
			dwLoadAddOn("Gladius");
			Gladius:Toggle(true);
		end
		IsInArena = true;
	end
	if (currentZoneType == "arena" or currentZoneType == "pvp") then
		if (not dwIsAddOnLoaded("GladiatorlosSA")) then
			dwLoadAddOn("GladiatorlosSA");
		end		
	end
end);

if (dwIsConfigurableAddOn("Gladius")) then
	dwRegisterCheckButton(
		"ArenaMod",
		ARENA_MOD_GLADIUS_ENABLE,
		nil,
		"GladiusEnable",
		1,
		function (arg)
			if(arg==1)then
				if(not dwIsAddOnLoaded("Gladius") and IsInArena)then
					dwLoadAddOn("Gladius");
				end
				if(dwIsAddOnLoaded("Gladius"))then
					Gladius:Toggle(true);
				end
				lGladiusEnable = true;
			else
				if(dwIsAddOnLoaded("Gladius"))then
					Gladius:Toggle(false);
				end
				lGladiusEnable = false;
			end
		end
	);
		
	dwRegisterButton(
		"ArenaMod",
		ARENA_MOD_GLADIUS_OPTION, 
		function()
			if (not dwIsAddOnLoaded("Gladius")) then
				dwLoadAddOn("Gladius");
				if (lGladiusEnable) then
					Gladius:Toggle(true);
				end
			end
			if (dwIsAddOnLoaded("Gladius")) then
				
				Gladius:ShowOptions();
			end
		end, 
		1
	);
end

if (dwIsConfigurableAddOn("GladiatorlosSA")) then
	dwRegisterCheckButton(
		"ArenaMod",
		ARENA_MOD_GLADIATORLOSSA_ENABLE,
		nil,
		"GladiatorlosSA",
		1,
		function (arg)
			if(arg==1)then
				if(not dwIsAddOnLoaded("GladiatorlosSA") and IsInArena)then
					dwLoadAddOn("GladiatorlosSA");
				end
				if (dwIsAddOnLoaded("GladiatorlosSA")) then
					GladiatorlosSA:Toggle(true);
				end
			else
				if(dwIsAddOnLoaded("GladiatorlosSA"))then
					GladiatorlosSA:Toggle(false);
				end
			end
		end
	);
		
	dwRegisterButton(
		"ArenaMod",
		ARENA_MOD_GLADIATORLOSSA_OPTION, 
		function()
			if (not dwIsAddOnLoaded("GladiatorlosSA")) then
				dwLoadAddOn("GladiatorlosSA");
			end
			
			if (dwIsAddOnLoaded("GladiatorlosSA")) then
				GladiatorlosSA:ShowConfig();
			end
		end, 
		1
	);
	
	dwRegisterCheckButton(
		"ArenaMod",
		ARENA_MOD_FIRE_ALERTER,
		nil,
		"FireArena0",
		0,
		function (arg)
			if(arg==1)then
				if(not dwIsAddOnLoaded("GladiatorlosSA") and IsInArena)then
					dwLoadAddOn("GladiatorlosSA");
				end
				if (dwIsAddOnLoaded("GladiatorlosSA")) then
					GladiatorlosSA:FireToggle(true);
				end				
			else
				if(dwIsAddOnLoaded("GladiatorlosSA"))then
					GladiatorlosSA:FireToggle(false);
				end
			end
		end
	);
end