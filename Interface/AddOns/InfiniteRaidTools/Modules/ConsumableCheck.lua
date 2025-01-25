local f2 = CreateFrame("Frame")--, nil, nil, BackdropTemplateMixin and "BackdropTemplate");
f2:SetMovable(false);
f2:EnableMouse(false);
f2:SetFrameLevel(3);
f2:SetFrameStrata("FULLSCREEN");
f2:SetHeight(25);
f2:SetWidth(218);
f2:Hide();
--[[
f2:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", --Set the background and border textures
	edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
	tile = true, tileSize = 16, edgeSize = 16,
	insets = { left = 4, right = 4, top = 4, bottom = 4 }
});
f2:SetBackdropColor(0.3,0.3,0.3,0.6);
f2:Hide();

local texture = f2:CreateTexture();
texture:SetTexture(0.5, 0.5, 0.5, 0.5);
texture:SetAllPoints();

local point, relativeTo, relativePoint, xOfs, yOfs = ReadyCheckFrameText:GetPoint();
ReadyCheckFrameText:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs+13);
point, relativeTo, relativePoint, xOfs, yOfs = ReadyCheckFrameYesButton:GetPoint();
ReadyCheckFrameYesButton:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs-10);
point, relativeTo, relativePoint, xOfs, yOfs = ReadyCheckFrameNoButton:GetPoint();
ReadyCheckFrameNoButton:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs-10);
]]

local consumableText = ReadyCheckListenerFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal");
consumableText:SetPoint("TOP", ReadyCheckFrameText, "TOP", 0, -18);

local buffBackgroundTextureTop1 = f2:CreateTexture(nil, "ARTWORK");
buffBackgroundTextureTop1:SetTexture("Interface\\RAIDFRAME\\UI-ReadyCheckFrame");
buffBackgroundTextureTop1:SetWidth(218);
buffBackgroundTextureTop1:SetHeight(5);
buffBackgroundTextureTop1:SetTexCoord(0.12,0.59,0.07,0.12);
buffBackgroundTextureTop1:SetPoint("TOPLEFT", 0,-5);
local buffBackgroundTextureCenter = f2:CreateTexture(nil, "BACKGROUND");
buffBackgroundTextureCenter:SetTexture("Interface\\RAIDFRAME\\UI-ReadyCheckFrame");
buffBackgroundTextureCenter:SetSize(218, 20);
buffBackgroundTextureCenter:SetTexCoord(0.2,0.5,0.1,0.7);
buffBackgroundTextureCenter:SetPoint("TOPLEFT", 0, -10);
local buffBackgroundTextureBottom1 = f2:CreateTexture(nil, "ARTWORK");
buffBackgroundTextureBottom1:SetTexture("Interface\\RAIDFRAME\\UI-ReadyCheckFrame");
buffBackgroundTextureBottom1:SetWidth(218);
buffBackgroundTextureBottom1:SetHeight(5);
buffBackgroundTextureBottom1:SetTexCoord(0.05,0.6,0.66,0.71);
buffBackgroundTextureBottom1:SetPoint("BOTTOMLEFT", 0, -5);
local buffBackgroundTextureLeft = f2:CreateTexture(nil, "ARTWORK");
buffBackgroundTextureLeft:SetTexture("Interface\\RAIDFRAME\\UI-ReadyCheckFrame");
buffBackgroundTextureLeft:SetWidth(3);
buffBackgroundTextureLeft:SetHeight(22);
buffBackgroundTextureLeft:SetTexCoord(0.61,0.62,0.15,0.64);
buffBackgroundTextureLeft:SetPoint("TOPLEFT", -1, -8);
local buffBackgroundTextureRight = f2:CreateTexture(nil, "ARTWORK");
buffBackgroundTextureRight:SetTexture("Interface\\RAIDFRAME\\UI-ReadyCheckFrame");
buffBackgroundTextureRight:SetWidth(3);
buffBackgroundTextureRight:SetHeight(22);
buffBackgroundTextureRight:SetTexCoord(0.61,0.62,0.15,0.64);
buffBackgroundTextureRight:SetPoint("TOPRIGHT", 0, -8);

local rcText = f2:CreateFontString(nil, "ARTWORK", "GameFontNormal");
rcText:SetPoint("TOPLEFT", 0, -15);
rcText:SetJustifyV("TOP");
rcText:SetJustifyH("CENTER");
rcText:SetFont("Fonts\\FRIZQT__.TTF", 8.5);
rcText:SetText("");
rcText:SetSize(f2:GetWidth(), f2:GetHeight());

local text2 = ReadyCheckListenerFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal");
text2:SetPoint("TOP", ReadyCheckFrameText, "TOP", 0, -40);
text2:SetFont("Fonts\\FRIZQT__.TTF", 12);
text2:SetJustifyH("CENTER");
local text3 = ReadyCheckListenerFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal");
text3:SetPoint("BOTTOM", text2, "BOTTOM", 0, -18);
text3:SetFont("Fonts\\FRIZQT__.TTF", 12);
text3:SetJustifyH("CENTER");

local f = CreateFrame("Frame");

SLASH_INFINITECONSUMABLE1 = "/irtc";

local RED = "\124cFFFF0000";
local YELLOW = "\124cFFFFFF00";
local GREEN = "\124cFF00FF00";
local CROSS = "\124TInterface\\addons\\InfiniteRaidTools\\Res\\cross:16\124t";
local CHECK = "\124TInterface\\addons\\InfiniteRaidTools\\Res\\check:16\124t";

local playerBuffs = {
	["flask"] = CROSS,
	["oil"] = CROSS,
	["food"] = CROSS,
	["rune"] = CROSS,
	["buffs"] = 0,
};

local flasks = {432021, 431971, 431974, 431972, 431973, 432473};
local oilsIDs = {6512, 6513, 6514, 6515, 6694, 6695, 6516, 6517, 6518};
local oilIconIDs = {
	[7493] = 609892, --mana oil
	[7494] = 609892, --mana oil
	[7495] = 609892, --mana oil
	[7496] = 609897, --deep
	[7497] = 609897, --deep
	[7498] = 609897, --deep
	[7500] = 609896, --beledar's grace
	[7501] = 609896, --beledar's grace
	[7502] = 609896, --beledar's grace
	[7543] = 3622195, --whetstone
	[7544] = 3622195, --whetstone
	[7545] = 3622195, --whetstone
	[7549] = 3622199, --weightstone
	[7550] = 3622199, --weightstone
	[7551] = 3622199, --weightstone
};
local rcSender = "";
local raiders = {};
local playerName = UnitName("player");

local oilTimers = {
	["Main Hand"] = 0,
	["Off Hand"] = 0,
};

local oilBindings = {
	["Beledar's Grace"] = "Beledar's Grace: No modifier(MH Only)",
	["Mana Oil"] = "Mana Oil: SHIFT(MH Only)",
	["Deep"] = "Deep: CTRL",
--	["Shaded Weightstone"] = "Shaded Weightstone: ALT",
};

local buffSpellIDs = {
	["MAGE"] = 1459,
	["PRIEST"] = 21562,
	["WARRIOR"] = 6673,
	["EVOKER"] = 381748,
	["DRUID"] = 1126,
	["SHAMAN"] = 462854,
};

local buffIconIDs = {
	["MAGE"] = 135932,
	["PRIEST"] = 135987,
	["WARRIOR"] = 132333,
	["EVOKER"] = 4622448,
	["DRUID"] = 136078,
	["SHAMAN"] = 4630367,
};

local IRT_UnitBuff = IRT_UnitBuff;
local UnitIsUnit = UnitIsUnit;
local UnitIsVisible = UnitIsVisible;
local GetWeaponEnchantInfo = GetWeaponEnchantInfo;
local C_Spell = C_Spell;
local GetInventoryItemID = GetInventoryItemID;
local GetInventorySlotInfo = GetInventorySlotInfo;
local tonumber = tonumber;
local math = math;
local select = select;
local IsInRaid = IsInRaid;
local IsInGroup = IsInGroup;
local GetNumGroupMembers = GetNumGroupMembers;

f:RegisterEvent("PLAYER_LOGIN");
f:RegisterEvent("READY_CHECK");
f:RegisterEvent("ENCOUNTER_START");

local offhand = GetInventoryItemID("player", GetInventorySlotInfo("SecondaryHandSlot"));
local isOffhandWeapon = false;
if (offhand and select(6, GetItemInfo(offhand)) == "Weapon") then
	isOffhandWeapon = true;
end

local autoOil = CreateFrame("Button", "IRT_AutoOilButton", nil, "SecureActionButtonTemplate");
autoOil:ClearAllPoints();
autoOil:RegisterForClicks("AnyUp", "AnyDown"); --this is treated as an action button and therefor uses ActionButtonUseKeyDown which either only allows Up or Down presses
autoOil:SetNormalTexture("Interface\\Icons\\inv_misc_rune_08");

autoOil:SetAttribute("type", "macro");
autoOil:SetAttribute("macrotext1", "/Use Oil of Beledar's Grace\n/use 16\n/click StaticPopup1Button1");
autoOil:SetAttribute("shift-macrotext1", "/Use Algari Mana Oil\n/use 16\n/click StaticPopup1Button1");
autoOil:SetAttribute("ctrl-macrotext1", "/Use Chirping Rune\n/use 16\n/click StaticPopup1Button1");
--autoOil:SetAttribute("alt-macrotext1", "/Use Shaded Weightstone\n/use 16\n/click StaticPopup1Button1");
autoOil:SetAttribute("macrotext2", "/Use Oil of Beledar's Grace\n/use 17\n/click StaticPopup1Button1");
autoOil:SetAttribute("shift-macrotext2", "/Use Algari Mana Oil\n/use 17\n/click StaticPopup1Button1");
autoOil:SetAttribute("ctrl-macrotext2", "/Use Chirping Rune\n/use 17\n/click StaticPopup1Button1");
--autoOil:SetAttribute("alt-macrotext2", "/Use Shaded Weightstone\n/use 17\n/click StaticPopup1Button1");
autoOil:SetAttribute("alt-ctrl-shiftmacrotext", "/run autoOil:Hide();");

autoOil:SetSize(25,25);
autoOil:SetPoint("RIGHT", ReadyCheckFrame, "RIGHT", 40, -15);
autoOil:SetFrameStrata("FULLSCREEN");
autoOil:SetClampedToScreen(true);
autoOil:SetMovable(true);
autoOil:RegisterForDrag("LeftButton");
autoOil:SetScript("OnDragStart", function(self)
	if (IsAltKeyDown() and IsControlKeyDown()) then
		self:StartMoving();
	end
end);
autoOil:SetScript("OnDragStop", function(self)
	local point, relativeTo, relativePoint, xOffset, yOffset = self:GetPoint(1);
	IRT_AutoOilPosition = {};
	IRT_AutoOilPosition.point = point;
	IRT_AutoOilPosition.relativeTo = relativeTo;
	IRT_AutoOilPosition.relativePoint = relativePoint;
	IRT_AutoOilPosition.xOffset = xOffset;
	IRT_AutoOilPosition.yOffset = yOffset;
	self:StopMovingOrSizing();
end);

autoOil:Hide();
autoOil:SetScript("OnLeave", function(self)
	GameTooltip:Hide();
end);

local function handler(msg, editbox)
	if (autoOil:IsShown()) then
		autoOil:Hide();
	else
		autoOil:Show();
	end
end
SlashCmdList["INFINITECONSUMABLE"] = handler;

local flaskIcon, flaskTime;
local _;
local function checkForFlask()
	playerBuffs["flask"] = CROSS;
	for i = 1, #flasks do
		_, flaskIcon, _, _, _, flaskTime = IRT_UnitBuff("player", C_Spell.GetSpellInfo(flasks[i]).name);
		if (flaskTime) then
			flaskTime = flaskTime and math.floor((tonumber(flaskTime)-GetTime())/60) or nil;
			if (flaskTime) then
				if (flaskTime > 15) then
					flaskTime = GREEN .. flaskTime .. "min|r";
				elseif (flaskTime <= 15 and flaskTime > 8) then
					flaskTime = YELLOW .. flaskTime .. "min|r";
				elseif (flaskTime <= 8) then
					flaskTime = RED .. flaskTime .. "min|r";
				end
			end
			playerBuffs["flask"] = flaskTime;
			break;
		end
	end
	flaskIcon = flaskIcon and flaskIcon or 5931173;
end

local food, foodIcon;
local function checkForFood()
	food, foodIcon = IRT_UnitBuff("player", C_Spell.GetSpellInfo(297039).name); -- Random Well Fed Buff
	foodIcon = foodIcon and foodIcon or 136000;
	if (food) then
		playerBuffs["food"] = CHECK;
	elseif (IRT_UnitBuff("player", C_Spell.GetSpellInfo(462191).name)) then -- Random Hearty Well Fed Buff
		playerBuffs["food"] = CHECK;
	else
		playerBuffs["food"] = CROSS;
	end
end
local rune, runeIcon;
local function checkForRune()
	rune, runeIcon = IRT_UnitBuff("player", C_Spell.GetSpellInfo(453250).name);
	runeIcon = runeIcon and runeIcon or 4549102;
	if (rune) then
		playerBuffs["rune"] = CHECK;
	else
		playerBuffs["rune"] = CROSS;
	end
end

local class = select(2, UnitClass("player"));
local canBuff = false;
local everyoneHasBuff = false;
if (class == "MAGE" or class == "PRIEST" or class == "WARRIOR" or class == "DRUID" or class == "EVOKER" or class == "SHAMAN") then
	canBuff = true;
end
local count = 0;
local total = 0;
local unit;
local function checkForBuffs()
	everyoneHasBuff = false;
	if (canBuff) then
		count = 0;
		total = 0;
		if (IsInRaid()) then
			for i = 1, GetNumGroupMembers() do
				unit = "raid"..i;
				if (UnitIsVisible(unit)) then
					total = total + 1;
					if (IRT_UnitBuff(unit, C_Spell.GetSpellInfo(buffSpellIDs[class]).name)) then
						count = count + 1;
					end
				end
			end
			if (total == count) then
				everyoneHasBuff = true;
			end
		elseif (IsInGroup()) then
			for i = 1, GetNumGroupMembers()-1 do
				unit = "party"..i;
				if (UnitIsVisible(unit)) then
					total = total + 1;
					if (IRT_UnitBuff(unit, C_Spell.GetSpellInfo(buffSpellIDs[class]).name)) then
						count = count + 1;
					end
				end
			end
			total = total + 1;
			if (IRT_UnitBuff("player", C_Spell.GetSpellInfo(buffSpellIDs[class]).name)) then
				count = count + 1;
			end
			if (total == count) then
				everyoneHasBuff = true;
			end
		end
		playerBuffs["buffs"] = count == total and (GREEN .. count .. "/" .. total) or (RED .. count .. "/" .. total);
	end
end
local oil, oilTime, oilID, offhandOil, offhandOilTime, _, offhandOilID;
local oilCount;
local oilIcon;
local function checkForOil()
	oil, oilTime, _, oilID, offhandOil, offhandOilTime, _, offhandOilID = GetWeaponEnchantInfo();
	oilCount = 0;
	offhand = GetInventoryItemID("player", GetInventorySlotInfo("SecondaryHandSlot"));
	if (offhand and select(6, GetItemInfo(offhand)) == "Weapon") then
		isOffhandWeapon = true;
	else
		isOffhandWeapon = false;
	end
	if (oil) then
		oilIcon = oilIconIDs[oilID];
	elseif (offhandOil) then
		oilIcon = oilIconIDs[offhandOilID];
	end
	oilIcon = oilIcon and oilIcon or 609892;
	if (oilTime and offhandOilTime) then
		oilTime = math.floor(tonumber(oilTime)/1000/60);
		offhandOilTime = math.floor(tonumber(offhandOilTime)/1000/60);
		oilTimers["Main Hand"] = GREEN .. oilTime .. "min|r";
		oilTimers["Off Hand"] = GREEN .. offhandOilTime .. "min|r";
		oilCount = 2;
		if (oilTime > offhandOilTime) then
			oilTime = offhandOilTime;
		end
	elseif (oilTime) then
		oilTime = math.floor(tonumber(oilTime)/1000/60);
		oilTimers["Main Hand"] = GREEN .. oilTime .. "min|r";
		oilTimers["Off Hand"] = RED .. "0min|r";
		oilCount = 1;
	elseif (offhandOilTime) then
		oilTime = math.floor(tonumber(offhandOilTime)/1000/60);
		oilTimers["Main Hand"] = RED .. "0min|r"
		oilTimers["Off Hand"] = GREEN .. oilTime .. "min|r";
		oilCount = 1;
	else
		oilTimers["Main Hand"] = RED .. "0min|r";
		oilTimers["Off Hand"] = RED .. "0min|r";
		oilTime = nil;
	end
	if (oilTime) then
		if (oilCount == 2) then
			oilCount = GREEN .. "2/2 ";
		elseif (isOffhandWeapon) then
			oilCount = RED .. "1/2 ";
		else
			oilCount = "";
		end
		if (oilTime > 15) then
			oilTime = GREEN .. oilTime .. "min|r";
		elseif (oilTime <= 15 and oilTime > 8) then
			oilTime = YELLOW .. oilTime .. "min|r";
		elseif (oilTime <= 8) then
			oilTime = RED .. oilTime .. "min|r";
		end
	else
		oilCount = "";
		oilTime = CROSS;
	end
	playerBuffs["oil"] = oilTime;
end
local blizzText;
local function updateConsumableText()
	if (ReadyCheckFrame:IsShown() and ReadyCheckFrameText:GetText() and (not UnitIsUnit(rcSender, playerName) or IRT_SenderReadyCheck)) then
		blizzText = ReadyCheckFrameText:GetText();
		if (UnitIsUnit(playerName.."(Consumable Check)", ReadyCheckFrame.initiator)) then --this is a bug without elvui
			blizzText = playerName .. " initiated a ready check";
		else
			if (blizzText:find("%-")) then
				local _, _, name = blizzText:find("([^-]*)");
				blizzText = name .. " initiated a ready check";
			else
				local _, _, name = blizzText:find("([^%s]*)");
				blizzText = name .. " initiated a ready check";
			end
		end
		if (canBuff) then
			if (ReadyCheckFrame.backdropInfo and ReadyCheckFrame.backdropInfo.bgFile and ReadyCheckFrame.backdropInfo.bgFile:match("ElvUI")) then
				ReadyCheckFrameText:SetSize(320, 40);
				ReadyCheckFrameText:SetText(blizzText .. "\n\n\124T".. flaskIcon .. ":16\124t" .. playerBuffs["flask"] .. " \124T" .. oilIcon .. ":16\124t" .. oilCount .. playerBuffs["oil"] .. " \124T" .. foodIcon .. ":16\124t" .. playerBuffs["food"] .. " \124T" .. runeIcon .. ":16\124t" .. playerBuffs["rune"] .. " \124T" .. buffIconIDs[class] .. ":16\124t" .. playerBuffs["buffs"]);
			else
				--f2:SetPoint("BOTTOM", ReadyCheckFrame, "BOTTOM", 2, -14);
				--f2:Show();
				ReadyCheckFrameText:SetPoint("TOP", 20, -18);
				consumableText:SetText("\124T" .. flaskIcon .. ":16\124t" .. playerBuffs["flask"] .. " \124T" .. oilIcon .. ":16\124t" .. oilCount .. playerBuffs["oil"] .. " \124T" .. foodIcon .. ":16\124t" .. playerBuffs["food"]  .. " \124T" .. runeIcon .. ":16\124t" .. playerBuffs["rune"] .." \124T" .. buffIconIDs[class] .. ":16\124t" .. playerBuffs["buffs"]);
				ReadyCheckFrameText:SetText(blizzText);
				rcText:SetText("\124T" .. flaskIcon .. ":16\124t" .. playerBuffs["flask"] .. " \124T" .. oilIcon .. ":16\124t" .. oilCount .. playerBuffs["oil"] .. " \124T" .. foodIcon .. ":16\124t" .. playerBuffs["food"] .. " \124T" .. runeIcon .. ":16\124t" .. playerBuffs["rune"] .." \124T" .. buffIconIDs[class] .. ":16\124t" .. playerBuffs["buffs"]);
			end
			--ReadyCheckFrameText:SetText(blizzText);
			--text2:SetText("\124T" .. flaskIcon .. ":16\124t" .. flaskTime .. " \124T" .. oilIcon .. ":16\124t" .. oilTime .. "  \124T" .. armorKitIcon .. ":16\124t" .. armorKitCount .. armorKitTime);
			--text3:SetText("\124T" .. foodIcon .. ":16\124t" .. (food and CHECK or CROSS) .. " \124T" .. runeIcon .. ":16\124t" .. (rune and CHECK or CROSS) .. " \124T" .. buffIconIDs[class] .. ":16\124t" .. (count == total and (GREEN .. count .. "/" .. total) or (RED .. count .. "/" .. total)));
			--rcText:SetText("\124T" .. flaskIcon .. ":16\124t" .. flaskTime .. " \124T" .. oilIcon .. ":16\124t" .. oilTime .. " \124T" .. armorKitIcon .. ":16\124t" .. armorKitCount .. armorKitTime .. " \124T" .. foodIcon .. ":16\124t" .. (food and CHECK or CROSS) .. " \124T" .. runeIcon .. ":16\124t" .. (rune and CHECK or CROSS) .. " \124T" .. buffIconIDs[class] .. ":16\124t" .. (count == total and (GREEN .. count .. "/" .. total) or (RED .. count .. "/" .. total)));
		else
			if (ReadyCheckFrame.backdropInfo and ReadyCheckFrame.backdropInfo.bgFile and ReadyCheckFrame.backdropInfo.bgFile:match("ElvUI")) then
				ReadyCheckFrameText:SetSize(320, 40);
				ReadyCheckFrameText:SetText(blizzText .. "\n\n\124T".. flaskIcon .. ":16\124t" .. playerBuffs["flask"] .. " \124T" .. oilIcon .. ":16\124t" .. oilCount .. playerBuffs["oil"] .. " \124T" .. foodIcon .. ":16\124t" .. playerBuffs["food"] .. " \124T" .. runeIcon .. ":16\124t" .. playerBuffs["rune"]);
			else
				--f2:SetPoint("BOTTOM", ReadyCheckFrame, "BOTTOM", 0, -17);
				--f2:Show();
				ReadyCheckFrameText:SetPoint("TOP", 20, -18);
				ReadyCheckFrameText:SetText(blizzText);
				consumableText:SetText("\124T" .. flaskIcon .. ":16\124t" .. playerBuffs["flask"] .. " \124T" .. oilIcon .. ":16\124t" .. oilCount .. playerBuffs["oil"] .. " \124T" .. foodIcon .. ":16\124t" .. playerBuffs["food"]  .. " \124T" .. runeIcon .. ":16\124t" .. playerBuffs["rune"]);
				rcText:SetText("\124T" .. flaskIcon .. ":16\124t" .. playerBuffs["flask"] .. " \124T" .. oilIcon .. ":16\124t" .. oilCount .. playerBuffs["oil"] .. " \124T" .. foodIcon .. ":16\124t" .. playerBuffs["food"] .. " \124T" .. runeIcon .. ":16\124t" .. playerBuffs["rune"]);
			end
			--ReadyCheckFrameText:SetText(blizzText .. "\n\n\124T".. flaskIcon .. ":16\124t" .. flaskTime .. " \124T" .. oilIcon .. ":16\124t" .. oilTime .. " \124T" .. foodIcon .. ":16\124t" .. (food and CHECK or CROSS) .. " \124T" .. runeIcon .. ":16\124t" .. (rune and CHECK or CROSS));
		end
	end
end

--[[
local function updateConsumables()
	_, flaskIcon, _, _, _, flaskTime = IRT_UnitBuff("player", C_Spell.GetSpellInfo(371339).name);
	for i = 1, #flasks do
		_, flaskIcon, _, _, _, flaskTime = IRT_UnitBuff("player", C_Spell.GetSpellInfo(flasks[i]).name);
		if (flaskTime) then
			break;
		end
	end
	local oil, oilTime, _, oilID, offhandOil, offhandOilTime, _, offhandOilID = GetWeaponEnchantInfo();
	offhand = GetInventoryItemID("player", GetInventorySlotInfo("SecondaryHandSlot"));
	if (offhand and select(6, GetItemInfo(offhand)) == "Weapon") then
		isOffhandWeapon = true;
	else
		isOffhandWeapon = false;
	end
	local oilCount = 0;
	local oilIcon = nil;
	if (oil) then
		oilIcon = oilIconIDs[oilID];
	elseif (offhandOil) then
		oilIcon = oilIconIDs[offhandOilID];
	end
	if (oilTime and offhandOilTime) then
		oilTime = math.floor(tonumber(oilTime)/1000/60);
		offhandOilTime = math.floor(tonumber(offhandOilTime)/1000/60);
		oilTimers["Main Hand"] = GREEN .. oilTime .. "min|r";
		oilTimers["Off Hand"] = GREEN .. offhandOilTime .. "min|r";
		oilCount = 2;
		if (oilTime > offhandOilTime) then
			oilTime = offhandOilTime;
		end
	elseif (oilTime) then
		oilTime = math.floor(tonumber(oilTime)/1000/60);
		oilTimers["Main Hand"] = GREEN .. oilTime .. "min|r";
		oilTimers["Off Hand"] = RED .. "0min|r";
		oilCount = 1;
	elseif (offhandOilTime) then
		oilTime = math.floor(tonumber(offhandOilTime)/1000/60);
		oilTimers["Main Hand"] = RED .. "0min|r"
		oilTimers["Off Hand"] = GREEN .. oilTime .. "min|r";
		oilCount = 1;
	else
		oilTimers["Main Hand"] = RED .. "0min|r";
		oilTimers["Off Hand"] = RED .. "0min|r";
		oilTime = nil;
	end
	if (oilTime) then
		if (oilCount == 2) then
			oilCount = GREEN .. "2/2 ";
		elseif (isOffhandWeapon) then
			oilCount = RED .. "1/2 ";
		else
			oilCount = "";
		end
		if (oilTime > 15) then
			oilTime = GREEN .. oilTime .. "min|r";
		elseif (oilTime <= 15 and oilTime > 8) then
			oilTime = YELLOW .. oilTime .. "min|r";
		elseif (oilTime <= 8) then
			oilTime = RED .. oilTime .. "min|r";
		end
	else
		oilCount = "";
		oilTime = CROSS;
	end
	local food, foodIcon, _, _, _, foodTime = IRT_UnitBuff("player", C_Spell.GetSpellInfo(297039).name); -- Random Well Fed Buff
	local rune, runeIcon, _, _, _, runeTime = IRT_UnitBuff("player", C_Spell.GetSpellInfo(393438).name);
	flaskIcon = flaskIcon and flaskIcon or 4497587;
	oilIcon = oilIcon and oilIcon or 134421;
	foodIcon = foodIcon and foodIcon or 136000;
	runeIcon = runeIcon and runeIcon or 4644002;
	if (ReadyCheckFrame:IsShown() and ReadyCheckFrameText:GetText() and (not UnitIsUnit(rcSender, playerName) or IRT_SenderReadyCheck)) then
		local blizzText = ReadyCheckFrameText:GetText();
		if (UnitIsUnit(playerName.."(Consumable Check)", ReadyCheckFrame.initiator)) then --this is a bug without elvui
			blizzText = playerName .. " initiated a ready check";
		else
			if (blizzText:find("%-")) then
				local head, tail, name = blizzText:find("([^-]*)");
				blizzText = name .. " initiated a ready check";
			else
				local head, tail, name = blizzText:find("([^%s]*)");
				blizzText = name .. " initiated a ready check";
			end
		end
		local currTime = GetTime();
		flaskTime = flaskTime and math.floor((tonumber(flaskTime)-currTime)/60) or nil;
		if (flaskTime) then
			if (flaskTime > 15) then
				flaskTime = GREEN .. flaskTime .. "min|r";
			elseif (flaskTime <= 15 and flaskTime > 8) then
				flaskTime = YELLOW .. flaskTime .. "min|r";
			elseif (flaskTime <= 8) then
				flaskTime = RED .. flaskTime .. "min|r";
			end
		else
			flaskTime = CROSS;
		end
		local class = select(2, UnitClass("player"));
		if (class == "MAGE" or class == "PRIEST" or class == "WARRIOR" or class == "DRUID" or class == "EVOKER" or class == "SHAMAN") then
			local count = 0;
			local total = 0;
			if (IsInRaid()) then
				for i = 1, GetNumGroupMembers() do
					local unit = "raid"..i;
					if (UnitIsVisible(unit)) then
						total = total + 1;
						if (IRT_UnitBuff(unit, C_Spell.GetSpellInfo(buffSpellIDs[class]).name)) then
							count = count + 1;
						end
					end
				end
			elseif (IsInGroup()) then
				for i = 1, GetNumGroupMembers()-1 do
					local unit = "party"..i;
					if (UnitIsVisible(unit)) then
						total = total + 1;
						if (IRT_UnitBuff(unit, C_Spell.GetSpellInfo(buffSpellIDs[class]).name)) then
							count = count + 1;
						end
					end
				end
				total = total + 1;
				if (IRT_UnitBuff("player", C_Spell.GetSpellInfo(buffSpellIDs[class]).name)) then
					count = count + 1;
				end
			end
			if (ReadyCheckFrame.backdropInfo and ReadyCheckFrame.backdropInfo.bgFile and ReadyCheckFrame.backdropInfo.bgFile:match("ElvUI")) then
				ReadyCheckFrameText:SetSize(320, 40);
				ReadyCheckFrameText:SetText(blizzText .. "\n\n\124T".. flaskIcon .. ":16\124t" .. flaskTime .. " \124T" .. oilIcon .. ":16\124t" .. oilCount .. oilTime .. " \124T" .. foodIcon .. ":16\124t" .. (food and CHECK or CROSS) .. " \124T" .. runeIcon .. ":16\124t" .. (rune and CHECK or CROSS) .. " \124T" .. buffIconIDs[class] .. ":16\124t" .. (count == total and (GREEN .. count .. "/" .. total) or (RED .. count .. "/" .. total)));
			else
				--f2:SetPoint("BOTTOM", ReadyCheckFrame, "BOTTOM", 2, -14);
				--f2:Show();
				ReadyCheckFrameText:SetPoint("TOP", 20, -18);
				consumableText:SetText("\124T" .. flaskIcon .. ":16\124t" .. flaskTime .. " \124T" .. oilIcon .. ":16\124t" .. oilCount .. oilTime .. " \124T" .. foodIcon .. ":16\124t" .. (food and CHECK or CROSS)  .. " \124T" .. runeIcon .. ":16\124t" .. (rune and CHECK or CROSS) .." \124T" .. buffIconIDs[class] .. ":16\124t" .. (count == total and (GREEN .. count .. "/" .. total) or (RED .. count .. "/" .. total)));
				ReadyCheckFrameText:SetText(blizzText);
				rcText:SetText("\124T" .. flaskIcon .. ":16\124t" .. flaskTime .. " \124T" .. oilIcon .. ":16\124t" .. oilCount .. oilTime .. " \124T" .. foodIcon .. ":16\124t" .. (food and CHECK or CROSS) .. " \124T" .. runeIcon .. ":16\124t" .. (rune and CHECK or CROSS) .." \124T" .. buffIconIDs[class] .. ":16\124t" .. (count == total and (GREEN .. count .. "/" .. total) or (RED .. count .. "/" .. total)));
			end
			--ReadyCheckFrameText:SetText(blizzText);
			--text2:SetText("\124T" .. flaskIcon .. ":16\124t" .. flaskTime .. " \124T" .. oilIcon .. ":16\124t" .. oilTime .. "  \124T" .. armorKitIcon .. ":16\124t" .. armorKitCount .. armorKitTime);
			--text3:SetText("\124T" .. foodIcon .. ":16\124t" .. (food and CHECK or CROSS) .. " \124T" .. runeIcon .. ":16\124t" .. (rune and CHECK or CROSS) .. " \124T" .. buffIconIDs[class] .. ":16\124t" .. (count == total and (GREEN .. count .. "/" .. total) or (RED .. count .. "/" .. total)));
			--rcText:SetText("\124T" .. flaskIcon .. ":16\124t" .. flaskTime .. " \124T" .. oilIcon .. ":16\124t" .. oilTime .. " \124T" .. armorKitIcon .. ":16\124t" .. armorKitCount .. armorKitTime .. " \124T" .. foodIcon .. ":16\124t" .. (food and CHECK or CROSS) .. " \124T" .. runeIcon .. ":16\124t" .. (rune and CHECK or CROSS) .. " \124T" .. buffIconIDs[class] .. ":16\124t" .. (count == total and (GREEN .. count .. "/" .. total) or (RED .. count .. "/" .. total)));
		else
			if (ReadyCheckFrame.backdropInfo and ReadyCheckFrame.backdropInfo.bgFile and ReadyCheckFrame.backdropInfo.bgFile:match("ElvUI")) then
				ReadyCheckFrameText:SetSize(320, 40);
				ReadyCheckFrameText:SetText(blizzText .. "\n\n\124T".. flaskIcon .. ":16\124t" .. flaskTime .. " \124T" .. oilIcon .. ":16\124t" .. oilCount .. oilTime .. " \124T" .. foodIcon .. ":16\124t" .. (food and CHECK or CROSS) .. " \124T" .. runeIcon .. ":16\124t" .. (rune and CHECK or CROSS));
			else
				--f2:SetPoint("BOTTOM", ReadyCheckFrame, "BOTTOM", 0, -17);
				--f2:Show();
				ReadyCheckFrameText:SetPoint("TOP", 20, -18);
				ReadyCheckFrameText:SetText(blizzText);
				consumableText:SetText("\124T" .. flaskIcon .. ":16\124t" .. flaskTime .. " \124T" .. oilIcon .. ":16\124t" .. oilCount .. oilTime .. " \124T" .. foodIcon .. ":16\124t" .. (food and CHECK or CROSS)  .. " \124T" .. runeIcon .. ":16\124t" .. (rune and CHECK or CROSS));
				rcText:SetText("\124T" .. flaskIcon .. ":16\124t" .. flaskTime .. " \124T" .. oilIcon .. ":16\124t" .. oilCount .. oilTime .. " \124T" .. foodIcon .. ":16\124t" .. (food and CHECK or CROSS) .. " \124T" .. runeIcon .. ":16\124t" .. (rune and CHECK or CROSS));
			end
			--ReadyCheckFrameText:SetText(blizzText .. "\n\n\124T".. flaskIcon .. ":16\124t" .. flaskTime .. " \124T" .. oilIcon .. ":16\124t" .. oilTime .. " \124T" .. foodIcon .. ":16\124t" .. (food and CHECK or CROSS) .. " \124T" .. runeIcon .. ":16\124t" .. (rune and CHECK or CROSS));
		end
	end
end
]]
autoOil:HookScript("OnClick", function(self, button, down)
	autoOil:SetAttribute("macrotext1", "/Use Oil of Beledar's Grace\n/use 16\n/click StaticPopup1Button1");
	autoOil:SetAttribute("shift-macrotext1", "/Use Algari Mana Oil\n/use 16\n/click StaticPopup1Button1");
	autoOil:SetAttribute("ctrl-macrotext1", "/Use Chirping Rune\n/use 16\n/click StaticPopup1Button1");
	--autoOil:SetAttribute("alt-macrotext1", "/Use Shaded Weightstone\n/use 16\n/click StaticPopup1Button1");
	autoOil:SetAttribute("macrotext2", "/Use Oil of Beledar's Grace\n/use 17\n/click StaticPopup1Button1");
	autoOil:SetAttribute("shift-macrotext2", "/Use Algari Mana Oil\n/use 17\n/click StaticPopup1Button1");
	autoOil:SetAttribute("ctrl-macrotext2", "/Use Chirping Rune\n/use 17\n/click StaticPopup1Button1");
	--autoOil:SetAttribute("alt-macrotext2", "/Use Shaded Weightstone\n/use 17\n/click StaticPopup1Button1");
	autoOil:SetAttribute("alt-ctrl-shiftmacrotext", "/run autoOil:Hide();");
	if (button == "MiddleButton") then
		autoOil:Hide();
	end
end);

autoOil:HookScript("OnEnter", function(self)
	f:RegisterEvent("UNIT_AURA");
	f:RegisterEvent("UNIT_INVENTORY_CHANGED");
	checkForOil();
	--updateConsumables();
	local tooltipText = "|cFF00FFFFIRT:|r\n|cFFFFFFFFLeft+Modifier for main hand\nRight+Modifier for off hand|r\nModifiers:";
	for id, modifierInfo in pairs (oilBindings) do
		tooltipText = tooltipText .. "\n|cFFFFFFFF" .. modifierInfo .. "|r";
	end
	if (isOffhandWeapon) then
		tooltipText = tooltipText .. "\n" .. "Main Hand" .. ": " .. oilTimers["Main Hand"];
		tooltipText = tooltipText .. "\n" .. "Off Hand" .. ": " .. oilTimers["Off Hand"];
	else
		tooltipText = tooltipText .. "\n" .. "Main Hand" .. ": " .. oilTimers["Main Hand"];
	end
	tooltipText = tooltipText .. "\n|cFFFFFFFFCTRL+ALT+Drag to move\nToggle: /irtc or Middle Click to close.|r";
	GameTooltip:SetOwner(autoOil);
	GameTooltip:SetText(tooltipText);
	GameTooltip:Show();
end);

ReadyCheckFrame:HookScript("OnHide", function()
	if (IRT_ConsumableCheckEnabled) then
		f:UnregisterEvent("UNIT_AURA");
		f:UnregisterEvent("UNIT_INVENTORY_CHANGED");
		autoOil:Hide();
		f2:Hide();
	end
end);
ReadyCheckFrame:HookScript("OnShow", function()
	if (IRT_ConsumableCheckEnabled) then
		if (ReadyCheckFrame.initiator and UnitIsUnit(ReadyCheckFrame.initiator, playerName) and IRT_SenderReadyCheck) then
			C_Timer.After(0.5, function()
				ShowReadyCheck(playerName.."(Consumable Check)", 38); --fool the game its not the player
				SetPortraitTexture(ReadyCheckPortrait, playerName);
				--updateConsumables();
				checkForFlask();
				checkForBuffs();
				checkForOil();
				checkForFood();
				checkForRune();
				updateConsumableText();
				if (IRT_ConsumableAutoButtonsEnabled) then
					autoOil:Show();
				end
				f2:Show();
			end);
		elseif (ReadyCheckFrame.initiator and not UnitIsUnit(ReadyCheckFrame.initiator, playerName)) then
			f2:Show();
			if (IRT_ConsumableAutoButtonsEnabled) then
				autoOil:Show();
			end
		elseif (not IRT_SenderReadyCheck) then
			--updateConsumables();
			if (IRT_ConsumableAutoButtonsEnabled) then
				autoOil:Show();
			end
		end
		--ReadyCheckFrame:Show();
		--ReadyCheckListenerFrame:Show();
	end
end);

f:SetScript("OnEvent", function(self, event, ...)
	if (event == "PLAYER_LOGIN") then
		if (IRT_ConsumableCheckEnabled == nil) then IRT_ConsumableCheckEnabled = true; end
		if (IRT_SenderReadyCheck == nil) then IRT_SenderReadyCheck = true; end
		if (IRT_ConsumableAutoButtonsEnabled == nil) then IRT_ConsumableAutoButtonsEnabled = true; end
	elseif (event == "ENCOUNTER_START" and autoOil:IsShown()) then
		autoOil:Hide();
		f:UnregisterEvent("UNIT_INVENTORY_CHANGED");
	elseif (event == "READY_CHECK" and IRT_ConsumableCheckEnabled) then
		f:RegisterEvent("UNIT_AURA");
		local sender = ...;
		rcSender = sender;
		if (not UnitIsUnit(sender, playerName)) then
			checkForFlask();
			checkForBuffs();
			checkForOil();
			checkForFood();
			checkForRune();
			updateConsumableText();
			--updateConsumables();
		end
	elseif (event == "UNIT_AURA" and IRT_ConsumableCheckEnabled and ReadyCheckFrame:IsShown()) then
		--local unit = ...;
		--if ((UnitInRaid(unit) or UnitInParty(unit)) and not UnitIsUnit(rcSender, UnitName("player"))) then
			--updateConsumables();
			if (playerBuffs["food"] == CROSS) then
				checkForFood();
				updateConsumableText();
			end
			if (canBuff and not everyoneHasBuff) then
				checkForBuffs();
				updateConsumableText();
			end
			if (playerBuffs["flask"] == CROSS) then
				checkForFlask();
				updateConsumableText();
			end
			if (playerBuffs["oil"] == CROSS) then
				checkForOil();
				updateConsumableText();
			end
			if (playerBuffs["rune"] == CROSS) then
				checkForRune();
				updateConsumableText();
			end
			--end
	elseif (event == "UNIT_INVENTORY_CHANGED" and IRT_ConsumableCheckEnabled and (ReadyCheckFrame:IsShown() or ((autoOil:IsMouseOver() and autoOil:IsShown())))) then
		--local unit = ...;
		--if ((UnitInRaid(unit) or UnitInParty(unit)) and not UnitIsUnit(rcSender, UnitName("player"))) then
		C_Timer.After(0.1, function()
			if (playerBuffs["oil"] == CROSS) then
				checkForOil();
				updateConsumableText();
			end
			--updateConsumables();
		end);
			--updateConsumables();
		--end
	end
end);

function IRT_AutoOilSetPosition(point, relativeTo, relativePoint, xOffset, yOffset)
	autoOil:ClearAllPoints();
	autoOil:SetPoint(point, ReadyCheckFrame, relativePoint, xOffset, yOffset);
end