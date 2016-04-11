------------------------------------
-- dugu 2009-6-9
if (GetLocale() == "zhCN") then
	AUCTION_MOD_TITLE = "拍卖助手";
	AUCTION_MOD_ENABLE = "开启拍卖助手"
	AUCTION_MOD_ENABLE_DESC = "扫描并分析拍卖行物品价格"
	AUCTION_MOD_CLEAR_DATA = "清空数据";
	AUCTION_MOD_OPTION = "更多设置";
	ITEMS_FENCE_AUTION_INFO = "显示物品拍卖行信息";
	BLACKMARKET_MOD_ENABLE = "开启离线黑市";
	BLACKMARKET_MOD_OPEN = "查看黑市";	
elseif (GetLocale() == "zhTW") then
	AUCTION_MOD_TITLE = "拍賣助手";
	AUCTION_MOD_ENABLE = "開啟拍賣助手"
	AUCTION_MOD_ENABLE_DESC = "掃描並分析拍賣行物品價格"
	AUCTION_MOD_CLEAR_DATA = "清空數據";
	AUCTION_MOD_OPTION = "更多設置";
	ITEMS_FENCE_AUTION_INFO = "顯示物品拍賣行諮詢";
	BLACKMARKET_MOD_ENABLE = "開啟離線黑市";
	BLACKMARKET_MOD_OPEN = "查看黑市";	
else
	AUCTION_MOD_TITLE = "拍卖助手";
	AUCTION_MOD_ENABLE = "开启拍卖助手"
	AUCTION_MOD_ENABLE_DESC = "扫描并分析拍卖行物品价格"
	AUCTION_MOD_CLEAR_DATA = "清空数据";
	AUCTION_MOD_OPTION = "更多设置";
	ITEMS_FENCE_AUTION_INFO = "显示物品拍卖行信息";
	BLACKMARKET_MOD_ENABLE = "开启离线黑市";
	BLACKMARKET_MOD_OPEN = "查看黑市";	
end

if (dwIsConfigurableAddOn("Fence") or dwIsConfigurableAddOn("DuowanBlackMarket")) then
	dwRegisterMod(
		"AuctionMod",
		AUCTION_MOD_TITLE,
		"Fence",
		"",
		"Interface\\ICONS\\Spell_Holy_HopeAndGrace",
		nil
	);	
end

if (dwIsConfigurableAddOn("Fence")) then
	local frame = CreateFrame("Frame");
	frame:RegisterEvent("ADDON_LOADED");
	local lEnableMailMod = false;
	local lEventFired = false;

	frame:SetScript("OnEvent", function(self, event, addon)
		if (addon == "Blizzard_AuctionUI") then
			lEventFired = true;
			if (not dwIsAddOnLoaded("Fence") and lEnableMailMod) then
				dwLoadAddOn("Fence");
			end
			self:UnregisterEvent("ADDON_LOADED");
		end		
	end)
	
	dwRegisterCheckButton(
		"AuctionMod",
		AUCTION_MOD_ENABLE,
		AUCTION_MOD_ENABLE_DESC,
		"EnableAuctionMod",
		1,
		function (arg)	
			if (arg == 1) then
				if (not dwIsAddOnLoaded("Fence") and lEventFired) then
					dwLoadAddOn("Fence");
				end
				if (dwIsAddOnLoaded("Fence")) then
					Fence_Toggle(true);
				end
				lEnableMailMod = true;				
			else
				if (dwIsAddOnLoaded("Fence")) then
					dwRequestReloadUI(nil);
				end
				lEnableMailMod = false;
			end
		end
	);
	dwRegisterCheckButton(
		"AuctionMod",
		ITEMS_FENCE_AUTION_INFO,
		nil,
		"AuctionInfo",
		1,
		function (arg)		
			if (arg == 1) then
				if (dwIsAddOnLoaded("Fence")) then
					Fence_ShowTooltipInfo(true);
				end
			else
				if (dwIsAddOnLoaded("Fence")) then
					Fence_ShowTooltipInfo(false);
				end	
			end
		end,
		1
	);
	dwRegisterButton(
		"AuctionMod",
		AUCTION_MOD_OPTION, 
		function()
			if (not dwIsAddOnLoaded("Fence")) then
				dwLoadAddOn("Fence");
			end
			if (dwIsAddOnLoaded("Fence")) then				
				InterfaceOptionsFrame_OpenToCategory(AuctionLite.optionFrames.main);
			end
		end, 
		1
	);

	dwRegisterButton(
		"AuctionMod",
		AUCTION_MOD_CLEAR_DATA, 
		function()
			if (not dwIsAddOnLoaded("Fence")) then
				dwLoadAddOn("Fence");
			end
			if (dwIsAddOnLoaded("Fence")) then				
				Fence_ClearData();
			end
		end, 
		1
	);
end

if (dwIsConfigurableAddOn("DuowanBlackMarket")) then
	dwRegisterCheckButton(
		"AuctionMod",
		BLACKMARKET_MOD_ENABLE,
		nil,
		"BlackMarket",
		1,
		function (arg)		
			if (arg == 1) then				
				if (not dwIsAddOnLoaded("DuowanBlackMarket")) then
					dwLoadAddOn("DuowanBlackMarket");
				end				
			else				
				if (dwIsAddOnLoaded("DuowanBlackMarket")) then
					dwRequestReloadUI(nil);
				end
			end
		end
	);
	dwRegisterButton(
		"AuctionMod",
		BLACKMARKET_MOD_OPEN, 
		function()
			if (not dwIsAddOnLoaded("DuowanBlackMarket")) then
				dwLoadAddOn("DuowanBlackMarket");
			end		
			if BlackMarketFrame and BlackMarketFrame:IsShown() then
				HideUIPanel(BlackMarketFrame)
			else
				HideUIPanel(DuowanConfigFrame);
				BigFootBank_OffLineUpdata()
			end
		end, 
		1
	);
end