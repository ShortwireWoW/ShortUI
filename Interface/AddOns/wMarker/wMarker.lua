-- Localization
local L = wMarkerLocales

-------------------------------------------------------
-- Databases and backdrops
-------------------------------------------------------

local defaults = {
	profile = {
		raid = {
			locked= false,
			clamped = false,
			shown = true,
			flipped = false,
			vertical = false,
			partyShow = false,
			targetShow = false,
			assistShow = false,
			bgHide = false,
			borderHide = false,
			countdownTime = 10,
			numCols = 8,
			lockControlFrame = true,
			control_frameEnabled = true,
			control_numCols = 4,
			control_clearButtonEnabled = true,
			control_readyButtonEnabled = true,
			control_roleButtonEnabled = false,
			control_timerButtonEnabled = true,
			control_clearAllTogether = false,
			tooltips = true,
			scale = 1,
			alpha = 1,
			iconSpace = 0,
		},
		world = {
			locked = false,
			clamped = false,
			shown = true,
			flipped = false,
			vertical = false,
			partyShow = false,
			assistShow = false,
			bgHide = false,
			borderHide = false,
			numCols = 9,
			tooltips = true,
			worldTex = 1,
			scale = 1,
			alpha = 1,
			iconSpace = 5,
		},
		frameLoc = {
			["wMarkerRaid"] = {"CENTER", "UIParent", "CENTER", -38, 0}, -- Slightly offset to the left to align with the world marker frame
			["wMarkerRaid_controlFrame"] = {"LEFT", "wMarkerRaid", "RIGHT", 0, 0},
			["wMarkerWorld"] = {"CENTER", "UIParent", "CENTER", 0, 50},			
		},
	},
	global ={
		imported = false
	},
}

local defaultBackdrop = {
	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile = true,
	tileSize = 16,
	edgeSize = 16,
	insets = {left = 4, right = 4, top = 4, bottom = 4,}
}
local borderlessBackdrop = {
	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	tile = true,
	tileSize = 16
}
local optionsBackdrop = {
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
	edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
	tile = true,
	tileSize = 16,
	edgeSize = 16,
	insets = {left = 4, right = 4, top = 4, bottom = 4}
}
local editBoxBackdrop = {
	bgFile = "Interface\\COMMON\\Common-Input-Border",
	tile = false,
}

-------------------------------------------------------
-- wMarker Ace Setup
-------------------------------------------------------

wMarkerAce = LibStub("AceAddon-3.0"):NewAddon("wMarker", "AceConsole-3.0", "AceEvent-3.0")

wMarkerAce.titleText = "|cffe1a500w|cff69ccf0Marker|r"
wMarkerAce.color = {
	["yellow"] = "|cffe1a500",
	["blue"] = "|cff69ccf0"
}

function wMarkerAce:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("wMarkerAceDB", defaults, true)
	self.options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)

	local AceConfig = LibStub("AceConfig-3.0")
	AceConfig:RegisterOptionsTable("wMarker", self.options)

	local AceDialog = LibStub("AceConfigDialog-3.0")
	AceDialog:SetDefaultSize("wMarker", 600, 450)
	self.optionsFrame = AceDialog:AddToBlizOptions("wMarker","wMarker")

end

function wMarkerAce:OnEnable()

	-------------------------------------------------------
	-- wMarker Main Frame
	-------------------------------------------------------

	local function createMover(width,height,parent,pt,relPt)
		local f = CreateFrame("Frame",nil,parent, "BackdropTemplate");
		f:SetBackdrop(defaultBackdrop)
		f:SetBackdropColor(0.1,0.1,0.1,0.7)
		f:EnableMouse(true)
		f:SetMovable(true)
		f:SetSize(width,height)
		f:SetPoint(pt,parent,relPt)
		f:SetScript("OnMouseDown",function(self,button) if (button=="LeftButton") then f:GetParent():StartMoving() end end)
		f:SetScript("OnMouseUp",function() f:GetParent():StopMovingOrSizing(); wMarkerAce:getLoc(f:GetParent()) end)
		return f
	end

	local main = CreateFrame("Frame", "wMarkerRaid", UIParent, "BackdropTemplate");
	main:SetBackdrop(borderlessBackdrop)
	main:SetBackdropColor(0,0,0,0)
	main:EnableMouse(true)
	main:SetMovable(true)
	main:SetSize(225,35)
	main:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	main:SetClampedToScreen(false)
	wMarkerAce.raidMain = main

	-------------------------------------------------------
	-- wMarker Icon Frame (and icons)
	-------------------------------------------------------


	local iconFrame = CreateFrame("Frame", "wMarkerRaid_iconFrame", wMarkerAce.raidMain, "BackdropTemplate");
	iconFrame:SetBackdrop(defaultBackdrop)
	iconFrame:SetBackdropColor(0.1,0.1,0.1,0.7)
	iconFrame:EnableMouse(true)
	iconFrame:SetMovable(true)
	iconFrame:SetSize(170,35)
	iconFrame:SetPoint("LEFT", wMarkerAce.raidMain, "LEFT")
	wMarkerAce.raidMain.iconFrame = iconFrame
	wMarkerAce.raidMain.icon = {}
	local lastFrame, xOff
	local function iconNew(name, num)
		if lastFrame then xOff = 0 else xOff = 5 end
		local f = CreateFrame("Button", string.format("wMarker%sicon",name), wMarkerAce.raidMain.iconFrame, "BackdropTemplate");
		table.insert(wMarkerAce.raidMain.icon, f)
		f:SetSize(20,20)
		f:SetPoint("LEFT",lastFrame or wMarkerAce.raidMain.iconFrame,xOff,0)
		f:SetNormalTexture(string.format("interface\\targetingframe\\ui-raidtargetingicon_%d",num))
		f:EnableMouse(true)
		f:RegisterForClicks("LeftButtonDown", "RightButtonDown")
		f:SetScript("OnClick", function(self, button) if (button=="LeftButton") then SetRaidTarget("target", num) else LibStub("AceConfigDialog-3.0"):Open("wMarker") end end)
		--f:SetScript("OnEnter", function(self) if (wMarkerAce.db.profile.raid.tooltips==true) then GameTooltip:SetOwner(self, "ANCHOR_CURSOR"); GameTooltip:ClearLines(); GameTooltip:AddLine(L[name]); GameTooltip:Show() end end)
		--Use Global Strings for Tooltip
		f:SetScript("OnEnter", function(self) if (wMarkerAce.db.profile.raid.tooltips==true) then GameTooltip:SetOwner(self, "ANCHOR_CURSOR"); GameTooltip:ClearLines(); GameTooltip:AddLine(_G["BINDING_NAME_RAIDTARGET"..num]); GameTooltip:Show() end end)
		f:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
		lastFrame = f
		wMarkerAce.raidMain.icon[name] = f
	end
	iconNew("Skull",8)
	iconNew("Cross",7)
	iconNew("Square",6)
	iconNew("Moon",5)
	iconNew("Triangle",4)
	iconNew("Diamond",3)
	iconNew("Circle",2)
	iconNew("Star",1)

	-------------------------------------------------------
	-- wMarker Control Frame
	-------------------------------------------------------

	wMarkerAce.raidMain.controlButtons = {}
	local controlFrame = CreateFrame("Frame", "wMarkerRaid_controlFrame", wMarkerAce.raidMain, "BackdropTemplate");
	controlFrame:SetBackdrop(defaultBackdrop)
	controlFrame:SetBackdropColor(0.1,0.1,0.1,0.7)
	controlFrame:EnableMouse(true)
	controlFrame:SetMovable(true)
	controlFrame:SetSize(95,35)
	controlFrame:SetPoint("RIGHT", wMarkerAce.raidMain, "RIGHT")
	wMarkerAce.raidMain.controlFrame = controlFrame
	local clearIcon = CreateFrame("Button", "wMarkerClearIcon", wMarkerAce.raidMain.controlFrame, "BackdropTemplate");
	clearIcon:SetSize(20,20)
	clearIcon:SetPoint("LEFT", wMarkerAce.raidMain.controlFrame, "LEFT",10,0)
	--clearIcon:SetNormalTexture("interface\\glues\\loadingscreens\\dynamicelements")
	--clearIcon:GetNormalTexture():SetTexCoord(0,0.5,0,0.5)
	clearIcon:SetNormalTexture("interface\\addons\\wMarker\\img\\icon_clear.tga")
	clearIcon:EnableMouse(true)
	clearIcon:RegisterForClicks("LeftButtonDown","RightButtonDown")
	clearIcon:SetScript("OnClick", function(self, button) if (button=="LeftButton") then if (wMarkerAce.db.profile.raid.control_clearAllTogether) then wMarkerAce:clearAllRaidTargets() else SetRaidTarget("target", 0) end else LibStub("AceConfigDialog-3.0"):Open("wMarker") end end)
	clearIcon:SetScript("OnEnter", function(self) if (wMarkerAce.db.profile.raid.tooltips==true) then GameTooltip:SetOwner(self, "ANCHOR_CURSOR"); GameTooltip:ClearLines(); if (wMarkerAce.db.profile.raid.control_clearAllTogether) then GameTooltip:AddLine(L["Clear all marks"]) else GameTooltip:AddLine(L["Clear mark"]) end; GameTooltip:Show() end end)
	clearIcon:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	wMarkerAce.raidMain.clearIcon = clearIcon
	wMarkerAce.raidMain.controlButtons["clearIcon"] = clearIcon
	--table.insert(wMarkerAce.raidMain.controlButtons,clearIcon)

	local readyCheck = CreateFrame("Button", "wMarkerReadyCheck", wMarkerAce.raidMain.controlFrame, "BackdropTemplate");
	readyCheck:SetSize(20,20)
	readyCheck:SetPoint("LEFT", clearIcon, "RIGHT")
	readyCheck:SetNormalTexture("interface\\raidframe\\readycheck-waiting")
	readyCheck:GetNormalTexture():SetTexCoord(0,1,0,1)
	readyCheck:EnableMouse(true)
	readyCheck:RegisterForClicks("LeftButtonDown","RightButtonDown")
	readyCheck:SetScript("OnClick", function(self, button) if (button=="LeftButton") then DoReadyCheck() else LibStub("AceConfigDialog-3.0"):Open("wMarker") end end)
	readyCheck:SetScript("OnEnter", function(self) if (wMarkerAce.db.profile.raid.tooltips==true) then GameTooltip:SetOwner(self, "ANCHOR_CURSOR"); GameTooltip:ClearLines(); GameTooltip:AddLine(L["Ready check"]); GameTooltip:Show() end end)
	readyCheck:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	wMarkerAce.raidMain.readyCheck = readyCheck
	wMarkerAce.raidMain.controlButtons["readyCheck"] = readyCheck
	--table.insert(wMarkerAce.raidMain.controlButtons,readyCheck)

	local roleCheck = CreateFrame("Button", "wMarkerRoleCheck", wMarkerAce.raidMain.controlFrame, "BackdropTemplate");
	roleCheck:SetSize(20,20)
	roleCheck:SetPoint("LEFT", readyCheck, "RIGHT")
	roleCheck:SetNormalTexture("interface\\addons\\wMarker\\img\\icon_roleCheck.tga")
	roleCheck:EnableMouse(true)
	roleCheck:RegisterForClicks("LeftButtonDown","RightButtonDown")
	roleCheck:SetScript("OnClick", function(self, button) if (button=="LeftButton") then InitiateRolePoll() else LibStub("AceConfigDialog-3.0"):Open("wMarker") end end)
	roleCheck:SetScript("OnEnter", function(self) if (wMarkerAce.db.profile.raid.tooltips==true) then GameTooltip:SetOwner(self, "ANCHOR_CURSOR"); GameTooltip:ClearLines(); GameTooltip:AddLine(L["Role Check"]); GameTooltip:Show() end end)
	roleCheck:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	wMarkerAce.raidMain.roleCheck = roleCheck
	wMarkerAce.raidMain.controlButtons["roleCheck"] = roleCheck
	--table.insert(wMarkerAce.raidMain.controlButtons,roleCheck)

	local timerButton = CreateFrame("Button", "wMarkerCountdownButton", wMarkerAce.raidMain.controlFrame, "BackdropTemplate");
	timerButton:SetSize(20,20)
	timerButton:SetPoint("LEFT", roleCheck, "RIGHT")
	timerButton:SetNormalTexture("interface\\addons\\wMarker\\img\\icon_timer.tga")
	timerButton:EnableMouse(true)
	timerButton:RegisterForClicks("LeftButtonDown","RightButtonDown")
	timerButton:SetScript("OnClick", function(self, button) if (button=="LeftButton" and wMarkerAce.db.profile.raid.countdownTime > 0) then C_PartyInfo.DoCountdown(wMarkerAce.db.profile.raid.countdownTime); else LibStub("AceConfigDialog-3.0"):Open("wMarker") end end)
	timerButton:SetScript("OnEnter", function(self) if (wMarkerAce.db.profile.raid.tooltips==true) then GameTooltip:SetOwner(self, "ANCHOR_CURSOR"); GameTooltip:ClearLines(); GameTooltip:AddLine(L["Countdown Timer"]..": "..wMarkerAce.db.profile.raid.countdownTime); GameTooltip:Show() end end)
	timerButton:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	wMarkerAce.raidMain.timerButton = timerButton
	wMarkerAce.raidMain.controlButtons["timerButton"] = timerButton
	--table.insert(wMarkerAce.raidMain.controlButtons,timerButton)

	-------------------------------------------------------
	-- Movers
	-------------------------------------------------------

	wMarkerAce.raidMain.moverLeft = createMover(20,35,wMarkerAce.raidMain,"RIGHT","LEFT")
	wMarkerAce.raidMain.moverRight = createMover(20,35,wMarkerAce.raidMain,"LEFT","RIGHT")

	-------------------------------------------------------
	-- World Marker Main Frame 
	-------------------------------------------------------

	local worldFrame = CreateFrame("Frame", "wMarkerWorld", UIParent, "BackdropTemplate");
	worldFrame:SetBackdrop(defaultBackdrop)
	worldFrame:SetBackdropColor(0.1,0.1,0.1,0.7)
	worldFrame:EnableMouse(true)
	worldFrame:SetMovable(true)
	worldFrame:SetSize(190,30)
	worldFrame:SetPoint("CENTER", UIParent, "CENTER",0,40)
	worldFrame:SetClampedToScreen(false)
	wMarkerAce.worldMain = worldFrame
	wMarkerAce.worldMain.moverLeft = createMover(20,30,wMarkerAce.worldMain,"RIGHT","LEFT")
	wMarkerAce.worldMain.moverRight = createMover(20,30,wMarkerAce.worldMain,"LEFT","RIGHT")

	-------------------------------------------------------
	-- The flares A.K.A. World markers
	-------------------------------------------------------

	-- New White (Skull 8), Red(Cross), Blue(Square), Silver (Moon 7), Green(Triangle), Purple (Diamond), Orange (Circle 6), Yellow (Star)
	wMarkerAce.worldMain.marker = {}
	local function flareNew(name, tex, num, xOff)

		local f = CreateFrame("Button", string.format("wMarker%sflare",name), wMarkerAce.worldMain, "SecureActionButtonTemplate")
		table.insert(wMarkerAce.worldMain.marker,f)
		f:SetSize(20,20)
		f:SetNormalTexture("interface\\targetingframe\\ui-raidtargeting6icons") -- "interface\\minimap\\partyraidblips"
		f:GetNormalTexture():SetTexCoord(unpack(tex))
		f:SetPoint("LEFT",lastFlare or wMarkerAce.worldMain,"RIGHT",xOff or 0,0)

		--Old Macro version
		--f:SetAttribute("type", "macro")
		--f:SetAttribute("macrotext",string.format("/wm %d",num))

		--Set Left-Click to Set Marker
		f:SetAttribute("type1","worldmarker")
		f:SetAttribute("marker1",num)
		f:SetAttribute("action1","set")
		--Set Right-Click to Clear Marker
		f:SetAttribute("type2","worldmarker")
		f:SetAttribute("marker2",num)
		f:SetAttribute("action2","clear")

		--f:SetScript("OnEnter", function(self) if (wMarkerAce.db.profile.world.tooltips==true) then GameTooltip:SetOwner(self, "ANCHOR_CURSOR"); GameTooltip:ClearLines(); GameTooltip:AddLine(string.format("%s %s",L[name],L["world marker"])); GameTooltip:Show() end end)
		--Use Global Strings for Tooltip
		f:SetScript("OnEnter", function(self) if (wMarkerAce.db.profile.world.tooltips==true) then GameTooltip:SetOwner(self, "ANCHOR_CURSOR"); GameTooltip:ClearLines(); GameTooltip:AddLine(_G["WORLD_MARKER"..num]); GameTooltip:Show() end end)
		f:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
		f:RegisterForClicks("AnyUp","AnyDown")
		lastFlare = f
		wMarkerAce.worldMain.marker[name] = f
		
	end
	flareNew("Square",{0.25,0.5,0.25,0.5},1,5)
	flareNew("Triangle",{0.75,1,0,0.25},2)
	flareNew("Diamond",{0.5,0.75,0,0.25},3)
	flareNew("Cross",{0.5,0.75,0.25,0.5},4)
	flareNew("Star",{0,0.25,0,0.25},5)
	flareNew("Circle",{0.25,0.5,0,0.25},6);
	flareNew("Moon",{0,0.25,0.25,0.5},7);
	flareNew("Skull",{0.75,1,0.25,0.5},8);

	local worldMarkerClear = CreateFrame("Button", "wMarkerClearflares", wMarkerAce.worldMain, "SecureActionButtonTemplate") -- Clear
	worldMarkerClear:SetSize(20,20)
	worldMarkerClear:SetNormalTexture("interface\\addons\\wMarker\\img\\icon_reset.tga")
	worldMarkerClear:SetPoint("LEFT", wMarkerAce.worldMain.marker["Skull"], "RIGHT",3,0)
	worldMarkerClear:SetAttribute("type1", "macro")
	worldMarkerClear:SetAttribute("macrotext1", "/cwm 0")
	worldMarkerClear:SetScript("OnEnter", function(self) if (wMarkerAce.db.profile.world.tooltips==true) then GameTooltip:SetOwner(self, "ANCHOR_CURSOR"); GameTooltip:ClearLines(); GameTooltip:AddLine(L["Clear all world markers"]); GameTooltip:Show() end end)
	worldMarkerClear:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	worldMarkerClear:RegisterForClicks("AnyUp","AnyDown")
	wMarkerAce.worldMain.clearIcon = worldMarkerClear
	table.insert(wMarkerAce.worldMain.marker,worldMarkerClear)

end

function wMarkerAce:clearAllRaidTargets()
	for i=8,0,-1 do SetRaidTarget("player",i) end
end

function wMarkerAce:OnDisable()
	
end

function wMarkerAce:Print(msg)
	DEFAULT_CHAT_FRAME:AddMessage(string.format("%s: %s",wMarkerAce.titleText,msg))
end

function wMarkerAce_OpenConfig()
	LibStub("AceConfigDialog-3.0"):Open("wMarker")
end


