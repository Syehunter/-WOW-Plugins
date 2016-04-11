 --[[
-- Author:	Thrae of Maelstrom (aka "Matthew Carras")
-- Modifier:	Hughman
-- Version:	2009.02.10
-- Note:		Base on TinyTip ver1.2x (not ACE)
--]]

------------------------------ 参数设置 --------------------------------
-- 修改后的数值必须与默认值的数据类型一致
-- 对于大多数参数，true为启用，false 为禁用（请不要使用nil）
local rc = LibStub("LibRangeCheck-2.0");
local InspectLess = LibStub("LibInspectLess-1.0")
local tip = {};
local _;
local TTCfg = {
	Anchor			= {value = 3,		desc = "錨點：0-默認；1-人物跟隨，其他默認；2-人物上方，其他默認；3-人物跟隨，其他右上；4-人物上方，其他右上；5-全部屏幕上方；6-全部跟隨。注意用OffsetX和OffsetY調整相對位置"},
	OffsetX			= {value = 30,		desc = "橫向偏移量：向右為正，向左為負。跟隨鼠標建議設置為30"},
	OffsetY			= {value = -30,		desc = "縱向偏移量：向上為正，向下為負。跟隨鼠標建議設置為-30"},
	Scale				= {value = 1.0,		desc = "縮放：默認－1.0，取值>0"},
	Fade				= {value = false,	desc = "漸隱"},
	HideInCombat		= {value = false,	desc = "戰斗中隱藏"},
	Power			= {value = false,	desc = "顯示法力、怒氣、能量等狀態條"},
	StatusBarText		= {value = 3,		desc = "相應數字之和顯示相應信息：0-禁用，1-当前，2-最大，4-百分比"},
	StatusBarHeight		= {value = 8,		desc = "設置狀態條高度，默认8"},
	ItemInfo			= {value = 125,		desc = "相應數字之和顯示相應信息：0-禁用，1-類別，2-編號，4-等級，8-堆疊，16-价格，32-图标，64-物品質量顏色顯示邊框"},
	NoShiftCompare		= {value = true,	desc = "不按Shift直接對比裝備"},
	HoverLink			= {value = true,	desc = "鼠標劃過聊天窗口的鏈接立即顯示提示"},
	ClassColorBorder	= {value = true,	desc = "職業顏色顯示邊框"},
	AltDKColor			= {value = false,	desc = "修改DK職業顏色"},
	ColorFriends		= {value = true,	desc = "好友和工會成員背景顏色"},
	ClassColorName		= {value = false,	desc = "職業顏色顯示名字"},
	PVPRank			= {value = true,	desc = "顯示軍銜及各種稱號"},
	Race				= {value = true,	desc = "顯示玩家種族"},
	Faction			= {value = true,	desc = "顯示NPC聲望等級"},
	Talent			= {value = true,	desc = "顯示天賦"},
	Status			= {value = true,	desc = "顯示狀態：AFK、DND、離線、假死"},
	Speed			= {value = false,	desc = "顯示速度"},
	Buff				= {value = 0, 		desc = "相應數字之和顯示相應信息：0-禁用，1-Buff，2-Debuff"},
	Guild				= {value = true,	desc = "顯示工會"},
	GuildRank			= {value = false,	desc = "顯示工會級別"},
	MyGuild			= {value = "",		desc = "各分公會公共詞匯。提取公共詞匯可以讓各分會成員醒目提示。"},
	Realm			= {value = true,	desc = "顯示服務器"},
	Target			= {value = 13,		desc = "相應數字之和顯示相應信息：0-禁用，1-目標，2-目標的目標，4-關注的小隊成員，8-關注的團隊成員數"},
	Range			= {value=true,		desc="显示玩家与鼠标指向目标的距离"},
}

------------------------------ 预设颜色 --------------------------------
-- r,g,b分别为红绿蓝的RGB值/255所得

local TTColor = {
	Corpse					= {r=0.54, g=0.54, b=0.54},	-- 尸体颜色（灰色）
	MyGuild				= {r=1, g=0, b=1},			-- 本工会名颜色（粉红）
	MyGuildBG				= {r=0.4, g=0, b=0.83},		-- 本工会背景颜色（紫色）
	FriendBG				= {r=0.4, g=0.2, b=1},		-- 好友背景颜色（红紫色）
	Hostile					= {r=1, g=0, b=0},			-- 敌对玩家名字颜色（红色）
	HostileCharmed			= {r=1, g=0.4, b=1},			-- 敌对玩家（控制我）名字颜色（粉红）
	FriendlyPVP				= {r=0, g=1, b=0},			-- 友好玩家（PVP）名字颜色（绿色）
	Friendly					= {r=0, g=0.67, b=1},		-- 友好玩家（PVE）名字颜色（蓝色）
	HostileBG				= {r=0.5, g=0, b=0},			-- 敌对玩家背景颜色（暗红）
	FriendlyBG				= {r=0, g=0, b=0.5},			-- 友好玩家背景颜色（暗蓝）
	FriendlyPVPBG			= {r=0, g=0.2, b=0},			-- 友好PVP玩家背景颜色（暗绿）
	NPCBG					= {r=0, g=0, b=0},			-- NPC背景颜色（黑色）
	DK						= {r=0.8, g=1, b=0},			-- DK职业颜色（黄绿）
	Race					= "DDEEAA",				-- 种族、生物类型颜色（草绿色）
	Default					= "FFCC00",					-- 游戏默认颜色（金黄）
	Classification			= {
		["elite"]				= "FFCC00",					-- 精英
		["worldboss"]		= "FF0000",					-- 首领
		["rare"]				= "FF66FF",					-- 稀有
		["rareelite"]			= "FFAAFF",					-- 稀有精英
	},
	Faction					= {
		[5]					= "33CC33",					-- 友好（绿色）
		[6]					= "33CCCC",				-- 尊敬（湖蓝）
		[7]					= "FF6633",					-- 崇敬（橙色）
		[8]					= "DD33DD",				-- 崇拜（紫色）
	},
}

------------------------------ 本地化 ----------------------------------
local TTA;
local TTLoc = {
	["tapped"]			= "Tapped",
	["rare"]			= "Rare",
	["rareelite"]		= "Rare Elite",
	["you"]			= ">>YOU<<",
	["targetedby"]		= "member(s) targetting it",
	["far"]			= "Too far to inspect talent",
	["nodata"]			= "No Data",
	["itemtype"]		= "ItemType",
	["itemid"]			= "ItemID",
	["itemlevel"]		= "ItemLevel",
	["itemstack"]		= "StackCount",
	["channel"] = " Channel",
	["Click to join channel."] = "Click to join channel.",
	["share to your friends."]= "share to your friends.",
	["Range"]			= "Range",
	["Yard"]			= "Yard",
	["ItemLevel"]		= "◇ItemLevel: ",
	["AvgItemLvl"]		= "◇AvgItemLvl: ",
}
local TALENTS = {"Talent", "Talent"};
if GetLocale() == "zhCN" then
TTLoc = {
	["tapped"]			= "已被选取",
	["rare"]			= "稀有",
	["rareelite"]		= "稀有精英",
	["you"]			= ">>你<<",
	["targetedby"]		= "人关注",
	["far"]			= "无法获取",
	["nodata"]			= "没有数据",
	["itemtype"]		= "物品类别",
	["itemid"]			= "物品编号",
	["itemlevel"]		= "物品等级",
	["itemstack"]		= "堆叠数量",
	["channel"]		= " 频道",
	["Click to join channel."] = "点击进入频道.",
	["share to your friends."]= "分享给你的伙伴.",
	["Range"]			= "距离",
	["Yard"]			= "码",
	["ItemLevel"]		= "◇装备等级: ",
	["AvgItemLvl"]		= "◇平均装等: ",
}
TALENTS = {"天赋", "备用"};
TTA = {	["默认"] = 0,	["跟随(1)"] = 1,	["跟随(2)"] = 3,	["跟随(3)"] = 6,	["上方(1)"] = 2,	["上方(2)"] = 4,	["上方(3)"] = 5}
elseif GetLocale() == "zhTW" then
TTLoc = {
	["tapped"]			= "已被選取",
	["rare"]				= "稀有",
	["rareelite"]			= "稀有精英",
	["you"]				= ">>你<<",
	["targetedby"]		= "人關注",
	["far"]				= "無法獲取",
	["nodata"]			= "沒有數據",
	["itemtype"]			= "物品類別",
	["itemid"]			= "物品編號",
	["itemlevel"]			= "物品等級",
	["itemstack"]		= "堆疊數量",
	["channel"] = " 頻道",
	["Click to join channel."] = "點擊進入頻道.",
	["share to your friends."]= "分享給你的夥伴.",
	["Range"]			= "距離",
	["Yard"]			= "碼",
	["ItemLevel"]		= "◇裝備等級: ",
	["AvgItemLvl"]		= "◇平均莊等: ",
}
TALENTS = {"天賦", "備用"};
TTA = {	["默認"] = 0,	["跟隨(1)"] = 1,		["跟隨(2)"] = 3,	["跟隨(3)"] = 6,	["上方(1)"] = 2,	["上方(2)"] = 4,	["上方(3)"] = 5}
end

TTLoc["elite"] = ELITE
TTLoc["worldboss"] = BOSS

local showItemLv = true;
local targetItemLevelInfo = {["未知目标"] = {},["小精灵"] = {}};

------------------------------ 自定义结束 ----------------------------------

function TinytipUpdateAnchor(arg)
	if (TTA[arg]) then
		TTVar.Anchor = TTA[arg];
	end
end

TTVar = {}
local _G = getfenv(0)
local tmp,tmp2,tmp3
local unit, class, reaction, name

local inspectList = {} -- 天赋缓存
local inspectName, talentLine, inspectGUID
local Inspected = false
local lastUnitRange;	-- 上一个目标的距离
local lastUnitItemLvl;
local lastUnitAvgItemLvl;
local TT = GameTooltip
local TTStatusBar = {}
	TTStatusBar[1] = GameTooltipStatusBar
local barTexture = "Interface\\TargetingFrame\\UI-TargetingFrame-BarFill"

CURRENTLY_EQUIPPED = "|cFFFF8000==="..CURRENTLY_EQUIPPED.."===|r"

-- 简化逻辑与判断
local function BAnd(arg1, arg2)
	if bit.band(arg1, arg2) == arg1 then
		return true
	else
		return false
	end
end

-- 转换颜色格式
local function ParseColor(color, hex)
	if hex then
		return format("%2x%2x%2x",color.r*255,color.g*255,color.b*255)
	else
		return color.r, color.g, color.b, 1
	end
end

-- 职业颜色
local function UnitColor(unit)
	_, class=UnitClass(unit)
	if class and RAID_CLASS_COLORS[class] then
		return ParseColor(RAID_CLASS_COLORS[class], true)
	end
end

-- 死亡或已被选取
local function DeadOrTapped(unit)
	if UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit) then
		return 1
	elseif (UnitHealth(unit) <= 0 and not UnitIsPlayer(unit))
	or (UnitIsPlayer(unit) and UnitIsDeadOrGhost(unit)) then
		return 2
	else
		return 0
	end
end

-- 获取阵营、声望
local function UnitFaction(unit)
	reaction = UnitReaction(unit, "player")
	if not reaction then return 0 end

	if reaction < 5 then
		tmp = ParseColor(FACTION_BAR_COLORS[reaction], true)
	else
		tmp = TTColor.Faction[reaction]
	end
	if DeadOrTapped(unit) > 0 then
		tmp = ParseColor(TTColor.Corpse, true)
	end
	tmp2 = GetText("FACTION_STANDING_LABEL"..reaction, UnitSex("player"))
	return format("|cFF%s%s|r", tmp, tmp2)
end

--格式化天赋
local function UnitTalent(names, nums, colors)
	local name, point
	if nums[1] >= nums[2] then
		if nums[1] >= nums[3] then
			tmp = 1
			if nums[2] >= nums[3] then tmp2 = 2 tmp3 = 3 else tmp2 = 3	tmp3 = 2 end
		else
			tmp = 3 tmp2 = 1 tmp3 = 2
		end
	else
		if nums[2] >= nums[3] then
			tmp = 2
			if nums[1] >= nums[3] then tmp2 = 1 tmp3 = 3 else tmp2 = 3 tmp3 = 1 end
		else
			tmp = 3 tmp2 = 2 tmp3 = 1
		end
	end
	if nums[tmp]*3/4 <= nums[tmp2] then
		if nums[tmp]*3/4 <= nums[tmp3] then
			name = colors[tmp]:format(names[tmp]).."/"..colors[tmp2]:format(names[tmp2]).."/"..colors[tmp3]:format(names[tmp3])
		else
			name = colors[tmp]:format(names[tmp]).."/"..colors[tmp2]:format(names[tmp2])
		end
	else
		name = colors[tmp]:format(names[tmp])
	end
	point = (" (%s/%s/%s)"):format(colors[1]:format(nums[1]), colors[2]:format(nums[2]), colors[3]:format(nums[3]))
	return name..point
end

--天赋着色
local function TalentColor(point)
	tmp = MAX_PLAYER_LEVEL_TABLE[GetAccountExpansionLevel()] - 9 --最大天赋点数
	tmp = point / tmp
	if tmp > 0.5 then
		tmp2 = 0.1 + (1 - tmp) * 2 * 0.9
		tmp3 = 0.9
	else
		tmp2 = 1.0
		tmp3 = 0.9 - (0.5 - tmp)* 2 * 0.9
	end

	return "|cFF".. ParseColor({r=tmp3, g=tmp2, b=0}, true) .."%s|r" -- GGRRBB
end

local function RGB(r, g, b)
	return string.format("%02x%02x%02x", r*255, g*255, b*255);	
end

local function GetRangeColorText(minRange, maxRange)
	local color, text;
	if (minRange) then
		if (minRange > 100) then
			maxRange = nil;
		end		
		
		if (maxRange) then
			local tmpText = format("%d-%d %s", minRange, maxRange, TTLoc["Yard"]);		
	
			if ( maxRange <= 5) then
				color = RGB(0.9, 0.9, 0.9);
			elseif (maxRange <= 20) then
				color = RGB(0.055, 0.875, 0.825);
			elseif (maxRange <= 30) then
				color = RGB(0.035, 0.865, 0.0);
			elseif (minRange >= 40) then
				color = RGB(0.9, 0.055, 0.075);
			else
				color = RGB(1.0, 0.82, 0);
			end
			
			text = format("%s: |cff%s%s|r", TTLoc["Range"], color, tmpText);
		end
	end
	
	return text;
end

local coords
local function SetClassIcon(classToken,ispet)
	if not TT.icon then
		TT.icon = GameTooltip:CreateTexture(nil, "OVERLAY")
		TT.icon:SetWidth(16); TT.icon:SetHeight(16);
		TT.icon:SetPoint("LEFT", GameTooltipTextLeft1, 1, 0)
		TT.icon:SetTexture("Interface\\WorldStateFrame\\Icons-Classes")
		TT.icon:Hide()

	end
	if not TT.peticon and ispet then
		TT.peticon = GameTooltip:CreateTexture(nil, "OVERLAY")
		TT.peticon:SetWidth(16); TT.peticon:SetHeight(16);
		TT.peticon:SetPoint("LEFT", GameTooltipTextLeft1, 1, 0)
		TT.peticon:SetTexture("Interface\\Icons\\Pet_TYPE_"..PET_TYPE_SUFFIX[classToken])
		TT.icon:Hide()
	end

	if ispet then
		TT.peticon:SetTexture("Interface\\Icons\\Pet_TYPE_"..PET_TYPE_SUFFIX[classToken])
		TT.peticon:Show()
	else
		coords = CLASS_BUTTONS[classToken]
		TT.icon:SetTexCoord(coords[1],coords[2],coords[3],coords[4])
		TT.icon:Show()
	end
end

local function UpdateUnitRange(TT, unit)
	-- 显示与目标的距离
	if (TTVar.Range and rc) then
		
		local minRange, maxRange = rc:getRange(unit);
		local text = GetRangeColorText(minRange, maxRange);
		
		local maxNum = TT:NumLines();
		local LeftText, tmpText, isFind;
		for i=1, maxNum, 1 do
			LeftText = _G[TT:GetName().."TextLeft"..i];	
			tmpText = LeftText:GetText();
			-- GameTooltip的bug, 无法获得正确的信息
			if (not tmpText) then
				if (lastUnitRange == text) then return end
				LeftText = _G[TT:GetName().."TextLeft"..maxNum];
				isFind = true;
				break;
			elseif(string.find(tmpText, "^" .. TTLoc["Range"])) then
				if (LeftText:GetText() == text) then return end
				isFind = true;
				break;
			end
		end
		
		if (text) then
			lastUnitRange = text;
			if (isFind) then
				LeftText:SetText(text);
			else
				TT:AddLine(text);
				TT:Show();
			end
		end
	end
end

-- 设置人物信息
local L, L1, L2, IsPlayer
local function SetUnit(self, ...)
	name, unit = self:GetUnit()
	if not (unit and name) then return end
	
	local i, cDeadOrTapped, levelLine, llText -- 行数、尸体颜色、等级行、等级行内容
	L = self:GetName() .. "TextLeft"
	L1 = _G[L .. "1"]
	L2 = _G[L .. "2"]
	IsPlayer = UnitIsPlayer(unit)
	reaction = UnitReaction(unit, "player")
	Inspected = false
	if DeadOrTapped(unit) >0 then cDeadOrTapped = ParseColor(TTColor.Corpse, true) end
	
	for i = 2, self:NumLines() do
		tmp = _G[L .. i]
		tmp2 = tmp:GetText()
		if tmp2 then
			if not levelLine and strfind(tmp2, LEVEL, 1, true) then	-- 找到等级行
				llText = tmp
				levelLine = i
				talentLine = i + 1
			end
			if levelLine and strfind(tmp2, PVP_ENABLED, 1, true) then	-- 移除PVP行
				tmp:SetText(nil)
				talentLine = i + 1				
			end
		else
			self:Hide()
		end
	end

	-- 职业颜色显示名字
	if (IsPlayer) then
		tmp = "     ";
	else
		tmp = "";
	end	
	
	if TTVar.ClassColorName and IsPlayer then
		tmp = tmp .. format( "|cFF%s%s|r", UnitColor(unit), name )
	else
		tmp = tmp .. name
	end
	
	-- 头衔
	if TTVar.PVPRank and IsPlayer then
		tmp2 = UnitPVPName(unit)
		tmp3 = nil
		if tmp2 and tmp2 ~= name then
			i = strfind(tmp2, name)
			if i and i > 1 then 
				tmp3 = strsub(tmp2, 1, i - 1 )
			elseif i == 1 then
				_, tmp3 = tmp2:match("(.+)，(.+)") --strsub(tmp2, strlen(name)+1)
			end
		end
		tmp3 = tmp3 and ("-" .. tmp3) or ""
		L1:SetText( tmp .. tmp3)
	else
		L1:SetText( tmp )
	end

	-- 设置职业图标
	if (IsPlayer) then
		local _, ENClass = UnitClass(unit);
		SetClassIcon(ENClass, false);
	end
	
	-- 状态
	tmp = " |cFFFFFFFF"
	if TTVar.Status and IsPlayer then
		if UnitIsAFK(unit) then
			self:AppendText(tmp .. CHAT_FLAG_AFK)
		elseif UnitIsDND(unit) then
			self:AppendText(tmp .. CHAT_FLAG_DND)
		elseif not UnitIsConnected(unit) then
			self:AppendText(tmp .. "<" .. PLAYER_OFFLINE .. ">" )
		end
		if UnitIsFeignDeath(unit) then
			self:AppendText(tmp .. "<" .. GetSpellInfo(5384) .. ">" )
		end
	end
	
	--速度
	if TTVar.Speed then
		tmp2 = GetUnitSpeed(unit)
		if tmp2 and tmp2 > 0 then
			self:AppendText (tmp .. "<" .. format("%.0f%%", (tmp2 / 7 * 100)) ..">")
		end
	end
	
	-- 阵营
	if cDeadOrTapped then
		L1:SetTextColor(ParseColor(TTColor.Corpse))
		if levelLine and levelLine == 3 then 
			L2:SetTextColor(ParseColor(TTColor.Corpse))
		end
	elseif IsPlayer or UnitPlayerControlled(unit) then
		if reaction and reaction<4 then -- 敌对
			self:SetBackdropColor(ParseColor(TTColor.HostileBG))
			L1:SetTextColor(ParseColor(TTColor.Hostile))
			if not UnitCanAttack("player", unit) and UnitCanAttack(unit, "player") then -- 被控制
				L1:SetTextColor(ParseColor(TTColor.HostileCharmed))
			end
		else -- 友好
			if UnitIsPVP(unit) then -- 友好（PvP）
				L1:SetTextColor(ParseColor(TTColor.FriendlyPVP))
				self:SetBackdropColor(ParseColor(TTColor.FriendlyPVPBG))
			else -- 友好（PvE）
				L1:SetTextColor(ParseColor(TTColor.Friendly))
				self:SetBackdropColor(ParseColor(TTColor.FriendlyBG))
			end
		end
	else -- npc
		self:SetBackdropColor(ParseColor(TTColor.NPCBG))
		if reaction then
			L1:SetTextColor(ParseColor(FACTION_BAR_COLORS[reaction]))
		end
	end

	-- 第二行（信息行）上色
	if not cDeadOrTapped and levelLine and levelLine == 3 then
		L2:SetTextColor( L1:GetTextColor() )
	end
	
	if levelLine then
		-- 等级
		tmp = UnitLevel(unit)
		tmp2 = ParseColor(GetQuestDifficultyColor(tmp), true)
		if reaction and reaction > 4 and tmp >= UnitLevel("player") +5 then
			tmp2 = "800000"
		end
		llText:SetText( format( "|cFF%s%s %s|r", 
					cDeadOrTapped or tmp2 or TTColor.Default, 
					LEVEL, tmp ~= -1 and tmp or "??") )

		-- 生物分级：精英、稀有、首领等
		tmp = UnitClassification(unit)
		if tmp and tmp ~= "normal" then
			llText:SetText(format("%s |cFF%s%s|r", 
						llText:GetText() or "", 
						cDeadOrTapped or TTColor.Classification[tmp] or TTColor.Default,
						TTLoc[tmp] or "" ) )
		end

		-- 职业、种族、生物类型、声望
		if IsPlayer then
			llText:SetText( format("%s |cFF%s%s|r |cFF%s%s|r",
						llText:GetText() or "",
						cDeadOrTapped or TTColor.Race,
						TTVar.Race and UnitRace(unit) or "", 
						cDeadOrTapped or UnitColor(unit), 
						UnitClass(unit) or UNKNOWN ) ) 
		elseif UnitPlayerControlled(unit) then 
			llText:SetText( format("%s |cFF%s%s|r",
						llText:GetText() or "",
						cDeadOrTapped or TTColor.Race,
						UnitCreatureFamily(unit) or UNKNOWN ) )
		else
			llText:SetText( format("%s |cFF%s%s %s|r",
						llText:GetText() or "",
						cDeadOrTapped or TTColor.Race,
						UnitCreatureType(unit) or "" ,
						TTVar.Faction and UnitFaction(unit) or "" ) )
		end
	end
	
	-- 添加：尸体或已被选取
	if cDeadOrTapped and llText then
		llText:SetText( format( "%s |cFF%s(%s)|r", 
					llText:GetText(), 
					cDeadOrTapped,
					( DeadOrTapped(unit) == 1 and TTLoc["tapped"] ) or CORPSE ) )
	end
	
	-- 好友背景
	if TTVar.ColorFriends and IsPlayer and UnitIsFriend(unit, "player") then
		for i = 1, GetNumFriends() do
			tmp,tmp2 = GetFriendInfo(i)
			if tmp and tmp2 ~= 0 and name and tmp == name then
				self:SetBackdropColor(ParseColor(TTColor.FriendBG))
				break
			end
		end
	end

	-- 工会和服务器名
	_, tmp = UnitName(unit)
	tmp2, tmp3 = GetGuildInfo(unit)
	if IsPlayer then
		if TTVar.Realm and tmp ~= nil and tmp ~= "" then tmp = " @ ".."<"..tmp..">" else tmp = "" end
		if tmp2 then
			if TTVar.Guild then
				if TTVar.GuildRank and tmp3 then tmp3 = "·"..tmp3 else tmp3 = "" end
				L2:SetText("<"..tmp2..tmp3..">"..tmp)
				if IsInGuild() and not cDeadOrTapped
				and (tmp2 == GetGuildInfo("player") or (TTVar.MyGuild ~="" and strfind(tmp2,TTVar.MyGuild))) then
					L2:SetTextColor(ParseColor(TTColor.MyGuild))
					self:SetBackdropColor(ParseColor(TTColor.MyGuildBG))
				else
					L2:SetTextColor(L1:GetTextColor())
				end
			else
		  		L2:SetText(tmp)
			end
		else
			if tmp ~= nil and tmp ~= "" then
				llText = L2:GetText()
				L2:SetText(tmp)
				L2:SetTextColor(L1:GetTextColor())
				self:AddLine(llText)
			end
		end
	end

	-- @显示玩家装备等级
	--ItemLevelShow();
	-- @显示平均装备等级
	--ShowUnitAvgItemLevel(self, unit);
	

	-- 天赋
	if TTVar.Talent and IsPlayer and not UnitIsUnit(unit, "player") and UnitLevel(unit) > 9 then
		tmp = inspectList[name]
		tmp2 = CheckInteractDistance(unit, 1) and CanInspect(unit)
		tmp3 = CheckInteractDistance(unit, 1) and not CanInspect(unit)
		if tmp then			
			local TextLine = _G["GameTooltipTextLeft" .. talentLine];
			TextLine:SetText(talentInfo);
			--self:AddLine(tmp)
		else
			if tmp2 then
				--self:AddLine(TALENTS[1] .. ": Loading ...")
			elseif not tmp3 and UnitIsVisible(unit) then
				--self:AddLine(TALENTS[1] .. ": " .. TTLoc["far"])
			end
		end
		if tmp2 then
			if (not InspectFrame or not InspectFrame:IsShown()) then
				inspectGUID = UnitGUID(unit);
				inspectName = UnitName(unit);
				--self:RegisterEvent("INSPECT_TALENT_READY")
				InspectLess:NotifyInspect(unit)
			end
		end
	end
	
	-- 目标
	tmp = unit .. "target"
	if BAnd(1, TTVar.Target) and UnitExists(tmp) then
		tmp2 = UnitName(tmp) or ""
		if UnitIsUnit(tmp, "player") then
			self:AddLine( format("%s: |cFFFF0000%s|r", TARGET, TTLoc["you"]) )
		elseif UnitIsPlayer(tmp) then
			self:AddLine( format("%s: |cFF%s%s|r", TARGET, UnitColor(tmp), tmp2 ) )
		else
			tmp3 = FACTION_BAR_COLORS[UnitReaction(tmp, "player")]
			self:AddLine( format("%s: |cFF%s%s|r", TARGET, tmp3 and ParseColor(tmp3, true) or TTColor.Default, tmp2 ) )
		end
	end
	
	-- 目标的目标
	--[[
	tmp =  unit .. "targettarget"
	if BAnd(3, TTVar.Target) and UnitExists(tmp) then
		tmp2 = UnitName(tmp) or ""
		if UnitIsUnit(tmp, "player") then
			self:AddLine( format("%s|cFFFF0000%s|r", "　->  ", TTLoc["you"]) )
		elseif UnitIsPlayer(tmp) then
			self:AddLine( format("%s|cFF%s%s|r", "　->  ", UnitColor(tmp), tmp2 ) )
		else
			tmp3 = FACTION_BAR_COLORS[UnitReaction(tmp, "player")]
			self:AddLine( format("%s|cFF%s%s|r", "　->  ", tmp3 and ParseColor(tmp3, true) or TTColor.Default, tmp2 ) )
		end
	end
	]]
	-- 关注的小队成员
	if BAnd(4, TTVar.Target) and UnitInParty("player") then
		tmp = GetNumSubgroupMembers()
		tmp2 = nil
		for i = 1, tmp do
			tmp3 = "party" .. i	
			if UnitIsUnit(tmp3 .. "target",unit) and not UnitIsUnit(tmp3, "player") then
				tmp2 = format("%s\n|cFF%s%s|r", tmp2 or "", UnitColor(tmp3), UnitName(tmp3) or UNKNOWN)
			end
		end
		if tmp2 then
			self:AddLine( format("%s:%s", GROUP, tmp2) )
		end
	end
	
	-- 关注的团队成员数
	if BAnd(8, TTVar.Target) and UnitInRaid("player") then
		tmp = GetNumGroupMembers()
		tmp2 = 0
		for i = 1,tmp,1 do
			if UnitIsUnit("raid" .. i .. "target",unit) then
				tmp2 = tmp2 + 1
			end
		end
		if tmp2 > 0 then
			self:AddLine( format("%s: (|cFFFFFFFF%s|r) %s", RAID, tostring(tmp2), TTLoc["targetedby"]) )
		end
	end
	
	-- 显示与目标的距离
	UpdateUnitRange(self, unit);	
	self:Show()
end

-- 创建状态条
local function CreateStatusBar(bar, i)
	if i > 1 then
		bar[i] = CreateFrame("StatusBar",nil, bar[i-1])
		bar[i]:SetStatusBarTexture(barTexture)
		bar[i]:SetHeight(bar[i-1]:GetHeight())
		bar[i]:SetPoint("TOPLEFT", bar[i-1], "BOTTOMLEFT")
		bar[i]:SetPoint("TOPRIGHT", bar[i-1], "BOTTOMRIGHT")
		bar[i]:SetFrameStrata("TOOLTIP")
		bar[i]:Hide()
	end

	bar[i].BG = CreateFrame("StatusBar", nil, bar[i])
	bar[i].BG:SetStatusBarTexture(barTexture)
	bar[i].BG:SetAlpha(0.2)
	bar[i].BG:SetAllPoints()
	bar[i].BG:SetFrameStrata("DIALOG")
	
	bar[i].Text = bar[i]:CreateFontString(nil, "OVERLAY")
	bar[i].Text:SetFont(GameFontNormalSmall:GetFont(), 11, "OUTLINE")
	bar[i].Text:SetPoint("CENTER", bar[i], "CENTER")
end

-- 设置状态条文本
local function SetStatusBarText(self, val, max)
	if not max or max == 0 then return end
	
	local percent = format("%.1f%%", (val / max * 100))
	tmp, tmp2 = 10000, "W"
	if val and val > tmp then val = format("%.1f %s", (val/tmp), tmp2 ) end
	if max and max > tmp then max = format("%.1f %s", (max/tmp), tmp2 ) end
	
	tmp = ""
	if BAnd(1, TTVar.StatusBarText) then
		tmp = val
	end
	if BAnd(2, TTVar.StatusBarText) then
		tmp = tmp .. " / " .. max
	end
	if BAnd(4, TTVar.StatusBarText) and percent ~= "100.0%" and percent ~= "0.0%" then
		tmp = tmp .. " (" .. percent .. ")"
	end
	self:SetText(tmp)
end

-- 设置血条
local function SetHealth(self, unit)
	if not unit then return end
	self:SetHeight(TTVar.StatusBarHeight)
	
	class = select(2, UnitClass(unit))
	if class and TTVar.ClassColorBorder then
		self:GetParent():SetBackdropBorderColor(ParseColor(RAID_CLASS_COLORS[class]))
		self:SetStatusBarColor(ParseColor(RAID_CLASS_COLORS[class]))
	end
	
	tmp = UnitHealth(unit)
	tmp2 = UnitHealthMax(unit)
	SetStatusBarText(self.Text, tmp, tmp2)

	if TTVar.ClassColorBorder and class then
		self.Text:SetTextColor(0, 1, 0)
	else
		self.Text:SetTextColor(1, 1, 1)
	end
	
	self.BG:SetStatusBarColor( self:GetStatusBarColor() )
	self.BG:Show()
end

-- 设置法力条
local function SetPower(self, unit)
	self:Hide()
end

-- 设置Buff或Debuff
local function SetBuff(unit, GetBuff)
	tmp = 1
	tmp3 = ""
	while (GetBuff(unit, tmp)) do
		tmp2 = select(3, GetBuff(unit, tmp))
		tmp3 = tmp3 .. "|T" .. tmp2 .. ":18:18:1:-5|t"
		tmp = tmp + 1
	end
	TT:AddLine(tmp3)
end

-- 设置物品价格
--[[
local ItemPrice
local function SetItemPrice(self, itemID)
	GameTooltip_ClearMoney(self)
	if LibStub then
		ItemPrice = LibStub("ItemPrice-1.1", true)
	else
		return
	end
	local money = ItemPrice and ItemPrice:GetPriceById(tonumber(itemID))
	if money then
		if money == 0  then self:AddLine(ITEM_UNSELLABLE) end
		SetTooltipMoney(self, money)
	else
		self:AddLine(TTLoc["nodata"])
	end
end
]]
-- 设置物品信息
local itemLink, itemID, itemRarity, itemLevel, itemType, itemSubType, itemStackCount, itemTexture
local function SetItem(self, ...)
	itemLink = select(2, self:GetItem())
	if not itemLink then return end
	tmp = _G[self:GetName() .. "TextLeft1"]
	if strfind(tmp:GetText(), "|T") then return end --消除配方提示SetItem执行两遍的问题
	
	itemRarity, itemLevel, _, itemType, itemSubType, itemStackCount, _, itemTexture = select(3, GetItemInfo(itemLink))
	itemID = itemLink:match("item:(%d+)")
	if (not (self==TT and MerchantFrame:IsShown())) then	--价格
		--SetItemPrice(self, itemID)
	end
	if BAnd(32, TTVar.ItemInfo) and itemTexture then --图标
		itemTexture = "|T" .. itemTexture .. ":20|t "
		tmp:SetText(itemTexture .. tmp:GetText())
	end
	if BAnd(64, TTVar.ItemInfo) and itemRarity then --物品质量颜色显示边框
		self:SetBackdropBorderColor( GetItemQualityColor(itemRarity) )
	end
end

local function HoverTip()
	for i = 1, NUM_CHAT_WINDOWS do
		tmp = _G["ChatFrame"..i]
		tmp:SetScript("OnHyperlinkEnter", function(self, link, ...)
			tmp2 = link:match("^([^:]+)")
			tmp3 = "item:enchant:spell:quest:unit:talent:achievement:glyph"
			if not strfind(tmp3, tmp2) then 
				if (tmp2 == "YY") then
					tmp3 = link:match("YY:ID(%d+)");
					TT:SetOwner(self, "ANCHOR_TOPLEFT");	
					TT:SetText(link .. TTLoc["channel"]);
					--TT:AddLine(TTLoc["Click to join channel."] , 1, 1, 1);
					TT:Show();
				elseif (tmp2 == "WoWBoxShare") then
					TT:SetOwner(self, "ANCHOR_TOPLEFT");
					TT:SetText(TTLoc["share to your friends."]);
					TT:Show();
				end
				return;
			end
			TT:SetOwner(self, "ANCHOR_TOPLEFT");
			TT:SetHyperlink(link);
			TT:Show();
		end)
		tmp:SetScript("OnHyperlinkLeave", function(...)
			TT:Hide();
		end)
	end
end

local function OnShow()
	if TTVar.Scale then TT:SetScale(TTVar.Scale) end
	
	unit = select(2, TT:GetUnit())
	if unit then
		SetHealth(TTStatusBar[1], unit)
		--if TTVar.Power then SetPower(TTStatusBar[2], unit) end
		--if BAnd(1, TTVar.Buff) then SetBuff(unit, UnitBuff) end
		--if BAnd(2, TTVar.Buff) then SetBuff(unit, UnitDebuff) end
	else
		TTStatusBar[1].Text:SetText("");
		--TTStatusBar[1]:Hide()
		TTStatusBar[2]:Hide()
	end
	--[[
	if TTVar.NoShiftCompare and TT:GetItem() then
		tmp = GetMouseFocus()
		tmp = tmp and tmp:GetName() or ""
		if not strfind(tmp, "^Character.*Slot$") then
			GameTooltip_ShowCompareItem()
		end
	end
	]]
end

--锚点，修改自zTip
local function SetDefaultAnchor(tooltip,owner)
	if TTVar.Anchor == 0 then
		return
	end
	
	if owner == UIParent then 
		if UnitExists("mouseover") then --人物
			tooltip:SetOwner(owner, "ANCHOR_NONE")
			if TTVar.Anchor == 2 or TTVar.Anchor == 4 or  TTVar.Anchor == 5 then -- 在上方
				tooltip:SetPoint("TOP",UIParent,"TOP", TTVar.OffsetX, TTVar.OffsetY)
			end
		else --熔炉、信箱等
			tooltip:SetOwner(owner, "ANCHOR_CURSOR")
		end
	else -- 按钮等非人物提示
		-- 修复一键驱散显示重复问题
		
		if (owner and owner:GetName() and 
			(strfind(owner:GetName(), "^DcrMicroUnit") or 
			strfind(owner:GetName(), "^EclipseBarFrame") or 
			strfind(owner:GetName(), "^QHLArrowFrame") or
			strfind(owner:GetName(), "^GridLayoutHeader"))) then
				return;
		end
		if TTVar.Anchor == 3 or TTVar.Anchor == 4 then
			tooltip:SetOwner(owner,"ANCHOR_RIGHT")
		elseif TTVar.Anchor == 5 then
			tooltip:SetOwner(owner, "ANCHOR_NONE")
			tooltip:SetPoint("TOP",UIParent,"TOP", TTVar.OffsetX, TTVar.OffsetY)
		elseif TTVar.Anchor == 6 then
			tooltip:SetOwner(owner, "ANCHOR_NONE")
		else -- 默认位置（屏幕右下）			
			return
		end		
	end	
end

local function UpdateUintItemLevel(TT, unit)
	if (showItemLv) then
		local target,serverName = UnitName(unit)
		if serverName then
			target = target.."-"..serverName;
		end
		
		if (targetItemLevelInfo[target] and targetItemLevelInfo[target].itemLevel) then
			local text = TTLoc["ItemLevel"]..targetItemLevelInfo[target].itemLevel;
			local maxNum = TT:NumLines();
			local LeftText, tmpText, isFind;

			for i=1, maxNum, 1 do
				LeftText = _G[TT:GetName().."TextLeft"..i];	
				tmpText = LeftText:GetText();
				-- GameTooltip的bug, 无法获得正确的信息
				--if (not tmpText) then
				--	if (lastUnitItemLvl == text) then return end
				--	LeftText = _G[TT:GetName().."TextLeft"..maxNum];
				--	isFind = true;
				--	break;
				--else
				if(tmpText and string.find(tmpText, "^" .. TTLoc["ItemLevel"])) then
					if (LeftText:GetText() == text) then return end
					isFind = true;
					break;
				end
			end
		
		
			if (text) then
				lastUnitItemLvl = text;
				if (isFind) then
					LeftText:SetText(text, 1, 1, 1);
				else
					TT:AddLine(text, 1, 1, 1);
					TT:Show();
				end
			end
		end
	end	
end

local lastUpdate = 0
local x,y,scale
local function OnUpdate()
	if lastUpdate + 0.01 < GetTime() then
		if (TT:IsOwned(UIParent) and (TTVar.Anchor == 1 or TTVar.Anchor == 3))
		or (not MouseIsOver(Minimap) and TTVar.Anchor == 6) then
			x, y = GetCursorPosition()
			scale = UIParent:GetScale()
			if (scale and scale ~= 0) then
				x = (x + TTVar.OffsetX) / scale / TTVar.Scale
				y = (y + TTVar.OffsetY) / scale / TTVar.Scale - TT:GetHeight() / scale
			end
			TT:ClearAllPoints()
			TT:SetPoint("BOTTOMLEFT",UIParent,"BOTTOMLEFT", x, y)
		end

		name, unit = TT:GetUnit()
		if name and TT:IsOwned(UIParent) and not UnitExists("mouseover") then
			if not TTVar.Fade then
				TT:Hide()			
			end
		end
		
		if unit then			
			SetHealth(TTStatusBar[1], unit)
			UpdateUnitRange(TT, unit);
			--UpdateUintItemLevel(TT, unit);
			--UpdateUnitAvgItemLevel(TT, unit);
			TTUpdateItemLevel(TT, unit);
			--if TTVar.Power then SetPower(TTStatusBar[2], unit) end
			if TTVar.Talent and UnitLevel(unit) > 9 and not Inspected
			and CheckInteractDistance(unit, 1) and CanInspect(unit) then
				if (not InspectFrame or not InspectFrame:IsShown()) then
					inspectName = name
					inspectGUID = UnitGUID(unit);
					--TT:RegisterEvent("INSPECT_TALENT_READY")
					InspectLess:NotifyInspect(unit)
				end				
			end
			TT:Show();
		end

		if TTVar.HideInCombat and InCombatLockdown() and TT:IsShown() and TT:IsOwned(UIParent) then
			TT:Hide()
		end
		
		lastUpdate = GetTime()
	end
end

local function SlashCMD(msg)
	if msg == "" then
		DEFAULT_CHAT_FRAME:AddMessage("TinyTip by |c00abd473Hughman|r： |cFFFFFF00/tinytip(tth) cmd[=value]|r（取值為true/false的省略方括號內容）", 0, 1, 0)
		local a = {}
		for k in pairs(TTCfg) do tinsert(a, k) end
		table.sort(a)
		for _, k in pairs(a) do
			DEFAULT_CHAT_FRAME:AddMessage("    |cFFFFFF00" .. k .. "|r=|cFF00FF00" .. tostring(TTVar[k]) .. "|r |cFF808080(" .. TTCfg[k].desc .. ")")
		end
	elseif msg == "reset" then
		TTVar = {}
		for k in pairs(TTCfg) do
			TTVar[k] = TTCfg[k].value
		end
		DEFAULT_CHAT_FRAME:AddMessage("TinyTip: Reset", 0, 1, 0)
	elseif msg == "clear" then
		inspectList = {}
		DEFAULT_CHAT_FRAME:AddMessage("TinyTip: Clear Talent", 0, 1, 0)
	else
		if strfind(msg, "=") then
			tmp, tmp2 = msg:match("(.+)=(.+)")
		else
			tmp = msg
			tmp2 = nil
		end
		
		tmp3 = type(TTVar[tmp])
		if tmp3 == "number" and tmp2 then
			tmp2 = tonumber(tmp2)
			if tmp2 then TTVar[tmp] = tmp2 end
		elseif tmp3 == "boolean" then
			if TTVar[tmp] then
				TTVar[tmp] = false
			else
				TTVar[tmp] = true
			end
		elseif tmp3 == "string" and tmp2 then
			TTVar[tmp] = tmp2
		elseif not TTCfg[tmp] then
			TTVar[tmp] = nil
		end
		DEFAULT_CHAT_FRAME:AddMessage("|cFF00FF00TinyTip: " .. tmp .. "=|r|cFFFFFF00" .. tostring(TTVar[tmp]))
	end
end

local function OnLoad()
	for k in pairs(TTCfg) do
		if type(TTVar[k]) ~= type(TTCfg[k].value) then TTVar[k] = TTCfg[k].value end
	end
	
	--if TTVar.AltDKColor then RAID_CLASS_COLORS["DEATHKNIGHT"] = TTColor.DK end
	
	CreateStatusBar(TTStatusBar, 1)
	CreateStatusBar(TTStatusBar, 2)
	
	TT:SetScript("OnUpdate", OnUpdate)
	TT:SetScript("OnShow", OnShow)
	TT:HookScript("OnHide", function()
		lastUnitRange = nil;
		lastUnitItemLvl = nil;
		if (TT.talenticon) then TT.talenticon:Hide() end
		if (TT.icon) then TT.icon:Hide() end
		if (TT.peticon) then TT.peticon:Hide() end
		itemlevel = 0;
		avgitemlevel = 0;
	end);
	TT:HookScript("OnTooltipSetUnit", SetUnit)
	GameTooltip:HookScript("OnTooltipSetItem", SetItem)
	ItemRefTooltip:HookScript("OnTooltipSetItem", SetItem)
	--hooksecurefunc(ShoppingTooltip1, "SetHyperlinkCompareItem", SetItem)
	--hooksecurefunc(ShoppingTooltip2, "SetHyperlinkCompareItem", SetItem)
	hooksecurefunc("GameTooltip_SetDefaultAnchor", SetDefaultAnchor)
	TTStatusBar[1]:HookScript("OnValueChanged", SetHealth)
	--SetCVar("showNewbieTips", "0");	
	if TTVar.HoverLink then HoverTip() end
	
	-- 增加
	InspectLess.RegisterCallback(tip, "InspectLess_InspectReady")

	-- 添加3D效果的皮肤
	local skin = GameTooltip:CreateTexture(nil, "BORDER");
	skin:SetTexture("Interface\\ChatFrame\\ChatFrameBackground");
	skin:SetPoint("TOPLEFT", GameTooltip, "TOPLEFT", 6, -6);
	skin:SetPoint("BOTTOMRIGHT", GameTooltip, "TOPRIGHT", -6, -27);
	skin:SetBlendMode("ADD");
	skin:SetGradientAlpha("VERTICAL", .1, .1, .1, 0, .2, .2, .2, 1); 
	
	SLASH_TinyTip1 = "/tinytip"
	SLASH_TinyTip2 = "/tth"
	SlashCmdList["TinyTip"] = SlashCMD

	RegisterAddonMessagePrefix("MyItemLevel");
end

local tabs, points, colors = {}, {}, {}
local function OnEvent(self, event, ...)
	local addonName = ...;
	if event == "ADDON_LOADED" and addonName == "TinyTip" then
		OnLoad()
		TT:UnregisterEvent("ADDON_LOADED")
	end	
end

--~ 天赋图标
local function SetTalentIcon(icontexture)
	if not icontexture then return end
	local tline = _G["GameTooltipTextLeft" .. talentLine];

	if not TT.talenticon then
		TT.talenticon = GameTooltip:CreateTexture(nil, "OVERLAY")
		TT.talenticon:SetWidth(15); TT.talenticon:SetHeight(15);
		TT.talenticon:SetPoint("LEFT", tline, 1, -1)
		TT.talenticon:SetTexture(icontexture)
		TT.talenticon:Hide()
	end

	TT.talenticon:SetPoint("LEFT", tline, 1, -1)
	TT.talenticon:SetTexture(icontexture)
	TT.talenticon:Show()

end

function tip:InspectLess_InspectReady(event, unit, guid)
	if (inspectGUID and inspectGUID == guid) then
		name = inspectName;
		inspectName = nil;
		inspectGUID = nil;

		local _, name2, _, icon, _,style = GetSpecializationInfoByID(GetInspectSpecialization(unit))
		if (name2 and icon) then
			local talentInfo = format("    %s: |cff00ff00%s[%s]|r", TALENTS[1], name2 or NONE, style and _G[style] or NONE);
			if (inspectList[name] ~= talentInfo) then
				inspectList[name] = talentInfo
			end
			TextLine = _G["GameTooltipTextLeft" .. talentLine];
			TextLine:SetText(talentInfo);
			SetTalentIcon(icon);
			TT:Show();
		end
		
		Inspected = true
		if InspectFrame and InspectFrame:IsShown() then
			NotifyInspect(InspectFrame.unit)	--重新获取正在观察的对象的数据
		end
	end		
end

--------------------------------
-- 显示玩家装备等级
local f = CreateFrame('Frame');
local events = {
	'CHAT_MSG_ADDON',
	'UPDATE_MOUSEOVER_UNIT',
	'PLAYER_ENTERING_WORLD',
}

for _, event in pairs(events) do
	f:RegisterEvent(event);
end

f:SetScript('OnEvent', function(self, event, ...)
	if floor(GetAverageItemLevel()) then
		if event == "UPDATE_MOUSEOVER_UNIT" then
			if UnitExists("mouseover") and UnitIsPlayer("mouseover") and UnitIsFriend("player","mouseover") then
				local target,serverName = UnitName("mouseover")
				if serverName then
					target = target.."-"..serverName;
				end
				if not targetItemLevelInfo[target] or
				(targetItemLevelInfo[target] and targetItemLevelInfo[target].refresh and targetItemLevelInfo[target].refresh <= GetTime()) then
					targetItemLevelInfo[target] = {};
					local isInInstance = nil;
					if UnitInBattleground("mouseover") then
						isInInstance = true;						
					elseif UnitInRaid("mouseover") then
						if IsInLFGDungeon() then
							isInInstance = true;
						else
							SendAddonMessage("MyItemLevel","MyItemLevel@"..floor(GetAverageItemLevel()),'RAID')
						end						
					elseif UnitInParty("mouseover") and UnitName("mouseover") ~= UnitName("player") then
						if IsInLFGDungeon() then
							isInInstance = true;
						else
							SendAddonMessage("MyItemLevel","MyItemLevel@"..floor(GetAverageItemLevel()),'PARTY')
						end
					else	
						if (not serverName) then
							SendAddonMessage("MyItemLevel","ShowMeLevel@"..floor(GetAverageItemLevel()),'WHISPER',target)
						end						
					end

					if (isInInstance) then
						SendAddonMessage("MyItemLevel","MyItemLevel@"..floor(GetAverageItemLevel()),'INSTANCE_CHAT')
					end
				end
			end			
		elseif event == "CHAT_MSG_ADDON" then
			local _,message,channel,sender = ...;
			local prefix, level = strsplit("@", message);
			if prefix and message and sender then
				if prefix == "MyItemLevel" or prefix == "ShowMeLevel" then
					targetItemLevelInfo[sender] = targetItemLevelInfo[sender] or {};
					targetItemLevelInfo[sender].itemLevel = tonumber(level);
					targetItemLevelInfo[sender].refresh = GetTime() + 1000;
					if prefix == "ShowMeLevel" then
						SendAddonMessage("MyItemLevel","MyItemLevel@"..floor(GetAverageItemLevel()),'WHISPER',sender)
					end
				end
			end
		elseif (event == "PLAYER_ENTERING_WORLD") then
			RegisterAddonMessagePrefix("MyItemLevel");
		end
	end
end)

function ItemLevelShow()
	if not showItemLv then return end

	local target,serverName = UnitName("mouseover")
	if serverName then
		target = target.."-"..serverName;
	end
	if targetItemLevelInfo[target] and targetItemLevelInfo[target].itemLevel and targetItemLevelInfo[target].refresh and targetItemLevelInfo[target].refresh > GetTime() then
		if UnitExists("mouseover") and UnitIsPlayer("mouseover") and UnitIsFriend("player","mouseover") and (CanInspect("mouseover")) then
			GameTooltip:AddLine(TTLoc["ItemLevel"]..targetItemLevelInfo[target].itemLevel, 1, 1, 1)
		end
	end
end

local DECIMAL_PLACES = 2
local invalidSlots = { [INVSLOT_BODY] = true, [INVSLOT_TABARD] = true, [INVSLOT_RANGED] = true, }
local coefficient = 10 ^ DECIMAL_PLACES
local formatString = '%.' .. DECIMAL_PLACES .. 'f'
local function calculate (unit, slot, total, count, is2Handed, isRetrieving)
	if ( slot > INVSLOT_LAST_EQUIPPED ) then
		if ( not isRetrieving ) then
			return tonumber(formatString:format(math.floor(total / (is2Handed and count - 1 or count) * coefficient) / coefficient))
		end
		return
	end

	if ( invalidSlots[slot] ) then
		return calculate(unit, slot + 1, total, count, is2Handed, isRetrieving)
	end
	
	local ItemLink = GetInventoryItemLink(unit, slot)
	local name,_, level, equipLoc
	if ( ItemLink ) then
		name, _, _, level, _, _, _, _, equipLoc = GetItemInfo(ItemLink)
	end

	if ( isRetrieving or ItemLink and not (level and equipLoc) ) then
		return calculate(unit, slot + 1, total, count, is2Handed, true)
	end

	total = ItemLink and total + level or total
	count = count + 1

	if ( slot == INVSLOT_MAINHAND ) then
		is2Handed = not ItemLink and 0 or equipLoc == 'INVTYPE_2HWEAPON' and 1
	elseif ( slot == INVSLOT_OFFHAND ) then
		is2Handed = is2Handed == 0 and equipLoc == 'INVTYPE_2HWEAPON' or is2Handed == 1 and not ItemLink
	end

	return calculate(unit, slot + 1, total, count, is2Handed)
end

-----------当前装等获取函数----------------------
local function GetUnitAvgItemLevle (unit)	
	return calculate(unit, INVSLOT_FIRST_EQUIPPED, 0, 0)
end

function UpdateUnitAvgItemLevel(TT, unit)
	if not showItemLv then return end

	local itemAvgLvl =  math.floor(dwGetUnitAvgItemLevel(unit));
	if (itemAvgLvl == 0) then return end

	local text = TTLoc["AvgItemLvl"] .. itemAvgLvl;
	local maxNum = TT:NumLines();
	local LeftText, tmpText, isFind;

	for i=1, maxNum, 1 do
		LeftText = _G[TT:GetName().."TextLeft"..i];	
		tmpText = LeftText:GetText();
		
		if(tmpText and string.find(tmpText, "^" .. TTLoc["AvgItemLvl"])) then
			if (LeftText:GetText() == text) then return end
			isFind = true;
			break;
		end
	end

	if (text) then
		lastUnitAvgItemLvl = text;
		if (isFind) then
			LeftText:SetText(text, 1, 1, 1);
		else
			TT:AddLine(text, 1, 1, 1);
			TT:Show();
		end
	end
end

function ShowUnitAvgItemLevel(TT, unit)	
	if not showItemLv then return end

	local perLvl = math.floor(dwGetUnitAvgItemLevle(unit)+0.5);	
	if (perLvl > 0) then
		TT:AddLine(TTLoc["AvgItemLvl"] .. perLvl, 1, 1, 1);
		TT:Show();	
	end	
end

function ItemLevel_Toggle(switch)
	if (switch) then
		showItemLv = true;
	else
		showItemLv = false;
	end
end

function TTUpdateItemLevel(TT, unit)
	if not showItemLv then return end
	local target,serverName = UnitName(unit)
	if serverName then
		target = target.."-"..serverName;
	end
	local itemLvl = (targetItemLevelInfo[target] and targetItemLevelInfo[target].itemLevel) and targetItemLevelInfo[target].itemLevel or 0;
	local itemAvgLvl =  math.floor(dwGetUnitAvgItemLevel(unit) or 0) or 0;
	if (itemLvl == 0 and itemAvgLvl == 0) then return end
	local itemLvlText = format("%s%d", TTLoc["AvgItemLvl"], itemAvgLvl);
	if (itemLvl > 0) then
		itemLvlText = format("%s%d / %d", TTLoc["ItemLevel"], itemAvgLvl, itemLvl);
	end	

	local maxNum = TT:NumLines();
	local LeftText, tmpText, isFind;
	for i=1, maxNum, 1 do
		LeftText = _G[TT:GetName().."TextLeft"..i];
		tmpText = LeftText:GetText();
		if(tmpText and (string.find(tmpText, "^" .. TTLoc["ItemLevel"]) or string.find(tmpText, "^" .. TTLoc["AvgItemLvl"]))) then
			if (LeftText:GetText() == itemLvlText) then return end
			isFind = true;
			break;
		end
	end

	if (itemLvlText) then
		lastUnitItemLvl = itemLvlText;
		if (isFind) then
			LeftText:SetText(itemLvlText, 1, 1, 1);
		else
			TT:AddLine(itemLvlText, 1, 1, 1);
			TT:Show();
		end
	end
end


TT:SetScript("OnEvent", OnEvent)
TT:RegisterEvent("ADDON_LOADED")
