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
    L["Index"] = "Index"
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
        "This installer will take you through the steps needed to import and install all aspects of Quazii UI."
    L["WelcomeText2"] =
        "Each step can be considered optional, however, it is recommended to at least use ElvUI and Weakauras."
    L["WelcomeText3"] = "Let's get started!"

    -- Supported Addon Check
    L["SupportedAddonsHeader"] = "Quazii UI Homepage"
    L["SupportedAddonsText"] =
        "Below shows the addon profiles are supported by Quazii UI.\nIf you have the respective addon installed, you can proceed to import the profiles\n"
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

    -- WeakAuras
    L["WeakAuraText"] = "Here you can choose which WAs you would like to import or update."
    L["ClassWA"] = "Class WeakAuras"
    L["NonClassWA"] = "Non-Class WeakAuras"
    L["ClassWA"] = "Class WeakAuras"
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
    L["FinishedText"] = "You have reached the end of the installation!\nHave fun with your new UI!"
end
