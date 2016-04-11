--============================================
-- 名称: PreLoad
-- 日期: 2014-09-06
-- 描述: 提前全局兼容老版本信息
-- 作者: 盒子哥
-- 版权所有 (C) duowan
--============================================


function dwGetMapContinents()
	local mapInfo = {GetMapContinents()};
	local maps = {};
	for i=2, #mapInfo, 2 do
		table.insert(maps, mapInfo[i]);		
	end
	
	return unpack(maps);
end
