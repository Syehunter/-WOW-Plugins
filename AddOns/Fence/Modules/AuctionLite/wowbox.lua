--------------------------------------------------
-- patch 


SellItemButton:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	if ( GetAuctionSellItemInfo() ) then
		local name, _, count, _, _, vendor, link = AuctionLite:GetAuctionSellItemInfoAndLink();
		if (link:find("|Hbattlepet:")) then
			dwBattlePetTooltip:SetOwner(self, "ANCHOR_RIGHT");
			dwBattlePetTooltip:SetHyperlink(link);
		else
			GameTooltip:SetAuctionSellItem();
		end		
	else
		GameTooltip:SetText(AUCTION_ITEM_TEXT, 1.0, 1.0, 1.0);
	end
end)

SellItemButton:SetScript("OnLeave", function(self)
	GameTooltip:Hide();
	dwBattlePetTooltip:Hide();
end)

function AuctionLite:SetAuctionLiteTooltip(widget, shift, link, count)
	if link ~= nil and self.db.profile.tooltipLocation ~= "e_hide" then
		local tooltip = GameTooltip;
		if (link:find("|Hbattlepet")) then
			tooltip = dwBattlePetTooltip;
		end
		self:SetHyperlinkTooltips(false);
		if self.db.profile.tooltipLocation == "a_cursor" then
			tooltip:SetOwner(widget, "ANCHOR_TOPLEFT", shift);
		elseif self.db.profile.tooltipLocation == "b_right" then
			tooltip:SetOwner(UIParent, "ANCHOR_NONE");
			tooltip:SetPoint("TOPLEFT", AuctionFrame, "TOPRIGHT", 10, -10);
		elseif self.db.profile.tooltipLocation == "c_below" then
			tooltip:SetOwner(UIParent, "ANCHOR_NONE");
			tooltip:SetPoint("TOPLEFT", AuctionFrame, "BOTTOMLEFT", 10, -30);
		elseif self.db.profile.tooltipLocation == "d_corner" then
			tooltip:SetOwner(UIParent, "ANCHOR_NONE");
			tooltip:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -15, 75);
		else
			assert(false);
		end
		
		tooltip:SetHyperlink(link);
		if tooltip == GameTooltip and GameTooltip:NumLines() > 0 then
			self:AddTooltipData(GameTooltip, link, count);
		end
		self:SetHyperlinkTooltips(true);
	end
end

function AuctionLite:CountItems(targetLink)
  local total = 0;

  if targetLink ~= nil then
    local i, j;
    for i = 0, 4 do
      local numItems = GetContainerNumSlots(i);
      for j = 1, numItems do
	local link = GetContainerItemLink(i, j);
	if (link and not link:find("|Hbattlepet")) then
		link = self:RemoveUniqueId(link);
	end
        if link == targetLink then
          local _, count = GetContainerItemInfo(i, j);
          total = total + count;
        end
      end
    end
  end

  return total;
end