--[[
	TitanGarrisonResources: A simple display of your current Garrison Resources value.
	Author: Canettieri, Eliote
	
	Base written by subwired.
--]]

-- Default language (enUS)
local L = {}
L["buttonLabel"] = "Resources: "
L["tooltipTitle"] = "Garrison Resources"
L["tooltipDescription"] = "Earn resources to build-up and\rexpand your garrison."
L["tooltipCountLabel"] = "Total Maximum: "
if GetLocale() == 'zhCN' then
	L["buttonLabel"] = "物资: "
	L["tooltipTitle"] = "要塞物资"
	L["tooltipDescription"] = "从建筑物中获得\r从要塞任务中获得."
	L["tooltipCountLabel"] = "总量: "
elseif GetLocale() == 'zhTW' then
	L["buttonLabel"] = "物資: "
	L["tooltipTitle"] = "要塞物資"
	L["tooltipDescription"] = "從建築物中獲得\r 從要塞任務中獲得."
	L["tooltipCountLabel"] = "總量: "
end


local menutext = "Titan|cffff8800 "..L["tooltipTitle"].."|r"
local ID = "GR"
local elap, currencyCount = 0, 0.0
local currencyMaximum

-- Main button frame and addon base
local f = CreateFrame("Button", "TitanPanelGRButton", CreateFrame("Frame", nil, UIParent), "TitanPanelComboTemplate")
f:SetFrameStrata("FULLSCREEN")
f:SetScript("OnEvent", function(this, event, ...) this[event](this, ...) end)
f:RegisterEvent("ADDON_LOADED")


function f:ADDON_LOADED(a1)
--print ("a1 = " .. a1)
	if a1 ~= "Titan" then -- needs to be the name of the folder that the addon is in
	return 
	end
	self:UnregisterEvent("ADDON_LOADED")
	self.ADDON_LOADED = nil
	
	-- Other languages
	if GetLocale() == "ptBR" then
		L["buttonLabel"] = "Recursos: "
		L["tooltipTitle"] = "Recursos da Guarnição"
		L["tooltipDescription"] = "Ganhe recursos para expandir ou\rconstruir sua Guarnição."
		L["tooltipCountLabel"] = "Máximo total: "
	end

	local name, isHeader, isExpanded, isUnused, isWatched, count, icon, maximum, hasWeeklyLimit, currentWeeklyAmount, unknown
	local i = 0
	local CurrencyIndex = 0
	local myicon = "Interface\\Icons\\inv_garrison_resource.blp"
	local mycheck = "Interface\\Icons\\Inv_Garrison_Resource"

	self.registry = {
		id = ID,
		menuText = menutext,
		buttonTextFunction = "TitanPanelGRButton_GetButtonText",
		tooltipTitle = L["tooltipTitle"],
		tooltipTextFunction = "TitanPanelGRButton_GetTooltipText",
		frequency = 2,
		icon = myicon,
		iconWidth = 16,
		category = "Information",
		savedVariables = {
			ShowIcon = 1,
			ShowLabelText = false,

		},
	}
	self:SetScript("OnUpdate", function(this, a1)
		elap = elap + a1
		if elap < 1 then return end

		for i = 1, GetCurrencyListSize(), 1 do
			
			name, isHeader, isExpanded, isUnused, isWatched, count, icon, maximum, hasWeeklyLimit, currentWeeklyAmount, unknown = GetCurrencyListInfo(i)
			
			if string.lower(tostring(icon)) == string.lower(mycheck) then
				CurrencyIndex = i
			end
			
		end
		
		name, isHeader, isExpanded, isUnused, isWatched, count, icon, maximum, hasWeeklyLimit, currentWeeklyAmount, unknown = GetCurrencyListInfo(CurrencyIndex)

		 currencyCount = count
		currencyMaximum = maximum
		
		TitanPanelButton_UpdateButton(ID)
		elap = 0
	end)
		
	--TitanPanelButton_OnLoad(self)
end


----------------------------------------------
function TitanPanelGRButton_GetButtonText()
----------------------------------------------
	local currencyCountText
	if not currencyCount then
		currencyCountText = TitanUtils_GetHighlightText("0")
	else	
		currencyCountText = TitanUtils_GetHighlightText(string.format("%.0f", currencyCount) .."")
	end
	return L["buttonLabel"], currencyCountText
end

-----------------------------------------------
function TitanPanelGRButton_GetTooltipText() --Thanks to my friend, Eliote
-----------------------------------------------
	local valorAtual = TitanUtils_GetHighlightText(Util_StringComDefault(currencyCount, "0"))
	local valorMaximo = TitanUtils_GetHighlightText(Util_StringComDefault(currencyMaximum, "0"))
	
	return L["tooltipDescription"].."\r\r"..L["tooltipCountLabel"]..valorAtual.." / "..valorMaximo
end

local temp = {}
local function UIDDM_Add(text, func, checked, keepShown)
	temp.text, temp.func, temp.checked, temp.keepShownOnClick = text, func, checked, keepShown
	UIDropDownMenu_AddButton(temp)
end
----------------------------------------------------
function TitanPanelRightClickMenu_PrepareGRMenu()
----------------------------------------------------
	TitanPanelRightClickMenu_AddTitle(TitanPlugins[ID].menuText)
	
	TitanPanelRightClickMenu_AddToggleIcon(ID)
	TitanPanelRightClickMenu_AddToggleLabelText(ID)
	TitanPanelRightClickMenu_AddSpacer()
	TitanPanelRightClickMenu_AddCommand(TITAN_PANEL_MENU_HIDE, ID, TITAN_PANEL_MENU_FUNC_HIDE)
end

----------------------------------------------------
function Util_StringComDefault(v,d)
----------------------------------------------------
	if not v then
		return d
	end
	
	return v
end