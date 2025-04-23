local addonName, DnDPoC = ...
DnDPoC.frame = CreateFrame("Frame")

local function printMsg(msg)
  DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99DnDPoC:|r " .. msg)
end

-- Scan for group titles from LFG search results
function DnDPoC.ScanGroupNames()
  local _, resultIDs = C_LFGList.GetSearchResults()
  printMsg("Found " .. #resultIDs .. " group(s):")

  for _, id in ipairs(resultIDs) do
    local info = C_LFGList.GetSearchResultInfo(id)
    if info and info.name then
      printMsg("- " .. info.name)

      if info.comment and info.comment ~= "" then
        printMsg("  → " .. info.comment)
      end
    else
      printMsg("- (no name)")
    end
  end
end

-- Trigger a Custom Group search, then wait briefly and scan
function DnDPoC.TriggerSearch()
  local categoryID = 3 -- Raids Groups
  local filter = 0 -- No filters (required now)

  -- Do the search
  C_LFGList.Search(categoryID, filter, 0) -- preferredFilters = 0

  -- Wait 1 second for results to populate
  C_Timer.After(1.0, function()
    DnDPoC.ScanGroupNames()
  end)
end


-- Slash command handler
SLASH_DNDPOC1 = "/dndpoc"
SlashCmdList["DNDPOC"] = function()
  DnDPoC.TriggerSearch()
end