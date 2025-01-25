local L = IRTLocals;
local f = CreateFrame("Frame");

local difficulty;
local timer = nil;
local decimatePlayers = {};
local inEncounter = false;
local raid = {};
local debugLevel = false;
local customPrio = nil;
local exposeCount = 0;
local debuffIds = {
	["BLADES"] = 433517,
	["DECIMATE_C"] = 442428,
	["BLADES_C"] = 433519,
	["EXPOSE_C"] = 432965,
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
local assignments = {
	[14] = {
		[1] = "CLEAR",
		[2] = "BACKUP",
		[3] = "BACKUP",
	},
	[15] = {
		[1] = "CLEAR",
		[2] = "BACKUP",
		[3] = "BACKUP",
	},
	[16] = {
		[1] = "LEFT",
		[2] = "RIGHT",
		[3] = "BACKUP",
	},
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
local playerName = GetUnitName("player", true);

f:RegisterEvent("PLAYER_LOGIN");
f:RegisterEvent("ENCOUNTER_START");
f:RegisterEvent("ENCOUNTER_END");

C_ChatInfo.RegisterAddonMessagePrefix("IRT_SIKRAN");

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
	if (IRT_RPAFPriority[2898] == nil) then
		prio = IRT_SavePriorityList(2898);
	else
		prio = IRT_RPAFPriority[2898];
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
		IRT_DebugMessage("raid initiated", debugLevel, L.OPTIONS_SIKRAN_TITLE);
	end
	local loopCount = GetNumGroupMembers();
	if (difficulty == 16) then
		loopCount = 20;
	end
	for i = 1, loopCount do
		local name, rank, group, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i);
		if (name and UnitIsConnected(name) and UnitIsVisible(name)) then
			if (debugLevel) then
				IRT_DebugMessage(" is added to raid with data: role: " .. "melee and group: " .. group, debugLevel, L.OPTIONS_SIKRAN_TITLE);
			end
			raid[name] = {["ROLE"] = "melee", ["GROUP"] = group, ["SPEC"] = 0};
		end
	end
	local role = UnitGroupRolesAssigned("player");
	local class = select(2, UnitClass("player"));
	local specID = select(1, GetSpecializationInfo(GetSpecialization()));
	if (role == "TANK") then
		local code = C_ChatInfo.SendAddonMessage("IRT_SIKRAN", "PLAYER_DATA tank " ..specID, "RAID");
		if (code ~= 0) then
			IRT_DebugMessage(L.ERROR_ADDON_MESSAGE_WHISPER .. IRT_GetAddonResultMessage(code), "debug", L.OPTIONS_SIKRAN_TITLE);
		end
		if (debugLevel) then
			IRT_DebugMessage("sending msg: tank to raid " .. IRT_GetAddonResultMessage(code), debugLevel, L.OPTIONS_SIKRAN_TITLE);
		end
	elseif (role == "HEALER") then
		local code = C_ChatInfo.SendAddonMessage("IRT_SIKRAN", "PLAYER_DATA healer " ..specID, "RAID");
		if (code ~= 0) then
			IRT_DebugMessage(L.ERROR_ADDON_MESSAGE_WHISPER .. IRT_GetAddonResultMessage(code), "debug", L.OPTIONS_SIKRAN_TITLE);
		end
		if (debugLevel) then
			IRT_DebugMessage("sending msg: healer to raid " .. IRT_GetAddonResultMessage(code), debugLevel, L.OPTIONS_SIKRAN_TITLE);
		end
	else
		if (class == "MAGE" or class == "WARLOCK" or class == "PRIEST" or class == "EVOKER") then
			local code = C_ChatInfo.SendAddonMessage("IRT_SIKRAN", "PLAYER_DATA ranged " ..specID, "RAID"); --covers pure ranged classes
			if (code ~= 0) then
				IRT_DebugMessage(L.ERROR_ADDON_MESSAGE_WHISPER .. IRT_GetAddonResultMessage(code), "debug", L.OPTIONS_SIKRAN_TITLE);
			end
			if (debugLevel) then
				IRT_DebugMessage("sending msg: ranged to raid " .. IRT_GetAddonResultMessage(code), debugLevel, L.OPTIONS_SIKRAN_TITLE);
			end
		elseif (meleeSpecIDs[specID] or class == "WARRIOR" or class == "ROGUE" or class == "DEMONHUNTER" or class == "DEATHKNIGHT" or class == "MONK" or class == "PALADIN") then
			local code = C_ChatInfo.SendAddonMessage("IRT_SIKRAN", "PLAYER_DATA melee " ..specID, "RAID"); --covers hybrid dps classes
			if (code ~= 0) then
				IRT_DebugMessage(L.ERROR_ADDON_MESSAGE_WHISPER .. IRT_GetAddonResultMessage(code), "debug", L.OPTIONS_SIKRAN_TITLE);
			end
			if (debugLevel) then
				IRT_DebugMessage("sending msg: melee to raid " .. IRT_GetAddonResultMessage(code), debugLevel, L.OPTIONS_SIKRAN_TITLE);
			end
		else
			local code = C_ChatInfo.SendAddonMessage("IRT_SIKRAN", "PLAYER_DATA ranged " ..specID, "RAID"); --covers melee classes
			if (code ~= 0) then
				IRT_DebugMessage(L.ERROR_ADDON_MESSAGE_WHISPER .. IRT_GetAddonResultMessage(code), "debug", L.OPTIONS_SIKRAN_TITLE);
			end
			if (debugLevel) then
				IRT_DebugMessage("sending msg: ranged to raid " .. IRT_GetAddonResultMessage(code), debugLevel, L.OPTIONS_SIKRAN_TITLE);
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

local function sortDecimatedList()
	local result = {};
	if (debugLevel) then
		IRT_DebugMessage("sorting debuffed players based on role", debugLevel, L.OPTIONS_SIKRAN_TITLE);
	end
	for i = 1, #decimatePlayers do
		if (debugLevel) then
			IRT_DebugMessage("creating temp array with following variables: name: " .. decimatePlayers[i] .. " role " .. raid[decimatePlayers[i]]["ROLE"] .. " group: " .. raid[decimatePlayers[i]]["GROUP"], debugLevel, L.OPTIONS_SIKRAN_TITLE);
		end
		table.insert(result, {decimatePlayers[i], raid[decimatePlayers[i]]["ROLE"], raid[decimatePlayers[i]]["GROUP"]});
	end
	table.sort(result, compare);
	if (debugLevel) then
		IRT_DebugMessage("sorted debuffs looks as following: ", debugLevel, L.OPTIONS_SIKRAN_TITLE);
		for i = 1, #result do
			IRT_DebugMessage(result[i][1], debugLevel, L.OPTIONS_SIKRAN_TITLE);
		end
	end
	return result;
end

local function getUpdatedDecimateList()
	local sortedDecimateList = sortDecimatedList();
	local text = IRT_GetIRTColor();
	for i, data in pairs(sortedDecimateList) do
		local pl = data[1];
		text = text .. "\n" .. "|cFFFFFFFF" .. assignments[difficulty][i] .. ":|r " .. IRT_ClassColorName(pl);
	end
	return text;
end

function IRT_Sikran_Debug(level)
	debugLevel = level;
	print("debug started at level " .. level);
end
f:SetScript("OnEvent", function(self, event, ...)
	if (event == "PLAYER_LOGIN") then
		if (IRT_SikranEnabled == nil) then IRT_SikranEnabled = true; end
		if (IRT_RPAFEnabled[2898] == nil) then
			IRT_RPAFEnabled[2898] = false;
		end
	elseif (event == "CHAT_MSG_ADDON" and IRT_SikranEnabled and inEncounter) then
		local prefix, msg, channel, sender = ...;
		if (prefix == "IRT_SIKRAN") then
			sender = Ambiguate(sender, "none");
			msg = IRT_DecodeAddonMesageWhisper(channel, msg);
			if (msg == nil) then
				return;
			end
			if (debugLevel) then
				IRT_DebugMessage("recieved addon message " .. msg .. " from " .. sender, debugLevel, L.OPTIONS_SIKRAN_TITLE);
			end
			if (msg == "S_DEC") then
				if (not IRT_Contains(decimatePlayers, sender)) then
					if (debugLevel) then
						IRT_DebugMessage("addon message was about decimate adding " .. sender .. " to list of decimate and updating list", debugLevel, L.OPTIONS_SIKRAN_TITLE);
					end
					table.insert(decimatePlayers, sender);
					IRT_InfoBoxShow(getUpdatedDecimateList(), 5);
				end
			elseif (msg:match("PLAYER_DATA") or msg == "healer" or msg == "ranged" or msg == "tank" or msg == "melee") then
				local _, role, specID = strsplit(" ", msg, 3);
				raid[sender]["ROLE"] = role;
				if (tonumber(specID)) then
					specID = tonumber(specID);
					raid[sender]["SPEC"] = specID;
				end
				if (debugLevel) then
					IRT_DebugMessage("change role on player " .. sender .. " to " .. msg, debugLevel, L.OPTIONS_SIKRAN_TITLE);
					IRT_DebugMessage("got a message in raid addon channel from " .. sender .. " that their role is " .. role .. " and specID " .. specID .. " updating the raid variable", debugLevel, L.OPTIONS_SIKRAN_TITLE);
				end
			elseif (msg:match("RPAF")) then
				local _, assignment = strsplit(" ", msg, 2);
				if (tonumber(assignment)) then
					assignment = tonumber(assignment);
					PlaySoundFile("Interface\\AddOns\\InfiniteRaidTools\\Sound\\CalendarNotification\\calnot" .. assignment .. ".ogg", "master");
					IRT_PopupShow("POSITION: \124cFFFFFFFF" .. assignment .. "\124r", 5, L.BOSS_FILE);
					timer = IRT_NotifyPlayer(timer, assignment, "SAY", 5, 1.5);
				elseif (assignment == "ABORT") then
					IRT_PopupHide(L.BOSS_FILE);
					if (timer) then
						timer:Cancel();
						timer = nil;
					end
				end
			end
		end
	elseif (event == "COMBAT_LOG_EVENT_UNFILTERED" and IRT_SikranEnabled and inEncounter) then
		local _, logEvent, _, _, _, _, _, _, target, _, _, spellID, _, _, _, _ = CombatLogGetCurrentEventInfo();
		if (logEvent == "SPELL_CAST_SUCCESS") then
			if (spellID == debuffIds["DECIMATE_C"]) then
				IRT_DebugMessage("boss casted decimate reseting list of decimate", debugLevel, L.OPTIONS_SIKRAN_TITLE);
				decimatePlayers = {};
				IRT_InfoBoxHide();
			elseif (spellID == debuffIds["EXPOSE_C"]) then
				exposeCount = exposeCount + 1;
				if (true) then
					if (customPrio == nil) then
						customPrio = setupPrio();
					end
					if (IRT_RPAFEnabled[2898]) then
						IRT_RPAFReset();
						IRT_RPAFShow(difficulty, "IRT_SIKRAN", 25, customPrio);
					end
				end
			end
		end
	elseif (event == "CHAT_MSG_RAID_BOSS_WHISPER" and IRT_SikranEnabled and inEncounter) then
		local msg = ...;
		if (debugLevel) then
			IRT_DebugMessage("recieved boss whisper " .. msg, debugLevel, L.OPTIONS_SIKRAN_TITLE);
		end
		if (msg:find("459349")) then
			local code = C_ChatInfo.SendAddonMessage("IRT_SIKRAN", "S_DEC", "RAID");
			if (code ~= 0) then
				IRT_DebugMessage(L.ERROR_ADDON_MESSAGE_WHISPER .. IRT_GetAddonResultMessage(code), "debug", L.OPTIONS_SIKRAN_TITLE);
			end
			if (debugLevel) then
				IRT_DebugMessage("boss whisper was a match, sending raid addon message with response code " .. IRT_GetAddonResultMessage(code), debugLevel, L.OPTIONS_SIKRAN_TITLE);
			end
		end
	elseif (event == "ENCOUNTER_START" and IRT_SikranEnabled) then
		local eID = ...;
		if (eID == 2898) then
			if (debugLevel) then
				IRT_DebugMessage("sikran encounter started", debugLevel, L.OPTIONS_SIKRAN_TITLE);
			end
			inEncounter = true;
			difficulty = select(3, GetInstanceInfo());
			f:RegisterEvent("CHAT_MSG_RAID_BOSS_WHISPER");
			f:RegisterEvent("CHAT_MSG_ADDON");
			f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
			decimatePlayers = {};
			exposeCount = 0;
			raid = {};
			customPrio = nil;
			IRT_PopupHide(L.BOSS_FILE);
			IRT_RPAFHide();
			IRT_InfoBoxHide();
			initRaid();
			if (timer) then
				timer:Cancel();
				timer = nil;
			end
		end
	elseif (event == "ENCOUNTER_END" and inEncounter and IRT_SikranEnabled) then
		if (debugLevel) then
			IRT_DebugMessage("sikran encounter ended", debugLevel, L.OPTIONS_SIKRAN_TITLE);
		end
		IRT_PopupHide(L.BOSS_FILE);
		IRT_RPAFHide();
		if (timer) then
			timer:Cancel();
			timer = nil;
		end
		inEncounter = false;
		exposeCount = 0;
		customPrio = nil;
		decimatePlayers = {};
		raid = {};
		IRT_InfoBoxHide();
		f:UnregisterEvent("CHAT_MSG_RAID_BOSS_WHISPER");
		f:UnregisterEvent("CHAT_MSG_ADDON");
		f:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	end
end);