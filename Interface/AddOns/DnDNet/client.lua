function DnDNetClient_Init()
  if DnDNet.debug then print("[DnDNet Debug] Client mode activated.") end

  -- In the future this will listen for broadcasts
  local f = CreateFrame("Frame")
  f:RegisterEvent("CHAT_MSG_ADDON")
  f:SetScript("OnEvent", function(_, _, prefix, msg, channel, sender)
    if prefix ~= "DnDNet" then return end

    if DnDNet.debug then
      print("[DnDNet Debug] 📩 Received:", msg, "from", sender)
    end

    -- TODO: Handle join requests, event listings, etc.
  end)
end
