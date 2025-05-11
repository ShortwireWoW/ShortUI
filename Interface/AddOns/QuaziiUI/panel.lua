local L = QuaziiUI.L

-- Page Functions
---@param parentFrame table|Frame
local function createPages(parentFrame)
    local pageCount = 0
    for _, page in ipairs(QuaziiUI.pages) do
        pageCount = pageCount + 1
        page:Create(parentFrame)
    end
    QuaziiUI:DebugPrint("Pages Created:", pageCount)
end

---@param pageIndex integer
function QuaziiUI:selectPage(pageIndex)
    self.db.char.selectedPage = pageIndex
    self.db.char.shownPages = 0

    QuaziiUI:DebugPrint("Selected Page:", pageIndex)
    for _, page in ipairs(self.pages) do
        if not page:ShouldShow() then
            page:Hide()
        else
            self.db.char.shownPages = self.db.char.shownPages + 1
            if self.db.char.shownPages == pageIndex then
                self.db.char.openPage = pageIndex
                page:Show()
            else
                page:Hide()
            end
        end
    end
end

local function selectNextPage()
    if ((QuaziiUI.db.char.selectedPage or 0) < QuaziiUI.db.char.shownPages) then -- If selectedPage is less than total pages
        QuaziiUI.db.char.openPage = QuaziiUI.db.char.selectedPage + 1
        QuaziiUI:selectPage(QuaziiUI.db.char.openPage) -- Show next page
    else -- If last page or higher
        QuaziiUI.panel:Hide() -- Hide installer UI
        QuaziiUI.db.global.isDone = true -- Set done as true
        ReloadUI() -- reload UI
    end
    QuaziiUI.db.char.openPage = nil
end

local function selectIndexPage()
    QuaziiUI.db.char.openPage = 2
    QuaziiUI:selectPage(2)
end

local function selectPreviousPage()
    if QuaziiUI.db.char.selectedPage > 1 then
        QuaziiUI.db.char.openPage = QuaziiUI.db.char.selectedPage - 1
        QuaziiUI:selectPage(QuaziiUI.db.char.openPage)
    end
end

-- Frame Template Functions
---@param parentPanel table|Frame
---@param addonName string
---@param importLabel string
---@param importFunction function
---@return table|Frame
function QuaziiUI:CreateImportFrame(parentPanel, addonName, importLabel, importFunction)
    local frame = CreateFrame("Frame", nil, parentPanel)
    frame:SetHeight(60)
    
    local profileText = self.DF:CreateLabel(frame, "", self.TableHeaderSize)
    profileText:SetFont(QuaziiUI.FontFace, QuaziiUI.TableHeaderSize)
    profileText:SetPoint("TOPLEFT", frame, "TOPLEFT")

    -- Button Template
    local importProfileButton =
        self.DF:CreateButton(frame, importFunction, 90, 25, L["Import"], nil, nil, nil, nil, nil, nil, self.ODT)
    importProfileButton:SetPoint("LEFT", profileText, "RIGHT", 10) -- Attach Button to profileText Label
    importProfileButton.text_overlay:SetFont(QuaziiUI.FontFace, self.TableTextSize) -- Set Button Font Size

    local lastImportLabel = self.DF:CreateLabel(frame, L["ImportLastImportText"], self.TableTextSize)
    lastImportLabel:SetFont(QuaziiUI.FontFace, QuaziiUI.TableTextSize)
    lastImportLabel:SetPoint("TOPRIGHT", profileText, "BOTTOMRIGHT", 0, -3)
    local versionLabel = self.DF:CreateLabel(frame, L["Version"] .. ": ", self.TableTextSize)
    versionLabel:SetFont(QuaziiUI.FontFace, QuaziiUI.TableTextSize)
    versionLabel:SetPoint("TOPRIGHT", lastImportLabel, "BOTTOMRIGHT", 4, -3)

    local lastImportText = self.DF:CreateLabel(frame, "", self.TableTextSize)
    lastImportText:SetFont(QuaziiUI.FontFace, QuaziiUI.TableTextSize)
    lastImportText:SetPoint("LEFT", lastImportLabel, "RIGHT", 10, 0)
    local versionText = self.DF:CreateLabel(frame, "", self.TableTextSize)
    versionText:SetFont(QuaziiUI.FontFace, QuaziiUI.TableTextSize)
    versionText:SetPoint("LEFT", versionLabel, "RIGHT", 6, 0)

    local function update()
        local addonLoaded = C_AddOns and C_AddOns.IsAddOnLoaded(addonName)
        local addonRealName = addonLoaded and select(2, C_AddOns and C_AddOns.GetAddOnInfo(addonName)) or addonName

        local updateLabel = addonRealName

        if not importLabel ~= nil then
            updateLabel = importLabel
        end

        profileText:SetText("|c" .. self.highlightColorHex .. updateLabel .. L["ImportProfileText"] .. "|r")
        frame:SetWidth(profileText:GetStringWidth() + 100)

        if (not addonLoaded) then
            importProfileButton:Disable()
            importProfileButton:SetText(L["NA"])
        else
            importProfileButton:Enable()
            importProfileButton:SetText(L["Import"])
        end
        importProfileButton:SetWidth(importProfileButton.button.text:GetStringWidth() + 10)
    end

    frame:SetScript("OnShow", update)

    frame.lastImportText = lastImportText
    frame.versionText = versionText

    return frame
end

-- Create Main UI Frame
local function createPanel()
    -- Init panel

    local panel = QuaziiUI.DF:CreateSimplePanel(UIParent, 600, 500, L["AddonName"], "QuaziiUIMainPanel") -- Create a 600x500 panel
    QuaziiUI.DF:ApplyStandardBackdrop(panel) -- Give it a basic backdrop

    local versionLabel = QuaziiUI.DF:CreateLabel(panel.TitleBar, QuaziiUI.versionString, 14)
    versionLabel:SetTextColor(unpack({0.439216, 0.501961, 0.564706, 1}))
    versionLabel:SetPoint("LEFT", panel.TitleBar, "LEFT", 2, 1)

    -- Panel Border
    QuaziiUI.DF:CreateBorder(panel) -- Give it a border
    panel:SetBorderColor(unpack(QuaziiUI.highlightColorRGBA)) -- Sets border color to Quazii Blue RGBA

    -- Panel Title Bar
    panel.Title:SetFont(QuaziiUI.FontFace, 18) -- Set Title Font Size to 18
    panel.Title:SetTextColor(unpack(QuaziiUI.textColorRGBA)) -- Set Text Color
    panel.Title:SetPoint("CENTER", panel.TitleBar, "CENTER", 0, 1) -- Center Title Text in the Title Bar, offset 1 Y pixel

    -- Panel Options
    panel:ClearAllPoints() -- Resets Panel Anchor point
    panel:SetPoint("CENTER", UIParent, "CENTER") -- Centers Panel on Screen
    panel:SetFrameStrata("DIALOG") -- We use Dialog to ensure it is above most other elements
    panel:SetFrameLevel(100) -- Same as above line
    panel:SetLayerVisibility(true, false, false) -- DFramework Layer Visibilty options, we only use layer 1, so others are set to false

    -- Previous Button
    local previousButton =
        QuaziiUI.DF:CreateButton(
        panel,
        selectPreviousPage,
        90,
        40,
        "<- " .. L["Back"],
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        QuaziiUI.ODT
    )
    previousButton:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 10, 5) -- Anchor Button to Bottom Left of Panel, with 5 pixel buffer
    previousButton.text_overlay:SetFont(QuaziiUI.FontFace, 18) -- Set Font Size
    previousButton:SetTextColor(unpack(QuaziiUI.textColorRGBA)) -- Set Text to Text Color

    -- Index Button
    local indexButton =
        QuaziiUI.DF:CreateButton(
        panel,
        selectIndexPage,
        90,
        40,
        "- " .. L["Index"] .. " -",
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        QuaziiUI.ODT
    )
    indexButton:SetPoint("BOTTOM", panel, "BOTTOM", 0, 5) -- Anchor Button to Bottom Left of Panel, with 5 pixel buffer
    indexButton.text_overlay:SetFont(QuaziiUI.FontFace, 18) -- Set Font Size
    indexButton:SetTextColor(unpack(QuaziiUI.textColorRGBA)) -- Set Text to Text Color

    -- Next Button
    local nextButton =
        QuaziiUI.DF:CreateButton(
        panel,
        selectNextPage,
        90,
        40,
        L["Next"] .. " ->",
        nil,
        nil,
        nil,
        nil,
        nil,
        nil,
        QuaziiUI.ODT
    )
    nextButton:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -10, 5) -- Anchor Button to Bottom Right of Panel, with 5 pixel buffer
    nextButton.text_overlay:SetFont(QuaziiUI.FontFace, 18) -- Set Font Size
    nextButton:SetTextColor(unpack(QuaziiUI.textColorRGBA)) -- Set Text to Text Color

    -- Panel Content Frame
    local panelContentFrame = CreateFrame("Frame", nil, panel)
    panelContentFrame:SetPoint("TOPLEFT", panel.TitleBar, "BOTTOMLEFT", 0, -5) -- Set Top Left anchor to Bottom Left anchor of TitleBar, with 5px buffer
    panelContentFrame:SetPoint("TOPRIGHT", panel.TitleBar, "BOTTOMRIGHT", 0, -5) -- Above but for Top Right / Bottom Right
    panelContentFrame:SetPoint("BOTTOMLEFT", panel, "BOTTOMLEFT", 0, 48) -- Set Bottom Left Anchor to Bottom Left anchor of panel, with 48px buffer for buttons
    panelContentFrame:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", 0, 48) -- Above for Bottom Right

    panel:HookScript("OnHide", function()
        QuaziiUI:Hide()
        QuaziiUI:DebugPrint("Set isDone to " .. tostring(QuaziiUI.db.global.isDone))
    end)

    panel.frameContent = panelContentFrame
    QuaziiUI.panel = panel


    createPages(panel)
end

createPanel()
