--=============================================
-- 名称: Revision 
-- 日期: 2010-4-6
-- 描述: 版本信息文件, 不要在别的地方修改或者添加版本信息
-- 作者: dugu
-- 版权所有 (c) duowan.com
--=============================================
local VER;

if (GetLocale() == "zhCN") then
	VER = "6.0.7.6";
else
	VER = "6.0.0.0";
end

function dwGetVersion()
	return VER;
end