local f = CreateFrame("Frame", "SMLS_DevToolsFrame", UIParent, "BackdropTemplate")
f:SetSize(200, 50)
f:SetPoint("CENTER")
f:SetMovable(true)
f:EnableMouse(true)
f:RegisterForDrag("LeftButton")
f:SetScript("OnDragStart", f.StartMoving)
f:SetScript("OnDragStop", f.StopMovingOrSizing)
f:SetBackdrop({ bgFile = "Interface/Tooltips/UI-Tooltip-Background" })
f:SetBackdropColor(0, 0, 0, 0.6)

local function CreateButton(name, label, xOffset, onClick)
    local b = CreateFrame("Button", name, f, "UIPanelButtonTemplate")
    b:SetSize(90, 24)
    b:SetText(label)
    b:SetPoint("LEFT", f, "LEFT", xOffset, 0)
    b:SetScript("OnClick", onClick)
    return b
end

CreateButton("SMLS_Button_Wire", "Wire Transfer", 0, function()
    C_ChatInfo.SendAddonMessage("SMLSDEV", "wire", "RAID")
end)

CreateButton("SMLS_Button_Reset", "Reset", 100, function()
    C_ChatInfo.SendAddonMessage("SMLSDEV", "reset", "RAID")
end)

print("[SMLS_DevTools] Movable buttons loaded.")