 -----------------------------------------------------------------------------
 -- 文件名: dwStaticPop.lua
 -- 日期: 2014-01-08
 -- 作者: dugu@wowbox
 -- 描述: 替换系统的对话框, 以解决无法换天赋的问题
 -- 版权所有 (c) 多玩游戏网
 -----------------------------------------------------------------------------

dwStaticPopup_DisplayedFrames = { }; 
dwStaticPopupDialogs = { };

function dwStaticPopup_FindVisible(which, data)
    local info = dwStaticPopupDialogs[which];
    if ( not info ) then
        return nil;
    end
    for index = 1, STATICPOPUP_NUMDIALOGS, 1 do
        local frame = _G["dwStaticPopup"..index];
        if ( frame:IsShown() and (frame.which == which) and (not info.multiple or (frame.data == data)) ) then
            return frame;
        end
    end
    return nil;
end

local function _RefreshDialogAnchors()
    for index = 1, #dwStaticPopup_DisplayedFrames do
        local current_dialog = dwStaticPopup_DisplayedFrames[index]
        current_dialog:ClearAllPoints()

        if index == 1 then
            local default_dialog = StaticPopup_DisplayedFrames[#StaticPopup_DisplayedFrames]

            if default_dialog then
                current_dialog:SetPoint("TOP", default_dialog, "BOTTOM", 0, 0)
            else
                current_dialog:SetPoint("TOP", UIParent, "TOP", 0, -135)
            end
        else
            current_dialog:SetPoint("TOP", dwStaticPopup_DisplayedFrames[index - 1], "BOTTOM", 0, 0)
        end
    end
end
 
function dwStaticPopup_Resize(dialog, which)
    local info = dwStaticPopupDialogs[which];
    if ( not info ) then
        return nil;
    end
 
    local text = _G[dialog:GetName().."Text"];
    local editBox = _G[dialog:GetName().."EditBox"];
    local button1 = _G[dialog:GetName().."Button1"];
     
    local maxHeightSoFar, maxWidthSoFar = (dialog.maxHeightSoFar or 0), (dialog.maxWidthSoFar or 0);
    local width = 320;
     
    if ( dialog.numButtons == 3 ) then
        width = 440;
    elseif (info.showAlert or info.showAlertGear or info.closeButton) then
        -- Widen
        width = 420;
    elseif ( info.editBoxWidth and info.editBoxWidth > 260 ) then
        width = width + (info.editBoxWidth - 260);
    elseif ( which == "HELP_TICKET" ) then
        width = 350;
    elseif ( which == "GUILD_IMPEACH" ) then
        width = 375;
    end
    if ( width > maxWidthSoFar )  then
        dialog:SetWidth(width);
        dialog.maxWidthSoFar = width;
    end
     
    local height = 32 + text:GetHeight() + 8 + button1:GetHeight();
    if ( info.hasEditBox ) then
        height = height + 8 + editBox:GetHeight();
    elseif ( info.hasMoneyFrame ) then
        height = height + 16;
    elseif ( info.hasMoneyInputFrame ) then
        height = height + 22;
    end
    if ( info.hasItemFrame ) then
        height = height + 64;
    end
 
    if ( height > maxHeightSoFar ) then
        dialog:SetHeight(height);
        dialog.maxHeightSoFar = height;
    end
end
 
local tempButtonLocs = {};  --So we don't make a new table each time.
function dwStaticPopup_Show(which, text_arg1, text_arg2, data)
    local info = dwStaticPopupDialogs[which];
    if ( not info ) then
        return nil;
    end
 
    if ( UnitIsDeadOrGhost("player") and not info.whileDead ) then
        if ( info.OnCancel ) then
            info.OnCancel();
        end
        return nil;
    end
 
    if ( InCinematic() and not info.interruptCinematic ) then
        if ( info.OnCancel ) then
            info.OnCancel();
        end
        return nil;
    end
 
    if ( info.exclusive ) then
        dwStaticPopup_HideExclusive();
    end
 
    if ( info.cancels ) then
        for index = 1, STATICPOPUP_NUMDIALOGS, 1 do
            local frame = _G["dwStaticPopup"..index];
            if ( frame:IsShown() and (frame.which == info.cancels) ) then
                frame:Hide();
                local OnCancel = dwStaticPopupDialogs[frame.which].OnCancel;
                if ( OnCancel ) then
                    OnCancel(frame, frame.data, "override");
                end
            end
        end
    end
 
    -- Pick a free dialog to use
    local dialog = nil;
    -- Find an open dialog of the requested type
    dialog = dwStaticPopup_FindVisible(which, data);
    if ( dialog ) then
        if ( not info.noCancelOnReuse ) then
            local OnCancel = info.OnCancel;
            if ( OnCancel ) then
                OnCancel(dialog, dialog.data, "override");
            end
        end
        dialog:Hide();
    end
    if ( not dialog ) then
        -- Find a free dialog
        local index = 1;
        if ( info.preferredIndex ) then
            index = info.preferredIndex;
        end
        for i = index, STATICPOPUP_NUMDIALOGS do
            local frame = _G["dwStaticPopup"..i];
            if ( not frame:IsShown() ) then
		dialog = frame;
                break;
            end
        end
 
        --If dialog not found and there's a preferredIndex then try to find an available frame before the preferredIndex
        if ( not dialog and info.preferredIndex ) then
            for i = 1, info.preferredIndex do
                local frame = _G["dwStaticPopup"..i];
                if ( not frame:IsShown() ) then
                    dialog = frame;
                    break;
                end
            end
        end
    end
    if ( not dialog ) then
        if ( info.OnCancel ) then
            info.OnCancel();
        end
        return nil;
    end
 
    dialog.maxHeightSoFar, dialog.maxWidthSoFar = 0, 0;
    -- Set the text of the dialog
    local text = _G[dialog:GetName().."Text"];   
    text:SetFormattedText(info.text, text_arg1, text_arg2);   
 
    -- Show or hide the close button
    if ( info.closeButton ) then
        local closeButton = _G[dialog:GetName().."CloseButton"];
        if ( info.closeButtonIsHide ) then
            closeButton:SetNormalTexture("Interface\\Buttons\\UI-Panel-HideButton-Up");
            closeButton:SetPushedTexture("Interface\\Buttons\\UI-Panel-HideButton-Down");
        else
            closeButton:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up");
            closeButton:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down");
        end
        closeButton:Show();
    else
        _G[dialog:GetName().."CloseButton"]:Hide();
    end
 
    -- Set the editbox of the dialog
    local editBox = _G[dialog:GetName().."EditBox"];
    if ( info.hasEditBox ) then
        editBox:Show();
 
        if ( info.maxLetters ) then
            editBox:SetMaxLetters(info.maxLetters);
            editBox:SetCountInvisibleLetters(info.countInvisibleLetters);
        end
        if ( info.maxBytes ) then
            editBox:SetMaxBytes(info.maxBytes);
        end
        editBox:SetText("");
        if ( info.editBoxWidth ) then
            editBox:SetWidth(info.editBoxWidth);
        else
            editBox:SetWidth(130);
        end
    else
        editBox:Hide();
    end
 
    -- Show or hide money frame
    if ( info.hasMoneyFrame ) then
        _G[dialog:GetName().."MoneyFrame"]:Show();
        _G[dialog:GetName().."MoneyInputFrame"]:Hide();
    elseif ( info.hasMoneyInputFrame ) then
        local moneyInputFrame = _G[dialog:GetName().."MoneyInputFrame"];
        moneyInputFrame:Show();
        _G[dialog:GetName().."MoneyFrame"]:Hide();
        -- Set OnEnterPress for money input frames
        if ( info.EditBoxOnEnterPressed ) then
            moneyInputFrame.gold:SetScript("OnEnterPressed", dwStaticPopup_EditBoxOnEnterPressed);
            moneyInputFrame.silver:SetScript("OnEnterPressed", dwStaticPopup_EditBoxOnEnterPressed);
            moneyInputFrame.copper:SetScript("OnEnterPressed", dwStaticPopup_EditBoxOnEnterPressed);
        else
            moneyInputFrame.gold:SetScript("OnEnterPressed", nil);
            moneyInputFrame.silver:SetScript("OnEnterPressed", nil);
            moneyInputFrame.copper:SetScript("OnEnterPressed", nil);
        end
    else
        _G[dialog:GetName().."MoneyFrame"]:Hide();
        _G[dialog:GetName().."MoneyInputFrame"]:Hide();
    end
 
    -- Show or hide item button
    if ( info.hasItemFrame ) then
        _G[dialog:GetName().."ItemFrame"]:Show();
        if ( data and type(data) == "table" ) then
            _G[dialog:GetName().."ItemFrame"].link = data.link
            _G[dialog:GetName().."ItemFrameIconTexture"]:SetTexture(data.texture);
            local nameText = _G[dialog:GetName().."ItemFrameText"];
            nameText:SetTextColor(unpack(data.color or {1, 1, 1, 1}));
            nameText:SetText(data.name);
            if ( data.count and data.count > 1 ) then
                _G[dialog:GetName().."ItemFrameCount"]:SetText(data.count);
                _G[dialog:GetName().."ItemFrameCount"]:Show();
            else
                _G[dialog:GetName().."ItemFrameCount"]:Hide();
            end
        end
    else
        _G[dialog:GetName().."ItemFrame"]:Hide();
    end
 
    -- Set the miscellaneous variables for the dialog
    dialog.which = which;
    dialog.timeleft = info.timeout or 0;
    dialog.hideOnEscape = info.hideOnEscape;
    dialog.exclusive = info.exclusive;
    dialog.enterClicksFirstButton = info.enterClicksFirstButton;
    -- Clear out data
    dialog.data = data;
     
    -- Set the buttons of the dialog
    local button1 = _G[dialog:GetName().."Button1"];
    local button2 = _G[dialog:GetName().."Button2"];
    local button3 = _G[dialog:GetName().."Button3"];
     
    do  --If there is any recursion in this block, we may get errors (tempButtonLocs is static). If you have to recurse, we'll have to create a new table each time.
        assert(#tempButtonLocs == 0);   --If this fails, we're recursing. (See the table.wipe at the end of the block)
         
        tinsert(tempButtonLocs, button1);
        tinsert(tempButtonLocs, button2);
        tinsert(tempButtonLocs, button3);
         
        for i=#tempButtonLocs, 1, -1 do
            --Do this stuff before we move it. (This is why we go back-to-front)
            tempButtonLocs[i]:SetText(info["button"..i]);
            tempButtonLocs[i]:Hide();
            tempButtonLocs[i]:ClearAllPoints();
            --Now we possibly remove it.
            if ( not (info["button"..i] and ( not info["DisplayButton"..i] or info["DisplayButton"..i](dialog))) ) then
                tremove(tempButtonLocs, i);
            end
        end
         
        local numButtons = #tempButtonLocs;
        --Save off the number of buttons.
        dialog.numButtons = numButtons;
         
        if ( numButtons == 3 ) then
            tempButtonLocs[1]:SetPoint("BOTTOMRIGHT", dialog, "BOTTOM", -72, 16);
        elseif ( numButtons == 2 ) then
            tempButtonLocs[1]:SetPoint("BOTTOMRIGHT", dialog, "BOTTOM", -6, 16);
        elseif ( numButtons == 1 ) then
            tempButtonLocs[1]:SetPoint("BOTTOM", dialog, "BOTTOM", 0, 16);
        end
         
        for i=1, numButtons do
            if ( i > 1 ) then
                tempButtonLocs[i]:SetPoint("LEFT", tempButtonLocs[i-1], "RIGHT", 13, 0);
            end
             
            local width = tempButtonLocs[i]:GetTextWidth();
            if ( width > 110 ) then
                tempButtonLocs[i]:SetWidth(width + 20);
            else
                tempButtonLocs[i]:SetWidth(120);
            end
            tempButtonLocs[i]:Enable();
            tempButtonLocs[i]:Show();
        end
         
        table.wipe(tempButtonLocs);
    end
 
    -- Show or hide the alert icon
    local alertIcon = _G[dialog:GetName().."AlertIcon"];
    if ( info.showAlert ) then
        alertIcon:SetTexture(STATICPOPUP_TEXTURE_ALERT);
        if ( button3:IsShown() )then
            alertIcon:SetPoint("LEFT", 24, 10);
        else
            alertIcon:SetPoint("LEFT", 24, 0);
        end
        alertIcon:Show();
    elseif ( info.showAlertGear ) then
        alertIcon:SetTexture(STATICPOPUP_TEXTURE_ALERTGEAR);
        if ( button3:IsShown() )then
            alertIcon:SetPoint("LEFT", 24, 0);
        else
            alertIcon:SetPoint("LEFT", 24, 0);
        end
        alertIcon:Show();
    else
        alertIcon:SetTexture();
        alertIcon:Hide();
    end
 
    if ( info.StartDelay ) then
        dialog.startDelay = info.StartDelay();
        button1:Disable();
    else
        dialog.startDelay = nil;
        button1:Enable();
    end
 
    editBox.autoCompleteParams = info.autoCompleteParams;
    editBox.autoCompleteRegex = info.autoCompleteRegex;
    editBox.autoCompleteFormatRegex = info.autoCompleteFormatRegex;
     
    editBox.addHighlightedText = true;
     
    -- Finally size and show the dialog
    dwStaticPopup_SetUpPosition(dialog);
    dialog:Show();
     
    dwStaticPopup_Resize(dialog, which);
 
    if ( info.sound ) then
        PlaySound(info.sound);
    end
 
    return dialog;
end
 
function dwStaticPopup_Hide(which, data)
    for index = 1, STATICPOPUP_NUMDIALOGS, 1 do
        local dialog = _G["dwStaticPopup"..index];
        if ( dialog:IsShown() and (dialog.which == which) and (not data or (data == dialog.data)) ) then
            dialog:Hide();
        end
    end
end
 
function dwStaticPopup_OnUpdate(dialog, elapsed)
    if ( dialog.timeleft > 0 ) then
        local which = dialog.which;
        local timeleft = dialog.timeleft - elapsed;
        if ( timeleft <= 0 ) then
            if ( not dwStaticPopupDialogs[which].timeoutInformationalOnly ) then
                dialog.timeleft = 0;
                local OnCancel = dwStaticPopupDialogs[which].OnCancel;
                if ( OnCancel ) then
                    OnCancel(dialog, dialog.data, "timeout");
                end
                dialog:Hide();
            end
            return;
        end
        dialog.timeleft = timeleft;
    end
    if ( dialog.startDelay ) then
        local which = dialog.which;
        local timeleft = dialog.startDelay - elapsed;
        if ( timeleft <= 0 ) then
            dialog.startDelay = nil;
            local text = _G[dialog:GetName().."Text"];
            text:SetFormattedText(dwStaticPopupDialogs[which].text, text.text_arg1, text.text_arg2);
            local button1 = _G[dialog:GetName().."Button1"];
            button1:Enable();
            dwStaticPopup_Resize(dialog, which);
            return;
        end
        dialog.startDelay = timeleft;
    end
 
    local onUpdate = dwStaticPopupDialogs[dialog.which].OnUpdate;
    if ( onUpdate ) then
        onUpdate(dialog, elapsed);
    end
end
 
function dwStaticPopup_EditBoxOnEnterPressed(self)
    local EditBoxOnEnterPressed, which, dialog;
    local parent = self:GetParent();
    if ( parent.which ) then
        which = parent.which;
        dialog = parent;
    elseif ( parent:GetParent().which ) then
        -- This is needed if this is a money input frame since it's nested deeper than a normal edit box
        which = parent:GetParent().which;
        dialog = parent:GetParent();
    end
    if ( not self.autoCompleteParams or not AutoCompleteEditBox_OnEnterPressed(self) ) then
        EditBoxOnEnterPressed = dwStaticPopupDialogs[which].EditBoxOnEnterPressed;
        if ( EditBoxOnEnterPressed ) then
            EditBoxOnEnterPressed(self, dialog.data);
        end
    end
end
 
function dwStaticPopup_EditBoxOnEscapePressed(self)
    local EditBoxOnEscapePressed = dwStaticPopupDialogs[self:GetParent().which].EditBoxOnEscapePressed;
    if ( EditBoxOnEscapePressed ) then
        EditBoxOnEscapePressed(self, self:GetParent().data);
    end
end
 
function dwStaticPopup_EditBoxOnTextChanged(self, userInput)
    if ( not self.autoCompleteParams or not AutoCompleteEditBox_OnTextChanged(self, userInput) ) then
        local EditBoxOnTextChanged = dwStaticPopupDialogs[self:GetParent().which].EditBoxOnTextChanged;
        if ( EditBoxOnTextChanged ) then
            EditBoxOnTextChanged(self, self:GetParent().data);
        end
    end
end
 
function dwStaticPopup_OnShow(self)
    PlaySound("igMainMenuOpen");
 
    local dialog = dwStaticPopupDialogs[self.which];
    local OnShow = dialog.OnShow;
 
    if ( OnShow ) then
        OnShow(self, self.data);
    end
    if ( dialog.hasMoneyInputFrame ) then
        _G[self:GetName().."MoneyInputFrameGold"]:SetFocus();
    end
    if ( dialog.enterClicksFirstButton ) then
        self:SetScript("OnKeyDown", dwStaticPopup_OnKeyDown);
    end
end
 
function dwStaticPopup_OnHide(self)
    PlaySound("igMainMenuClose");
 
    dwStaticPopup_CollapseTable();
     
    local dialog = dwStaticPopupDialogs[self.which];
    local OnHide = dialog.OnHide;
    if ( OnHide ) then
        OnHide(self, self.data);
    end
    self.extraFrame:Hide();
    if ( dialog.enterClicksFirstButton ) then
        self:SetScript("OnKeyDown", nil);
    end
end
 
function dwStaticPopup_OnClick(dialog, index)
    if ( not dialog:IsShown() ) then
	print("dwStaticPopup_OnClick", "not dialog:IsShown()")
        return;
    end
    local which = dialog.which;
    local info = dwStaticPopupDialogs[which];
    if ( not info ) then
	print("dwStaticPopup_OnClick", "not info")
        return nil;
    end

    --print("dwStaticPopup_OnClick: index =", index)
    local hide = true;
    if ( index == 1 ) then
        local OnAccept = info.OnAccept;
        if ( OnAccept ) then
            hide = not OnAccept(dialog, dialog.data, dialog.data2);
        end
    elseif ( index == 3 ) then
        local OnAlt = info.OnAlt;
        if ( OnAlt ) then
            OnAlt(dialog, dialog.data, "clicked");
        end
    else
        local OnCancel = info.OnCancel;
        if ( OnCancel ) then
            hide = not OnCancel(dialog, dialog.data, "clicked");
        end
    end
 
    if ( hide and (which == dialog.which) ) then
        -- can dialog.which change inside one of the On* functions???
        dialog:Hide();
    end
end
 
function dwStaticPopup_OnKeyDown(self, key)
    -- previously, dwStaticPopup_EscapePressed() captured the escape key for dialogs, but now we need
    -- to catch it here
    if ( GetBindingFromClick(key) == "TOGGLEGAMEMENU" ) then
        return dwStaticPopup_EscapePressed();
    elseif ( GetBindingFromClick(key) == "SCREENSHOT" ) then
        RunBinding("SCREENSHOT");
        return;
    end
 
    local dialog = dwStaticPopupDialogs[self.which];
    if ( dialog ) then
        if ( key == "ENTER" and dialog.enterClicksFirstButton ) then
            local frameName = self:GetName();
            local button;
            local i = 1;
            while ( true ) do
                button = _G[frameName.."Button"..i];
                if ( button ) then
                    if ( button:IsShown() ) then
                        dwStaticPopup_OnClick(self, i);
                        return;
                    end
                    i = i + 1;
                else
                    break;
                end
            end
        end
    end
end
 
function dwStaticPopup_Visible(which)
    for index = 1, STATICPOPUP_NUMDIALOGS, 1 do
        local frame = _G["dwStaticPopup"..index];
        if( frame:IsShown() and (frame.which == which) ) then
            return frame:GetName(), frame;
        end
    end
    return nil;
end
 
function dwStaticPopup_EscapePressed()
    local closed = nil;
    for _, frame in pairs(dwStaticPopup_DisplayedFrames) do
        if( frame:IsShown() and frame.hideOnEscape ) then
            local standardDialog = dwStaticPopupDialogs[frame.which];
            if ( standardDialog ) then
                local OnCancel = standardDialog.OnCancel;
                local noCancelOnEscape = standardDialog.noCancelOnEscape;
                if ( OnCancel and not noCancelOnEscape) then
                    OnCancel(frame, frame.data, "clicked");
                end
                frame:Hide();
            else
                dwStaticPopupSpecial_Hide(frame);
            end
            closed = 1;
        end
    end
    return closed;
end
 
function dwStaticPopup_SetUpPosition(dialog)
    if ( not tContains(dwStaticPopup_DisplayedFrames, dialog) ) then
        local lastFrame = dwStaticPopup_DisplayedFrames[#dwStaticPopup_DisplayedFrames];
        if ( lastFrame ) then  
            dialog:SetPoint("TOP", lastFrame, "BOTTOM", 0, 0);
        else
            dialog:SetPoint("TOP", UIParent, "TOP", 0, -135);
        end
        tinsert(dwStaticPopup_DisplayedFrames, dialog);
    end
end
 
function dwStaticPopup_CollapseTable()
    local displayedFrames = dwStaticPopup_DisplayedFrames;
    local index = #displayedFrames;
    while ( ( index >= 1 ) and ( not displayedFrames[index]:IsShown() ) ) do
        tremove(displayedFrames, index);
        index = index - 1;
    end
end
 
function dwStaticPopupSpecial_Show(frame)
    if ( frame.exclusive ) then
        dwStaticPopup_HideExclusive();
    end
    dwStaticPopup_SetUpPosition(frame);
    frame:Show();
end
 
function dwStaticPopupSpecial_Hide(frame)
    frame:Hide();
    dwStaticPopup_CollapseTable();
end
 
--Used to figure out if we can resize a frame
function dwStaticPopup_IsLastDisplayedFrame(frame)
    for i=#dwStaticPopup_DisplayedFrames, 1, -1 do
        local popup = dwStaticPopup_DisplayedFrames[i];
        if ( popup:IsShown() ) then
            return frame == popup
        end
    end
    return false;
end
 
function dwStaticPopup_OnEvent(self)
    self.maxHeightSoFar = 0;
    dwStaticPopup_Resize(self, self.which);
end
 
function dwStaticPopup_HideExclusive()
    for _, frame in pairs(dwStaticPopup_DisplayedFrames) do
        if ( frame:IsShown() and frame.exclusive ) then
            local standardDialog = dwStaticPopupDialogs[frame.which];
            if ( standardDialog ) then
                frame:Hide();
                local OnCancel = standardDialog.OnCancel;
                if ( OnCancel ) then
                    OnCancel(frame, frame.data, "override");
                end
            else
                dwStaticPopupSpecial_Hide(frame);
            end
            break;
        end
    end
end

------------------------------
--
hooksecurefunc("StaticPopup_OnHide", function()
        _RefreshDialogAnchors()
end)
hooksecurefunc("StaticPopup_SetUpPosition", function()
        _RefreshDialogAnchors()
end)
hooksecurefunc("StaticPopup_EscapePressed", function()
        dwStaticPopup_EscapePressed()
end)
