-- DnDTools.lua

local md5 = md5 -- from libs/md5.lua

-- Main frame
local DnDTools = CreateFrame("Frame", "DnDToolsFrame", UIParent, "BasicFrameTemplateWithInset")
DnDTools:SetSize(420, 360)
DnDTools:SetPoint("CENTER")
DnDTools:SetMovable(true)
DnDTools:EnableMouse(true)
DnDTools:RegisterForDrag("LeftButton")
DnDTools:SetScript("OnDragStart", DnDTools.StartMoving)
DnDTools:SetScript("OnDragStop", DnDTools.StopMovingOrSizing)
DnDTools:Hide()

-- Title
DnDTools.title = DnDTools:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
DnDTools.title:SetPoint("LEFT", DnDTools.TitleBg, "LEFT", 10, 0)
DnDTools.title:SetText("DnDTools - MD5 Hash Generator")

-- Scroll frame
local scrollFrame = CreateFrame("ScrollFrame", "DnDToolsScrollFrame", DnDTools, "UIPanelScrollFrameTemplate")
scrollFrame:SetSize(370, 180)
scrollFrame:SetPoint("TOPLEFT", DnDTools, "TOPLEFT", 20, -40)

-- Edit box inside scroll
local inputBox = CreateFrame("EditBox", nil, scrollFrame)
inputBox:SetMultiLine(true)
inputBox:SetFontObject(ChatFontNormal)
inputBox:SetWidth(350)
inputBox:SetHeight(400) -- Important!
inputBox:SetAutoFocus(false)
inputBox:SetText("Enter BattleTags here...\nExample:\nChugMonk#1359\nFooBar#1234")
inputBox:SetScript("OnEscapePressed", inputBox.ClearFocus)
inputBox:SetScript("OnTextChanged", function(self)
    scrollFrame:UpdateScrollChildRect()
end)

-- Properly set as scroll child
scrollFrame:SetScrollChild(inputBox)


-- Output box (allow focus + selection)
local outputBox = CreateFrame("EditBox", nil, DnDTools, "InputBoxTemplate")
outputBox:SetSize(370, 30)
outputBox:SetPoint("BOTTOMLEFT", DnDTools, "BOTTOMLEFT", 20, 80)
outputBox:SetAutoFocus(false)
outputBox:SetFontObject(ChatFontNormal)
outputBox:SetEnabled(true)             -- Allow input
outputBox:EnableMouse(true)           -- Allow clicking
outputBox:SetScript("OnEscapePressed", outputBox.ClearFocus)
outputBox:SetScript("OnEditFocusGained", function(self)
    self:HighlightText()
end)
outputBox:SetScript("OnEditFocusLost", function(self)
    self:HighlightText(0, 0) -- Deselect when focus lost
end)


-- Generate hash button
local generateButton = CreateFrame("Button", nil, DnDTools, "GameMenuButtonTemplate")
generateButton:SetSize(180, 30)
generateButton:SetPoint("BOTTOMLEFT", DnDTools, "BOTTOMLEFT", 20, 35)
generateButton:SetText("Generate Hash")
generateButton:SetScript("OnClick", function()
    local raw = inputBox:GetText()
    local lines = {}
    for line in raw:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end
    table.sort(lines)
    local concat = table.concat(lines, "|")
    local hash = md5.sumhexa(concat)
    outputBox:SetText(hash)
end)

-- Copy button
local copyButton = CreateFrame("Button", nil, DnDTools, "GameMenuButtonTemplate")
copyButton:SetSize(160, 30)
copyButton:SetPoint("LEFT", generateButton, "RIGHT", 10, 0)
copyButton:SetText("Copy to Clipboard")
copyButton:SetScript("OnClick", function()
    outputBox:HighlightText()
    outputBox:SetFocus()
end)

-- Close
DnDTools.CloseButton:SetScript("OnClick", function()
    DnDTools:Hide()
end)

-- Slash command
SLASH_DNDTOOLS1 = "/dndtools"
SlashCmdList["DNDTOOLS"] = function()
    DnDTools:Show()
end
