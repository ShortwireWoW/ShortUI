local DEBUG = true
local function debugPrint(...)
    if DEBUG then
        print("|cff00ffff[DnDLeader Debug]|r", ...)
    end
end

local TARGET_LEADER = "Gunparade-Illidan"

-- Setup UI frame
local frame = CreateFrame("Frame", "DnDLeaderFrame", UIParent, "BackdropTemplate")
frame:SetSize(360, 140)
frame:SetPoint("CENTER")
frame:SetBackdrop({ bgFile = "Interface/Tooltips/UI-Tooltip-Background" })
frame:SetBackdropColor(0, 0, 0, 0.9)
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
frame:Hide()

-- Close Button
local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
close:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -5, -5)

-- Status Text
local statusText = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
statusText:SetPoint("BOTTOM", frame, "BOTTOM", 0, 15)
statusText:SetText("")

-- Button to run secure search
local searchButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
searchButton:SetSize(240, 26)
searchButton:SetText("🔍 Find Group by Leader: " .. TARGET_LEADER)
searchButton:SetPoint("TOP", frame, "TOP", 0, -30)

searchButton:SetScript("OnClick", function()
    debugPrint("🔍 Secure search for Raids started...")
    statusText:SetText("Searching...")

    local f = CreateFrame("Frame")
    f:RegisterEvent("LFG_LIST_SEARCH_RESULTS_RECEIVED")
    f:SetScript("OnEvent", function()
        local results = C_LFGList.GetSearchResults()
        if type(results) ~= "table" or #results == 0 then
            debugPrint("⚠️ No results returned.")
            statusText:SetText("No results.")
            return
        end

        local found = false
        for _, id in ipairs(results) do
            local info = C_LFGList.GetSearchResultInfo(id)
            if info and info.leaderName == TARGET_LEADER then
                debugPrint("✅ Found group led by:", TARGET_LEADER)
                debugPrint("   Group ID:", id)
                debugPrint("   Group Name:", info.name or "unknown")
                debugPrint("   Voice Chat:", info.voiceChat or "none")
                statusText:SetText("Found group: ID " .. id)
                found = true
                break
            end
        end

        if not found then
            debugPrint("❌ Could not find any group led by:", TARGET_LEADER)
            statusText:SetText("Group not found.")
        end

        f:UnregisterAllEvents()
        f:SetScript("OnEvent", nil)
    end)

    -- Must be secure to succeed
    C_LFGList.Search(3)
end)

-- Slash command to open frame
SLASH_DNDLEADER1 = "/dndleader"
SlashCmdList["DNDLEADER"] = function()
    debugPrint("/dndleader run. Showing frame.")
    frame:Show()
end
