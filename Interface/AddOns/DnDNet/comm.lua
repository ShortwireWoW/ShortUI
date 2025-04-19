DnDNetComm = {}

-- Used to send messages between addons
function DnDNetComm:Send(to, message)
  if not to or not message then return end
  C_ChatInfo.SendAddonMessage("DnDNet", message, "WHISPER", to)
  if DnDNet.debug then print("[DnDNet Debug] 🔁 Sent to", to .. ":", message) end
end

-- Broadcast to group/instance/community/etc. can be added later
