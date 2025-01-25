local L = IRTLocals;
local f = CreateFrame("Frame");

local difficulty;
local count = 0;
local timer = nil;
local twilightPlayers = {};
local inEncounter = false;
local raid = {};
local notAssigned = true;
local debugLevel = false;
local twilightTracker = 0;
local RPAFTimer = nil;
local customPrio = nil;
local debuffIds = {
	["ASSASINATION"] = 436971,
	["TWILIGHT"] = 438139,
	["SHREDDERS"] = 440377,
	["STARLESS"] = 435405,
};
local meleeSpecIDs = {
	[103] = true,
	[255] = true,
	[263] = true,
};
local rolePrio = {
	["ranged"] = 1,
	["healer"] = 2,
	["melee"] = 3,
	["tank"] = 4,
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
local assignmentTimer = nil;
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
local playerName = GetUnitName("player", true);

f:RegisterEvent("PLAYER_LOGIN");
f:RegisterEvent("ENCOUNTER_START");
f:RegisterEvent("ENCOUNTER_END");

C_ChatInfo.RegisterAddonMessagePrefix("IRT_NEXUSP");

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
	if (IRT_RPAFPriority[2920] == nil) then
		prio = IRT_SavePriorityList(2920);
	else
		prio = IRT_RPAFPriority[2920];
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
		IRT_DebugMessage("raid initiated", debugLevel, L.OPTIONS_NEXUSPRINCESS_TITLE);
	end
	local loopCount = GetNumGroupMembers();
	if (difficulty == 16) then
		loopCount = 20;
	end
	for i = 1, loopCount do
		local name, rank, group, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i);
		if (name and UnitIsConnected(name) and UnitIsVisible(name)) then
			if (debugLevel) then
				IRT_DebugMessage(" is added to raid with data: role: " .. "melee and group: " .. group, debugLevel, L.OPTIONS_NEXUSPRINCESS_TITLE);
			end
			raid[name] = {["ROLE"] = "melee", ["GROUP"] = group, ["SPEC"] = 0};
		end
	end
	local role = UnitGroupRolesAssigned("player");
	local class = select(2, UnitClass("player"));
	local specID = select(1, GetSpecializationInfo(GetSpecialization()));
	if (role == "TANK") then
		local code = C_ChatInfo.SendAddonMessage("IRT_NEXUSP", "PLAYER_DATA tank " ..specID, "RAID");
		if (code ~= 0) then
			IRT_DebugMessage(L.ERROR_ADDON_MESSAGE_WHISPER .. IRT_GetAddonResultMessage(code), "debug", L.OPTIONS_NEXUSPRINCESS_TITLE);
		end
		if (debugLevel) then
			IRT_DebugMessage("sending msg: tank to raid " .. IRT_GetAddonResultMessage(code), debugLevel, L.OPTIONS_NEXUSPRINCESS_TITLE);
		end
	elseif (role == "HEALER") then
		local code = C_ChatInfo.SendAddonMessage("IRT_NEXUSP", "PLAYER_DATA healer " ..specID, "RAID");
		if (code ~= 0) then
			IRT_DebugMessage(L.ERROR_ADDON_MESSAGE_WHISPER .. IRT_GetAddonResultMessage(code), "debug", L.OPTIONS_NEXUSPRINCESS_TITLE);
		end
		if (debugLevel) then
			IRT_DebugMessage("sending msg: healer to raid " .. IRT_GetAddonResultMessage(code), debugLevel, L.OPTIONS_NEXUSPRINCESS_TITLE);
		end
	else
		if (class == "MAGE" or class == "WARLOCK" or class == "PRIEST" or class == "EVOKER") then
			local code = C_ChatInfo.SendAddonMessage("IRT_NEXUSP", "PLAYER_DATA ranged " ..specID, "RAID"); --covers pure ranged classes
			if (code ~= 0) then
				IRT_DebugMessage(L.ERROR_ADDON_MESSAGE_WHISPER .. IRT_GetAddonResultMessage(code), "debug", L.OPTIONS_NEXUSPRINCESS_TITLE);
			end
			if (debugLevel) then
				IRT_DebugMessage("sending msg: ranged to raid " .. IRT_GetAddonResultMessage(code), debugLevel, L.OPTIONS_NEXUSPRINCESS_TITLE);
			end
		elseif (meleeSpecIDs[specID] or class == "WARRIOR" or class == "ROGUE" or class == "DEMONHUNTER" or class == "DEATHKNIGHT" or class == "MONK" or class == "PALADIN") then
			local code = C_ChatInfo.SendAddonMessage("IRT_NEXUSP", "PLAYER_DATA melee " ..specID, "RAID"); --covers hybrid dps classes
			if (code ~= 0) then
				IRT_DebugMessage(L.ERROR_ADDON_MESSAGE_WHISPER .. IRT_GetAddonResultMessage(code), "debug", L.OPTIONS_NEXUSPRINCESS_TITLE);
			end
			if (debugLevel) then
				IRT_DebugMessage("sending msg: melee to raid " .. IRT_GetAddonResultMessage(code), debugLevel, L.OPTIONS_NEXUSPRINCESS_TITLE);
			end
		else
			local code = C_ChatInfo.SendAddonMessage("IRT_NEXUSP", "PLAYER_DATA ranged " ..specID, "RAID"); --covers melee classes
			if (code ~= 0) then
				IRT_DebugMessage(L.ERROR_ADDON_MESSAGE_WHISPER .. IRT_GetAddonResultMessage(code), "debug", L.OPTIONS_NEXUSPRINCESS_TITLE);
			end
			if (debugLevel) then
				IRT_DebugMessage("sending msg: ranged to raid " .. IRT_GetAddonResultMessage(code), debugLevel, L.OPTIONS_NEXUSPRINCESS_TITLE);
			end
		end
	end
end

local function compare(a, b)
	if (a[2] == b[2]) then
		if (a[3] == b[3]) then
			return a[1] < b[1]; -- name check
		else
			return a[3] < b[3]; -- group check
		end
	end
	return rolePrio[a[2]] < rolePrio[b[2]]; -- role check
end

local function sortTwilightList()
	local result = {};
	if (debugLevel) then
		IRT_DebugMessage("sorting debuffed players based on role", debugLevel, L.OPTIONS_NEXUSPRINCESS_TITLE);
	end
	for i = 1, #twilightPlayers do
		if (debugLevel) then
			IRT_DebugMessage("creating temp array with following variables: name: " .. twilightPlayers[i] .. " role " .. raid[twilightPlayers[i]]["ROLE"] .. " group: " .. raid[twilightPlayers[i]]["GROUP"], debugLevel, L.OPTIONS_NEXUSPRINCESS_TITLE);
		end
		table.insert(result, {twilightPlayers[i], raid[twilightPlayers[i]]["ROLE"], raid[twilightPlayers[i]]["GROUP"]});
	end
	table.sort(result, compare);
	if (debugLevel) then
		IRT_DebugMessage("sorted debuffs looks as following: ", debugLevel, L.OPTIONS_NEXUSPRINCESS_TITLE);
		for i = 1, #result do
			IRT_DebugMessage(result[i][1], debugLevel, L.OPTIONS_NEXUSPRINCESS_TITLE);
		end
	end
	return result;
end

local function assignTwilight()
	local sortedTwilightList = sortTwilightList();
	local split = math.floor(#sortedTwilightList)/2;
	for i, data in pairs(sortedTwilightList) do
		local pl = data[1];
		if (UnitIsUnit(playerName, pl) and twilightTracker % 2 == 0) then
			IRT_PopupShow("GO AWAY FROM RAID");
		elseif (UnitIsUnit(playerName, pl) and i <= split) then
			IRT_PopupShow("GO TO CENTER OF ROOM");
		elseif (UnitIsUnit(playerName, pl) and i > split) then
			IRT_PopupShow("GO TO ENTRANCE");
		end
	end
end

function IRT_NexusPricness_Debug(level)
	debugLevel = level;
	print("debug started at level " .. level);
end

f:SetScript("OnEvent", function(self, event, ...)
	if (event == "PLAYER_LOGIN") then
		if (IRT_NexusPrincessEnabled == nil) then IRT_NexusPrincessEnabled = true; end
		if (IRT_RPAFEnabled[2920] == nil) then
			IRT_RPAFEnabled[2920] = false;
		end
	elseif (event == "CHAT_MSG_ADDON" and IRT_NexusPrincessEnabled and inEncounter) then
		local prefix, msg, channel, sender = ...;
		if (prefix == "IRT_NEXUSP") then
			sender = Ambiguate(sender, "none");
			msg = IRT_DecodeAddonMesageWhisper(channel, msg);
			if (msg == nil) then
				return;
			end
			if (debugLevel) then
				IRT_DebugMessage("recieved addon message " .. msg .. " from " .. sender, debugLevel, L.OPTIONS_NEXUSPRINCESS_TITLE);
			end
			if (msg:match("PLAYER_DATA") or msg == "healer" or msg == "ranged" or msg == "tank" or msg == "melee") then
				local _, role, specID = strsplit(" ", msg, 3);
				raid[sender]["ROLE"] = role;
				if (tonumber(specID)) then
					specID = tonumber(specID);
					raid[sender]["SPEC"] = specID;
				end
				if (debugLevel) then
					IRT_DebugMessage("got a message in raid addon channel from " .. sender .. " that their role is " .. role .. " and specID " .. specID .. " updating the raid variable", debugLevel, L.OPTIONS_NEXUSPRINCESS_TITLE);
				end
			elseif (msg:match("RPAF")) then
				local _, assignment = strsplit(" ", msg, 2);
				if (tonumber(assignment)) then
					assignment = tonumber(assignment);
					IRT_PopupShow("\124TInterface\\TargetingFrame\\UI-RaidTargetingIcon_" .. assignment .. ":30\124t".." GO TO " .. groupIcons[assignment] .. "\124TInterface\\TargetingFrame\\UI-RaidTargetingIcon_" .. assignment .. ":30\124t", 5, L.BOSS_FILE);
					timer = IRT_NotifyPlayer(timer, "{rt" .. assignment .. "} ", "SAY", 4);
				elseif (assignment == "ABORT") then
					IRT_PopupHide(L.BOSS_FILE);
					if (timer) then
						timer:Cancel();
						timer = nil;
					end
				end
			end
		end
	elseif (event == "COMBAT_LOG_EVENT_UNFILTERED" and IRT_NexusPrincessEnabled and inEncounter) then
		local _, logEvent, _, _, _, _, _, _, target, _, _, spellID, _, _, _, _ = CombatLogGetCurrentEventInfo();
		if (logEvent == "SPELL_CAST_SUCCESS") then
			if (spellID == debuffIds["STARLESS"]) then
				RPAFTimer = C_Timer.After(24, function()
					if (customPrio == nil) then
						customPrio = setupPrio();
					end
					if (IRT_RPAFEnabled[2920]) then
						IRT_RPAFReset();
						IRT_RPAFShow(difficulty, "IRT_NEXUSP", 20, customPrio);
					end
				end);
			end
		end
	elseif (event == "UNIT_AURA" and IRT_NexusPrincessEnabled and inEncounter) then
		local unit = ...;
		local unitName = GetUnitName(unit, true);
		if (not IRT_Contains(twilightPlayers, unitName) and IRT_UnitDebuff(unit, C_Spell.GetSpellInfo(debuffIds["TWILIGHT"]).name, debuffIds["TWILIGHT"])) then
			table.insert(twilightPlayers, unitName);
			if (notAssigned) then
				notAssigned = false;
				assignmentTimer = C_Timer.After(0.3, function()
					twilightTracker = twilightTracker + 1;
					assignTwilight();
				end);
			end
		elseif (IRT_Contains(twilightPlayers, unitName) and not IRT_UnitDebuff(unit, C_Spell.GetSpellInfo(debuffIds["TWILIGHT"]).name, debuffIds["TWILIGHT"])) then
			IRT_DebugMessage(unitName .. " is no longer debuffed with blades so reseting count and blade list", debugLevel, L.OPTIONS_NEXUSPRINCESS_TITLE);
			count = count - 1;
			table.remove(twilightPlayers, IRT_Contains(twilightPlayers, unitName));
			if (UnitIsUnit(unitName, playerName)) then
				IRT_PopupHide(L.BOSS_FILE);
				if (timer) then
					timer:Cancel();
					timer = nil;
				end
			end
		end
	elseif (event == "ENCOUNTER_START" and IRT_NexusPrincessEnabled) then
		local eID = ...;
		if (eID == 2920) then
			if (debugLevel) then
				IRT_DebugMessage("sikran encounter started", debugLevel, L.OPTIONS_NEXUSPRINCESS_TITLE);
			end
			inEncounter = true;
			difficulty = select(3, GetInstanceInfo());
			f:RegisterEvent("UNIT_AURA");
			f:RegisterEvent("CHAT_MSG_ADDON");
			f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
			count = 0;
			twilightPlayers = {};
			customPrio = nil;
			raid = {};
			IRT_PopupHide(L.BOSS_FILE);
			IRT_RPAFHide();
			initRaid();
			RPAFTimer = nil;
			if (RPAFTimer) then
				RPAFTimer:Cancel();
			end
			if (customPrio == nil) then
				customPrio = setupPrio();
			end
			if (IRT_RPAFEnabled[2920]) then
				IRT_RPAFReset();
				IRT_RPAFShow(difficulty, "IRT_NEXUSP", 20, customPrio);
			end
			notAssigned = true;
			twilightTracker = 0;
			if (timer) then
				timer:Cancel();
				timer = nil;
			end
			if (assignmentTimer) then
				assignmentTimer:Cancel();
				assignmentTimer = nil;
			end
		end
	elseif (event == "ENCOUNTER_END" and inEncounter and IRT_NexusPrincessEnabled) then
		if (debugLevel) then
			IRT_DebugMessage("sikran encounter ended", debugLevel, L.OPTIONS_NEXUSPRINCESS_TITLE);
		end
		IRT_PopupHide(L.BOSS_FILE);
		IRT_RPAFHide();
		if (timer) then
			timer:Cancel();
			timer = nil;
		end
		if (assignmentTimer) then
			assignmentTimer:Cancel();
			assignmentTimer = nil;
		end
		count = 0;
		inEncounter = false;
		twilightPlayers = {};
		if (RPAFTimer) then
			RPAFTimer:Cancel();
		end
		RPAFTimer = nil;
		customPrio = nil;
		notAssigned = true;
		twilightTracker = 0;
		raid = {};
		f:UnregisterEvent("UNIT_AURA");
		f:UnregisterEvent("CHAT_MSG_ADDON");
		f:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	end
end);