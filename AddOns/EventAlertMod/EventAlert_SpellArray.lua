local function CopyTable(SrcTable)
	local TarTable = {};
	for sKey, sValue in pairs(SrcTable) do
		if type(sValue) == "table" then
			TarTable[sKey] = {};
			TarTable[sKey] = CopyTable(sValue);
		else
			TarTable[sKey] = sValue;
		end
	end
	return TarTable;
end
function EventAlert_LoadClassSpellArray(ItemType)
	if EA_Items[EA_playerClass] == nil then EA_Items[EA_playerClass] = {} end;
	if EA_AltItems[EA_playerClass] == nil then EA_AltItems[EA_playerClass] = {} end;
	if EA_Items[EA_CLASS_OTHER] == nil then EA_Items[EA_CLASS_OTHER] = {} end;
	if EA_TarItems[EA_playerClass] == nil then EA_TarItems[EA_playerClass] = {} end;
	if EA_ScdItems[EA_playerClass] == nil then EA_ScdItems[EA_playerClass] = {} end;
	if EA_GrpItems[EA_playerClass] == nil then EA_GrpItems[EA_playerClass] = {} end;

	if (ItemType == 1 or ItemType == 9) then
		for i, v in pairsByKeys(EADef_Items[EA_playerClass]["ITEMS"]) do
			i = tonumber(i);
			if (ItemType == 9) then
				EA_Items[EA_playerClass][i] = v;
			else
				if EA_Items[EA_playerClass][i] == nil then EA_Items[EA_playerClass][i] = v end;
			end
			
		end
	end
	if (ItemType == 2 or ItemType == 9) then
		for i, v in pairsByKeys(EADef_Items[EA_playerClass]["ALTITEMS"]) do
			i = tonumber(i);
			if (ItemType == 9) then
				EA_AltItems[EA_playerClass][i] = v;
			else
				if EA_AltItems[EA_playerClass][i] == nil then EA_AltItems[EA_playerClass][i] = v end;
			end
		end
	end
	if (ItemType == 3 or ItemType == 9) then
		for i, v in pairsByKeys(EADef_Items[EA_CLASS_OTHER]) do
			i = tonumber(i);
			if (ItemType == 9) then
				 EA_Items[EA_CLASS_OTHER][i] = v;
			else
				if EA_Items[EA_CLASS_OTHER][i] == nil then EA_Items[EA_CLASS_OTHER][i] = v  end;
			end
		end
	end
	if (ItemType == 4 or ItemType == 9) then
		for i, v in pairsByKeys(EADef_Items[EA_playerClass]["TARITEMS"]) do
			i = tonumber(i);
			if (ItemType == 9) then
				EA_TarItems[EA_playerClass][i] = v;
			else
				if EA_TarItems[EA_playerClass][i] == nil then EA_TarItems[EA_playerClass][i] = v end;
			end
		end
	end
	if (ItemType == 5 or ItemType == 9) then
		for i, v in pairsByKeys(EADef_Items[EA_playerClass]["SCDITEMS"]) do
			i = tonumber(i);
			if (ItemType == 9) then
				 EA_ScdItems[EA_playerClass][i] = v;
			else
				if EA_ScdItems[EA_playerClass][i] == nil then EA_ScdItems[EA_playerClass][i] = v end;
			end
		end
	end
	if (ItemType == 6 or ItemType == 9) then
		local iGroupCnts = 0;
		if (#EA_GrpItems[EA_playerClass] ~= nil) then iGroupCnts = #EA_GrpItems[EA_playerClass] end;
		for i, v in pairsByKeys(EADef_Items[EA_playerClass]["GRPITEMS"]) do
			i = tonumber(i);
			if EA_GrpItems[EA_playerClass][iGroupCnts+i] == nil then EA_GrpItems[EA_playerClass][iGroupCnts+i] = {} end;
			-- EA_GrpItems[EA_playerClass][iGroupCnts+i] = v;
			EA_GrpItems[EA_playerClass][iGroupCnts+i] = CopyTable(v);
		end
	end
end


function EventAlert_LoadSpellArray()

	EADef_Items = {};

--------------------------------------------------------------------------------
-- Death Knight / 死亡騎士
--------------------------------------------------------------------------------
	EADef_Items[EA_CLASS_DK] = {
		-- Primary Alert / 本職業提醒區
		["ITEMS"] = {
			[49222] = {enable=true,},
			[144948] = {enable=true,},
			[55233] = {enable=true,},
			[48792] = {enable=true,},
			[48707] = {enable=true,}, 
			[81256] = {enable=true,},
			[49039] = {enable=false,}, 
			[51271] = {enable=true,},
			[96268] = {enable=true,}, 
			[115989] = {enable=true,}, 
			[51124] = {enable=true,},
			[81141] = {enable=true,},
			[59052] = {enable=true,},
			[50421] = {enable=true, stack=5,},	 -- 血之气息
			[51124] = {enable=true,},
			[81340] = {enable=true,},
			[53365] = {enable=true,},
			[63560] = {enable=true,},
			[91342] = {enable=true,},
			[114851] = {enable=true,},
		},
		-- Alternate Alert / 本職業額外提醒區
		["ALTITEMS"] = {
			[56815] = {enable=true,},   -- Rune Strike / 符文打擊
		},
		-- Target Alert / 目標提醒區
		["TARITEMS"] = {
			[55095] = {enable=false, self=true,},    -- 冰霜熱疫
			[55078] = {enable=false, self=true,},    -- 血魄瘟疫
		--	[81130] = {enable=false, self=true,},    -- 血色熱疫
		},
		-- Spell Cooldown Alert / 本職業技能CD區
		["SCDITEMS"] = {
			[47528] = {enable=false,},
			[47476] = {enable=false,},
			[47481] = {enable=false,},
			[108200] = {enable=false,},
			[77606] = {enable=false,},
			[130736] = {enable=false,},
			[49576] = {enable=false,},
			[123693] = {enable=false,},
			[43265] = {enable=false,},
			[96268] = {enable=false,},
			[48982] = {enable=false,},
			[48707] = {enable=false,},
			[55233] = {enable=false,},
			[51271] = {enable=false,},
			[77575] = {enable=false,},
			[108199] = {enable=false,},
			[46584] = {enable=false,},
			[49028] = {enable=false,},
			[115989] = {enable=false,},
			[49039] = {enable=false,},
			[108201] = {enable=false,},
			[48743] = {enable=false,},
			[51052] = {enable=false,},
			[48792] = {enable=false,},
			[49206] = {enable=false,},

		},
		-- GroupEvent Alert / 本職業條件技能區
		["GRPITEMS"] = {
			[1] = {
				enable=false,
				LocX = 0,
				LocY = -200,
				IconSize = 80,
				IconAlpha = 0.5,
				IconPoint = "Top",
				IconRelatePoint = "Top",
				-- ActiveTalentGroup=1,	-- nil for all, 1 for primary, 2 for secondary
				Spells = {
					[1] = {
						SpellIconID = 57330,	-- 57330 凜冬號角
						Checks = {
							[1] = {
								CheckAndOp = true,
								SubChecks = {
									[1] = {	-- 玩家身上沒有凜風號角、並且凜冬號角不在CD中
										SubCheckAndOp = true,		-- 編號1的邏輯運算可以無視
										EventType = "UNIT_AURA",	-- 事件別，屬於"AURA異動類"
										UnitType = "player",		-- 檢測對象，為"玩家"
										CheckAuraNotExist = 57330,	-- 檢測"凜冬號角"Buff是否"不存在"
										CheckCD = 57330,		-- 檢測"凜冬號角"技能是否"CD中"
									},
									[2] = {	-- 並且(true)，身上沒有戰士的力量怒吼(不檢查此技能之CD)
										SubCheckAndOp = true,		-- true:並且, false:或者
										EventType = "UNIT_AURA",	-- 事件別，屬於"AURA異動類"
										UnitType = "player",		-- 檢測對象，為"玩家"
										CheckAuraNotExist = 6673, 	-- 檢測"力量怒吼"Buff是否"不存在"
									},
								},
							},
						},
					},
				},
			},
			[2] = {
				enable=false,
				LocX = 80,
				LocY = -200,
				IconSize = 80,
				IconAlpha = 0.5,
				IconPoint = "Top",
				IconRelatePoint = "Top",
				ActiveTalentGroup=1,	-- nil for all, 1 for primary, 2 for secondary
				Spells = {
					[1] = {
						SpellIconID = 49222,	-- 49222 駭骨之盾
						Checks = {
							[1] = {
								CheckAndOp = true,
								SubChecks = {
									[1] = {
										SubCheckAndOp = true,
										EventType = "UNIT_AURA",
										UnitType = "player",
										CheckAuraNotExist = 49222,
										CheckCD = 49222,
									},
								},
							},
						},
					},
				},
			},
		},
	}


--------------------------------------------------------------------------------
-- Druid / 德魯依
--------------------------------------------------------------------------------
	EADef_Items[EA_CLASS_DRUID] = {
		-- Primary Alert / 本職業提醒區
		["ITEMS"] = {
			[117679] = {enable=true,},
			[102560] = {enable=true,},
			[102543] = {enable=true,},
			[102558] = {enable=true,},
			[124974] = {enable=true,},
			[61336] = {enable=true,},
			[22812] = {enable=true,},
			[132402] = {enable=true,},
			[52610] = {enable=true,},
			[50334] = {enable=true,},
			[5217] = {enable=true,},
			[112071] = {enable=true,},
			[108294] = {enable=true,},
			[48505] = {enable=true,},
			[170856] = {enable=true,},
			[1850] = {enable=true,},
			[102351] = {enable=true,},
			[145152] = {enable=true,},
			[171743] = {enable=true,},
			[171744] = {enable=true,},
			[96206] = {enable=true,},
			[16870] = {enable=true,},
			[114108] = {enable=true,},
			[135286] = {enable=true,},
			[69369] = {enable=true,},
			[144871] = {enable=true,},			

		},
		-- Alternate Alert / 本職業額外提醒區
		["ALTITEMS"] = {
		},
		-- Target Alert / 目標提醒區
		["TARITEMS"] = {
			[164812] = {enable=false, self=true,},
			[164815] = {enable=false, self=true,},
			[155722] = {enable=false, self=true,},
			[1079] = {enable=false, self=true,},
			[33745] = {enable=false, self=true,},
			[77758] = {enable=false, self=true,},
			[45334] = {enable=false, self=true,},

		},
		-- Spell Cooldown Alert / 本職業技能CD區
		["SCDITEMS"] = {
			[88423] = {enable=false,},
			[2782] = {enable=false,},
			[106839] = {enable=false,},
			[33917] = {enable=false,},
			[48438] = {enable=false,},
			[18562] = {enable=false,},
			[6795] = {enable=false,},
			[22570] = {enable=false,},
			[78674] = {enable=false,},
			[102401] = {enable=false,},
			[102693] = {enable=false,},
			[770] = {enable=false,},
			[5217] = {enable=false,},
			[99] = {enable=false,},
			[102359] = {enable=false,},
			[132469] = {enable=false,},
			[5211] = {enable=false,},
			[78675] = {enable=false,},
			[22812] = {enable=false,},
			[102342] = {enable=false,},
			[132158] = {enable=false,},
			[102793] = {enable=false,},
			[124974] = {enable=false,},
			[106952] = {enable=false,},
			[102558] = {enable=false,},
			[33891] = {enable=false,},
			[102560] = {enable=false,},
			[102543] = {enable=false,},
		},
		-- GroupEvent Alert / 本職業條件技能區
		["GRPITEMS"] = {
			[1] = {
				enable=false,
				LocX = 0,
				LocY = -200,
				IconSize = 80,
				IconAlpha = 0.5,
				IconPoint = "Top",
				IconRelatePoint = "Top",
				ActiveTalentGroup=1,	-- nil for all, 1 for primary, 2 for secondary
				Spells = {
					[1] = {
						SpellIconID = 5217,	-- 5217 猛虎之怒
						Checks = {
							[1] = {
								CheckAndOp = true,
								SubChecks = {
									[1] = {
										SubCheckAndOp = true,
										EventType = "UNIT_POWER",
										UnitType = "player",
										PowerTypeNum = 3,
										PowerType = "ENERGY",
										CheckCD = 5217,
										PowerCompType = 2,
										PowerLessThanValue = 40,
									},
								},
							},
						},
					},
				},
			},
			[2] = {
				enable=false,
				LocX = 0,
				LocY = -200,
				IconSize = 80,
				IconAlpha = 0.5,
				IconPoint = "Top",
				IconRelatePoint = "Top",
				ActiveTalentGroup=2,	-- nil for all, 1 for primary, 2 for secondary
				Spells = {
					[1] = {
						SpellIconID = 48438,	-- 48438 野性癒合
						Checks = {
							[1] = {
								CheckAndOp = true,
								SubChecks = {
									[1] = {
										SubCheckAndOp = true,
										EventType = "UNIT_POWER",
										UnitType = "player",
										PowerTypeNum = 0,
										PowerType = "MANA",
										CheckCD = 48438,
										PowerCompType = 4,
										PowerLessThanValue = 5000,
									},
								},
							},
						},
					},
				},
			},
			[3] = {
				enable=false,
				LocX = 80,
				LocY = -200,
				IconSize = 80,
				IconAlpha = 0.5,
				IconPoint = "Top",
				IconRelatePoint = "Top",
				ActiveTalentGroup=2,	-- nil for all, 1 for primary, 2 for secondary
				Spells = {
					[1] = {
						SpellIconID = 29166,	-- 29166 啟動
						Checks = {
							[1] = {
								CheckAndOp = true,
								SubChecks = {
									[1] = {
										SubCheckAndOp = true,
										EventType = "UNIT_POWER",
										UnitType = "player",
										PowerTypeNum = 0,
										PowerType = "MANA",
										CheckCD = 29166,
										PowerCompType = 2,
										PowerLessThanPercent = 80,
									},
								},
							},
						},
					},
				},
			},
			[4] = {
				enable=false,
				LocX = -80,
				LocY = -200,
				IconSize = 80,
				IconAlpha = 0.5,
				IconPoint = "Top",
				IconRelatePoint = "Top",
				ActiveTalentGroup=2,	-- nil for all, 1 for primary, 2 for secondary
				Spells = {
					[1] = {
						SpellIconID = 18562,	-- 18562 迅愈
						Checks = {
							[1] = {
								CheckAndOp = true,
								SubChecks = {
									[1] = {
										SubCheckAndOp = true,
										EventType = "UNIT_POWER",
										UnitType = "player",
										PowerTypeNum = 0,
										PowerType = "MANA",
										CheckCD = 18562,
										PowerCompType = 4,
										PowerLessThanValue = 1700,
									},
								},
							},
						},
					},
				},
			},
			-- 1.割碎 2.無割裂，補割裂 3.有割裂無粉碎，補粉碎 4.痛擊 5.揮擊
			[5] = {
				enable=false,
				LocX = -80,
				LocY = -200,
				IconSize = 80,
				IconAlpha = 0.5,
				IconPoint = "Top",
				IconRelatePoint = "Top",
				ActiveTalentGroup=1,	-- nil for all, 1 for primary, 2 for secondary
				Spells = {
					[1] = {
						SpellIconID = 33878,	-- 割碎
						Checks = {
							[1] = {
								CheckAndOp = true,	-- 可無視
								SubChecks = {
									[1] = {	-- 玩家怒氣滿15以上，並且割碎不在CD中
										SubCheckAndOp = true,		-- 可無視
										EventType = "UNIT_POWER",	-- 事件別，屬於"能量異動類"
										UnitType = "player",		-- 檢測對象，為"玩家"
										PowerTypeNum = 1, 		-- 能量類型編號(1:怒氣)
										PowerType = "RAGE",		-- 能量類型, 可無視
										CheckCD = 33878,		-- 檢測"割碎"技能是否"CD中"
										PowerCompType = 4,		-- 能量, true:小於等於, false:大於等於
										PowerLessThanValue = 15,	-- 15
									},
								},
							},
						},
					},
					[2] = {
						SpellIconID = 33745,	-- 割裂
						Checks = {
							[1] = {
								CheckAndOp = true,	-- 可無視
								SubChecks = {
									[1] = {	-- 玩家怒氣滿15以上，並且割裂不在CD中
										SubCheckAndOp = true,		-- 可無視
										EventType = "UNIT_POWER",       -- 事件別，屬於"能量異動類"
										UnitType = "player",            -- 檢測對象，為"玩家"
										PowerTypeNum = 1,               -- 能量類型編號(1:怒氣)
										PowerType = "RAGE",             -- 能量類型, 可無視
										CheckCD = 33745,                -- 檢測"割裂"技能是否"CD中"
										PowerCompType = 4,          -- 能量, true:小於等於, false:大於等於
										PowerLessThanValue = 15,        -- 15
									},
								},
							},
							[2] = {
								CheckAndOp = true,	-- true:並且, false:或者
								SubChecks = {
									[1] = {	-- 目標身上無割裂
										SubCheckAndOp = true,		-- 可無視
										EventType = "UNIT_AURA",	-- 事件別，屬於"AURA異動類"
										UnitType = "target",		-- 檢測對象，為"目標"
										CastByPlayer = true,		-- true:只檢測玩家施放的
										CheckAuraNotExist = 33745,	-- 檢測"割裂"DeBuff是否"不存在"
									},
									[2] = {	-- 或者(false)，目標身上割裂小於等於2層堆疊
										SubCheckAndOp = false,		-- true:並且, false:或者
										EventType = "UNIT_AURA",	-- 事件別，屬於"AURA異動類"
										UnitType = "target",		-- 檢測對象，為"目標"
										CheckAuraExist = 33745,		-- 檢測"割裂"DeBuff是否"存在"
										CastByPlayer = true,		-- true:只檢測玩家施放的
										StackCompType = 2,		-- 堆疊層數, true:小於等於, false:大於等於
										StackLessThanValue = 2,		-- 2層
									},
									[3] = {	-- 或者(false)，目標身上割裂剩餘時間，小於等於3秒
										SubCheckAndOp = false,		-- true:並且, false:或者
										EventType = "UNIT_AURA",	-- 事件別，屬於"AURA異動類"
										UnitType = "target",		-- 檢測對象，為"目標"
										CheckAuraExist = 33745,		-- 檢測"割裂"DeBuff是否"存在"
										CastByPlayer = true,		-- true:只檢測玩家施放的
										TimeCompType = 2,		-- 剩餘時間, true:小於等於, false:大於等於
										TimeLessThanValue = 3,		-- 3秒
									},
								},
							},
						},
					},
					[3] = {
						SpellIconID = 80313,	-- 粉碎
						Checks = {
							[1] = {
								CheckAndOp = true,	-- 可無視
								SubChecks = {
									[1] = {	-- 玩家怒氣滿15以上，並且粉碎不在CD中
										SubCheckAndOp = true,		-- 可無視
										EventType = "UNIT_POWER",       -- 事件別，屬於"能量異動類"
										UnitType = "player",            -- 檢測對象，為"玩家"
										PowerTypeNum = 1,               -- 能量類型編號(1:怒氣)
										PowerType = "RAGE",             -- 能量類型, 可無視
										CheckCD = 80313,                -- 檢測"割碎"技能是否"CD中"
										PowerCompType = 4,          -- 能量, true:小於等於, false:大於等於
										PowerLessThanValue = 15,        -- 15
									},
									[2] = {	-- 並且(true)，目標身上有玩家施放的割裂Debuff
										SubCheckAndOp = true,		-- true:並且, false:或者
										EventType = "UNIT_AURA",	-- 事件別，屬於"AURA異動類"
										UnitType = "target",		-- 檢測對象，為"目標"
										CastByPlayer = true,		-- true:只檢測玩家施放的
										CheckAuraExist = 33745,		-- 檢測"割裂"DeBuff是否"存在"
									},
								},
							},
							[2] = {
								CheckAndOp = true,	-- true:並且, false:或者
								SubChecks = {
									[1] = {	-- 玩家身上的粉碎Buff剩餘時間，小於等於3秒
										SubCheckAndOp = true,		-- 可無視
										EventType = "UNIT_AURA",	-- 事件別，屬於"AURA異動類"
										UnitType = "player",		-- 檢測對象，為"玩家"
										CheckAuraExist = 80951,		-- 檢測"粉碎"Buff是否"存在"
										TimeCompType = 2,		-- 剩餘時間, true:小於等於, false:大於等於
										TimeLessThanValue = 3,		-- 3秒
									},
									[2] = {	-- 或者(false)，玩家身上沒有粉碎Buff
										SubCheckAndOp = false,		-- true:並且, false:或者
										EventType = "UNIT_AURA",	-- 事件別，屬於"AURA異動類"
										UnitType = "player",		-- 檢測對象，為"玩家"
										CheckAuraNotExist = 80951,	-- 檢測"粉碎"Buff是否"不存在"
									},
								},
							},
						},
					},
					[4] = {
						SpellIconID = 77758,	-- 痛擊
						Checks = {
							[1] = {
								CheckAndOp = true,	-- 可無視
								SubChecks = {
									[1] = {	-- 玩家怒氣滿25以上，並且痛擊不在CD中
										SubCheckAndOp = true,		-- 可無視
										EventType = "UNIT_POWER",       -- 事件別，屬於"能量異動類"
										UnitType = "player",            -- 檢測對象，為"玩家"
										PowerTypeNum = 1,               -- 能量類型編號(1:怒氣)
										PowerType = "RAGE",             -- 能量類型, 可無視
										CheckCD = 77758,                -- 檢測"痛擊"技能是否"CD中"
										PowerCompType = 4,          -- 能量, true:小於等於, false:大於等於
										PowerLessThanValue = 25,        -- 25
									},
								},
							},
						},
					},
					[5] = {
						SpellIconID = 779,	-- 揮擊
						Checks = {
							[1] = {
								CheckAndOp = true,	-- 可無視
								SubChecks = {
									[1] = {	-- 玩家怒氣滿25以上，並且揮擊不在CD中
										SubCheckAndOp = true,		-- 可無視
										EventType = "UNIT_POWER",       -- 事件別，屬於"能量異動類"
										UnitType = "player",            -- 檢測對象，為"玩家"
										PowerTypeNum = 1,               -- 能量類型編號(1:怒氣)
										PowerType = "RAGE",             -- 能量類型, 可無視
										CheckCD = 779,                  -- 檢測"揮擊"技能是否"CD中"
										PowerCompType = 4,          -- 能量, true:小於等於, false:大於等於
										PowerLessThanValue = 15,        -- 15
									},
								},
							},
						},
					},
				},
			},
		},
	}


--------------------------------------------------------------------------------
-- Hunter / 獵人
--------------------------------------------------------------------------------
	EADef_Items[EA_CLASS_HUNTER] = {
		-- Primary Alert / 本職業提醒區
		["ITEMS"] = {
			[19263] = {enable=true,},
			[3045] = {enable=true,},
			[19574] = {enable=true,},
			[82692] = {enable=true,},
			[90361] = {enable=true,},
			[118922] = {enable=true,},
			[177668] = {enable=true,},
			[168980] = {enable=true,},
			[19615] = {enable=true,},
			[136] = {enable=true,},

			[34720] = {enable=true, stack=3,},   -- 狩猎刺激
		--	[82925] = {enable=true, stack=3,},   -- 准备，端枪，瞄准……
		},
		-- Alternate Alert / 本職業額外提醒區
		["ALTITEMS"] = {
			[53351] = {enable=true,},   -- Kill Shot / 擊殺射擊
		},
		-- Target Alert / 目標提醒區
		["TARITEMS"] = {
			[3674] = {enable=false, self=true,},
			[53301] = {enable=false, self=true,},
			[136634] = {enable=false, self=true,},
		},
		-- Spell Cooldown Alert / 本職業技能CD區
		["SCDITEMS"] = {
			[5116] = {enable=false,},
			[147362] = {enable=false,},
			[34026] = {enable=false,},
			[53301] = {enable=false,},
			[53209] = {enable=false,},
			[53351] = {enable=false,},
			[117050] = {enable=false,},
			[120360] = {enable=false,},
			[781] = {enable=false,},
			[120679] = {enable=false,},
			[82726] = {enable=false,},
			[34477] = {enable=false,},
			[5384] = {enable=false,},
			[13813] = {enable=false,},
			[13809] = {enable=false,},
			[117526] = {enable=false,},
			[53271] = {enable=false,},
			[109259] = {enable=false,},
			[19386] = {enable=false,},
			[19577] = {enable=false,},
			[19574] = {enable=false,},
			[131894] = {enable=false,},
			[120697] = {enable=false,},
			[109304] = {enable=false,},
			[3045] = {enable=false,},
			[19263] = {enable=false,},
			[90361] = {enable=false,},
		},
		-- GroupEvent Alert / 本職業條件技能區
		["GRPITEMS"] = {
		},
	}


--------------------------------------------------------------------------------
-- Mage / 法師
--------------------------------------------------------------------------------
	EADef_Items[EA_CLASS_MAGE] = {
		-- Primary Alert / 本職業提醒區
		["ITEMS"] = {
			[45438] = {enable=true,},
			[32612] = {enable=true,},
			[110960] = {enable=true,},
			[12472] = {enable=true,},
			[12042] = {enable=true,},
			[11426] = {enable=true,},
			[111264] = {enable=true,},
			[48107] = {enable=true,},
			[108839] = {enable=true,},
			[1463] = {enable=true,},
			[110909] = {enable=true,},
			[115610] = {enable=true,},
			[116014] = {enable=true,},
			[44544] = {enable=true,},
			[57761] = {enable=true,},
			[79683] = {enable=true,},
			[48108] = {enable=true,},

			[36032] = {enable=true, stack=6,},   -- 奥术充能			
		},
		-- Alternate Alert / 本職業額外提醒區
		["ALTITEMS"] = {
		},
		-- Target Alert / 目標提醒區
		["TARITEMS"] = {
			[31589] = {enable=false, self=true,},
			[12654] = {enable=false, self=true,},
			[44457] = {enable=false, self=true,},
			[114923] = {enable=false, self=true,},
			[112948] = {enable=false, self=true,},
			[11366] = {enable=false, self=true,},
			[83853] = {enable=false, self=true,},
			[33395] = {enable=false, self=true,},
			[122] = {enable=false, self=true,},
			[111340] = {enable=false, self=true,},
			[120] = {enable=false, self=true,},
			[44614] = {enable=false, self=true,},
		},
		-- Spell Cooldown Alert / 本職業技能CD區
		["SCDITEMS"] = {
			[475] = {enable=false,}, 
			[102051] = {enable=false,},
			[2139] = {enable=false,},
			[1953] = {enable=false,},
			[108843] = {enable=false,},
			[44572] = {enable=false,},
			[122] = {enable=false,},
			[111264] = {enable=false,},
			[113724] = {enable=false,},
			[11426] = {enable=false,},
			[115610] = {enable=false,},
			[1463] = {enable=false,},
			[2136] = {enable=false,},
			[112948] = {enable=false,},
			[2120] = {enable=false,},
			[120] = {enable=false,},
			[33395] = {enable=false,},
			[108839] = {enable=false,},
			[11129] = {enable=false,},
			[84714] = {enable=false,},
			[12042] = {enable=false,},
			[12043] = {enable=false,},
			[12051] = {enable=false,},
			[12472] = {enable=false,},
			[11958] = {enable=false,},
			[55342] = {enable=false,},
			[108978] = {enable=false,},
			[45438] = {enable=false,},
			[66] = {enable=false,},
		},
		-- GroupEvent Alert / 本職業條件技能區
		["GRPITEMS"] = {
			[1] = {
				enable=false,
				LocX = 0,
				LocY = -200,
				IconSize = 80,
				IconAlpha = 0.5,
				IconPoint = "Top",
				IconRelatePoint = "Top",
				-- ActiveTalentGroup=1,	-- nil for all, 1 for primary, 2 for secondary
				Spells = {
					[1] = {
						SpellIconID = 12051,	-- 12051 喚醒
						Checks = {
							[1] = {
								CheckAndOp = true,
								SubChecks = {
									[1] = {
										SubCheckAndOp = true,
										EventType = "UNIT_POWER",
										UnitType = "player",
										PowerTypeNum = 0,
										PowerType = "MANA",
										CheckCD = 12051,
										PowerCompType = 2,
										PowerLessThanPercent = 40,
									},
								},
							},
						},
					},
				},
			},
		},
	}


--------------------------------------------------------------------------------
-- Paladin / 聖騎士
--------------------------------------------------------------------------------
	EADef_Items[EA_CLASS_PALADIN] = {
		-- Primary Alert / 本職業提醒區
		["ITEMS"] = {
			[642] = {enable=true,},
			[86659] = {enable=true,},
			[105809] = {enable=true,},
			[31884] = {enable=true,},
			[31850] = {enable=true,},
			[498] = {enable=true,},
			[85499] = {enable=true,},
			[114163] = {enable=true,},
			[20925] = {enable=true,},
			[54149] = {enable=true,},
			[114637] = {enable=true,},
			[114250] = {enable=false,},
			[90174] = {enable=true,},
			[85416] = {enable=true,},
			[88819] = {enable=true,},
			[87173] = {enable=true,},
			[144595] = {enable=true,},

			[114250] = {enable=true, stack=3,},   -- 无私治愈
			[85247] = {enable=true, stack=3,},   -- 神圣能量
		},
		-- Alternate Alert / 本職業額外提醒區
		["ALTITEMS"] = {
			[24275] = {enable=true,},   -- Hammer of Wrath / 憤怒之錘
		},
		-- Target Alert / 目標提醒區
		["TARITEMS"] = {
			[25771] = {enable=false, self=true,},      -- 制裁之錘
			[31803] = {enable=false, self=true,},     -- 神聖憤怒
			[63529] = {enable=false, self=true,},    -- 退邪術
			[20170] = {enable=false, self=true,},    -- 懺悔
			[2812] = {enable=false, self=true,},
		},
		-- Spell Cooldown Alert / 本職業技能CD區
		["SCDITEMS"] = {
			[4987] = {enable=false,},
			[96231] = {enable=false,},
			[20066] = {enable=false,},
			[10326] = {enable=false,},
			[853] = {enable=false,},
			[20271] = {enable=false,},
			[26573] = {enable=false,},
			[119072] = {enable=false,},
			[31935] = {enable=false,},
			[879] = {enable=false,},
			[114165] = {enable=false,},
			[1044] = {enable=false,},
			[114039] = {enable=false,},
			[85499] = {enable=false,},
			[498] = {enable=false,},
			[114157] = {enable=false,},
			[114158] = {enable=false,},
			[115750] = {enable=false,},
			[105809] = {enable=false,},
			[31821] = {enable=false,},
			[6940] = {enable=false,},
			[31884] = {enable=false,},
			[31850] = {enable=false,},
			[1022] = {enable=false,},			
		},
		-- GroupEvent Alert / 本職業條件技能區
		["GRPITEMS"] = {
			[1] = {
				enable=false,
				LocX = 0,
				LocY = -200,
				IconSize = 80,
				IconAlpha = 0.5,
				IconPoint = "Top",
				IconRelatePoint = "Top",
				ActiveTalentGroup=2,	-- nil for all, 1 for primary, 2 for secondary
				Spells = {
					[1] = {
						SpellIconID = 85673,	-- 85673 榮耀聖言
						Checks = {
							[1] = {
								CheckAndOp = true,
								SubChecks = {
									[1] = {
										SubCheckAndOp = true,
										EventType = "UNIT_POWER",
										UnitType = "player",
										PowerTypeNum = 9,
										PowerType = "HOLY_POWER",
										CheckCD = 85673,
										PowerCompType = 4,
										PowerLessThanValue = 3,
									},
									[2] = {
										SubCheckAndOp = true,
										EventType = "UNIT_HEALTH",
										UnitType = "target",
										HealthCompType = 2,
										HealthLessThanPercent = 80,
									},
								},
							},
						},
					},
					[2] = {
						SpellIconID = 85222,	-- 85222 黎明曙光(手電筒)
						Checks = {
							[1] = {
								CheckAndOp = true,
								SubChecks = {
									[1] = {
										SubCheckAndOp = true,
										EventType = "UNIT_POWER",
										UnitType = "player",
										PowerTypeNum = 9,
										PowerType = "HOLY_POWER",
										CheckCD = 85222,
										PowerCompType = 4,
										PowerLessThanValue = 3,
									},
								},
							},
						},
					},
				},
			},
			[2] = {
				["enable"] = false,
				["LocX"] = 0,
				["LocY"] = -200,
				["IconSize"] = 80,
				["IconAlpha"] = 0.5,
				["IconPoint"] = "Top",
				["IconRelatePoint"] = "Top",
				["ActiveTalentGroup"] = 1,
				["HideOnLostTarget"] = true,
				["Spells"] = {
					[1] = {
						["SpellIconID"] = 24275,
						["Checks"] = {
							[1] = {
								["CheckAndOp"] = true,
								["SubChecks"] = {
									[1] = {
										["HealthLessThanPercent"] = 20,
										["UnitType"] = "target",
										["CheckCD"] = 24275,
										["SubCheckResult"] = false,
										["SubCheckAndOp"] = true,
										["EventType"] = "UNIT_HEALTH",
										["HealthCompType"] = 1,
									}, -- [1]
								},
							}, -- [1]
						},
					}, -- [1]
					[2] = {
						["SpellIconID"] = 879,
						["Checks"] = {
							[1] = {
								["CheckAndOp"] = true,
								["SubChecks"] = {
									[1] = {
										["SubCheckResult"] = false,
										["UnitType"] = "player",
										["SubCheckAndOp"] = true,
										["CheckCD"] = 879,
										["CheckAuraExist"] = 59578,
										["EventType"] = "UNIT_AURA",
									}, -- [1]
								},
							}, -- [1]
						},
					}, -- [2]
					[3] = {
						["SpellIconID"] = 85256,
						["Checks"] = {
							[1] = {
								["CheckAndOp"] = true,
								["SubChecks"] = {
									[1] = {
										["SubCheckAndOp"] = true,
										["PowerType"] = "HOLY_POWER",
										["UnitType"] = "player",
										["PowerLessThanValue"] = 3,
										["CheckCD"] = 85256,
										["PowerTypeNum"] = 9,
										["EventType"] = "UNIT_POWER",
										["PowerCompType"] = 4,
									}, -- [1]
									[2] = {
										["SubCheckResult"] = false,
										["UnitType"] = "player",
										["SubCheckAndOp"] = false,
										["CheckCD"] = 85256,
										["CheckAuraExist"] = 90174,
										["EventType"] = "UNIT_AURA",
									}, -- [2]
								},
							}, -- [1]
						},
					}, -- [3]
					[4] = {
						["SpellIconID"] = 20271,
						["Checks"] = {
							[1] = {
								["CheckAndOp"] = true,
								["SubChecks"] = {
									[1] = {
										["SubCheckAndOp"] = true,
										["EventType"] = "UNIT_POWER",
										["SubCheckResult"] = false,
										["PowerType"] = "MANA",
										["UnitType"] = "player",
										["PowerLessThanValue"] = 90,
										["PowerTypeNum"] = 0,
										["CheckCD"] = 20271,
										["PowerCompType"] = 4,
									}, -- [1]
								},
							}, -- [1]
						},
					}, -- [4]
					[5] = {
						["SpellIconID"] = 35395,
						["Checks"] = {
							[1] = {
								["CheckAndOp"] = true,
								["SubChecks"] = {
									[1] = {
										["SubCheckAndOp"] = true,
										["EventType"] = "UNIT_POWER",
										["SubCheckResult"] = false,
										["PowerType"] = "HOLY_POWER",
										["UnitType"] = "player",
										["PowerLessThanValue"] = 3,
										["PowerTypeNum"] = 9,
										["CheckCD"] = 35395,
										["PowerCompType"] = 1,
									}, -- [1]
									[2] = {
										["SubCheckAndOp"] = false,
										["EventType"] = "UNIT_POWER",
										["SubCheckResult"] = false,
										["PowerType"] = "MANA",
										["UnitType"] = "player",
										["PowerLessThanValue"] = 100,
										["PowerTypeNum"] = 0,
										["CheckCD"] = 35395,
										["PowerCompType"] = 4,
									}, -- [2]
								},
							}, -- [1]
						},
					}, -- [5]
				},
			}, -- [2]
		},
	}


--------------------------------------------------------------------------------
-- Priest / 牧師
--------------------------------------------------------------------------------
	EADef_Items[EA_CLASS_PRIEST] = {
		-- Primary Alert / 本職業提醒區
		["ITEMS"] = {
			[47585] = {enable=true,},
			[10060] = {enable=true,},		
			[109964] = {enable=true,},		
			[81700] = {enable=true,},		
			[15286] = {enable=true,},		
			[17] = {enable=true,},		
			[139] = {enable=true,},		
			[586] = {enable=true,},		
			[45242] = {enable=true,},	
			[123267] = {enable=true,},	
			[124430] = {enable=true,},	
			[114255] = {enable=true,},	
			[87160] = {enable=true,},	
			[63735] = {enable=true,},	
			[81292] = {enable=true,},	
			[59889] = {enable=true,},	
			[123254] = {enable=true,},	
			[81661] = {enable=true,},	
			[132573] = {enable=true,},			

			[81661] = {enable=true, stack=5,},   -- 福音传播
			[63735] = {enable=true, stack=2,},   -- 妙手回春
			[81292] = {enable=true, stack=2,},   -- 心灵尖刺雕文
			[77487] = {enable=true, stack=3,},   -- 暗影宝珠
		},
		-- Alternate Alert / 本職業額外提醒區
		["ALTITEMS"] = {
		},
		-- Target Alert / 目標提醒區
		["TARITEMS"] = {
			[114404] = {enable=false, self=true,},      -- Shadow Word: Pain / 暗言術:痛
			[87194] = {enable=false, self=true,},     -- Devouring Plague / 噬靈瘟疫
			[589] = {enable=false, self=true,},     -- Weakened Soul / 虛弱靈魂
			[34914] = {enable=false, self=true,},    -- Vampiric Touch / 吸血之觸
			[2944] = {enable=false, self=true,},
		},
		-- Spell Cooldown Alert / 本職業技能CD區
		["SCDITEMS"] = {
			[527] = {enable=false,},   -- 注入能量
			[32375] = {enable=false,},   -- 脈輪運轉
			[47540] = {enable=false,},   -- 奧流之術
			[8092] = {enable=false,},   -- 暗言術:死
			[14914] = {enable=false,},   -- 痛苦鎮壓
			[34861] = {enable=false,},   -- 暗影惡魔
			[33076] = {enable=false,},   -- 懺悟
			[110744] = {enable=false,},   -- 影散
			[121135] = {enable=false,},   -- 大天使
			[81700] = {enable=false,},   -- 聖言術:寧
			[88625] = {enable=false,},   -- 心靈專注
			[120517] = {enable=false,},
			[32379] = {enable=false,},
			[8122] = {enable=false,},
			[64044] = {enable=false,},
			[15487] = {enable=false,},
			[10060] = {enable=false,},
			[47585] = {enable=false,},
			[33206] = {enable=false,},
			[47788] = {enable=false,},
			[62618] = {enable=false,},
			[19236] = {enable=false,},
			[73325] = {enable=false,},
			[108920] = {enable=false,},
		},
		-- GroupEvent Alert / 本職業條件技能區
		["GRPITEMS"] = {
			[1] = {
				enable=false,
				LocX = 0,
				LocY = -200,
				IconSize = 80,
				IconAlpha = 0.5,
				IconPoint = "Top",
				IconRelatePoint = "Top",
				-- ActiveTalentGroup=1,	-- nil for all, 1 for primary, 2 for secondary
				Spells = {
					[1] = {
						SpellIconID = 34433,	-- 34433 暗影惡魔
						Checks = {
							[1] = {
								CheckAndOp = true,
								SubChecks = {
									[1] = {
										SubCheckAndOp = true,
										EventType = "UNIT_POWER",
										UnitType = "player",
										PowerTypeNum = 0,
										PowerType = "MANA",
										CheckCD = 34433,
										PowerCompType = 2,
										PowerLessThanPercent = 70,
									},
								},
							},
						},
					},
				},
			},
			[2] = {
				enable=false,
				LocX = 80,
				LocY = -200,
				IconSize = 80,
				IconAlpha = 0.5,
				IconPoint = "Top",
				IconRelatePoint = "Top",
				ActiveTalentGroup=2,	-- nil for all, 1 for primary, 2 for secondary
				Spells = {
					[1] = {
						SpellIconID = 32379,	-- 32379 暗言術: 死
						Checks = {
							[1] = {	-- 目標血量小於等於25%、並且暗言術:死不在CD中。
								CheckAndOp = true,
								SubChecks = {
									[1] = {	-- 目標血量小於等於25%、並且暗言術:死不在CD中。
										SubCheckAndOp = true,		-- 可無視
										EventType = "UNIT_HEALTH",	-- 事件別，屬於"血量異動類"
										UnitType = "target",		-- 檢測對象，為"目標"
										CheckCD = 32379,		-- 檢測"暗言術: 死"技能是否"CD中"
										HealthCompType = 2,		-- 血量, true:小於等於, false:大於等於
										HealthLessThanPercent = 25,	-- 25%
									},
								},
							},
						},
					},
				},
			},
			[3] = {
				enable=false,
				LocX = -80,
				LocY = -200,
				IconSize = 80,
				IconAlpha = 0.5,
				IconPoint = "Top",
				IconRelatePoint = "Top",
				ActiveTalentGroup=2,	-- nil for all, 1 for primary, 2 for secondary
				Spells = {
					[1] = {
						SpellIconID = 8092,	-- 8092 心靈震爆
						Checks = {
							[1] = {
								CheckAndOp = true,
								SubChecks = {
									[1] = {	-- 心爆未CD，且MP夠
										SubCheckAndOp = true,
										EventType = "UNIT_POWER",
										UnitType = "player",
										PowerTypeNum = 0,
										PowerType = "MANA",
										CheckCD = 8092,
										PowerCompType = 4,
										PowerLessThanValue = 3500,
									},
									[2] = {	-- 且 黑球存在
										SubCheckAndOp = true,
										EventType = "UNIT_AURA",
										UnitType = "player",
										CheckAuraExist = 77487,
									},
								},
							},
							[2] = {
								CheckAndOp = true,
								SubChecks = {
									[1] = {	-- 紅球剩3秒
										SubCheckAndOp = true,
										EventType = "UNIT_AURA",
										UnitType = "player",
										CheckAuraExist = 95799,
										TimeCompType = 2,
										TimeLessThanValue = 3,
									},
									[2] = {	-- 或 紅球不存在
										SubCheckAndOp = false,
										EventType = "UNIT_AURA",
										UnitType = "player",
										CheckAuraNotExist = 95799,
									},
									[3] = {	-- 或 黑球x3
										SubCheckAndOp = false,
										EventType = "UNIT_AURA",
										UnitType = "player",
										CheckAuraExist = 77487,
										StackCompType = 4,
										StackLessThanValue = 3,
									},
								},
							},
						},
					},
					[2] = {
						SpellIconID = 34914,	-- 34914 吸血之觸
						Checks = {
							[1] = {
								CheckAndOp = true,
								SubChecks = {
									[1] = {	-- 吸血之觸未CD，且MP夠
										SubCheckAndOp = true,
										EventType = "UNIT_POWER",
										UnitType = "player",
										PowerTypeNum = 0,
										PowerType = "MANA",
										CheckCD = 34914,
										PowerCompType = 4,
										PowerLessThanValue = 3300,
									},
								},
							},
							[1] = {
								CheckAndOp = true,
								SubChecks = {
									[1] = {	-- 吸血之觸剩2秒
										SubCheckAndOp = true,
										EventType = "UNIT_AURA",
										UnitType = "target",
										CastByPlayer = true,
										CheckAuraExist = 34914,
										TimeCompType = 2,
										TimeLessThanValue = 2,
									},
									[2] = {	-- 或 目標身上 無 吸血之觸
										SubCheckAndOp = false,
										EventType = "UNIT_AURA",
										UnitType = "target",
										CastByPlayer = true,
										CheckAuraNotExist = 34914,
									},
								},
							},
						},
					},
					[3] = {
						SpellIconID = 589,	-- 589 暗言術:痛
						Checks = {
							[1] = {
								CheckAndOp = true,
								SubChecks = {
									[1] = {
										SubCheckAndOp = true,
										EventType = "UNIT_POWER",
										UnitType = "player",
										PowerTypeNum = 0,
										PowerType = "MANA",
										CheckCD = 589,
										PowerCompType = 4,
										PowerLessThanValue = 4100,
									},
									[2] = {
										SubCheckAndOp = true,
										EventType = "UNIT_AURA",
										UnitType = "target",
										CastByPlayer = true,
										CheckAuraNotExist = 589,
									},
								},
							},
						},
					},
					[4] = {
						SpellIconID = 2944,	-- 2944 噬靈瘟疫
						Checks = {
							[1] = {
								CheckAndOp = true,
								SubChecks = {
									[1] = {
										SubCheckAndOp = true,
										EventType = "UNIT_POWER",
										UnitType = "player",
										PowerTypeNum = 0,
										PowerType = "MANA",
										CheckCD = 2944,
										PowerCompType = 4,
										PowerLessThanValue = 4800,
									},
									[2] = {
										SubCheckAndOp = true,
										EventType = "UNIT_AURA",
										UnitType = "target",
										CastByPlayer = true,
										CheckAuraNotExist = 2944,
									},
								},
							},
						},
					},
				},
			},
		},
	}


--------------------------------------------------------------------------------
-- Rogue / 盜賊
--------------------------------------------------------------------------------
	EADef_Items[EA_CLASS_ROGUE] = {
		-- Primary Alert / 本職業提醒區
		["ITEMS"] = {
			[5171] = {enable=true,},
			[73651] = {enable=true,},
			[13750] = {enable=true,},
			[5277] = {enable=true,},
			[32645] = {enable=true,},
			[51713] = {enable=true,},
			[31665] = {enable=true,},
			[31224] = {enable=true,},
			[1856] = {enable=true,},
			[74001] = {enable=true,},
			[74002] = {enable=true,},
			[45182] = {enable=true,},
			[13877] = {enable=true,},
			[2983] = {enable=true,},
			[1966] = {enable=true,},
			[115192] = {enable=true,},
			[115189] = {enable=true,},
			[84745] = {enable=true,},
			[84746] = {enable=true,},
			[84747] = {enable=true,},
			[121153] = {enable=true,},

		},
		-- Alternate Alert / 本職業額外提醒區
		["ALTITEMS"] = {
			[14251] = {enable=true,},   -- Riposte / 還擊
		},
		-- Target Alert / 目標提醒區
		["TARITEMS"] = {
			[1943] = {enable=false, self=true,},
			[703] = {enable=false, self=true,},
			[1776] = {enable=false, self=true,},
			[84617] = {enable=false, self=true,},
			[79140] = {enable=false, self=true,},
			[16511] = {enable=false, self=true,},
			[91021] = {enable=false, self=true,},
			[2818] = {enable=false, self=true,},
			[3409] = {enable=false, self=true,},
			[8680] = {enable=false, self=true,},
			
		},
		-- Spell Cooldown Alert / 本職業技能CD區
		["SCDITEMS"] = {
			[1784] = {enable=false,}, 
			[1766] = {enable=false,}, 
			[1776] = {enable=false,},
			[408] = {enable=false,},
			[14183] = {enable=false,},
			[2983] = {enable=false,},
			[51690] = {enable=false,},
			[13750] = {enable=false,},
			[79140] = {enable=false,},
			[51713] = {enable=false,},
			[74001] = {enable=false,},
			[1856] = {enable=false,},
		},
		-- GroupEvent Alert / 本職業條件技能區
		["GRPITEMS"] = {
			[1] = {
				enable=false,
				LocX = 0,
				LocY = -200,
				IconSize = 80,
				IconAlpha = 0.5,
				IconPoint = "Top",
				IconRelatePoint = "Top",
				--ActiveTalentGroup=2,	-- nil for all, 1 for primary, 2 for secondary
				Spells = {
					[1] = {
						SpellIconID = 53,	-- 53 背刺
						Checks = {
							[1] = {
								CheckAndOp = true,
								SubChecks = {
									[1] = {
										SubCheckAndOp = true,
										EventType = "UNIT_POWER",
										UnitType = "player",
										PowerTypeNum = 3,
										PowerType = "ENERGY",
										CheckCD = 53,
										PowerCompType = 4,
										PowerLessThanValue = 40,
									},
									[2] = {
										SubCheckAndOp = true,
										EventType = "UNIT_HEALTH",
										UnitType = "target",
										HealthCompType = 2,
										HealthLessThanPercent = 35,
									},
								},
							},
						},
					},
				},
			},
		},
	}


--------------------------------------------------------------------------------
-- Shaman / 薩滿
--------------------------------------------------------------------------------
	EADef_Items[EA_CLASS_SHAMAN] = {
		-- Primary Alert / 本職業提醒區
		["ITEMS"] = {
			[324] = {enable=false,},     -- 閃電之盾
			[53817] = {enable=true,},
			[30823] = {enable=true,},
			[16166] = {enable=true,},
			[114049] = {enable=true,},
			[79206] = {enable=true,},
			[73683] = {enable=true,},
			[73685] = {enable=true,},
			[31616] = {enable=true,},
			[114893] = {enable=true,},
			[108281] = {enable=true,},
			[108271] = {enable=true,},
			[77762] = {enable=true,},
			[118522] = {enable=true,},
			[128985] = {enable=true,},
			[53390] = {enable=true,},
			[126697] = {enable=true,},
			[146308] = {enable=true,},
			[148903] = {enable=true,},
			[148896] = {enable=true,},
			[146310] = {enable=true,},
			[146312] = {enable=true,},
			[138699] = {enable=true,},
			[138938] = {enable=true,},
			[138895] = {enable=true,},
			[139120] = {enable=true,},
			[138756] = {enable=true,},
			[136086] = {enable=true,},
			[126649] = {enable=true,},
			[126599] = {enable=true,},
			[126554] = {enable=true,},
			[126690] = {enable=true,},
			[126707] = {enable=true,},
			[136082] = {enable=true,},
			[126605] = {enable=true,},
			[126683] = {enable=true,},
			[126705] = {enable=true,},
			[146046] = {enable=true,},
			[148906] = {enable=true,},
			[148897] = {enable=true,},
			[146184] = {enable=true,},
			[146218] = {enable=true,},
			[138963] = {enable=true,},
			[138703] = {enable=true,},
			[139133] = {enable=true,},
			[138898] = {enable=true,},		
			[138786] = {enable=true,},
			[126659] = {enable=true,},
			[126577] = {enable=true,},
			[146314] = {enable=true,},
			[148908] = {enable=true,},
			[148911] = {enable=true,},
			[126588] = {enable=true,},			
			[53817] = {enable=true, stack=5,},  -- 氣漩武器			
			[324] = {enable=true, stack=7,},   -- 闪电之盾
		},
		-- Alternate Alert / 本職業額外提醒區
		["ALTITEMS"] = {
		},
		-- Target Alert / 目標提醒區
		["TARITEMS"] = {
			[17364] = {enable=false, self=true,}, 
			[8056] = {enable=false, self=true,}, 
			[8050] = {enable=false, self=true,}, 
			[64695] = {enable=false, self=true,},
			[974] = {enable=false, self=true,},
			[61295] = {enable=false, self=true,},
		},
		-- Spell Cooldown Alert / 本職業技能CD區
		["SCDITEMS"] = {
			[51886] = {enable=false,},
			[57994] = {enable=false,},
			[51514] = {enable=false,},
			[8042] = {enable=false,},
			[51505] = {enable=false,},
			[61295] = {enable=false,},
			[17364] = {enable=false,},
			[60103] = {enable=false,},
			[73920] = {enable=false,},
			[117014] = {enable=false,},
			[73680] = {enable=false,},
			[51490] = {enable=false,},
			[2484] = {enable=false,},
			[8143] = {enable=false,},
			[30823] = {enable=false,},
			[108270] = {enable=false,},
			[108271] = {enable=false,},
			[16188] = {enable=false,},
			[51533] = {enable=false,},
			[79206] = {enable=false,},
			[108281] = {enable=false,},
			[114049] = {enable=false,},
			[20594] = {enable=false,},
			[28880] = {enable=false,},
			[20572] = {enable=false,},
			[20549] = {enable=false,},
			[26297] = {enable=false,},
			[69070] = {enable=false,},
			[107079] = {enable=false,},				
		},
		-- GroupEvent Alert / 本職業條件技能區
		["GRPITEMS"] = {
			[1] = {
				["enable"] = false,
				["LocX"] = 0,
				["LocY"] = -200,
				["IconSize"] = 80,
				["IconAlpha"] = 0.5,
				["IconPoint"] = "Top",
				["IconRelatePoint"] = "Top",
				["ActiveTalentGroup"] = 2,
				["HideOnLeaveCombat"] = true,
				["Spells"] = {
					[1] = {
						["SpellIconID"] = 51505,
						["Checks"] = {
							[1] = {
								["CheckAndOp"] = true,
								["SubChecks"] = {
									[1] = {
										["SubCheckAndOp"] = true,
										["EventType"] = "UNIT_POWER",
										["UnitType"] = "player",
										["PowerTypeNum"] = 0,
										["PowerType"] = "MANA",
										["CheckCD"] = 51505,
										["PowerCompType"] = 4,
										["PowerLessThanValue"] = 380,
									}, -- [1]
								},
							}, -- [1]
						},
					}, -- [1]
					[2] = {
						["SpellIconID"] = 8050,
						["Checks"] = {
							[1] = {
								["CheckAndOp"] = true,
								["SubChecks"] = {
									[1] = {
										["SubCheckAndOp"] = true,
										["EventType"] = "UNIT_AURA",
										["UnitType"] = "target",
										["CheckCD"] = 8050,
										["CheckAuraNotExist"] = 8050,
										["CastByPlayer"] = true,
									}, -- [1]
									[2] = {
										["SubCheckAndOp"] = false,
										["EventType"] = "UNIT_AURA",
										["UnitType"] = "target",
										["CastByPlayer"] = true,
										["CheckAuraExist"] = 8050,
										["CheckCD"] = 8050,
										["TimeCompType"] = 2,
										["TimeLessThanValue"] = 5,
									}, -- [2]
								},
							}, -- [1]
						},
					}, -- [2]
					[3] = {
						["SpellIconID"] = 8042,
						["Checks"] = {
							[1] = {
								["CheckAndOp"] = true,
								["SubChecks"] = {
									[1] = {
										["SubCheckAndOp"] = true,
										["EventType"] = "UNIT_AURA",
										["UnitType"] = "target",
										["CheckCD"] = 8042,
										["CastByPlayer"] = true,
										["CheckAuraExist"] = 8050,
										["TimeCompType"] = 5,
										["TimeLessThanValue"] = 5,
									}, -- [1]
									[2] = {
										["SubCheckAndOp"] = true,
										["EventType"] = "UNIT_AURA",
										["UnitType"] = "player",
										["CheckAuraExist"] = 324,
										["StackCompType"] = 4,
										["StackLessThanValue"] = 9,
									}, -- [2]
								},
							}, -- [1]
							[2] = {
								["CheckAndOp"] = false,
								["SubChecks"] = {
									[1] = {
										["SubCheckAndOp"] = true,
										["EventType"] = "UNIT_AURA",
										["UnitType"] = "target",
										["CheckCD"] = 8042,
										["CastByPlayer"] = true,
										["CheckAuraExist"] = 8050,
										["TimeCompType"] = 3,
										["TimeLessThanValue"] = 5,
									}, -- [1]
									[2] = {
										["SubCheckAndOp"] = true,
										["EventType"] = "UNIT_AURA",
										["UnitType"] = "player",
										["CheckAuraExist"] = 324,
										["StackCompType"] = 4,
										["StackLessThanValue"] = 7,
									}, -- [2]
								},
							}, -- [2]
						},
					}, -- [3]
				},
			}, -- [1]
			[2] = {
				["enable"] = false,
				["LocX"] = 0,
				["LocY"] = -200,
				["IconSize"] = 80,
				["IconAlpha"] = 0.5,
				["IconPoint"] = "Top",
				["IconRelatePoint"] = "Top",
				["ActiveTalentGroup"] = 2,
				["Spells"] = {
					[1] = {
						["SpellIconID"] = 324,
						["Checks"] = {
							[1] = {
								["CheckAndOp"] = true,
								["SubChecks"] = {
									[1] = {
										["SubCheckAndOp"] = true,
										["EventType"] = "UNIT_AURA",
										["UnitType"] = "player",
										["CheckCD"] = 324,
										["CheckAuraExist"] = 324,
										["CastByPlayer"] = true,
										["TimeCompType"] = 1,
										["TimeLessThanValue"] = 60,
									}, -- [1]
									[2] = {
										["SubCheckAndOp"] = false,
										["EventType"] = "UNIT_AURA",
										["UnitType"] = "player",
										["CheckAuraNotExist"] = 324,
									}, -- [2]
								},
							}, -- [1]
						},
					}, -- [1]
				},
			}, -- [2]
		},
	}


--------------------------------------------------------------------------------
-- Warlock / 術士
--------------------------------------------------------------------------------
	EADef_Items[EA_CLASS_WARLOCK] = {
		-- Primary Alert / 本職業提醒區
		["ITEMS"] = {
			[110913] = {enable=true,},
			[104773] = {enable=true,},
			[113861] = {enable=true,},
			[113860] = {enable=true,},
			[113858] = {enable=true,},
			[74434] = {enable=true,},
			[86211] = {enable=true,},
			[111400] = {enable=true,},
			[108683] = {enable=true,},
			[122355] = {enable=true,},
			[117828] = {enable=true,},
			[171982] = {enable=true,},
			[145164] = {enable=true,},
			
			[108647] = {enable=true, stack=3,},   -- 爆燃灰烬
		},
		-- Alternate Alert / 本職業額外提醒區
		["ALTITEMS"] = {
		},
		-- Target Alert / 目標提醒區
		["TARITEMS"] = {
			[1098] = {enable=false, self=true,},      -- Corruption / 腐蝕術
			[603] = {enable=false, self=true,},      -- Immolate / 獻祭
			[980] = {enable=false, self=true,},      -- 末日災厄
			[146739] = {enable=false, self=true,},      -- 暗影箭
			[27243] = {enable=false, self=true,},      -- 痛苦災厄
			[348] = {enable=false, self=true,},     -- Curse of the Elements / 元素詛咒
			[30108] = {enable=false, self=true,},    -- 燒盡
			[48181] = {enable=false, self=true,},    -- 痛苦動盪
		},
		-- Spell Cooldown Alert / 本職業技能CD區
		["SCDITEMS"] = {
			[19505] = {enable=false,},
			[19647] = {enable=false,},
			[30283] = {enable=false,},
			[5484] = {enable=false,},
			[6789] = {enable=false,},
			[7812] = {enable=false,},
			[105174] = {enable=false,},
			[48020] = {enable=false,},
			[89751] = {enable=false,},
			[74434] = {enable=false,},
			[108501] = {enable=false,},		
		},
		-- GroupEvent Alert / 本職業條件技能區
		["GRPITEMS"] = {
		},
	}


--------------------------------------------------------------------------------
-- Warrior / 戰士
--------------------------------------------------------------------------------
	EADef_Items[EA_CLASS_WARRIOR] = {
		-- Primary Alert / 本職業提醒區
		["ITEMS"] = {
			[871] = {enable=true,},
			[12975] = {enable=true,},
			[55694] = {enable=true,},
			[2565] = {enable=true,},
			[112048] = {enable=true,},
			[23920] = {enable=true,},
			[118038] = {enable=true,},
			[18499] = {enable=true,},
			[107574] = {enable=true,},
			[12292] = {enable=true,},
			[1719] = {enable=true,},
			[169667] = {enable=true,},
			[12328] = {enable=true,},
			[32216] = {enable=true,},
			[52437] = {enable=true,},
			[131116] = {enable=true,},
			[46916] = {enable=true,},
			[50227] = {enable=true,},
			[122510] = {enable=true,},
			[85739] = {enable=true,},
			[169686] = {enable=true,},
			[12880] = {enable=true,},
			[86663] = {enable=true,},


			[85739] = {enable=true, stack=3,},   -- 绞肉机
		},
		-- Alternate Alert / 本職業額外提醒區
		["ALTITEMS"] = {
		},
		-- Target Alert / 目標提醒區
		["TARITEMS"] = {
			[772] = {enable=false, self=true,},
			[86346] = {enable=false, self=true,},
			[1715] = {enable=false, self=true,},
			[1160] = {enable=false, self=true,},			
		},
		-- Spell Cooldown Alert / 本職業技能CD區
		["SCDITEMS"] = {
			[6552] = {enable=false,},
			[23922] = {enable=false,},
			[46968] = {enable=false,},
			[107570] = {enable=false,},
			[6343] = {enable=false,},
			[355] = {enable=false,},
			[86346] = {enable=false,},
			[100] = {enable=false,},
			[23920] = {enable=false,},
			[3411] = {enable=false,},
			[18499] = {enable=false,},
			[6544] = {enable=false,},
			[1160] = {enable=false,},
			[55694] = {enable=false,},
			[871] = {enable=false,},
			[12975] = {enable=false,},
			[97462] = {enable=false,},
		},
		-- GroupEvent Alert / 本職業條件技能區
		["GRPITEMS"] = {
		},
	}

--------------------------------------------------------------------------------
-- Monk / 武僧
--------------------------------------------------------------------------------
	EADef_Items[EA_CLASS_MONK] = {
		-- Primary Alert / 本職業提醒區
		["ITEMS"] = {
			[115295] = {enable=true,},
			[120954] = {enable=true,},
			[115308] = {enable=true,},
			[116740] = {enable=true,},
			[125174] = {enable=true,},
			[122783] = {enable=true,},
			[115288] = {enable=true,},
			[116680] = {enable=true,},
			[119085] = {enable=true,},
			
			[125195] = {enable=true, stack=10},
			
			[125359] = {enable=true,},
			[116768] = {enable=true,},
			[118864] = {enable=true,},
			[115307] = {enable=true,},
			[118674] = {enable=true,},
			[127722] = {enable=true,},
			[120273] = {enable=true,},
			
			[115867] = {enable=true, stack=18},		-- 气
			[128939] = {enable=true, stack=12},	-- 飘渺酒
			[118674] = {enable=true, stack=5},	-- 活力之雾
			[115307] = {enable=true, stack=1, self=true, overgrow=1, redsectext=3, },	-- 酒醒淡定
			[125195] = {enable=true},	-- 猛虎之力
		},
		-- Alternate Alert / 本職業額外提醒區
		["ALTITEMS"] = {

		},
		-- Target Alert / 目標提醒區
		["TARITEMS"] = {
			[116330] = {enable=false, self=true,},
			[123725] = {enable=false, self=true,},			
		},
		-- Spell Cooldown Alert / 本職業技能CD區
		["SCDITEMS"] = {
			[115450] = {enable=false,},
			[116705] = {enable=false,},
			[115078] = {enable=false,},
			[115072] = {enable=false,},
			[107428] = {enable=false,},
			[115546] = {enable=false,},
			[124081] = {enable=false,},
			[115098] = {enable=false,},
			[113656] = {enable=false,},
			[123986] = {enable=false,},
			[115295] = {enable=false,},
			[119392] = {enable=false,},
			[116844] = {enable=false,},
			[116680] = {enable=false,},
			[122278] = {enable=false,},
			[101545] = {enable=false,},
			[115288] = {enable=false,},
			[122470] = {enable=false,},
			[115080] = {enable=false,},
			[137562] = {enable=false,},
			[116849] = {enable=false,},
			[123904] = {enable=false,},
		},
		-- GroupEvent Alert / 本職業條件技能區
		["GRPITEMS"] = {
		},
	}


--------------------------------------------------------------------------------
-- Other / 跨職業共通區
--------------------------------------------------------------------------------
	EADef_Items[EA_CLASS_OTHER] = {
		--[17] = {enable=false,},      -- Priest / 牧師 - 真言術:盾
		--[7001] = {enable=false,},    -- Priest / 牧師 - 光束泉恢復
		--[10060] = {enable=true,},   -- Priest - Power Infusion / 牧師 - 注入能量
		--[33206] = {enable=true,},   -- Priest - Pain Suppression / 牧師 - 痛苦鎮壓
		--[81782] = {enable=true,},   -- Priest - 牧師 - 真言術:壁

		--[29166] = {enable=true,},   -- Druid-Innervate / 德魯依-啟動

		[2825] = {enable=true,},    -- Shaman / 薩滿 - 嗜血術
		[80353] = {enable=true,},   -- Mage / 法師 - 時間扭曲
		--[90355] = {enable=true,},   -- Hunter / 獵人 - 上古狂亂

		[128985] = {enable=true,}, 
		[126697] = {enable=true,}, 
		[146343] = {enable=true,}, 
		[138728] = {enable=true,}, 
		[138864] = {enable=true,}, 
		[126646] = {enable=true,}, 
		[126533] = {enable=true,}, 
		[126597] = {enable=true,}, 
		[146245] = {enable=true,}, 
		[146250] = {enable=true,}, 
		[146285] = {enable=true,}, 
		[148899] = {enable=true,}, 
		[146296] = {enable=true,}, 
		[138702] = {enable=true,}, 
		[138759] = {enable=true,}, 
		[138870] = {enable=true,}, 
		[139170] = {enable=true,}, 
		[136084] = {enable=true,}, 
		[126657] = {enable=true,}, 
		[126582] = {enable=true,}, 
		[126599] = {enable=true,}, 
		[129812] = {enable=true,}, 
		[126679] = {enable=true,}, 
		[126700] = {enable=true,}, 
		[136082] = {enable=true,}, 
		[126605] = {enable=true,}, 
		[126683] = {enable=true,}, 
		[126705] = {enable=true,}, 
		[146314] = {enable=true,}, 
		[148908] = {enable=true,}, 
		[148911] = {enable=true,}, 
		[126588] = {enable=true,}, 
		[116660] = {enable=true,}, 
		[120032] = {enable=true,}, 
		[104993] = {enable=true,}, 
		[137593] = {enable=true,}, 
		[137288] = {enable=true,}, 
		[146200] = {enable=true,}, 
	}


end