local L = IRTLocals;
local f = CreateFrame("Frame");
local addon = ...; -- The name of the addon folder
local version = C_AddOns.GetAddOnMetadata(addon, "Version");
local IRTColor = "\124cFF00FFFFIRT:\124r";
SLASH_INFINITERAIDTOOLS1 = "/endlessraidtools";
SLASH_INFINITERAIDTOOLS2 = "/enrt";
SLASH_INFINITERAIDTOOLS3 = "/irt";
SLASH_INFINITERAIDTOOLS4 = "/infiniteraidtools";
local playersChecked = {};
local initCheck = false;
local recievedOutOfDateMessage = false;
local rangeIdList = {
	[4] = 90175,
	[6] = 37727,
	[8] = 8149,
	[10] = 3,
	[11] = 2,
	[13] = 32321,
	[18] = 6450,
	[23] = 21519,
	[30] = 1,
	[33] = 1180,
	[43] = 34471,
	[48] = 32698,
	[53] = 116139,
	[60] = 32825,
	[80] = 35278,
	[100] = 41058
};

local AuraUtil = AuraUtil;
local addonMessageResults = {};
for resultMessage, resultCode in pairs(Enum.SendAddonMessageResult) do
	addonMessageResults[resultCode] = resultMessage;
end

function IRT_GetAddonResultMessage(code)
	if (addonMessageResults[code]) then
		return addonMessageResults[code];
	else
		return "result code not found by irt";
	end
end

function IRT_OnAddonCompartmentClick(addonName, buttonName)
	Settings.OpenToCategory(IRT_GetSubcategory("Parent"):GetID());
end

function IRT_GetRangeMeasurement(yards)
	-- Check if the exact index exists
	if (rangeIdList[yards]) then
		return rangeIdList[yards];
	else
		local closestHigherIndex = nil
		-- Find the closest higher existing index
		for index, _ in pairs(rangeIdList) do
			if (index > yards and (not closestHigherIndex or index < closestHigherIndex)) then
				closestHigherIndex = index;
			end
		end
		if (closestHigherIndex) then
			return rangeIdList[closestHigherIndex];
		else
			return rangeIdList[100]; -- No values found
		end
	end
end

local function handler(msg, editbox)
	local arg = string.lower(msg);
	if (arg ~= nil and arg == "vc") then
		local code = C_ChatInfo.SendAddonMessage("IRT_VC", "vc", "RAID");
		if (code ~= 0 and code ~= 5) then
			IRT_DebugMessage(L.ERROR_ADDON_MESSAGE_WHISPER .. IRT_GetAddonResultMessage(code), "debug", "CORE");
		end
		if (not initCheck) then
			initCheck = true;
			C_Timer.After(2, function()
				IRT_FindMissingPlayers();
				playersChecked = {};
				initCheck = false;
			end);
		end
	elseif (arg ~= nil and arg == "bossaction") then
		local code = C_ChatInfo.SendAddonMessage("IRT_ULGRAX", "SAFE", "RAID");
		if (code ~= 0 and code ~= 5) then
			IRT_DebugMessage(L.ERROR_ADDON_MESSAGE_WHISPER .. IRT_GetAddonResultMessage(code), "debug", "CORE"..L.OPTIONS_ULGRAX_TITLE);
		end
		code = C_ChatInfo.SendAddonMessage("IRT_BROOD", "SAFE", "RAID");
		if (code ~= 0 and code ~= 5) then
			IRT_DebugMessage(L.ERROR_ADDON_MESSAGE_WHISPER .. IRT_GetAddonResultMessage(code), "debug", "CORE"..L.OPTIONS_BROODTWISTER_TITLE);
		end
	elseif (arg ~= nil and arg == "inv") then
		IRT_RaidInvite();
	else
		Settings.OpenToCategory(IRT_GetSubcategory("Parent"):GetID());
	end
end
SlashCmdList["INFINITERAIDTOOLS"] = handler;
f:RegisterEvent("CHAT_MSG_ADDON");
f:RegisterEvent("ADDON_LOADED");
f:RegisterEvent("PLAYER_LOGIN");
f:RegisterEvent("GROUP_ROSTER_UPDATE");
C_ChatInfo.RegisterAddonMessagePrefix("IRT_VC");
C_ChatInfo.RegisterAddonMessagePrefix("IRT_CRVC");
C_ChatInfo.RegisterAddonMessagePrefix("IRT_UPDATE");

local function renameWarning()
	local warningFrame = CreateFrame("Frame", nil, nil, BackdropTemplateMixin and "BackdropTemplate");
	warningFrame:SetSize(1000, 170);
	warningFrame:SetPoint("CENTER");
	warningFrame:SetMovable(false);
	warningFrame:EnableMouse(false);
	warningFrame:SetFrameLevel(3);
	warningFrame:SetFrameStrata("TOOLTIP");
	warningFrame:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", --Set the background and border textures
		edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
		tile = true, tileSize = 16, edgeSize = 16,
		insets = { left = 4, right = 4, top = 4, bottom = 4 }
	});
	warningFrame:SetBackdropColor(0.27,0.5,1,1);
	--warningFrame:SetBackdropColor(0.2,0.4,0.92,1);
	--warningFrame:SetBackdropColor(0.27,0.56,0.92,1);
	--warningFrame:SetBackdropColor(0.13,0.29,0.60,1);

	local warningText = warningFrame:CreateFontString(nil, "ARTWORK", "GameFontNormal");
	warningText:SetPoint("TOP", 0, -10);
	warningText:SetJustifyV("TOP");
	warningText:SetJustifyH("CENTER");
	warningText:SetSpacing(8);
	warningText:SetText(L.WARNING_DELETE_OLD_FOLDER);
	C_AddOns.DisableAddOn("EndlessRaidTools");

	local closeButton = CreateFrame("Button", nil, warningFrame, "UIPanelButtonTemplate");
	closeButton:SetPoint("BOTTOM", 0, 10);
	closeButton:SetSize(80,25);
	closeButton:SetText("Reload UI");
	closeButton:SetScript("OnClick", function(self)
		ReloadUI();
	end);
	warningFrame:Show();
end

f:SetScript("OnEvent", function(self, event, ...)
	if (event == "CHAT_MSG_ADDON") then
		local prefix, msg, channel, sender = ...;
		if (prefix == "IRT_VC" and UnitName("player") ~= Ambiguate(sender, "short")) then
			if (msg == "vc") then
				sender = Ambiguate(sender, "none");
				if (sender:match("%-")) then
					local code = C_ChatInfo.SendAddonMessage("IRT_CRVC", sender .. " " .. version, "RAID");
					if (code ~= 0) then
						IRT_DebugMessage(L.ERROR_ADDON_MESSAGE_WHISPER .. IRT_GetAddonResultMessage(code), "debug", "CORE");
					end
				else
					local code = C_ChatInfo.SendAddonMessage("IRT_VC", version, "WHISPER", sender);
					if (code ~= 0) then
						IRT_DebugMessage(L.ERROR_ADDON_MESSAGE_WHISPER .. IRT_GetAddonResultMessage(code), "debug", "CORE");
					end
				end
			--[[
			elseif (msg:find("vco") and not recievedOutOfDateMessage) then
			local head, tail, ver = msg:find("([^vco-].*)");
			if (tonumber(ver) ~= nil) then
				if (tonumber(ver) > tonumber(version)) then
					DEFAULT_CHAT_FRAME:AddMessage("|cFFFFFF00" .. L.WARNING_OUTOFDATEMESSAGE);
					recievedOutOfDateMessage = true;
				end
			end]]
			else
				sender = Ambiguate(sender, "short");
				playersChecked[#playersChecked+1] = sender;
				print(sender .. "-" .. msg);
			end
		elseif (prefix == "IRT_CRVC" and UnitName("player") ~= Ambiguate(sender, "short")) then
			local target, vers = strsplit(" ", msg);
			local shortName, serverName = UnitFullName("player");
			local fullName = shortName .. "-" .. serverName;
			if (UnitIsUnit(target, fullName)) then
				sender = Ambiguate(sender, "short");
				playersChecked[#playersChecked+1] = sender;
				print(sender .. "-" .. vers);
			end
		elseif (prefix == "IRT_UPDATE" and UnitName("player") ~= Ambiguate(sender, "short") and not recievedOutOfDateMessage) then
			if (tonumber(msg) ~= nil) then
				if (tonumber(msg) > tonumber(version)) then
					DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000" .. L.WARNING_OUTOFDATEMESSAGE .. "|r");
					recievedOutOfDateMessage = true;
				end
			end
		end
	elseif (event == "GROUP_ROSTER_UPDATE") then
		if (IsInRaid(LE_PARTY_CATEGORY_INSTANCE) or IsInGroup(LE_PARTY_CATEGORY_INSTANCE)) then
			local code = C_ChatInfo.SendAddonMessage("IRT_UPDATE", version, "INSTANCE_CHAT");
			if (code ~= 0 and code ~= 3) then
				IRT_DebugMessage(L.ERROR_ADDON_MESSAGE_WHISPER .. IRT_GetAddonResultMessage(code), "debug", "CORE");
			end
		elseif (IsInRaid(LE_PARTY_CATEGORY_HOME)) then
			local code = C_ChatInfo.SendAddonMessage("IRT_UPDATE", version, "RAID");
			if (code ~= 0 and code ~= 3) then
				IRT_DebugMessage(L.ERROR_ADDON_MESSAGE_WHISPER .. IRT_GetAddonResultMessage(code), "debug", "CORE");
			end
		elseif (IsInGroup(LE_PARTY_CATEGORY_HOME)) then
			local code = C_ChatInfo.SendAddonMessage("IRT_UPDATE", version, "PARTY");
			if (code ~= 0 and code ~= 3) then
				IRT_DebugMessage(L.ERROR_ADDON_MESSAGE_WHISPER .. IRT_GetAddonResultMessage(code), "debug", "CORE");
			end
		end
	elseif (event == "ADDON_LOADED") then
		local loadedAddon = ...;
		if (loadedAddon == "EndlessRaidTools") then
			renameWarning();
		elseif (loadedAddon == addon) then
			if (C_AddOns.IsAddOnLoaded("EndlessRaidTools")) then
				renameWarning();
			end
			if (IRT_PopupTextPosition ~= nil) then
				IRT_PopupSetPosition(IRT_PopupTextPosition.point, IRT_PopupTextPosition.relativeTo, IRT_PopupTextPosition.relativePoint, IRT_PopupTextPosition.xOffset, IRT_PopupTextPosition.yOffset);
			end
			if (IRT_PopupTextFontSize == nil) then
				IRT_PopupTextFontSize = 28;
			end
			if (IRT_InfoBoxPosition ~= nil) then
				IRT_InfoBoxSetPosition(IRT_InfoBoxPosition.point, IRT_InfoBoxPosition.relativeTo, IRT_InfoBoxPosition.relativePoint, IRT_InfoBoxPosition.xOffset, IRT_InfoBoxPosition.yOffset);
			end
			if (IRT_InfoBoxTextFontSize == nil) then
				IRT_InfoBoxTextFontSize = 14;
			end
			if (IRT_RPAFPosition ~= nil) then
				IRT_RPAFSetPosition(IRT_RPAFPosition.point, IRT_RPAFPosition.relativeTo, IRT_RPAFPosition.relativePoint, IRT_RPAFPosition.xOffset, IRT_RPAFPosition.yOffset);
			end
			if (IRT_RPAFLayout == nil) then
				IRT_RPAFLayout = "VERTICAL";
			end
			if (IRT_RPAFEnabled == nil) then
				IRT_RPAFEnabled = {};
			end
			if (IRT_RPAFPriority == nil) then
				IRT_RPAFPriority = {};
			end
			if (IRT_AutoOilPosition ~= nil) then
				IRT_AutoOilSetPosition(IRT_AutoOilPosition.point, IRT_AutoOilPosition.relativeTo, IRT_AutoOilPosition.relativePoint, IRT_AutoOilPosition.xOffset, IRT_AutoOilPosition.yOffset);
			end
			IRT_PopupUpdateFontSize();
			IRT_InfoBoxUpdateFontSize();
		end
	elseif (event == "PLAYER_LOGIN") then
		if (IsInGuild()) then
			local code = C_ChatInfo.SendAddonMessage("IRT_UPDATE", version, "GUILD");
			if (code ~= 0) then
				IRT_DebugMessage(L.ERROR_ADDON_MESSAGE_WHISPER .. IRT_GetAddonResultMessage(code), "debug", "CORE");
			end
		end
	end
end);
function IRT_FindMissingPlayers()
	for i = 1, GetNumGroupMembers() do
		local raider = Ambiguate(GetUnitName("raid"..i, true), "short");
		if (not IRT_Contains(playersChecked, raider) and UnitName("raid"..i) ~= UnitName("player")) then
			print(GetUnitName("raid"..i, true) .. " - not installed");
		end
	end
end
--[[
	Checking if a table contains a given value and if it does, what index is the value located at
	param(arr) table
	param(value) T - value to check exists
	return boolean or integer / returns false if the table does not contain the value otherwise it returns the index of where the value is locatedd
]]
function IRT_Contains(arr, value)
	if (value == nil) then
		return false;
	end
	if (arr == nil) then
		return false;
	end
	for k, v in pairs(arr) do
		if (v == value) then
			return k;
		end
	end
	return false;
end

--[[
	Checking if a table contains a given value and if it does, what index is the value located at
	param(arr) table
	param(value) T - value to check exists
	return boolean or integer / returns false if the table does not contain the value otherwise it returns the index of where the value is locatedd
]]
function IRT_ContainsKey(arr, value)
	if (value == nil or arr == nil) then
		return false;
	end
	if (arr[value]) then
		return true;
	else
		return false;
	end
end

function IRT_UnitBuff(unit, spellName)
	if (unit and spellName) then
		for i = 1, 100 do
			local auraData = C_UnitAuras.GetBuffDataByIndex(unit, i);
			local name, icon, count, dispelType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod = AuraUtil.UnpackAuraData(auraData);
			if (not name) then
				return;
			end
			if (name == spellName) then
				return name, icon, count, dispelType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod;
			end
		end
	end
	return
end

function IRT_UnitDebuff(unit, spellName, trackedSpellId)
	if (unit and spellName) then
		for i = 1, 100 do
			local auraData = C_UnitAuras.GetDebuffDataByIndex(unit, i);
			if (auraData) then
				local name, icon, count, dispelType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod = AuraUtil.UnpackAuraData(auraData);
				if (not name) then
					return;
				end
				if (name == spellName and trackedSpellId and spellId == trackedSpellId) then
					return name, icon, count, dispelType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod;
				elseif (name == spellName and trackedSpellId == nil) then
					return name, icon, count, dispelType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellId, canApplyAura, isBossDebuff, castByPlayer, nameplateShowAll, timeMod;
				end
			end
		end
	end
	return;
end

function IRT_GetRaidLeader()
	for i = 1, GetNumGroupMembers() do
		local raider = "raid"..i;
		if select(2, GetRaidRosterInfo(i)) == 2 then
			return GetUnitName(raider, true);
		end
	end
	return "";
end

function IRT_GetIRTColor()
	return IRTColor;
end

function IRT_SendAddonCrossRealmMessage(prefix, target, msg)
	if (target:match("%-")) then
		return C_ChatInfo.SendAddonMessage(prefix, target .. " " .. msg, "RAID");
	else
		return C_ChatInfo.SendAddonMessage(prefix, msg, "WHISPER", target);
	end
end

function IRT_SendAddonMessageWhisper(prefix, msg, target, onlyCrossRealm, alwaysSendRaidChannel)
	onlyCrossRealm = onlyCrossRealm or false;
	if (target and msg and prefix and (target:match("%-") or alwaysSendRaidChannel)) then
		return C_ChatInfo.SendAddonMessage(prefix, "X*-" .. target .. " " .. msg, "RAID");
	elseif (target and msg and prefix) then
		if (onlyCrossRealm == false) then
			return C_ChatInfo.SendAddonMessage(prefix, msg, "WHISPER", target);
		end
	else
		return "error missing prefix, target or msg";
	end
end

function IRT_DecodeAddonMesageWhisper(channel, msg)
	if (channel == "RAID") then
		if (msg:match("^X%*%-")) then
			msg = string.sub(msg, 4);
			local target;
			target, msg = msg:match("^(%S*)%s*(.-)$");
			target = Ambiguate(target, "none");
			if (UnitIsUnit(target, Ambiguate("player", "none"))) then
				return msg, target;
			else
				return nil;
			end
		else
			return msg;
		end
	else
		return msg;
	end
end

--[[
	To check if message is to me: (UnitIsUnit(target, playerName) or target == nil)
	To check if message is to raid: (channel == "RAID" and target == nil)
]]--
function IRT_DecodeCrossRealmAddonMessage(sender, channel, msg)
	if (channel == "RAID") then
		local target, text = strsplit(" ", msg, 2); --look at this
		local shortName = Ambiguate(target, "short");
		if (UnitInRaid(shortName)) then
			return text, shortName;
		else
			return msg;
		end
	else
		return msg;
	end
end

function IRT_ClassColorName(name)
	if (UnitIsConnected(name)) then
		return string.format("\124c%s%s\124r", RAID_CLASS_COLORS[select(2, UnitClass(name))].colorStr, Ambiguate(name, "short"));
	else
		return name;
	end
end

function IRT_SetFlagIcon(texture, index)
	local iconSize = 32;
	local columns = 256/iconSize;
	local rows = 64/iconSize;
	local l = mod(index, columns) / columns;
	local r = l + (1/columns);
	local t = floor(index/columns) / rows;
	local b = t + (1/rows);
	texture:SetTexCoord(l,r,t,b);
end

function IRT_NotifyPlayer(ticker, text, channel, seconds, fq)
	if (fq == nil) then
		fq = 1.75;
	end
	if (ticker) then
		ticker:Cancel();
		ticker = nil;
	end
	if (ticker == nil and text and fq and seconds) then
		SendChatMessage(text, channel);
		ticker = C_Timer.NewTicker(fq, function()
			SendChatMessage(text, channel);
		end, math.floor(seconds/fq));
		return ticker;
	end
end

function IRT_GetName(player, server)
	if (server == nil or server) then
		return Ambiguate(GetUnitName(player), "none");
	else
		return Ambiguate(GetUnitName(player), "short");
	end
end

--[[
function IRT_GetSubcategory(name)
	local category = Settings.GetCategory("Infinite Raid Tools");
	if (category:HasSubcategories()) then
		for index, subcategory in pairs(category.subcategories) do
			if (subcategory.name == name) then
				return subcategory;
			end
		end
	end
	return nil;
end
]]
function IRT_Log(boss, msg)
	if (IRT_DebugLog == nil) then
		IRT_DebugLog = {};
	end
	IRT_DebugLog[#IRT_DebugLog+1] = tostring(date("%y/%m/%d %H:%M:%S")) .. " " .. boss .." | " .. msg;
	print(msg);
end
function IRT_DebugMessage(msg, level, boss)
	boss = boss or "unknown boss";
	if (level == "info") then
		print(msg);
	elseif (level == "debug") then
		IRT_Log(boss, msg);
		print(msg);
	end
end