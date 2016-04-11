local t,e=...local p=e.L local l,r,i,k=floor,ceil,format,tostring local n,s,m,y,h,a,u,c,q,g=pairs,ipairs,next,wipe,assert,type,tinsert,select,tremove,GetTime local o,d,f,j,w={},{},{},{"%.1f","%.2f","%.3f","%.4f","%.5f",[0]="%d"},{"0","00","000","0000","00000"}for e=0,100 do o[e]=k(e)end for e=0,9 do for t=0,9 do f[e+t/10]=i("%.1f",e+t/10)end end function noop()end _empty_table={};_temp_table={};function copy(t,e)e=e or{}if not t then return end for t,a in n(t)do e[t]=a;end return e;end function tremovedata(e,a)for t=#e,1,-1 do if e[t]==a then q(e,t)end end end function tinsertdata(e,t)for a=1,#e do if(e[a]==t)then return end end u(e,t);return true;end function escape(e)return e:gsub("%%","%%%%"):gsub("%-","%%-"):gsub("%+","%%+"):gsub("%.","%%."):gsub("%[","%%["):gsub("%]","%%]"):gsub("%(","%%("):gsub("%)","%%)");end function nocase(e)return string.gsub(e,"%a",function(e)return string.format("[%s%s]",string.lower(e),string.upper(e))end)end function uncolor(e)return e and e:gsub("|c%x%x%x%x%x%x%x%x(.-)|r","%1")or nil end local v=xpcall local function t(e)return geterrorhandler()(e)end local function b(a)local o={}for t=1,a do o[t]="arg"..t end e=e:gsub("ARGS",table.concat(o,", "))return h(loadstring(e,"safecall Dispatcher["..a.."]"))(v,t)end local b=setmetatable({},{__index=function(a,e)local t=b(e)rawset(a,e,t)return t end})b[0]=function(e)return v(e,t)end function safecall(e,...)return b[c("#",...)](e,...)end function n2s_pad(t,e)e=e-#t if e>0 then return w[e]..t else return t end end local v={}for e=0,100 do v[e]=i("%02d",e)end function n2s(e,t,n)if e>=0 then if e<=100 then if t then if t==2 then return v[e]end local e=o[e]or o[(n and r or l)(e)]t=t-#e if t>0 then return w[t]..e else return e end else return o[e]or o[(n and r or l)(e)]end elseif e<=1e4 then local a=d[e]if not a then e=(n and r or l)(e)a=d[e]if not a then a=i("%d",e)d[(n and r or l)(e)]=a end end if t then t=t-#a if t>0 then return w[t]..a else return a end else return a end else return i("%d",e)end else return i("%d",e)end end function f2s(e,t)t=t or 0 if e>=0 and e<=100 and t<=1 then if t==0 then return o[l(e+.5)]else local t=f[l(e*10+.5)/10]if not t then t=i("%.1f",e)f[e]=t end return t end else return i(j[t]or j[0],e)end end local d,o,b,t,v,j=n2s,safecall,copy,tinsertdata,tremovedata,f2s LibStub("AceTimer-3.0"):Embed(e)function CoreScheduleTimer(i,a,o,t)if(i)then return e:ScheduleRepeatingTimer(o,a,t)else return e:ScheduleTimer(o,a,t)end end function CoreCancelTimer(t,a)return e:CancelTimer(t,a);end local r={}function CoreScheduleBucket(t,a,i,o)if r[t]then CoreCancelTimer(r[t])end r[t]=CoreScheduleTimer(false,a,function(...)r[t]=nil i(...)end,o)end e.frame=CreateFrame("Frame")local t=0 local r={}local w=0 local f=setmetatable({},{__newindex=function(e,a,t)rawset(e,a,t)w=w+1 end})e.frame:SetScript("OnUpdate",function(e)if w>0 then for e,t in m,f do o(t,e);f[e]=nil end w=0;end if t>0 then local a=t for e=1,a do local e=r[e];if e[1]then o(e[1],c(2,unpack(e)));end y(e);end t=t-a;for e=1,t do b(r[e+t],r[e]);y(r[e+t]);end end end)function RunOnNextFrame(a,...)t=t+1;local e=r[t];if(not e)then e={};r[t]=e;end e[1]=a;for t=1,c("#",...)do e[t+1]=c(t,...);end end function RunOnNextFrameKey(t,e)f[t]=e;end function RunOnNextFrameKeyCancel(e)f[e]=nil;end local r;function CoreDispatchEvent(i,e)i.addon=e or i;r=r or function(o,t,...)local e=o.addon[t];if(a(e)=="function")then e(o.addon,t,...);else e=o.addon.DEFAULT_EVENT;if(a(e)~="function")then print(p["没有事件["]..t..p["]的处理函数."]);return end e(o.addon,t,...);end end i:SetScript("OnEvent",r);end local t={}function CoreAddEvent(e)t[e]={};end function CoreRegisterEvent(e,a)local t=t[a];h(t,"No event '"..a.."' is defined.");u(t,WW and WW:un(e)or e._F or e);end function CoreUnregisterEvent(e,a)local t=t[a];h(t,"No event '"..a.."' is defined.");v(t,WW and WW:un(e)or e._F or e);end function CoreUnregisterAllEvents(a)for e,t in n(t)do CoreUnregisterEvent(a,e);end end function CoreFireEvent(a,...)local e=t[a];if(e)then for t=1,#e do local e=e[t]o(e[a],e,...);end end end function CoreDependCall(t,e,...)local e=a(e)=="function"and e or _G[e];local e=a(e)=="function"and e or _G[e];if(IsAddOnLoaded(t)and a(e)=="function")then e(...)else local o={...}CoreOnEvent("ADDON_LOADED",function(i,a)if(a==t)then e(unpack(o));return true;end end)end end local t={}function CoreLeaveCombatCall(i,n,e)local e=a(e)=="function"and e or _G[e];h(a(e)=="function","param #2 should be function or function name.")if not InCombatLockdown()then o(e,i)else if n then U1Message(n)end t[i]=e;end end local f={}local r,w={},false e.frame:RegisterEvent("PLAYER_REGEN_ENABLED")e.frame:SetScript("OnEvent",function(a,e,...)if e=="PLAYER_REGEN_ENABLED"then for t,e in m,t do o(e,t)end y(t);end local a=f[e];if a then local t=1;while t<=#a do local e,o=o(a[t],e,...);if e and o then q(a,t);else t=t+1;end end end local t=r[e]if t then for a=1,#t do local t=t[a]local a=t[3]if a==nil then o(t[1],e)t[3]=t[2]else t[4]=1 end end end end)CoreScheduleTimer(true,.2,function()if not w then return end for a,e in n(r)do for t=1,#e do local t=e[t]local e=t[3];if e then e=e-.1 if e<=0 then if t[4]then o(t[1],a);t[4]=nil;e=t[2];else e=nil end end t[3]=e end end end end)function CoreOnEvent(t,i,o)if o then if a(o)=="table"then o:RegisterEvent(t);o[t]=i;else local e=CreateFrame("Frame");CoreDispatchEvent(e)e:RegisterEvent(t);e[t]=i;return e;end end if(not e.frame:IsEventRegistered(t))then e.frame:RegisterEvent(t);end local e=f[t];if(e==nil)then e={}f[t]=e end u(e,i);end function CoreOnEventBucket(t,a,o)if(not e.frame:IsEventRegistered(t))then e.frame:RegisterEvent(t);end local e=r[t];if(e==nil)then e={}r[t]=e end u(e,{o,a,0})w=m(r)and true end function dump(...)if not IsAddOnLoaded("Blizzard_DebugTools")then LoadAddOn("Blizzard_DebugTools")end DevTools_Dump(...);end function EncodeURL(a)local e=1;local t={}while e<=#a do local a=string.byte(a,e);t[e]=a e=e+1 end local e="";for a,t in s(t)do e=e..string.format("%%%X",t)end return e;end function CoreRawHook(t,e,o,i)if a(t)=="string"then e,o,i,t=t,e,o,_G end if DEBUG_MODE and not i and e:find("^On")then debug(p["忘记设置isscript了？"],e)end if i then local a=t:GetScript(e)if not a then t:SetScript(e,o)else t:SetScript(e,function(...)a(...)return o(...)end)end else local a=t[e]if not a then t[e]=o else t[e]=function(...)local r,s,h,e,i,t,n,a,d=a(...)o(...)return r,s,h,e,i,t,n,a,d end end end end CoreGlobalHooks={}function hook(e,t,o)h(a(_G[t])=="function","Bad arg1, string function name expected")h(a(o)=="function","Bad arg2, function expected")e=e or CoreGlobalHooks;e._origins=e._origins or{}e._hooks=e._hooks or{}e._copies=e._copies or{}if not e._origins[t]then e._origins[t]=_G[t]_G[t]=function(...)return e._hooks[t](...)end end e._hooks[t]=o end function unhook(e,t)e=e or CoreGlobalHooks;if not e._origins or not e._origins[t]then return end if e._copies and e._copies[t]then return end e._copies[t]=e._hooks[t];e._hooks[t]=e._origins[t];end function rehook(e,t,a)e=e or CoreGlobalHooks;if not e._origins or not e._origins[t]then if(a)then hook(e,t,a)end return end if not e._copies or not e._copies[t]then return end e._hooks[t]=e._copies[t]e._copies[t]=nil;end function togglehook(e,t,o,a)if a then rehook(e,t,o)else unhook(e,t)end end function toggleposthook(s,o,e,t,n,i)h(a(o)=="table","para #1 store must be a table.")if e==nil then e="NIL"end o[e]=o[e]or{}if not o[e][t]then o[e][t]={n,i}local a=function(...)if(o[e][t][2])then o[e][t][1](...)end end if s=="hooksecurefunc"then if e=="NIL"then hooksecurefunc(t,a)else hooksecurefunc(e,t,a)end else e:HookScript(t,a)end else o[e][t][1]=n o[e][t][2]=i end end function togglesecurehook(a,t,i,o,e)return toggleposthook("hooksecurefunc",a,t,i,o,e)end function togglescripthook(a,t,i,o,e)return toggleposthook("HookScript",a,t,i,o,e)end function CoreCall(e,...)local e=_G[e]return e and e(...);end

local floor,n2s,f2s=floor,n2s,f2s
--[[--------------------------------------------------------------------
	GridStatusHots.lua
----------------------------------------------------------------------]]

local _, GridStatusHots = ...

if not GridStatusHots.L then GridStatusHots.L = { } end

local L = setmetatable(GridStatusHots.L, {
	__index = function(t, k)
		t[k] = k
		return k
	end
})

--}}}

local GridRoster = Grid:GetModule("GridRoster")
local GridStatusHots = Grid:GetModule("GridStatus"):NewModule("GridStatusHots", "AceTimer-3.0")
local refreshTimer

GridStatusHots.menuName = L["My HoTs"];

local playerClass, englishClass = UnitClass("player")
local playerRace, englishRace = UnitRace("player")

local spellNameCache = {};
local spellIconCache = {};
--Druid
spellNameCache.Lifebloom1 = GetSpellInfo(33763);
spellNameCache.Lifebloom2 = GetSpellInfo(94447);
spellNameCache.Regrowth = GetSpellInfo(8936);
spellNameCache.Rejuvenation = GetSpellInfo(774);
spellNameCache.WildGrowth = GetSpellInfo(48438);

--Monk 新增
spellNameCache.RenewingMist = GetSpellInfo(119611);
spellNameCache.ZenSphere = GetSpellInfo(124081);
spellNameCache.EnvelopingMist = GetSpellInfo(132120);

--Paladin
spellNameCache.BeaconofLight = GetSpellInfo(53563);
spellNameCache.EternalFlame = GetSpellInfo(114163);					--永恒之火
spellNameCache.SacredShield = GetSpellInfo(20925);					--圣洁护盾

--Priest
spellNameCache.Grace = GetSpellInfo(77613) -- 47930
spellNameCache.PrayerofMending = GetSpellInfo(33076);
spellNameCache.Renew = GetSpellInfo(139);
spellNameCache.PowerWordShield = GetSpellInfo(17);
spellNameCache.WeakenedSoul = GetSpellInfo(6788);
spellNameCache.DivineAegis = GetSpellInfo(47753);
spellNameCache.Inspiration = GetSpellInfo(15357);

--Shaman
spellNameCache.Earthliving = GetSpellInfo(51945);
spellNameCache.EarthShield = GetSpellInfo(974);
spellNameCache.Riptide = GetSpellInfo(61295);
spellNameCache.AncestralFortitude = GetSpellInfo(16236);
local fort_name, fort_rank, fort_icon = GetSpellInfo(16236);
spellIconCache.AncestralFortitude = fort_icon
spellNameCache.AncestralVigor = GetSpellInfo(105284);
local vigor_name, vigor_rank, vigor_icon = GetSpellInfo(105284);
spellIconCache.AncestralVigor = vigor_icon

--Draenei
spellNameCache.GiftoftheNaaru = GetSpellInfo(28880);


GridStatusHots.extraOptions = {
}


--{{{ AceDB defaults
--
local _, PlayerClass = UnitClass("player")
local IsPriest = PlayerClass == "PRIEST"
local IsDruid = PlayerClass == "DRUID"
local IsShaman = PlayerClass == "SHAMAN"
local IsPaladin = PlayerClass == "PALADIN"
local IsMonk = PlayerClass == "MONK"
GridStatusHots.defaultDB = {
	alert_tothots = {
		text = L["Hots: Hot Count"],
		enable = false,
		lbeach = false,
		priority = 95,
		range = false,
		color = { r = 0, g = 1, b = 0, a = 1 },
	},

	--Druid
	alert_lifebl = {
		text = L["Hots: My Lifebloom"],
		enable = false,
		totshow = false,
		decshow = false,
		priority = 99,
		range = false,
		threshold2 = 4,
		threshold3 = 2,
		color = { r = 0, g = 1, b = 0, a = 1 },
		color2 = { r = 1, g = 1, b = 0, a = 1 },
		color3 = { r = 1, g = 0, b = 0, a = 1 },
	},
	alert_lifebl_stack = {
		text = L["Hots: My Lifebloom Stack Colored"],
		enable = IsDruid,
		totshow = false,
		decshow = false,
		priority = 99,
		range = false,
		threshold2 = 4,
		threshold3 = 2,
		color = { r = 1, g = 0, b = 0, a = 1 },
		color2 = { r = 1, g = 1, b = 0, a = 1 },
		color3 = { r = 0, g = 1, b = 0, a = 1 },
	},
	alert_regrow = {
		text = L["Hots: My Regrowth"],
		enable = IsDruid,
		totshow = false,
		priority = 97,
		range = false,
		threshold2 = 4,
		threshold3 = 2,
		color = { r = 0, g = 1, b = 0, a = 1 },
		color2 = { r = 1, g = 1, b = 0, a = 1 },
		color3 = { r = 1, g = 0, b = 0, a = 1 },
	},
	alert_rejuv = {
		text = L["Hots: My Rejuvenation"],
		enable = IsDruid,
		totshow = false,
		priority = 98,
		range = false,
		threshold2 = 4,
		threshold3 = 2,
		color = { r = 0, g = 1, b = 0, a = 1 },
		color2 = { r = 1, g = 1, b = 0, a = 1 },
		color3 = { r = 1, g = 0, b = 0, a = 1 },
	},
	alert_wgrowth = {
		text = L["Hots: My Wild Growth"],
		enable = IsDruid,
		totshow = false,
		priority = 96,
		range = false,
		threshold2 = 4,
		threshold3 = 2,
		color = { r = 0, g = 1, b = 0, a = 1 },
		color2 = { r = 1, g = 1, b = 0, a = 1 },
		color3 = { r = 1, g = 0, b = 0, a = 1 },
	},

	--Monk
	alert_rmist = {
		text = L["Hots: My Renewing Mist"],
		enable = IsMonk,
		totshow = false,
		priority = 98,
		range = false,
		threshold2 = 4,
		threshold3 = 2,
		color = { r = 0, g = 1, b = 0, a = 1 },
		color2 = { r = 1, g = 1, b = 0, a = 1 },
		color3 = { r = 1, g = 0, b = 0, a = 1 },
	},
	alert_zsphere = {
		text = L["Hots: My Zen Sphere"],
		enable = IsMonk,
		totshow = false,
		priority = 98,
		range = false,
		threshold2 = 4,
		threshold3 = 2,
		color = { r = 0, g = 1, b = 0, a = 1 },
		color2 = { r = 1, g = 1, b = 0, a = 1 },
		color3 = { r = 1, g = 0, b = 0, a = 1 },
	},	
	alert_emist = {
		text = L["Hots: My Enveloping Mist"],
		enable = IsMonk,
		totshow = false,
		priority = 98,
		range = false,
		threshold2 = 2,
		threshold3 = 1,
		color = { r = 0, g = 1, b = 0, a = 1 },
		color2 = { r = 1, g = 1, b = 0, a = 1 },
		color3 = { r = 1, g = 0, b = 0, a = 1 },
	},

	--Paladin
	alert_beacon = {
		text = L["Hots: My Beacon of Light"],
		enable = IsPaladin,
		priority = 96,
		range = false,
		threshold2 = 10,
		threshold3 = 5,
		color = { r = 0, g = 1, b = 0, a = 1 },
		color2 = { r = 1, g = 1, b = 0, a = 1 },
		color3 = { r = 1, g = 0, b = 0, a = 1 },
	},
	alert_eternal = {
		text = L["Hots: My Eternal Flame"],
		enable = IsPaladin,
		priority = 98,
		range = false,
		threshold2 = 6,
		threshold3 = 3,
		color = { r = 0, g = 1, b = 0, a = 1 },
		color2 = { r = 1, g = 1, b = 0, a = 1 },
		color3 = { r = 1, g = 0, b = 0, a = 1 },
	},
	alert_sacred = {
		text = L["Hots: My Sacred Shield"],
		enable = IsPaladin,
		priority = 95,
		range = false,
		threshold2 = 0,
		threshold3 = 0,
		color = { r = 0, g = 1, b = 0, a = 1 },
		color2 = { r = 1, g = 1, b = 0, a = 1 },
		color3 = { r = 1, g = 0, b = 0, a = 1 },
	},

	--Priest
	alert_gracestack = {
		text = L["Hots: My Grace Stack"],
		enable = IsPriest,
		priority = 90,
		range = false,
		color = { r = 1, g = 0, b = 0, a = 1 },
		color2 = { r = 1, g = 1, b = 0, a = 1 },
		color3 = { r = 0, g = 1, b = 0, a = 1 },
	},
	alert_gracedurstack = {
		text = L["Hots: My Grace Duration + Stack"],
		enable = IsPriest,
		priority = 90,
		range = false,
		threshold2 = 5.5,
		threshold3 = 3,
		color = { r = 0, g = 1, b = 0, a = 1 },
		color2 = { r = 1, g = 1, b = 0, a = 1 },
		color3 = { r = 1, g = 0, b = 0, a = 1 },
	},
	alert_pom = {
		text = L["Hots: My Prayer of Mending"],
		enable = IsPriest,
		priority = 70,
		range = false,
		mine = false,
		color = { r = 1, g = 0, b = 0, a = 1 },
		color2 = { r = 1, g = .5, b = 0, a = 1 },
		color3 = { r = 1, g = 1, b = 0, a = 1 },
		color4 = { r = 0, g = 1, b = 1, a = 1 },
		color5 = { r = .5, g = 1, b = 0, a = 1 },
		color6 = { r = 0, g = 1, b = 0, a = 1 },
	},
	alert_pomdur = {
		text = L["Hots: My Prayer of Mending - duration colored"],
		enable = IsPriest,
		priority = 70,
		range = false,
		mine = false,
		threshold2 = 6,
		threshold3 = 3,
		color = { r = 0, g = 1, b = 0, a = 1 },
		color2 = { r = 1, g = 1, b = 0, a = 1 },
		color3 = { r = 1, g = 0, b = 0, a = 1 },
	},
	alert_pws = {
		text = L["Hots: Power Word: Shield"],
		enable = IsPriest,
		wsshow = false,
		priority = 91,
		range = false,
		threshold2 = 10,
		threshold3 = 5,
		color = { r = 0, g = 1, b = 0, a = 1 },
		color2 = { r = 1, g = 1, b = 0, a = 1 },
		color3 = { r = 1, g = 0, b = 0, a = 1 },
	},
	alert_weakenedsoul = {
		text = L["Hots: Weakened Soul"],
		enable = false,
		priority = 92,
		range = false,
		threshold2 = 4,
		threshold3 = 2,
		color = { r = 1, g = 0, b = 0, a = 1 },
		color2 = { r = 1, g = .5, b = 0, a = 1 },
		color3 = { r = 1, g = 1, b = 0, a = 1 },
	},
	alert_renew = {
		text = L["Hots: My Renew"],
		enable = IsPriest,
		totshow = false,
		priority = 99,
		range = false,
		threshold2 = 4,
		threshold3 = 2,
		color = { r = 0, g = 1, b = 0, a = 1 },
		color2 = { r = 1, g = 1, b = 0, a = 1 },
		color3 = { r = 1, g = 0, b = 0, a = 1 },
	},
	alert_aegis = {
		text = L["Hots: Divine Aegis"],
		enable = false,
		totshow = false,
		priority = 99,
		range = false,
		threshold2 = 8,
		threshold3 = 4,
		color = { r = 0, g = 1, b = 0, a = 1 },
		color2 = { r = 1, g = 1, b = 0, a = 1 },
		color3 = { r = 1, g = 0, b = 0, a = 1 },
	},
	alert_inspiration = {
		text = L["Hots: Inspiration"],
		enable = false,
		totshow = false,
		priority = 99,
		range = false,
		threshold2 = 8,
		threshold3 = 4,
		color = { r = 0, g = 1, b = 0, a = 1 },
		color2 = { r = 1, g = 1, b = 0, a = 1 },
		color3 = { r = 1, g = 0, b = 0, a = 1 },
	},

	--Shaman
	alert_earthliving = {
		text = L["Hots: My Earthliving"],
		enable = false,
		totshow = false,
		priority = 98,
		range = false,
		threshold2 = 4,
		threshold3 = 2,
		color = { r = 0, g = 1, b = 0, a = 1 },
		color2 = { r = 1, g = 1, b = 0, a = 1 },
		color3 = { r = 1, g = 0, b = 0, a = 1 },
	},
	alert_earthshield = {
		text = L["Hots: My Earth Shield"],
		enable = IsShaman,
		priority = 91,
		range = false,
		threshold2 = 2,
		threshold3 = 1,
		color = { r = 1, g = 0, b = 0, a = 1 },
		color2 = { r = 1, g = .5, b = 0, a = 1 },
		color3 = { r = 1, g = 1, b = 0, a = 1 },
		color4 = { r = 0, g = 1, b = 1, a = 1 },
		color5 = { r = 0, g = 1, b = 0, a = 1 },
	},
	alert_riptide = {
		text = L["Hots: My Riptide"],
		enable = IsShaman,
		totshow = false,
		priority = 99,
		range = false,
		threshold2 = 4,
		threshold3 = 2,
		color = { r = 0, g = 1, b = 0, a = 1 },
		color2 = { r = 1, g = 1, b = 0, a = 1 },
		color3 = { r = 1, g = 0, b = 0, a = 1 },
	},
	alert_fortitude = {
		text = L["Hots: Ancestral Fortitude"],
		enable = false,
		totshow = false,
		priority = 99,
		range = false,
		threshold2 = 8,
		threshold3 = 4,
		color = { r = 0, g = 1, b = 0, a = 1 },
		color2 = { r = 1, g = 1, b = 0, a = 1 },
		color3 = { r = 1, g = 0, b = 0, a = 1 },
	},
	alert_vigor = {
		text = L["Hots: Ancestral Vigor"],
		enable = false,
		totshow = false,
		priority = 99,
		range = false,
		threshold2 = 8,
		threshold3 = 4,
		color = { r = 0, g = 1, b = 0, a = 1 },
		color2 = { r = 1, g = 1, b = 0, a = 1 },
		color3 = { r = 1, g = 0, b = 0, a = 1 },
	},

	--Draenei
	alert_gift = {
		text = L["Hots: My Gift of the Naaru"],
		enable = false,
		totshow = false,
		priority = 91,
		range = false,
		threshold2 = 4,
		threshold3 = 2,
		color = { r = 0, g = 1, b = 0, a = 1 },
		color2 = { r = 1, g = 1, b = 0, a = 1 },
		color3 = { r = 1, g = 0, b = 0, a = 1 },
	},
}

local tothots_options = {
	["lbeach"] = {
		type = "toggle",
		name = L["Count Lifebloom as 1 HoT per stack"],
		desc = L["Check, if you want each stack of Lifebloom to count as 1 HoT"],
		get = function () return GridStatusHots.db.profile.alert_tothots.lbeach end,
		set = function (_, arg)
			GridStatusHots.db.profile.alert_tothots.lbeach = arg
		end,
	},
}

local renew_hotcolors = {
	["threshold2"] = {
		type = "range",
		name = L["Threshold to activate color 2"],
		max = 10,
		min = 1,
		step = .5,
		get = function ()
			return GridStatusHots.db.profile.alert_renew.threshold2
		end,
		set = function (_, v)
			GridStatusHots.db.profile.alert_renew.threshold2 = v
		end,
	},
	["color2"] = {
		type = "color",
		name = L["Color 2"],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_renew.color2
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_renew.color2
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["threshold3"] = {
		type = "range",
		name = L["Threshold to activate color 3"],
		max = 10,
		min = 1,
		step = .5,
		get = function ()
			return GridStatusHots.db.profile.alert_renew.threshold3
		end,
		set = function (_, v)
			GridStatusHots.db.profile.alert_renew.threshold3 = v
		end,
	},
	["color3"] = {
		type = "color",
		name = L["Color 3"],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_renew.color3
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_renew.color3
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["totshow"] = {
		type = "toggle",
		name = L["Show HoT-Counter"],
		desc = L["Check, if you want to see the total of HoTs behind the countdown of your HoT(i.e. 13-5)"],
		get = function () return GridStatusHots.db.profile.alert_renew.totshow end,
		set = function (_, arg)
			GridStatusHots.db.profile.alert_renew.totshow = arg
		end,
	},
}

local rejuv_hotcolors = {
	["threshold2"] = {
		type = "range",
		name = L["Threshold to activate color 2"],
		max = 10,
		min = 1,
		step = .5,
		get = function ()
			return GridStatusHots.db.profile.alert_rejuv.threshold2
		end,
		set = function (_, v)
			GridStatusHots.db.profile.alert_rejuv.threshold2 = v
		end,
	},
	["color2"] = {
		type = "color",
		name = L["Color 2"],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_rejuv.color2
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_rejuv.color2
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["threshold3"] = {
		type = "range",
		name = L["Threshold to activate color 3"],
		max = 10,
		min = 1,
		step = .5,
		get = function ()
			return GridStatusHots.db.profile.alert_rejuv.threshold3
		end,
		set = function (_, v)
			GridStatusHots.db.profile.alert_rejuv.threshold3 = v
		end,
	},
	["color3"] = {
		type = "color",
		name = L["Color 3"],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_rejuv.color3
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_rejuv.color3
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["totshow"] = {
		type = "toggle",
		name = L["Show HoT-Counter"],
		desc = L["Check, if you want to see the total of HoTs behind the countdown of your HoT(i.e. 13-5)"],
		get = function () return GridStatusHots.db.profile.alert_rejuv.totshow end,
		set = function (_, arg)
			GridStatusHots.db.profile.alert_rejuv.totshow = arg
		end,
	},
}
--renewing mist
local rmist_hotcolors = {
	["threshold2"] = {
		type = "range",
		name = L["Threshold to activate color 2"],
		max = 10,
		min = 1,
		step = .5,
		get = function ()
			return GridStatusHots.db.profile.alert_rmist.threshold2
		end,
		set = function (_, v)
			GridStatusHots.db.profile.alert_rmist.threshold2 = v
		end,
	},
	["color2"] = {
		type = "color",
		name = L["Color 2"],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_rmist.color2
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_rmist.color2
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["threshold3"] = {
		type = "range",
		name = L["Threshold to activate color 3"],
		max = 10,
		min = 1,
		step = .5,
		get = function ()
			return GridStatusHots.db.profile.alert_rmist.threshold3
		end,
		set = function (_, v)
			GridStatusHots.db.profile.alert_rmist.threshold3 = v
		end,
	},
	["color3"] = {
		type = "color",
		name = L["Color 3"],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_rmist.color3
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_rmist.color3
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["totshow"] = {
		type = "toggle",
		name = L["Show HoT-Counter"],
		desc = L["Check, if you want to see the total of HoTs behind the countdown of your HoT(i.e. 13-5)"],
		get = function () return GridStatusHots.db.profile.alert_rejuv.totshow end,
		set = function (_, arg)
			GridStatusHots.db.profile.alert_rmist.totshow = arg
		end,
	},
}
--zen sphere
local zsphere_hotcolors = {
	["threshold2"] = {
		type = "range",
		name = L["Threshold to activate color 2"],
		max = 10,
		min = 1,
		step = .5,
		get = function ()
			return GridStatusHots.db.profile.alert_zsphere.threshold2
		end,
		set = function (_, v)
			GridStatusHots.db.profile.alert_zsphere.threshold2 = v
		end,
	},
	["color2"] = {
		type = "color",
		name = L["Color 2"],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_zsphere.color2
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_zsphere.color2
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["threshold3"] = {
		type = "range",
		name = L["Threshold to activate color 3"],
		max = 10,
		min = 1,
		step = .5,
		get = function ()
			return GridStatusHots.db.profile.alert_zsphere.threshold3
		end,
		set = function (_, v)
			GridStatusHots.db.profile.alert_zsphere.threshold3 = v
		end,
	},
	["color3"] = {
		type = "color",
		name = L["Color 3"],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_zsphere.color3
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_zsphere.color3
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["totshow"] = {
		type = "toggle",
		name = L["Show HoT-Counter"],
		desc = L["Check, if you want to see the total of HoTs behind the countdown of your HoT(i.e. 13-5)"],
		get = function () return GridStatusHots.db.profile.alert_zsphere.totshow end,
		set = function (_, arg)
			GridStatusHots.db.profile.alert_rejuv.totshow = arg
		end,
	},
}
--enveloping mist
local emist_hotcolors = {
	["threshold2"] = {
		type = "range",
		name = L["Threshold to activate color 2"],
		max = 10,
		min = 1,
		step = .5,
		get = function ()
			return GridStatusHots.db.profile.alert_emist.threshold2
		end,
		set = function (_, v)
			GridStatusHots.db.profile.alert_emist.threshold2 = v
		end,
	},
	["color2"] = {
		type = "color",
		name = L["Color 2"],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_emist.color2
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_emist.color2
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["threshold3"] = {
		type = "range",
		name = L["Threshold to activate color 3"],
		max = 10,
		min = 1,
		step = .5,
		get = function ()
			return GridStatusHots.db.profile.alert_emist.threshold3
		end,
		set = function (_, v)
			GridStatusHots.db.profile.alert_emist.threshold3 = v
		end,
	},
	["color3"] = {
		type = "color",
		name = L["Color 3"],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_emist.color3
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_emist.color3
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["totshow"] = {
		type = "toggle",
		name = L["Show HoT-Counter"],
		desc = L["Check, if you want to see the total of HoTs behind the countdown of your HoT(i.e. 13-5)"],
		get = function () return GridStatusHots.db.profile.alert_emist.totshow end,
		set = function (_, arg)
			GridStatusHots.db.profile.alert_rejuv.totshow = arg
		end,
	},
}

local regrow_hotcolors = {
	["threshold2"] = {
		type = "range",
		name = L["Threshold to activate color 2"],
		max = 10,
		min = 1,
		step = .5,
		get = function ()
			return GridStatusHots.db.profile.alert_regrow.threshold2
		end,
		set = function (_, v)
			GridStatusHots.db.profile.alert_regrow.threshold2 = v
		end,
	},
	["color2"] = {
		type = "color",
		name = L["Color 2"],
		desc = L["Color 2"],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_regrow.color2
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_regrow.color2
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["threshold3"] = {
		type = "range",
		name = L["Threshold to activate color 3"],
		max = 10,
		min = 1,
		step = .5,
		get = function ()
			return GridStatusHots.db.profile.alert_regrow.threshold3
		end,
		set = function (_, v)
			GridStatusHots.db.profile.alert_regrow.threshold3 = v
		end,
	},
	["color3"] = {
		type = "color",
		name = L["Color 3"],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_regrow.color3
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_regrow.color3
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["totshow"] = {
		type = "toggle",
		name = L["Show HoT-Counter"],
		desc = L["Check, if you want to see the total of HoTs behind the countdown of your HoT(i.e. 13-5)"],
		get = function () return GridStatusHots.db.profile.alert_regrow.totshow end,
		set = function (_, arg)
			GridStatusHots.db.profile.alert_regrow.totshow = arg
		end,
	},
}

local lifebl_hotcolors = {
	["threshold2"] = {
		type = "range",
		name = L["Threshold to activate color 2"],
		max = 10,
		min = 1,
		step = .5,
		get = function ()
			return GridStatusHots.db.profile.alert_lifebl.threshold2
		end,
		set = function (_, v)
			GridStatusHots.db.profile.alert_lifebl.threshold2 = v
		end,
	},
	["color2"] = {
		type = "color",
		name = L["Color 2"],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_lifebl.color2
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_lifebl.color2
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["threshold3"] = {
		type = "range",
		name = L["Threshold to activate color 3"],
		max = 10,
		min = 1,
		step = .5,
		get = function ()
			return GridStatusHots.db.profile.alert_lifebl.threshold3
		end,
		set = function (_, v)
			GridStatusHots.db.profile.alert_lifebl.threshold3 = v
		end,
	},
	["color3"] = {
		type = "color",
		name = L["Color 3"],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_lifebl.color3
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_lifebl.color3
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["totshow"] = {
		type = "toggle",
		name = L["Show HoT-Counter"],
		desc = L["Check, if you want to see the total of HoTs behind the countdown of your HoT(i.e. 13-5)"],
		get = function () return GridStatusHots.db.profile.alert_lifebl.totshow end,
		set = function (_, arg)
			GridStatusHots.db.profile.alert_lifebl.totshow = arg
		end,
	},
	["decshow"] = {
		type = "toggle",
		name = L["Show decimals"],
		desc = L["Check, if you want to see one decimal place for your Lifebloom(i.e. 7.1)"],
		get = function () return GridStatusHots.db.profile.alert_lifebl.decshow end,
		set = function (_, arg)
			GridStatusHots.db.profile.alert_lifebl.decshow = arg
		end,
	},
}

local lifebl_stack_hotcolors = {
	["color2"] = {
		type = "color",
		name = L["Color 2"],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_lifebl_stack.color2
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_lifebl_stack.color2
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["color3"] = {
		type = "color",
		name = L["Color 3"],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_lifebl_stack.color3
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_lifebl_stack.color3
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["totshow"] = {
		type = "toggle",
		name = L["Show HoT-Counter"],
		desc = L["Check, if you want to see the total of HoTs behind the countdown of your HoT(i.e. 13-5)"],
		get = function () return GridStatusHots.db.profile.alert_lifebl_stack.totshow end,
		set = function (_, arg)
			GridStatusHots.db.profile.alert_lifebl_stack.totshow = arg
		end,
	},
	["decshow"] = {
		type = "toggle",
		name = L["Show decimals"],
		desc = L["Check, if you want to see one decimal place for your Lifebloom(i.e. 7.1)"],
		get = function () return GridStatusHots.db.profile.alert_lifebl_stack.decshow end,
		set = function (_, arg)
			GridStatusHots.db.profile.alert_lifebl_stack.decshow = arg
		end,
	},
}

local wgrowth_hotcolors = {
	["threshold2"] = {
		type = "range",
		name = L["Threshold to activate color 2"],
		max = 10,
		min = 1,
		step = .5,
		get = function ()
			return GridStatusHots.db.profile.alert_wgrowth.threshold2
		end,
		set = function (_, v)
			GridStatusHots.db.profile.alert_wgrowth.threshold2 = v
		end,
	},
	["color2"] = {
		type = "color",
		name = L["Color 2"],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_wgrowth.color2
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_wgrowth.color2
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["threshold3"] = {
		type = "range",
		name = L["Threshold to activate color 3"],
		max = 10,
		min = 1,
		step = .5,
		get = function ()
			return GridStatusHots.db.profile.alert_wgrowth.threshold3
		end,
		set = function (_, v)
			GridStatusHots.db.profile.alert_wgrowth.threshold3 = v
		end,
	},
	["color3"] = {
		type = "color",
		name = L["Color 3"],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_wgrowth.color3
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_wgrowth.color3
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["totshow"] = {
		type = "toggle",
		name = L["Show HoT-Counter"],
		desc = L["Check, if you want to see the total of HoTs behind the countdown of your HoT(i.e. 13-5)"],
		get = function () return GridStatusHots.db.profile.alert_wgrowth.totshow end,
		set = function (_, arg)
			GridStatusHots.db.profile.alert_wgrowth.totshow = arg
		end,
	},
}

local riptide_hotcolors = {
	["threshold2"] = {
		type = "range",
		name = L["Threshold to activate color 2"],
		max = 10,
		min = 1,
		step = .5,
		get = function ()
				return GridStatusHots.db.profile.alert_riptide.threshold2
			end,
		set = function (_, v)
			GridStatusHots.db.profile.alert_riptide.threshold2 = v
		end,
	},
	["color2"] = {
		type = "color",
		name = L["Color 2"],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_riptide.color2
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_riptide.color2
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["threshold3"] = {
		type = "range",
		name = L["Threshold to activate color 3"],
		max = 10,
		min = 1,
		step = .5,
		get = function ()
			return GridStatusHots.db.profile.alert_riptide.threshold3
		end,
		set = function (_, v)
			GridStatusHots.db.profile.alert_riptide.threshold3 = v
		end,
	},
	["color3"] = {
		type = "color",
		name = L["Color 3"],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_riptide.color3
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_riptide.color3
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["totshow"] = {
		type = "toggle",
		name = L["Show HoT-Counter"],
		desc = L["Check, if you want to see the total of HoTs behind the countdown of your HoT(i.e. 13-5)"],
		get = function () return GridStatusHots.db.profile.alert_riptide.totshow end,
		set = function (_, arg)
			GridStatusHots.db.profile.alert_riptide.totshow = arg
		end,
	},
}

local fortitude_hotcolors = {
	["threshold2"] = {
		type = "range",
		name = L["Threshold to activate color 2"],
		max = 10,
		min = 1,
		step = .5,
		get = function ()
			return GridStatusHots.db.profile.alert_fortitude.threshold2
		end,
		set = function (_, v)
			GridStatusHots.db.profile.alert_fortitude.threshold2 = v
		end,
	},
	["color2"] = {
		type = "color",
		name = L["Color 2"],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_fortitude.color2
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_fortitude.color2
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["threshold3"] = {
		type = "range",
		name = L["Threshold to activate color 3"],
		max = 10,
		min = 1,
		step = .5,
		get = function ()
			return GridStatusHots.db.profile.alert_fortitude.threshold3
		end,
		set = function (_, v)
			GridStatusHots.db.profile.alert_fortitude.threshold3 = v
		end,
	},
	["color3"] = {
		type = "color",
		name = L["Color 3"],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_fortitude.color3
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_fortitude.color3
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
}

local vigor_hotcolors = {
	["threshold2"] = {
		type = "range",
		name = L["Threshold to activate color 2"],
		max = 10,
		min = 1,
		step = .5,
		get = function ()
			return GridStatusHots.db.profile.alert_vigor.threshold2
		end,
		set = function (_, v)
			GridStatusHots.db.profile.alert_vigor.threshold2 = v
		end,
	},
	["color2"] = {
		type = "color",
		name = L["Color 2"],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_vigor.color2
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_vigor.color2
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["threshold3"] = {
		type = "range",
		name = L["Threshold to activate color 3"],
		max = 10,
		min = 1,
		step = .5,
		get = function ()
			return GridStatusHots.db.profile.alert_vigor.threshold3
		end,
		set = function (_, v)
			GridStatusHots.db.profile.alert_vigor.threshold3 = v
		end,
	},
	["color3"] = {
		type = "color",
		name = L["Color 3"],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_vigor.color3
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_vigor.color3
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
}

local pom_hotcolors = {
	["color2"] = {
		type = "color",
		name = L["Color 2"],
		desc = L["Color when player has two charges of PoM."],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_pom.color2
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_pom.color2
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["color3"] = {
		type = "color",
		name = L["Color 3"],
		desc = L["Color when player has three charges of PoM."],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_pom.color3
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_pom.color3
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["color4"] = {
		type = "color",
		name = L["Color 4"],
		desc = L["Color when player has four charges of PoM."],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_pom.color4
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_pom.color4
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["color5"] = {
		type = "color",
		name = L["Color 5"],
		desc = L["Color when player has five charges of PoM."],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_pom.color5
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_pom.color5
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["color6"] = {
		type = "color",
		name = L["Color 6"],
		desc = L["Color when player has six charges of PoM."],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_pom.color6
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_pom.color6
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["mine"] = {
		type = "toggle",
		name = L["Only mine"],
		desc = L["Only show my PoM"],
		order = 102,
		get = function () return GridStatusHots.db.profile.alert_pom.mine end,
		set = function (_, arg)
			GridStatusHots.db.profile.alert_pom.mine = arg
		end,
	},
}

local pomdur_hotcolors = {
	["threshold2"] = {
		type = "range",
		name = L["Threshold to activate color 2"],
		max = 20,
		min = 1,
		step = .5,
		get = function ()
			      return GridStatusHots.db.profile.alert_pomdur.threshold2
		      end,
		set = function (_, v)
			       GridStatusHots.db.profile.alert_pomdur.threshold2 = v
		end,
	},
	["color2"] = {
		type = "color",
		name = L["Color 2"],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_pomdur.color2
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_pomdur.color2
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["threshold3"] = {
		type = "range",
		name = L["Threshold to activate color 3"],
		max = 20,
		min = 1,
		step = .5,
		get = function ()
			      return GridStatusHots.db.profile.alert_pomdur.threshold3
		      end,
		set = function (_, v)
			       GridStatusHots.db.profile.alert_pomdur.threshold3 = v
		end,
	},
	["color3"] = {
		type = "color",
		name = L["Color 3"],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_pomdur.color3
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_pomdur.color3
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["mine"] = {
		type = "toggle",
		name = L["Only mine"],
		desc = L["Only show my PoM"],
		order = 102,
		get = function () return GridStatusHots.db.profile.alert_pom.mine end,
		set = function (_, arg)
			GridStatusHots.db.profile.alert_pom.mine = arg
		end,
	},
}

local pws_hotcolors = {
	["threshold2"] = {
		type = "range",
		name = L["Threshold to activate color 2"],
		max = 20,
		min = 1,
		step = .5,
		get = function ()
				return GridStatusHots.db.profile.alert_pws.threshold2
			end,
		set = function (_, v)
			GridStatusHots.db.profile.alert_pws.threshold2 = v
		end,
	},
	["threshold3"] = {
		type = "range",
		name = L["Threshold to activate color 3"],
		max = 20,
		min = 1,
		step = .5,
		get = function ()
				return GridStatusHots.db.profile.alert_pws.threshold3
			end,
		set = function (_, v)
			GridStatusHots.db.profile.alert_pws.threshold3 = v
		end,
	},
	["color2"] = {
		type = "color",
		name = L["Color 2"],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_pws.color2
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_pws.color2
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["color3"] = {
		type = "color",
		name = L["Color 3"],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_pws.color3
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_pws.color3
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["wsshow"] = {
		type = "toggle",
		name = L["Combine Timers"],
		desc = L["Check, if you want to see the Weakened Soul Timer behind the Pw: Shield Timer(i.e. 13-5)"],
		order = 102,
		get = function () return GridStatusHots.db.profile.alert_pws.wsshow end,
		set = function (_, arg)
			GridStatusHots.db.profile.alert_pws.wsshow = arg
		end,
	},
}

local weakenedsoul_hotcolors = {
	["threshold2"] = {
		type = "range",
		name = L["Threshold to activate color 2"],
		max = 10,
		min = 1,
		step = .5,
		get = function ()
			return GridStatusHots.db.profile.alert_weakenedsoul.threshold2
		end,
		set = function (_, v)
			GridStatusHots.db.profile.alert_weakenedsoul.threshold2 = v
		end,
	},
	["color2"] = {
		type = "color",
		name = L["Color 2"],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_weakenedsoul.color2
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_weakenedsoul.color2
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["threshold3"] = {
		type = "range",
		name = L["Threshold to activate color 3"],
		max = 10,
		min = 1,
		step = .5,
		get = function ()
			return GridStatusHots.db.profile.alert_weakenedsoul.threshold3
		end,
		set = function (_, v)
			GridStatusHots.db.profile.alert_weakenedsoul.threshold3 = v
		end,
	},
	["color3"] = {
		type = "color",
		name = L["Color 3"],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_weakenedsoul.color3
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_weakenedsoul.color3
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
}

local aegis_hotcolors = {
	["threshold2"] = {
		type = "range",
		name = L["Threshold to activate color 2"],
		max = 10,
		min = 1,
		step = .5,
		get = function ()
			return GridStatusHots.db.profile.alert_aegis.threshold2
		end,
		set = function (_, v)
			GridStatusHots.db.profile.alert_aegis.threshold2 = v
		end,
	},
	["color2"] = {
		type = "color",
		name = L["Color 2"],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_aegis.color2
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_aegis.color2
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["threshold3"] = {
		type = "range",
		name = L["Threshold to activate color 3"],
		max = 10,
		min = 1,
		step = .5,
		get = function ()
			return GridStatusHots.db.profile.alert_aegis.threshold3
		end,
		set = function (_, v)
			GridStatusHots.db.profile.alert_aegis.threshold3 = v
		end,
	},
	["color3"] = {
		type = "color",
		name = L["Color 3"],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_aegis.color3
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_aegis.color3
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
}

local inspiration_hotcolors = {
	["threshold2"] = {
		type = "range",
		name = L["Threshold to activate color 2"],
		max = 10,
		min = 1,
		step = .5,
		get = function ()
			return GridStatusHots.db.profile.alert_inspiration.threshold2
		end,
		set = function (_, v)
			GridStatusHots.db.profile.alert_inspiration.threshold2 = v
		end,
	},
	["color2"] = {
		type = "color",
		name = L["Color 2"],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_inspiration.color2
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_inspiration.color2
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["threshold3"] = {
		type = "range",
		name = L["Threshold to activate color 3"],
		max = 10,
		min = 1,
		step = .5,
		get = function ()
			return GridStatusHots.db.profile.alert_inspiration.threshold3
		end,
		set = function (_, v)
			GridStatusHots.db.profile.alert_inspiration.threshold3 = v
		end,
	},
	["color3"] = {
		type = "color",
		name = L["Color 3"],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_inspiration.color3
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_inspiration.color3
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
}

local beacon_hotcolors = {
	["threshold2"] = {
		type = "range",
		name = L["Threshold to activate color 2"],
		max = 30,
		min = 1,
		step = .5,
		get = function ()
				return GridStatusHots.db.profile.alert_beacon.threshold2
			end,
		set = function (_, v)
			GridStatusHots.db.profile.alert_beacon.threshold2 = v
		end,
	},
	["color2"] = {
		type = "color",
		name = L["Color 2"],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_beacon.color2
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_beacon.color2
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["threshold3"] = {
		type = "range",
		name = L["Threshold to activate color 3"],
		max = 30,
		min = 1,
		step = .5,
		get = function ()
			return GridStatusHots.db.profile.alert_beacon.threshold3
		end,
		set = function (_, v)
			GridStatusHots.db.profile.alert_beacon.threshold3 = v
		end,
	},
	["color3"] = {
		type = "color",
		name = L["Color 3"],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_beacon.color3
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_beacon.color3
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
}
--新增骑士
local eternal_hotcolors = {
	["threshold2"] = {
		type = "range",
		name = L["Threshold to activate color 2"],
		max = 30,
		min = 1,
		step = .5,
		get = function ()
				return GridStatusHots.db.profile.alert_eternal.threshold2
			end,
		set = function (_, v)
			GridStatusHots.db.profile.alert_eternal.threshold2 = v
		end,
	},
	["color2"] = {
		type = "color",
		name = L["Color 2"],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_eternal.color2
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_eternal.color2
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["threshold3"] = {
		type = "range",
		name = L["Threshold to activate color 3"],
		max = 30,
		min = 1,
		step = .5,
		get = function ()
			return GridStatusHots.db.profile.alert_eternal.threshold3
		end,
		set = function (_, v)
			GridStatusHots.db.profile.alert_eternal.threshold3 = v
		end,
	},
	["color3"] = {
		type = "color",
		name = L["Color 3"],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_eternal.color3
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_eternal.color3
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
}

local sacred_hotcolors = {
	["threshold2"] = {
		type = "range",
		name = L["Threshold to activate color 2"],
		max = 30,
		min = 1,
		step = .5,
		get = function ()
				return GridStatusHots.db.profile.alert_sacred.threshold2
			end,
		set = function (_, v)
			GridStatusHots.db.profile.alert_sacred.threshold2 = v
		end,
	},
	["color2"] = {
		type = "color",
		name = L["Color 2"],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_sacred.color2
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_sacred.color2
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["threshold3"] = {
		type = "range",
		name = L["Threshold to activate color 3"],
		max = 30,
		min = 1,
		step = .5,
		get = function ()
			return GridStatusHots.db.profile.alert_sacred.threshold3
		end,
		set = function (_, v)
			GridStatusHots.db.profile.alert_sacred.threshold3 = v
		end,
	},
	["color3"] = {
		type = "color",
		name = L["Color 3"],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_sacred.color3
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_sacred.color3
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
}

local earthliving_hotcolors = {
	["threshold2"] = {
		type = "range",
		name = L["Threshold to activate color 2"],
		max = 10,
		min = 1,
		step = .5,
		get = function ()
				return GridStatusHots.db.profile.alert_earthliving.threshold2
			end,
		set = function (_, v)
			GridStatusHots.db.profile.alert_earthliving.threshold2 = v
		end,
	},
	["color2"] = {
		type = "color",
		name = L["Color 2"],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_earthliving.color2
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_earthliving.color2
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["threshold3"] = {
		type = "range",
		name = L["Threshold to activate color 3"],
		max = 10,
		min = 1,
		step = .5,
		get = function ()
			return GridStatusHots.db.profile.alert_earthliving.threshold3
		end,
		set = function (_, v)
			GridStatusHots.db.profile.alert_earthliving.threshold3 = v
		end,
	},
	["color3"] = {
		type = "color",
		name = L["Color 3"],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_earthliving.color3
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_earthliving.color3
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["totshow"] = {
		type = "toggle",
		name = L["Show HoT-Counter"],
		desc = L["Check, if you want to see the total of HoTs behind the countdown of your HoT(i.e. 13-5)"],
		get = function () return GridStatusHots.db.profile.alert_earthliving.totshow end,
		set = function (_, arg)
			GridStatusHots.db.profile.alert_earthliving.totshow = arg
		end,
	},
}

local earthshield_hotcolors = {
	["color2"] = {
		type = "color",
		name = L["Color 2"],
		desc = L["Color when player has 2 charges of Earth Shield."],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_earthshield.color2
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_earthshield.color2
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["color3"] = {
		type = "color",
		name = L["Color 3"],
		desc = L["Color when player has 3 charges of Earth Shield."],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_earthshield.color3
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_earthshield.color3
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["color4"] = {
		type = "color",
		name = L["Color 4"],
		desc = L["Color when player has 4 charges of Earth Shield."],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_earthshield.color4
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_earthshield.color4
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["color5"] = {
		type = "color",
		name = L["Color 5"],
		desc = L["Color when player has 5 or more charges of Earth Shield."],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_earthshield.color5
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_earthshield.color5
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
}

local gracestack_hotcolors = {
	["color2"] = {
		type = "color",
		name = L["Color 2"],
		desc = L["Color when player has two charges of grace."],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_gracestack.color2
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_gracestack.color2
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["color3"] = {
		type = "color",
		name = L["Color 3"],
		desc = L["Color when player has three charges of grace."],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_gracestack.color3
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_gracestack.color3
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
}

local gracedurstack_hotcolors = {
	["threshold2"] = {
		type = "range",
		name = L["Threshold to activate color 2"],
		max = 10,
		min = 1,
		step = .5,
		get = function ()
			      return GridStatusHots.db.profile.alert_gracedurstack.threshold2
		      end,
		set = function (_, v)
			       GridStatusHots.db.profile.alert_gracedurstack.threshold2 = v
		end,
	},
	["color2"] = {
		type = "color",
		name = L["Color 2"],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_gracedurstack.color2
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_gracedurstack.color2
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["threshold3"] = {
		type = "range",
		name = L["Threshold to activate color 3"],
		max = 10,
		min = 1,
		step = .5,
		get = function ()
			      return GridStatusHots.db.profile.alert_gracedurstack.threshold3
		      end,
		set = function (_, v)
			       GridStatusHots.db.profile.alert_gracedurstack.threshold3 = v
		end,
	},
	["color3"] = {
		type = "color",
		name = L["Color 3"],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_gracedurstack.color3
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_gracedurstack.color3
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
}

local gift_hotcolors = {
	["threshold2"] = {
		type = "range",
		name = L["Threshold to activate color 2"],
		max = 10,
		min = 1,
		step = .5,
		get = function ()
			return GridStatusHots.db.profile.alert_gift.threshold2
		end,
		set = function (_, v)
			GridStatusHots.db.profile.alert_gift.threshold2 = v
		end,
	},
	["color2"] = {
		type = "color",
		name = L["Color 2"],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_gift.color2
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_gift.color2
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["threshold3"] = {
		type = "range",
		name = L["Threshold to activate color 3"],
		max = 10,
		min = 1,
		step = .5,
		get = function ()
			return GridStatusHots.db.profile.alert_gift.threshold3
		end,
		set = function (_, v)
			GridStatusHots.db.profile.alert_gift.threshold3 = v
		end,
	},
	["color3"] = {
		type = "color",
		name = L["Color 3"],
		hasAlpha = true,
		get = function ()
			local color = GridStatusHots.db.profile.alert_gift.color3
			return color.r, color.g, color.b, color.a
		end,
		set = function (_, r, g, b, a)
			local color = GridStatusHots.db.profile.alert_gift.color3
			color.r = r
			color.g = g
			color.b = b
			color.a = a or 1
		end,
	},
	["totshow"] = {
		type = "toggle",
		name = L["Show HoT-Counter"],
		desc = L["Check, if you want to see the total of HoTs behind the countdown of your HoT(i.e. 13-5)"],
		get = function () return GridStatusHots.db.profile.alert_gift.totshow end,
		set = function (_, arg)
			GridStatusHots.db.profile.alert_gift.totshow = arg
		end,
	},
}

--}}}


function GridStatusHots:OnInitialize()
	self.super.OnInitialize(self)

	self:RegisterStatuses()
end

GridStatusHots.defaultDB.update_frequency = 0.5
GridStatusHots.extraOptions = {
	update_frequency = {
		order = 101, width = "double",
		name = L["刷新频率"],
		desc = L["刷新频率过高会导致卡顿，请根据自己的需要调整"],
		type = "range", min = 0.1, max = 1, step = 0.1,
		get = function()
			return GridStatusHots.db.profile.update_frequency
		end,
		set = function(_, v)
			GridStatusHots.db.profile.update_frequency = v
			GridStatusHots:OnDisable()
            GridStatusHots:OnEnable()
		end,
	},
}

function GridStatusHots:OnEnable()
	if not refreshTimer then refreshTimer = self:ScheduleRepeatingTimer("UpdateAllUnits", self.db.profile.update_frequency) end
end

function GridStatusHots:OnDisable()
	if refreshTimer then self:CancelTimer(refreshTimer, true) refreshTimer = nil end
end

function GridStatusHots:Reset()
	self.super.Reset(self)

	self:UnregisterStatuses()
	self:RegisterStatuses()
	self:UpdateAllUnits()
end

function GridStatusHots:RegisterStatuses()
	-- Priest
	self:RegisterStatus("alert_tothots", L["Hots: Hot Count"], tothots_options)
	self:RegisterStatus("alert_renew", L["Hots: My Renew"], renew_hotcolors)
    self:RegisterStatus("alert_pom", L["Hots: My Prayer of Mending"], pom_hotcolors)
    self:RegisterStatus("alert_pomdur", L["Hots: My Prayer of Mending - duration colored"], pomdur_hotcolors)
	self:RegisterStatus("alert_gracestack", L["Hots: My Grace Stack"], gracestack_hotcolors)
	self:RegisterStatus("alert_gracedurstack", L["Hots: My Grace Duration + Stack"], gracedurstack_hotcolors)
	self:RegisterStatus("alert_pws", L["Hots: Power Word: Shield"], pws_hotcolors)
    self:RegisterStatus("alert_weakenedsoul", L["Hots: Weakened Soul"], weakenedsoul_hotcolors)
	self:RegisterStatus("alert_aegis", L["Hots: Divine Aegis"], aegis_hotcolors)
	self:RegisterStatus("alert_inspiration", L["Hots: Inspiration"], inspiration_hotcolors)
	-- Druid
	self:RegisterStatus("alert_rejuv", L["Hots: My Rejuvenation"], rejuv_hotcolors)
	self:RegisterStatus("alert_regrow", L["Hots: My Regrowth"], regrow_hotcolors)
	self:RegisterStatus("alert_lifebl", L["Hots: My Lifebloom"], lifebl_hotcolors)
	self:RegisterStatus("alert_lifebl_stack", L["Hots: My Lifebloom Stack Colored"], lifebl_stack_hotcolors)
	self:RegisterStatus("alert_wgrowth", L["Hots: My Wild Growth"], wgrowth_hotcolors)
	-- Monk
	self:RegisterStatus("alert_rmist", L["Hots: My Renewing Mist"], rmist_hotcolors)
	self:RegisterStatus("alert_zsphere", L["Hots: My Zen Sphere"], zsphere_hotcolors)
	self:RegisterStatus("alert_emist", L["Hots: My Enveloping Mist"], emist_hotcolors)
	-- Paladin
	self:RegisterStatus("alert_beacon", L["Hots: My Beacon of Light"], beacon_hotcolors)
	self:RegisterStatus("alert_eternal", L["Hots: My Eternal Flame"], eternal_hotcolors)
	self:RegisterStatus("alert_sacred", L["Hots: My Sacred Shield"], sacred_hotcolors)
	-- Shaman
	self:RegisterStatus("alert_riptide", L["Hots: My Riptide"], riptide_hotcolors)
	self:RegisterStatus("alert_earthliving", L["Hots: My Earthliving"], earthliving_hotcolors)
	self:RegisterStatus("alert_earthshield", L["Hots: My Earth Shield"], earthshield_hotcolors)
	self:RegisterStatus("alert_fortitude", L["Hots: Ancestral Fortitude"], fortitude_hotcolors)
	self:RegisterStatus("alert_vigor", L["Hots: Ancestral Vigor"], vigor_hotcolors)
	-- Draenei
	self:RegisterStatus("alert_gift", L["Hots: My Gift of the Naaru"], gift_hotcolors)
end

function GridStatusHots:UnregisterStatuses()
	self:UnregisterStatus("alert_tothots")
	-- Priest
	self:UnregisterStatus("alert_renew")
	self:UnregisterStatus("alert_pom")
	self:UnregisterStatus("alert_pomdur")
	self:UnregisterStatus("alert_gracestack")
	self:UnregisterStatus("alert_gracedurstack")
	self:UnregisterStatus("alert_pws")
	self:UnregisterStatus("alert_weakenedsoul")
	self:UnregisterStatus("alert_aegis")
	self:UnregisterStatus("alert_inspiration")
	-- Druid
	self:UnregisterStatus("alert_rejuv")
	self:UnregisterStatus("alert_regrow")
	self:UnregisterStatus("alert_lifebl")
	self:UnregisterStatus("alert_lifebl_stack")
	self:UnregisterStatus("alert_wgrowth")
	--Monk
	self:UnregisterStatus("alert_rmist")
	self:UnregisterStatus("alert_zsphere")
	self:UnregisterStatus("alert_emist")
	-- Paladin
	self:UnregisterStatus("alert_beacon")
	self:UnregisterStatus("alert_eternal")
	self:UnregisterStatus("alert_sacred")
	-- Shaman
	self:UnregisterStatus("alert_riptide")
	self:UnregisterStatus("alert_earthliving")
	self:UnregisterStatus("alert_earthshield")
	self:UnregisterStatus("alert_fortitude")
	self:UnregisterStatus("alert_vigor")
	-- Draenei
	self:UnregisterStatus("alert_gift")

end

function GridStatusHots:Grid_UnitJoined(guid, unitid)
	self:UpdateUnit(guid, unitid)
end

function GridStatusHots:UpdateAllUnits()
	for guid, unitid in GridRoster:IterateRoster() do
		self:UpdateUnit(guid, unitid)
	end
end

-- XXX 163 恢复 buff重名
local _renew_icon = select(3, GetSpellInfo(139))
function GridStatusHots:UpdateUnit(guid, unitid)
	local total_hots, lbstack, pomstack, mypomstack, grastack, esstack = 0, 0, 0, 0, 0, 0;
	local retime,rjtime,rgtime,lbtime,wgtime,sltime,sstime,ritime,pomtime,mypomtime,pwstime,boltime,eltime,estime,gratime,gifttime,datime,insptime,forttime,vigtime
	local rmisttime,emisttime,zspheretime,eternaltime,sacredtime		--新增5技能
	local wstime

	local now = GetTime()
	-- Find number of hots per unit
	for i=1,999 do
		local bname,brank,btexture,bcount,btype,bdur,bexptime,bismine = UnitBuff(unitid, i)
		if not bname then break end

		local btime = bexptime - now
		if bname == spellNameCache["Renew"] and btexture == _renew_icon then
			total_hots = total_hots + 1;
			if (bismine == "player" and btime) then retime = btime end
		elseif bname == spellNameCache["Regrowth"] then
			total_hots = total_hots + 1;
			if (bismine == "player" and btime) then rgtime = btime end
		elseif bname == spellNameCache["Rejuvenation"] then
			total_hots = total_hots + 1;
			if (bismine == "player" and btime) then rjtime = btime end
		elseif bname == spellNameCache["RenewingMist"] then
			total_hots = total_hots + 1;
			if (bismine == "player" and btime) then rmisttime = btime end
		elseif bname == spellNameCache["ZenSphere"] then
			total_hots = total_hots + 1;
			if (bismine == "player" and btime) then zspheretime = btime end
		elseif bname == spellNameCache["EnvelopingMist"] then
			total_hots = total_hots + 1;
			if (bismine == "player" and btime) then emisttime = btime end
		elseif bname == spellNameCache["Lifebloom1"] or bname == spellNameCache["Lifebloom2"] then
			if self.db.profile.alert_tothots.lbeach then
				total_hots = total_hots + bcount;
			else
				total_hots = total_hots + 1;
			end
			if (bismine == "player" and btime) then
				lbtime = btime
				lbstack = bcount
			end
		elseif bname == spellNameCache["WildGrowth"] then
			total_hots = total_hots + 1;
			if (bismine == "player" and btime) then wgtime = btime end
		elseif bname == spellNameCache["Riptide"] then
			total_hots = total_hots + 1;
			if (bismine == "player" and btime) then ritime = btime end
		elseif bname == spellNameCache["PrayerofMending"] then
				pomtime = btime
				pomstack = bcount
			if bismine == "player"then
				mypomtime = btime
				mypomstack = bcount
			end
		elseif bname == spellNameCache["PowerWordShield"] then
			if btime then
				pwstime = btime
			end
		elseif bname == spellNameCache["DivineAegis"] then
			if btime then
				datime = btime
			end
		elseif bname == spellNameCache["Inspiration"] then
			if btime then
				insptime = btime
			end
		elseif bname == spellNameCache["BeaconofLight"] then
			if (bismine == "player" and btime) then boltime = btime end
		elseif bname == spellNameCache["Earthliving"] then
			total_hots = total_hots + 1;
			if (bismine == "player" and btime) then eltime = btime end
		elseif bname == spellNameCache["EarthShield"] then
			if (bismine == "player" and btime) then
				estime = btime
				esstack = bcount
			end
		elseif bname == spellNameCache["EternalFlame"] then
			if btime then
				eternaltime = btime
			end
		elseif bname == spellNameCache["SacredShield"] then
			if btime then
				sacredtime = btime
			end
		elseif bname == spellNameCache["AncestralFortitude"] and btexture == spellIconCache["AncestralFortitude"] then
			if btime then
				forttime = btime
			end
		elseif bname == spellNameCache["AncestralVigor"] and btexture == spellIconCache["AncestralVigor"] then
			if btime then
				vigtime = btime
			end
		elseif bname == spellNameCache["Grace"] then
			if (bismine == "player" and btime) then
				gratime = btime
				grastack = bcount
			end
		elseif bname == spellNameCache["GiftoftheNaaru"] then
			total_hots = total_hots + 1;
			if (bismine == "player" and btime) then gifttime = btime end
		end
	end

	-- Find debuffs
	for i=1,999 do
		local dbname,dbrank,dbtexture,dbcount,dbtype,dbdur,dbexptime,dbismine = UnitDebuff(unitid, i)
		if not dbname then break end

		local dbtime = dbexptime - now
		if dbname == spellNameCache["WeakenedSoul"] then
			if dbtime then
				wstime = dbtime
			end
		end
	end

	-- Set number of hots currently running on all units
	if total_hots > 0 and self.db.profile.alert_tothots.enable then
		local settings = self.db.profile.alert_tothots
		self.core:SendStatusGained(guid, "alert_tothots",
			settings.priority,
			(settings.range and 40),
			settings.color,
			n2s(total_hots)
		)
	else
		if self.core:GetCachedStatus(guid, "alert_tothots") then self.core:SendStatusLost(guid, "alert_tothots") end
	end

    total_hots = "-"..n2s(total_hots)

	--Renew
	if retime and self.db.profile.alert_renew.enable then
		-- Add self thrown countdown and status
		local settings = self.db.profile.alert_renew
		local hotcolor = settings.color
		if retime <= settings.threshold2 then hotcolor = settings.color2 end
		if retime <= settings.threshold3 then hotcolor = settings.color3 end
		if settings.totshow then
			self.core:SendStatusGained(guid, "alert_renew",
				settings.priority,
				(settings.range and 40),
				hotcolor,
				n2s(floor(retime+.5))..total_hots
				--string.format("%d-%d", retime, total_hots)
			)
		else
			self.core:SendStatusGained(guid, "alert_renew",
				settings.priority,
				(settings.range and 40),
				hotcolor,
				n2s(floor(retime+.5))
				--string.format("%d", retime)
			)
		end
	else
		if self.core:GetCachedStatus(guid, "alert_renew") then self.core:SendStatusLost(guid, "alert_renew") end
	end

	--Regrowth
	if rgtime and self.db.profile.alert_regrow.enable then
		-- Add self thrown countdown and status
		local settings = self.db.profile.alert_regrow
		local hotcolor = settings.color
		if rgtime <= settings.threshold2 then hotcolor = settings.color2 end
		if rgtime <= settings.threshold3 then hotcolor = settings.color3 end
		if settings.totshow then
			self.core:SendStatusGained(guid, "alert_regrow",
				settings.priority,
				(settings.range and 40),
				hotcolor,
				n2s(floor(rgtime+.5))..total_hots
				--string.format("%d-%d", rgtime, total_hots)
			)
		else
			self.core:SendStatusGained(guid, "alert_regrow",
				settings.priority,
				(settings.range and 40),
				hotcolor,
                n2s(floor(rgtime+.5))
				--string.format("%d", rgtime)
			)
		end
	else
		if self.core:GetCachedStatus(guid, "alert_regrow") then self.core:SendStatusLost(guid, "alert_regrow") end
	end

	--Rejuv
	if rjtime and self.db.profile.alert_rejuv.enable then
		-- Add self thrown countdown and status
		local settings = self.db.profile.alert_rejuv
		local hotcolor = settings.color
		if rjtime <= settings.threshold2 then hotcolor = settings.color2 end
		if rjtime <= settings.threshold3 then hotcolor = settings.color3 end
		if settings.totshow then
			self.core:SendStatusGained(guid, "alert_rejuv",
				settings.priority,
				(settings.range and 40),
				hotcolor,
				n2s(floor(rjtime+.5))..total_hots
				--string.format("%d-%d", rjtime, total_hots)
			)
		else
			self.core:SendStatusGained(guid, "alert_rejuv",
				settings.priority,
				(settings.range and 40),
				hotcolor,
				n2s(floor(rjtime+.5))
				--string.format("%d", rjtime)
			)
		end
	else
		if self.core:GetCachedStatus(guid, "alert_rejuv") then self.core:SendStatusLost(guid, "alert_rejuv") end
	end

	--Renewing Mist
	if rmisttime and self.db.profile.alert_rmist.enable then
		-- Add self thrown countdown and status
		local settings = self.db.profile.alert_rmist
		local hotcolor = settings.color
		if rmisttime <= settings.threshold2 then hotcolor = settings.color2 end
		if rmisttime <= settings.threshold3 then hotcolor = settings.color3 end
		if settings.totshow then
			self.core:SendStatusGained(guid, "alert_rmist",
				settings.priority,
				(settings.range and 40),
				hotcolor,
				n2s(floor(rmisttime+.5))..total_hots
				--string.format("%d-%d", rmisttime, total_hots)
			)
		else
			self.core:SendStatusGained(guid, "alert_rmist",
				settings.priority,
				(settings.range and 40),
				hotcolor,
				n2s(floor(rmisttime+.5))
				--string.format("%d", rmisttime)
			)
		end
	else
		if self.core:GetCachedStatus(guid, "alert_rmist") then self.core:SendStatusLost(guid, "alert_rmist") end
	end
--Zen Sphere
	if zspheretime and self.db.profile.alert_zsphere.enable then
		-- Add self thrown countdown and status
		local settings = self.db.profile.alert_zsphere
		local hotcolor = settings.color
		if zspheretime <= settings.threshold2 then hotcolor = settings.color2 end
		if zspheretime <= settings.threshold3 then hotcolor = settings.color3 end
		if settings.totshow then
			self.core:SendStatusGained(guid, "alert_zsphere",
				settings.priority,
				(settings.range and 40),
				hotcolor,
				n2s(floor(zspheretime+.5))..total_hots
				--string.format("%d-%d", zspheretime, total_hots)
			)
		else
			self.core:SendStatusGained(guid, "alert_zsphere",
				settings.priority,
				(settings.range and 40),
				hotcolor,
				n2s(floor(zspheretime+.5))
				--string.format("%d", zspheretime)
			)
		end
	else
		if self.core:GetCachedStatus(guid, "alert_zsphere") then self.core:SendStatusLost(guid, "alert_zsphere") end
	end
--Enveloping Mist
	if emisttime and self.db.profile.alert_emist.enable then                                    -------------------------修复原版错误
		-- Add self thrown countdown and status
		local settings = self.db.profile.alert_emist
		local hotcolor = settings.color
		if emisttime <= settings.threshold2 then hotcolor = settings.color2 end
		if emisttime <= settings.threshold3 then hotcolor = settings.color3 end
		if settings.totshow then
			self.core:SendStatusGained(guid, "alert_emist",
				settings.priority,
				(settings.range and 40),
				hotcolor,
				n2s(floor(emisttime+.5))..total_hots
				--string.format("%d-%d", emisttime, total_hots)
			)
		else
			self.core:SendStatusGained(guid, "alert_emist",
				settings.priority,
				(settings.range and 40),
				hotcolor,
				n2s(floor(emisttime+.5))
				--string.format("%d", emisttime)
			)
		end
	else
		if self.core:GetCachedStatus(guid, "alert_emist") then self.core:SendStatusLost(guid, "alert_emist") end
	end

	--Lifebloom
	if lbtime and self.db.profile.alert_lifebl_stack.enable then
		-- Add self thrown countdown and status
		local settings = self.db.profile.alert_lifebl_stack
		local hotcolor = settings.color
		if lbstack == 2 then hotcolor = settings.color2 end
		if lbstack == 3 then hotcolor = settings.color3 end
		if settings.totshow then
			if settings.decshow then
				self.core:SendStatusGained(guid, "alert_lifebl_stack",
					settings.priority,
					(settings.range and 40),
					hotcolor,
				    f2s(lbtime, 1)..total_hots
					--string.format("%.1f-%d", lbtime, total_hots)
				)
			else
				self.core:SendStatusGained(guid, "alert_lifebl_stack",
					settings.priority,
					(settings.range and 40),
					hotcolor,
				    n2s(floor(lbtime+.5))..total_hots
					--string.format("%d-%d", lbtime, total_hots)
				)
			end
		else
			if settings.decshow then
				self.core:SendStatusGained(guid, "alert_lifebl_stack",
					settings.priority,
					(settings.range and 40),
					hotcolor,
                    f2s(lbtime, 1)
					--string.format("%.1f", lbtime)
				)
			else
				self.core:SendStatusGained(guid, "alert_lifebl_stack",
					settings.priority,
					(settings.range and 40),
					hotcolor,
                    n2s(floor(lbtime+.5))
					--string.format("%d", lbtime)
				)
			end
		end
	else
		if self.core:GetCachedStatus(guid, "alert_lifebl_stack") then self.core:SendStatusLost(guid, "alert_lifebl_stack") end
	end

	if lbtime and self.db.profile.alert_lifebl.enable then
		-- Add self thrown countdown and status
		local settings = self.db.profile.alert_lifebl
		local hotcolor = settings.color
		if lbtime <= settings.threshold2 then hotcolor = settings.color2 end
		if lbtime <= settings.threshold3 then hotcolor = settings.color3 end
		if settings.totshow then
			if settings.decshow then
				self.core:SendStatusGained(guid, "alert_lifebl",
					settings.priority,
					(settings.range and 40),
					hotcolor,
                    n2s(lbstack).."-"..f2s(lbtime, 1)..total_hots
					--string.format("%d-%.1f-%d", lbstack, lbtime, total_hots)
				)
			else
				self.core:SendStatusGained(guid, "alert_lifebl",
					settings.priority,
					(settings.range and 40),
					hotcolor,
                    n2s(lbstack).."-"..n2s(floor(lbtime+.5))..total_hots
					--string.format("%d-%d-%d", lbstack, lbtime, total_hots)
				)
			end
		else
			if settings.decshow then
				self.core:SendStatusGained(guid, "alert_lifebl",
					settings.priority,
					(settings.range and 40),
					hotcolor,
                    n2s(lbstack).."-"..f2s(lbtime, 1)
					--string.format("%d-%.1f", lbstack, lbtime)
				)
			else
				self.core:SendStatusGained(guid, "alert_lifebl",
					settings.priority,
					(settings.range and 40),
					hotcolor,
                    n2s(lbstack).."-"..n2s(floor(lbtime+.5))
					--string.format("%d-%d", lbstack, lbtime)
				)
			end
		end
	else
		if self.core:GetCachedStatus(guid, "alert_lifebl") then self.core:SendStatusLost(guid, "alert_lifebl") end
	end

	--Wild Growth
	if wgtime and self.db.profile.alert_wgrowth.enable then
		-- Add self thrown countdown and status
		local settings = self.db.profile.alert_wgrowth
		local hotcolor = settings.color
		if wgtime <= settings.threshold2 then hotcolor = settings.color2 end
		if wgtime <= settings.threshold3 then hotcolor = settings.color3 end
		if settings.totshow then
			self.core:SendStatusGained(guid, "alert_wgrowth",
				settings.priority,
				(settings.range and 40),
				hotcolor,
                n2s(floor(wgtime+.5))..total_hots
				--string.format("%d-%d", wgtime, total_hots)
			)
		else
			self.core:SendStatusGained(guid, "alert_wgrowth",
				settings.priority,
				(settings.range and 40),
				hotcolor,
                n2s(floor(wgtime+.5))
				--string.format("%d", wgtime)
			)
		end
	else
		if self.core:GetCachedStatus(guid, "alert_wgrowth") then self.core:SendStatusLost(guid, "alert_wgrowth") end
	end

	--Riptide
	if ritime and self.db.profile.alert_riptide.enable then
		-- Add self thrown countdown and status
		local settings = self.db.profile.alert_riptide
		local hotcolor = settings.color
		if ritime <= settings.threshold2 then hotcolor = settings.color2 end
		if ritime <= settings.threshold3 then hotcolor = settings.color3 end
		if settings.totshow then
			self.core:SendStatusGained(guid, "alert_riptide",
				settings.priority,
				(settings.range and 40),
				hotcolor,
                n2s(floor(ritime+.5))..total_hots
				--string.format("%d-%d", ritime, total_hots)
			)
		else
			self.core:SendStatusGained(guid, "alert_riptide",
				settings.priority,
				(settings.range and 40),
				hotcolor,
                n2s(floor(ritime+.5))
				--string.format("%d", ritime)
			)
		end
	else
		if self.core:GetCachedStatus(guid, "alert_riptide") then self.core:SendStatusLost(guid, "alert_riptide") end
	end

	-- Earth Shield
	if estime and self.db.profile.alert_earthshield.enable then
		-- Add self thrown countdown and status
		local settings = self.db.profile.alert_earthshield
		local hotcolor = settings.color
		if esstack == 2 then hotcolor = settings.color2 end
		if esstack == 3 then hotcolor = settings.color3 end
		if esstack == 4 then hotcolor = settings.color4 end
		if esstack > 4 then hotcolor = settings.color5 end
		self.core:SendStatusGained(guid, "alert_earthshield",
			settings.priority,
			(settings.range and 40),
			hotcolor,
			n2s(esstack)
		)
	else
		if self.core:GetCachedStatus(guid, "alert_earthshield") then self.core:SendStatusLost(guid, "alert_earthshield") end
	end

	--Prayer of Mending
	if pomtime or mypomtime and self.db.profile.alert_pom.enable then
		-- Add self thrown countdown and status
		local settings = self.db.profile.alert_pom
		local hotcolor = settings.color
		if pomstack == 2 then hotcolor = settings.color2 end
		if pomstack == 3 then hotcolor = settings.color3 end
		if pomstack == 4 then hotcolor = settings.color4 end
		if pomstack == 5 then hotcolor = settings.color5 end
		if pomstack == 6 then hotcolor = settings.color6 end
		if mypomtime and self.db.profile.alert_pom.mine then
			self.core:SendStatusGained(guid, "alert_pom",
				settings.priority,
				(settings.range and 40),
				hotcolor,
                n2s(floor(mypomtime+.5))
				--string.format("%d", mypomtime)
			)
		elseif pomtime and not self.db.profile.alert_pom.mine then
			self.core:SendStatusGained(guid, "alert_pom",
				settings.priority,
				(settings.range and 40),
				hotcolor,
                n2s(floor(pomtime+.5))
				--string.format("%d", pomtime)
			)
		else
			if self.core:GetCachedStatus(guid, "alert_pom") then self.core:SendStatusLost(guid, "alert_pom") end
		end
	else
		if self.core:GetCachedStatus(guid, "alert_pom") then self.core:SendStatusLost(guid, "alert_pom") end
	end

	if pomtime or mypomtime and self.db.profile.alert_pomdur.enable then
		-- Add self thrown countdown and status
		local settings = self.db.profile.alert_pomdur
		local hotcolor = settings.color
		if pomtime <= settings.threshold2 then hotcolor = settings.color2 end
		if pomtime <= settings.threshold3 then hotcolor = settings.color3 end
		if mypomtime and self.db.profile.alert_pom.mine then
			self.core:SendStatusGained(guid, "alert_pomdur",
				settings.priority,
				(settings.range and 40),
				hotcolor,
				n2s(mypomstack)
			)
		elseif pomtime and not self.db.profile.alert_pom.mine then
			self.core:SendStatusGained(guid, "alert_pomdur",
				settings.priority,
				(settings.range and 40),
				hotcolor,
				n2s(pomstack)
			)
		else
			if self.core:GetCachedStatus(guid, "alert_pomdur") then self.core:SendStatusLost(guid, "alert_pomdur") end
		end
	else
		if self.core:GetCachedStatus(guid, "alert_pomdur") then self.core:SendStatusLost(guid, "alert_pomdur") end
	end

	--Power Word: Shield
	if pwstime or wstime and self.db.profile.alert_pws.enable then
		if pwstime then
			-- Add self thrown countdown and status
			local settings = self.db.profile.alert_pws
			local hotcolor = settings.color
			if pwstime <= settings.threshold2 then hotcolor = settings.color2 end
			if pwstime <= settings.threshold3 then hotcolor = settings.color3 end
			if settings.wsshow and wstime then
				self.core:SendStatusGained(guid, "alert_pws",
					settings.priority,
					(settings.range and 40),
					hotcolor,
                    n2s(floor(pwstime+.5)).."-"..n2s(floor(wstime+.5))
					--string.format("%d-%d", n2s(floor)pwstime, wstime)
				)
			else
				self.core:SendStatusGained(guid, "alert_pws",
					settings.priority,
					(settings.range and 40),
					hotcolor,
                    n2s(floor(pwstime+.5))
					--string.format("%d", pwstime)
				)
			end
		elseif self.db.profile.alert_pws.wsshow and wstime then
			-- Add self thrown countdown and status
			local settings = self.db.profile.alert_weakenedsoul
			local hotcolor = settings.color
			if wstime <= settings.threshold2 then hotcolor = settings.color2 end
			if wstime <= settings.threshold3 then hotcolor = settings.color3 end
			self.core:SendStatusGained(guid, "alert_pws",
				settings.priority,
				(settings.range and 40),
				hotcolor,
                n2s(floor(wstime+.5))
				--string.format("%d", wstime)
			)
		else
			if self.core:GetCachedStatus(guid, "alert_pws") then self.core:SendStatusLost(guid, "alert_pws") end
		end
	else
		if self.core:GetCachedStatus(guid, "alert_pws") then self.core:SendStatusLost(guid, "alert_pws") end
	end

	--Weakened Soul
	if wstime and self.db.profile.alert_weakenedsoul.enable then
		-- Add self thrown countdown and status
		local settings = self.db.profile.alert_weakenedsoul
		local hotcolor = settings.color
		if wstime <= settings.threshold2 then hotcolor = settings.color2 end
		if wstime <= settings.threshold3 then hotcolor = settings.color3 end
		self.core:SendStatusGained(guid, "alert_weakenedsoul",
			settings.priority,
			(settings.range and 40),
			hotcolor,
            n2s(floor(wstime+.5))
			--string.format("%d", wstime)
		)
	else
		if self.core:GetCachedStatus(guid, "alert_weakenedsoul") then self.core:SendStatusLost(guid, "alert_weakenedsoul") end
	end

	--Divine Aegis
	if datime and self.db.profile.alert_aegis.enable then
		-- Add self thrown countdown and status
		local settings = self.db.profile.alert_aegis
		local hotcolor = settings.color
		if datime <= settings.threshold2 then hotcolor = settings.color2 end
		if datime <= settings.threshold3 then hotcolor = settings.color3 end
		self.core:SendStatusGained(guid, "alert_aegis",
			settings.priority,
			(settings.range and 40),
			hotcolor,
            n2s(floor(datime+.5))
            --string.format("%d", datime)
		)
	else
		if self.core:GetCachedStatus(guid, "alert_aegis") then self.core:SendStatusLost(guid, "alert_aegis") end
	end

	--Inspiration
	if insptime and self.db.profile.alert_inspiration.enable then
		-- Add self thrown countdown and status
		local settings = self.db.profile.alert_inspiration
		local hotcolor = settings.color
		if insptime <= settings.threshold2 then hotcolor = settings.color2 end
		if insptime <= settings.threshold3 then hotcolor = settings.color3 end
		self.core:SendStatusGained(guid, "alert_inspiration",
			settings.priority,
			(settings.range and 40),
			hotcolor,
            n2s(floor(insptime+.5))
			--string.format("%d", insptime)
		)
	else
		if self.core:GetCachedStatus(guid, "alert_inspiration") then self.core:SendStatusLost(guid, "alert_inspiration") end
	end

	--Beacon of Light
	if boltime and self.db.profile.alert_beacon.enable then
		-- Add self thrown countdown and status
		local settings = self.db.profile.alert_beacon
		local hotcolor = settings.color
		if boltime <= settings.threshold2 then hotcolor = settings.color2 end
		if boltime <= settings.threshold3 then hotcolor = settings.color3 end
		self.core:SendStatusGained(guid, "alert_beacon",
			settings.priority,
			(settings.range and 40),
			hotcolor,
            n2s(floor(boltime+.5))
			--string.format("%d", boltime)
		)
	else
		if self.core:GetCachedStatus(guid, "alert_beacon") then self.core:SendStatusLost(guid, "alert_beacon") end
	end

	--Eternal Flame
	if eternaltime and self.db.profile.alert_eternal.enable then
		-- Add self thrown countdown and status
		local settings = self.db.profile.alert_eternal
		local hotcolor = settings.color
		if eternaltime <= settings.threshold2 then hotcolor = settings.color2 end
		if eternaltime <= settings.threshold3 then hotcolor = settings.color3 end
		self.core:SendStatusGained(guid, "alert_eternal",
			settings.priority,
			(settings.range and 40),
			hotcolor,
            n2s(floor(eternaltime+.5))
			--string.format("%d", eternaltime)
		)
	else
		if self.core:GetCachedStatus(guid, "alert_eternal") then self.core:SendStatusLost(guid, "alert_eternal") end
	end

	--Sacred Shield
	if sacredtime and self.db.profile.alert_sacred.enable then
		-- Add self thrown countdown and status
		local settings = self.db.profile.alert_sacred
		local hotcolor = settings.color
		if sacredtime <= settings.threshold2 then hotcolor = settings.color2 end
		if sacredtime <= settings.threshold3 then hotcolor = settings.color3 end
		self.core:SendStatusGained(guid, "alert_sacred",
			settings.priority,
			(settings.range and 40),
			hotcolor,
            n2s(floor(sacredtime+.5))
			--string.format("%d", sacredtime)
		)
	else
		if self.core:GetCachedStatus(guid, "alert_sacred") then self.core:SendStatusLost(guid, "alert_sacred") end
	end
	
	--Earthliving
	if eltime and self.db.profile.alert_earthliving.enable then
		-- Add self thrown countdown and status
		local settings = self.db.profile.alert_earthliving
		local hotcolor = settings.color
		if eltime <= settings.threshold2 then hotcolor = settings.color2 end
		if eltime <= settings.threshold3 then hotcolor = settings.color3 end
		if settings.totshow then
			self.core:SendStatusGained(guid, "alert_earthliving",
				settings.priority,
				(settings.range and 40),
				hotcolor,
                n2s(floor(eltime+.5))..total_hots
				--string.format("%d-%d", eltime, total_hots)
			)
		else
			self.core:SendStatusGained(guid, "alert_earthliving",
				settings.priority,
				(settings.range and 40),
				hotcolor,
                n2s(floor(eltime+.5))
				--string.format("%d", eltime)
			)
		end
	else
		if self.core:GetCachedStatus(guid, "alert_earthliving") then self.core:SendStatusLost(guid, "alert_earthliving") end
	end

	--Ancestral Fortitude
	if forttime and self.db.profile.alert_fortitude.enable then
		-- Add self thrown countdown and status
		local settings = self.db.profile.alert_fortitude
		local hotcolor = settings.color
		if forttime <= settings.threshold2 then hotcolor = settings.color2 end
		if forttime <= settings.threshold3 then hotcolor = settings.color3 end
		self.core:SendStatusGained(guid, "alert_fortitude",
			settings.priority,
			(settings.range and 40),
			hotcolor,
            n2s(floor(forttime+.5))
			--string.format("%d", forttime)
		)
	else
		if self.core:GetCachedStatus(guid, "alert_fortitude") then self.core:SendStatusLost(guid, "alert_fortitude") end
	end

	--Ancestral Vigor
	if vigtime and self.db.profile.alert_vigor.enable then
		-- Add self thrown countdown and status
		local settings = self.db.profile.alert_vigor
		local hotcolor = settings.color
		if vigtime <= settings.threshold2 then hotcolor = settings.color2 end
		if vigtime <= settings.threshold3 then hotcolor = settings.color3 end
		self.core:SendStatusGained(guid, "alert_vigor",
			settings.priority,
			(settings.range and 40),
			hotcolor,
            n2s(floor(vigtime+.5))
			--string.format("%d", vigtime)
		)
	else
		if self.core:GetCachedStatus(guid, "alert_vigor") then self.core:SendStatusLost(guid, "alert_vigor") end
	end

	--Grace
	if gratime and (self.db.profile.alert_gracestack.enable or self.db.profile.alert_gracedurstack.enable) then
		-- Add self thrown countdown and status
		local settings = self.db.profile.alert_gracestack
		local hotcolor = settings.color
		if grastack == 2 then hotcolor = settings.color2 end
		if grastack == 3 then hotcolor = settings.color3 end
		self.core:SendStatusGained(guid, "alert_gracestack",
			settings.priority,
			(settings.range and 40),
			hotcolor,
            n2s(floor(gratime+.5))
			--string.format("%d", gratime)
		)

		-- Add self thrown countdown and status
		local settings = self.db.profile.alert_gracedurstack
		local hotcolor = settings.color
		if gratime <= settings.threshold2 then hotcolor = settings.color2 end
		if gratime <= settings.threshold3 then hotcolor = settings.color3 end
		self.core:SendStatusGained(guid, "alert_gracedurstack",
			settings.priority,
			(settings.range and 40),
			hotcolor,
            n2s(floor(gratime+.5)).."-"..n2s(grastack)
			--string.format("%d-%d", gratime, grastack)
		)
	else
		if self.core:GetCachedStatus(guid, "alert_gracestack") then self.core:SendStatusLost(guid, "alert_gracestack") end
		if self.core:GetCachedStatus(guid, "alert_gracedurstack") then self.core:SendStatusLost(guid, "alert_gracedurstack") end
	end

	--Gift of the Naaru
	if gifttime and self.db.profile.alert_gift.enable then
		-- Add self thrown countdown and status
		local settings = self.db.profile.alert_gift
		local hotcolor = settings.color
		if gifttime <= settings.threshold2 then hotcolor = settings.color2 end
		if gifttime <= settings.threshold3 then hotcolor = settings.color3 end
		if settings.totshow then
			self.core:SendStatusGained(guid, "alert_gift",
				settings.priority,
				(settings.range and 40),
				hotcolor,
                n2s(floor(gifttime+.5))..total_hots
				--string.format("%d-%d", gifttime, total_hots)
			)
		else
			self.core:SendStatusGained(guid, "alert_gift",
				settings.priority,
				(settings.range and 40),
				hotcolor,
                n2s(floor(gifttime+.5))
				--string.format("%d", gifttime)
			)
		end
	else
		if self.core:GetCachedStatus(guid, "alert_gift") then self.core:SendStatusLost(guid, "alert_gift") end
	end
end
