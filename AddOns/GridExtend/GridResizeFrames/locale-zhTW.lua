if GetLocale() ~= "zhTW" then return end
local addonName, addonTable = ...
local L = {}
addonTable.L = L
--Translation by cadcamzy@Hotmail.com

-- General Strings
L["GridResizeFrames"] = '框架尺寸'
L["LAYOUT_NAME"] = "框架縮放"
L["AUTO_SIZE"] = "自動調整團框尺寸"
L["AUTO_SIZE_DESC"] = "自動調整團框的寬度/高度尺寸"

-- Options Pane Strings
L["Width"] = "條寬度設置"
L["Height"] = "條高度設置"
L["OPT_DESC"] = "調整每個單元格的寬度/高度尺寸. 你可以為1~8個隊時設置不同的尺寸."
L["ONE_GROUP"] = "1隊寬度"
L["ONE_GROUP_DESC"] = "自動調整單元格寬度當處於1個隊伍時."
L["TWO_GROUP"] = "2隊寬度"
L["TWO_GROUP_DESC"] = "自動調整單元格寬度當處於2個隊伍時."
L["THREE_GROUP"] = "3隊寬度"
L["THREE_GROUP_DESC"] = "自動調整單元格寬度當處於3個隊伍時."
L["FOUR_GROUP"] = "4隊寬度"
L["FOUR_GROUP_DESC"] = "自動調整單元格寬度當處於4個隊伍時."
L["FIVE_GROUP"] = "5隊寬度"
L["FIVE_GROUP_DESC"] = "自動調整單元格寬度當處於5個隊伍時."
L["SIX_GROUP"] = "6隊寬度"
L["SIX_GROUP_DESC"] = "自動調整單元格寬度當處於6個隊伍時."
L["SEVEN_GROUP"] = "7隊寬度"
L["SEVEN_GROUP_DESC"] = "自動調整單元格寬度當處於7個隊伍時."
L["EIGHT_GROUP"] = "8隊寬度"
L["EIGHT_GROUP_DESC"] = "自動調整單元格寬度當處於8個隊伍時."

L["ONE_GROUP_H"] = "1隊高度"
L["ONE_GROUP_DESC_H"] = "自動調整單元格高度當處於1個隊伍時."
L["TWO_GROUP_H"] = "2隊高度"
L["TWO_GROUP_DESC_H"] = "自動調整單元格高度當處於2個隊伍時."
L["THREE_GROUP_H"] = "3隊高度"
L["THREE_GROUP_DESC_H"] = "自動調整單元格高度當處於3個隊伍時."
L["FOUR_GROUP_H"] = "4隊高度"
L["FOUR_GROUP_DESC_H"] = "自動調整單元格高度當處於4個隊伍時."
L["FIVE_GROUP_H"] = "5隊高度"
L["FIVE_GROUP_DESC_H"] = "自動調整單元格高度當處於5個隊伍時."
L["SIX_GROUP_H"] = "6隊高度"
L["SIX_GROUP_DESC_H"] = "自動調整單元格高度當處於6個隊伍時."
L["SEVEN_GROUP_H"] = "7隊高度"
L["SEVEN_GROUP_DESC_H"] = "自動調整單元格高度當處於7個隊伍時."
L["EIGHT_GROUP_H"] = "8隊高度"
L["EIGHT_GROUP_DESC_H"] = "自動調整單元格高度當處於8個隊伍時."

-- Debug Strings
L["DEBUG_INCOMBAT"] = "戰鬥中，等待更新."
L["DEBUG_LEAVECOMBAT"] = "離開戰鬥，開始更新.."
L["DEBUG_NOCHANGE"] = "隊伍數沒變化，無需縮放."
L["DEBUG_CHANGEFROM"] = "改變隊伍數從"
L["DEBUG_CHANGETO"] = "到"
L["DEBUG_MAXGROUPS"] = "最大隊伍數:"
