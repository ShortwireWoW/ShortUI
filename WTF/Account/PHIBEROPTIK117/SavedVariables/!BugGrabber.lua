
BugGrabberDB = {
["lastSanitation"] = 3,
["session"] = 19,
["errors"] = {
{
["message"] = "[ADDON_ACTION_BLOCKED] AddOn 'FriendGroups' tried to call the protected function 'RaidFrame:Hide()'.",
["time"] = "2025/04/02 22:33:50",
["locals"] = "_ = Frame {\n}\nevent = \"ADDON_ACTION_BLOCKED\"\nevents = <table> {\n}\n",
["stack"] = "[Interface/AddOns/!BugGrabber/BugGrabber.lua]:485: in function <Interface/AddOns/!BugGrabber/BugGrabber.lua:485>\n[C]: in function 'Hide'\n[Interface/AddOns/Blizzard_FriendsFrame/Mainline/FriendsFrame.lua]:79: in function 'FriendsFrame_ShowSubFrame'\n[Interface/AddOns/Blizzard_FriendsFrame/Mainline/FriendsFrame.lua]:411: in function 'FriendsFrame_Update'\n[Interface/AddOns/Blizzard_FriendsFrame/Mainline/FriendsFrame.lua]:1119: in function <...dOns/Blizzard_FriendsFrame/Mainline/FriendsFrame.lua:1052>",
["session"] = 19,
["counter"] = 1,
},
{
["message"] = "FontString:SetText(): Font not set\nLua Taint: BigWigs_Plugins",
["time"] = "2025/04/02 22:33:35",
["locals"] = "(*temporary) = FontString {\n animFade = Alpha {\n }\n elapsed = 0.410000\n anim = AnimationGroup {\n }\n icon = Texture {\n }\n}\n(*temporary) = \"Briny Vomit (Dodge)\"\n",
["stack"] = "[C]: in function 'SetText'\n[Interface/AddOns/BigWigs_Plugins/Messages.lua]:775: in function 'Print'\n[Interface/AddOns/BigWigs_Plugins/Messages.lua]:859: in function <Interface/AddOns/BigWigs_Plugins/Messages.lua:836>\n[C]: ?\n[Interface/AddOns/BigWigs/Loader.lua]:1491: in function 'SendMessage'\n[Interface/AddOns/BigWigs_Core/BossPrototype.lua]:2693: in function 'Message'\n[Interface/AddOns/BigWigs_KhazAlgar/Shurrai.lua]:105: in function '?'\n[Interface/AddOns/BigWigs_Core/BossPrototype.lua]:798: in function <Interface/AddOns/BigWigs_Core/BossPrototype.lua:756>",
["session"] = 19,
["counter"] = 12,
},
},
}
