-- Localization file for english/United States
local L = LibStub("AceLocale-3.0"):NewLocale("QuaziiUI", "enUS", true, true)

if L then
    -- Generic
    L["AddonName"] = "Quazii UI"
    L["Tank"] = "Tank"
    L["DPS"] = "DPS"
    L["Healer"] = "Healer"
    L["Import"] = "Import"
    L["Imports"] = "Imports"
    L["Next"] = "Next"
    L["Index"] = "Home"
    L["Prev"] = "Prev" --Shorthand for Previous
    L["Back"] = "Back"
    L["GoToPage"] = "Go To Page"
    L["Icon"] = "Icon"
    L["Name"] = "Name"
    L["Update"] = "Update Needed?"
    L["Version"] = "Version"
    L["LeftClickOpen"] = "Left Click: Open Installer"

    L["NA"] = "N/A"
    L["Yes"] = "Yes"
    L["No"] = "No"
    L["True"] = "True"
    L["False"] = "False"

    -- Import Frame
    L["ImportProfileText"] = " Profile:"
    L["ImportLastImportText"] = "Last Import Time:"

    -- Addons
    L["ElvUI"] = "ElvUI"
    L["Cell"] = "Cell"
    L["Details"] = "Details!"
    L["BigWigs"] = "BigWigs"
    L["OmniCD"] = "OmniCD"
    L["WeakAuras"] = "WeakAuras"
    L["MDT"] = "MDT"

    -- Welcome Page
    L["WelcomeHeader"] = "Quazii UI"
    L["WelcomeText1"] =
        "Quazii UI comes in non-ElvUI OR ElvUI versions. More details on next page.\n"
    L["WelcomeText2"] =
        "Note for Non-ElvUI version: Some addon profiles must be imported manually into your WoW folders. Please see the accompanying video guide for instructions.\n"
    L["WelcomeText3"] =
        "Click 'Next' to begin installation, or 'Home' at any time to return to the main menu."

    -- Supported Addon Check
    L["SupportedAddonsHeader"] = "Quazii UI Homepage"
    L["SupportedAddonsText"] =
        "|cffFFA500Imports in Orange are a MUST for non-ElvUI version.|r\n|cffFF00FFImports in Pink are a MUST for ElvUI version.|r\n|cffffffffImports in White apply to BOTH versions.|r"
    L["SupportedAddonsTable1stHeader"] = "Supported|r Addons"
    L["SupportedAddonsTable2ndHeader"] = "Enabled"
    L["SupportedAddonsTable3rdHeader"] = "Installed Version"

    -- ElvUI / UI Scale
    L["ElvUIHeader"] = "ElvUI Imports"
    L["ElvUIText"] =
        "Here you can import or update any of |cQHCHQuazii's|r ElvUI Profiles.\n|cQHCHNOTE:|r If you import multiple profiles, you can switch in ElvUI's profile settings."
    L["CellNotice"] = "Cell users visit https://quazii.com\nfor the cell compatible profile."
    L["UIScaleHeader"] = "UI Scale"
    L["UIScaleText"] =
        "Adjust your UI Scaling below.\nIf the UI looks off or too big/small, you may wish to try a different setting."
    L["CurrentUIScale"] = "Current UI Scale"
    L["ScaleButtonAuto"] = "Auto"
    L["ScaleButtonSmall"] = "Small"
    L["ScaleButtonMedium"] = "Medium"
    L["ScaleButtonLarge"] = "Large"

    -- Addon Import Messages
    L["BigWigsNameplateDisable"] = "Would you like to disable BigWigs Nameplate CDs?"
    L["DetailsPrompt"] = "Insert a Name for the New Details Profile:"
    local AddonImportMessage = "Are you sure you want to import the ADDONNAME Profile?"
    L["OmniCDPrompt"] = AddonImportMessage:gsub("ADDONNAME", "OmnicD")
    L["CellPrompt"] = AddonImportMessage:gsub("ADDONNAME", "Cell") .. "\n!- This will overwrite your current cell setup -!"
    L["PlaterPrompt"] = "Insert a Name for the New Plater Profile:"

    L["PressCtrlCToCopy"] = "Press Ctrl+C to copy" -- Added for Copy EditBox

    -- WeakAuras
    L["WeakAuraText"] = "Note: Scroll down if you cannot find what you want."
    L["Class WAs"] = "Class WAs" -- Renamed from ClassWA for clarity in separate page title
    L["Utility WAs"] = "Utility WAs" -- Added for separate page title
    L["NonClassWA"] = "Non-Class WeakAuras" -- Kept for potential backend use, though page title uses Utility WAs
    L["WeakAuraNotFound"] = "WeakAura not installed or has been renamed"
    -- All WA names are pulled from the import string, so cannot be translated

    -- MDT
    L["MDTHeader"] = "MDT Route Import"
    L["MDTText"] = "Here you can choose which MDT Routes you would like to import.\nAfter import, please /reload to ensure routes are imported properly!"
    L["MDTNotLoaded"] = "MDT Addon not loaded"
    L["PUG 'Push W' Routes"] = "PUG 'Push W' Routes"
    L["AdvRoutes"] = "Advanced Routes"
    -- All MDT Names are pulled from the import string, so cannot be translated

    -- Finish Page
    L["FinishHeader"] = "Congratulations!"
    L["FinishedText"] = [[
Keep Quazii UI FREE for you. Support at |cff00ffffpatreon.com/quazii|r

|cffffd700EXCLUSIVE PATREON PERKS|r
• |cffffffffQuazii M+ Dungeon Pack:|r Clean text & audio alerts for M+ mechanics
• |cffffffffQuazii Tankbuster Pack:|r Instant alerts for tank hits
• |cffffffffQuazii AoE CC Shotcaller:|r Shows next 3 party CCs for mob lockdown
• |cffffffffQuazii Mob Tankbuster CD:|r Exact countdown for tankbusters
• |cffffffffQuazii Mob AoE CD:|r Precise timer for party-wide AoE
• |cffffffffEarly Access:|r Alpha/Beta/PTR access to Plater & Class WAs
• |cffffffffPriority Quazii UI Hotline:|r Private Discord help from Quazii
• |cffffffffExtras:|r Ad-free podcast, credits, Discord roles & more
]]
end
