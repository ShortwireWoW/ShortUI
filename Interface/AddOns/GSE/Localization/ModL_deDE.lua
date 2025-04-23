if GetLocale() ~= "deDE" then
    return
end

local L = LibStub("AceLocale-3.0"):NewLocale("GSE", "deDE", false)

-- Options translation
L[" was imported."] = " wurde importiert."
L["%s/255 Characters Used"] = "%s/255 Zeichen verwendet"
L[", You will need to correct errors in this variable from another source."] = ", Du musst Fehler in dieser Variable aus einer anderen Quelle korrigieren."
L["Account Macros"] = "Account Makros"
L["Action Type"] = "Aktionstyp"
--[[Translation missing --]]
L["Actionbar Buttons"] = "Actionbar Buttons"
--[[Translation missing --]]
L["Actionbar Overrides"] = "Actionbar Overrides"
L["Add Special KeyBinding"] = "Spezielle Tastenkombination hinzufügen"
L["Add Talent Loadout"] = "Talent Ausrüstungen hinzufügen"
L["Advanced Export"] = "Erweiterter Export"
L["All Talent Loadouts"] = "Alle Talent Ausrüstungen"
L["Already Known"] = "Bereits bekannt"
--[[Translation missing --]]
L["Button State"] = "Button State"
--[[Translation missing --]]
L["CHanges Left Side, Changes Right Side, Many Changes!!!! Handle It"] = "CHanges Left Side, Changes Right Side, Many Changes!!!! Handle It"
L["Changes Left Side, Changes Right Side, Many Changes!!!! Handle It!"] = "Änderungen auf der linken Seite, Änderungen auf der rechten Seite, viele Änderungen!!!! Komm damit klar!"
L["Character Macros"] = "Charakter Makros"
L["Chat Link"] = "Chat Link"
L["Command Colour"] = "Befehlsfarbe"
L["Compiled Macro"] = "Kompiliertes Makro"
L["Conditionals Colour"] = "Konditionale Farbe"
L["Create a new macro in the /macro interface and assign it an Icon. Then reopen this menu.  You cannot create a new macro here but after it has been created you can manage it."] = "Erstelle ein neues Makro in der /macro-Oberfläche und weisen Sie ihm ein Symbol zu. Öffne anschließend dieses Menü erneut. Du kannst hier kein neues Makro erstellen, aber nachdem es erstellt wurde, können Sie es verwalten."
L["Create Human Readable Exports"] = "Erstelle menschenlesbare Exporte"
L["Current Value"] = "Aktueller Wert"
--[[Translation missing --]]
L["Default"] = "Default"
L["Default Keybinding Height"] = "Standart Tastenbelegungshöhe"
L["Default Keybinding Width"] = "Standart Tastenbelegungsbreite"
--[[Translation missing --]]
L["Disable inbuilt LibActionButton"] = "Disable inbuilt LibActionButton"
L["Disable Sequence"] = "Sequenz ausschalten"
L["Do not compile this Sequence at startup."] = "Kompilieren Sie diese Sequenz nicht beim Start."
L["Enable Mod Debug Mode"] = "Mod-Debug-Modus einschalten"
L["Enter the implementation link for this variable. Use '= true' or '= false' to test."] = "Gebe den Implementierungslink für diese Variable ein. Verwende zum Testen „= true“ oder „= false“."
--[[Translation missing --]]
L["Experimental Features"] = "Experimental Features"
L["Export Variable"] = "Variable exportieren"
L["Gnome Sequencer Enhanced"] = "Gnome Sequencer Enhanced"
L["GSE allows plugins to load Collections as plugins.  You can reload a collection by pressing the button below."] = "GSE ermöglicht es Plugins, Sammlungen als Plugins zu laden. Sie können eine Sammlung neu laden, indem Sie die folgende Schaltfläche drücken."
L["GSE Discord"] = "GSE Discord"
L["GSE has a LibDataBroker (LDB) data feed.  Set this option to show queued Out of Combat events in the tooltip."] = "GSE hat einen LibDataBroker (LDB) Datenfeed. Setze diese Option, um in der Warteschlange befindliche \"Out of Combat\"-Ereignisse im Tooltip anzuzeigen."
L["GSE: Export"] = "GSE: Exportieren"
L["GSE: Main Menu"] = "GSE: Hauptmenü"
--[[Translation missing --]]
L["GSE: Middle Click to open the Keybinding Interface"] = "GSE: Middle Click to open the Keybinding Interface"
L["GSE: Record your rotation to a macro."] = "GSE: Zeichne Deine Rotation in einem Makro auf."
L["GSE: Whats New in "] = "GSE: Was ist neu in"
L["How many pixels high should Keybindings start at.  Defaults to 500"] = "Bei welcher Höhe sollten Tastenkombinationen beginnen? Der Standardwert ist 500."
L["How many pixels wide should Keybinding start at.  Defaults to 700"] = "Bei welcher Breite soll die Tastenkombination beginnen? Der Standardwert ist 700"
L["How many times does this action repeat"] = "Wie oft wird diese Aktion wiederholt?"
L["Implementation Link"] = "Implementierungslink"
L["Import Macro from Forums"] = "Makros aus dem Forum importieren"
L["Insert Gamepad KeyBind"] = "Gamepad-Tastenbelegung einfügen"
L["Insert GSE Sequence"] = "GSE-Sequenz einfügen"
L["Insert GSE Variable"] = "GSE-Variable einfügen"
L["Insert Mouse KeyBind"] = "Maus-Tastenbelegung einfügen"
L["Insert Spell"] = "Zauber einfügen"
L["Insert Test Case"] = "Testfall einfügen"
L["Item"] = "Gegenstand"
L["Keybind"] = "Tastenbelegung"
L["Keybindings"] = "Tastenbelegungen"
L["Last Updated"] = "Zuletzt aktualisiert"
L["Left Mouse Button"] = "Linke Maustaste"
--[[Translation missing --]]
L["LibActionButton is used by ConsolePort and Bartender.  Disabling this will use the standard version of this library."] = "LibActionButton is used by ConsolePort and Bartender.  Disabling this will use the standard version of this library."
L["Macro"] = "Makro"
L["Macro Name"] = "Makroname"
L["Macro Name or Macro Commands"] = "Makroname oder Makrobefehle"
L["Macro Template"] = "Makro Vorlage"
L["Macros"] = "Makros"
L["Manage Keybinds"] = "Tastenbelegung verwalten"
L["Manage Macro"] = "Makro verwalten"
L["Manage Macro with GSE"] = "Makros mit GSE verwalten"
L["Manage Macros"] = "Makros verwalten"
L["Manage Variables"] = "Variablen verwalten"
--[[Translation missing --]]
L["Missing Variable "] = "Missing Variable "
--[[Translation missing --]]
L["modified in other window.  This view is now behind the current sequence."] = "modified in other window.  This view is now behind the current sequence."
--[[Translation missing --]]
L["New Actionbar Override"] = "New Actionbar Override"
--[[Translation missing --]]
L["New KeyBind"] = "New KeyBind"
--[[Translation missing --]]
L["New Sequence"] = "New Sequence"
--[[Translation missing --]]
L["New Variable"] = "New Variable"
L["Not Yet Active"] = "Noch nicht aktiv"
--[[Translation missing --]]
L["Open %s in New Window"] = "Open %s in New Window"
L["Party"] = "Party"
L["Pet"] = "Begleiter"
L["Pet Ability"] = "Begleiter Fähigkeit"
L["Print Active Modifiers on Click"] = "Aktive Modifikatoren per Klick drucken"
L["Processing Collection of %s Elements."] = "Sammlung von %s Elementen wird verarbeitet."
L["Repeat"] = "Wiederholung"
L["Report an Issue"] = "Ein Problem melden"
L["Right Mouse Button"] = "Rechte Maustaste"
L["Save pending for "] = "Speichern ausstehend für"
L["Save the changes made to this variable."] = "Speicher die an dieser Variable vorgenommenen Änderungen."
L["Saved"] = "Gespeichert"
--[[Translation missing --]]
L["Select Icon"] = "Select Icon"
L["Sequences"] = "Sequenzen"
L["Set Key to Bind"] = "Zum Binden die Taste festlegen"
L["Show next time you login."] = "Bei der nächsten Anmeldung anzeigen."
L["Spell"] = "Zauber"
L["Store output of debug messages in a Global Variable that can be referrenced by other mods."] = "Speichert die Ausgabe von Debug-Meldungen in einer globalen Variable, die von anderen Mods referenziert werden kann."
L["String Colour"] = "String Farbe"
L["Talent Loadout"] = "Talent Ausrüstung"
L["The author of this Macro."] = "Der Autor dieses Makros."
L["The author of this Variable."] = "Der Autor dieser Variable."
L["The UI has been set to KeyDown configuration.  The /click command needs to be `/click TEMPLATENAME LeftButton t` (Note the 't' here is required along with the LeftButton.)  You will need to check your macros and adjust your click commands."] = "Die Benutzeroberfläche wurde auf KeyDown-Konfiguration eingestellt. Der /click-Befehl benötigt `/click TEMPLATENAME LeftButton t` (Beachte 't' hier zusammen mit dem LeftButton erforderlich ist.) Du musst Ihre Makros überprüfen und Ihre Klickbefehle anpassen."
L["The UI has been set to KeyUp configuration.  The /click command needs to be `/click TEMPLATENAME` You will need to check your macros and adjust your click commands."] = "Die Benutzeroberfläche wurde auf KeyUp-Konfiguration eingestellt. Der /click-Befehl muss `/click TEMPLATENAME` lauten. Du musst Deine Makros überprüfen und Deine Klickbefehle anpassen."
--[[Translation missing --]]
L["There is an error in the sequence that needs to be corrected before it can be saved."] = "There is an error in the sequence that needs to be corrected before it can be saved."
L["There was an error processing "] = "Bei der Verarbeitung ist ein Fehler aufgetreten"
L["This macro is not compatible with this version of the game and cannot be imported."] = "Dieses Makro ist nicht mit dieser Spielversion kompatibel und kann nicht importiert werden."
L["This option dumps extra trace information to your chat window to help troubleshoot problems with the mod"] = "Diese Option gibt zusätzliche Trace-Informationen im Chat-Fenster aus, um Probleme mit dem Mod zu beheben"
L["This version of GSE is incompatabile with this version of the game."] = "Diese Version von GCSE ist mit dieser Version des Spiels nicht kompatibel."
L["Toy"] = "Spielzeug"
L["Unit Name"] = "Einheiten Name"
L["Use WLM Export Sequence Format"] = "Verwende das WLM-Exportsequenzformat "
L["Variable"] = "Variable"
L["Variable Menu"] = "Variablenmenü"
--[[Translation missing --]]
L["WhatsNew"] = "|cFFFFFFFFGS|r|cFF00FFFFE|r 3.2.28 changes the import and export strings.  Each GSE import will now start with !GSEx! where the x shows the version number going forward.  https://wago.io/gse has been updated toi handle these new import strings and wago.io exports will switch to exporting these style strings around 11.2.  These new strings will be picked up by the classic variants when they are next updated by Blizzard.  As always details are in Discord."
L["When creating a macro, if there is not a personal character macro space, create an account wide macro."] = "Wenn beim Erstellen eines Makros kein persönlicher Zeichenmakrobereich vorhanden ist, erstelle Accountweites Makro."
L["When exporting from GSE create a descriptive export for Discord/Discource forums."] = "Erstellen Sie beim Exportieren aus GSE einen beschreibenden Export für Discord/Discource-Foren."
L["When loading or creating a sequence, if it is a macro of the same class automatically create the Macro Stub"] = "Beim Laden oder Erstellen einer Sequenz, wenn es sich um ein Makro derselben Klasse handelt, wird automatisch der Makro Stub erstellt."
--[[Translation missing --]]
L["You cannot open a new Sequence Editor window while you are in combat.  Please exit combat and then try again."] = "You cannot open a new Sequence Editor window while you are in combat.  Please exit combat and then try again."


