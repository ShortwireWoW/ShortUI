IRTLocals = {};
local L = IRTLocals;
local addon = ...;

L.OPTIONS_TITLE = "Infinite Raid Tools";
L.OPTIONS_AUTHOR = "Author: " .. C_AddOns.GetAddOnMetadata(addon, "Author");
L.OPTIONS_VERSION = "Version: " .. C_AddOns.GetAddOnMetadata(addon, "Version");
L.OPTIONS_DIFFICULTY = "Difficulty:"
L.OPTIONS_ENABLED = "Enabled";

L.OPTIONS_POPUPSETTINGS_TEXT = "Popup Text Settings";
L.OPTIONS_FONTSIZE_TEXT = "Font size:";
L.OPTIONS_FONTSLIDER_BUTTON_TEXT = "Move Popup Text";

L.OPTIONS_VERSIONCHECK_TEXT = "Version Check Raid Members";
L.OPTIONS_VERSIONCHECK_BUTTON_TEXT = "Check Raiders";

L.OPTIONS_INFOBOXSETTINGS_TEXT = "Infobox Settings";
L.OPTIONS_INFOBOX_BUTTON_TEXT = "Move Infobox Text";

L.OPTIONS_RPAFSETTINGS_TEXT = "Private Aura Magic Settings";
L.OPTIONS_RPAF_BUTTON_TEXT = "Move Private Aura Magic";
L.OPTIONS_RPAF_LAYOUT_TEXT = "Group Layout";
L.OPTIONS_RPAF_ENABLED = "Show Private Aura Magic";
L.OPTIONS_RPAF_PRIORITY = "Set Private Aura Magic Priority";
L.OPTIONS_RPAF_PRIORITY_TITLE = "IRT:\nPrivate Aura Magic Priority";

L.OPTIONS_MINIMAP_CLICK = "Click to open the settings";
L.OPTIONS_MINIMAP_MODE_TEXT = "Show minimap button:";

L.OPTIONS_GENERAL_INFO = "This is the popup text that |cFF00FFFFInterrupt|r, |cFF00FFFFInnervate|r, |cFF00FFFFHuntsman Altimor|r, |cFF00FFFFHungering Destroyer|r, |cFF00FFFFLady Inerva Darkvein|r, |cFF00FFFFCouncil of Blood|r, |cFF00FFFFSludgefist|r and |cFF00FFFFStone Legion Modules|r are using. Move the popup to anywhere you want on your screen and change the size after your preference.";
L.OPTIONS_GENERALSETTINGS_TEXT = "General Settings:";
L.OPTIONS_GENERAL_TITLE = "General Options";
L.OPTIONS_RESETPOSITIONS_BUTTON = "Reset";
L.OPTIONS_RESETPOSITIONS_TEXT = "Reset To Default IRT Positions";

L.OPTIONS_INTERRUPT_TITLE = "Interrupt Module";
L.OPTIONS_INTERRUPT_INFO = "|cFF00FFFFInterrupt Module:|r Allows you to create interrupt orders then fill in the boss and the player ahead of you in interrupts. Once that player interrupts you get a popup informing you that you are next. You also get a text anchored to the nameplate showing you its your turn to interrupt and also shows that to everyone else in the raid. So if everyone in the interrupt order has the addon it becomes a real time interrupt order anchored to the nameplate. \n|cFF00FFFFUsage:|r Put the name of the person who is before you on interrupts.\n\n|cFF00FFFFConfig:|r The popup can be individually moved, resized and reset to default positions in the general options.";
L.OPTIONS_INTERRUPT_ORDER = "Player to track:";
L.OPTIONS_INTERRUPT_SOUND = "Plays sound when it is your turn to interrupt and when the cast is happening.";
L.OPTIONS_INTERRUPT_NEWROW = "Add Row";
L.OPTIONS_INTERRUPT_DELETEROW = "Remove Row";
L.OPTIONS_INTERRUPT_PREVIEW = "|cFFFFFFFFPreview of the popup that appears on your screen when it is your turn to interrupt and the text anchored to the nameplate of the mob that you are supposed to interrupt.|r";

L.OPTIONS_INNERVATE_TITLE = "Innervate Module";
L.OPTIONS_INNERVATE_INFO = "Tells your druid that you need innervate with a popup on your druids screen!\n|cFF00FFFFUsage:|r Macro: /irtinnervate PlayerName.\n\n|cFF00FFFFConfig:|r The popup can be individually moved, resized and reset to default positions in the general options.";
L.OPTIONS_INNERVATE_PREVIEW = "|cFFFFFFFFPreview of the popup that appears on the druids screen|r";

L.OPTIONS_INVITES_TITLE = "Raid Invite Module";
L.OPTIONS_INVITES_INFO = "Invites everyone of the selected guild ranks to a raid group by pressing the invite button or using /irt inv.";

L.OPTIONS_CALENDARNOTIFICATION_TITLE = "Calendar Notice Module";
L.OPTIONS_CALENDARNOTIFICATION_INFO = "On login a voice reads 'You have X amount of unanswered calendar invites' (only counting raid events). If you have no unanswered invites you get no notification.";

L.OPTIONS_BONUSROLL_TITLE = "Bonus Roll Module";
L.OPTIONS_BONUSROLL_INFO = "|cFF00FFFFNotification:|r Whenever you enter the latest raid a window is presented allowing you to tick the boxes of the bosses you want to coin and on which difficulty. Once a boss is killed that you have ticked a popup will show reminding you to use your bonus roll.\n|cFF00FFFFBLP:|r It also adds a BLP tracker to Blizzard's bonus roll frame, after 6 failed rolls you are guaranteed an item.\nModify the size and position of the popup text in the general settings!";
L.OPTIONS_BONUSROLL_PREVIEW = "|cFFFFFFFFPreview of the popup that appears and the BLP tracker:|r";

L.OPTIONS_READYCHECK_TITLE = "Ready Check Module";
L.OPTIONS_READYCHECK_INFO = "|cFF00FFFFRaiders:|r If you are in a raid and you are either AFK or decline a ready check you will get a button show up on your screen that will inform the raid that you are ready once you press it.\n|cFF00FFFFRaid leader(sender):|r If you have this enabled and send a ready check a list will show up of players that are AFK/not ready after the Blizzard ready check finished that updates in real time as the players presses their IRT ready button.";
L.OPTIONS_READYCHECK_PREVIEW = "|cFF00FFFFRaiders:|r\n|cFFFFFFFFPreview of the button that appears if you press not ready or AFK for a ready check.|r\n\n|cFF00FFFFRaid leader(sender):|r\n|cFFFFFFFFPreview of the list that appears for the players that pressed not ready or was AFK\nThe list updates in real time.|r";
L.OPTIONS_READYCHECK_FLASHING = "Flash IRT Ready Check Button \nWarning for those sensitive to pulsating light.";
L.OPTIONS_READYCHECK_WATCHER = "Show list of unready players even when you did not initiate the ready check.";

L.OPTIONS_CONSUMABLECHECK_TITLE = "Consumable Module";
L.OPTIONS_CONSUMABLECHECK_INFO = "|cFF00FFFFConsumable Check:|r Shows if the player has flask, weapon oil/sharpening stone, food and rune during the ready check. In addition classes that can buff can see if players are missing their buff.\nThe top picture is taken from a |cff3ec6eamage|r point of view, other classes would see their buff or none if they do not have any.\nThe bottom picture is taken from a |cfff38bb9paladin|r which can not buff and therefore no buffs are shown.\n\n|cFF00FFFFArmor kit/weapon oil buttons:|r When ready check is initiated two buttons appears allowing you to apply an armor kit and weapon oil/stones on your gear in a single click.\n|cFF00FFFFAppears when:|r a ready check is initiated or use /irtc.\n|cFF00FFFFDisapears when:|r a ready check finishes, you type /irtc or middle click the button.";
L.OPTIONS_CONSUMABLECHECK_SENDERREADYCHECK_TEXT = "|cFF00FFFFRaid leaders(senders):|r Show your own ready check to see your own consumable check"
L.OPTIONS_CONSUMABLECHECK_PREVIEW = "|cFFFFFFFFPreview of consumable check from |cff3ec6eaMage|r PoV (can buff) and |cfff38bb9Paladin|r PoV (cant buff). Also a preview of the armor kit/weapon oil/stone buttons, once mouseovering the actual buttons a tooltip appears with more info.|r";
L.OPTIONS_CONSUMABLECHECK_PREVIEW_BARTEXT_BUFF = "|T2057568:16|t|cFF00FF00132min|r |T463543:16|t|cFF00FF0057min|r |T3528447:16|t|cFF00FF002hrs|r |T136000:16|t|TInterface\\addons\\InfiniteRaidTools\\Res\\check:16|t |T134078:16|t|TInterface\\addons\\InfiniteRaidTools\\Res\\cross:16|t |T135932:16|t|cFF00FF0020/20|r";
L.OPTIONS_CONSUMABLECHECK_PREVIEW_BARTEXT_NOBUFF = "|T2057568:16|t|cFF00FF00132min|r |T463543:16|t|cFF00FF0057min|r |T3528447:16|t|cFF00FF002hrs|r |T136000:16|t|TInterface\\addons\\InfiniteRaidTools\\Res\\check:16|t |T134078:16|t|TInterface\\addons\\InfiniteRaidTools\\Res\\cross:16|t";

L.OPTIONS_CONSUMABLECHECK_AUTOBUTTONS_TEXT = "Show kit/oil buttons";

L.OPTIONS_RELEASE_TITLE ="Release Module";
L.OPTIONS_RELEASE_INFO = "Stops you from accidentally releasing inside of raids. Your release button will be hidden unless you hold down SHIFT.";
L.OPTIONS_RELEASE_PREVIEW = "|cFFFFFFFFPreview of the release button being hidden.";

L.OPTIONS_SUMMON_TITLE ="Summon Module";
L.OPTIONS_SUMMON_INFO = "Assigns players that are inside the raid to summon players outside that type '123', '1' or 'sum'.";
L.OPTIONS_SUMMON_PREVIEW = "|cFFFFFFFFPreview of the release button being hidden.";

L.OPTIONS_TERROS_TITLE = "Terros Module";
L.OPTIONS_TERROS_INFO = "Assigns players targeted by Awakened Earth to either left or right side split based on the custom amount set in the options and prioritizing melee right side and ranged left side. Each player gets a popup text where to go and starts announcing their position in say chat.";
L.OPTIONS_TERROS_PIE = "Pie ";
L.OPTIONS_TERROS_AMOUNT_OF_SOAKERS = "Amount of soakers right side";
L.OPTIONS_TERROS_PREVIEW = "|cFFFFFFFFPreview of the players announcing their position and the popup text|r";

L.OPTIONS_THEFORGOTTENEXPERIMENTS_TITLE = "The Forgotten Experiments Module";
L.OPTIONS_THEFORGOTTENEXPERIMENTS_INFO = "Shows a popup when the person before you has soaked the Temporal Fracture and informing you that you are next to soak. When the person soaks 2 or more Temporal Fractures it instead tells you to soak now.";
L.OPTIONS_THEFORGOTTENEXPERIMENTS_TRACKED_PLAYER = "Player soaking before you:";
L.OPTIONS_THEFORGOTTENEXPERIMENTS_PREVIEW = "|cFFFFFFFFPreview of the players announcing their position and the popup text|r";

L.OPTIONS_ECHOOFNELTHARION_TITLE = "Echo Of Neltharion Module";
L.OPTIONS_ECHOOFNELTHARION_INFO = "|cFF00FFFFNEW FEATURE!|r IRT PRIVATE AURA MAGIC. Which will popup a sorted raid frame before important private auras are applied which requires assignments. On Echo of Neltharion it will show up a few seconds before Volcanic Heart is applied, PAM will then show who has which ability and it will allow the Raid Leader / Assistants to interact with the it to make assignments. Left click assigns and right click unassigns incase of a missclick. For Echo of Neltharion you will assign players to a volcanic heart position which is another popup that shows where the 4 different debuffed players should go. The first person you click gets position 1, 2nd person position 2 and so on. The players assigned will see the map and a green circle on the one assigned to them.";
L.OPTIONS_ECHOOFNELTHARION_PREVIEW = "|cFFFFFFFFPreview of the players announcing their position and the popup text|r";

L.OPTIONS_KAZZRA_TITLE = "Kazzara Module";
L.OPTIONS_KAZZRA_INFO = "The purpose of this module is to make the marking of Ray of Anguish and Dread Rift players become more consistent pull over pull. Gives players debuffed with Ray of Anguish and Dread Rift a mark based on their raid index. Raid index is the position they have in the raid UI so group 1 player 2 is index 2 and group 3 position 1 is 16 for example. It also gives players a popup text telling them which mark to go to with these debuffs.";
L.OPTIONS_KAZZRA_PREVIEW = "|cFFFFFFFFPreview of the players announcing their position and the popup text|r";

L.OPTIONS_IGIRA_TITLE = "Igira Module";
L.OPTIONS_IGIRA_INFO = "This module will assign players affected by Blistering Spear to Star, Circle or Diamond. Melee are prioritized to star, then healer and lastly ranged. Players will yell which mark they are assigned and one of the two are also marked.";
L.OPTIONS_IGIRA_PREVIEW = "|cFFFFFFFFPreview of the players announcing their status and the popup text|r";

L.OPTIONS_COUNCILOFDREAMS_TITLE = "Council of Dreams Module";
L.OPTIONS_COUNCILOFDREAMS_INFO = "When affected by the Poisonous Javelin you can have a macro that does the command /irt councildispel which will create a popup text for everyone that can dispel poison inside the raid. Once dispelled the popup text will go away automatically.";
L.OPTIONS_COUNCILOFDREAMS_PREVIEW = "|cFFFFFFFFPreview of the players announcing their status and the popup text|r";
L.OPTIONS_COUNCILOFDREAMS_EXTRAS = "Show dispel popup even if your class cant dispel";

L.OPTIONS_VOLCOROSS_TITLE = "Volcoross Module";
L.OPTIONS_VOLCOROSS_INFO = "Assigns players with Coiling Flames to front left(star) or front right (circle) or back left (diamond) or back right (triangle) and once turned in to Coiling Eruption it assigns the rest of the raid evenly to soak. It also takes in to account which side players are on as well as prioritzing putting tanks and melee in the front then healers and lastly ranged.";
L.OPTIONS_VOLCOROSS_PREVIEW = "|cFFFFFFFFPreview of the debuffed players announcing and popup text on the left and on the right is the player soaking's announcements and popup text|r";

L.OPTIONS_NYMUE_TITLE = "Nymue Module";
L.OPTIONS_NYMUE_INFO = "Players affected by the Blossoming will yell their name to make it easy to call which of them should pass the matrix to spawn the effect on the ground.";
L.OPTIONS_NYMUE_PREVIEW = "|cFFFFFFFFPreview of the players announcing their status and the popup text|r";

L.OPTIONS_LARODAR_TITLE = "Larodar Module";
L.OPTIONS_LARODAR_INFO = "Everytime the boss casts Blazing Thorns all players with 1 or more stacks of Blazing Coalecence will say how many stacks they have in the chat for the next 8 seconds so that people around the target knows if they are a more eligible target for soaking.";
L.OPTIONS_LARODAR_PREVIEW = "|cFFFFFFFFPreview of the players announcing how many stacks they have in say|r";

L.OPTIONS_SMOLDERON_TITLE = "Smolderon Module";
L.OPTIONS_SMOLDERON_INFO = "By using a macro with the command /irt smolderonfixate the addon knows that you are targeted by the Seeking Inferno and will therefore put you in a priority list in the infobox based on if your role, putting melee first then healers and lastly ranged dps. It will also countdown for when it is safe for the next perrson to soak their orb.";
L.OPTIONS_SMOLDERON_PREVIEW = "|cFFFFFFFFPreview of the fixated players and their priority|r";

L.OPTIONS_TINDRALSAGESWIFT_TITLE = "Tindral Sageswift Module";
L.OPTIONS_TINDRALSAGESWIFT_INFO = "This module will assign players that can remove roots from other players (paladins/monks) to remove roots from players targeted by Fiery Growth and Mass Entaglement overlaps. It will prioritize that you help your self.";
L.OPTIONS_TINDRALSAGESWIFT_PREVIEW = "|cFFFFFFFFPreview of the infobox showing who should free who|r";
L.OPTIONS_TINDRALSAGESWIFT_EXTRAS = "Show assignments infobox even if your class cant free roots and you are not targeted";

L.OPTIONS_FYRAKK_TITLE = "Fyrakk Module";
L.OPTIONS_FYRAKK_INFO = "This module has multiple parts. For the intermission it will automatically assign everyone a position from Left 1 to 4, Mid, Right 1 to Right 4 and have 1 shadow and 1 flame player per spot. You can also type pre determined positions in the options below if you want to put 2 names in the same position just do so by putting a space between them i.e. Player1 Player2 Secondly whenever the Molten Eruption happens you get a button that you can press or you can use the macro /irt bossaction. The first player that presses it starts yelling cross raid mark and the second player that presses it starts yelling square raid mark. \n\n|cFF00FFFFNEW FEATURE!|r IRT PRIVATE AURA MAGIC. Which will popup a sorted raid frame before important private auras are applied which requires assignments. On Fyrakk it will show up a few seconds before the Shadow Cages and the Molten Eruptions are applied, PAM will then show who has which ability and it will allow the Raid Leader / Assistants to interact with the it to make assignments. Left click assigns and right click unassigns incase of a missclick. For Fyrakk have everyone start by standing on SQUARE and when Shadow Cages are applied press 2 of them which will give them a popup telling them to go to the CROSS raid marker. The 3rd and 4th click should on be Molten Eruption players. The 3rd person you click will get a popup on their screen telling them to free players on CROSS and will yell FREE CROSS while the 4th person you press will get the same popup and yell but for SQUARE. It will automatically reset before the next set of abilities. NO MACROS NEEDED";
L.OPTIONS_FYRAKK_PREVIEW = "|cFFFFFFFFPreview of the players announcing their status and the popup text|r";

L.OPTIONS_ULGRAX_TITLE = "Ulgrax the Devourer Module";
L.OPTIONS_ULGRAX_INFO = "When affected by the Digestive Venom you can have a macro that does the command /irt action which will create a popup text for everyone that can dispel poison inside the raid. Once dispelled the popup text will go away automatically.";
L.OPTIONS_ULGRAX_PREVIEW = "|cFFFFFFFFPreview of the dispeller's perspective and who should be dispelled text|r";
L.OPTIONS_ULGRAX_EXTRAS = "Show dispel popup even if your class cant dispel";

L.OPTIONS_SIKRAN_TITLE = "Sikran Module";
L.OPTIONS_SIKRAN_INFO = "Ahead of Phase Blades the Private Aura Magic Frame will show up if its enabled in the options and the order that the raid leader/assistant interacts with it will assign players numbers 1-4. The players affected will get a popup text and start announcing in say chat which number/assignment they got. IRT will also track who is targeted by Decimate and assign players to clear the adds on the left, right or be backup.";
L.OPTIONS_SIKRAN_PREVIEW = "|cFFFFFFFFPreview of the decimate positions and player saying their phase blade position|r";

L.OPTIONS_BROODTWISTER_TITLE = "Broodtwister Ovi'nax Module";
L.OPTIONS_BROODTWISTER_INFO = "When affected by Experimental Dosage players will automatically be assigned to star, circle, diamond or green prioritizing melee to star and circle. The players will get a popup text saying their position and start saying it in chat as well. These players should go to the world markers which should be placed down in advance by the raid leader to hatch the eggs. When affected by the Unstable Web you can have a macro that does the command /irt action which will create a popup text for everyone that can dispel poison inside the raid. Once dispelled the popup text will go away automatically.";
L.OPTIONS_BROODTWISTER_PREVIEW = "|cFFFFFFFFPreview of the dispeller's perspective and who should be dispelled text and previewing the popup text and you saying your position for Experimental Dosage|r";
L.OPTIONS_BROODTWISTER_EXTRAS = "Show dispel popup even if your class cant dispel";

L.OPTIONS_NEXUSPRINCESS_TITLE = "Ky'veza Module";
L.OPTIONS_NEXUSPRINCESS_INFO = "Ahead of Assassination the Private Aura Magic Frame will show up if its enabled in the options and the order that the raid leader/assistant interacts with it will assign players numbers a world marker star, circle, diamond, triangle, moon, square, cross, skull in that order. The players affected will get a popup text and start announcing in say chat which mark/assignment they got. IRT will also track who is targeted by Twilight Massacre and assign half the raid to go towards the entrance and the other half to the middle of the room making the shadows simply just swap position with each other.";
L.OPTIONS_NEXUSPRINCESS_PREVIEW = "|cFFFFFFFFPreview of the players announcing their assignment|r";

L.OPTIONS_SILKENCOURT_TITLE = "Silken Court Module";
L.OPTIONS_SILKENCOURT_INFO = "In phase 3 when you are affected by web binding you will be able to see who you are connected to. You can also select other players you want to track who they are connected to by adding their names below. Cross realm players are Player-Server";
L.OPTIONS_SILKENCOURT_PREVIEW = "|cFFFFFFFFPreview of the list of players affected by web bindings|r";
L.OPTIONS_SILKENCOURT_TRACKED = "Players to track for webs";

L.RELEASE_STATICPOPUP = "|cFFFF0000Hold shift to show the release button.";

L.INTERRUPT_NEXT = "|cFF00FF00Interrupt Next!";
L.INTERRUPT_NEXT2 = "|cFFFFFFFF Next!";
L.INTERRUPT_NEXT_POPUP = "NEXT INTERRUPT IS YOURS!";
L.INTERRUPT_ERROR1 = "|cFFFF0000IRT: Error in interrupt module|r ";
L.INTERRUPT_ERROR2 = " |cFFFF0000is not online or not in the raid.|r";
L.INTERRUPT_FILE = "Interrupt";

L.SUMMONING_ASSIST_PLAYER_1 = "Assist ";
L.SUMMONING_ASSIST_PLAYER_2 = " in summoning.";
L.SUMMONING_SUMMON_PLAYER = "Summon ";

L.RAIDINVITE_NOT_OFFICER = "IRT: Missing Permissions! This feature is reserved for officers of the guild only, to prevent it from being abused.";

L.POPUP_FILE = "Popup";

L.INNERVATE_FILE = "Innervate";

L.BOSS_FILE = "BossMod";

L.ERROR_ADDON_MESSAGE_WHISPER = "IRT: There was an error on Blizzards end sending addon message. Response: ";

L.WARNING_OUTOFDATEMESSAGE = "There is a newer version of Infinite Raid Tools available on overwolf/curseforge!";
L.WARNING_RESETPOSITIONS_DIALOG = "Are you sure you want to reset IRT: minimap, popup, infobox, kit/oil button positions?";
L.WARNING_DELETE_OLD_FOLDER = "|cFFFFFFFFHello dear |r|cFF00FFFFEndless Raid Tools|r|cFFFFFFFF user!\n|cFF00FFFFEndless Raid Tools|r |cFFFFFFFFhas changed name to |r|cFF00FFFFInfinite Raid Tools|r, |cFF00FFFF/enrt|r |cFFFFFFFFwill still work for now but will eventually be removed, the new command is: |cFF00FFFF/irt|r.\n|cFFFF0000Please delete the|r |cFF00FFFFEndless Raid Tools|r |cFFFF0000folder to avoid possible bugs and interference.|r \n|cFFFFFFFFThe folder can be found from your WoW installation then _retail_/Interface/AddOns/EndlessRaidTools\n Thank you for using|r |cFF00FFFFInfinite Raid Tools|r|cFFFFFFFF! Coming in Shadowlands: Consumable Check update and 6 new boss modules for Castle Nathria!|r\n |cFFFF0000Auto-disabling old |r|cFF00FFFFEndless Raid Tools|r|cFFFF0000 for now, new|r |cFF00FFFFInfinite Raid Tools|r |cFFFF0000will still be loaded. Please hit reload ui.|r";