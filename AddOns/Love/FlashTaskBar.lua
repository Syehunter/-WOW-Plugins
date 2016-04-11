

local FlashTaskBar = CreateFrame ("frame", "FlashTaskBar", UIParent)
FlashTaskBar.last_flash = 0

FlashTaskBar:RegisterEvent ("ADDON_LOADED")
FlashTaskBar:RegisterEvent ("READY_CHECK")

local default_config = {
					ready_check = true,
					arena_queue = true,
					bg_queue = true,
				}

function FlashTaskBar:DoFlash()
	if (FlashTaskBar.last_flash + 5 < GetTime()) then
		FlashClientIcon()
		FlashTaskBar.last_flash = GetTime()
	end
end

FlashTaskBar:SetScript ("OnEvent", function (self, event, ...)
	
	if (event == "ADDON_LOADED") then
		local addon_name = select (1, ...)
		if (addon_name == "Love") then
			FlashTaskBar.db = FlashTaskbarDB
			if (not FlashTaskBar.db) then
				FlashTaskBar.db = {}
				FlashTaskbarDB = FlashTaskBar.db
			end
			
			for key, value in pairs (default_config) do
				if (FlashTaskBar.db [key] == nil) then
					FlashTaskBar.db [key] = value
				end
			end
		end
		
		hooksecurefunc ("LFGDungeonReadyStatus_ResetReadyStates", function()
			FlashTaskBar:DoFlash()
		end)
		hooksecurefunc ("PVPReadyDialog_Display", function()
			FlashTaskBar:DoFlash()
		end)
		
	elseif (event == "READY_CHECK") then
		FlashTaskBar:DoFlash()
	end
	
end)