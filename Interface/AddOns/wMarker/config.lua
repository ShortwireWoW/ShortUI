-- Localization
local L = wMarkerLocales

-------------------------------------------------------
-- Ace Options Table
-------------------------------------------------------

wMarkerAce = LibStub("AceAddon-3.0"):GetAddon("wMarker")
local config = wMarkerAce:NewModule("wMarkerConfig", "AceEvent-3.0");
local dbRaid, dbWorld, dbFLoc = nil
wMarkerDB = nil
wFlaresDB = nil

function config:OnInitialize()
	dbRaid = wMarkerAce.db.profile.raid
	dbWorld = wMarkerAce.db.profile.world
	dbFLoc = wMarkerAce.db.profile.frameLoc

	--Look for old configs, Pre-Ace
	wMarkerDB = wMarkerDB or {}
	wFlaresDB = wFlaresDB or {}

	wMarkerAce.db.RegisterCallback(wMarkerAce, "OnProfileReset", "ConfigCheck")
	wMarkerAce.db.RegisterCallback(wMarkerAce, "OnProfileChanged","ConfigCheck")
	wMarkerAce.db.RegisterCallback(wMarkerAce, "OnProfileCopied","ConfigCheck")

	wMarkerAce:RegisterChatCommand("wmarker","SlashInput")
	wMarkerAce:RegisterChatCommand("wma","SlashInput")
	wMarkerAce:RegisterChatCommand("rc", "SlashReadyCheck")
	wMarkerAce:RegisterChatCommand("roc", "SlashRoleCheck")

	wMarkerAce:RegisterEvent("GROUP_ROSTER_UPDATE","EventHandler")
	wMarkerAce:RegisterEvent("RAID_ROSTER_UPDATE","EventHandler")
	wMarkerAce:RegisterEvent("PLAYER_TARGET_CHANGED","EventHandler")
	wMarkerAce:RegisterEvent("PLAYER_REGEN_ENABLED","EventHandler")

	wMarkerAce.db.global.lastVer = C_AddOns.GetAddOnMetadata("wMarker","Version")
end

function config:OnEnable()
	--Apply saved configs
	wMarkerAce:ConfigCheck()

end

function config:OnDisable()

	wMarkerAce.db.UnregisterAllCallbacks(wMarkerAce)

	wMarkerAce:UnregisterChatCommand("wmarker","SlashInput")
	wMarkerAce:UnregisterChatCommand("wma","SlashInput")
	wMarkerAce:UnregisterChatCommand("rc", "SlashReadyCheck")
	wMarkerAce:UnregisterChatCommand("roc", "SlashRoleCheck")

	wMarkerAce:UnregisterEvent("GROUP_ROSTER_UPDATE","EventHandler")
	wMarkerAce:UnregisterEvent("RAID_ROSTER_UPDATE","EventHandler")
	wMarkerAce:UnregisterEvent("PLAYER_TARGET_CHANGED","EventHandler")
	wMarkerAce:UnregisterEvent("PLAYER_REGEN_ENABLED","EventHandler")
end

function wMarkerAce:ConfigCheck()
	dbRaid = wMarkerAce.db.profile.raid
	dbWorld = wMarkerAce.db.profile.world
	dbFLoc = wMarkerAce.db.profile.frameLoc

	-- Check if old configs exist, if not yet imported, complete the import
	if (wMarkerDB.locked ~= nil) and (wMarkerAce.db.global.imported == false or wMarkerAce.db.global.imported == nil) then wMarkerAce:ConfigImport() end

	-- Check for old loc exists in Ace, if yes, use these points and nil them
	if (dbRaid.point) then wMarkerAce.raidMain:ClearAllPoints(); wMarkerAce.raidMain:SetPoint(dbRaid.point, "UIParent", dbRaid.relPt, dbRaid.x, dbRaid.y); wMarkerAce:getLoc(wMarkerAce.raidMain); dbRaid.point, dbRaid.relPt, dbRaid.x, dbRaid.y = nil end
	if (dbRaid.vertical) then dbRaid.numCols = 1; dbRaid.vertical = false end --Convert the old 'vertical' setting to columns of 1
	wMarkerAce:setLoc(wMarkerAce.raidMain)
	wMarkerAce:setLoc(wMarkerAce.raidMain.controlFrame)
	if (dbWorld.point) then wMarkerAce.worldMain:ClearAllPoints(); wMarkerAce.worldMain:SetPoint(dbWorld.point, "UIParent", dbWorld.relPt, dbWorld.x, dbWorld.y); wMarkerAce:getLoc(wMarkerAce.worldMain); dbWorld.point, dbWorld.relPt, dbWorld.x, dbWorld.y = nil end
	if (dbWorld.vertical) then dbWorld.numCols = 1; dbWorld.vertical = false end --Convert the old 'vertical' setting to columns of 1
	wMarkerAce:setLoc(wMarkerAce.worldMain)

	wMarkerAce:updateControlFrameLock()

	wMarkerAce.raidMain:SetScale(dbRaid.scale)
	wMarkerAce.raidMain:SetAlpha(dbRaid.alpha)

	wMarkerAce.worldMain:SetScale(dbWorld.scale)
	wMarkerAce.worldMain:SetAlpha(dbWorld.alpha)

	wMarkerAce:updateClamp()
	wMarkerAce:updateVisibility()
	wMarkerAce:updateLock()
	wMarkerAce:backgroundVisibility()

	wMarkerAce:raidButtonsLayout()
	wMarkerAce:controlButtonsLayout()
	wMarkerAce:worldButtonsLayout()
	

	wMarkerAce:worldRetext(dbWorld.worldTex)
end

function wMarkerAce:ConfigImport()	
	local oldwDB = wMarkerDB
	local oldfDB = wFlaresDB
	dbRaid.locked = oldwDB.locked
	dbRaid.clamped = oldwDB.clamped
	dbRaid.shown = oldwDB.shown
	dbRaid.flipped = oldwDB.flipped
	dbRaid.vertical = oldwDB.vertical
	dbRaid.partyShow = oldwDB.partyShow
	dbRaid.targetShow = oldwDB.targetShow
	dbRaid.assistShow = oldwDB.assistShow
	dbRaid.bgHide = oldwDB.bgHide
	dbRaid.tooltips = oldwDB.tooltips
	dbRaid.iconSpace = oldwDB.iconSpace
	dbRaid.scale = oldwDB.scale
	dbRaid.alpha = oldwDB.alpha
	dbFLoc["wMarkerRaid"] = {"CENTER", "UIParent", oldwDB.relPt, oldwDB.x, oldwDB.y}

	dbWorld.locked = oldfDB.locked
	dbWorld.clamped = oldfDB.clamped
	dbWorld.shown = oldfDB.shown
	dbWorld.flipped = oldfDB.flipped
	dbWorld.vertical = oldfDB.vertical
	dbWorld.partyShow = oldfDB.partyShow
	dbWorld.targetShow = oldfDB.targetShow
	dbWorld.assistShow = oldfDB.assistShow
	dbWorld.bgHide = oldfDB.bgHide
	dbWorld.tooltips = oldfDB.tooltips
	dbWorld.scale = oldfDB.scale
	dbWorld.alpha = oldfDB.alpha
	dbFLoc["wMarkerWorld"] = {"CENTER", "UIParent", oldfDB.relPt, oldfDB.x, oldfDB.y}

	wMarkerAce.db.global.imported = true
	wMarkerDB = nil
	wFlaresDB = nil
	wMarkerAce:Print("Configurations imported from legacy wMarker")
end

wMarkerAce.options = {
	name = "wMarker",
	handler = wMarkerAce,
	type = 'group',
	args = {
		raidMarkers = {
			type = 'group',
			name = L["Raid marker"],
			order = 10,
			width = "full",
			args = {
				raidMarkersText = {
					type = "description",
					name = (wMarkerAce.titleText.." - "..L["Raid marker"]),
					fontSize = "large",
					width = "full",
					order = 0,
				},
				spacer = {
					type = "description",
					name = "",
					fontSize = "large",
					width = "full",
					order = 1,
				},
				showCheck = {
					type = "toggle",
					name = L["Show frame"],
					set = function(info) dbRaid.shown = not dbRaid.shown; wMarkerAce:updateVisibility() end,
					get = function(info) return dbRaid.shown end,
					order = 5,
					width = "full",
				},
				lockCheck = {
					type = "toggle",
					name = L["Lock frame"],
					set = function(info) dbRaid.locked = not dbRaid.locked; wMarkerAce:updateLock() end,					
					get = function(info) return dbRaid.locked end,
					order = 10,
				},
				clampCheck = {
					type = "toggle",
					name = L["Clamp to screen"],
					set = function(info) dbRaid.clamped = not dbRaid.clamped; wMarkerAce:updateClamp() end,
					get = function(info) return dbRaid.clamped end,
					order = 15,
				},
				reverseCheck = {
					type = "toggle",
					name = L["Reverse icons"],
					set = function(info) dbRaid.flipped = not dbRaid.flipped; wMarkerAce:raidButtonsLayout() end,
					get = function(info) return dbRaid.flipped end,
					order = 20,
				},				
				vertCheck = {
					type = "toggle",
					name = L["Display vertically"],
					set = "raidVertToggle",
					get = function(info) return dbRaid.vertical end,
					order = 25,
					hidden = true,
				},
				aloneCheck = {
					type = "toggle",
					name = L["Hide when alone"],
					set = function(info) dbRaid.partyShow = not dbRaid.partyShow; wMarkerAce:updateVisibility() end,
					get = function(info) return dbRaid.partyShow end,
					order = 30,
				},
				targetCheck = {
					type = "toggle",
					name = L["Show only with a target"],
					set = function(info) dbRaid.targetShow = not dbRaid.targetShow; wMarkerAce:updateVisibility() end,
					get = function(info) return dbRaid.targetShow end,
					order = 35,	
				},
				assistCheck = {
					type = "toggle",
					name = L["Hide without assist (in a raid)"],
					set = function(info) dbRaid.assistShow = not dbRaid.assistShow; wMarkerAce:updateVisibility() end,
					get = function(info) return dbRaid.assistShow end,
					order = 40,
					width = "full"
				},
				hideBGCheck = {
					type = "toggle",
					name = L["Hide background"],
					set = function(info) dbRaid.bgHide = not dbRaid.bgHide; wMarkerAce:backgroundVisibility() end,
					get = function(info) return dbRaid.bgHide end,
					order = 45,
				},
				hideBorderCheck = {
					type = "toggle",
					name = L["Hide border"],
					set = function(info) dbRaid.borderHide = not dbRaid.borderHide; wMarkerAce:backgroundVisibility() end,
					get = function(info) return dbRaid.borderHide end,
					order = 46,
				},
				tooltipsCheck = {
					type = "toggle",
					name = L["Enable tooltips"],
					set = function(info) dbRaid.tooltips = not dbRaid.tooltips end,
					get = function(info) return dbRaid.tooltips end,
					order = 50,
					width = "full",
				},			
				scaleSlider = {
					type = "range",
					name = "Scale",
					min = 0.5,
					max = 2,
					step = 0.05,
					isPercent = true,
					set = function(info, input) dbRaid.scale = input; wMarkerAce.raidMain:SetScale(input) end,
					get = function(info) return dbRaid.scale end,
					order = 55
				},
				alphaSlider = {
					type = "range",
					name = "Transparency",
					min = 0,
					max = 1,
					step = 0.05,
					isPercent = true,
					set = function(info, input) dbRaid.alpha = input; wMarkerAce.raidMain:SetAlpha(input) end,
					get = function(info) return dbRaid.alpha end,
					order = 60
				},
				spacingSlider = {
					type = "range",
					name = L["Icon spacing"],
					min = -5,
					max = 15,
					step = 1,
					set = function(info, input) dbRaid.iconSpace = input; wMarkerAce:raidButtonsLayout(); wMarkerAce:controlButtonsLayout() end,
					get = function(info) return dbRaid.iconSpace end,
					order = 65
				},
				numColsSlider = {
					type = "range",
					name = L["Icon Columns"],
					min = 1,
					max = 8,
					step = 1,
					set = function(info, input) dbRaid.numCols = input; wMarkerAce:raidButtonsLayout() end,
					get = function(info) return dbRaid.numCols end,
					order = 70
				},
				controlFrameHeaderSpacer = {
					type = "description",
					name = " ",
					fontSize = "medium",
					order = 79,
				},
				controlFrameHeader = {
					type ="header",
					name = L["Control Frame"],
					width = "full",
					order = 80,
				},
				controlFrameToggle = {
					type = "toggle",
					name = "Enable Control Frame",
					set = function(info) dbRaid.control_frameEnabled = not dbRaid.control_frameEnabled; wMarkerAce:updateVisibility() end,
					get = function(info) return dbRaid.control_frameEnabled end,
					order = 81,
				},
				lockControlToMain = {
					type = "toggle",
					name = L["Lock frames together"],
					set = function(info) dbRaid.lockControlFrame = not dbRaid.lockControlFrame; wMarkerAce:updateControlFrameLock() end,
					get = function(info) return dbRaid.lockControlFrame end,
					order = 82,
				},	
				controlButtonsSpacer = {
					type = "description",
					name = " ",
					fontSize = "medium",
					order = 83,
				},
				controlFrameButtonsHeader = {
					type="description",
					name = ("|cffffd700"..L["Control Buttons"]),
					fontSize = "medium",
					width="full",
					order = 84,
				},
				controlFrame_clearToggle = {
					type = "toggle",
					name = L["Clear mark"].." |Tinterface\\addons\\wMarker\\img\\icon_clear.tga:14:14|t",
					set = function(info) dbRaid.control_clearButtonEnabled = not dbRaid.control_clearButtonEnabled; wMarkerAce:controlButtonsLayout() end,
					get = function(info) return dbRaid.control_clearButtonEnabled end,
					order = 85,
				},
				controlFrame_readyToggle = {
					type = "toggle",
					name = L["Ready check"].." |Tinterface\\raidframe\\readycheck-waiting:14:14|t",
					set = function(info) dbRaid.control_readyButtonEnabled = not dbRaid.control_readyButtonEnabled; wMarkerAce:controlButtonsLayout() end,
					get = function(info) return dbRaid.control_readyButtonEnabled end,
					order = 86,
				},
				controlFrame_roleCheckToggle = {
					type = "toggle",
					name = L["Role check"].." |Tinterface\\addons\\wMarker\\img\\icon_roleCheck.tga:14:14|t",
					set = function(info) dbRaid.control_roleButtonEnabled = not dbRaid.control_roleButtonEnabled; wMarkerAce:controlButtonsLayout() end,
					get = function(info) return dbRaid.control_roleButtonEnabled end,
					order = 87,
				},
				controlFrame_timerToggle = {
					type = "toggle",
					name = L["Countdown Timer"].." |Tinterface\\addons\\wMarker\\img\\icon_timer.tga:14:14|t",
					set = function(info) dbRaid.control_timerButtonEnabled = not dbRaid.control_timerButtonEnabled; wMarkerAce:controlButtonsLayout() end,
					get = function(info) return dbRaid.control_timerButtonEnabled end,
					order = 88,
				},
				countdownTimeSlider = {
					type = "range",
					name = L["Countdown Timer"],
					min = 0,
					max = 30,
					step = 1,
					set = function(info,input) dbRaid.countdownTime = input end,
					get = function(info) return dbRaid.countdownTime end,
					order = 90
				},
				controlFrame_numColsSlider = {
					type = "range",
					name = L["Icon Columns"],
					min = 1,
					max = 4,
					step = 1,
					set = function(info,input) dbRaid.control_numCols = input; wMarkerAce:controlButtonsLayout(input) end,
					get = function(info) return dbRaid.control_numCols end,
					order = 95
				},
				controlFrame_clearAllTogetherToggle = {
					type = "toggle",
					name = L["Clear all marks at the same time"],
					disabled = function(info) return not dbRaid.control_clearButtonEnabled end,
					set = function(info) dbRaid.control_clearAllTogether = not dbRaid.control_clearAllTogether end,
					get = function(info) return dbRaid.control_clearAllTogether end,
					width = "full",
					order = 89

				},
				
			},
		},
		worldMarkers = {
			type = 'group',
			name = L["World markers"],
			order = 20,
			args = {
				worldMarkersText = {
					type = "description",
					name = (wMarkerAce.titleText.." - "..L["World markers"]),
					fontSize = "large",
					width = "full",
					order = 0,
				},
				spacer = {
					type = "description",
					name = "",
					fontSize = "large",
					width = "full",
					order = 1,
				},
				showCheck = {
					type = "toggle",
					name = L["Show frame"],
					set = function(info) dbWorld.shown = not dbWorld.shown; wMarkerAce:updateVisibility() end,
					get = function(info) return dbWorld.shown end,
					order = 5,
					width = "full"
				},
				lockCheck = {
					type = "toggle",
					name = L["Lock frame"],
					set = function(info) dbWorld.locked = not dbWorld.locked; wMarkerAce:updateLock() end,
					get = function(info) return dbWorld.locked end,
					order = 10,
				},
				clampCheck = {
					type = "toggle",
					name = L["Clamp to screen"],
					set = function(info) dbWorld.clamped = not dbWorld.clamped; wMarkerAce:updateClamp() end,
					get = function(info) return dbWorld.clamped end,
					order = 15,
				},
				reverseCheck = {
					type = "toggle",
					name = L["Reverse icons"],
					set = function(info) dbWorld.flipped = not dbWorld.flipped; wMarkerAce:worldButtonsLayout() end,
					get = function(info) return dbWorld.flipped end,
					order = 20,
					width = "full"
				},
				vertCheck = {
					type = "toggle",
					name = L["Display vertically"],
					set = "worldVertToggle",
					get = function(info) return dbWorld.vertical end,
					order = 25,
					hidden = true,
				},
				aloneCheck = {
					type = "toggle",
					name = L["Hide when alone"],
					set = function(info) dbWorld.partyShow = not dbWorld.partyShow; wMarkerAce:updateVisibility() end,
					get = function(info) return dbWorld.partyShow end,
					order = 30,
				},
				assistCheck = {
					type = "toggle",
					name = L["Hide without assist (in a raid)"],
					set = function(info) dbWorld.assistShow = not dbWorld.assistShow; wMarkerAce:updateVisibility() end,
					get = function(info) return dbWorld.assistShow end,
					order = 40,
					width = "full"
				},
				hideBGCheck = {
					type = "toggle",
					name = L["Hide background"],
					set = function(info) dbWorld.bgHide = not dbWorld.bgHide; wMarkerAce:backgroundVisibility() end,
					get = function(info) return dbWorld.bgHide end,
					order = 45,
				},
				hideBorderCheck = {
					type = "toggle",
					name = L["Hide border"],
					set = function(info) dbWorld.borderHide = not dbWorld.borderHide; wMarkerAce:backgroundVisibility() end,
					get = function(info) return dbWorld.borderHide end,
					order = 46,
				},
				tooltipsCheck = {
					type = "toggle",
					name = L["Enable tooltips"],
					set = function(info) dbWorld.tooltips = not dbWorld.tooltips end,
					get = function(info) return dbWorld.tooltips end,
					order = 50,
					width = "full",
				},		
				scaleSlider = {
					type = "range",
					name = "Scale",
					min = 0.5,
					max = 2,
					step = 0.05,
					isPercent = true,
					set = function(info,input) dbWorld.scale = input; wMarkerAce.worldMain:SetScale(dbWorld.scale) end,
					get = function(info) return dbWorld.scale end,
					order = 55
				},
				alphaSlider = {
					type = "range",
					name = "Transparency",
					min = 0,
					max = 1,
					step = 0.05,
					isPercent = true,
					set = function(info,input) dbWorld.alpha = input; wMarkerAce.worldMain:SetAlpha(dbWorld.alpha) end,
					get = function(info) return dbWorld.alpha end,
					order = 60
				},
				spacingSlider = {
					type = "range",
					name = L["Icon spacing"],
					min = -5,
					max = 15,
					step = 1,
					set = function(info,input) dbWorld.iconSpace = input; wMarkerAce:worldButtonsLayout() end,
					get = function(info) return dbWorld.iconSpace end,
					order = 65
				},
				numColsSlider = {
					type = "range",
					name = L["Icon Columns"],
					min = 1,
					max = 9,
					step = 1,
					set = function(info,input) dbWorld.numCols = input; wMarkerAce:worldButtonsLayout(input) end,
					get = function(info) return dbWorld.numCols end,
					order = 70
				},
				displayAsRadio = {
					type = "select",
					style = "radio",
					name = L["Display as"],
					values = {[1] = L["Blips"], [2] = L["Icons"]},
					set = function(info,input) dbWorld.worldTex = input; wMarkerAce:worldRetext(dbWorld.worldTex) end,
					get = function(info) return dbWorld.worldTex end,
					order = 75
				},
			}
		},
		aboutSection = {
			type = "group",
			name = L["About"],
			order = 0,
			hidden = false,
			args = {
				wMarkerText = {
					type = "description",
					name = wMarkerAce.titleText.." |Tinterface\\targetingframe\\ui-raidtargetingicon_8:14:14|t",
					fontSize = "large",
					width = "full",
					order = 0,
				},
				versionText = {
					type = "description",
					name = string.format("%s%s:|r %s",wMarkerAce.color.yellow,L["Version"],C_AddOns.GetAddOnMetadata("wMarker", "Version")),
					width = "full",
					order = 5,
				},
				aboutText = {
					type = "description",
					name = string.format("%s%s:|r %s",wMarkerAce.color.yellow,L["About"],C_AddOns.GetAddOnMetadata("wMarker", "Notes")),
					width = "full",
					order = 10,
				},
				authorText = {
					type = "description",
					name = string.format("%s%s:|r Waky - Azuremyst",wMarkerAce.color.yellow,L["Author"]),
					width = "full",
					order = 15,
				},
				translationText = {
					type = "header",
					name = L["Translation credits"],
					width = "full",
					order = 20,
				},
				germanText = {
					type = "description",
					name = string.format("|cff69ccf0%s|r - %s","German-deDE","TheGeek/StormCalai, Zaephyr81, Fiveyoushi, Morwo"),
					width = "full",
					order = 25,
				},
				spanishText = {
					type = "description",
					name = string.format("|cff69ccf0%s|r - %s","Spanish-esES","Waky"),
					width = "full",
					order = 30,
				},
				frenchText = {
					type = "description",
					name = string.format("|cff69ccf0%s|r - %s","French-frFR","Kromdhar, Argone"),
					width = "full",
					order = 35,
				},
				traditionalChineseText = {
					type = "description",
					name = string.format("|cff69ccf0%s|r - %s","Traditional Chinese-zhTW","EKE"),
					width = "full",
					order = 40,
				},
				italianText = {
					type = "description",
					name = string.format("|cff69ccf0%s|r - %s","Italian-itIT","Fabsm"),
					width = "full",
					order = 45,
				},
				russianText = {
					type = "description",
					name = string.format("|cff69ccf0%s|r - %s","Russian-ruRU","katanaFAN, panzer48, RamyAlexis"),
					width = "full",
					order = 50,
				},
				simplifiedChineseText = {
					type = "description",
					name = string.format("|cff69ccf0%s|r - %s","Simplified Chinese-zhCN","dll32"),
					width = "full",
					order = 55,
				},
				koreanText = {
					type = "description",
					name = string.format("|cff69ccf0%s|r - %s","Koreak-koKR","cyberyahoo2"),
					width = "full",
					order = 60,
				},
			},
		},
	},
}

-------------------------------------------------------
-- Option Handlers
-------------------------------------------------------


-------------------------------------------------------
-- Helper Functions
-------------------------------------------------------

-- Based on Shadowed's Out of Combat function queue
wMarker_queuedFuncs = {};
function wMarkerAce:RegisterOOCFunc(self,func)
	if (type(func)=="string") then
		wMarker_queuedFuncs[func] = self;		
	else
		wMarker_queuedFuncs[self] = true;
	end	
end

-------------------------------------------------------
-- Frame Manipulation functions (Oh so many of them.)
-------------------------------------------------------

function wMarkerAce:updateVisibility()
	--Start off by saying both should be shown
	wMarkerAce.raidMain:Show()
	local worldMarks = true

	--Raid Marker check
	if (dbRaid.shown==false) then wMarkerAce.raidMain:Hide() end
	if (dbRaid.control_frameEnabled==false) then wMarkerAce.raidMain.controlFrame:Hide() else wMarkerAce.raidMain.controlFrame:Show() end
	if (dbRaid.partyShow==true) then if (GetNumGroupMembers()==0) then wMarkerAce.raidMain:Hide() end end
	if (dbRaid.targetShow==true) then if not (UnitExists("target")) then wMarkerAce.raidMain:Hide() end end
	if (dbRaid.assistShow==true) then if (IsInRaid()) and (UnitIsGroupAssistant("player")==false and UnitIsGroupLeader("player")==false) then wMarkerAce.raidMain:Hide() end end

	--World Marker check
	if (dbWorld.shown==false) then worldMarks = false end
	if (dbWorld.partyShow==true) then if (GetNumGroupMembers()==0) then worldMarks = false end end
	if (dbWorld.assistShow==true) then if (IsInRaid()==true) and (UnitIsGroupAssistant("player")==false and UnitIsGroupLeader("player")==false) then worldMarks = false end end

	--World Marker hide/show
	if not (InCombatLockdown()) then
		if (worldMarks==true) then
			if not(wMarkerAce.worldMain:IsShown()) then 
				wMarkerAce.worldMain:Show() 
			end
		else
			if (wMarkerAce.worldMain:IsShown()) then
				wMarkerAce.worldMain:Hide()
			end
		end
	else
		wMarkerAce:RegisterOOCFunc(self,"updateVisibility");
	end
end

local function setMoverState(mover, locked)
	if (locked) then mover:Hide() else mover:Show() end
end

function wMarkerAce:updateLock()
	setMoverState(wMarkerAce.raidMain.moverLeft,dbRaid.locked)
	setMoverState(wMarkerAce.raidMain.moverRight,dbRaid.locked)
	setMoverState(wMarkerAce.worldMain.moverLeft,dbWorld.locked)
	setMoverState(wMarkerAce.worldMain.moverRight,dbWorld.locked)
end

local function getBackdropArray(bgHide,borderHide)
	if (bgHide) then return {{0,0,0,0},{0,0,0,0}} end
	if (borderHide) then return {{0.1,0.1,0.1,0.7},{0,0,0,0}} end
	return {{0.1,0.1,0.1,0.7},{1,1,1,1}}
end

local function setBackdrop(frame, bgColor, borderColor)
	frame:SetBackdropColor(unpack(bgColor))
	frame:SetBackdropBorderColor(unpack(borderColor))
end

function wMarkerAce:backgroundVisibility()
	setBackdrop(wMarkerAce.raidMain.iconFrame,unpack(getBackdropArray(dbRaid.bgHide,dbRaid.borderHide)))
	setBackdrop(wMarkerAce.raidMain.controlFrame,unpack(getBackdropArray(dbRaid.bgHide,dbRaid.borderHide)))
	setBackdrop(wMarkerAce.worldMain,unpack(getBackdropArray(dbWorld.bgHide,dbWorld.borderHide)))
end

function wMarkerAce:updateClamp()
	wMarkerAce.raidMain:SetClampedToScreen(dbRaid.clamped or false)
	wMarkerAce.worldMain:SetClampedToScreen(dbWorld.clamped or false)
end

function wMarkerAce:raidButtonsLayout(numCols, iconSpace, iconSize)
	local currentRow = 1
	local currentCol = 0
	local maxCols = numCols or dbRaid.numCols
	local iconPadding = iconSpace or dbRaid.iconSpace
	local iconDim = iconSize or 20
	local edgePadding = 7

	local startIcon = 1
	local endIcon = table.getn(wMarkerAce.raidMain.icon)
	local step = 1

	if (dbRaid.flipped) then
		startIcon = table.getn(wMarkerAce.raidMain.icon)
		endIcon = 1
		step = -1
	end

	for i = startIcon,endIcon,step do
		currentCol = currentCol + 1
		if (currentCol > maxCols) then 
			currentRow = currentRow + 1 
			currentCol = 1
		end
		local iconX = edgePadding + (currentCol-1)*iconDim + (currentCol-1)*iconPadding
		local iconY = 0 - edgePadding - (currentRow-1)*iconDim - (currentRow-1)*iconPadding
		wMarkerAce.raidMain.icon[i]:ClearAllPoints()
		wMarkerAce.raidMain.icon[i]:SetSize(iconDim,iconDim)
		wMarkerAce.raidMain.icon[i]:SetPoint("TOPLEFT",wMarkerAce.raidMain.iconFrame,"TOPLEFT",iconX,iconY)
	end

	local frameWidth = (edgePadding*2) + (maxCols*(iconDim+iconPadding)) - iconPadding
	local frameHeight = (edgePadding*2) + (currentRow*(iconDim+iconPadding)) - iconPadding
	wMarkerAce.raidMain.iconFrame:SetSize(frameWidth,frameHeight)
	wMarkerAce.raidMain:SetSize(frameWidth,frameHeight)
end

function wMarkerAce:controlButtonsLayout(numCols, iconSpace, iconSize)
	local currentRow = 1
	local currentCol = 0
	local maxCols = numCols or dbRaid.control_numCols
	local iconPadding = iconSpace or dbRaid.iconSpace
	local iconDim = iconSize or 20
	local edgePadding = 7

	local enabledButtons = {}
	if (dbRaid.control_clearButtonEnabled) then table.insert(enabledButtons,wMarkerAce.raidMain.clearIcon); wMarkerAce.raidMain.clearIcon:Show() else wMarkerAce.raidMain.clearIcon:Hide() end
	if (dbRaid.control_readyButtonEnabled) then table.insert(enabledButtons,wMarkerAce.raidMain.readyCheck) wMarkerAce.raidMain.readyCheck:Show() else wMarkerAce.raidMain.readyCheck:Hide() end
	if (dbRaid.control_roleButtonEnabled) then table.insert(enabledButtons,wMarkerAce.raidMain.roleCheck) wMarkerAce.raidMain.roleCheck:Show() else wMarkerAce.raidMain.roleCheck:Hide() end
	if (dbRaid.control_timerButtonEnabled) then table.insert(enabledButtons,wMarkerAce.raidMain.timerButton) wMarkerAce.raidMain.timerButton:Show() else wMarkerAce.raidMain.timerButton:Hide() end

	local startIcon = 1
	local endIcon = table.getn(enabledButtons)
	local step = 1

	maxCols = math.min(maxCols, endIcon)  --Never let there be more columns than enabled buttons

	for i = startIcon,endIcon,step do
		currentCol = currentCol + 1
		if (currentCol > maxCols) then 
			currentRow = currentRow + 1 
			currentCol = 1
		end
		local iconX = edgePadding + (currentCol-1)*iconDim + (currentCol-1)*iconPadding
		local iconY = 0 - edgePadding - (currentRow-1)*iconDim - (currentRow-1)*iconPadding
		enabledButtons[i]:ClearAllPoints()
		enabledButtons[i]:SetPoint("TOPLEFT",wMarkerAce.raidMain.controlFrame,"TOPLEFT",iconX,iconY)
	end

	local frameWidth = (edgePadding*2) + (maxCols*(iconDim+iconPadding)) - iconPadding
	local frameHeight = (edgePadding*2) + (currentRow*(iconDim+iconPadding)) - iconPadding
	wMarkerAce.raidMain.controlFrame:SetSize(frameWidth,frameHeight)
end

function wMarkerAce:worldButtonsLayout(numCols, iconSpace, iconSize)
	--World Markers frame cannot be changed while in combat since they're SecureActionButtons
	if  (UnitAffectingCombat("player")) then wMarkerAce:RegisterOOCFunc(self,"worldButtonsLayout"); return; end

	local currentRow = 1
	local currentCol = 0
	local maxCols = numCols or dbWorld.numCols
	local iconPadding = iconSpace or dbWorld.iconSpace
	local iconDim = iconSize or 20
	local edgePadding = 5

	local startIcon = 1
	local endIcon = table.getn(wMarkerAce.worldMain.marker)
	local step = 1


	if (dbWorld.flipped) then
		startIcon = table.getn(wMarkerAce.worldMain.marker)
		endIcon = 1
		step = -1
	end

	for i = startIcon,endIcon,step do
		currentCol = currentCol + 1
		if (currentCol > maxCols) then 
			currentRow = currentRow + 1 
			currentCol = 1
		end
		local iconX = edgePadding + (currentCol-1)*iconDim + (currentCol-1)*iconPadding
		local iconY = 0 - edgePadding - (currentRow-1)*iconDim - (currentRow-1)*iconPadding
		wMarkerAce.worldMain.marker[i]:ClearAllPoints()
		wMarkerAce.worldMain.marker[i]:SetPoint("TOPLEFT",wMarkerAce.worldMain,"TOPLEFT",iconX,iconY)
	end

	local frameWidth = (edgePadding*2) + (maxCols*(iconDim+iconPadding)) - iconPadding
	local frameHeight = (edgePadding*2) + (currentRow*(iconDim+iconPadding)) - iconPadding
	wMarkerAce.worldMain:SetSize(frameWidth,frameHeight)
end

function wMarkerAce:worldRetext(tex)
	if (tex==1) then
		for k,v in pairs(wMarkerAce.worldMain.marker) do v:SetNormalTexture("interface\\minimap\\partyraidblips") end
		wMarkerAce.worldMain.marker["Square"]:GetNormalTexture():SetTexCoord(0.75,0.875,0,0.25)
		wMarkerAce.worldMain.marker["Triangle"]:GetNormalTexture():SetTexCoord(0.25,0.375,0,0.25)
		wMarkerAce.worldMain.marker["Diamond"]:GetNormalTexture():SetTexCoord(0,0.125,0.25,0.5)
		wMarkerAce.worldMain.marker["Cross"]:GetNormalTexture():SetTexCoord(0.625,0.75,0,0.25)
		wMarkerAce.worldMain.marker["Star"]:GetNormalTexture():SetTexCoord(0.375,0.5,0,0.25)
		wMarkerAce.worldMain.marker["Circle"]:GetNormalTexture():SetTexCoord(0.25,0.375,0.25,0.5)
		wMarkerAce.worldMain.marker["Moon"]:GetNormalTexture():SetTexCoord(0.875,1,0,0.25)
		wMarkerAce.worldMain.marker["Skull"]:GetNormalTexture():SetTexCoord(0.5,0.625,0,0.25)
	else
		for k,v in pairs(wMarkerAce.worldMain.marker) do v:SetNormalTexture("interface\\targetingframe\\ui-raidtargetingicons") end
		wMarkerAce.worldMain.marker["Square"]:GetNormalTexture():SetTexCoord(0.25,0.5,0.25,0.5)
		wMarkerAce.worldMain.marker["Triangle"]:GetNormalTexture():SetTexCoord(0.75,1,0,0.25)
		wMarkerAce.worldMain.marker["Diamond"]:GetNormalTexture():SetTexCoord(0.5,0.75,0,0.25)
		wMarkerAce.worldMain.marker["Cross"]:GetNormalTexture():SetTexCoord(0.5,0.75,0.25,0.5)
		wMarkerAce.worldMain.marker["Star"]:GetNormalTexture():SetTexCoord(0,0.25,0,0.25)
		wMarkerAce.worldMain.marker["Circle"]:GetNormalTexture():SetTexCoord(0.25,0.5,0,0.25)
		wMarkerAce.worldMain.marker["Moon"]:GetNormalTexture():SetTexCoord(0,0.25,0.25,0.5)
		wMarkerAce.worldMain.marker["Skull"]:GetNormalTexture():SetTexCoord(0.75,1,0.25,0.5)
	end
	--Need to retex the clearIcon every time since it's inside the same table for layout purposes. Clever at one time, now it's a pain.
	wMarkerAce.worldMain.clearIcon:SetNormalTexture("interface\\addons\\wMarker\\img\\icon_reset.tga")
end

function wMarkerAce:updateControlFrameLock()
	if (dbRaid.lockControlFrame) then
		wMarkerAce.raidMain.controlFrame:ClearAllPoints()
		wMarkerAce.raidMain.controlFrame:SetPoint("LEFT",wMarkerAce.raidMain,"RIGHT")
		wMarkerAce.raidMain.moverRight:SetParent(wMarkerAce.raidMain)
		wMarkerAce.raidMain.moverRight:ClearAllPoints()
		wMarkerAce.raidMain.moverRight:SetPoint("LEFT",wMarkerAce.raidMain.controlFrame,"RIGHT")
	else
		wMarkerAce.raidMain.moverRight:ClearAllPoints()
		wMarkerAce.raidMain.moverRight:SetParent(wMarkerAce.raidMain.controlFrame)
		wMarkerAce.raidMain.moverRight:SetPoint("LEFT",wMarkerAce.raidMain.controlFrame,"RIGHT")
	end
end

function wMarkerAce:getLoc(frame, savedVar)
	local point, relativeTo, relPt, xOff, yOff = frame:GetPoint()
	if (relativeTo == nil) then relativeTo = _G["UIParent"] end
	dbFLoc[savedVar or frame:GetName()] = {point, relativeTo:GetName(), relPt, xOff, yOff};
end

function wMarkerAce:setLoc(frame, savedVar)
	if dbFLoc[savedVar or frame:GetName()] then
		frame:ClearAllPoints()
		frame:SetPoint(unpack(dbFLoc[savedVar or frame:GetName()]))
	else
		self:getLoc(frame)
	end
end

-------------------------------------------------------
-- Slash Command Handlers
-------------------------------------------------------

function wMarkerAce:SlashInput(input)
	if not input or input:trim() == "" then
		LibStub("AceConfigDialog-3.0"):Open("wMarker")
	else
		if (input=="lock") then
			dbRaid.lock = not dbRaid.lock
			dbWorld.lock = not dbWorld.lock
			wMarkerAce:updateLock()
		elseif (input=="show") then
			dbRaid.shown=true
			dbWorld.shown=true
			wMarkerAce:updateVisibility()
		elseif (input=="hide") then
			dbRaid.shown=false
			dbWorld.shown=false
			wMarkerAce:updateVisibility()
		elseif (input=="clamp") then
			dbRaid.clamp = not dbRaid.clamp
			dbWorld.clamp = not dbWorld.clamp
			wMarkerAce:updateClamp()
		elseif (input=="options") then
			LibStub("AceConfigDialog-3.0"):Open("wMarker")
		end
	end
end

function wMarkerAce:SlashReadyCheck()
	DoReadyCheck();
end

function wMarkerAce:SlashRoleCheck()
	InitiateRolePoll();
end

-------------------------------------------------------
-- Event Handler
-------------------------------------------------------

function wMarkerAce:EventHandler(event, arg1, arg2, ...)

	if (event=="GROUP_ROSTER_UPDATE") or (event=="RAID_ROSTER_UPDATE") or (event=="PLAYER_TARGET_CHANGED") then
		wMarkerAce:updateVisibility()
	elseif (event=="PLAYER_REGEN_ENABLED") then
		-- Based on Shadowed's Out of Combat function queue
		for func, handler in pairs(wMarker_queuedFuncs) do
			if (type(handler)=="table") then
				handler[func](handler);
			elseif (type(func)=="string") then
				_G[func]();
			else
				func();
			end
		end
		
		for func in pairs(wMarker_queuedFuncs) do
			wMarker_queuedFuncs[func] = nil;
		end

	end

end
