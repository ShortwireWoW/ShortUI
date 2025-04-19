function DnDNetLeader_Init()
  if DnDNet.debug then print("[DnDNet Debug] Leader mode enabled.") end

  -- Show special leader message in UI
  DnDNetUI_Open()
  if DnDNetMainFrame then
    DnDNetMainFrame.text:SetText("Leader Mode Enabled — Ready to Create Events")
  end

  -- Add future logic for broadcasting events, password validation, etc.
end
