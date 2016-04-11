if GetLocale() ~= "zhCN" then return end
local addonName, addonTable = ...
local L = {}
addonTable.L = L
--Translation by cadcamzy@Hotmail.com

-- General Strings
L["GridResizeFrames"] = '框架尺寸'
L["LAYOUT_NAME"] = "框架缩放"
L["AUTO_SIZE"] = "自动调整团框尺寸"
L["AUTO_SIZE_DESC"] = "自动调整团框的宽度/高度尺寸"

-- Options Pane Strings
L["Width"] = "条宽度设置"
L["Height"] = "条高度设置"
L["OPT_DESC"] = "调整每个单元格的宽度/高度尺寸. 你可以为1~8个队时设置不同的尺寸."
L["ONE_GROUP"] = "1队宽度"
L["ONE_GROUP_DESC"] = "自动调整单元格宽度当处于1个队伍时."
L["TWO_GROUP"] = "2队宽度"
L["TWO_GROUP_DESC"] = "自动调整单元格宽度当处于2个队伍时."
L["THREE_GROUP"] = "3队宽度"
L["THREE_GROUP_DESC"] = "自动调整单元格宽度当处于3个队伍时."
L["FOUR_GROUP"] = "4队宽度"
L["FOUR_GROUP_DESC"] = "自动调整单元格宽度当处于4个队伍时."
L["FIVE_GROUP"] = "5队宽度"
L["FIVE_GROUP_DESC"] = "自动调整单元格宽度当处于5个队伍时."
L["SIX_GROUP"] = "6队宽度"
L["SIX_GROUP_DESC"] = "自动调整单元格宽度当处于6个队伍时."
L["SEVEN_GROUP"] = "7队宽度"
L["SEVEN_GROUP_DESC"] = "自动调整单元格宽度当处于7个队伍时."
L["EIGHT_GROUP"] = "8队宽度"
L["EIGHT_GROUP_DESC"] = "自动调整单元格宽度当处于8个队伍时."

L["ONE_GROUP_H"] = "1队高度"
L["ONE_GROUP_DESC_H"] = "自动调整单元格高度当处于1个队伍时."
L["TWO_GROUP_H"] = "2队高度"
L["TWO_GROUP_DESC_H"] = "自动调整单元格高度当处于2个队伍时."
L["THREE_GROUP_H"] = "3队高度"
L["THREE_GROUP_DESC_H"] = "自动调整单元格高度当处于3个队伍时."
L["FOUR_GROUP_H"] = "4队高度"
L["FOUR_GROUP_DESC_H"] = "自动调整单元格高度当处于4个队伍时."
L["FIVE_GROUP_H"] = "5队高度"
L["FIVE_GROUP_DESC_H"] = "自动调整单元格高度当处于5个队伍时."
L["SIX_GROUP_H"] = "6队高度"
L["SIX_GROUP_DESC_H"] = "自动调整单元格高度当处于6个队伍时."
L["SEVEN_GROUP_H"] = "7队高度"
L["SEVEN_GROUP_DESC_H"] = "自动调整单元格高度当处于7个队伍时."
L["EIGHT_GROUP_H"] = "8队高度"
L["EIGHT_GROUP_DESC_H"] = "自动调整单元格高度当处于8个队伍时."

-- Debug Strings
L["DEBUG_INCOMBAT"] = "战斗中，等待更新."
L["DEBUG_LEAVECOMBAT"] = "离开战斗，开始更新.."
L["DEBUG_NOCHANGE"] = "队伍数没变化，无需缩放."
L["DEBUG_CHANGEFROM"] = "改变队伍数从"
L["DEBUG_CHANGETO"] = "到"
L["DEBUG_MAXGROUPS"] = "最大队伍数:"