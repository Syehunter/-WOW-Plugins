
local _, AzerothsTopTunes = ...
local points = AzerothsTopTunes.points
local playerFaction = UnitFactionGroup("player")

-- points[<mapfile>] = { [<coordinates>] = { <quest ID>, <item name>, <notes> } }
--zhCN: cadcamzy at 20150424
--Reference: http://bbs.ngacn.cc/read.php?tid=7878659

----------------------
-- Eastern Kingdoms --
----------------------
if GetLocale() == 'zhCN' or GetLocale() == 'zhTW' then
	points["BlackwingDescent"] = {
		[47377918] = { 38063, "艾泽拉斯传奇", "黑石山团本黑翼血环最终战'奈法利安的末日'有几率掉落." },
	}

	points["BurningSteppes"] = {
		[23242635] = { 38063, "艾泽拉斯传奇", "黑石山团本黑翼血环最终战'奈法利安的末日'有几率掉落." },
	}

	points["DeadwindPass"] = {
		[46927479] = { 38093, "卡拉赞歌剧院", "逆风小径团本卡拉赞'歌剧院'一战有几率掉落." },
	}

	points["Duskwood"] = {
		[23503710] = { 38088, "幽魂的低语", "在暮色森林乌鸦岭墓地死亡后从'Forlorn Composer'处获取，\n到暮色森林西北部的乌鸦岭墓地，自杀(飞高然后下坐骑)，鬼魂形态下跑到墓地东北方，\n找到荒原作曲家向他索要乐谱." },
	}

	points["Karazhan"] = {
		[17713439] = { 38093, "卡拉赞歌剧院 ", "逆风小径团本卡拉赞'歌剧院'一战有几率掉落." },
	}

	points["StranglethornVale"] = {
		[41285134] = { 38087, "天使之歌 ", "荆棘谷海角古拉巴什竞技场PvP区域中央宝箱取得." },
	}

	points["TheCapeOfStranglethorn"] = {
		[46532626] = { 38087, "天使之歌 ", "荆棘谷海角古拉巴什竞技场PvP区域中央宝箱取得." },
	}

	points["Tirisfal"] = {
		[17566754] = { 38096, "精灵龙", "拾取自提瑞斯法林地耳语森林精灵龙事件(18,67)出现时的宝箱." },
		[60148499] = { 38095, "上层精灵的挽歌", "拾取自幽暗城希尔瓦娜斯旁边的'希尔瓦娜斯的重箱'." },
	}

	points["Undercity"] = {
		[58119388] = { 38095, "上层精灵的挽歌", "拾取自幽暗城希尔瓦娜斯旁边的'希尔瓦娜斯的重箱'." },
	}

	if playerFaction == "Alliance" then
		points["DunMorogh"] = {
			[31393804] = { 38081, "工匠镇 ", "在丹莫罗西部副本诺莫瑞根打开[被清洁器包装过的盒子]后取得，从副本小怪或者拍卖行取得一些'脏兮兮的东西'，\n在副本清洁室找到超级清洁器5200，完成可重复任务超级清洁器5200型获得盒子，重复上述步骤直到开出来乐谱."},
			[65802243] = { 38075, "冷山", "在铁炉堡北部荒弃的洞穴钓鱼可得." },
		}

		points["Gnomeregan"] = {
			[64946316] = { 38081, "工匠镇 ", "在丹莫罗西部副本诺莫瑞根打开[被清洁器包装过的盒子]后取得，从副本小怪或者拍卖行取得一些'脏兮兮的东西'，\n在副本清洁室找到超级清洁器5200，完成可重复任务超级清洁器5200型获得盒子，重复上述步骤直到开出来乐谱."},
		}

		points["Ironforge"] = {
			[47001983] = { 38075, "冷山", "在铁炉堡北部荒弃的洞穴钓鱼可得." },
		}

		points["NewTinkertownStart"] = {
			[32503700] = { 38081, "工匠镇 ", "在丹莫罗西部副本诺莫瑞根打开[被清洁器包装过的盒子]后取得，从副本小怪或者拍卖行取得一些'脏兮兮的东西'，\n在副本清洁室找到超级清洁器5200，完成可重复任务超级清洁器5200型获得盒子，重复上述步骤直到开出来乐谱."},
		}
	end

	if playerFaction == "Horde" then
		points["StranglethornVale"][63852180] = { 38080, "祖尔格拉布的巫术", "荆棘谷副本祖尔格拉布最终战'金度'有几率掉落." }
		points["StranglethornJungle"] = {
			[71953290] = { 38080, "祖尔格拉布的巫术", "荆棘谷副本祖尔格拉布最终战'金度'有几率掉落." },
		}
		points["ZulGurub"] = {
			[50933982] = { 38080, "祖尔格拉布的巫术", "荆棘谷副本祖尔格拉布最终战'金度'有几率掉落." },
		}
	end


	--------------
	-- Kalimdor --
	--------------

	points["Ashenvale"] = {
		[56404923] = { 38090, "魔法", "拾取自灰谷林中树居西面一处树洞(56.6,49.5)内宝藏." }
	}

	points["Darnassus"] = {
		[43007600] = { 38100, "沙兰蒂斯岛", "拾取自达纳苏斯月神殿泰兰德正前方的'高阶祭司的圣物'"},
	}

	points["Tanaris"] = {
		[61705195] = { 38066, "毁灭", "巨龙之魂团本最终战'死亡之翼的疯狂'有几率掉落." },
	}

	points["Winterspring"] = {
		[68007390] = { 38089, "远山", "拾取自冬泉谷的'冰冻补给'(68.0, 73.9)." },
	}

	if playerFaction == "Horde" then
		points["Mulgore"] = {
			[35882188] = { 38076, "莫高雷平原", "在雷霆崖预见之池钓鱼可得." },
		}
		points["ThunderBluff"] = {
			[25701640] = { 38076, "莫高雷平原", "在雷霆崖预见之池钓鱼可得." },
		}
	end


	-------------
	-- Outland --
	-------------

	points["ShadowmoonValley"] = {
		[57384968] = { 38091, "黑暗神殿", "拾取自影月谷(外域)守望者牢笼内灰舌死誓者的地道尽头,入口(57,49)." },
		[70994642] = { 38064, "燃烧的远征", "影月谷(外域)团本黑暗神殿,最终战'伊利丹·怒风'有几率掉落" },
	}


	---------------
	-- Northrend --
	---------------

	points["Dragonblight"] = {
		[87335092] = { 38065, "巫妖王之怒", "龙骨荒野东部团本纳克萨玛斯最终战'克尔苏加德'有几率掉落." },
	}

	points["HallsofLightning"] = {
		[19185606] = { 38098, "雷霆之山", "风暴峭壁北部副本闪电大厅'洛肯'有几率掉落(普通可出)." },
	}

	points["IcecrownCitadel"] = {
		[49795290] = { 38092, "无敌", "冰冠冰川南部团本冰冠堡垒最终战'巫妖王'有几率掉落." }
	}

	points["IcecrownGlacier"] = {
		[53838714] = { 38092, "无敌", "冰冠冰川南部团本冰冠堡垒最终战'巫妖王'有几率掉落." }
	}

	points["Naxxramas"] = {
		[36542288] = { 38065, "巫妖王之怒", "龙骨荒野东部团本纳克萨玛斯最终战'克尔苏加德'有几率掉落." },
	}

	points["TheStormPeaks"] = {
		[45292148] = { 38098, "雷霆之山", "风暴峭壁北部副本闪电大厅'洛肯'有几率掉落(普通可出)." },
	}

	if playerFaction == "Alliance" then
		points["IcecrownGlacier"][75951993] = { 38094, "银色锦标赛", "在冰冠冰川东北部银色锦标赛主城军需官处用25个冠军的徽记换得." }
		points["GrizzlyHills"] = {
			[57113318] = { 38097, "灰喉图腾", "在灰熊丘陵找到'雷明顿·布洛德'并对话,依次选择'2-1-3-1(2)'" },
		}
	end

	if playerFaction == "Horde" then
		points["IcecrownGlacier"][75952363] = { 38094, "银色锦标赛", "在冰冠冰川东北部银色锦标赛主城军需官处用25个冠军的徽记换得." }
		points["GrizzlyHills"] = {
			[22026934] = { 38097, "灰喉图腾", "在灰熊丘陵找到'雷明顿·布洛德'并对话,依次选择'2-1-3-1(2)'" },
		}
	end


	---------------
	-- Cataclysm --
	---------------

	points["DarkmoonFaireIsland"] = {
		[51507505] = { 38099, "暗月旋转木马", "暗月马戏团到来时在切斯特(51.2,75.0)处用90个暗月奖券购买." }
	}
	--------------
	-- Pandaria --
	--------------

	points["TheHiddenPass"] = {
		[48486149] = { 38067, "潘达利亚之心", "雾纱栈道团本永春台最终战'惧之煞'有几率掉落(随机团队也可)." },
	}

	points["TerraceOfEndlessSpring"] = {
		[38914829] = { 38067, "潘达利亚之心", "雾纱栈道团本永春台最终战'惧之煞'有几率掉落(随机团队也可)." },
	}

	points["ValeofEternalBlossoms"] = {
		[82222928] = { 38102, "刘浪之歌", "锦绣谷闻道之座谭欣眺处花费80金币购买,需要游学者-崇敬." },
	}

	if playerFaction == "Alliance" then
		points["Krasarang"] = {
			[89533354] = { 38071, "远洋", "在雄狮港(89.6,33.4)用500个[统御岗哨委任状]购买." },
		}
	end

	if playerFaction == "Horde" then
		points["Krasarang"] = {
			[10605360] = { 38072, "战争步伐", "在统御岗哨(10.6,53.6)用500个[雄狮港委任状]购买." },
		}
	end


	-------------
	-- Draenor --
	-------------

	points["FoundryRaid"] = {
		[48363460] = { 38068, "倾世之战", "戈尔隆德北部团本黑石铸造厂最终战'黑手'有几率掉落." },
	}

	points["Gorgrond"] = {
		[51562724] = { 38068, "倾世之战", "戈尔隆德北部团本黑石铸造厂最终战'黑手'有几率掉落." },
	}
else

	points["BlackwingDescent"] = {
		[47377918] = { 38063, "Legends of Azeroth", "Defeat Nefarian.\nThis is NOT a guaranteed drop." },
	}

	points["BurningSteppes"] = {
		[23242635] = { 38063, "Legends of Azeroth", "Inside the Blackwing Descent raid.\n\nDefeat Nefarian.\nThis is NOT a guaranteed drop." },
	}

	points["DeadwindPass"] = {
		[46927479] = { 38093, "Karazhan Opera House", "Inside the Karazhan raid.\n\nComplete the Opera House event.\nThis is NOT a guaranteed drop." },
	}

	points["Duskwood"] = {
		[23503710] = { 38088, "Ghost", "Kill yourself somehow, then speak to the Forlorn Composer." },
	}

	points["Karazhan"] = {
		[17713439] = { 38093, "Karazhan Opera House", "Inside the Karazhan raid.\n\nComplete the Opera House event.\nThis is NOT a guaranteed drop." },
	}

	points["StranglethornVale"] = {
		[41285134] = { 38087, "Angelic", "Loot the Arena Master Chest in the center of the Gurubashi Battle Ring.\nOnly available once every four hours." },
	}

	points["TheCapeOfStranglethorn"] = {
		[46532626] = { 38087, "Angelic", "Loot the Arena Master Chest in the center of the Gurubashi Battle Ring.\nOnly available once every four hours." },
	}

	points["Tirisfal"] = {
		[17566754] = { 38096, "Faerie Dragon", "Loot the Faerie Dragon Nest in the center of the mushroom circle.\nOnly available while the Fey-Drunk Darters are casting their spell." },
		[60148499] = { 38095, "Lament of the Highborne", "Inside Undercity.\n\nLoot the strongbox at the base of a pillar to the left of Sylvannas Windrunner." },
	}

	points["Undercity"] = {
		[58119388] = { 38095, "Lament of the Highborne", "Loot the strongbox at the base of a pillar to the left of Sylvannas Windrunner." },
	}

	if playerFaction == "Alliance" then
		points["DunMorogh"] = {
			[31393804] = { 38081, "Tinkertown", "Inside the Gnomeregan dungeon.\n\nKill mobs for [Grime-Encrusted Object], clean them at the Sparkle-Matic 5200 and open the box it gives you.\nThis is NOT a guaranteed drop." },
			[65802243] = { 38075, "Cold Mountain", "Inside Ironforge.\n\nGo fishing for a bit in the Folorn Cavern." },
		}

		points["Gnomeregan"] = {
			[64946316] = { 38081, "Tinkertown", "Kill mobs for [Grime-Encrusted Object], clean them at the Sparkle-Matic 5200 and open the box it gives you.\nThis is NOT a guaranteed drop." },
		}

		points["Ironforge"] = {
			[47001983] = { 38075, "Cold Mountain", "Go fishing for a bit in the Folorn Cavern." },
		}

		points["NewTinkertownStart"] = {
			[32503700] = { 38081, "Tinkertown", "Inside the Gnomeregan dungeon.\n\nKill mobs for [Grime-Encrusted Object], clean them at the Sparkle-Matic 5200 and open the box it gives you.\nThis is NOT a guaranteed drop." },
		}
	end

	if playerFaction == "Horde" then
		points["StranglethornVale"][63852180] = { 38080, "Zul'Gurub Voo Doo", "Inside the Zul'Gurub dungeon.\n\nDefeat Jin'do the Godbreaker.\nThis is NOT a guaranteed drop." }
		points["StranglethornJungle"] = {
			[71953290] = { 38080, "Zul'Gurub Voo Doo", "Inside the Zul'Gurub dungeon.\n\nDefeat Jin'do the Godbreaker.\nThis is NOT a guaranteed drop." },
		}
		points["ZulGurub"] = {
			[50933982] = { 38080, "Zul'Gurub Voo Doo", "Defeat Jin'do the Godbreaker.\nThis is NOT a guaranteed drop." },
		}
	end


	--------------
	-- Kalimdor --
	--------------

	points["Ashenvale"] = {
		[56404923] = { 38090, "Magic", "Loot the Lost Sentinel's Pouch inside a large hollow tree trunk." }
	}

	points["Darnassus"] = {
		[43007600] = { 38100, "Shalandis Isle", "Loot the chest on the top floor of the Temple of the Moon,\non the wall opposite Tyrande Whisperwind." },
	}

	points["Tanaris"] = {
		[61705195] = { 38066, "The Shattering", "Inside the Dragon Soul raid.\n\nDefeat Madness of Deathwing.\nThis is NOT a guaranteed drop." },
	}

	points["Winterspring"] = {
		[68007390] = { 38089, "Mountains", "Loot the Frozen Supplies in a nook at the base of the pillar." },
	}

	if playerFaction == "Horde" then
		points["Mulgore"] = {
			[35882188] = { 38076, "Mulgore Plains", "Inside Thunder Bluff.\n\nGo fishing for a bit in the Pools of Vision\nbeneath the Spirit Rise." },
		}
		points["ThunderBluff"] = {
			[25701640] = { 38076, "Mulgore Plains", "Go fishing for a bit in the Pools of Vision\nbeneath the Spirit Rise." },
		}
	end


	-------------
	-- Outland --
	-------------

	points["ShadowmoonValley"] = {
		[57384968] = { 38091, "The Black Temple", "Loot the Warden's Scrollcase inside the Warden's Cage." },
		[70994642] = { 38064, "The Burning Legion", "Inside the Black Temple raid.\n\nDefeat Illidan.\nThis is NOT a guaranteed drop." },
	}


	---------------
	-- Northrend --
	---------------

	points["Dragonblight"] = {
		[87335092] = { 38065, "Wrath of the Lich King", "Inside the Naxxramas raid.\n\nDefeat Kel'Thuzad.\nThis is NOT a guaranteed drop." },
	}

	points["HallsofLightning"] = {
		[19185606] = { 38098, "Mountains of Thunder", "Defeat Loken on Heroic difficulty.\nThis is NOT a guaranteed drop." },
	}

	points["IcecrownCitadel"] = {
		[49795290] = { 38092, "Invincible", "Defeat The Lich King.\nThis is NOT a guaranteed drop." }
	}

	points["IcecrownGlacier"] = {
		[53838714] = { 38092, "Invincible", "Inside the Icecrown Citadel raid.\n\nDefeat The Lich King.\nThis is NOT a guaranteed drop." }
	}

	points["Naxxramas"] = {
		[36542288] = { 38065, "Wrath of the Lich King", "Defeat Kel'Thuzad.\nThis is NOT a guaranteed drop." },
	}

	points["TheStormPeaks"] = {
		[45292148] = { 38098, "Mountains of Thunder", "Inside the Halls of Lightning dungeon.\n\nDefeat Loken on Heroic difficulty.\nThis is NOT a guaranteed drop." },
	}

	if playerFaction == "Alliance" then
		points["IcecrownGlacier"][75951993] = { 38094, "The Argent Tournament", "Purchased from any city quartermaster for 25 [Champion's Seal]." }
		points["GrizzlyHills"] = {
			[57113318] = { 38097, "Totems of the Grizzlemaw", "Speak to Remington Brode, who patrols all over Grizzly Hills.\nHe starts at Amberpine Lodge, follows the road counter-clockwise to Conquest Hold,\nthen north to Westfall Brigade Encampment, and then south to Camp Oneqwah.\n\nWhen you find him select \"<Breathe deeply.>\",\"I'm looking for a song...\",\n\"A song about the wilderness.\", and \"Yes!\"" },
		}
	end

	if playerFaction == "Horde" then
		points["IcecrownGlacier"][75952363] = { 38094, "The Argent Tournament", "Purchased from any city quartermaster for 25 [Champion's Seal]." }
		points["GrizzlyHills"] = {
			[22026934] = { 38097, "Totems of the Grizzlemaw", "Speak to Remington Brode, who patrols all over Grizzly Hills.\nHe starts at Amberpine Lodge, follows the road counter-clockwise to Conquest Hold,\nthen north to Westfall Brigade Encampment, and then south to Camp Oneqwah.\n\nWhen you find him select \"<Breathe deeply.>\",\"I'm looking for a song...\",\n\"A song about the wilderness.\", and \"Yes!\"" },
		}
	end


	---------------
	-- Cataclysm --
	---------------
	points["DarkmoonFaireIsland"] = {
		[51507505] = { 38099, "Darkmoon Carousel", "Purchased from Chester for 90 [Darkmoon Prize Ticket]." }
	}

	--------------
	-- Pandaria --
	--------------

	points["TheHiddenPass"] = {
		[48486149] = { 38067, "Heart of Pandaria", "Inside the Terrace of Endless Spring raid.\n\nDefeat Sha of Fear.\nThis is NOT a guaranteed drop." },
	}

	points["TerraceOfEndlessSpring"] = {
		[38914829] = { 38067, "Heart of Pandaria", "Defeat Sha of Fear.\nThis is NOT a guaranteed drop." },
	}

	points["ValeofEternalBlossoms"] = {
		[82222928] = { 38102, "Song of Liu Lang", "Purchased from Tan Shin Tiao for 100 gold.\nRequires Revered with The Lorewalkers." },
	}

	if playerFaction == "Alliance" then
		points["Krasarang"] = {
			[89533354] = { 38071, "High Seas", "Purchased from Proveditor Grantley for 500 [Domination Point Commission]." },
		}
	end

	if playerFaction == "Horde" then
		points["Krasarang"] = {
			[10605360] = { 38072, "War March", "Purchased from Ongrom Black Tooth for 500 [Lion's Landing Commission]." },
		}
	end


	-------------
	-- Draenor --
	-------------

	points["FoundryRaid"] = {
		[48363460] = { 38068, "A Siege of Worlds", "Defeat Blackhand.\nThis is NOT a guaranteed drop." },
	}

	points["Gorgrond"] = {
		[51562724] = { 38068, "A Siege of Worlds", "Inside the Blackrock Foundry raid.\n\nDefeat Blackhand.\nThis is NOT a guaranteed drop." },
	}
end