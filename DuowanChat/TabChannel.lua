-------------------------------------------------------------------------------
-- TabChannel ver.1.0
-- 日期: 2010-11-23
-- 作者: 独孤傲雪
-- 描述: 使用Tab键在说、队友、团队、战场、公会频道间便捷的切换
-- 版权所有 (c) duowan.com
-------------------------------------------------------------------------------

local function dw_ChatEdit_CustomTabPressed(self)
  if (self:GetAttribute("chatType") == "SAY")  then 
      if (GetNumSubgroupMembers()>0) then 
         self:SetAttribute("chatType", "PARTY"); 
         ChatEdit_UpdateHeader(self); 
      elseif (IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and IsInInstance()) then 
         self:SetAttribute("chatType", "INSTANCE_CHAT"); 
         ChatEdit_UpdateHeader(self); 
      elseif (GetNumGroupMembers()>0 and IsInRaid()) then 
         self:SetAttribute("chatType", "RAID"); 
         ChatEdit_UpdateHeader(self); 
      elseif (IsInGuild()) then 
         self:SetAttribute("chatType", "GUILD"); 
         ChatEdit_UpdateHeader(self); 
      elseif (CanEditOfficerNote()) then 
         self:SetAttribute("chatType", "OFFICER"); 
         ChatEdit_UpdateHeader(self); 
      else 
         return; 
      end 
   elseif (self:GetAttribute("chatType") == "PARTY") then 
         if (IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and IsInInstance())  then 
         self:SetAttribute("chatType", "INSTANCE_CHAT"); 
              ChatEdit_UpdateHeader(self); 
        elseif (GetNumGroupMembers()>0 and IsInRaid() ) then 
              self:SetAttribute("chatType", "RAID"); 
              ChatEdit_UpdateHeader(self); 
        elseif (IsInGuild()) then 
              self:SetAttribute("chatType", "GUILD"); 
              ChatEdit_UpdateHeader(self); 
         elseif (CanEditOfficerNote()) then 
              self:SetAttribute("chatType", "OFFICER"); 
              ChatEdit_UpdateHeader(self); 
      else 
         self:SetAttribute("chatType", "SAY"); 
         ChatEdit_UpdateHeader(self); 
      end         
   elseif (self:GetAttribute("chatType") == "INSTANCE_CHAT") then 
      if (IsInGuild()) then 
         self:SetAttribute("chatType", "GUILD"); 
         ChatEdit_UpdateHeader(self); 
      elseif (CanEditOfficerNote()) then 
         self:SetAttribute("chatType", "OFFICER"); 
         ChatEdit_UpdateHeader(self); 
      else 
         self:SetAttribute("chatType", "SAY"); 
         ChatEdit_UpdateHeader(self); 
      end 
   elseif (self:GetAttribute("chatType") == "RAID") then 
      if (IsInGuild) then 
         self:SetAttribute("chatType", "GUILD"); 
         ChatEdit_UpdateHeader(self); 
      elseif (CanEditOfficerNote()) then 
         self:SetAttribute("chatType", "OFFICER"); 
         ChatEdit_UpdateHeader(self); 
      else 
         self:SetAttribute("chatType", "SAY"); 
         ChatEdit_UpdateHeader(self); 
      end 
   elseif (self:GetAttribute("chatType") == "GUILD") then 
      if (CanEditOfficerNote()) then 
         self:SetAttribute("chatType", "OFFICER"); 
         ChatEdit_UpdateHeader(self); 
      else 
          self:SetAttribute("chatType", "SAY"); 
          ChatEdit_UpdateHeader(self); 
      end 
   elseif (self:GetAttribute("chatType") == "OFFICER") then 
       self:SetAttribute("chatType", "SAY"); 
       ChatEdit_UpdateHeader(self); 
--密语切换开始 不需要的请从这删除 
--   elseif (self:GetAttribute("chatType") == "WHISPER") then 
--       self:SetAttribute("chatType", "SAY"); 
--       ChatEdit_UpdateHeader(self); 
--密语切换结束 删除到这里 
   elseif (self:GetAttribute("chatType") == "CHANNEL") then 
      if (GetNumSubgroupMembers()>0) then 
         self:SetAttribute("chatType", "PARTY"); 
         ChatEdit_UpdateHeader(self); 
      elseif (IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and IsInInstance())  then 
         self:SetAttribute("chatType", "INSTANCE_CHAT"); 
         ChatEdit_UpdateHeader(self); 
      elseif (GetNumGroupMembers()>0 and IsInRaid() ) then 
         self:SetAttribute("chatType", "RAID"); 
         ChatEdit_UpdateHeader(self); 
      elseif (IsInGuild()) then 
         self:SetAttribute("chatType", "GUILD"); 
         ChatEdit_UpdateHeader(self); 
      elseif (CanEditOfficerNote()) then 
         self:SetAttribute("chatType", "OFFICER"); 
         ChatEdit_UpdateHeader(self); 
      else 
         self:SetAttribute("chatType", "SAY"); 
         ChatEdit_UpdateHeader(self); 
      end 
   end 
end

--hooksecurefunc("ChatEdit_CustomTabPressed", dw_ChatEdit_CustomTabPressed);
hooksecurefunc("ChatEdit_OnTabPressed", dw_ChatEdit_CustomTabPressed);
