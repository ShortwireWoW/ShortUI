local L = QuaziiUI.L

local page = {}
table.insert(QuaziiUI.pages, page)

function page:Create(parent)
    local frame = CreateFrame("Frame", nil, parent.frameContent)
    frame:SetAllPoints()

    self:CreateHeader(frame)
    self:CreateText(frame)
    self:CreateImage(frame)

    self.rootFrame = frame
    return frame
end

function page:CreateHeader(frame)
    local header = QuaziiUI.DF:CreateLabel(frame, "|c" .. QuaziiUI.highlightColorHex .. L["FinishHeader"] .. "|r", QuaziiUI.PageHeaderSize)
    header:SetFont(QuaziiUI.FontFace, QuaziiUI.PageHeaderSize)
    header:SetPoint("TOP", frame, "TOP", 0, -10)
end

function page:CreateText(frame)
    local text = QuaziiUI.DF:CreateLabel(frame, L["FinishedText"], QuaziiUI.PageTextSize)
    text:SetFont(QuaziiUI.FontFace, QuaziiUI.PageTextSize)
    text:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -40)
    text:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -10, -40)
    text:SetSpacing(5)
    text:SetJustifyH("CENTER")
    text:SetJustifyV("TOP")
    frame.textWidget = text.widget
end

function page:CreateImage(frame)
    local image = QuaziiUI.DF:CreateImage(frame, QuaziiUI.logoPath, 256, 256)
    image:SetPoint("CENTER", frame, "CENTER", 0, -10)
end

function page:ShouldShow()
    return true
end

function page:Show()
    self.rootFrame:Show()
end

function page:Hide()
    self.rootFrame:Hide()
end
