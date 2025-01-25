--[[
	HOW TO ADD NEW BOSSEES TO PAM:
	1. Add boss ID to bossIdToNameMap
	2. Add togglePriorityListButton to the options of the boss (use the bossID as argument)
	3. Add the bossID to IRT_RPAFEnabled on PLAYER_LOGIN and set to false by defaultif (IRT_RPAFEnabled[2677] == nil) then
	4. Add the RPAFEnabledButton to the options of the boss
	5. Add the logic to what RPAF should do for the boss in the boss module
]]
local L = IRTLocals;
local f = CreateFrame("Frame", nil, nil, BackdropTemplateMixin and "BackdropTemplate");
local timer = nil;
local count = 0;
local latestPrefix = nil;
f:SetSize(300, 300);
f:SetPoint("TOPLEFT", 30, -300);
f:SetMovable(false);
f:EnableMouse(false);
f:RegisterForDrag("LeftButton");
f:SetFrameLevel(3);
f:SetScript("OnDragStart", f.StartMoving);
f:SetScript("OnDragStop", function(self)
	local point, relativeTo, relativePoint, xOffset, yOffset = self:GetPoint(1);
	IRT_RPAFPosition = {};
	IRT_RPAFPosition.point = point;
	IRT_RPAFPosition.relativeTo = relativeTo;
	IRT_RPAFPosition.relativePoint = relativePoint;
	IRT_RPAFPosition.xOffset = xOffset;
	IRT_RPAFPosition.yOffset = yOffset;
	self:StopMovingOrSizing();
end);
f:SetFrameStrata("TOOLTIP");

local logoTexture = f:CreateTexture(nil, "OVERLAY");
logoTexture:SetTexture("Interface\\addons\\InfiniteRaidTools\\Res\\inf_logo.tga");
logoTexture:SetPoint("TOPLEFT", 5, -5);
logoTexture:SetSize(20, 9);
logoTexture:SetTexCoord(0,0.63,0,0.56);

local text = f:CreateFontString(nil, "ARTWORK", "GameFontNormal");
text:SetPoint("LEFT", logoTexture, "RIGHT", 3, 0);
text:SetText("|cFFFFFFFFIRT|r");
text:SetFont("Fonts\\ARIALN.TTF", 11);

f:Hide();
local GUI = nil;
local function createRaiderFrame(index, prefix, customRaider)
	local raider = customRaider or GetRaidRosterInfo(index);
	local player = Ambiguate(GetUnitName(raider, true), "none");
	local privateAuraFrame = CreateFrame("Frame", "IRT_RPAF"..index, f, BackdropTemplateMixin and "BackdropTemplate");
	local y = (index-1)%5*33;
	local x = (math.ceil(index/5)-1)*33;
	privateAuraFrame:SetSize(32,32);
	if (IRT_RPAFLayout == "HORIZONTAL") then
		y = (math.ceil(index/5)-1)*33;
		x = (index-1)%5*33;
	elseif (IRT_RPAFLayout == "LIST") then
		x = 0;
		y = (index-1)*15;
		privateAuraFrame:SetSize(80,14);
	end
	privateAuraFrame:SetPoint("TOPLEFT", 5+x, -18-y);
	local raidIndex = 0;
	for i = 1, GetNumGroupMembers() do
		if (GetUnitName("raid"..i, true)) then
			local pl = Ambiguate(GetUnitName("raid"..i, true), "none");
			if (UnitIsUnit(pl, player)) then
				raidIndex = i;
				break;
			end
		end
	end
	local privateAuraConfig = {
		unitToken = "raid"..raidIndex,
		auraIndex = 1,
		parent = privateAuraFrame,
		showCountdownFrame = true,
		showCountdownNumbers = true,
		iconInfo = {
			iconAnchor = {
				point = "TOPLEFT",
				relativeTo = privateAuraFrame,
				relativePoint = "TOPLEFT",
				offsetX = 0,
				offsetY = 0
			},
			iconWidth = 12,
			iconHeight = 12
		},
	};
	local privateAuraConfig2 = {
		unitToken = "raid"..raidIndex,
		auraIndex = 2,
		parent = privateAuraFrame,
		showCountdownFrame = true,
		showCountdownNumbers = true,
		iconInfo = {
			iconAnchor = {
				point = "TOPLEFT",
				relativeTo = privateAuraFrame,
				relativePoint = "TOPLEFT",
				offsetX = 13,
				offsetY = 0
			},
			iconWidth = 4,
			iconHeight = 4
		},
	};
	local _, class  = UnitClass(raider);
	local r,g,b = RAID_CLASS_COLORS[class]:GetRGBA();
	privateAuraFrame:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8x8",
		edgeFile = "Interface\\Buttons\\WHITE8x8",
		edgeSize = 1,
	});
	privateAuraFrame:SetBackdropBorderColor(0.5, 0.5, 0.5);
	privateAuraFrame:SetBackdropColor(r,g,b,1);
	--[[
		privateAuraFrame:SetScript("OnMouseDown", function(self, button)
		print("test")
		if (UnitIsGroupAssistant("player") or UnitIsGroupLeader("player")) then
			if (button == "LeftButton") then
				count = count + 1;
				IRT_SendAddonMessageWhisper(prefix, "RPAF " .. count, player);
			elseif (button == "RightButton") then
				count = count - 1;
				IRT_SendAddonMessageWhisper(prefix, "RPAF ABORT", player);
			end
		end
	end);
	]]
	local privateAuraButton = CreateFrame("Button", "IRT_RPAFButton"..index, privateAuraFrame);
	privateAuraButton:SetScript("OnMouseDown", function (self, button)
		if (UnitIsGroupAssistant("player") or UnitIsGroupLeader("player")) then
			if (button == "LeftButton") then
				count = count + 1;
				local code = IRT_SendAddonMessageWhisper(prefix, "RPAF " .. count, player, false, true);
				if (code ~= 0) then
					IRT_DebugMessage(L.ERROR_ADDON_MESSAGE_WHISPER .. IRT_GetAddonResultMessage(code), "debug", "PRIVATEAURAMAGIC");
				end
			elseif (button == "RightButton") then
				count = count - 1;
				local code = IRT_SendAddonMessageWhisper(prefix, "RPAF ABORT", player, false, true);
				if (code ~= 0) then
					IRT_DebugMessage(L.ERROR_ADDON_MESSAGE_WHISPER .. IRT_GetAddonResultMessage(code), "debug", "PRIVATEAURAMAGIC");
				end
			end
		end
	end);
	privateAuraButton:SetPoint("CENTER");
	privateAuraButton:SetSize(32,32);
	local privateAuraFrameText = privateAuraFrame:CreateFontString("IRT_RPAFText".. index, "OVERLAY", "GameFontNormal");
	local shortName = player:sub(0, 5);
	privateAuraFrameText:SetText("|cffffffff"..shortName);
	privateAuraFrameText:SetJustifyH("CENTER");
	privateAuraFrameText:SetPoint("CENTER");
	privateAuraFrameText:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE");
	GUI["IRT_RPAF"..index] = privateAuraFrame;
	GUI["IRT_RPAFButton"..index] = privateAuraButton;
	GUI["IRT_RPAFText"..index] = privateAuraFrameText;
	if (GUI["IRT_RPAFAnchor1"..index]) then
		C_UnitAuras.RemovePrivateAuraAnchor(GUI["IRT_RPAFAnchor1"..index]);
	end
	if (GUI["IRT_RPAFAnchor2"..index]) then
		C_UnitAuras.RemovePrivateAuraAnchor(GUI["IRT_RPAFAnchor2"..index]);
	end
	GUI["IRT_RPAFConfig1"..index] = privateAuraConfig;
	GUI["IRT_RPAFConfig2"..index] = privateAuraConfig2;
	GUI["IRT_RPAFAnchor1"..index] = C_UnitAuras.AddPrivateAuraAnchor(privateAuraConfig);
	GUI["IRT_RPAFAnchor2"..index] = C_UnitAuras.AddPrivateAuraAnchor(privateAuraConfig2);
	return privateAuraFrame, privateAuraFrameText;
end
f:RegisterEvent("CHAT_MSG_ADDON");

local function updateRaiderFrame(index, prefix, customRaider)
	local raider = customRaider or GetRaidRosterInfo(index);
	if (raider ~= nil) then
		local player = Ambiguate(GetUnitName(raider, true), "none");
		local privateAuraFrame = GUI["IRT_RPAF"..index];
		local raidIndex = 0;
		for i = 1, GetNumGroupMembers() do
			if (GetUnitName("raid" ..i, true)) then
				local pl = Ambiguate(GetUnitName("raid"..i, true), "none");
				if (UnitIsUnit(pl, player)) then
					raidIndex = i;
					break;
				end
			end
		end
		local privateAuraConfig = GUI["IRT_RPAFConfig1"..index];
		privateAuraConfig.unitToken = "raid"..raidIndex;
		local privateAuraConfig2 = GUI["IRT_RPAFConfig2"..index];
		privateAuraConfig2.unitToken = "raid"..raidIndex;
		local _, class  = UnitClass(raider);
		local r,g,b = RAID_CLASS_COLORS[class]:GetRGBA();
		privateAuraFrame:SetBackdropBorderColor(0.5, 0.5, 0.5);
		privateAuraFrame:SetBackdropColor(r,g,b,1);
		local privateAuraButton = GUI["IRT_RPAFButton"..index]
		privateAuraButton:SetScript("OnMouseDown", function (self, button)
			if (UnitIsGroupAssistant("player") or UnitIsGroupLeader("player")) then
				if (button == "LeftButton") then
					count = count + 1;
					local code = IRT_SendAddonMessageWhisper(prefix, "RPAF " .. count, player, false, true);
					if (code ~= 0) then
						IRT_DebugMessage(L.ERROR_ADDON_MESSAGE_WHISPER .. IRT_GetAddonResultMessage(code), "debug", "PRIVATEAURAMAGIC");
					end
				elseif (button == "RightButton") then
					count = count - 1;
					local code = IRT_SendAddonMessageWhisper(prefix, "RPAF ABORT", player, false, true);
					if (code ~= 0) then
						IRT_DebugMessage(L.ERROR_ADDON_MESSAGE_WHISPER .. IRT_GetAddonResultMessage(code), "debug", "PRIVATEAURAMAGIC");
					end
				end
			end
		end);
--[[
	privateAuraFrame:SetScript("OnMouseDown", function(self, button)
	if (UnitIsGroupAssistant("player") or UnitIsGroupLeader("player")) then
		if (button == "LeftButton") then
			count = count + 1;
			IRT_SendAddonMessageWhisper(prefix, "RPAF " .. count, player);
		elseif (button == "RightButton") then
			count = count - 1;
			IRT_SendAddonMessageWhisper(prefix, "RPAF ABORT", player);
		end
	end
end);
]]
		local privateAuraFrameText = GUI["IRT_RPAFText"..index];
		local shortName = player:sub(0, 5);
		privateAuraFrameText:SetText("|cffffffff"..shortName);
		GUI["IRT_RPAF"..index] = privateAuraFrame;
		GUI["IRT_RPAFText"..index] = privateAuraFrameText;
		if (GUI["IRT_RPAFAnchor1"..index]) then
			C_UnitAuras.RemovePrivateAuraAnchor(GUI["IRT_RPAFAnchor1"..index]);
		end
		if (GUI["IRT_RPAFAnchor2"..index]) then
			C_UnitAuras.RemovePrivateAuraAnchor(GUI["IRT_RPAFAnchor2"..index]);
		end
		GUI["IRT_RPAFConfig1"..index] = privateAuraConfig;
		GUI["IRT_RPAFConfig2"..index] = privateAuraConfig2;
		GUI["IRT_RPAFAnchor1"..index] = C_UnitAuras.AddPrivateAuraAnchor(privateAuraConfig);
		GUI["IRT_RPAFAnchor2"..index] = C_UnitAuras.AddPrivateAuraAnchor(privateAuraConfig2);
		return privateAuraFrame, privateAuraFrameText;
	else
		local privateAuraFrame = GUI["IRT_RPAF"..index];
		local privateAuraConfig = GUI["IRT_RPAFConfig1"..index];
		privateAuraConfig.unitToken = "";
		local privateAuraConfig2 = GUI["IRT_RPAFConfig2"..index];
		privateAuraConfig2.unitToken = "";
		privateAuraFrame:SetBackdropBorderColor(0.5, 0.5, 0.5,0);
		privateAuraFrame:SetBackdropColor(0,0,0,0);
		privateAuraFrame:SetScript("OnMouseDown", nil);
		local privateAuraFrameText = GUI["IRT_RPAFText"..index];
		privateAuraFrameText:SetText("");
		GUI["IRT_RPAF"..index] = privateAuraFrame;
		GUI["IRT_RPAFText"..index] = privateAuraFrameText;
		if (GUI["IRT_RPAFAnchor1"..index]) then
			C_UnitAuras.RemovePrivateAuraAnchor(GUI["IRT_RPAFAnchor1"..index]);
		end
		if (GUI["IRT_RPAFAnchor2"..index]) then
			C_UnitAuras.RemovePrivateAuraAnchor(GUI["IRT_RPAFAnchor2"..index]);
		end
		GUI["IRT_RPAFConfig1"..index] = privateAuraConfig;
		GUI["IRT_RPAFConfig2"..index] = privateAuraConfig2;
		return privateAuraFrame, privateAuraFrameText;
	end
end

local function initGUI(difficulty, prefix, customRaidPrio)
	local players = 20;
	if (difficulty ~= 16) then
		players = GetNumGroupMembers() or players;
	end
	if (IRT_RPAFLayout == "HORIZONTAL") then
		f:SetSize((33*5)+8,math.ceil(players/5)*33+22);
	elseif (IRT_RPAFLayout == "LIST") then
		f:SetSize(80+8,players*15+22);
	else
		f:SetSize(math.ceil(players/5)*33+22,(33*5)+8);
	end
	if (GUI == nil) then
		GUI = {};
		if (customRaidPrio) then
			for i = 1, #customRaidPrio do
				createRaiderFrame(i, prefix, customRaidPrio[i]);
			end
		else
			for i = 1, players do
				createRaiderFrame(i, prefix);
			end
		end
	else
		if (customRaidPrio) then
			for i = 1, #customRaidPrio do
				if (_G["IRT_RPAF"..i]) then
					updateRaiderFrame(i, prefix, customRaidPrio[i]);
				else
					createRaiderFrame(i, prefix, customRaidPrio[i]);
				end
			end
			for i = #customRaidPrio+1, 30 do
				if (_G["IRT_RPAF"..i]) then
					updateRaiderFrame(i, prefix);
				end
			end
		else
			for i = 1, players do
				if (_G["IRT_RPAF"..i]) then
					updateRaiderFrame(i, prefix);
				else
					createRaiderFrame(i, prefix);
				end
			end
			for i = players+1, 30 do
				if (_G["IRT_RPAF"..i]) then
					updateRaiderFrame(i, prefix);
				end
			end
		end
	end
	f:Show();
end

function IRT_RPAFShow(difficulty, prefix, sec, customRaidPrio)
	latestPrefix = prefix;
	initGUI(difficulty, prefix, customRaidPrio);
	f:Show();
	if (timer) then
		timer:Cancel();
	end
	if (sec) then
		timer = C_Timer.NewTimer(sec, function()
			f:Hide();
		end);
	end
	return timer;
end

function IRT_RPAFMove()
	text:SetText("|cFFFFFFFFIRT|r MOVE ME");
	f:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", --Set the background and border textures
	edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
	tile = true, tileSize = 16, edgeSize = 16,
	insets = { left = 4, right = 4, top = 4, bottom = 4 }
	});
	f:SetSize(33*5+8, 170);
	f:SetBackdropColor(0.3,0.3,0.3,0.6);
	f:SetMovable(true);
	f:EnableMouse(true);
	f:Show();
	C_Timer.After(7, function()
		f:Hide();
		f:SetMovable(false);
		f:EnableMouse(false);
		text:SetText("|cFFFFFFFFIRT|r");
		f:SetBackdrop(nil);
	end)
end

function IRT_RPAFHide()
	if (timer) then
		timer:Cancel();
	end
	f:Hide();
end

function IRT_RPAFSetPosition(point, relativeTo, relativePoint, xOffset, yOffset)
	f:ClearAllPoints();
	f:SetPoint(point, relativeTo, relativePoint, xOffset, yOffset);
end

function IRT_RPAFIsShown()
	if f:IsShown() then
		return true;
	else
		return false;
	end
end

function IRT_RPAFUpdateLayout()
	for i = 1, 40 do
		if (GUI and GUI["IRT_RPAF"..i]) then
			local privateAuraFrame = GUI["IRT_RPAF"..i];
			local y = (i-1)%5*33;
			local x = (math.ceil(i/5)-1)*33;
			privateAuraFrame:SetSize(32,32);
			if (IRT_RPAFLayout == "HORIZONTAL") then
				y = (math.ceil(i/5)-1)*33;
				x = (i-1)%5*33;
			elseif (IRT_RPAFLayout == "LIST") then
				x = 0;
				y = (i-1)*15;
				privateAuraFrame:SetSize(80,14);
			end
			privateAuraFrame:SetPoint("TOPLEFT", 5+x, -18-y);
			GUI["IRT_RPAF"..i] = privateAuraFrame;
			updateRaiderFrame(i, latestPrefix);
		end
	end
end

function IRT_RPAFReset()
	count = 0;
end
local bossIdToNameMap = {
	[2677] = "Fyrakk",
	[2684] = "Nelth",
	[2918] = "Sikran",
	[2920] = "Ky'veza",
};
local priorityListFrame = CreateFrame("Frame", nil, nil, BackdropTemplateMixin and "BackdropTemplate");
priorityListFrame:SetPoint("TOP", 0, -20);
priorityListFrame:SetSize(195, 580);
priorityListFrame:SetMovable(true);
priorityListFrame:EnableMouse(true);
priorityListFrame:RegisterForDrag("LeftButton");
priorityListFrame:SetFrameLevel(3);
priorityListFrame:SetScript("OnDragStart", f.StartMoving);
priorityListFrame:SetScript("OnDragStop", function(self)
	self:StopMovingOrSizing();
end);
priorityListFrame:SetFrameStrata("TOOLTIP");
priorityListFrame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", --Set the background and border textures
edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
tile = true, tileSize = 16, edgeSize = 16,
insets = { left = 4, right = 4, top = 4, bottom = 4 }
});
priorityListFrame:SetBackdropColor(0.3, 0.3, 0.3, 0.6);
priorityListFrame:Hide();
local priorityListFrameTitle = priorityListFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal");
priorityListFrameTitle:SetPoint("TOP", 0, -7);
priorityListFrameTitle:SetText("|cFFFFFFFF" .. L.OPTIONS_RPAF_PRIORITY_TITLE .. ": ");
priorityListFrameTitle:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE");
local saveButton = CreateFrame("Button", nil, priorityListFrame, "UIPanelButtonTemplate");
saveButton:SetSize(100, 20);
saveButton:SetPoint("BOTTOM", 0, 10);
saveButton:SetText("Save");
saveButton:SetScript("OnClick", function(frame)
	priorityListFrame:Hide();
end);
local priorityUI = {};
local buttonBeingDragged = nil;
local UIData = {
	[1] = {["spec"] = "Arcane", x = 7, y = -35},
	[2] = {["spec"] = "Fire", x = 7, y = -48},
	[3] = {["spec"] = "Frost (Mage)", x = 7, y = -61},
	[4] = {["spec"] = "Beast Mastery", x = 7, y = -74},
	[5] = {["spec"] = "Marksmanship", x = 7, y = -87},
	[6] = {["spec"] = "Affliction", x = 7, y = -100},
	[7] = {["spec"] = "Demonology", x = 7, y = -113},
	[8] = {["spec"] = "Destruction", x = 7, y = -126},
	[9] = {["spec"] = "Shadow", x = 7, y = -139},
	[10] = {["spec"] = "Devastation", x = 7, y = -152},
	[11] = {["spec"] = "Augmentation", x = 7, y = -165},
	[12] = {["spec"] = "Elemental", x = 7, y = -178},
	[13] = {["spec"] = "Balance", x = 7, y = -191},
	[14] = {["spec"] = "Havoc", x = 7, y = -204},
	[15] = {["spec"] = "Retribution", x = 7, y = -217},
	[16] = {["spec"] = "Enhancement", x = 7, y = -230},
	[17] = {["spec"] = "Windwalker", x = 7, y = -243},
	[18] = {["spec"] = "Feral", x = 7, y = -256},
	[19] = {["spec"] = "Survival", x = 7, y = -269},
	[20] = {["spec"] = "Unholy", x = 7, y = -282},
	[21] = {["spec"] = "Frost (DK)", x = 7, y = -295},
	[22] = {["spec"] = "Arms", x = 7, y = -308},
	[23] = {["spec"] = "Fury", x = 7, y = -321},
	[24] = {["spec"] = "Outlaw", x = 7, y = -334},
	[25] = {["spec"] = "Assassination", x = 7, y = -347},
	[26] = {["spec"] = "Subtlety", x = 7, y = -360},
	[27] = {["spec"] = "Discipline", x = 7, y = -373},
	[28] = {["spec"] = "Preservation", x = 7, y = -386},
	[29] = {["spec"] = "Mistweaver", x = 7, y = -399},
	[30] = {["spec"] = "Restoration (Druid)", x = 7, y = -412},
	[31] = {["spec"] = "Restoration (Shaman)", x = 7, y = -425},
	[32] = {["spec"] = "Holy (Paladin)", x = 7, y = -438},
	[33] = {["spec"] = "Holy (Priest)", x = 7, y = -451},
	[34] = {["spec"] = "Brewmaster", x = 7, y = -464},
	[35] = {["spec"] = "Protection (Warrior)", x = 7, y = -477},
	[36] = {["spec"] = "Vengeance", x = 7, y = -490},
	[37] = {["spec"] = "Guardian", x = 7, y = -503},
	[38] = {["spec"] = "Protection (Paladin)", x = 7, y = -516},
	[39] = {["spec"] = "Blood", x = 7, y = -529},
	[40] = {["spec"] = "", x = 7, y = -542}
};
local specilizationToClassMap = {
	["Arcane"] = "MAGE",
	["Fire"] = "MAGE",
	["Frost (Mage)"] = "MAGE",
	["Beast Mastery"] = "HUNTER",
	["Marksmanship"] = "HUNTER",
	["Affliction"] = "WARLOCK",
	["Demonology"] = "WARLOCK",
	["Destruction"] = "WARLOCK",
	["Shadow"] = "PRIEST",
	["Devastation"] = "EVOKER",
	["Augmentation"] = "EVOKER",
	["Elemental"] = "SHAMAN",
	["Balance"] = "DRUID",
	["Havoc"] = "DEMONHUNTER",
	["Retribution"] = "PALADIN",
	["Enhancement"] = "SHAMAN",
	["Windwalker"] = "MONK",
	["Feral"] = "DRUID",
	["Survival"] = "HUNTER",
	["Unholy"] = "DEATHKNIGHT",
	["Frost (DK)"] = "DEATHKNIGHT",
	["Arms"] = "WARRIOR",
	["Fury"] = "WARRIOR",
	["Outlaw"] = "ROGUE",
	["Assassination"] = "ROGUE",
	["Subtlety"] = "ROGUE",
	["Discipline"] = "PRIEST",
	["Preservation"] = "EVOKER",
	["Mistweaver"] = "MONK",
	["Restoration (Druid)"] = "DRUID",
	["Restoration (Shaman)"] = "SHAMAN",
	["Holy (Paladin)"] = "PALADIN",
	["Holy (Priest)"] = "PRIEST",
	["Brewmaster"] = "MONK",
	["Protection (Warrior)"] = "WARRIOR",
	["Vengeance"] = "DEMONHUNTER",
	["Guardian"] = "DRUID",
	["Protection (Paladin)"] = "PALADIN",
	["Blood"] = "DEATHKNIGHT",
};
local specilizationToRoleMap = {
	["Arcane"] = "DAMAGER",
	["Fire"] = "DAMAGER",
	["Frost (Mage)"] = "DAMAGER",
	["Beast Mastery"] = "DAMAGER",
	["Marksmanship"] = "DAMAGER",
	["Affliction"] = "DAMAGER",
	["Demonology"] = "DAMAGER",
	["Destruction"] = "DAMAGER",
	["Shadow"] = "DAMAGER",
	["Devastation"] = "DAMAGER",
	["Augmentation"] = "DAMAGER",
	["Elemental"] = "DAMAGER",
	["Balance"] = "DAMAGER",
	["Havoc"] = "DAMAGER",
	["Retribution"] = "DAMAGER",
	["Enhancement"] = "DAMAGER",
	["Windwalker"] = "DAMAGER",
	["Feral"] = "DAMAGER",
	["Survival"] = "DAMAGER",
	["Unholy"] = "DAMAGER",
	["Frost (DK)"] = "DAMAGER",
	["Arms"] = "DAMAGER",
	["Fury"] = "DAMAGER",
	["Outlaw"] = "DAMAGER",
	["Assassination"] = "DAMAGER",
	["Subtlety"] = "DAMAGER",
	["Discipline"] = "HEALER",
	["Preservation"] = "HEALER",
	["Mistweaver"] = "HEALER",
	["Restoration (Druid)"] = "HEALER",
	["Restoration (Shaman)"] = "HEALER",
	["Holy (Paladin)"] = "HEALER",
	["Holy (Priest)"] = "HEALER",
	["Brewmaster"] = "TANK",
	["Protection (Warrior)"] = "TANK",
	["Vengeance"] = "TANK",
	["Guardian"] = "TANK",
	["Protection (Paladin)"] = "TANK",
	["Blood"] = "TANK",
};
function GetTexCoordsForRole(role)
	local textureHeight, textureWidth = 256, 256;
	local roleHeight, roleWidth = 67, 67;
	if ( role == "GUIDE" ) then
		return GetTexCoordsByGrid(1, 1, textureWidth, textureHeight, roleWidth, roleHeight);
	elseif ( role == "TANK" ) then
		return GetTexCoordsByGrid(1, 2, textureWidth, textureHeight, roleWidth, roleHeight);
	elseif ( role == "HEALER" ) then
		return GetTexCoordsByGrid(2, 1, textureWidth, textureHeight, roleWidth, roleHeight);
	elseif ( role == "DAMAGER" ) then
		return GetTexCoordsByGrid(2, 2, textureWidth, textureHeight, roleWidth, roleHeight);
	else
		error("Unknown role: "..tostring(role));
	end
end
local function resetUIData()
	UIData = {
		[1] = {["spec"] = "Arcane", x = 7, y = -35},
		[2] = {["spec"] = "Fire", x = 7, y = -48},
		[3] = {["spec"] = "Frost (Mage)", x = 7, y = -61},
		[4] = {["spec"] = "Beast Mastery", x = 7, y = -74},
		[5] = {["spec"] = "Marksmanship", x = 7, y = -87},
		[6] = {["spec"] = "Affliction", x = 7, y = -100},
		[7] = {["spec"] = "Demonology", x = 7, y = -113},
		[8] = {["spec"] = "Destruction", x = 7, y = -126},
		[9] = {["spec"] = "Shadow", x = 7, y = -139},
		[10] = {["spec"] = "Devastation", x = 7, y = -152},
		[11] = {["spec"] = "Augmentation", x = 7, y = -165},
		[12] = {["spec"] = "Elemental", x = 7, y = -178},
		[13] = {["spec"] = "Balance", x = 7, y = -191},
		[14] = {["spec"] = "Havoc", x = 7, y = -204},
		[15] = {["spec"] = "Retribution", x = 7, y = -217},
		[16] = {["spec"] = "Enhancement", x = 7, y = -230},
		[17] = {["spec"] = "Windwalker", x = 7, y = -243},
		[18] = {["spec"] = "Feral", x = 7, y = -256},
		[19] = {["spec"] = "Survival", x = 7, y = -269},
		[20] = {["spec"] = "Unholy", x = 7, y = -282},
		[21] = {["spec"] = "Frost (DK)", x = 7, y = -295},
		[22] = {["spec"] = "Arms", x = 7, y = -308},
		[23] = {["spec"] = "Fury", x = 7, y = -321},
		[24] = {["spec"] = "Outlaw", x = 7, y = -334},
		[25] = {["spec"] = "Assassination", x = 7, y = -347},
		[26] = {["spec"] = "Subtlety", x = 7, y = -360},
		[27] = {["spec"] = "Discipline", x = 7, y = -373},
		[28] = {["spec"] = "Preservation", x = 7, y = -386},
		[29] = {["spec"] = "Mistweaver", x = 7, y = -399},
		[30] = {["spec"] = "Restoration (Druid)", x = 7, y = -412},
		[31] = {["spec"] = "Restoration (Shaman)", x = 7, y = -425},
		[32] = {["spec"] = "Holy (Paladin)", x = 7, y = -438},
		[33] = {["spec"] = "Holy (Priest)", x = 7, y = -451},
		[34] = {["spec"] = "Brewmaster", x = 7, y = -464},
		[35] = {["spec"] = "Protection (Warrior)", x = 7, y = -477},
		[36] = {["spec"] = "Vengeance", x = 7, y = -490},
		[37] = {["spec"] = "Guardian", x = 7, y = -503},
		[38] = {["spec"] = "Protection (Paladin)", x = 7, y = -516},
		[39] = {["spec"] = "Blood", x = 7, y = -529},
		[40] = {["spec"] = "", x = 7, y = -542}
	};
	for i = 1, #priorityUI do
		if (i == #priorityUI) then
			break;
		end
		local button = priorityUI[i];
		button:SetText(UIData[i].spec);
		button:ClearAllPoints();
		button:SetPoint("TOPLEFT", priorityListFrame, "TOPLEFT", UIData[i].x, UIData[i].y);
		local classColor = RAID_CLASS_COLORS[specilizationToClassMap[UIData[i].spec]];
		button:GetNormalTexture():SetVertexColor(classColor.r, classColor.g, classColor.b);
		local roleIcon = button.roleIcon;
		roleIcon:SetTexCoord(GetTexCoordsForRole(specilizationToRoleMap[UIData[i].spec]));
		button.rankText:SetText(i..".");
	end
end
local function priorityList_OnUpdate(self)
	local cursorY = select(2, GetScaledCursorPosition());
	local top = priorityListFrame:GetTop() / UIParent:GetEffectiveScale();
	local bottom = priorityListFrame:GetBottom() / UIParent:GetEffectiveScale();

	-- Check if the cursor is within the bounds of the priority list frame
	if (cursorY > top - 15) then
		-- Check if cursor is close to the top edge
		buttonBeingDragged:StopMovingOrSizing();
		priorityListFrame:SetScript("OnUpdate", nil);
		return;
	elseif (cursorY < bottom + 15) then
		-- Check if cursor is close to the bottom edge
		buttonBeingDragged:StopMovingOrSizing();
		priorityListFrame:SetScript("OnUpdate", nil);
		return;
	end

	local pos = nil;
	-- Find the position of the button being dragged in the priority UI list
	for index, button in ipairs(priorityUI) do
		if (index == #priorityUI) then
			break;
		end
		if (button:GetName() == buttonBeingDragged:GetName()) then
			pos = index;
			break;
		end
	end

	-- Check if the button is dragged past another button
	local newPos = pos;
	for i = 1, #priorityUI do
		if (i ~= pos) then
			local button = priorityUI[i];
			local buttonY = button:GetTop() / UIParent:GetEffectiveScale();
			local deltaY = cursorY - buttonY;
			-- If the button being dragged passes another button, update the new position
			if (deltaY > -10 and deltaY < 30) then
				-- If the button is dragged downwards
				if (newPos < i) then
					if (newPos == pos - 1) then
						newPos = pos; -- Move to the position of the button being passed
					else
						newPos = i - 1;  -- Move up by 1 position
					end
				-- If the button is dragged upwards
				elseif (newPos > i) then
					newPos = i; -- Move to the position of the button being passed
				end
				break
			end
		end
	end

	-- Update the position of the dragged button based on the determined newPos
	if (newPos ~= pos) then
		local temp = priorityUI[pos];
		table.remove(priorityUI, pos);
		table.insert(priorityUI, newPos, temp);
	end
	-- Update the positions of all buttons in the priority UI list
	for i, button in ipairs(priorityUI) do
		if (i == #priorityUI) then
			break;
		end
		button:ClearAllPoints();
		button:SetPoint("TOPLEFT", priorityListFrame, "TOPLEFT", UIData[i].x, UIData[i].y);
		UIData[i].spec = button:GetText();
		button.rankText:SetText(i..".");
	end
end
for i = 1, #UIData do
	if (i == #UIData) then
		local specializationButton = CreateFrame("Button", "IRT_PriorityListButton"..UIData[i].spec, priorityListFrame);
		specializationButton:SetSize(180, 10);
		specializationButton:SetPoint("TOPLEFT", priorityListFrame, "TOPLEFT", UIData[i].x, UIData[i]. y);
		specializationButton:SetNormalTexture("Interface\\BUTTONS\\ListButtons");
		specializationButton:GetNormalTexture():SetAlpha(0); -- RGB values for red
		priorityUI[i] = specializationButton;
		specializationButton:Hide();
		break;
	end
	local specializationButton = CreateFrame("Button", "IRT_PriorityListButton"..UIData[i].spec, priorityListFrame);
	specializationButton:SetSize(180, 12);
	specializationButton:SetPoint("TOPLEFT", priorityListFrame, "TOPLEFT", UIData[i].x, UIData[i]. y);
	specializationButton:SetText(UIData[i].spec);
	specializationButton:GetFontString():SetFont("Fonts\\FRIZQT__.TTF", 9, "OUTLINE");
	specializationButton:RegisterForDrag("LeftButton");
	specializationButton:SetMovable(true);
	specializationButton:SetScript("OnDragStart", function(self)
		self:StartMoving();
		priorityListFrame:SetScript("OnUpdate", priorityList_OnUpdate);
		buttonBeingDragged = specializationButton;
	end);
	specializationButton:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing();
		priorityList_OnUpdate();
		priorityListFrame:SetScript("OnUpdate", nil);
		--findBestPosition(self);
	end);
	local classColor = RAID_CLASS_COLORS[specilizationToClassMap[UIData[i].spec]];
	specializationButton:SetNormalFontObject("GameFontNormal");
	specializationButton:SetHighlightFontObject("GameFontHighlight");
	specializationButton:GetFontString():SetTextColor(1, 1, 1, 1);
	specializationButton:SetNormalTexture("Interface\\BUTTONS\\WHITE8X8");
	specializationButton:GetNormalTexture():SetVertexColor(classColor.r, classColor.g, classColor.b) -- RGB values for red
	specializationButton:SetHighlightTexture("Interface/Buttons/ButtonHilight-Square", "ADD");
	local roleIcon = specializationButton:CreateTexture(nil, "OVERLAY");
	roleIcon:SetSize(9, 9);
	roleIcon:SetPoint("TOPRIGHT", specializationButton, "TOPRIGHT", -10, -2);
	roleIcon:SetTexture("Interface\\LFGFrame\\UI-LFG-ICON-ROLES");
	roleIcon:SetTexCoord(GetTexCoordsForRole(specilizationToRoleMap[UIData[i].spec]));
	specializationButton.roleIcon = roleIcon;
	local rankText = specializationButton:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall");
	rankText:SetPoint("TOPLEFT", 10, -2);
	rankText:SetText(i..".");
	rankText:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE");
	specializationButton.rankText = rankText;
	priorityUI[i] = specializationButton;
end
function IRT_SavePriorityList(boss)
	local priorityList = {};
	for i = 1, #UIData do
		if (i == #UIData) then
			break;
		end
		table.insert(priorityList, UIData[i].spec);
	end
	IRT_RPAFPriority[boss] = priorityList;
	resetUIData();
	return priorityList;
end
function IRT_OpenPriorityList(boss)
	if (not priorityListFrame:IsShown()) then
		priorityListFrameTitle:SetText("|cFFFFFFFF" .. L.OPTIONS_RPAF_PRIORITY_TITLE .. ": " .. bossIdToNameMap[boss]);
		if (IRT_RPAFPriority[boss]) then
			for i = 1, #IRT_RPAFPriority[boss] do
				if (i == #priorityUI) then
					break;
				end
				UIData[i].spec = IRT_RPAFPriority[boss][i];
				priorityUI[i]:SetText(IRT_RPAFPriority[boss][i]);
			end
		end
		for i = 1, #priorityUI do
			if (i == #priorityUI) then
				break;
			end
			local button = priorityUI[i];
			local classColor = RAID_CLASS_COLORS[specilizationToClassMap[UIData[i].spec]];
			button:GetNormalTexture():SetVertexColor(classColor.r, classColor.g, classColor.b);
			local roleIcon = button.roleIcon;
			roleIcon:SetTexCoord(GetTexCoordsForRole(specilizationToRoleMap[UIData[i].spec]));
			button.rankText:SetText(i..".");
			button:ClearAllPoints();
			button:SetPoint("TOPLEFT", priorityListFrame, "TOPLEFT", UIData[i].x, UIData[i].y);
		end
		saveButton:SetScript("OnClick", function(frame)
			IRT_SavePriorityList(boss);
			priorityListFrame:Hide();
		end);
		priorityListFrame:Show();
	else
		DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000" .. "IRT: Priority List is already open, close it before you open a new one.");
	end
end