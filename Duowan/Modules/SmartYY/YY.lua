local YY = LibStub("AceAddon-3.0"):NewAddon("YY", "AceEvent-3.0");
local V = LibStub("LibVoice-3.0");

local default_db = {
	guildName = "",
}

function YY:OnInitialize()
	self.db = default_db;
	self:RegisterEvent("PLAYER_GUILD_UPDATE", "OnGuildChanged")
	self:RegisterEvent("GUILD_ROSTER_UPDATE", "OnGuildChanged")
end

function YY:OnEnable()
	self:SetRealm();
	self:SetGuild();
	self:SetPlayer();
end

function YY:OnDisable()
	
end

function YY:SetRealm()
	local ticket = "wow_ticket://NV_WOWSVR:value^=^%s";	
	ticket = ticket:format(GetRealmName());
	--print("YY:SetRealm()", ticket);
	V:Transfer_New(ticket);
end

function YY:SetPlayer()
	local ticket = "wow_ticket://NV_BIND_ACCOUNT:name^=^%s^&^svr^=^%s";	
	ticket = ticket:format(UnitName("player"),GetRealmName());
	--print("YY:SetRealm()", ticket);
	V:Transfer_New(ticket);
end

function YY:SetGuild()
	local ticket = "wow_ticket://NV_GROUPINFO:id^=^%s^&^name^=^%s^&^master^=^%s^&^type^=^%s";
	local realmName = GetRealmName();
	local guildName, _, guildRankIndex = GetGuildInfo("player");
	local master = (guildRankIndex == 0) and "1" or "0"
	local guildType = "0";
	
	if (realmName and guildName) then
		local guildID = HashCrc32(realmName .. guildName);
		ticket = ticket:format(tostring(guildID), guildName, master, guildType);
		self.db.guildName = guildName;
	else
		ticket = ticket:format("0", "0", "0", "0");
	end
	--print("YY:SetGuild()", ticket);
	V:Transfer_New(ticket);
end

function YY:OnGuildChanged(event)
	local ticket = "wow_ticket://NV_GROUPINFO:id^=^%s^&^name^=^%s^&^master^=^%s^&^type^=^%s";
	local realmName = GetRealmName();
	local guildName, _, guildRankIndex = GetGuildInfo("player");
	local master = (guildRankIndex == 0) and "1" or "0"
	local guildType = "0";

	if (realmName and guildName and self.db.guildName ~= guildName) then
		local guildID = HashCrc32(realmName .. guildName);
		ticket = ticket:format(tostring(guildID), guildName, master, guildType);
		self.db.guildName = guildName;
		
		--print("YY:OnGuildChanged", ticket)
		V:Transfer_New(ticket);
	end	
end