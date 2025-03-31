-- Localization file for German/Germany
local L = LibStub("AceLocale-3.0"):NewLocale("QuaziiUI", "deDE", false, true)

if L then
    -- Generic
    L["AddonName"] = "Quazii UI"
    L["Tank"] = "Tank"
    L["DPS"] = "DPS"
    L["Healer"] = "Heiler"
    L["Import"] = "Importieren"
    L["Imports"] = "Importe"
    L["Next"] = "Weiter"
    L["Index"] = "Index"
    L["Prev"] = "Zurück" --Shorthand for Previous
    L["Back"] = "Zurück"
    L["GoToPage"] = "Zur Seite gehen"
    L["Icon"] = "Symbol"
    L["Name"] = "Name"
    L["Update"] = "Update benötigt?"
    L["Version"] = "Version"
    L["LeftClickOpen"] = "Linksklick: Installer öffnen"

    L["NA"] = "N/V"
    L["Yes"] = "Ja"
    L["No"] = "Nein"
    L["True"] = "Wahr"
    L["False"] = "Falsch"

    -- Import Frame
    L["ImportProfileText"] = " Profil:"
    L["ImportLastImportText"] = "Letzter Importzeitpunkt:"

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
        "Dieser Installer führt Sie durch die Schritte, die zum Importieren und Installieren aller Aspekte von Quazii UI erforderlich sind."
    L["WelcomeText2"] =
        "Jeder Schritt kann als optional betrachtet werden, es wird jedoch empfohlen, mindestens ElvUI und WeakAuras zu verwenden."
    L["WelcomeText3"] = "Lass uns beginnen!"

    -- Supported Addon Check
    L["SupportedAddonsHeader"] = "Quazii UI Startseite"
    L["SupportedAddonsText"] =
        "Unten sehen Sie die Addon-Profile, die von Quazii UI unterstützt werden.\nWenn Sie das jeweilige Addon installiert haben, können Sie mit dem Import der Profile fortfahren\n"
    L["SupportedAddonsTable1stHeader"] = "Unterstützte|r Addons"
    L["SupportedAddonsTable2ndHeader"] = "Aktiviert"
    L["SupportedAddonsTable3rdHeader"] = "Installierte Version"

    -- ElvUI / UI Scale
    L["ElvUIHeader"] = "ElvUI Importe"
    L["ElvUIText"] =
        "Hier können Sie |cQHCHQuaziis|r ElvUI-Profile importieren oder aktualisieren.\n|cQHCHHINWEIS:|r Wenn Sie mehrere Profile importieren, können Sie in den Profileinstellungen von ElvUI wechseln."
    L["CellNotice"] = "Cell-Benutzer besuchen Sie https://quazii.com\nfür das Cell-kompatible Profil."
    L["UIScaleHeader"] = "UI-Skalierung"
    L["UIScaleText"] =
        "Passen Sie unten Ihre UI-Skalierung an.\nWenn die Benutzeroberfläche seltsam aussieht oder zu groß/klein ist, möchten Sie vielleicht eine andere Einstellung ausprobieren."
    L["CurrentUIScale"] = "Aktuelle UI-Skalierung"
    L["ScaleButtonAuto"] = "Auto"
    L["ScaleButtonSmall"] = "Klein"
    L["ScaleButtonMedium"] = "Mittel"
    L["ScaleButtonLarge"] = "Groß"

    
    -- Addon Import Messages
    -- @ UNTRANSLATED @ --
    L["BigWigsNameplateDisable"] = "Would you like to disable BigWigs Nameplate CDs?"
    L["DetailsPrompt"] = "Geben Sie einen Namen für das neue Details-Profil ein:"
    local AddonImportMessage = "Sind Sie sicher, dass Sie das ADDONNAME-Profil importieren möchten?"
    L["OmniCDPrompt"] = AddonImportMessage:gsub("ADDONNAME", "OmnicD")
    L["CellPrompt"] = AddonImportMessage:gsub("ADDONNAME", "Cell") .. "\n!- Dies überschreibt Ihre aktuelle Cell-Einrichtung -!"
    L["PlaterPrompt"] = "Geben Sie einen Namen für das neue Plater-Profil ein:"

    -- WeakAuras
    L["WeakAuraText"] = "Hier können Sie auswählen, welche WeakAuras Sie importieren oder aktualisieren möchten."
    L["ClassWA"] = "Klassen-WeakAuras"
    L["NonClassWA"] = "Nicht-Klassen-WeakAuras"
    L["ClassWA"] = "Klassen-WeakAuras"
    L["WeakAuraNotFound"] = "WeakAura nicht installiert oder wurde umbenannt"

    -- MDT
    L["MDTHeader"] = "MDT-Routen-Import"
    L["MDTText"] = "Hier können Sie auswählen, welche MDT-Routen importiert werden sollen.\nBitte /reload nach dem Import, um sicherzustellen, dass die Routen importiert wurden!"
    L["MDTNotLoaded"] = "MDT-Addon nicht geladen"
    L["PUG 'Push W' Routes"] = "PUG 'Push W' Routen"
    L["AdvRoutes"] = "Fortgeschrittene Routen"

    -- Finish Page
    L["FinishHeader"] = "Glückwunsch!"
    L["FinishedText"] = "Sie haben das Ende der Installation erreicht!\nViel Spaß mit Ihrer neuen Benutzeroberfläche!"
end