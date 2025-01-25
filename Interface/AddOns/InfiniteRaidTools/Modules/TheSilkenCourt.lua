local L = IRTLocals;
local f = CreateFrame("Frame");
local webPartners = {};
local playerName = Ambiguate(GetUnitName("player", true), "none");
local inEncounter = false;
local isPhase3 = false;
local debugLevel = nil;
local difficulty;
local raid = {};
local timer = nil;
local customPrio = nil;
local RPAFTimer = nil;
local spellIds = {
	["BINDING"] = 440001,
	["SPIKE"] = 451277,
	["STINGING"] = 438708,
	["VORTEX"] = 441626,
};

local meleeSpecIDs = {
	[103] = true,
	[255] = true,
	[263] = true,
};
local groupIcons = {
	[1] = "STAR",
	[2] = "CIRCLE",
	[3] = "DIAMOND",
	[4] = "TRIANGLE",
	[5] = "MOON",
	[6] = "SQUARE",
	[7] = "CROSS",
	[8] = "SKULL",
};
local specPrio = {};
local specNameMap = {
	["Blood"] = 250,
	["Frost (DK)"] = 251,
	["Unholy"] = 252,
	["Havoc"] = 577,
	["Vengeance"] = 581,
	["Balance"] = 102,
	["Feral"] = 103,
	["Guardian"] = 104,
	["Restoration (Druid)"] = 105,
	["Beast Mastery"] = 253,
	["Marksmanship"] = 254,
	["Survival"] = 255,
	["Arcane"] = 62,
	["Fire"] = 63,
	["Frost (Mage)"] = 64,
	["Brewmaster"] = 268,
	["Windwalker"] = 269,
	["Mistweaver"] = 270,
	["Holy (Paladin)"] = 65,
	["Protection (Paladin)"] = 66,
	["Retribution"] = 70,
	["Discipline"] = 256,
	["Holy (Priest)"] = 257,
	["Shadow"] = 258,
	["Assassination"] = 259,
	["Outlaw"] = 260,
	["Subtlety"] = 261,
	["Elemental"] = 262,
	["Enhancement"] = 263,
	["Restoration (Shaman)"] = 264,
	["Affliction"] = 265,
	["Demonology"] = 266,
	["Destruction"] = 267,
	["Arms"] = 71,
	["Fury"] = 72,
	["Protection (Warrior)"] = 73,
	["Devastation"] = 1467,
	["Augmentation"] = 1473,
	["Preservation"] = 1468,
};

f:RegisterEvent("PLAYER_LOGIN");
f:RegisterEvent("ENCOUNTER_START");
f:RegisterEvent("ENCOUNTER_END");

C_ChatInfo.RegisterAddonMessagePrefix("IRT_SILKENC");

local function updateSpecPrio(prio)
	specPrio = {};
	specPrio[0] = 100;
	for i = 1, #prio do
		specPrio[specNameMap[prio[i]]] = i;
	end
end

local function compareSpec(a, b)
	if (a[2] == b[2]) then
		return a[1] < b[1]; -- name check
	end
	return specPrio[a[2]] < specPrio[b[2]]; -- role check
end

local function sortPAM()
	local result = {};
	if (debugLevel) then
		print("sorting soak players based on group");
	end
	for name, data in pairs(raid) do
		table.insert(result, {name, data["SPEC"]});
	end
	table.sort(result, compareSpec);
	if (debugLevel) then
		local text = "Sorted soakers in order: ";
		for name, data in ipairs(result) do
			text = text .. name .. " ";
		end
		print(text);
	end
	return result;
end

local function setupPrio()
	local prio;
	if (IRT_RPAFPriority[2921] == nil) then
		prio = IRT_SavePriorityList(2921);
	else
		prio = IRT_RPAFPriority[2921];
	end
	updateSpecPrio(prio);
	local sortedRaid = sortPAM();
	local raidPrioritized = {};
	for index, data in ipairs(sortedRaid) do
		raidPrioritized[index] = data[1];
	end
	return raidPrioritized;
end

local function initRaid()
	if (debugLevel) then
		IRT_DebugMessage("raid initiated", debugLevel, L.OPTIONS_SILKENCOURT_TITLE);
	end
	local loopCount = GetNumGroupMembers();
	if (difficulty == 16) then
		loopCount = 20;
	end
	for i = 1, loopCount do
		local name, rank, group, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i);
		if (name and UnitIsConnected(name) and UnitIsVisible(name)) then
			if (debugLevel) then
				IRT_DebugMessage(" is added to raid with data: role: " .. "melee and group: " .. group, debugLevel, L.OPTIONS_SILKENCOURT_TITLE);
			end
			raid[name] = {["ROLE"] = "melee", ["GROUP"] = group, ["SPEC"] = 0};
		end
	end
	local role = UnitGroupRolesAssigned("player");
	local class = select(2, UnitClass("player"));
	local specID = select(1, GetSpecializationInfo(GetSpecialization()));
	if (role == "TANK") then
		local code = C_ChatInfo.SendAddonMessage("IRT_SILKENC", "PLAYER_DATA tank " ..specID, "RAID");
		if (code ~= 0) then
			IRT_DebugMessage(L.ERROR_ADDON_MESSAGE_WHISPER .. IRT_GetAddonResultMessage(code), "debug", L.OPTIONS_SILKENCOURT_TITLE);
		end
		if (debugLevel) then
			IRT_DebugMessage("sending msg: tank to raid " .. IRT_GetAddonResultMessage(code), debugLevel, L.OPTIONS_SILKENCOURT_TITLE);
		end
	elseif (role == "HEALER") then
		local code = C_ChatInfo.SendAddonMessage("IRT_SILKENC", "PLAYER_DATA healer " ..specID, "RAID");
		if (code ~= 0) then
			IRT_DebugMessage(L.ERROR_ADDON_MESSAGE_WHISPER .. IRT_GetAddonResultMessage(code), "debug", L.OPTIONS_SILKENCOURT_TITLE);
		end
		if (debugLevel) then
			IRT_DebugMessage("sending msg: healer to raid " .. IRT_GetAddonResultMessage(code), debugLevel, L.OPTIONS_SILKENCOURT_TITLE);
		end
	else
		if (class == "MAGE" or class == "WARLOCK" or class == "PRIEST" or class == "EVOKER") then
			local code = C_ChatInfo.SendAddonMessage("IRT_SILKENC", "PLAYER_DATA ranged " ..specID, "RAID"); --covers pure ranged classes
			if (code ~= 0) then
				IRT_DebugMessage(L.ERROR_ADDON_MESSAGE_WHISPER .. IRT_GetAddonResultMessage(code), "debug", L.OPTIONS_SILKENCOURT_TITLE);
			end
			if (debugLevel) then
				IRT_DebugMessage("sending msg: ranged to raid " .. IRT_GetAddonResultMessage(code), debugLevel, L.OPTIONS_SILKENCOURT_TITLE);
			end
		elseif (meleeSpecIDs[specID] or class == "WARRIOR" or class == "ROGUE" or class == "DEMONHUNTER" or class == "DEATHKNIGHT" or class == "MONK" or class == "PALADIN") then
			local code = C_ChatInfo.SendAddonMessage("IRT_SILKENC", "PLAYER_DATA melee " ..specID, "RAID"); --covers hybrid dps classes
			if (code ~= 0) then
				IRT_DebugMessage(L.ERROR_ADDON_MESSAGE_WHISPER .. IRT_GetAddonResultMessage(code), "debug", L.OPTIONS_SILKENCOURT_TITLE);
			end
			if (debugLevel) then
				IRT_DebugMessage("sending msg: melee to raid " .. IRT_GetAddonResultMessage(code), debugLevel, L.OPTIONS_SILKENCOURT_TITLE);
			end
		else
			local code = C_ChatInfo.SendAddonMessage("IRT_SILKENC", "PLAYER_DATA ranged " ..specID, "RAID"); --covers melee classes
			if (code ~= 0) then
				IRT_DebugMessage(L.ERROR_ADDON_MESSAGE_WHISPER .. IRT_GetAddonResultMessage(code), "debug", L.OPTIONS_SILKENCOURT_TITLE);
			end
			if (debugLevel) then
				IRT_DebugMessage("sending msg: ranged to raid " .. IRT_GetAddonResultMessage(code), debugLevel, L.OPTIONS_SILKENCOURT_TITLE);
			end
		end
	end
end

local function isPlayerTracked(player)
	for i = 1, #IRT_SilkenTracker do
		if (IRT_SilkenTracker[i] and IRT_SilkenTracker ~= "") then
			if (UnitIsUnit(player, IRT_SilkenTracker[i])) then
				return true;
			end
		end
	end
	return false;
end

local function updateWebPartners()
	local text = IRT_GetIRTColor();
	for player1, player2 in pairs(webPartners) do
		if (UnitIsUnit(player1, playerName) or UnitIsUnit(player2, playerName)) then
			text = text .. "\n|cFFFFFFFFYOU|r: " .. IRT_ClassColorName(player1) .. " - " .. IRT_ClassColorName(player2) .. "\n";
			break;
		end
	end
	for player1, player2 in pairs(webPartners) do
		if (not UnitIsUnit(player1, playerName) and not UnitIsUnit(player2, playerName)) then
			text = text .. "\n" .. IRT_ClassColorName(player1) .. " - " .. IRT_ClassColorName(player2);
		end
	end
	IRT_InfoBoxShow(text, 50);
end

f:SetScript("OnEvent", function(self, event, ...)
	if (event == "PLAYER_LOGIN") then
		if (IRT_SilkenTracker == nil) then IRT_SilkenTracker = {}; end
		if (IRT_SilkenCourtEnabled == nil) then IRT_SilkenCourtEnabled = true; end
	elseif (event == "CHAT_MSG_ADDON" and inEncounter and IRT_SilkenCourtEnabled) then
		local prefix, msg, channel, sender = ...;
		if (prefix == "IRT_SILKENC") then
			sender = Ambiguate(sender, "none");
			msg = IRT_DecodeAddonMesageWhisper(channel, msg);
			if (msg == nil) then
				return;
			end
			if (msg:match("PLAYER_DATA")) then
				local _, role, specID = strsplit(" ", msg, 3);
				raid[sender]["ROLE"] = role;
				if (tonumber(specID)) then
					specID = tonumber(specID);
					raid[sender]["SPEC"] = specID;
				end
				if (debugLevel) then
					IRT_DebugMessage("got a message in raid addon channel from " .. sender .. " that their role is " .. role .. " and specID " .. specID .. " updating the raid variable", debugLevel, L.OPTIONS_SIKRAN_TITLE);
				end
			elseif (msg:match("RPAF")) then
				local _, assignment = strsplit(" ", msg, 2);
				if (tonumber(assignment)) then
					assignment = tonumber(assignment);
					IRT_PopupShow("\124TInterface\\TargetingFrame\\UI-RaidTargetingIcon_" .. assignment .. ":30\124t".." GO TO " .. groupIcons[assignment] .. "\124TInterface\\TargetingFrame\\UI-RaidTargetingIcon_" .. assignment .. ":30\124t", 10, L.BOSS_FILE);
					timer = IRT_NotifyPlayer(timer, "{rt" .. assignment .. "} ", "SAY", 6);
				elseif (assignment == "ABORT") then
					IRT_PopupHide(L.BOSS_FILE);
					if (timer) then
						timer:Cancel();
						timer = nil;
					end
				end
			end
		end
	elseif (event == "UNIT_AURA" and inEncounter and IRT_SilkenCourtEnabled and isPhase3) then --and not isphase1
		local unit = ...;
		local name = Ambiguate(GetUnitName(unit, true), "none");
		if (IRT_UnitDebuff(unit, C_Spell.GetSpellInfo(spellIds["BINDING"]).name) and not webPartners[name] and not IRT_Contains(webPartners, name)) then
			local caster = select(7, IRT_UnitDebuff(unit, C_Spell.GetSpellInfo(spellIds["BINDING"]).name));
			local casterName = Ambiguate(GetUnitName(caster, true), "none");
			if (not UnitIsUnit(casterName, name) and (isPlayerTracked(casterName) or isPlayerTracked(name) or UnitIsUnit(casterName, playerName) or UnitIsUnit(name, playerName))) then
				webPartners[name] = casterName;
				updateWebPartners();
			end
		elseif (not IRT_UnitDebuff(unit, C_Spell.GetSpellInfo(spellIds["BINDING"]).name) and (webPartners[name] or IRT_Contains(webPartners, name))) then
			webPartners[name] = nil;
			webPartners[IRT_Contains(webPartners, name)] = nil;
			if (next(webPartners)) then
				updateWebPartners();
			else
				IRT_InfoBoxHide();
			end
		end
	elseif (event == "COMBAT_LOG_EVENT_UNFILTERED" and inEncounter and IRT_SilkenCourtEnabled) then
		local _, logEvent, _, _, _, _, _, _, target, _, _, spellID, _, _, _, _ = CombatLogGetCurrentEventInfo();
		if (logEvent == "SPELL_CAST_SUCCESS") then
			if (spellID == spellIds["SPIKE"] and not isPhase3) then
				isPhase3 = true;
			elseif (spellID == spellIds["VORTEX"] and not isPhase3) then
				if (customPrio == nil) then
					customPrio = setupPrio();
				end
				if (IRT_RPAFEnabled[2921]) then
					RPAFTimer = C_Timer.After(2, function()
						IRT_RPAFReset();
						IRT_RPAFShow(difficulty, "IRT_SIKRAN", 18, customPrio);
					end);
				end
			end
		end
	elseif (event == "ENCOUNTER_START" and IRT_SilkenCourtEnabled) then
		local eID = ...;
		if (eID == 2921) then
			difficulty = select(3, GetInstanceInfo());
			f:RegisterEvent("UNIT_AURA");
			f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
			f:RegisterEvent("CHAT_MSG_ADDON");
			inEncounter = true;
			webPartners = {};
			isPhase3 = false;
			raid = {};
			customPrio = nil;
			if (RPAFTimer) then
				RPAFTimer:Cancel();
				RPAFTimer = nil;
			end
			if (timer) then
				timer:Cancel();
				timer = nil;
			end
			IRT_PopupHide(L.BOSS_FILE);
			IRT_RPAFHide();
			IRT_InfoBoxHide();
			initRaid();
		end
	elseif (event == "ENCOUNTER_END" and inEncounter and IRT_SilkenCourtEnabled) then
		if (inEncounter) then
			f:UnregisterEvent("UNIT_AURA");
			f:UnregisterEvent("CHAT_MSG_ADDON");
			f:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
			inEncounter = false;
			webPartners = {};
			customPrio = nil;
			raid = {};
			if (RPAFTimer) then
				RPAFTimer:Cancel();
				RPAFTimer = nil;
			end
			if (timer) then
				timer:Cancel();
				timer = nil;
			end
			isPhase3 = false;
			IRT_RPAFHide();
			IRT_PopupHide(L.BOSS_FILE);
			IRT_InfoBoxHide();
		end
	end
end);