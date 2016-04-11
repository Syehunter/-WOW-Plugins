-- Author: Ooshjoxa - Wildhammer, formerly known as Ashkar - Azjol-Nerub.
-- Version: 2.2
-- Rewrite by eui.cc at 2015.02.03
local frame = CreateFrame("Frame", "DWBODYGUARDAWAY");
local firsttime = true

-- Array of bodyguards
local BodyGuardList = {
	86682, -- Tormmok
	86927, -- Delvar
	86964, -- Leorajh
	86946, -- Ishaal
	86934, -- Illona
	86945, -- Aeda Brightdawn !!UNTESTED!!   
	86933, -- Vivianne !!UNTESTED!!
	27914  -- Ethereal Soul-Trader
}

-- Check 'em.
local function CheckForBodyGuard()
	local TargetGUID = UnitGUID("target")

	if not TargetGUID then return end

	local unittype, _, _, _, _, NPCID = strsplit('-', TargetGUID)

	if unittype == "Creature" then
		-- Iterate through bodyguards.
		for i, bodyguard in ipairs(BodyGuardList) do
			if tonumber(NPCID) == bodyguard then
				CloseGossip();
			end
		end
	end
end

-- Parse commands
function DWBODYGUARDAWAY:Toggle(toggle)
	if toggle == 1 then
		frame:RegisterEvent("GOSSIP_SHOW")
		frame:SetScript("OnEvent", function()
			if not IsControlKeyDown() then
				CheckForBodyGuard();
			end
		end)
	else
		frame:UnregisterAllEvents();
		frame:SetScript("OnEvent", nil)
	end
end

DWBODYGUARDAWAY:Toggle(dwGetCVar('Garrison', 'EnableDWBODYGUARDAWAY'))