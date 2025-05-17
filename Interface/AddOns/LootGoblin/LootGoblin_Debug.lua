-- LootGoblin.lua
-- DnD LootGoblin Addon: Scans raid member gear and tracks loot rolls

local addonName, LG = ...
LG.frame = CreateFrame("Frame")
LG.scanData = {}
LG.inspectQueue = {}
LG.failedQueue = {}
LG.isScanning = false
LG.currentUnit = nil
LG.totalPlayersToScan = 0
LG.scanStartTime = 0
LG.lastScanTime = {}
LG.scanInterval = 300 -- 5 minutes
LG.zoneID = 2406 -- Liberation of Undermine

-- Create movable status frame
LG.statusFrame = CreateFrame("Frame", "LootGoblinStatusFrame", UIParent, "BackdropTemplate")
LG.statusFrame:SetSize(240, 40)
LG.statusFrame:SetPoint("CENTER")
LG.statusFrame:SetBackdrop({
    bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 12,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
LG.statusFrame:SetBackdropColor(0.1, 0.1, 0.1, 0.8)
LG.statusFrame:SetMovable(true)
LG.statusFrame:EnableMouse(true)
LG.statusFrame:RegisterForDrag("LeftButton")
LG.statusFrame:SetScript("OnDragStart", function(self) self:StartMoving() end)
LG.statusFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

LG.statusFrame.title = LG.statusFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
LG.statusFrame.title:SetPoint("TOP", LG.statusFrame, "TOP", 0, 10)
LG.statusFrame.title:SetText("DnD Loot Goblin")

LG.statusFrame.text = LG.statusFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
LG.statusFrame.text:SetPoint("CENTER", LG.statusFrame, "CENTER", 0, -8)
LG.statusFrame.text:SetText("Players Scanned: 0/0")

-- Update status text
function LG:UpdateStatus()
    local scanned = 0
    local total = GetNumGroupMembers()
    for i = 1, total do
        local unit = "raid" .. i
        local guid = UnitGUID(unit)
        if guid and LG.scanData[guid] and GetTime() - LG.scanData[guid].timeStamp < LG.scanInterval then
            scanned = scanned + 1
        end
    end
    LG.statusFrame.text:SetText(string.format("Players Scanned: %d/%d", scanned, total))
end

-- Slash command
SLASH_LOOTGOBLIN1 = "/lootgoblin"
SLASH_LOOTGOBLIN2 = "/lg"
SlashCmdList["LOOTGOBLIN"] = function(msg)
    print("|cff00ff00[LootGoblin]:|r Running scan manually...")
    LG:QueueScans()
end

-- Event handling
LG.frame:RegisterEvent("PLAYER_ENTERING_WORLD")
LG.frame:RegisterEvent("GROUP_ROSTER_UPDATE")
LG.frame:RegisterEvent("INSPECT_READY")
LG.frame:RegisterEvent("PLAYER_REGEN_ENABLED")
LG.frame:SetScript("OnEvent", function(_, event, ...)
    if event == "PLAYER_ENTERING_WORLD" or event == "GROUP_ROSTER_UPDATE" then
        local zone = C_Map.GetBestMapForUnit("player")
        print("[LootGoblin Debug] Zone ID: " .. tostring(zone))
        if zone == LG.zoneID and IsInRaid() then
            print("[LootGoblin Debug] Showing scan window")
            LG.statusFrame:Show()
            LG:ClearScanData()
            LG:QueueScans()
        else
            print("[LootGoblin Debug] Hiding scan window")
            LG.statusFrame:Hide()
        end
    elseif event == "PLAYER_REGEN_ENABLED" then
        print("[LootGoblin Debug] Out of combat, resuming scan")
        LG:QueueScans()
    elseif event == "INSPECT_READY" then
    local unit = LG.currentUnit
    if not unit or not UnitExists(unit) then
        print("[LootGoblin Debug] INSPECT_READY but no valid currentUnit")
        LG.currentUnit = nil
        LG.isScanning = false
        return
    end

    local guid = UnitGUID(unit)
    if not guid then
        print("[LootGoblin Debug] INSPECT_READY but no valid GUID for unit: " .. tostring(unit))
        LG.currentUnit = nil
        LG.isScanning = false
        return
    end


        local data = { name = UnitName(unit), timeStamp = GetTime() }
        local valid = 0
        for slot = 1, 18 do
            local link = GetInventoryItemLink(unit, slot)
            if link then
                data["slot_" .. slot] = link
                valid = valid + 1
            else
                data["slot_" .. slot] = "None"
            end
        end

        if valid >= 15 then
            print("[LootGoblin Debug] Scan success for: " .. UnitName(unit) .. " (" .. valid .. "/18)")
            LG.scanData[guid] = data
            LG.lastScanTime[guid] = GetTime()
        else
            print("[LootGoblin Debug] Scan failed for: " .. UnitName(unit) .. " (" .. valid .. "/18), retrying later")
            table.insert(LG.failedQueue, unit)
        end

        ClearInspectPlayer()
        LG.currentUnit = nil
        LG.isScanning = false
        LG:UpdateStatus()
        C_Timer.After(0.4, function() LG:ProcessQueue() end)
    end
end)

function LG:ClearScanData()
    print("[LootGoblin Debug] Clearing scan data")
    LG.scanData = {}
    LG.inspectQueue = {}
    LG.failedQueue = {}
    LG.lastScanTime = {}
end

function LG:QueueScans()
    if InCombatLockdown() then
        print("[LootGoblin Debug] Skipping scan, in combat")
        return
    end

    LG.inspectQueue = {}
    local total = GetNumGroupMembers()
    for i = 1, total do
        local unit = "raid" .. i
        local guid = UnitGUID(unit)
        if UnitExists(unit) and UnitIsConnected(unit) and not UnitIsDeadOrGhost(unit) and CanInspect(unit)
                and CheckInteractDistance(unit, 1) and (not LG.lastScanTime[guid] or (GetTime() - LG.lastScanTime[guid]) > LG.scanInterval) then
            print("[LootGoblin Debug] Added to scan queue: " .. UnitName(unit))
            table.insert(LG.inspectQueue, unit)
        else
            print("[LootGoblin Debug] Skipped: " .. UnitName(unit or "nil"))
        end
    end

    LG.totalPlayersToScan = #LG.inspectQueue
    LG.scanStartTime = GetTime()

    if LG.totalPlayersToScan > 0 then
        LG:ProcessQueue()
    end
end

function LG:ProcessQueue()
    if LG.isScanning or InCombatLockdown() then return end

    local unit = table.remove(LG.inspectQueue, 1)
    if not unit and #LG.failedQueue > 0 then
        print("[LootGoblin Debug] Retry failed scans")
        LG.inspectQueue = LG.failedQueue
        LG.failedQueue = {}
        unit = table.remove(LG.inspectQueue, 1)
    end

    if not unit then
        print("[LootGoblin Debug] Scan queue empty")
        return
    end

    if UnitExists(unit) and CanInspect(unit) and CheckInteractDistance(unit, 1) then
        print("[LootGoblin]: Now scanning " .. UnitName(unit))
        LG.currentUnit = unit
        LG.isScanning = true
        NotifyInspect(unit)
    else
        print("[LootGoblin Debug] Skipping unit: " .. UnitName(unit))
        C_Timer.After(0.2, function() LG:ProcessQueue() end)
    end
end

print("[LootGoblin]: Debugger Loaded.")