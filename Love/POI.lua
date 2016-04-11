local function CreatePOI()
	local f = CreateFrame("Frame", "DWPOI", UIParent)
	f:SetFrameStrata("DIALOG")
	f:SetSize(38,38)
	f:SetPoint("CENTER",0,0)
	
	f.texture = f:CreateTexture(nil, "BACKGROUND")
	f.texture:SetTexture("Interface\\Common\\UI-ModelControlPanel")
	f.texture:SetTexCoord(0.57812500, 0.82812500, 0.14843750, 0.27343750);
	f.texture:SetAllPoints(f)
	f.texture:SetVertexColor(0.5, 1, 1)
	
	f:Hide()
	
	return f
end

function ToggleDWPoi(toggle)
	local combat = true;
	if toggle then
		DWPOI = DWPOI or CreatePOI();
		if combat then
			DWPOI:RegisterEvent("PLAYER_REGEN_ENABLED")
			DWPOI:RegisterEvent("PLAYER_REGEN_DISABLED")
			DWPOI:SetScript("OnEvent", function(self, event)
				if not combat then return; end
				if event == 'PLAYER_REGEN_DISABLED' then
					self:Show()
				else
					self:Hide()
				end
			end)
			DWPOI:Hide();
		else
			DWPOI:UnregisterAllEvents()
			DWPOI:SetScript("OnEvent", nil)
			DWPOI:Show()
		end
	else
		if DWPOI then DWPOI:Hide(); end
	end
end