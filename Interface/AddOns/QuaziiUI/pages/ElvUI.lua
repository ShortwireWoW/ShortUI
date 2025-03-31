local L = QuaziiUI.L

local page = {}
table.insert(QuaziiUI.pages, page)

-- Helper Functions
local function updateElvUIDisplay()
    local function updateImportInfo(importType, dateField, versionField)
        if QuaziiUI.db.global and QuaziiUI.db.global.imports and QuaziiUI.db.global.imports[importType] then
            page[dateField]:SetText(date("%m/%d/%y", QuaziiUI.db.global.imports[importType].date))
            page[versionField]:SetText(QuaziiUI.db.global.imports[importType].version)
        else
            page[dateField]:SetText(L["NA"])
            page[versionField]:SetText(L["NA"])
        end
    end

    updateImportInfo("healer", "lastHImportTime", "lastHVersion")
    updateImportInfo("cell", "lastCImportTime", "lastCVersion")
    updateImportInfo("tankdps", "lastTImportTime", "lastTVersion")
end

local function updateScaleDisplay()
    local currentUIScale
    if C_AddOns and C_AddOns.IsAddOnLoaded("ElvUI") then
        currentUIScale = ElvUI[1].global.general.UIScale
    else
        currentUIScale = C_CVar.GetCVar("uiScale")
    end
    page.uiScaleText:SetText("|c" .. QuaziiUI.highlightColorHex .. tostring(currentUIScale) .. "|r")
end

local function updateUIScale(scale)
    if C_AddOns and C_AddOns.IsAddOnLoaded("ElvUI") then
        local Elv = ElvUI[1]
        Elv.global.general.UIScale = scale
        Elv.PixelScaleChanged()
    else
        C_CVar.SetCVar("uiScale", scale)
        C_CVar.SetCVar("useUIScale", 1)
    end
    updateScaleDisplay()
end

-- UI Scale Functions
local function smallUIScale()
    updateUIScale(QuaziiUI.smallScale)
end
local function medUIScale()
    updateUIScale(QuaziiUI.mediumScale)
end
local function lgUIScale()
    updateUIScale(QuaziiUI.largeScale)
end
local function autoUIScale()
    if C_AddOns and C_AddOns.IsAddOnLoaded("ElvUI") then
        updateUIScale(ElvUI[1]:PixelBestSize())
    else
        local _, physHeight = GetPhysicalScreenSize()
        local perfect = 768 / physHeight
        updateUIScale(max(0.4, min(1.15, perfect)))
    end
end

-- Import Profile Functions
local function importProfile(profileType, dbKey, dataKey)
    return function()
        QuaziiUI.DF:ShowPromptPanel(
            string.format("Are you sure you want to import/update Quazii's %s ElvUI profile?", profileType),
            function()
                QuaziiUI.db.global.imports[dbKey] = {
                    date = GetServerTime(),
                    version = QuaziiUI.versionNumber
                }
                local Profile = ElvUI[1].Distributor
                Profile:ImportProfile(dataKey)
                QuaziiUI.db.char.openPage = 3
                updateElvUIDisplay()
            end,
            function()
            end,
            true
        )
    end
end

local importHealerProfile = importProfile("Healer", "healer", QuaziiUI.imports.ElvUI.healer.data)
local importHealerCellProfile = importProfile("Cell", "cell", QuaziiUI.imports.ElvUI.cell.data)
local importTankProfile = importProfile("Tank/DPS", "tankdps", QuaziiUI.imports.ElvUI.tankdps.data)

-- Page Creation
function page:Create(parent)
    local frame = CreateFrame("Frame", nil, parent.frameContent)
    frame:SetAllPoints()

    self:CreateElvUISection(frame)
    self:CreateUIScaleSection(frame)

    self.rootFrame = frame
    return frame
end

function page:CreateElvUISection(frame)
    local elvHeader =
        QuaziiUI.DF:CreateLabel(
        frame,
        "|c" .. QuaziiUI.highlightColorHex .. L["ElvUI"] .. " " .. L["Imports"] .. "|r",
        QuaziiUI.PageHeaderSize
    )
    elvHeader:SetFont(QuaziiUI.FontFace, QuaziiUI.PageHeaderSize)
    elvHeader:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -10)
    elvHeader:SetPoint("TOPRIGHT", frame, "TOP", -10, -10)
    elvHeader:SetJustifyH("CENTER")
    elvHeader:SetJustifyV("TOP")

    local elvDescription =
        QuaziiUI.DF:CreateLabel(frame, L["ElvUIText"]:gsub("QHCH", QuaziiUI.highlightColorHex), QuaziiUI.PageTextSize)
    elvDescription:SetFont(QuaziiUI.FontFace, QuaziiUI.PageTextSize)
    elvDescription:SetWordWrap(true)
    elvDescription:SetPoint("TOPLEFT", elvHeader.widget, "BOTTOMLEFT", 0, -10)
    elvDescription:SetPoint("TOPRIGHT", elvHeader.widget, "BOTTOMRIGHT", 0, -10)
    elvDescription:SetJustifyH("LEFT")
    elvDescription:SetJustifyV("TOP")

    local importTankContainer =
        QuaziiUI:CreateImportFrame(frame, "ElvUI", L["Tank"] .. "/" .. L["DPS"], importTankProfile)
    importTankContainer:SetPoint("TOP", elvDescription.widget, "BOTTOM", 0, -20)

    local importHealerContainer = QuaziiUI:CreateImportFrame(frame, "ElvUI", L["Healer"], importHealerProfile)
    importHealerContainer:SetPoint("TOPRIGHT", importTankContainer, "BOTTOMRIGHT", 0, 0)

    -- L["CellNotice"]
    local cellNotice =
        QuaziiUI.DF:CreateLabel(
        frame,
        "Cell AddOn Users:\nBelow profile is specific for use with Cell",
        QuaziiUI.PageTextSize
    )
    cellNotice:SetFont(QuaziiUI.FontFace, QuaziiUI.TableTextSize)
    cellNotice:SetWordWrap(true)
    cellNotice:SetPoint("TOP", importHealerContainer.versionText.widget, "BOTTOMLEFT", -5, -15)
    cellNotice:SetJustifyH("CENTER")

    local importCellContainer = QuaziiUI:CreateImportFrame(frame, "ElvUI", L["ElvUI"], importHealerCellProfile)
    importCellContainer:SetPoint("TOP", cellNotice.widget, "BOTTOM", 0, -10)

    self.lastHImportTime = importHealerContainer.lastImportText
    self.lastTImportTime = importTankContainer.lastImportText
    self.lastCImportTime = importCellContainer.lastImportText
    self.lastHVersion = importHealerContainer.versionText
    self.lastTVersion = importTankContainer.versionText
    self.lastCVersion = importCellContainer.versionText
end

function page:CreateUIScaleSection(frame)
    local uiHeader =
        QuaziiUI.DF:CreateLabel(
        frame,
        "|c" .. QuaziiUI.highlightColorHex .. L["UIScaleHeader"] .. "|r",
        QuaziiUI.PageHeaderSize
    )
    uiHeader:SetFont(QuaziiUI.FontFace, QuaziiUI.PageHeaderSize)
    uiHeader:SetPoint("TOPLEFT", frame, "TOP", 10, -10)
    uiHeader:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -10, -10)
    uiHeader:SetJustifyH("CENTER")

    local uiDescription = QuaziiUI.DF:CreateLabel(frame, L["UIScaleText"], QuaziiUI.PageTextSize)
    uiDescription:SetFont(QuaziiUI.FontFace, QuaziiUI.PageTextSize)
    uiDescription:SetWordWrap(true)
    uiDescription:SetPoint("TOPLEFT", uiHeader.widget, "BOTTOMLEFT", 0, -10)
    uiDescription:SetPoint("TOPRIGHT", uiHeader.widget, "BOTTOMRIGHT", 0, -10)
    uiDescription:SetJustifyH("LEFT")
    uiDescription:SetJustifyV("TOP")

    local uiScaleLabel = QuaziiUI.DF:CreateLabel(frame, L["CurrentUIScale"], QuaziiUI.PageTextSize)
    uiScaleLabel:SetFont(QuaziiUI.FontFace, QuaziiUI.PageTextSize)
    uiScaleLabel:SetPoint("TOP", uiDescription.widget, "BOTTOM", 0, -35)

    self.uiScaleText = QuaziiUI.DF:CreateLabel(frame, "", QuaziiUI.PageTextSize)
    self.uiScaleText:SetFont(QuaziiUI.FontFace, QuaziiUI.PageTextSize)
    self.uiScaleText:SetPoint("TOP", uiScaleLabel, "BOTTOM", 0, -10)

    self:CreateScaleButtons(frame)
end

function page:CreateScaleButtons(frame)
    local buttonConfig = {
        {text = L["ScaleButtonAuto"], func = autoUIScale},
        {text = L["ScaleButtonSmall"], func = smallUIScale},
        {text = L["ScaleButtonMedium"], func = medUIScale},
        {text = L["ScaleButtonLarge"], func = lgUIScale}
    }

    local lastButton
    for i, config in ipairs(buttonConfig) do
        local button =
            QuaziiUI.DF:CreateButton(
            frame,
            config.func,
            90,
            30,
            config.text,
            nil,
            nil,
            nil,
            nil,
            nil,
            nil,
            QuaziiUI.ODT
        )
        if i == 1 then
            button:SetPoint("TOP", self.uiScaleText.widget, "BOTTOM", 0, -10)
        else
            button:SetPoint("TOP", lastButton, "BOTTOM", 0, -10)
        end
        button.text_overlay:SetFont(QuaziiUI.FontFace, QuaziiUI.PageTextSize)
        lastButton = button
    end
end

function page:ShouldShow()
    return true
end

function page:Show()
    updateElvUIDisplay()
    updateScaleDisplay()
    self.rootFrame:Show()
end

function page:Hide()
    self.rootFrame:Hide()
end
