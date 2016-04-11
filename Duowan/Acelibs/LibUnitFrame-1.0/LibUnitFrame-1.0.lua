------------------------------------------------------------------------------
-- 文件名: LibUnitFrame ver 1.0
-- 日期: 2011-04-05
-- 作者: dugu
-- 描述: 重新实现系统头像的一些功能
-- 版权所有 (c) duowan.com
------------------------------------------------------------------------------
DW_PARTYMEMBER_MACRO = "/target party%d";
DW_PARTYTARGET_MACRO ="/target partypet%d";

local SecureCallStack = {};

local UnitFrames = {
	["PlayerFrame"] = "player",
	["PetFrame"] = "pet",
};

local UnitToVehicle = {
	["player"] = "vehicle",
	["pet"] = "player",
};
local AddOns = {"XPerl", "Pitbull4", "ag_Unitframes", "ShadowedUnitFrames", "Perl_Player", "oUF"};
function HasOtherUnitAddOn()
	local name, title, notes, enabled;	
	for k, n in pairs(AddOns) do
		name, title, notes, enabled = GetAddOnInfo(n);
		if (name and enabled) then
			return true;
		end
	end

	return false;
end

local function SecureCall(func, ...)
	if (not InCombatLockdown()) then
		pcall(func, ...);
	else
		local arg1 = ...;
		SecureCallStack[func] = SecureCallStack[func] or {};
		SecureCallStack[func][arg1] = {...};
	end
end

local function DeleteSecureCall(func, ...)
	local arg1 = ...;
	if (SecureCallStack[func] and SecureCallStack[func][arg1]) then
		SecureCallStack[func][arg1] = nil;
	end
end

-- 没有自带头像
if (not HasOtherUnitAddOn()) then
	local VehicleDriverFrame = CreateFrame("Frame", nil, UIParent, "SecureHandlerStateTemplate");
	RegisterStateDriver(VehicleDriverFrame, "vehicle", "[target=vehicle,exists]vehicle;novehicle");
	VehicleDriverFrame:SetAttribute("_onstate-vehicle", [[
		if newstate == "vehicle" then
			for idx, frame in pairs(VEHICLE_FRAMES) do
				frame:SetAttribute("unit", frame:GetAttribute("vehicleUnit"));
			end
		else
			for idx, frame in pairs(VEHICLE_FRAMES) do
				frame:SetAttribute("unit", frame:GetAttribute("normalUnit"));
			end
		end
	]]);

	VehicleDriverFrame:Execute([[
		VEHICLE_FRAMES = newtable();
	]]);

	local function VehicleRegisterFrame(self, unit)
		self:SetAttribute("normalUnit", unit);

		if UnitToVehicle[unit] then
			self:SetAttribute("vehicleUnit", UnitToVehicle[unit]);
		end

		VehicleDriverFrame:SetFrameRef("vehicleFrame", self);
		VehicleDriverFrame:Execute([[
			local frame = self:GetFrameRef("vehicleFrame");
			table.insert(VEHICLE_FRAMES, frame);
		]]);
	end	
	
	function dwFixUnitFrame()
		for name, unit in pairs(UnitFrames) do
			if (_G[name]) then
				VehicleRegisterFrame(_G[name], unit);
				RegisterUnitWatch(_G[name]);
			end
		end
		
		RegisterUnitWatch(_G["TargetFrame"]);

		for i=1, 4 do
			-- boss Frames
			RegisterUnitWatch(_G["Boss"..i.."TargetFrame"]);
			
			local PartyPetDriverFrame = CreateFrame("Frame", "PartyPetDriverFrame"..i, UIParent, "SecureHandlerStateTemplate");
			RegisterStateDriver(_G["PartyPetDriverFrame"..i], "pos", "[target=partypet"..i..",exists]bottom;top");
			PartyPetDriverFrame:SetFrameRef("_PetFrame", _G["PartyMemberFrame"..i.."PetFrame"]);
			PartyPetDriverFrame:SetFrameRef("_partyFrame", _G["PartyMemberFrame"..i]);
			if (i ~= 4) then
				PartyPetDriverFrame:SetFrameRef("_NextFrame", _G["PartyMemberFrame"..(i+1)]);
			end
			PartyPetDriverFrame:SetAttribute("_onstate-pos", [[
				local petFrame = self:GetFrameRef("_PetFrame");
				local partyFrame = self:GetFrameRef("_partyFrame");
				local nextFrame = self:GetFrameRef("_NextFrame");
				petFrame:SetAttribute("unit", "partypet"..partyFrame:GetID());
				partyFrame:SetAttribute("unit", "party"..partyFrame:GetID());
				petFrame:ClearAllPoints();
				if newstate == "bottom" then
					petFrame:SetPoint("TOPLEFT", partyFrame, "TOPLEFT", 23, -43);
				else					
					petFrame:SetPoint("TOPLEFT", partyFrame, "TOPLEFT", 23, -27);
				end
				if (nextFrame) then
					nextFrame:ClearAllPoints();
					nextFrame:SetPoint("TOPLEFT", petFrame, "BOTTOMLEFT", -23, -10);
				end
			]]);

			_G["PartyMemberFrame"..i]:SetAttribute("unit", "party"..i);
			_G["PartyMemberFrame"..i.."PetFrame"]:SetAttribute("unit", "partypet"..i);
			RegisterUnitWatch(_G["PartyMemberFrame"..i]);
			RegisterUnitWatch(_G["PartyMemberFrame"..i.."PetFrame"]);
			_G["PartyMemberFrame"..i]:SetAttribute("*type1", "macro");
			_G["PartyMemberFrame"..i]:SetAttribute("macrotext", format(DW_PARTYMEMBER_MACRO, i));
			_G["PartyMemberFrame"..i.."PetFrame"]:SetAttribute("*type1", "macro");
			_G["PartyMemberFrame"..i.."PetFrame"]:SetAttribute("macrotext", format(DW_PARTYTARGET_MACRO, i));			
		end
	end	
	
	local PartyEventFrame = CreateFrame("Frame", nil, UIParent);
	PartyEventFrame:RegisterEvent("PLAYER_REGEN_ENABLED");	
	PartyEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
	PartyEventFrame:RegisterEvent("GROUP_ROSTER_UPDATE");
	PartyEventFrame:SetScript("OnEvent", function(self, event, ...)
		if (InCombatLockdown()) then return end

		for i=1, 4 do
			local nextPartyMemberFrame = _G["PartyMemberFrame"..(i+1)];
			local partyMemberFrame = _G["PartyMemberFrame"..i];
			local partyMemberPetFrame = _G["PartyMemberFrame"..i.."PetFrame"];
			if (partyMemberFrame:IsShown()) then
				partyMemberPetFrame:ClearAllPoints();
				if (partyMemberPetFrame:IsShown()) then
					partyMemberPetFrame:SetPoint("TOPLEFT", partyMemberFrame, "TOPLEFT", 23, -43);
				else
					partyMemberPetFrame:SetPoint("TOPLEFT", partyMemberFrame, "TOPLEFT", 23, -27);
				end
			end
			if (nextPartyMemberFrame and nextPartyMemberFrame:IsShown()) then
				nextPartyMemberFrame:ClearAllPoints();
				nextPartyMemberFrame:SetPoint("TOPLEFT", partyMemberPetFrame, "BOTTOMLEFT", -23, -10);
			end
		end
	end);

	function __PlayerFrame_ToPlayerArt(self)
		if (EUF_CurrentOptions and EUF_CurrentOptions["PLAYERHPMP"] == 1) then
			EUF_PlayerFrameTextureExt:SetAlpha(1);
			EUF_PlayerFrameBackground:SetWidth(214);
		else
			PlayerFrameTexture:Show();
		end
	end

	function __PlayerFrame_ToVehicleArt(self, vehicleType)
		PlayerFrameTexture:Hide();
		if ( vehicleType == "Natural" ) then
			if (EUF_CurrentOptions and EUF_CurrentOptions["PLAYERHPMP"] == 1) then
				PlayerFrameVehicleTexture:SetWidth(480);
				PlayerFrameVehicleTexture:SetTexture("Interface\\AddOns\\Duowan\\textures\\UI-Vehicle-Frame-Organic");
				PlayerFrameVehicleTexture:ClearAllPoints();
				PlayerFrameVehicleTexture:SetPoint("LEFT", PlayerFrame, "LEFT", 16, 0);
				EUF_PlayerFrameTextureExt:SetAlpha(0);
				EUF_PlayerFrameBackground:SetWidth(210);
			else
				PlayerFrameVehicleTexture:SetWidth(240);
				PlayerFrameVehicleTexture:SetTexture("Interface\\Vehicles\\UI-Vehicle-Frame-Organic");			
			end
		else
			if (EUF_CurrentOptions and EUF_CurrentOptions["PLAYERHPMP"] == 1) then
				PlayerFrameVehicleTexture:SetWidth(480);
				PlayerFrameVehicleTexture:SetTexture("Interface\\AddOns\\Duowan\\textures\\UI-Vehicle-Frame");
				PlayerFrameVehicleTexture:ClearAllPoints();
				PlayerFrameVehicleTexture:SetPoint("LEFT", PlayerFrame, "LEFT", 16, 0);
				EUF_PlayerFrameTextureExt:SetAlpha(0);
				EUF_PlayerFrameBackground:SetWidth(210);
			else
				PlayerFrameVehicleTexture:SetWidth(240);
				PlayerFrameVehicleTexture:SetTexture("Interface\\Vehicles\\UI-Vehicle-Frame");
				PlayerFrameVehicleTexture:SetPoint("CENTER", PlayerFrame, "CENTER", 0, 0);
			end
		end
		PlayerFrameVehicleTexture:Show();
	end	
	hooksecurefunc("PlayerFrame_ToPlayerArt", __PlayerFrame_ToPlayerArt)
	hooksecurefunc("PlayerFrame_ToVehicleArt", __PlayerFrame_ToVehicleArt);
	
	function __PartyMemberFrame_UpdateMember (self)		
		--if (GetDisplayedAllyFrames() ~= "party") then
		if (GetCVarBool("useCompactPartyFrames")) then
			if (UnitWatchRegistered(self)) then
				SecureCall(UnregisterUnitWatch, self);
				DeleteSecureCall(RegisterUnitWatch, self);
			end
			if (self:IsShown()) then
				dwSecureCall(self.Hide, self);
			end
			
			return;
		end
		
		if not UnitWatchRegistered(self) then
			SecureCall(RegisterUnitWatch, self);
			DeleteSecureCall(UnregisterUnitWatch, self);
		end
	end
	hooksecurefunc("PartyMemberFrame_UpdateMember", __PartyMemberFrame_UpdateMember);
	
	function dwUpdatePartyFrames()
		for i=1, 4 do
			PartyMemberFrame_UpdateMember(_G["PartyMemberFrame"..i]);	
		end
	end	
	hooksecurefunc("RaidOptionsFrame_UpdatePartyFrames", dwUpdatePartyFrames);
	
	if CompactUnitFrameProfilesRaidStylePartyFrames then
	CompactUnitFrameProfilesRaidStylePartyFrames:HookScript("PostClick", function(this)
		if (GetCVarBool("useCompactPartyFrames")) then
			dwSetCVar("EN_UnitFrames", "showInRaid", 0);
		else
			dwSetCVar("EN_UnitFrames", "showInRaid", 1);
		end
	end);
	end
	
	function __PartyMemberFrame_ToVehicleArt(self, vehicleType)
		local prefix = self:GetName();
		_G[prefix.."Texture"]:Hide();
		if ( vehicleType == "Natural" ) then
			if (EUF_CurrentOptions and EUF_CurrentOptions["PLAYERHPMP"] == 1) then
				_G[prefix.."VehicleTexture"]:SetWidth(256);
				_G[prefix.."VehicleTexture"]:SetTexture("Interface\\AddOns\\Duowan\\textures\\UI-Vehicles-PartyFrame-Organic");
				_G[prefix.."VehicleTexture"]:ClearAllPoints();
				_G[prefix.."VehicleTexture"]:SetPoint("LEFT", self, "LEFT", -4, 0);
			else
				_G[prefix.."VehicleTexture"]:SetWidth(128);
				_G[prefix.."VehicleTexture"]:SetTexture("Interface\\Vehicles\\UI-Vehicles-PartyFrame-Organic");
				_G[prefix.."VehicleTexture"]:ClearAllPoints();
				_G[prefix.."VehicleTexture"]:SetPoint("LEFT", self, "LEFT", 0, 0);
			end			
		else
			if (EUF_CurrentOptions and EUF_CurrentOptions["PLAYERHPMP"] == 1) then
				_G[prefix.."VehicleTexture"]:SetWidth(256);
				_G[prefix.."VehicleTexture"]:SetTexture("Interface\\AddOns\\Duowan\\textures\\UI-VEHICLES-PARTYFRAME");
				_G[prefix.."VehicleTexture"]:ClearAllPoints();
				_G[prefix.."VehicleTexture"]:SetPoint("LEFT", self, "LEFT", -4, 0);
			else
				_G[prefix.."VehicleTexture"]:SetWidth(128);
				_G[prefix.."VehicleTexture"]:SetTexture("Interface\\Vehicles\\UI-Vehicles-PartyFrame");
				_G[prefix.."VehicleTexture"]:ClearAllPoints();
				_G[prefix.."VehicleTexture"]:SetPoint("LEFT", self, "LEFT", 0, 0);
			end
		end
		_G[prefix.."VehicleTexture"]:Show();
	end
		
	hooksecurefunc("PartyMemberFrame_ToVehicleArt", __PartyMemberFrame_ToVehicleArt);
	
	-- FocusFrame
	FocusFrame:UnregisterEvent("PLAYER_FOCUS_CHANGED");
	TargetFrame:UnregisterEvent("PLAYER_FOCUS_CHANGED");
	RegisterUnitWatch(FocusFrame);
	--RegisterUnitWatch(FocusFrameToT);
	
	local VehicleEventFrame = CreateFrame("Frame", nil, UIParent);
	VehicleEventFrame:RegisterEvent("UNIT_ENTERED_VEHICLE");
	VehicleEventFrame:RegisterEvent("UNIT_EXITED_VEHICLE");
	VehicleEventFrame:RegisterEvent("PET_UI_UPDATE");
	VehicleEventFrame:RegisterEvent("UNIT_PET");
	VehicleEventFrame:RegisterEvent("PLAYER_FOCUS_CHANGED");
	VehicleEventFrame:RegisterEvent("PLAYER_REGEN_ENABLED");
	
	VehicleEventFrame:SetScript("OnEvent", function(self, event, ...)
		local unit, arg2, vehicleType = ...
		
		if (event == "PLAYER_FOCUS_CHANGED") then			
			if (UnitExists("focus")) then
				TargetFrame_Update(FocusFrame);
				TargetFrame_UpdateRaidTargetIcon(FocusFrame);
			elseif (UnitExists("target")) then
				TargetFrame_Update(TargetFrame);
				TargetFrame_UpdateRaidTargetIcon(TargetFrame);
			end
		elseif (event == "PLAYER_REGEN_ENABLED") then
			for func, v in pairs(SecureCallStack) do
				for k, args in pairs(v) do
					pcall(func, unpack(args));
				end
			end
		end
	end)
	
	function TargetofTarget_Update(self, elapsed)
		local parent = self:GetParent();		

		if ( UnitExists(parent.unit) and UnitExists(self.unit) ) then
			if ( parent.spellbar ) then
				parent.haveToT = true;					
			end
			local _,enClass = UnitClass(self.unit);			
			local color = RAID_CLASS_COLORS[enClass];
			if (UnitIsPlayer("targettarget") and color) then
				self.name:SetTextColor(color.r or 1, color.g or 0.8, color.b or 0);
			else
				self.name:SetTextColor(1, 0.8, 0);
			end

			UnitFrame_Update(self);
			TargetofTarget_CheckDead(self);
			TargetofTargetHealthCheck(self);
			RefreshDebuffs(self, self.unit);
		else
			if ( parent.spellbar ) then
				parent.haveToT = nil;
			end
		end
		Target_Spellbar_AdjustPosition(parent.spellbar);
	end
	
	function TargetFrame_Update (self)
		if ( UnitExists(self.unit) ) then
			-- Moved here to avoid taint from functions below
			if ( self.totFrame ) then
				TargetofTarget_Update(self.totFrame);
			end
			
			UnitFrame_Update(self);
			if ( self.showLevel ) then
				TargetFrame_CheckLevel(self);
			end
			TargetFrame_CheckFaction(self);
			if ( self.showClassification ) then
				TargetFrame_CheckClassification(self);
			end
			TargetFrame_CheckDead(self);
			if ( self.showLeader ) then
				if ( UnitIsGroupLeader(self.unit) and (UnitInParty(self.unit) or UnitInRaid(self.unit)) ) then
					if ( HasLFGRestrictions() ) then
						self.leaderIcon:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-PORTRAITROLES");
						self.leaderIcon:SetTexCoord(0, 0.296875, 0.015625, 0.3125);
					else
						self.leaderIcon:SetTexture("Interface\\GroupFrame\\UI-Group-LeaderIcon");
						self.leaderIcon:SetTexCoord(0, 1, 0, 1);
					end
					self.leaderIcon:Show();
				else
					self.leaderIcon:Hide();
				end
			end
			TargetFrame_UpdateAuras(self);
			if ( self.portrait ) then
				self.portrait:SetAlpha(1.0);
			end
		end
	end
	
	-----------------------
	-- 重新定义目标的目标头像
	function CreateToTFrame(unit)
		local name, parent;
		if (unit == "targettarget") then
			name = "dwToTFrame";
			parent = TargetFrame;
		else
			name = "dwFocusToTFrame";
			parent = FocusFrame;
		end

		local frame = CreateFrame("Button", name, parent, "TargetofTargetFrameTemplate");
		UnitFrame_Initialize(frame, unit, _G[name.."TextureFrameName"], _G[name.."Portrait"],
						 _G[name.."HealthBar"], _G[name.."TextureFrameHealthBarText"],
						 _G[name.."ManaBar"], _G[name.."TextureFrameManaBarText"]);
		SetTextStatusBarTextZeroText(frame.healthbar, DEAD);
		frame.deadText = _G[name.."TextureFrameDeadText"];
		frame.unconsciousText  = _G[name.."TextureFrameUnconsciousText"];
		SecureUnitButton_OnLoad(frame, unit);
		frame.unit = unit;
		--frame.unconsciousText = frame:CreateText(nil, "OVERLAY");
		frame:SetScript("OnUpdate", function(self, elapsed)			
			local parent = self:GetParent();
			
			if UnitExists(unit) then
				local _,enClass = UnitClass(unit);
				local color = RAID_CLASS_COLORS[enClass];
				if (UnitIsPlayer(unit) and color) then
					frame.name:SetTextColor(color.r or 1, color.g or 0.8, color.b or 0);
				else
					frame.name:SetTextColor(1, 0.8, 0);
				end
				
				if ( parent.spellbar ) then
					parent.haveToT = true;
					Target_Spellbar_AdjustPosition(parent.spellbar);
				end

				UnitFrame_Update(self);
				TargetofTarget_CheckDead(self);			
				TargetofTargetHealthCheck(self);
				RefreshDebuffs(self, self.unit);			
			else
				if ( parent.spellbar ) then
					parent.haveToT = nil;
					Target_Spellbar_AdjustPosition(parent.spellbar);
				end
			end
		end);		
	end

	dwFixUnitFrame();
	CreateToTFrame("targettarget");
	CreateToTFrame("focustarget");
end

function dwTargetTOT_Toggle(switch)		
	if (switch) then
		if (dwFocusToTFrame) then
			RegisterUnitWatch(dwFocusToTFrame);
		end
		if (dwToTFrame) then
			TargetFrame.totFrame = nil;
			RegisterUnitWatch(dwToTFrame);
		else
			SetCVar("showTargetOfTarget", "1");
		end
	else
		if (dwFocusToTFrame) then
			UnregisterUnitWatch(dwFocusToTFrame);
		end
		if (dwToTFrame) then
			TargetFrame.totFrame = nil;
			UnregisterUnitWatch(dwToTFrame);
			dwSecureCall(dwToTFrame.Hide, dwToTFrame);
		else
			SetCVar("showTargetOfTarget", "0");
		end
	end	
end

if (SHOW_TARGET_OF_TARGET == "1") then
	dwTargetTOT_Toggle(true);
end

InterfaceOptionsCombatPanelTargetOfTarget:SetScript("PostClick", function(self, button)
	if (not dwToTFrame) then
		return;
	end

	if (SHOW_TARGET_OF_TARGET == "1") then
		dwTargetTOT_Toggle(true);
	else
		dwTargetTOT_Toggle(false);
	end
end);	