
local _, T = ...;
local D = T.Dcr;

function T._SelfDiagnostic() return 0 end

function D:ColorPrint () end

function D:Println() end

function D:VersionWarnings() end

if (GetLocale() == "zhCN") then
	BINDING_HEADER_DECURSIVE = "一键驱散";
elseif (GetLocale() == "zhTW") then
	BINDING_HEADER_DECURSIVE = "一鍵驅散";
else
	BINDING_HEADER_DECURSIVE = "Decursive";
end