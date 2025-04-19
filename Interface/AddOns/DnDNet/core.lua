DnDNet = {}
local f = CreateFrame("Frame")

f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(_, event, addon)
  if addon ~= "DnDNet" then return end

  DnDNet.debug = true
  DnDNetConfig = DnDNetConfig or {}

  if DnDNet.debug then print("[DnDNet Debug] Loaded.") end

  -- Run BNet validation check
  DnDNet.isLeader = DnDNetSecurity and DnDNetSecurity:ValidateLeader()

  if DnDNet.isLeader then
    if DnDNet.debug then print("[DnDNet Debug] Leader mode enabled.") end
    DnDNetLeader_Init()
  else
    DnDNetClient_Init()
  end
end)

-- Slash command
SLASH_DNDNET1 = "/dndnet"
SlashCmdList["DNDNET"] = function()
  print("[DnDNet] Use `/dndnet` to open the UI.")
  if DnDNetUI_Open then DnDNetUI_Open() end
end
