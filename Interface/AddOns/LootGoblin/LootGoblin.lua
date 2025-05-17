--[[-------------------------------------------------------------------------
LootGoblin: A raid gear scanner that inspects all raid members,
detects item rolls, and displays a scan progress UI during Liberation of Undermine.
---------------------------------------------------------------------------]]

-- === Saved Variables ===
LootGoblin = LootGoblin or {}
LootGoblinDB = LootGoblinDB or {}
LootGoblin.lastScan = LootGoblinDB.lastScan or {}

-- === Internal State ===
LootGoblin.inspectQueue = {}
LootGoblin.failedQueue = {}
LootGoblin.scanInProgress = false
LootGoblin.inspectCooldown = false
LootGoblin.scanStartTime = 0
LootGoblin.totalToScan = 0

-----------------------------------------------------
-- 🧠 Utility Functions
-----------------------------------------------------

function LootGoblin:Print(msg)
    print("|cffffff00[LootGoblin]:|r " .. msg)
end

function LootGoblin:ShouldScan(unit)
    if not UnitExists(unit) or not UnitIsConnected(unit) or UnitIsDeadOrGhost(unit) then return false end
    if not CanInspect(unit) or not CheckInteractDistance(unit, 1) then return false end

    local guid = UnitGUID(unit)
    local scan = self.lastScan[guid]
    return not scan or (GetTime() - scan.timeStamp) >= 300
end

function LootGoblin:ResetScan()
    self.inspectQueue = {}
    self.failedQueue = {}
    self.lastScan = {}
    LootGoblinDB.lastScan = {}
    self.scanStartTime = 0
    self.totalToScan = 0
    self.inspecting = nil
    self.inspectCooldown = false
end

-----------------------------------------------------
-- 🔁 Scan Execution
-----------------------------------------------------

function LootGoblin:ScanNext()
    if self.inspectCooldown or self.scanInProgress or InCombatLockdown() then return end
    local unit = table.remove(self.inspectQueue, 1)
    if not unit then return end

    self.scanInProgress = true
    self.inspectCooldown = true
    self.inspecting = unit

    self:Print("Now scanning " .. (UnitName(unit) or unit))
    NotifyInspect(unit)

    C_Timer.After(0.25, function()
        self.inspectCooldown = false
    end)
end

function LootGoblin:ProcessInspect(unit)
    local guid = UnitGUID(unit)
    if not guid then return end

    local entry = { name = UnitName(unit), timeStamp = GetTime() }
    local valid = 0
    for i = 1, 18 do
        local link = GetInventoryItemLink(unit, i)
        if link then valid = valid + 1 end
        entry["slot_" .. i] = link or "None"
    end

    if valid >= 15 then
        self.lastScan[guid] = entry
        LootGoblinDB.lastScan = self.lastScan
    else
        table.insert(self.failedQueue, unit)
    end
end

-----------------------------------------------------
-- 🔃 UI: Scan Status Frame
-----------------------------------------------------

local scanFrame = CreateFrame("Frame", "LootGoblinScanFrame", UIParent, "BackdropTemplate")
scanFrame:SetSize(260, 60)
scanFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 200)
scanFrame:SetMovable(true)
scanFrame:EnableMouse(true)
scanFrame:RegisterForDrag("LeftButton")
scanFrame:SetScript("OnDragStart", scanFrame.StartMoving)
scanFrame:SetScript("OnDragStop", scanFrame.StopMovingOrSizing)
scanFrame:SetBackdrop({
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
scanFrame:SetBackdropColor(0.1, 0.1, 0.1, 0.9)

local title = scanFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
title:SetPoint("TOP", scanFrame, "TOP", 0, -8)
title:SetText("DnD Loot Goblin")

local statusText = scanFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
statusText:SetPoint("CENTER")
statusText:SetText("Players Scanned: 0/0")

function LootGoblin_UpdateScanDisplay()
    if not IsInRaid() then
        statusText:SetText("|cffffcc00Not in raid...|r")
        return
    end

    local total, scanned = 0, 0
    local now = GetTime()
    for i = 1, GetNumGroupMembers() do
        local unit = "raid" .. i
        local guid = UnitGUID(unit)
        if guid then
            total = total + 1
            local data = LootGoblin.lastScan[guid]
            if data and (now - data.timeStamp) < 300 then
                scanned = scanned + 1
            end
        end
    end

    local color = (scanned == total) and "|cff00ff00" or "|cffff0000"
    statusText:SetText(string.format("|cffffff00Players Scanned: %s%d/%d|r", color, scanned, total))
end

-----------------------------------------------------
-- 👁️ Frame Visibility Handling
-----------------------------------------------------

local function UpdateLootGoblinFrameVisibility()
    local zoneID = C_Map.GetBestMapForUnit("player")
    local alive = not UnitIsDeadOrGhost("player")
    local inCombat = InCombatLockdown()

    if zoneID == 2406 and alive and not inCombat then
        scanFrame:Show()
        LootGoblin_UpdateScanDisplay()
    else
        scanFrame:Hide()
    end
end

-----------------------------------------------------
-- ⚡ Slash Commands
-----------------------------------------------------

SLASH_LOOTGOBLIN1 = "/lootgoblin"
SLASH_LOOTGOBLIN2 = "/lg"
SlashCmdList["LOOTGOBLIN"] = function(msg)
    if msg == "reset" then
        LootGoblin:ResetScan()
        LootGoblin:Print("Data cleared.")
    else
        LootGoblin:Print("Use /lootgoblin or /lg. Type /lootgoblin reset to clear scan data.")
    end
end

-----------------------------------------------------
-- 🧩 Event Handling
-----------------------------------------------------

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("INSPECT_READY")
eventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
eventFrame:RegisterEvent("CHAT_MSG_LOOT")
eventFrame:RegisterEvent("GROUP_LEFT")
eventFrame:RegisterEvent("GROUP_JOINED")
eventFrame:SetScript("OnEvent", function(_, event, arg1, arg2)
    if event == "PLAYER_LOGIN" then
        LootGoblin:Print("Loaded.")

    elseif event == "GROUP_JOINED" or event == "PLAYER_REGEN_ENABLED" or event == "GROUP_ROSTER_UPDATE" then
        if InCombatLockdown() then return end
        LootGoblin:ResetScan()
        for i = 1, GetNumGroupMembers() do
            local unit = "raid" .. i
            if LootGoblin:ShouldScan(unit) then
                table.insert(LootGoblin.inspectQueue, unit)
            end
        end
        LootGoblin.totalToScan = #LootGoblin.inspectQueue
        LootGoblin.scanStartTime = GetTime()
        LootGoblin:ScanNext()

    elseif event == "GROUP_LEFT" then
        LootGoblin:ResetScan()

    elseif event == "INSPECT_READY" and LootGoblin.inspecting then
        LootGoblin:ProcessInspect(LootGoblin.inspecting)
        ClearInspectPlayer()
        LootGoblin.inspecting = nil
        LootGoblin.scanInProgress = false
        LootGoblin_UpdateScanDisplay()
        LootGoblin:ScanNext()

    elseif event == "CHAT_MSG_LOOT" then
        -- Future logic to compare loot rolls
    end
end)

-----------------------------------------------------
-- ⏱️ Frame Visibility Events
-----------------------------------------------------

scanFrame:SetFrameStrata("HIGH")
scanFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
scanFrame:RegisterEvent("PLAYER_ALIVE")
scanFrame:RegisterEvent("PLAYER_UNGHOST")
scanFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
scanFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
scanFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
scanFrame:SetScript("OnEvent", UpdateLootGoblinFrameVisibility)