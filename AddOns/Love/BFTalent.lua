
--[[

GetTalentInfo(id)			--返回值： 名称,图标,行,列,是否已学,是否可学
GetTalentRowSelectionInfo(rowid) 行数 --返回值：是否可学习，如果是false，则返回学习的队列id
GetNumSpecializations() --返回值：获得可学的天赋分系个数
GetActiveSpecGroup() --返回值：获得当前激活天赋的分支 主天赋--1 副天赋--2
GetSpecialization()--返回值：获得天赋的信息
GetSpecializationInfo(id) id--GetSpecialization() ---返回值：_,天赋名称,说明,图标,_,职责类型
_G[select(6,GetSpecializationInfo(1))] -- 职责

--大边框
button.knownSelection:Show();
button.knownSelection:SetDesaturated(toggle); --toggle: true-- 灰色  false-- 金色
--小边框
button.highlight:SetAlpha(1);		--鼠标悬浮样式
button.learnSelection:Hide();		--选中样式

]]

if ( GetLocale() == "zhCN" ) then
	BFTalent_Title = "天赋推荐"
elseif (GetLocale() == "zhTW") then
	BFTalent_Title = "天賦推薦"
else
	BFTalent_Title = "Talent Healper"
end

-- 职业天赋推荐初始化
local class_Talent_Information = {
	["MAGE"] = {
		--奥术
		["62- PvP"] = {0},
		["62- PvE"] = {1,6,9,10,13,17},
		--火焰
		["63- PvP"] = {0},
		["63- PvE"] = {1,6,9,10,14,17},
		--冰霜
		["64- PvP"] = {0},
		["64- PvE"] = {1,6,9,10,14,17},
	},
	["PALADIN"] = {
		--神圣
		["65- PvP"] = {0},
		["65- PvE"] = {1,5,7,12,15,16},
		--防护
		["66- PvP"] = {0},
		["66- PvE"] = {2,4,7,11,13,18},
		--惩戒
		["70- PvP"] = {0},
		["70- PvE"] = {2,4,7,11,14,18},
	},
	["WARRIOR"] = {
		--武器
		["71- PvP"] = {0},
		["71- PvE"] = {2,4,8,12,15,16},
		--狂怒
		["72- PvP"] = {0},
		["72- PvE"] = {2,4,8,12,15,16},
		--防护
		["73- PvP"] = {0},
		["73- PvE"] = {2,4,8,11,14,16},
	},
	["DRUID"] = {
		--平衡
		["102- PvP"] = {0},
		["102- PvE"] = {3,4,9,11,15,18},
		--野性战斗DPS
		["103- PvP"] = {0},
		["103- PvE"] = {3,4,7,11,15,17},
		--野性守护T
		["104- PvP"] = {0},
		["104- PvE"] = {3,6,7,11,15,18},
		--恢复
		["105- PvP"] = {0},
		["105- PvE"] = {3,4,9,11,15,17},
	},
	["DEATHKNIGHT"] = {
		--鲜血
		["250- PvP"] = {0},
		["250- PvE"] = {1,4,7,10,15,18},
		--冰霜
		["251- PvP"] = {0},
		["251- PvE"] = {3,5,7,11,15,17},
		--邪恶
		["252- PvP"] = {0},
		["252- PvE"] = {1,5,7,11,15,18},
	},
	["HUNTER"] = {
		--兽王
		["253- PvP"] = {0},
		["253- PvE"] = {1,4,8,11,15,18},
		--射击
		["254- PvP"] = {0},
		["254- PvE"] = {1,4,8,12,14,18},
		--生存
		["255- PvP"] = {0},
		["255- PvE"] = {1,4,8,10,14,18},
	},
	["PRIEST"] = {
		--戒律
		["256- PvP"] = {0},
		["256- PvE"] = {1,4,8,10,13,16},
		--神圣
		["257- PvP"] = {0},
		["257- PvE"] = {1,4,8,10,13,16},
		--暗影
		["258- PvP"] = {0},
		["258- PvE"] = {1,6,7,10,15,16},
	},
	["ROGUE"] = {
		--刺杀
		["259- PvP"] = {0},
		["259- PvE"] = {1,6,7,12,15,18},
		--战斗
		["260- PvP"] = {0},
		["260- PvE"] = {1,6,9,12,13,18},
		--敏锐
		["261- PvP"] = {0},
		["261- PvE"] = {1,6,9,11,15,18},
	},
	["SHAMAN"] = {
		--元素
		["262- PvP"] = {0},
		["262- PvE"] = {3,4,9,12,14,18},
		--增强
		["263- PvP"] = {0},
		["263- PvE"] = {3,4,9,10,14,18},
		--恢复
		["264- PvP"] = {0},
		["264- PvE"] = {3,4,9,11,14,16},
	},
	["WARLOCK"] = {
		--痛苦
		["265- PvP"] = {0},
		["265- PvE"] = {3,5,7,11,13,18},
		--恶魔
		["266- PvP"] = {0},
		["266- PvE"] = {3,5,7,11,13,18},
		--毁灭
		["267- PvP"] = {0},
		["267- PvE"] = {3,5,7,11,13,18},
	},
	["MONK"] = {
		--酒仙T
		["268- PvP"] = {0},
		["268- PvE"] = {1,5,7,12,15,18},
		--踏风DPS
		["269- PvP"] = {0},
		["269- PvE"] = {1,4,7,12,14,17},
		--织雾HP
		["270- PvP"] = {0},
		["270- PvE"] = {1,4,8,12,14,17},
	},
}

local _,class = UnitClass("player");
local select_arg;
local talent_swith;

local function talentBuilderUpdate(builderTable,swith)
	if #builderTable == 1 and swith then
		print("天赋数据暂无！")
	end
	local name, iconTexture, tier, column, selected, available
	local button,selectbuttonid
	local numTalents = GetNumTalents and GetNumTalents() or 0;
	for i=1, numTalents do
		name, iconTexture, tier, column, selected, available = GetTalentInfo(i);
		selectbuttonid = builderTable[tier] or 0
		button = PlayerTalentFrameTalents["tier"..tier]["talent"..column];
		if button.bfbar and selectbuttonid == button.bfbar.id and talent_swith then
			button.bfbar:Show()
			button.bftip:Play()
		else
			button.bfbar:Hide()
			button.bftip:Stop()
		end
	end
end

local function ClassTalentBuilders_func(self,arg1,arg2)
	select_arg = arg1
	local builder = class_Talent_Information[class][arg1] or {}
	talentBuilderUpdate(builder,1)

	UIDropDownMenu_SetSelectedValue(BF_TalentSelectDropDown, self.value)
end

--初始化选项菜单
local ClassTalentBuilders = {
	[1] = {
		["name"] = BFTalent_Title,
		["isTitle"] = true
	},
	[2] = {
		["name"] = NONE,
		["func"] = ClassTalentBuilders_func,
	}
}

--构造玩家的选项菜单
local function build_ClassTalentBuilders()
	local numSpecs = GetNumSpecializations();
	local id, name, description, icon, background, duties;
	local talent_builder_pvp,talent_builder_pve
	for i = 1, numSpecs do
		id, name, description, icon, background, duties = GetSpecializationInfo(i);
		talent_builder_pvp = {}
		talent_builder_pvp.name = name.."- PvP";
		talent_builder_pvp.arg1 = id.."- PvP";
		talent_builder_pvp.arg2 = talent_builder_pvp;
		talent_builder_pvp.func = ClassTalentBuilders_func;
		talent_builder_pve = {}
		talent_builder_pve.name = name.."- PvE";
		talent_builder_pve.arg1 = id.."- PvE";
		talent_builder_pve.arg2 = talent_builder_pvp;
		talent_builder_pve.func = ClassTalentBuilders_func;
		table.insert(ClassTalentBuilders,talent_builder_pvp)
		table.insert(ClassTalentBuilders,talent_builder_pve)
	end
end

--构造边框
local function build_ClassTalentBorders()
	local name, iconTexture, tier, column, selected, available
	local button,tipAG,tipShow
	local numTalents = GetNumTalents and GetNumTalents() or 0;
	for i=1, numTalents do
		name, iconTexture, tier, column, selected, available = GetTalentInfo(i);
		button = PlayerTalentFrameTalents["tier"..tier]["talent"..column];
		button.bfbar = button:CreateTexture(button:GetName().."bfbar", "OVERLAY")
		tipAG = button.bfbar:CreateAnimationGroup("BFTalentAGtier"..tier.."talent"..column)
		tipShow = tipAG:CreateAnimation("Alpha")
		tipAG:SetLooping("BOUNCE")
		tipShow:SetDuration(1)
		tipShow:SetChange(-0.8)
		tipShow:SetOrder(1)
		button.bftip = tipAG
		button.bfbar.id = i;
		button.bfbar:SetAllPoints(button)
		button.bfbar:SetTexture("Interface\\TalentFrame\\talent-main")
		button.bfbar:SetWidth(200)
		button.bfbar:SetHeight(61)
		button.bfbar:SetTexCoord(0.00390625,0.78515625,0.25,0.36914063);
		-- button.bfbar:SetWidth(190)
		-- button.bfbar:SetHeight(51)
		-- button.bfbar:SetTexCoord(0.00390625,0.74609375,0.37304688,0.47265625);
		-- button.bfbar:SetDesaturated(true)
	end
end

local function BF_TalentSelectDropDown_Init()
    local info;
    for _,t in pairs(ClassTalentBuilders) do
        if type(t) == "table" then
			info = UIDropDownMenu_CreateInfo()
			info.isTitle = t.isTitle
			info.text = t.name
			info.arg1 = t.arg1
			info.arg2 = t.arg2
			info.func = t.func
			UIDropDownMenu_AddButton(info)
		end
    end
end

function BFTalent_Initialize()
	build_ClassTalentBuilders()
	build_ClassTalentBorders()
	local frame = CreateFrame("Frame", "BF_TalentSelectDropDown", PlayerTalentFrameTalents, "UIDropDownMenuTemplate");
	UIDropDownMenu_Initialize(frame, BF_TalentSelectDropDown_Init)
	frame:SetPoint("TOPLEFT", "PlayerTalentFrame", "TOPLEFT", 50, -30);
	frame:SetFrameLevel(PlayerTalentFrame:GetFrameLevel()+1)
	UIDropDownMenu_SetSelectedValue(BF_TalentSelectDropDown, BFTalent_Title)

	hooksecurefunc("PlayerTalentFrame_Update", function()
		if PlayerTalentFrame.talentGroup ~= GetActiveSpecGroup() then
			BF_TalentSelectDropDown:Hide()
			talentBuilderUpdate({})
		else
			if talent_swith then
				BF_TalentSelectDropDown:Show()
			end
			local builder = class_Talent_Information[class][select_arg] or {}
			talentBuilderUpdate(builder)
		end
	end)
end

local loaded
function BFTalent_Toggle(swith)
	talent_swith = swith
	if swith then
		if not loaded then
			dwAsynCall("Blizzard_TalentUI", "BFTalent_Initialize");			
			loaded = true
		else
			if BF_TalentSelectDropDown then
				BF_TalentSelectDropDown:Show()
			end
		end
	else
		if BF_TalentSelectDropDown then
			BF_TalentSelectDropDown:Hide()
		end
	end
end

BFTalent_Toggle(true)