
BugGrabberDB = {
["lastSanitation"] = 3,
["session"] = 357,
["errors"] = {
{
["message"] = "[ADDON_ACTION_BLOCKED] AddOn '*** ForceTaint_Strong ***' tried to call the protected function 'Button:SetPassThroughButtons()'.",
["time"] = "2025/02/08 00:45:09",
["locals"] = "_ = Frame {\n}\nevent = \"ADDON_ACTION_BLOCKED\"\nevents = <table> {\n}\n",
["stack"] = "[string \"@Interface/AddOns/!BugGrabber/BugGrabber.lua\"]:485: in function <Interface/AddOns/!BugGrabber/BugGrabber.lua:485>\n[string \"=[C]\"]: in function `SetPassThroughButtons'\n[string \"@Interface/AddOns/Blizzard_MapCanvas/MapCanvas_DataProviderBase.lua\"]:224: in function `CheckMouseButtonPassthrough'\n[string \"@Interface/AddOns/Blizzard_MapCanvas/Blizzard_MapCanvas.lua\"]:257: in function `AcquirePin'\n[string \"@Interface/AddOns/Blizzard_SharedMapDataProviders/EncounterJournalDataProvider.lua\"]:36: in function `RefreshAllData'\n[string \"@Interface/AddOns/Blizzard_SharedMapDataProviders/EncounterJournalDataProvider.lua\"]:22: in function `OnEvent'\n[string \"@Interface/AddOns/Blizzard_MapCanvas/MapCanvas_DataProviderBase.lua\"]:99: in function `SignalEvent'\n[string \"@Interface/AddOns/Blizzard_MapCanvas/Blizzard_MapCanvas.lua\"]:115: in function <...ace/AddOns/Blizzard_MapCanvas/Blizzard_MapCanvas.lua:114>\n[string \"=[C]\"]: in function `secureexecuterange'\n[string \"@Interface/AddOns/Blizzard_MapCanvas/Blizzard_MapCanvas.lua\"]:123: in function `OnEvent'\n[string \"@Interface/AddOns/Blizzard_BattlefieldMap/Blizzard_BattlefieldMap.lua\"]:168: in function <.../Blizzard_BattlefieldMap/Blizzard_BattlefieldMap.lua:167>",
["session"] = 357,
["counter"] = 1,
},
},
}
