
BugGrabberDB = {
["session"] = 654,
["lastSanitation"] = 3,
["errors"] = {
{
["message"] = "Lua error in aura 'Lunar Effect - Tier Reporter': Trigger 2\nWeakAuras Version: 5.19.4\nStack trace:\n[string \"return function(event, ...)\"]:6: bad argument #1 to 'ipairs' (table expected, got nil)",
["time"] = "2025/03/11 19:44:22",
["locals"] = "(*temporary) = nil\n(*temporary) = \"table expected, got nil\"\n",
["stack"] = "[C]: in function 'ipairs'\n[return function(event, ...)]:6: in function 'updateTier'\n[return function(event, ...)]:17: in function <[string \"return function(event, ...)\"]:1>\n[C]: in function 'xpcall'\n[Interface/AddOns/WeakAuras/GenericTrigger.lua]:752: in function <Interface/AddOns/WeakAuras/GenericTrigger.lua:656>\n[Interface/AddOns/WeakAuras/GenericTrigger.lua]:963: in function 'ScanEventsInternal'\n[Interface/AddOns/WeakAuras/GenericTrigger.lua]:897: in function 'ScanEvents'\n[Interface/AddOns/WeakAuras/GenericTrigger.lua]:1192: in function <Interface/AddOns/WeakAuras/GenericTrigger.lua:1180>",
["session"] = 653,
["counter"] = 1,
},
{
["message"] = "[string \"print(C_ChatInfo.IsAddonMessagePrefixRegistered(\"LE_TIER\")\"]:1: ')' expected near '<eof>'",
["time"] = "2025/03/11 21:17:49",
["locals"] = "(*temporary) = \"print(C_ChatInfo.IsAddonMessagePrefixRegistered(\"LE_TIER\")\"\n",
["stack"] = "[C]: in function 'RunScript'\n[Interface/AddOns/Blizzard_ChatFrameBase/Mainline/ChatFrame.lua]:2308: in function '?'\n[Interface/AddOns/Blizzard_ChatFrameBase/Mainline/ChatFrame.lua]:5517: in function <...AddOns/Blizzard_ChatFrameBase/Mainline/ChatFrame.lua:5463>\n[C]: in function 'ChatEdit_ParseText'\n[Interface/AddOns/Blizzard_ChatFrameBase/Mainline/ChatFrame.lua]:5169: in function <...AddOns/Blizzard_ChatFrameBase/Mainline/ChatFrame.lua:5168>\n[C]: in function 'ChatEdit_SendText'\n[Interface/AddOns/Blizzard_ChatFrameBase/Mainline/ChatFrame.lua]:5205: in function 'ChatEdit_OnEnterPressed'\n[*ChatFrame.xml:140_OnEnterPressed]:1: in function <[string \"*ChatFrame.xml:140_OnEnterPressed\"]:1>",
["session"] = 654,
["counter"] = 1,
},
{
["message"] = "[ADDON_ACTION_BLOCKED] AddOn 'Myslot' tried to call the protected function 'PickupAction()'.",
["time"] = "2025/03/11 23:13:43",
["locals"] = "_ = Frame {\n}\nevent = \"ADDON_ACTION_BLOCKED\"\nevents = <table> {\n}\n",
["stack"] = "[Interface/AddOns/!BugGrabber/BugGrabber.lua]:485: in function <Interface/AddOns/!BugGrabber/BugGrabber.lua:485>\n[C]: in function 'PickupAction'\n[Interface/AddOns/Myslot/Myslot.lua]:202: in function 'GetActionInfo'\n[Interface/AddOns/Myslot/Myslot.lua]:377: in function 'Export'\n[Interface/AddOns/Myslot/gui.lua]:518: in function <Interface/AddOns/Myslot/gui.lua:517>",
["session"] = 654,
["counter"] = 1,
},
},
}
