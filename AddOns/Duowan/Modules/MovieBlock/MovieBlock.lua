---------------------------------------------------------------------------
-- 文件： MovieBlock.lua
-- 日期： 2012-02-01
-- 描述： 屏蔽过场动画
-- 作者： 盒子哥
-- 感谢： BigWigs
---------------------------------------------------------------------------
local config_enable = true;

local knownMovies = {
	[73] = true, -- Ultraxion death			奥特拉赛恩
	[74] = true, -- DeathwingSpine engage		死亡之翼的脊椎（交战）
	[75] = true, -- DeathwingSpine death		死亡之翼的脊椎（死亡）
	[76] = true, -- DeathwingMadness death		死亡之翼的狂乱
}

local origMovieHandler = MovieFrame:GetScript("OnEvent");
MovieFrame:SetScript("OnEvent", function(frame, event, id, ...)
	if event == "PLAY_MOVIE" and knownMovies[id] and config_enable then
		return MovieFrame_OnMovieFinished(frame);		
	else
		return origMovieHandler(frame, event, id, ...);
	end
end)

function MovieBlock_Toggle(switch)
	if (switch) then
		config_enable = true;
	else
		config_enable = false;
	end
end