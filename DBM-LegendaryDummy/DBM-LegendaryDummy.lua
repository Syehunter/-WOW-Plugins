do
	local L = {}
	if GetLocale() == 'zhCN' then
		L["Equip your legendary ring (it's in your bags)! "] = "装备你的传奇戒指"
		L["Equipped ring "] = "装备的戒指 "
		L[" does not match your chosen role."] = " 不匹配你的职责."
		L["/dbm legendarydummy warning <on|off>: enable or disable the warning sound accompaning the message. (Default: on)"] = "/dbm legendarydummy warning <on|off>: 启用或禁用信息警告音.(默认启用)"
		L["/dbm legendarydummy playsound: Plays the configured warning sound."] = "/dbm legendarydummy playsound: 播放设置的警告音."
		L["Warning sound: enabled"] = "警告音：启用"
		L["Warning sound: disabled"] = "警告音: 禁用"
		L["Playing warning sound"] = "播放警告音"
		L["Unknown command, see /dbm help"] = "未知的命令, 看 /dbm help"
	elseif GetLocale() == 'zhTW' then
		L["Equip your legendary ring (it's in your bags)! "] = "裝備你的傳奇戒指"
		L["Equipped ring "] = "裝備的戒指 "
		L[" does not match your chosen role."] = " 不匹配你的職責."
		L["/dbm legendarydummy warning <on|off>: enable or disable the warning sound accompaning the message. (Default: on)"] = "/dbm legendarydummy warning <on|off>: 啟用或禁用資訊警告音.(默認啟用)"
		L["/dbm legendarydummy playsound: Plays the configured warning sound."] = "/dbm legendarydummy playsound: 播放設置的警告音."
		L["Warning sound: enabled"] = "警告音：啟用"
		L["Warning sound: disabled"] = "警告音: 禁用"
		L["Playing warning sound"] = "播放警告音"
		L["Unknown command, see /dbm help"] = "未知的命令, 看 /dbm help"
	else
		L["Equip your legendary ring (it's in your bags)! "] = "Equip your legendary ring (it's in your bags)! "
		L["Equipped ring "] = "Equipped ring ";
		L[" does not match your chosen role."] = " does not match your chosen role."
		L["/dbm legendarydummy warning <on|off>: enable or disable the warning sound accompaning the message. (Default: on)"] = "/dbm legendarydummy warning <on|off>: enable or disable the warning sound accompaning the message. (Default: on)"
		L["/dbm legendarydummy playsound: Plays the configured warning sound."] = "/dbm legendarydummy playsound: Plays the configured warning sound."
		L["Warning sound: enabled"] = "Warning sound: enabled"
		L["Warning sound: disabled"] = "Warning sound: disabled"
		L["Playing warning sound"] = "Playing warning sound"
		L["Unknown command, see /dbm help"] = "Unknown command, see /dbm help"
	end

	local frame = CreateFrame("Frame", "DBM-LegendaryDummy"); -- Need a frame to respond to events
	frame:RegisterEvent("ADDON_LOADED"); -- Fired when saved variables are loaded
	function frame:OnEvent(event, arg1)
		if event == "ADDON_LOADED" and arg1 == "DBM-LegendaryDummy" then
			-- Our saved variables are ready at this point. If there are none, both variables will set to nil.
			if DBMLegendaryDummyDB == nil then -- intialize DB
				DBMLegendaryDummyDB = { warning = true} 
			end
		end
	end
	frame:SetScript("OnEvent", frame.OnEvent);

    local dbmCmdHandler = SlashCmdList["DEADLYBOSSMODS"];
    if dbmCmdHandler == nil then return end

	local rings = {
		["TANK"] = 124637,
		["DAMAGER-INT"] = 124635,
		["DAMAGER-AGI"] = 124636,
		["DAMAGER-STR"] = 124634,
		["HEALER"] = 124638
	}

    SlashCmdList["DEADLYBOSSMODS"] = function(msg, ...)
		local function PrintMessage(message)
			DBM:AddMsg(RED_FONT_COLOR_CODE .. ">>> " .. FONT_COLOR_CODE_CLOSE .. message .. RED_FONT_COLOR_CODE .. " <<<" .. FONT_COLOR_CODE_CLOSE, "DBM-LegendaryDummy")
		end
		
		local function GetItemIdFromLink(link)
			if(link) then
				return select(3, strfind(link, "item:(%d+)"))
			end
		end
		
		local function ScanBagsForItem(itemId)
			for b=0,NUM_BAG_SLOTS do 
				for s = 1, GetContainerNumSlots(b) do 
					local link = GetContainerItemLink(b, s)
					local id = GetItemIdFromLink(link)
					if(id == tostring(itemId)) then
						return link
					end
				end 
			end
		end
		
		local function ScanCharacterForItem(itemId)
			for _,slot in pairs({INVSLOT_FINGER1, INVSLOT_FINGER2}) do
				local link = GetInventoryItemLink("player", slot)
				local id = GetItemIdFromLink(link)
				if(id == tostring(itemId)) then
					return link
				end
			end
		end
		
		local function PlaySpecialWarningSound(override)
			if (DBMLegendaryDummyDB.warning == nil or DBMLegendaryDummyDB.warning or override) then DBM:PlaySpecialWarningSound(1) end
		end
		
       	local cmd = msg:lower()
        if cmd:sub(1, 4) == "pull" then
			-- what is my current role?
			local currentRole = UnitGroupRolesAssigned("player")
			-- UnitGroupRolesAssigned only works when grouped
			-- we only really care when we're grouped anyway, I doubt anyone would ever call /dbm pull solo
			if (currentRole ~= nil and currentRole ~= "NONE") then
				local enhancedRole = currentRole
				-- what is my current preferred stat (only important for DAMAGER role)
				if(currentRole == "DAMAGER") then
					local _, str = UnitStat("player", 1);
					local _, agi = UnitStat("player", 2);
					local _, int = UnitStat("player", 4);
					if(str > agi and str > int) then
						enhancedRole = enhancedRole.. "-STR"
					elseif(agi > str and agi > int) then
						enhancedRole = enhancedRole.. "-AGI"
					else
						enhancedRole = enhancedRole.. "-INT"
					end
				end
				
				-- this is the legendary ring we should be expected to wear
				local myLegendaryRing = rings[enhancedRole]

				-- show a warning if I don't have the legendary ring equipped but I have it my bags
				if(not IsEquippedItem(myLegendaryRing) and GetItemCount(myLegendaryRing, false) > 0 ) then
					local link = ScanBagsForItem(myLegendaryRing)
					PrintMessage(L["Equip your legendary ring (it's in your bags)! "]..link)
					PlaySpecialWarningSound()
				else
					-- what if we only bought one legendary ring and we have it equipped but it doesn't match our chosen role
					local otherRingEquipped = false
					for _, otherRing in pairs(rings) do
						if(not otherRingEquipped and otherRing ~= myLegendaryRing and IsEquippedItem(otherRing))then
							otherRingEquipped = true
							local link = ScanCharacterForItem(otherRing)
							PrintMessage(L["Equipped ring "]..link .. L[" does not match your chosen role."])
							PlaySpecialWarningSound()
						end
					end
				end
			end
        end
		
		if cmd:sub(1, 4) == "help" then
			dbmCmdHandler(msg, ...)
			DBM:AddMsg(L["/dbm legendarydummy warning <on|off>: enable or disable the warning sound accompaning the message. (Default: on)"], "DBM-LegendaryDummy")
			DBM:AddMsg(L["/dbm legendarydummy playsound: Plays the configured warning sound."], "DBM-LegendaryDummy")
			return
		end
		
		if cmd:sub(1, 14) == "legendarydummy" then
			local param = cmd:sub(16)
			local warning = param:match("^warning (.*)$")
			if warning == "on" or warning == "true" or warning == "1" then
				DBMLegendaryDummyDB.warning = true
				DBM:AddMsg(L["Warning sound: enabled"], "DBM-LegendaryDummy")
				return
			end
			if warning == "off" or warning == "false" or warning == "0" then
				DBMLegendaryDummyDB.warning = false
				DBM:AddMsg(L["Warning sound: disabled"], "DBM-LegendaryDummy")
				return
			end
			
			if param == "playsound" then
				DBM:AddMsg(L["Playing warning sound"], "DBM-LegendaryDummy")
				PlaySpecialWarningSound(true)
				return
			end
			
			DBM:AddMsg(L["Unknown command, see /dbm help"], "DBM-LegendaryDummy")
			return
		end
		
        return dbmCmdHandler(msg, ...)
    end
end