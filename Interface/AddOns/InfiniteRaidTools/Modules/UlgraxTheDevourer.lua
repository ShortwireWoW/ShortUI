local L = IRTLocals;
local f = CreateFrame("Frame");

--Addon vars
local debuffedStates = {}; -- raid poison states
local inEncounter = false;
local debuffType = {["POISON"] = "POISON"};
local debuffIds = {[debuffType.POISON] = 435138};
local popupTimer = nil;
--Player vars
local playerName = GetUnitName("player", true);
local class = select(2, UnitClass("player"));
--debug
local printDebug = false;

--Cache
local IRT_UnitDebuff = IRT_UnitDebuff;
local IRT_Contains = IRT_Contains;
local UnitIsUnit = UnitIsUnit;
local Ambiguate = Ambiguate;
local UnitIsConnected = UnitIsConnected;

f:RegisterEvent("PLAYER_LOGIN");
f:RegisterEvent("ENCOUNTER_START");
f:RegisterEvent("ENCOUNTER_END");

C_ChatInfo.RegisterAddonMessagePrefix("IRT_ULGRAX");

function IRT_ULGRAX_Debug()
	if (printDebug) then
		printDebug = false;
	else
		printDebug = true;
	end
end

function IRT_ULGRAX_StartEncounter()
	inEncounter = true;
	if (printDebug) then
		print("ULGRAX fight started");
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
			if (printDebug) then
				print(pl .. " is safe adding to text");
			end
			players = players + 1;
		elseif (state) then
			if (printDebug) then
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
		if (IRT_UlgraxEnabled == nil) then IRT_UlgraxEnabled = true; end
		if (IRT_UlgraxExtras == nil) then IRT_UlgraxExtras = false; end
	elseif (event == "CHAT_MSG_ADDON" and inEncounter and IRT_UlgraxEnabled) then
		local prefix, msg, channel, sender = ...;
		sender = Ambiguate(sender, "none");
		if (prefix == "IRT_ULGRAX") then
			if (UnitIsUnit(playerName, sender)) then
				SendChatMessage("SAFE", "SAY");
			end
			if (msg == "SAFE" and (class == "DRUID" or class == "EVOKER" or class == "MONK" or class == "PALADIN" or printDebug or IRT_UlgraxExtras)) then
				debuffedStates[sender] = true;
				if (printDebug) then
					print(sender .. " is safe updating state to true");
				end
				if (popupTimer) then
					popupTimer:Cancel();
				end
				if (printDebug) then
					print(sender .. " is safe and updating text");
				end
				local text, players = updateDispelText();
				if (popupTimer) then
					popupTimer:Cancel();
					popupTimer = nil;
				end
				popupTimer = IRT_PopupShow(text, 10, L.BOSS_FILE);
			end
		end
	elseif (event == "UNIT_AURA" and inEncounter and IRT_UlgraxEnabled) then
		local unit = ...;
		local unitName = GetUnitName(unit, true);
		if (not IRT_UnitDebuff(unit, C_Spell.GetSpellInfo(debuffIds[debuffType.POISON]).name)) then
			if (debuffedStates[unitName]) then
				if (printDebug) then
					print(unitName .. " is no longer poisoned and removed from debuff list");
				end
				debuffedStates[unitName] = nil;
				local text, players = updateDispelText();
				if (players > 0) then
					if (printDebug) then
						print(unitName .. " is no longer safe, updating text");
					end
					if (popupTimer) then
						popupTimer:Cancel();
						popupTimer = nil;
					end
					popupTimer = IRT_PopupShow(text, 10, L.BOSS_FILE);
				else
					if (printDebug) then
						print(unitName .. " is no longer safe, but players safe is 0 so hiding all");
					end
					IRT_PopupHide(L.BOSS_FILE);
				end
			end
		end
	elseif (event == "ENCOUNTER_START" and IRT_UlgraxEnabled) then
		local eID = ...;
		if (eID == 2902) then
			inEncounter = true;
			if (printDebug) then
				print("ULGRAX fight started");
			end
			f:RegisterEvent("UNIT_AURA");
			f:RegisterEvent("CHAT_MSG_ADDON");
			debuffedStates = {};
			popupTimer = nil;
		end
	elseif (event == "ENCOUNTER_END" and inEncounter and IRT_UlgraxEnabled) then
		if (printDebug) then
			print("ULGRAX fight ended");
		end
		inEncounter = false;
		f:UnregisterEvent("UNIT_AURA");
		f:UnregisterEvent("CHAT_MSG_ADDON");
		debuffedStates = {};
		IRT_PopupHide(L.BOSS_FILE);
		popupTimer = nil;
	end
end);

function IRT_ULGRAX_Test2()
	IRT_InfoBoxShow("\124cFF00FFFFIRT:\n\124r\124cFFFFFFFF1. \124cFF00FF00SAFE \124r\124cFFF48CBAhealer1\124r -> \124cFF3FC7EB debuffedPlayer1\n\124r\124cFFFFFFFF2. \124cFFFF0000UNSAFE \124r\124cFFFF7C0Ahealer2\124r -> \124cFFAAD372 debuffedPlayer2\n\124cFFFFFFFF2. \124cFFFF0000UNSAFE \124r\124cFF0070DDAhealer3\124r -> \124cFF8788EE debuffedPlayer3\n", 10)
end

function IRT_ULGRAX_Test()
	local raid = {
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

