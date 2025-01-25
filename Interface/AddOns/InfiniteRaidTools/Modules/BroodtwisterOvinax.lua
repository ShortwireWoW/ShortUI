local L = IRTLocals;
local f = CreateFrame("Frame");

--Addon vars
local debuffedStates = {}; -- raid poison states
local inEncounter = false;
local debuffIds = {["WEB"] = 446349, ["EXPERIMENTAL"] = 440421};
local experimentalPlayers = {};
local popupTimer = nil;
local raid = {};
local difficulty
local timer = nil;
local meleeSpecIDs = {
	[103] = true,
	[255] = true,
	[263] = true,
};
local rolePrio = {
	["melee"] = 1,
	["healer"] = 2,
	["ranged"] = 3,
	["tank"] = 4,
};
local groupIcons = {
	[1] = "STAR",
	[2] = "CIRCLE",
	[3] = "DIAMOND",
	[4] = "TRIANGLE",
};
--Player vars
local playerName = GetUnitName("player", true);
local role = UnitGroupRolesAssigned("player");
local leader;
--debug
local debugLevel = nil;

--Cache
local IRT_UnitDebuff = IRT_UnitDebuff;
local IRT_Contains = IRT_Contains;
local UnitIsUnit = UnitIsUnit;
local Ambiguate = Ambiguate;
local UnitIsConnected = UnitIsConnected;

f:RegisterEvent("PLAYER_LOGIN");
f:RegisterEvent("ENCOUNTER_START");
f:RegisterEvent("ENCOUNTER_END");

C_ChatInfo.RegisterAddonMessagePrefix("IRT_BROOD");

local function initRaid()
	if (debugLevel) then
		IRT_DebugMessage("raid initiated", debugLevel, L.OPTIONS_BROODTWISTER_TITLE);
	end
	local loopCount = GetNumGroupMembers();
	if (difficulty == 16) then
		loopCount = 20;
	end
	for i = 1, loopCount do
		local name, rank, group, level, class, fileName, zone, online, isDead, plRole, isML = GetRaidRosterInfo(i);
		if (name and UnitIsConnected(name) and UnitIsVisible(name)) then
			if (debugLevel) then
				IRT_DebugMessage(" is added to raid with data: role: " .. "melee and group: " .. group, debugLevel, L.OPTIONS_BROODTWISTER_TITLE);
			end
			raid[name] = {["ROLE"] = "melee", ["GROUP"] = group};
		end
	end
	role = UnitGroupRolesAssigned("player");
	local class = select(2, UnitClass("player"));
	local specID = select(1, GetSpecializationInfo(GetSpecialization()));
	if (role == "TANK") then
		local code = C_ChatInfo.SendAddonMessage("IRT_BROOD", "tank", "RAID");
		if (code ~= 0) then
			IRT_DebugMessage(L.ERROR_ADDON_MESSAGE_WHISPER .. IRT_GetAddonResultMessage(code), "debug", L.OPTIONS_BROODTWISTER_TITLE);
		end
		if (debugLevel) then
			IRT_DebugMessage("sending msg: tank to raid " .. IRT_GetAddonResultMessage(code), debugLevel, L.OPTIONS_BROODTWISTER_TITLE);
		end
	elseif (role == "HEALER") then
		local code = C_ChatInfo.SendAddonMessage("IRT_BROOD", "healer", "RAID");
		if (code ~= 0) then
			IRT_DebugMessage(L.ERROR_ADDON_MESSAGE_WHISPER .. IRT_GetAddonResultMessage(code), "debug", L.OPTIONS_BROODTWISTER_TITLE);
		end
		if (debugLevel) then
			IRT_DebugMessage("sending msg: healer to raid " .. IRT_GetAddonResultMessage(code), debugLevel, L.OPTIONS_BROODTWISTER_TITLE);
		end
	else
		if (class == "MAGE" or class == "WARLOCK" or class == "PRIEST" or class == "EVOKER") then
			local code = C_ChatInfo.SendAddonMessage("IRT_BROOD", "ranged", "RAID"); --covers pure ranged classes
			if (code ~= 0) then
				IRT_DebugMessage(L.ERROR_ADDON_MESSAGE_WHISPER .. IRT_GetAddonResultMessage(code), "debug", L.OPTIONS_BROODTWISTER_TITLE);
			end
			if (debugLevel) then
				IRT_DebugMessage("sending msg: ranged to raid " .. IRT_GetAddonResultMessage(code), debugLevel, L.OPTIONS_BROODTWISTER_TITLE);
			end
		elseif (meleeSpecIDs[specID] or class == "WARRIOR" or class == "ROGUE" or class == "DEMONHUNTER" or class == "DEATHKNIGHT" or class == "MONK" or class == "PALADIN") then
			local code = C_ChatInfo.SendAddonMessage("IRT_BROOD", "melee", "RAID"); --covers hybrid dps classes
			if (code ~= 0) then
				IRT_DebugMessage(L.ERROR_ADDON_MESSAGE_WHISPER .. IRT_GetAddonResultMessage(code), "debug", L.OPTIONS_BROODTWISTER_TITLE);
			end
			if (debugLevel) then
				IRT_DebugMessage("sending msg: melee to raid " .. IRT_GetAddonResultMessage(code), debugLevel, L.OPTIONS_BROODTWISTER_TITLE);
			end
		else
			local code = C_ChatInfo.SendAddonMessage("IRT_BROOD", "ranged", "RAID"); --covers melee classes
			if (code ~= 0) then
				IRT_DebugMessage(L.ERROR_ADDON_MESSAGE_WHISPER .. IRT_GetAddonResultMessage(code), "debug", L.OPTIONS_BROODTWISTER_TITLE);
			end
			if (debugLevel) then
				IRT_DebugMessage("sending msg: ranged to raid " .. IRT_GetAddonResultMessage(code), debugLevel, L.OPTIONS_BROODTWISTER_TITLE);
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

local function sortExperimentList()
	local result = {};
	if (debugLevel) then
		IRT_DebugMessage("sorting debuffed players based on role", debugLevel, L.OPTIONS_BROODTWISTER_TITLE);
	end
	for i = 1, #experimentalPlayers do
		if (debugLevel) then
			IRT_DebugMessage("creating temp array with following variables: name: " .. experimentalPlayers[i] .. " role " .. raid[experimentalPlayers[i]]["ROLE"] .. " group: " .. raid[experimentalPlayers[i]]["GROUP"], debugLevel, L.OPTIONS_BROODTWISTER_TITLE);
		end
		table.insert(result, {experimentalPlayers[i], raid[experimentalPlayers[i]]["ROLE"], raid[experimentalPlayers[i]]["GROUP"]});
	end
	table.sort(result, compare);
	if (debugLevel) then
		IRT_DebugMessage("sorted debuffs looks as following: ", debugLevel, L.OPTIONS_BROODTWISTER_TITLE);
		for i = 1, #result do
			IRT_DebugMessage(result[i][1], debugLevel, L.OPTIONS_BROODTWISTER_TITLE);
		end
	end
	return result;
end

function IRT_BROODTWISTER_Debug()
	if (debugLevel) then
		debugLevel = false;
	else
		debugLevel = true;
		print("debug started")
	end
end

function IRT_BROODTWISTER_StartEncounter()
	inEncounter = true;
	if (debugLevel) then
		print("BROODTWISTER fight started");
	end
	f:RegisterEvent("UNIT_AURA");
	f:RegisterEvent("CHAT_MSG_ADDON");
	debuffedStates = {};
end
local function updateDispelText()
		local text = "\124cFF00FF00Dispel\124r ";
		local isFirst = true;
		local players = 0;
		for pl, state in pairs(debuffedStates) do
			if (UnitIsConnected(pl)) then
				pl = string.format("\124c%s%s\124r", RAID_CLASS_COLORS[select(2, UnitClass(pl))].colorStr, Ambiguate(pl, "short"));
			end
		if (isFirst and state) then
			isFirst = false;
			text = text .. pl;
			if (debugLevel) then
				print(pl .. " is safe adding to text");
			end
			players = players + 1;
		elseif (state) then
			if (debugLevel) then
				print(pl .. " is safe adding to text");
			end
			text = text .. " AND " .. pl;
			players = players + 1;
		end
	end
	return text, players;
end
f:SetScript("OnEvent", function(self, event, ...)
	if (event == "PLAYER_LOGIN") then
		if (IRT_BroodtwisterEnabled == nil) then IRT_BroodtwisterEnabled = true; end
		if (IRT_BroodtwisterExtras == nil) then IRT_BroodtwisterExtras = false; end
	elseif (event == "CHAT_MSG_ADDON" and inEncounter and IRT_BroodtwisterEnabled) then
		local prefix, msg, channel, sender = ...;
		sender = Ambiguate(sender, "none");
		if (prefix == "IRT_BROOD") then
			if (msg == "SAFE" and UnitIsUnit(playerName, sender)) then
				SendChatMessage("SAFE", "SAY");
			end
			if (msg == "SAFE" and (role == "HEALER" or debugLevel or IRT_BroodtwisterExtras)) then
				debuffedStates[sender] = true;
				if (debugLevel) then
					print(sender .. " is safe updating state to true");
				end
				if (popupTimer) then
					popupTimer:Cancel();
				end
				if (debugLevel) then
					print(sender .. " is safe and updating text");
				end
				local text, players = updateDispelText();
				if (popupTimer) then
					popupTimer:Cancel();
					popupTimer = nil;
				end
				popupTimer = IRT_PopupShow(text, 10, L.BOSS_FILE);
			elseif (msg == "healer" or msg == "ranged" or msg == "tank" or msg == "melee") then
				if (debugLevel) then
					IRT_DebugMessage("change role on player " .. sender .. " to " .. msg, debugLevel, L.OPTIONS_BROODTWISTER_TITLE);
				end
				raid[sender]["ROLE"] = msg;
			end
		end
	elseif (event == "COMBAT_LOG_EVENT_UNFILTERED" and inEncounter and IRT_BroodtwisterEnabled) then
		local _, logEvent, _, _, _, _, _, _, target, _, _, spellID, _, _, _, _ = CombatLogGetCurrentEventInfo();
		if (logEvent == "SPELL_AURA_APPLIED") then
			target = Ambiguate(target, "none");
			if (spellID and spellID == debuffIds["EXPERIMENTAL"] and not IRT_Contains(experimentalPlayers, target)) then
				if (debugLevel) then
					print("adding " .. target);
				end
				table.insert(experimentalPlayers, target);
				if (#experimentalPlayers == 4 and difficulty == 15) then
					local sortedExperiemntList = sortExperimentList();
					for k, data in pairs(sortedExperiemntList) do
						if (UnitIsUnit(playerName, leader)) then
							SetRaidTarget(data[1], k);
						end
						if (UnitIsUnit(playerName, data[1])) then
							PlaySoundFile("Interface\\AddOns\\InfiniteRaidTools\\Sound\\" .. groupIcons[math.ceil(k)] .. ".ogg", "master");
							IRT_PopupShow("\124TInterface\\TargetingFrame\\UI-RaidTargetingIcon_" .. k .. ":30\124t".." GO TO " .. groupIcons[k] .. "\124TInterface\\TargetingFrame\\UI-RaidTargetingIcon_" .. k .. ":30\124t", 5, L.BOSS_FILE);
							timer = IRT_NotifyPlayer(timer, "{rt" .. math.ceil(k) .. "} ", "SAY", 4);
						end
					end
				elseif (#experimentalPlayers == 2 and difficulty == 14) then
					local sortedExperiemntList = sortExperimentList();
					if (debugLevel) then
						print("sorting list")
					end
					for k, data in pairs(sortedExperiemntList) do
						if (UnitIsUnit(playerName, leader)) then
							SetRaidTarget(data[1], k);
						end
						if (UnitIsUnit(playerName, data[1])) then
							PlaySoundFile("Interface\\AddOns\\InfiniteRaidTools\\Sound\\" .. groupIcons[math.ceil(k)] .. ".ogg", "master");
							IRT_PopupShow("\124TInterface\\TargetingFrame\\UI-RaidTargetingIcon_" .. k .. ":30\124t".." GO TO " .. groupIcons[k] .. "\124TInterface\\TargetingFrame\\UI-RaidTargetingIcon_" .. k .. ":30\124t", 5, L.BOSS_FILE);
							timer = IRT_NotifyPlayer(timer, "{rt" .. math.ceil(k) .. "} ", "SAY", 4);
						end
					end
				elseif (difficulty == 16 and #experimentalPlayers == 8) then
					local sortedExperiemntList = sortExperimentList();
					if (debugLevel) then
						print("sorting list")
					end
					for k, data in pairs(sortedExperiemntList) do
						if (UnitIsUnit(playerName, leader) and k%2 == 0) then
							SetRaidTarget(data[1], k/2);
						end
						if (UnitIsUnit(playerName, data[1])) then
							PlaySoundFile("Interface\\AddOns\\InfiniteRaidTools\\Sound\\" .. groupIcons[math.ceil(k/2)] .. ".ogg", "master");
							IRT_PopupShow("\124TInterface\\TargetingFrame\\UI-RaidTargetingIcon_" .. math.ceil(k/2) .. ":30\124t".." GO TO " .. groupIcons[math.ceil(k/2)] .. "\124TInterface\\TargetingFrame\\UI-RaidTargetingIcon_" .. math.ceil(k/2) .. ":30\124t", 5, L.BOSS_FILE);
							timer = IRT_NotifyPlayer(timer, "{rt" .. math.ceil(k/2) .. "} ", "SAY", 4);
						end
					end
				end
			end
		elseif (logEvent == "SPELL_AURA_REMOVED") then
			target = Ambiguate(target, "none");
			if (spellID == debuffIds["WEB"]) then
				if (debuffedStates[target]) then
					if (debugLevel) then
						print(target .. " is no longer web and removed from debuff list");
					end
					debuffedStates[target] = nil;
					local text, players = updateDispelText();
					if (players > 0) then
						if (debugLevel) then
							print(target .. " is no longer safe, updating text");
						end
						if (popupTimer) then
							popupTimer:Cancel();
							popupTimer = nil;
						end
						popupTimer = IRT_PopupShow(text, 10, L.BOSS_FILE);
					else
						if (debugLevel) then
							print(target .. " is no longer safe, but players safe is 0 so hiding all");
						end
						IRT_PopupHide(L.BOSS_FILE);
					end
				end
			elseif (spellID == debuffIds["EXPERIMENTAL"] and IRT_Contains(experimentalPlayers, target)) then
				if (debugLevel) then
					print("removing " .. target);
				end
				table.remove(experimentalPlayers, IRT_Contains(experimentalPlayers, target));
				if (UnitIsUnit(playerName, leader)) then
					SetRaidTarget(target, 0);
				end
			end
		end
	elseif (event == "ENCOUNTER_START" and IRT_BroodtwisterEnabled) then
		local eID = ...;
		if (eID == 2919) then
			difficulty = select(3, GetInstanceInfo());
			inEncounter = true;
			if (debugLevel) then
				print("BROODTWISTER fight started");
			end
			role = UnitGroupRolesAssigned("player");
			f:RegisterEvent("UNIT_AURA");
			f:RegisterEvent("CHAT_MSG_ADDON");
			f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
			debuffedStates = {};
			leader = IRT_GetRaidLeader();
			popupTimer = nil;
			raid = {};
			initRaid();
			if (timer) then
				timer:Cancel();
				timer = nil;
			end
		end
	elseif (event == "ENCOUNTER_END" and inEncounter and IRT_BroodtwisterEnabled) then
		if (debugLevel) then
			print("BROODTWISTER fight ended");
		end
		role = UnitGroupRolesAssigned("player");
		inEncounter = false;
		leader = nil;
		f:UnregisterEvent("UNIT_AURA");
		f:UnregisterEvent("CHAT_MSG_ADDON");
		f:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
		debuffedStates = {};
		IRT_PopupHide(L.BOSS_FILE);
		popupTimer = nil;
		raid = {};
		if (timer) then
			timer:Cancel();
			timer = nil;
		end
	end
end);

function IRT_BROODTWISTER_Test2()
	IRT_InfoBoxShow("\124cFF00FFFFIRT:\n\124r\124cFFFFFFFF1. \124cFF00FF00SAFE \124r\124cFFF48CBAhealer1\124r -> \124cFF3FC7EB debuffedPlayer1\n\124r\124cFFFFFFFF2. \124cFFFF0000UNSAFE \124r\124cFFFF7C0Ahealer2\124r -> \124cFFAAD372 debuffedPlayer2\n\124cFFFFFFFF2. \124cFFFF0000UNSAFE \124r\124cFF0070DDAhealer3\124r -> \124cFF8788EE debuffedPlayer3\n", 10)
end

function IRT_BROODTWISTER_Test()
	raid = {
		["Pred"] = "tank",
		["Nost"] = "tank",
		["Marie"] = "healer",
		["Natu"] = "healer",
		["Janga"] = "healer",
		["Warlee"] = "healer",
		["Ala"] = "ranged",
		["Ant"] = "ranged",
		["Blink"] = "ranged",
		["Fed"] = "ranged",
		["Cakk"] = "ranged",
		["Maev"] = "ranged",
		["Mvk"] = "ranged",
		["Sloni"] = "ranged",
		["Sejuka"] = "ranged",
		["Emnity"] = "ranged",
		["Bram"] = "melee",
		["Dez"] = "melee",
		["Sloxy"] = "melee",
		["Cata"] = "melee",
	};
	local debuffed = {};
	debuffedStates = {};
	for i = 1, 3 do
		local player = nil;
		local rng = math.random(1, 20);
		local rngRange = math.random(1,2);
		local count = 1;
		for k, v in pairs(raid) do
			if (rng == count) then
				player = k;
			end
			count = count + 1;
		end
		while (IRT_Contains(debuffed, player)) do
			rng = math.random(1, 20);
			count = 1;
			for k, v in pairs(raid) do
				if (rng == count) then
					player = k;
				end
				count = count + 1;
			end
		end
		if (rngRange == 1) then
			debuffedStates[player] = true;
		else
			debuffedStates[player] = false;
		end
	end
	print("debuffed:")
	for pl, state in pairs(debuffedStates) do
		print("\n" .. pl .. " " .. tostring(state));
	end
	IRT_PopupShow(updateDispelText(), 10, L.BOSS_FILE);
end

