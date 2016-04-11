-----------------------------------------------------------
-- Duowan Trade skill ver 1.0
-- 日期：2010年8月26日
-- 作者：独孤傲雪
-- 描述：扩展游戏自带的制作面板，并提供技能切换快捷按键
--	2011-10-11: 增加已学配方着色功能
-- 版权所有 (c) duowan.com
-- 感谢TradeTabs 和 TradeskillHD
-----------------------------------------------------------
DuowanTradeskill = LibStub("AceAddon-3.0"):NewAddon("DuowanTradeskill", "AceHook-3.0", "AceEvent-3.0");
local DT = DuowanTradeskill;
DT.tradeSpells = { -- Spell order in this table determines the tab order
	28596, -- Alchemy
	29844, -- Blacksmithing
	28029, -- Enchanting
	30350, -- Engineering
	45357, -- Inscription
	28897, -- Jewel Crafting
	32549, -- Leatherworking
	53428, -- Runeforging
	2656,  -- Smelting
	26790, -- Tailoring
	
	33359, -- Cooking
	27028, -- First Aid
	
	13262, -- Disenchant
	51005, -- Milling
	31252, -- Prospecting
	818,   -- Basic Campfire
};
DT.config = {
	tabs = true,
	double = true,
};
DT.TradeTabs = {};

function DT:OnInitialize()
	dwAsynCall("Blizzard_TradeSkillUI", "DWT_Init");
end

function DT:OnEnable()
	self:ToggleTabs(true);
end

function DT:OnDisable()
	self:ToggleTabs(false);
end

-----------------------
-- 增加制作标签
-----------------------
do
	local function onEnter(self) 
		GameTooltip:SetOwner(self,"ANCHOR_RIGHT");
		GameTooltip:SetText(self.tooltip);
		self:GetParent():LockHighlight();
	end

	local function onLeave(self) 
		GameTooltip:Hide();
		self:GetParent():UnlockHighlight();
	end   

	local function updateSelection(self)
		if IsCurrentSpell(self.spellID,"spell") then
			self:SetChecked(true);
			self.clickStopper:Show();
		else
			self:SetChecked(false);
			self.clickStopper:Hide();
		end
	end

	local function createClickStopper(button)
		local f = CreateFrame("Frame",nil,button);
		f:SetAllPoints(button);
		f:EnableMouse(true);
		f:SetScript("OnEnter",onEnter);
		f:SetScript("OnLeave",onLeave);
		button.clickStopper = f;
		f.tooltip = button.tooltip;
		f:Hide();
	end

	function DT:CreateTab(spell, spellID, parent)
		local button = CreateFrame("CheckButton", nil, parent, "SpellBookSkillLineTabTemplate,SecureActionButtonTemplate");
		button.tooltip = spell;
		button:Show();
		button:SetAttribute("type","spell");
		button:SetAttribute("spell",spell);
		button.spellID = spellID;
		button:SetNormalTexture(GetSpellTexture(spellID, "spell"));
		
		button:SetScript("OnEvent", updateSelection);
		button:RegisterEvent("TRADE_SKILL_SHOW");
		button:RegisterEvent("TRADE_SKILL_CLOSE");
		button:RegisterEvent("CURRENT_SPELL_CAST_CHANGED");

		createClickStopper(button);
		updateSelection(button);
		return button;
	end
end

function DT:InitTabs()
	if self.initialized then return end
	
	local name2id = {};
	for i=1, #(self.tradeSpells) do
		local n = GetSpellInfo(self.tradeSpells[i]);	
		name2id[n] = -1;
		self.tradeSpells[i] = n;
	end
	
	local parent = TradeSkillFrame;
	if SkilletFrame then
		parent = SkilletFrame;
		self:UnregisterAllEvents();
	end

	local tradeSkillIDTbl = {GetProfessions()};
	for _, index in ipairs(tradeSkillIDTbl) do
		local numSpells, spelloffset = select(5, GetProfessionInfo(index));
		for i=1, numSpells do
			local name = GetSpellInfo(i+spelloffset, "spell");
			if (name and name2id[name]) then
				name2id[name] = i+spelloffset;
			end
		end		
	end
	
	local prev;
	for i,spell in ipairs(self.tradeSpells) do
		local spellid = name2id[spell];
		if spellid and type(spellid) == "number" and spellid > 0 then	
			local tab = self:CreateTab(spell,spellid,parent);
			table.insert(self.TradeTabs, tab);
			local point,relPoint,x,y = "TOPLEFT","BOTTOMLEFT",0,-15;
			if not prev then
				prev,relPoint,x,y = parent,"TOPRIGHT",0,-44;
				if parent == SkilletFrame then x = 0; end
			end
			tab:SetPoint(point, prev, relPoint, x, y);
			prev = tab;
		end
	end

	if (not self.enableTabs) then
		for i, button in ipairs(self.TradeTabs) do
			button:UnregisterEvent("TRADE_SKILL_SHOW");
			button:UnregisterEvent("TRADE_SKILL_CLOSE");
			button:UnregisterEvent("CURRENT_SPELL_CAST_CHANGED");
			button:Hide();
		end
	end
	
	self.initialized = true;
end

function DWT_Init()
	dwSecureCall(DuowanTradeskill.InitTabs, DuowanTradeskill);
end

function DT:ToggleTabs(switch)
	if (switch) then
		if (self.initialized) then
			for i, button in ipairs(self.TradeTabs) do				
				button:RegisterEvent("TRADE_SKILL_SHOW");
				button:RegisterEvent("TRADE_SKILL_CLOSE");
				button:RegisterEvent("CURRENT_SPELL_CAST_CHANGED");
				button:Show();
			end
		else
			self.enableTabs = true;
		end
	else
		if (self.initialized) then
			for i, button in ipairs(self.TradeTabs) do				
				button:UnregisterEvent("TRADE_SKILL_SHOW");
				button:UnregisterEvent("TRADE_SKILL_CLOSE");
				button:UnregisterEvent("CURRENT_SPELL_CAST_CHANGED");
				button:Hide();
			end
		else
			self.enableTabs = false;
		end
	end
end

---------------------
-- 已学配方着色
---------------------

local COLOR = { r = 0.1, g = 1.0, b = 0.1 }

-- end of config.


-- things we have to care. please let me know if any lack or surplus here. Or should we check "GetAuctionItemSubClasses" ?
local WEAPON, ARMOR, CONTAINER, CONSUMABLE, GLYPH, TRADE_GOODS, RECIPE, GEM, MISCALLANEOUS, QUEST = GetAuctionItemClasses()
local KNOWABLES = { [CONSUMABLE] = true, [GLYPH] = true, [RECIPE] = true, [MISCALLANEOUS] = true }

-- is it already known ?
local f = CreateFrame("GameTooltip")
f:SetOwner(WorldFrame, "ANCHOR_NONE")

local lines = {}
for i=1, 40 do
   lines[i] = f:CreateFontString()
   f:AddFontStrings(lines[i], f:CreateFontString())
end

local knowns, id = {}
function DT:isKnown(link)
   id = strmatch(link, "item:(%d+):")
   if ( not id ) then
      return false
   end
   if ( knowns[id] ) then
      return true
   end

   f:ClearLines()
   f:SetHyperlink(link)
   for i=1, f:NumLines() do
      if ( lines[i]:GetText() == ITEM_SPELL_KNOWN ) then
         knowns[id] = true
         return true
      end
   end
   return false
end

-- just like default game UI does ...
local numItems, offset, index, link, merchantButton, itemButton

function DT:MerchantFrame_UpdateMerchantInfo()
   numItems = GetMerchantNumItems()
   for i=1, MERCHANT_ITEMS_PER_PAGE do
      index = (((MerchantFrame.page - 1) * MERCHANT_ITEMS_PER_PAGE) + i)
      if ( index <= numItems ) then
         link = GetMerchantItemLink(index)
         if ( link and KNOWABLES[select(6, GetItemInfo(link))] and self:isKnown(link) ) then
            merchantButton, itemButton = _G["MerchantItem" .. i], _G["MerchantItem" .. i .. "ItemButton"]
            if ( select(5, GetMerchantItemInfo(index)) == 0 ) then -- out of stock.
               SetItemButtonNameFrameVertexColor(merchantButton, COLOR.r * 0.5, COLOR.g * 0.5, COLOR.b * 0.5)
               SetItemButtonSlotVertexColor(merchantButton, COLOR.r * 0.5, COLOR.g * 0.5, COLOR.b * 0.5)
               SetItemButtonTextureVertexColor(itemButton, COLOR.r * 0.5, COLOR.g * 0.5, COLOR.b * 0.5)
               SetItemButtonNormalTextureVertexColor(itemButton, COLOR.r * 0.5, COLOR.g * 0.5, COLOR.b * 0.5)
            else
               SetItemButtonNameFrameVertexColor(merchantButton, COLOR.r, COLOR.g, COLOR.b)
               SetItemButtonSlotVertexColor(merchantButton, COLOR.r, COLOR.g, COLOR.b)
               SetItemButtonTextureVertexColor(itemButton, COLOR.r, COLOR.g, COLOR.b)
               SetItemButtonNormalTextureVertexColor(itemButton, COLOR.r, COLOR.g, COLOR.b)
            end
         end
      end
   end
end

function DT:AuctionFrameBrowse_Update()
   numItems, offset = GetNumAuctionItems("list"), FauxScrollFrame_GetOffset(BrowseScrollFrame)
   for i=1, NUM_BROWSE_TO_DISPLAY do
      index = offset + i + (NUM_AUCTION_ITEMS_PER_PAGE * AuctionFrameBrowse.page)
      if ( index <= (numItems + (NUM_AUCTION_ITEMS_PER_PAGE * AuctionFrameBrowse.page)) ) then
         link = GetAuctionItemLink("list", offset + i)
         if ( link and KNOWABLES[select(6, GetItemInfo(link))] and self:isKnown(link) ) then
            _G["BrowseButton" .. i .. "ItemIconTexture"]:SetVertexColor(COLOR.r, COLOR.g, COLOR.b)
         end
      end
   end
end

function DT:AuctionFrameBid_Update()
   numItems, offset = GetNumAuctionItems("bidder"), FauxScrollFrame_GetOffset(BidScrollFrame)
   for i=1, NUM_BIDS_TO_DISPLAY do
      index = offset + i
      if ( index <= numItems ) then
         link = GetAuctionItemLink("bidder", index)
         if ( link and KNOWABLES[select(6, GetItemInfo(link))] and self:isKnown(link) ) then
            _G["BidButton" .. i .. "ItemIconTexture"]:SetVertexColor(COLOR.r, COLOR.g, COLOR.b)
         end
      end
   end
end

function DT:AuctionFrameAuctions_Update()
   numItems, offset = GetNumAuctionItems("owner"), FauxScrollFrame_GetOffset(AuctionsScrollFrame)
   for i=1, NUM_AUCTIONS_TO_DISPLAY do
      index = offset + i + (NUM_AUCTION_ITEMS_PER_PAGE * AuctionFrameAuctions.page)
      if ( index <= (numItems + (NUM_AUCTION_ITEMS_PER_PAGE * AuctionFrameAuctions.page)) ) then
         if ( select(16, GetAuctionItemInfo("owner", offset + i)) ~= 1 ) then -- not sold item.
            link = GetAuctionItemLink("owner", offset + i)
            if ( link and KNOWABLES[select(6, GetItemInfo(link))] and self:isKnown(link) ) then
               _G["AuctionsButton" .. i .. "ItemIconTexture"]:SetVertexColor(COLOR.r, COLOR.g, COLOR.b)
            end
         end
      end
   end
end

function DT_HookAuctionProfile(switch)	
	if (switch) then
		DT:SecureHook("AuctionFrameBrowse_Update");
		DT:SecureHook("AuctionFrameBid_Update");
		DT:SecureHook("AuctionFrameAuctions_Update");
	else
		DT:Unhook("AuctionFrameBrowse_Update");
		DT:Unhook("AuctionFrameBid_Update");
		DT:Unhook("AuctionFrameAuctions_Update");
	end
end

function DT:ToggleProfileColor(switch)
	if (switch) then		
		self:SecureHook("MerchantFrame_UpdateMerchantInfo", "MerchantFrame_UpdateMerchantInfo");
		if ( MerchantFrame:IsVisible() and MerchantFrame.selectedTab == 1 ) then
			self:MerchantFrame_UpdateMerchantInfo();
		end
	else
		self:Unhook("MerchantFrame_UpdateMerchantInfo");
	end
	dwAsynCall("Blizzard_AuctionUI", "DT_HookAuctionProfile", switch);
end