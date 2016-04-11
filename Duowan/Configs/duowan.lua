------------------------------------
-- dugu 2009-12-22

if (GetLocale() == "zhCN") then
	DUOWAN_TITLE = "基本设置";
	DUOWAN_MAX_CAMERA = "开启超远视距"
	DUOWAN_NEWBIE = "[官方]新兵助手"
	DUOWAN_NEWBIE_TIPS = "网易官方提供的新兵助手插件"	
	DUOWAN_MYSLOT_ENABLE = "开启按键设置保存功能";
	DUOWAN_MYSLOT_TOOLTIP= "记忆、恢复、保存、载入您的按键设置";
	DUOWAN_MYSLOT_TITAN_TEXT = "显示泰坦信息条按钮";
	DUOWAN_MYSLOT_PROXMIO = "管理配置";
elseif (GetLocale() == "zhTW") then
	DUOWAN_TITLE = "基本設置";
	DUOWAN_MAX_CAMERA = "開啟超遠視距"
	DUOWAN_NEWBIE = "[官方]新兵助手"
	DUOWAN_NEWBIE_TIPS = "網易官方提供的新兵助手外掛程式"
	DUOWAN_MYSLOT_ENABLE = "開啟按鍵設置保存功能";
	DUOWAN_MYSLOT_TOOLTIP= "記憶、恢復、保存、載入您的按鍵設置";
	DUOWAN_MYSLOT_TITAN_TEXT = "顯示泰坦諮詢條按鈕";
	DUOWAN_MYSLOT_PROXMIO = "管理配置";
else
	DUOWAN_TITLE = "基本设置";
	DUOWAN_MAX_CAMERA = "开启超远视距"
	DUOWAN_NEWBIE = "[官方]新兵助手"
	DUOWAN_NEWBIE_TIPS = "网易官方提供的新兵助手插件"
	DUOWAN_MYSLOT = "开启按键设置保存功能";
	DUOWAN_MYSLOT_TOOLTIP= "记忆、恢复、保存、载入您的按键设置";
	DUOWAN_MYSLOT_TITAN_TEXT = "显示泰坦信息条按钮";
	DUOWAN_MYSLOT_PROXMIO = "管理配置";
end


dwRegisterMod(
	"DuowanMod",
	DUOWAN_TITLE,
	"DuowanMod",
	"",
	"Interface\\AddOns\\Duowan\\UiLogo",
	nil
);

do
	function ToggleMaxCamera(switch)
		if (switch) then
			SetCVar("cameraDistanceMax", 50);	
			SetCVar("cameraDistanceMaxFactor", 4);
		else
			SetCVar("cameraDistanceMax", 15);	
			SetCVar("cameraDistanceMaxFactor", 1);
		end
	end

	local defVal = dwRawGetCVar("LoveMod", "maxcamera", 1);
	dwRegisterCheckButton(
		"DuowanMod",
		DUOWAN_MAX_CAMERA,
		nil,
		"EnableMaxCamara",
		defVal,
		function (arg)
			if (arg == 1) then
				ToggleMaxCamera(true);
			else				
				ToggleMaxCamera(false);		
			end
		end
	);
end

if (dwIsConfigurableAddOn("NewbieAssistant")) then
	defVal = dwRawGetCVar("DuowanMod", "EnableNewbieAssist", 1);
	if (UnitLevel("player") >= 20) then
		dwSetCVar("DuowanMod", "EnableNewbieAssist", 0);
		defVal = 0;
	end

	dwRegisterCheckButton(
		"DuowanMod",
		DUOWAN_NEWBIE,
		DUOWAN_NEWBIE_TIPS,
		"EnableNewbieAssist",
		defVal,
		function (arg)
			if (arg == 1) then
				if (not dwIsAddOnLoaded("NewbieAssistant")) then
					dwLoadAddOn("NewbieAssistant");
				end		
			else		
				if (dwIsAddOnLoaded("NewbieAssistant")) then
					dwRequestReloadUI(nil);
				end
			end
		end
	);	
end

if (dwIsConfigurableAddOn("MySlot")) then
	dwRegisterCheckButton(
		"DuowanMod",
		DUOWAN_MYSLOT_ENABLE,
		DUOWAN_MYSLOT_TOOLTIP,
		"EnableMySlotNew",
		0,
		function (arg)	
			if(arg==1)then
				if (not dwIsAddOnLoaded("MySlot")) then
					dwLoadAddOn("MySlot");
				end				
			else
				if (dwIsAddOnLoaded("MySlot")) then
					dwRequestReloadUI(nil);
				end
			end
		end
	);
	dwRegisterCheckButton(
		"DuowanMod",
		DUOWAN_MYSLOT_TITAN_TEXT,
		nil,
		"MySlotTitanButton",
		1,
		function (arg)	
			if(arg==1)then
				if (dwIsAddOnLoaded("MySlot")) then
					MYSLOT_ShowTitanButton(true);
				end				
			else
				if (dwIsAddOnLoaded("MySlot")) then
					MYSLOT_ShowTitanButton(false);
				end
			end
		end,
		1
	);
	
	dwRegisterButton(
		"DuowanMod",
		DUOWAN_MYSLOT_PROXMIO, 
		function()	
			if (dwIsAddOnLoaded("MySlot")) then	
				ShowUIPanel(MYSLOT_ReportFrame);
			end
		end, 
		1
	);
end