
if (not GladiatorlosSA) then return end

function GladiatorlosSA:FireToggle(switch)
	if (switch) then
		self.FireArenaEnable = true;
		self:PLAYER_ENTERING_WORLD();		
	else
		self.FireArenaEnable = false;
		self:CancelAllTimers();
	end
end

function GladiatorlosSA:PLAYER_ENTERING_WORLD()
	local _,currentZoneType = IsInInstance();
	CombatLogClearEntries();
	if (currentZoneType == "arena" or self._DEBUG) then
		self:ScheduleRepeatingTimer("UpdateArenaTarget", 0.01, self);
	else
		self:CancelAllTimers();
	end
end

function GladiatorlosSA:UpdateArenaTarget()
	if (self.FireArenaEnable) then
		self.ArenaInfo = {};		
		for i=1, 5 do
			if (UnitExists("arena"..i) and UnitExists("arena"..i.."target") and UnitInParty("arena"..i.."target") and UnitIsPlayer("arena"..i.."target") and not UnitIsDeadOrGhost("arena"..i.."target")) then
				local name = UnitName("arena"..i.."target");
				local class = select(2, UnitClass("arena"..i.."target"));
				self.ArenaInfo[name] = self.ArenaInfo[name] or {};
				self.ArenaInfo[name]["name"] = name;
				self.ArenaInfo[name]["class"] = class;
				self.ArenaInfo[name]["count"] = self.ArenaInfo[name]["count"] or 1;
			end
		end

		-- 计算count最大的
		local name, class, maxCount = nil, 0, 0;
		for k, v in pairs(self.ArenaInfo) do
			if (v["count"] > maxCount) then
				maxCount = v["count"];
				name = k;
				class = v["class"];
			end
		end

		if (name ~= self.lastFireTarget) then
			self:FireAlert(name, class, maxCount);
		end
	end
end

function GladiatorlosSA:FireAlert(name, class, count)
	if (count >= 2) then	
		if (name == UnitName("player")) then
			name = ">>你<<";
		end
		-- 颜色
		local color = RAID_CLASS_COLORS[class];
		if (color) then
			name = format("|cff%02x%02x%02x%s|r", color.r*255, color.g*255, color.b*255, name);
		end
		
		local msg = format("%s 被|cff56dc7c%d|r人集火!", name, count);
		self.AlertFrame:AddMessage(msg, 1.0, 1.0, 0.1);

		self.lastFireTarget = name;
	end
end