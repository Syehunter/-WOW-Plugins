if (select(2, UnitClass('player')) ~= "MONK") then return end
local _;
---------------------------
       -- config --
---------------------------
local position = {a1 = "BOTTOM", parent = UIParent, a2 = "BOTTOM", x = 0, y = 210}--195
local positionaura = {a1 = "BOTTOM", parent = UIParent, a2 = "BOTTOM", x = 0, y = 165}
local positionauraright = {a1 = "BOTTOM", parent = UIParent, a2 = "BOTTOM", x = 150, y = 270}

local powerx = 45                     -- 当能量大于此数值时变色
local second1 = 3                     -- 酒醒入定的发光时间
local countbm = 10                    -- 飘渺酒发光层数
local showtg = true

local mediapath = "Interface\\AddOns\\BMHelper\\media\\"
local font = mediapath.."expressway.TTF"
local growcolor ={r = 1, g = 0.8, b = 0.05} -- 发光颜色

local chi = {
	one = "D",
	two = "D D",
	three = "F F F",
	four = "B B B B",
	five = "G G G G G",
	}

local locked = true
local enableTank = true

---------------------------
     -- config end --
---------------------------

local applyDragFunctionality = function(f,locked)
	f:SetScript("OnDragStart", function(s) s:StartMoving() end)
	f:SetScript("OnDragStop", function(s) s:StopMovingOrSizing() end)

	local t = f:CreateTexture(nil,"OVERLAY",nil,6)
	t:SetPoint("TOPLEFT",-10,10)
	t:SetPoint("BOTTOMRIGHT",10,-10)
	t:SetTexture(0,1,0.5)
	t:SetAlpha(0)
	f.dragtexture = t
	f:SetClampedToScreen(true)
	
	f:SetMovable(true)
	f:SetUserPlaced(true)
	if not locked then
		f.dragtexture:SetAlpha(0.2)
		f:EnableMouse(true)
		f:RegisterForDrag("LeftButton")
		f:SetScript("OnEnter", function(s)
			GameTooltip:SetOwner(s, "ANCHOR_TOP")
			GameTooltip:AddLine(s:GetName(), 0, 1, 0.5, 1, 1, 1)
			GameTooltip:Show()
		end)
		f:SetScript("OnLeave", function(s) GameTooltip:Hide() end)
	else
		f.dragtexture:SetAlpha(0)
		f:EnableMouse(nil)
		f:RegisterForDrag(nil)
		f:SetScript("OnEnter", nil)
		f:SetScript("OnLeave", nil)
	end
  end

-- time
local GetFormattedTime = function(time)
	local hr, m, s, text
	if time <= 0 then text = ""
	elseif(time < 3600 and time > 60) then
		hr = floor(time / 3600)
		m = floor(mod(time, 3600) / 60 + 1)
		text = format("%dm", m)
	elseif time < 60 then
		m = floor(time / 60)
		s = mod(time, 60)
		text = (m == 0 and format("%d", s))
	else
		hr = floor(time / 3600 + 1)
		text = format("%dh", hr)
	end
	return text
end

-- texture
local function createtex(f)
	local tex = f:CreateTexture(nil,"OVERLAY")
	local inset = f:GetWidth()/5

	tex:SetPoint("TOPLEFT",-inset,inset)
	tex:SetPoint("BOTTOMRIGHT",inset,-inset)

	tex:SetTexture(mediapath.."Normal")
	tex:SetVertexColor(1, 1, 1)

	f.tex = tex
end

-- animation
local function newAnim(a, type, change, order)
	local anim = a:CreateAnimation(type)
	anim:SetDuration(1)
	anim:SetOrder(order)

	if type == 'Scale' then
		anim:SetOrigin('CENTER', 0, 0)
		anim:SetScale(change, change)
	else
		anim:SetChange(change)
	end
end

local function creAnim(a)
	newAnim(a, 'Scale', 1.3, 1)
	newAnim(a, 'Alpha', .7, 1)

	newAnim(a, 'Scale', -1.3, 2)
	newAnim(a, 'Alpha', -.7, 2)
end

local function creAnimframe(parent,id)
	local aFrame = CreateFrame('Button', nil, parent)
	aFrame:SetAllPoints()
	aFrame:SetFrameLevel(parent:GetFrameLevel() -1)
	aFrame:SetAlpha(0)
	aFrame:SetNormalTexture(select(3, GetSpellInfo(id)))
	createtex(aFrame)
	local Anims = aFrame:CreateAnimationGroup()
	Anims:SetLooping("NONE")
	creAnim(Anims)

	parent.aFrame = aFrame
	parent.Anims = Anims
end

local function playanim(parent)
	Anims = parent.Anims
	if not Anims:IsPlaying() then
		Anims:Play()
	end
end

local function stopanim(parent)
	Anims = parent.Anims
	if Anims:IsPlaying() then
		Anims:Stop()
	end
end

-- find aurasize

local locale = GetLocale()

debuff_class_types = locale == "deDE" and {
    magic = "Magie",
    curse = "Fluch",
    disease = "Krankheit",
    poison = "Gift",
    enrage = "Wutanfall",
    none = "Keine(r)",
} or locale == "zhCN" and {
    magic = "魔法",
    curse = "诅咒",
    disease = "疾病",
    poison = "中毒",
    enrage = "激怒",
    none = "无",
} or locale == "zhTW" and {
    magic = "魔法",
    curse = "詛咒",
    disease = "疾病",
    poison = "中毒",
    enrage = "激怒",
    none = "無",
}

function GetHiddenTooltip()
    if not(hiddenTooltip) then
        hiddenTooltip = CreateFrame("GameTooltip", "WeakAurasTooltip", nil, "GameTooltipTemplate");
        hiddenTooltip:SetOwner(WorldFrame, "ANCHOR_NONE");
        hiddenTooltip:AddFontStrings(
        hiddenTooltip:CreateFontString("$parentTextLeft1", nil, "GameTooltipText"),
        hiddenTooltip:CreateFontString("$parentTextRight1", nil, "GameTooltipText")
        );
    end
    return hiddenTooltip;
end
	
function GetAuraTooltipInfo(unit, index, filter)
	local tooltip = GetHiddenTooltip();
	tooltip:SetUnitAura(unit, index, filter);
	local lines = { tooltip:GetRegions() };
	local tooltipText = lines[12] and lines[12]:GetObjectType() == "FontString" and lines[12]:GetText() or "";
	local debuffType = lines[11] and lines[11]:GetObjectType() == "FontString" and lines[11]:GetText() or "";
	local found = false;
	for i,v in pairs(debuff_class_types) do
		if(v == debuffType) then
			found = true;
			debuffType = i;
			break;
		end
	end
	if not(found) then
		debuffType = "none";
	end
	local tootipSize, _;
	if(tooltipText) then
		_, _, tooltipSize = tooltipText:find("(%d+)")
	end
	return tooltipText, debuffType, tonumber(tooltipSize) or 0;
end

-----------------------------------
-- frame
-----------------------------------
local bmh = CreateFrame("frame", "BMHelperCHIFrame", UIParent)
bmh:SetPoint(position.a1, position.parent, position.a2, position.x, position.y)
bmh:SetSize(250,70)
applyDragFunctionality(bmh,locked)

local bmhaura = CreateFrame("frame", "BMHelperAuraFrame", UIParent)
bmhaura:SetPoint(positionaura.a1, positionaura.parent, positionaura.a2, positionaura.x, positionaura.y)
bmhaura:SetSize(300,150)
applyDragFunctionality(bmhaura,locked)

local bmhauraright = CreateFrame("frame", "BMHelperAuraRightFrame", UIParent)
bmhauraright:SetPoint(positionauraright.a1, positionauraright.parent, positionauraright.a2, positionauraright.x, positionauraright.y)
bmhauraright:SetSize(50,100)
applyDragFunctionality(bmhauraright,locked)

local BM_Frames = {
	"BMHelperCHIFrame",
	"BMHelperAuraFrame",
	"BMHelperAuraRightFrame",
}
-----------------------------------
-- power and chi text
-----------------------------------
local bmhtext = bmh:CreateFontString(nil, "OVERLAY")
bmhtext:SetPoint("TOP")
bmhtext:SetFont(font, 25, "OUTLINE")

local bmhpowertext = bmh:CreateFontString(nil, "OVERLAY")
bmhpowertext:SetPoint("BOTTOM")
bmhpowertext:SetFont(font, 25, "OUTLINE")

local function update()
	local chitext, chicolor
	local chip = UnitPower("player", 12)
	local power = UnitPower("player", 3)

	if chip == 1 then
		chitext = chi.one
		chicolor = {r = 1, g = 0, b = 0}
	elseif chip == 2 then
		chitext = chi.two
		chicolor = {r = 1, g = .65, b = .15}
	elseif chip == 3 then
		chitext = chi.three
		chicolor = {r = 1, g = 1, b = .3}
	elseif chip == 4 then
		chitext = chi.four
		chicolor = {r = 0.2, g = 1, b = 0.5}
	elseif chip == 5 then
		chitext = chi.five
		chicolor = {r = 0.3, g = 1, b = 0.9}	
	else
		chitext = ""
		chicolor = {r = 0, g = 0, b = 0}
	end
		
	bmhtext:SetTextColor(chicolor.r, chicolor.g, chicolor.b)	
	bmhtext:SetText(chitext)

	if power > powerx then
		bmhpowertext:SetTextColor(0.3, 1, 0.8, 0.6)
	else
		bmhpowertext:SetTextColor(1, 0.7, 0.3, 0.6)
	end
	bmhpowertext:SetText(" "..power.." ")
end

bmh:SetScript("OnEvent", function(self, event, ...)
    self[event](self, ...)
end)

function bmh:PLAYER_ENTERING_WORLD()
	update()
end

function bmh:UNIT_POWER()
	update()
end

function bmh:UNIT_ENTERED_VEHICLE(unit)
	if unit == "player" then
		print("UNIT_ENTERED_VEHICLE hide")
		bmh:Hide()
	end
end

function bmh:UNIT_EXITED_VEHICLE(unit)
	if unit == "player" then
		print("UNIT_ENTERED_VEHICLE show")
		bmh:Show()
	end
end

bmh:RegisterEvent("UNIT_POWER")
bmh:RegisterEvent("PLAYER_ENTERING_WORLD")
bmh:RegisterEvent("UNIT_ENTERED_VEHICLE")
bmh:RegisterEvent("UNIT_EXITED_VEHICLE")

-----------------------------------
-- Createbutton
-----------------------------------
local function createbutton(i, id, size, show)
i:SetFrameStrata("BACKGROUND")
i:SetFrameLevel(3)
i:SetSize(size, size)
i:SetNormalTexture(select(3, GetSpellInfo(id)))
i:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
createtex(i)
if not show then
	i:SetAlpha(0)
	end

	local timercen = i:CreateFontString(nil, "OVERLAY")
	timercen:SetPoint("CENTER", i, "CENTER", 0, 0)
	timercen:SetFont(font, size-7, "OUTLINE")

	local timerbl = i:CreateFontString(nil, "OVERLAY")
	timerbl:SetPoint("BOTTOMLEFT", i, "BOTTOMLEFT", 0, 0)
	timerbl:SetFont(font, size/2-1, "OUTLINE")

	local countt = i:CreateFontString(nil, "OVERLAY")
	countt:SetPoint("TOPRIGHT", i, "TOPRIGHT", 0, 0)
	countt:SetTextColor(0.3, 0.9, 1)
	countt:SetFont(font, size/2-1, "OUTLINE")

	i.timercen = timercen
	i.timerbl = timerbl
	i.countt = countt
end


local auratext = bmhaura:CreateFontString(nil, "OVERLAY")
auratext:SetPoint("TOPRIGHT", bmhaura, "TOP", -30, -108)
auratext:SetFont(font, 14, "OUTLINE")

-----------------------------------
-- UpdateAura
-----------------------------------
local function createbuff(i, id, auratype, show, tc, tbl, ctt, gw, growtime, growcount)

	timercen = i.timercen
	timerbl = i.timerbl
	countt = i.countt

	local aura_name, aura_rank, aura_icon = GetSpellInfo(id)
	local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, shouldConsolidate, spID = UnitAura("player", aura_name, aura_rank, auratype)
	
	if name then
		if not show then
			i:SetAlpha(1)
		end
		i:GetNormalTexture():SetDesaturated(false)
	else
		if not show then
			i:SetAlpha(0)
		end
		i:GetNormalTexture():SetDesaturated(true)
	end	
	
	-- timercen
	if tc then
		if name then
		local value = expires-GetTime()
		    timercen:SetText(GetFormattedTime(value))
			if value < 5 then
				timercen:SetTextColor(1, 0.4, 0)
			else
				timercen:SetTextColor(1, 0.8, 0)
			end
		else
			timercen:SetText(" ")
			timercen:SetTextColor(1, 0.4, 0)
		end
	end
	
	-- timerbl
	if tbl then
		if name then
			local value1 = expires-GetTime()
			timerbl:SetText(GetFormattedTime(value1))
			if value1 < 5 then
				timerbl:SetTextColor(1, 0.4, 0)
			else
				timerbl:SetTextColor(1, 0.8, 0)
			end
		else
			timerbl:SetText(" ")
			timerbl:SetTextColor(1, 0.4, 0)
		end
	end
	
	-- count
	if ctt then
		if name then
			countt:SetText(count)
		else
			countt:SetText(" ")
		end
	end
	
		-- grow on time
	if gw and growtime then
		if name then
		local value2 = expires-GetTime()
			if value2 < growtime then
				i.tex:SetVertexColor(growcolor.r, growcolor.g, growcolor.b)
				else
				i.tex:SetVertexColor(1, 1, 1, 1)
			end
		else
			i.tex:SetVertexColor(1, 1, 1, 1)
		end
	end
	
		-- gorw on count
	if gw and growcount then
		if name then
			if count > growcount-1 then
				i.tex:SetVertexColor(growcolor.r, growcolor.g, growcolor.b)
				else
				i.tex:SetVertexColor(1, 1, 1, 1)
			end
		else
			i.tex:SetVertexColor(1, 1, 1, 1)
		end
	end 
end

local function createcooldown(i, id, show, cd, gw, growtime)

	timercen = i.timercen

	local start, duration, enable = GetSpellCooldown(id)
	
	if start and duration then
		local now = GetTime()
		local value = start+duration-now

		if not ((value > 0) and duration > 2) then
				if not show then
					i:SetAlpha(1)
				end
				i:GetNormalTexture():SetDesaturated(false)
		else --item is on cooldown show time
				if not show then
					i:SetAlpha(0)
				end
				i:GetNormalTexture():SetDesaturated(true)    
		end
	end
		-- cd
	if cd then
		if start and duration then
			local now = GetTime()
			local value1 = start+duration-now

			if not ((value1 > 0) and duration > 2) then
				timercen:SetTextColor(0, 0.8, 0)
				timercen:SetText(" ")
			else --item is on cooldown show time
				if value1 < 5 then
					timercen:SetTextColor(1, 0.4, 0)
				else
					timercen:SetTextColor(1, 0.8, 0)
				end
				timercen:SetText(GetFormattedTime(value1))      
			end
		end
	end
		-- grow on time
	if gw and growtime then
		if start and duration then
			local now = GetTime()
			local value2 = start+duration-now
			
			if not ((value2 > 0) and duration > 2) then
				i.tex:SetVertexColor(growcolor.r, growcolor.g, growcolor.b)
			else --item is on cooldown show time
				if value2 < growtime then
					i.tex:SetVertexColor(growcolor.r, growcolor.g, growcolor.b)
				else
					i.tex:SetVertexColor(1, 1, 1, 1)
				end   
			end
		end
	end
end

local function hideAwhenB(IA,ib)
	for _, v in pairs(IA) do
		f = _G[v]
		if f then
			if ib:GetAlpha() == 1 then
				f:SetAlpha(0)
			else
				f:SetAlpha(1)
			end
		end
	end
end

local function checkaura(id,auratype,atime,acount)
	local aura_name, aura_rank, aura_icon = GetSpellInfo(id)
	local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, shouldConsolidate, spID = UnitAura("player", id)--UnitAura("player", aura_name, aura_rank, auratype)

	if name then
		local value = expires-GetTime()
		if (atime and value < atime) or (acount and count > acount) or not(atime or acount) then
		return true end
	end
end

local function findbmdindex()
	for i = 1, DEBUFF_ACTUAL_DISPLAY do
	local debuff = (select(11, UnitDebuff("player", i)))
		if debuff == 124273 or debuff == 124274 or debuff == 124275 then
			return i
		end
	end
end

hooksecurefunc("DebuffButton_UpdateAnchors", findbmdindex)
  
local function update3()
	if checkaura(124273,"HARMFUL", nil, nil) == true then
		auratext:SetTextColor(1, 0, 0)
	elseif checkaura(124274,"HARMFUL", nil, nil) == true then
		auratext:SetTextColor(1, 1, 0.2)
	elseif checkaura(124275,"HARMFUL", nil, nil) == true then
		auratext:SetTextColor(0.2, 1, 0.2)
	else
		auratext:SetTextColor(1, 1, 1)
	end

	local tooltip, debuffClass, tooltipSize
	local indexfind = findbmdindex()
	if indexfind then
		tooltip, debuffClass, tooltipSize = GetAuraTooltipInfo("player", indexfind, "HARMFUL")
		auratext:SetText(tooltipSize)
		--print("在1到"..DEBUFF_ACTUAL_DISPLAY.."中"..indexfind.."是醉拳")
	else
		auratext:SetText("")
	end
end
-----------------------------------
-- debuffs and cooldown
-----------------------------------

--酒醒入定
local icon1 = CreateFrame("Button", "bmhicon1", bmhaura)
icon1:SetPoint("TOPLEFT", bmhaura, "TOP", 30, -70)
createbutton(icon1, 115307, 35, true)

--飘渺酒(叠加)
local icon2 = CreateFrame("Button", "bmhicon2", bmhaura)
icon2:SetPoint("TOPRIGHT", bmhaura, "TOP", -20, -5)
createbutton(icon2, 128939, 25, true)

--飘渺酒(消耗)
local icon3 = CreateFrame("Button", "bmhicon3", bmhaura)
icon3:SetPoint("TOPRIGHT", bmhaura, "TOP", -20, -5)
createbutton(icon3, 115308, 25, nil)
local Icon3hide = {
	"bmhicon2",
}

-- 禅意珠
local icon4 = CreateFrame("Button", "bmhicon4", bmhaura)
icon4:SetPoint("TOP", bmhaura, "TOP", 0, -5)
createbutton(icon4, 124081, 25, true)

-- 轻度醉拳
local icon5 = CreateFrame("Button", "bmhicon5", bmhaura)
icon5:SetPoint("TOPRIGHT", bmhaura, "TOP", -30, -70)
createbutton(icon5, 124275, 35, true)

-- 中度醉拳
local icon6 = CreateFrame("Button", "bmhicon6", bmhaura)
icon6:SetPoint("TOPRIGHT", bmhaura, "TOP", -30, -70)
createbutton(icon6, 124274, 35, nil)
local Icon6hide = {
	"bmhicon5",
}

-- 重度醉拳
local icon7 = CreateFrame("Button", "bmhicon7", bmhaura)
icon7:SetPoint("TOPRIGHT", bmhaura, "TOP", -30, -70)
createbutton(icon7, 124273, 35, nil)
local Icon7hide = {
	"bmhicon5",
}

-- 金钟罩(CD)
local icon8 = CreateFrame("Button", "bmhicon8", bmhaura)
icon8:SetPoint("TOPLEFT", bmhaura, "TOP", 20, -5)
createbutton(icon8, 115295, 25, true)

-- 金钟罩(buff)
local icon9 = CreateFrame("Button", "bmhicon9", bmhaura)
icon9:SetPoint("TOPLEFT", bmhaura, "TOP", 20, -5)
createbutton(icon9, 115295, 25, nil)
local Icon9hide = {
	"bmhicon8",
}

--[[ 慈悲庇护
local icon10 = CreateFrame("Button", "bmhicon10", bmhauraright)
icon10:SetPoint("TOP", bmhauraright, "TOP", 0, -5)
createbutton(icon10, 115213, 30, true)
]]
-- 酒壮人胆
local icon11 = CreateFrame("Button", "bmhicon11", bmhauraright)
icon11:SetPoint("TOP", bmhauraright, "TOP", 0, -45)
createbutton(icon11, 115203, 30, true)

-- 醉酿投 + 移花接木 + 贯日击
local icon12 = CreateFrame("Button", "bmhicon12", bmhaura)
icon12:SetPoint("TOP", bmhaura, "TOP", 0, -70)
createbutton(icon12, 115687, 45, true)

-- 猛虎掌
local icon13 = CreateFrame("Button", "bmhicon13", bmhauraright)
icon13:SetPoint("TOP", bmhauraright, "TOP", 0, -85)
createbutton(icon13, 125359, 25, true)

local function updatechispell(i)
	local start1, duration1, enable1 = GetSpellCooldown(121253) --醉酿投
	local start2, duration2, enable2 = GetSpellCooldown(115072) --移花接木
	
	local now = GetTime()
	local value1 = start1+duration1-now
	local value2 = start2+duration2-now
	
	if not (value1 > 1) then -- 醉酿投冷却结束或者小于2秒
		i.tex:SetVertexColor(1, 0.3, 0.8)
		i:SetNormalTexture(select(3, GetSpellInfo(121253)))
	elseif not ((value2 > 0) and duration2 > 2) then -- 移花接木冷却结束
		i.tex:SetVertexColor(0.3, 1, 0.8)
		i:SetNormalTexture(select(3, GetSpellInfo(115072)))
	else
		i.tex:SetVertexColor(0.7, 0.6, 0)
		i:SetNormalTexture(select(3, GetSpellInfo(115687)))
	end
	
	local power = UnitPower("player", 3)
	local chip = UnitPower("player", 12)
	
	if (power > 40) and (chip < 3) then -- 真气小于3 且 能量大于40
		i:GetNormalTexture():SetDesaturated(false)
	else
		i:GetNormalTexture():SetDesaturated(true)
	end
end

-----------------------------------
-- init
-----------------------------------
local function update()
	--createbuff(i, id, auratype, show, tc, tbl, ctt, gw, growtime, growcount)
	--createcooldown(i, id, show, cd, gw, growtime)
	createbuff(icon1, 115307, "HElPFUL",true, true, nil, nil, true, second1, nil)
	createbuff(icon2, 128939, "HElPFUL",true, nil, true, true, true, nil, 2)
	createbuff(icon3, 115308, "HElPFUL",nil, true, nil, nil, true, 20, nil)
	hideAwhenB(Icon3hide,icon3)
	createbuff(icon4, 124081, "HElPFUL",true, true, nil, nil, true, 20, nil)
	createbuff(icon5, 124275, "HARMFUL",true, true, nil, nil, nil, nil, nil)
	createbuff(icon6, 124274, "HARMFUL",nil, true, nil, nil, nil, nil, nil)
	hideAwhenB(Icon6hide,icon6)
	createbuff(icon7, 124273, "HARMFUL",nil, true, nil, nil, nil, nil, nil)
	hideAwhenB(Icon7hide,icon7)
	createcooldown(icon8, 115295, true, true, true, 6)
	createbuff(icon9, 115295, "HElPFUL",nil, true, nil, nil, true, 30, nil)
	hideAwhenB(Icon9hide,icon9)
--	createcooldown(icon10, 115213, true, true, true, 1)
	createcooldown(icon11, 115203, true, true, true, 1)
	updatechispell(icon12)
	createbuff(icon13, 125359, "HElPFUL", true, nil, true, true, true, 25, nil)
end

local function update2()
	if checkaura(118636,"HELPFUL", nil, 2) == true then
		ActionButton_ShowOverlayGlow(icon8)
	else
		ActionButton_HideOverlayGlow(icon8)
	end
	if checkaura(125359,"HELPFUL", second1, nil) == true then
		ActionButton_ShowOverlayGlow(icon13)
	else
		ActionButton_HideOverlayGlow(icon13)
	end
end

if showtg then
	icon13:SetAlpha(1)
else
	icon13:SetAlpha(0)
end
-----------------------------------
-- update
-----------------------------------
bmhaura:SetScript("OnEvent", function(self,event)
	if event == "UNIT_AURA" or event == "UNIT_HEALTH" or event == "UNIT_POWER" or event == "PLAYER_REGEN_DISABLED" then
		update()
		update2()
		update3()
	end
	
	for _, v in pairs(BM_Frames) do
		f = _G[v]
		if f then
			if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_TALENT_UPDATE" or event == "CHARACTER_POINTS_CHANGED" or event == "PLAYER_REGEN_ENABLED" then
				f:SetAlpha(0.2)
			elseif event == "PLAYER_REGEN_DISABLED" then
				f:SetAlpha(1)
			end
		end
	end
end)

bmhaura:RegisterEvent("UNIT_AURA")
bmhaura:RegisterEvent("UNIT_HEALTH")
bmhaura:RegisterEvent("UNIT_POWER")
bmhaura:RegisterEvent("PLAYER_REGEN_ENABLED")
bmhaura:RegisterEvent("PLAYER_REGEN_DISABLED")
bmhaura:RegisterEvent("PLAYER_ENTERING_WORLD")
bmhaura:RegisterEvent("PLAYER_TALENT_UPDATE") 
bmhaura:RegisterEvent("CHARACTER_POINTS_CHANGED") 
---------------------------------------------
-- MOVE
---------------------------------------------
local function unlockFrames()
	print("BMHelper: Frames unlocked")
	for _, v in pairs(BM_Frames) do
		f = _G[v]
		if f then
			if f:IsShown() then
				f.state = "shown"
			 else
				f.state = "hidden"
				f:Show()
			end
			f.dragtexture:SetAlpha(0.2)
			f:EnableMouse(true)
			f:RegisterForDrag("LeftButton")
			f:SetScript("OnEnter", function(s)
				GameTooltip:SetOwner(s, "ANCHOR_TOP")
				GameTooltip:AddLine(s:GetName(), 0, 1, 0.5, 1, 1, 1)
				GameTooltip:Show()
			end)
			f:SetScript("OnLeave", function(s) GameTooltip:Hide() end)
		end
	end
end

local function lockFrames()
	print("BMHelper: frames locked")
	for _, v in pairs(BM_Frames) do
		f = _G[v]
		if f then
			f.dragtexture:SetAlpha(0)
			f:EnableMouse(nil)
			f:RegisterForDrag(nil)
			f:SetScript("OnEnter", nil)
			f:SetScript("OnLeave", nil)
			if f.state == "hidden" then
				f:Hide()
			end
		end
	end
end

local function resetFrames()
	print("BMHelper: frames reseted")
	for _, v in pairs(BM_Frames) do
		f = _G[v]
	      if f then
			f.dragtexture:SetAlpha(0)
			f:EnableMouse(nil)
			f:RegisterForDrag(nil)
			f:SetScript("OnEnter", nil)
			f:SetScript("OnLeave", nil)
			if f.state == "hidden" then
				f:Hide()
			end
			f:ClearAllPoints()
		end
	end
	bmh:SetPoint(position.a1, position.parent, position.a2, position.x, position.y)
	bmhaura:SetPoint(positionaura.a1, positionaura.parent, positionaura.a2, positionaura.x, positionaura.y)
	bmhauraright:SetPoint(positionauraright.a1, positionauraright.parent, positionauraright.a2, positionauraright.x, positionauraright.y)
end
  
local function SlashCmd(cmd)
	if (cmd:match"unlock") then
		unlockFrames()
	elseif (cmd:match"lock") then
		lockFrames()
	elseif (cmd:match"reset") then
		resetFrames()
	else
		print("|c0000FF00BMHelper command list:|r")
		print("|c0000FF00\/bmh lock|r, to lock all bars")
		print("|c0000FF00\/bmh unlock|r, to unlock all bars")
		print("|c0000FF00\/bmh reset|r, to reset position")
	end
end

SlashCmdList["bmhelper"] = SlashCmd;
SLASH_bmhelper1 = "/bmh";
  
---------------------------------------------
-- talent
---------------------------------------------  

local bmhe = CreateFrame("Frame", nil, UIParent)
function bmhe:Talents()
	PlayerLevel = UnitLevel("PLAYER")
	if (PlayerLevel >=10 ) then
		local primaryTalentTree = GetSpecialization()
		if (primaryTalentTree == 1 and enableTank) then
			BMHelperAuraFrame:Show();
			BMHelperAuraRightFrame:Show();
		else
			BMHelperAuraFrame:Hide();
			BMHelperAuraRightFrame:Hide();
		end		
	end

	BMHelperCHIFrame:Show();	
end

function bmhe:PLAYER_TALENT_UPDATE(event,...) bmhe:Talents() end
function bmhe:CHARACTER_POINTS_CHANGED(event,...) bmhe:Talents() end
function bmhe:PLAYER_ENTERING_WORLD(event,...) bmhe:Talents() end
function bmhe:PLAYER_LOGIN(event,...) bmhe:Talents() end

bmhe:SetScript("OnEvent", function(self,event, ...) 
	if self[event] then 
		return self[event](self, event, ...) 
	end
end)

function dwBMHelper_Toggle(switch)
	if (switch) then
		bmhe:RegisterEvent("PLAYER_LOGIN")
		bmhe:RegisterEvent("PLAYER_ENTERING_WORLD")
		bmhe:RegisterEvent("PLAYER_TALENT_UPDATE")
		bmhe:RegisterEvent("CHARACTER_POINTS_CHANGED")
		bmhe:Talents()
	else
		bmhe:UnregisterAllEvents();
		for _, v in pairs(BM_Frames) do
			_G[v]:Hide()			
		end
	end
end

function dwBMHelperTank_Toggle(switch)
	if (switch) then
		enableTank = true;
	else
		enableTank = false;
	end
	bmhe:Talents()
end