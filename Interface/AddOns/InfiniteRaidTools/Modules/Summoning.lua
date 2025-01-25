local L = IRTLocals;

local f = CreateFrame("Frame");
local assignments = {};
local raidZones = {"Nerub-ar Palace"};
local awaitingSummons = {};
local difficulty = nil;
local playerName = GetUnitName("player", true);
local available = false;
local raids = {
	"Nerub'ar Palace",
};
local myTarget = nil;
local needAssist = {};
local raidFrames = {};
local timer = nil;

local debugEnabled = false;

C_ChatInfo.RegisterAddonMessagePrefix("IRT_SUM");

f:RegisterEvent("PLAYER_LOGIN");
f:RegisterEvent("CHAT_MSG_ADDON");
f:RegisterEvent("CHAT_MSG_RAID");
f:RegisterEvent("GROUP_ROSTER_UPDATE");
f:RegisterEvent("INCOMING_SUMMON_CHANGED");
f:RegisterEvent("ZONE_CHANGED_NEW_AREA");
f:RegisterEvent("CHAT_MSG_RAID_LEADER");

local targetBorder = CreateFrame("Frame", nil, f, "ActionButtonInterruptTemplate");
targetBorder:GetParent().cooldown = nil;
targetBorder.cooldown = nil;
targetBorder:Hide();

local ag = targetBorder:CreateAnimationGroup();
ag:SetLooping("REPEAT");

local aniFade = ag:CreateAnimation("Alpha");
aniFade:SetDuration(2);
aniFade:SetToAlpha(0.8);
aniFade:SetFromAlpha(1);
aniFade:SetOrder(1);

local aniAppear = ag:CreateAnimation("Alpha");
aniAppear:SetDuration(1.5);
aniAppear:SetToAlpha(1);
aniAppear:SetFromAlpha(0.8);
aniAppear:SetOrder(2);

local rotate = ag:CreateAnimation("Rotation");
rotate:SetDuration(12);
rotate:SetDegrees(360);

function IRT_SUMMONING_DEBUG()
	if (debugEnabled) then
		debugEnabled = false;
	else
		debugEnabled = true;
	end
end

-- The `updateGlow` function updates the appearance of the target border frame.
--
-- @param isGlow A boolean indicating if the frame should be glowing or not.
-- @param frame The frame to which the target border should be attached.

local function updateGlow(isGlow, frame)
    if (isGlow) then
		targetBorder:ClearAllPoints();
		local frameWidth, frameHeight = frame:GetSize();
		targetBorder:SetSize(frameWidth * 1.1, frameHeight * 1.1);
		targetBorder:SetPoint("CENTER", frame, "CENTER", 0, 0);
		targetBorder.Base.AnimIn:Play();
		targetBorder.Highlight.AnimIn:Play();
	else
		targetBorder:ClearAllPoints();
		targetBorder.Base.AnimIn:Stop();
		targetBorder.Highlight.AnimIn:Stop();
		targetBorder:Hide();
    end
end

-- The `volunteer` function sends a message indicating the player's willingness to summon a target.
--
-- @param target The name of the target to be summoned.
local function volunteer(target)
	if(debugEnabled) then
		print(target .. " needs a summon, checking if I can volunteer");
	end
	if (available) then
		if(debugEnabled) then
			print("I am available and will try to get the job to summon " .. target);
		end
		local code = C_ChatInfo.SendAddonMessage("IRT_SUM", Ambiguate(target, "none"), "RAID");
		if (code ~= 0) then
			IRT_DebugMessage(L.ERROR_ADDON_MESSAGE_WHISPER .. IRT_GetAddonResultMessage(code), "debug", L.OPTIONS_SUMMON_TITLE);
		end
	end
end

-- The `init` function initializes the raid and checks who needs a summon.
local function init()
	if(debugEnabled) then
		print("initializing raid to see who needs summon");
	end
	difficulty = GetRaidDifficultyID();
	if (difficulty == 16) then
		for i = 1, 20 do
			local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i);
			if (name) then
				name = Ambiguate(name, "none");
				if (not IRT_Contains(raidZones, zone)) then
					if(debugEnabled) then
						print(name .. " is in zone: " .. zone .. " which is not a raid, they will be added to the list if they arent already.");
					end
					if (not IRT_Contains(awaitingSummons, name)) then
						if(debugEnabled) then
							print("added " .. name .. " to the list of players that needs summon");
						end
						table.insert(awaitingSummons, name);
					end
				end
			end
		end
	else
		for i = 1, GetNumGroupMembers() do
			local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i);
			name = Ambiguate(name, "none");
			if (not IRT_Contains(raidZones, zone)) then
				if(debugEnabled) then
					print(name .. " is in zone: " .. zone .. " which is not a raid, they will be added to the list if they arent already.");
				end
				if (not IRT_Contains(awaitingSummons, name)) then
					if(debugEnabled) then
						print("added " .. name .. " to the list of players that needs summon");
					end
					table.insert(awaitingSummons, name);
				end
			end
		end
	end
	if (next(awaitingSummons)) then
		if(debugEnabled) then
			print("finished initializing will now try to volunteer to summon " .. awaitingSummons[1]);
		end
		volunteer(awaitingSummons[1]);
	else
		if(debugEnabled) then
			print("finished initializing no players needs summons");
		end
	end
end
--[[
local function updateRaid(player)
	for i = 1, GetNumGroupMembers() do
		local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i);
		name = Ambiguate(name, "none");
		if (name == player) then
			local contains = IRT_Contains(raid, name);
			if (contains) then
			else
			end
		end
	end
end
]]

local function updateRaid()
	if(debugEnabled) then
		print("updating raidFrames");
	end
	raidFrames = {};
	for group = 1, 8 do
		for member = 1, 5 do
			if (_G["CompactRaidGroup"..group.."Member"..member] and _G["CompactRaidGroup"..group.."Member"..member]:GetAttribute("unit")) then
				if (GetUnitName(_G["CompactRaidGroup"..group.."Member"..member]:GetAttribute("unit"), true)) then
					local unit = Ambiguate(GetUnitName(_G["CompactRaidGroup"..group.."Member"..member]:GetAttribute("unit"), true), "none");
					raidFrames[unit] = _G["CompactRaidGroup"..group.."Member"..member];
				end
			end
		end
	end
	if (myTarget and assignments[playerName]) then
		updateGlow(true, raidFrames[myTarget]);
	else
		updateGlow(false);
	end
end

local function summonPlayer(target, isAssist)
	if (isAssist) then
		if(debugEnabled) then
			print("player is assigned to be assist to summon " .. target);
		end
		IRT_PopupShow(L.SUMMONING_ASSIST_PLAYER_1 .. IRT_ClassColorName(assignments[target]) .. L.SUMMONING_ASSIST_PLAYER_2, 90, "SUMMONING");
	else
		if(debugEnabled) then
			print("player is assigned to summon " .. target .. " starting glow");
		end
		IRT_PopupShow(L.SUMMONING_SUMMON_PLAYER .. IRT_ClassColorName(target), 90, "SUMMONING");
		updateGlow(true, raidFrames[target]);
		timer = C_Timer.After(90, function()
			updateGlow(false);
		end);
	end
	myTarget = target;
end

local function skipSummon(target)
	if(debugEnabled) then
		print(target .. " wants to be skipped");
	end
	if (IRT_Contains(awaitingSummons, target)) then
		if(debugEnabled) then
			print("the player was in the list of summons and has been removed");
		end
		table.remove(awaitingSummons, IRT_Contains(awaitingSummons, target));
		if (assignments[target]) then
			if(debugEnabled) then
				print("the assignment of summoning " .. target .. " has been removed");
			end
			assignments[target] = nil;
		end
		if (myTarget == target) then
			if(debugEnabled) then
				print("I was supposed to summon or assist " .. target .. " but it has now been reset");
			end
			myTarget = nil;
			updateGlow(false);
			IRT_PopupHide("SUMMONING");
			if (timer) then
				timer:Cancel();
				timer = nil;
				updateGlow(false);
			end
			local contains = IRT_Contains(needAssist, target);
			if (contains) then
				if(debugEnabled) then
					print(target .. " was pending an assist which is now removed");
				end
				table.remove(needAssist, contains);
			end
			available = true;
			if(debugEnabled) then
				print("now available to summon");
			end
			local nextTarget = next(awaitingSummons);
			local nextAssist = next(needAssist);
			if (nextAssist) then
				if(debugEnabled) then
					print("going to volunteer to assist to summon " .. nextAssist);
				end
				volunteer(needAssist[1]);
			elseif (nextTarget) then
				if(debugEnabled) then
					print("going to volunteer to summon " .. nextTarget);
				end
				volunteer(awaitingSummons[1]);
			end
		end
	end
end

f:SetScript("OnEvent", function(self, event, ...)
	if (event == "PLAYER_LOGIN") then
		if (IRT_SummonEnabled == nil) then IRT_SummonEnabled = true; end
		if (IsInRaid()) then
			local zone = GetRealZoneText();
			if (myTarget == nil and IRT_Contains(raids, zone)) then
				if(debugEnabled) then
					print("in a raid group, dont have a target and in a raid instance, now marked as available");
				end
				available = true;
			end
			for i = 1, #awaitingSummons do
				if (not UnitInRaid(awaitingSummons[i])) then
					if(debugEnabled) then
						print(awaitingSummons[i] .. " is not in the raid group anymore, removing from list");
					end
					skipSummon(awaitingSummons[i]);
				end
			end
			if(debugEnabled) then
				print("calling to update raid frames");
			end
			updateRaid();
			if (available and next(awaitingSummons) ~= nil) then
				if(debugEnabled) then
					print("available and there are players that needs summon, trying to volunteer to summon " .. awaitingSummons[1]);
				end
				volunteer(awaitingSummons[1]);
			end
		end
	elseif (event == "INCOMING_SUMMON_CHANGED" and IRT_SummonEnabled) then
		local target = ...;
		target = Ambiguate(GetUnitName(target, true), "none");
		if(debugEnabled) then
			print(target .. "has got a summon");
		end
		if (assignments[target]) then
			if(debugEnabled) then
				print("clearing the assignment of summoning " .. target);
			end
			assignments[target] = nil;
		end
		local contains = IRT_Contains(needAssist, target);
		if (contains) then
			if(debugEnabled) then
				print("does not need summon any assist anymore");
			end
			table.remove(needAssist, contains);
		end
		if (myTarget == target) then
			if(debugEnabled) then
				print("reseting my assignment");
			end
			myTarget = nil;
			available = true;
			updateGlow(false);
			IRT_PopupHide("SUMMONING");
			if (timer) then
				timer:Cancel();
				timer = nil;
				updateGlow(false);
			end
			local nextTarget = next(awaitingSummons);
			local nextAssist = next(needAssist);
			if (nextAssist) then
				if(debugEnabled) then
					print("going to volunteer to assist to summon " .. nextAssist);
				end
				volunteer(needAssist[1]);
			elseif (nextTarget) then
				if(debugEnabled) then
					print("going to volunteer to summon " .. nextTarget);
				end
				volunteer(awaitingSummons[1]);
			end
		end
	elseif (event == "CHAT_MSG_ADDON" and IRT_SummonEnabled) then
		local prefix, msg, channel, sender = ...;
		sender = Ambiguate(sender, "none");
		if (prefix == "IRT_SUM") then
			if (msg == "!skip") then
				if(debugEnabled) then
					print(sender .. " wants their summon skipped");
				end
				skipSummon(sender);
			else
				if (UnitIsConnected(msg)) then
					local containsAwaiting = IRT_Contains(awaitingSummons, msg);
					local containsAssist = IRT_Contains(needAssist, msg);
					if (containsAwaiting) then
						if(debugEnabled) then
							print(msg .. " wants a summon and is in the list, assigning " .. sender .. " to summon them");
						end
						table.remove(awaitingSummons, containsAwaiting);
						table.insert(needAssist, msg);
						assignments[msg] = Ambiguate(sender, "none");
						if (UnitIsUnit(sender, playerName)) then
							if(debugEnabled) then
								print("now assigned to summon " .. msg .. " therefore becoming unavailable");
							end
							available = false;
							summonPlayer(msg, false);
						end
					elseif (containsAssist) then
						if(debugEnabled) then
							print(msg .. " wants a summon and is in the list, assigning " .. sender .. " to assist in summoning them");
						end
						table.remove(needAssist, containsAssist);
						if (UnitIsUnit(sender, playerName)) then
							if(debugEnabled) then
								print("now assigned to assist in summoning " .. msg .. " therefore becoming unavailable");
							end
							available = false;
							summonPlayer(msg, true);
						end
					end
				end
			end
		end
	elseif ((event == "CHAT_MSG_RAID" or event == "CHAT_MSG_RAID_LEADER") and IRT_SummonEnabled) then
		local msg, sender = ...;
		sender = Ambiguate(sender, "none");
		if (msg == "!irtsum") then
			if(debugEnabled) then
				print("irt sum was started");
			end
			init();
		elseif (msg == "123" or msg:match("sum pls") or msg:match("summon pls") or msg == "1") then
			if(debugEnabled) then
				print(sender .. " wants a summon");
			end
			if (not IRT_Contains(awaitingSummons, sender)) then
				if(debugEnabled) then
					print(sender .. " was not waiting for summon before adding to list and trying to volunteer");
				end
				table.insert(awaitingSummons, sender);
				volunteer(sender);
			end
		end
	elseif (event == "GROUP_ROSTER_UPDATE" and IRT_SummonEnabled) then
		if (IsInRaid()) then
			local zone = GetRealZoneText();
			if (myTarget == nil and IRT_Contains(raids, zone)) then
				if(debugEnabled) then
					print("in a raid group, dont have a target and in a raid instance, now marked as available");
				end
				available = true;
			end
			for i = 1, #awaitingSummons do
				if (not UnitInRaid(awaitingSummons[i])) then
					if(debugEnabled) then
						print(awaitingSummons[i] .. " is not in the raid group anymore, removing from list");
					end
					skipSummon(awaitingSummons[i]);
				end
			end
			if(debugEnabled) then
				print("calling to update raid frames");
			end
			updateRaid();
			if (available and next(awaitingSummons) ~= nil) then
				if(debugEnabled) then
					print("available and there are players that needs summon, trying to volunteer to summon " .. awaitingSummons[1]);
				end
				volunteer(awaitingSummons[1]);
			end
		end
	elseif (event == "ZONE_CHANGED_NEW_AREA" and IRT_SummonEnabled) then
		local zone = GetRealZoneText();
		if (IRT_Contains(raids, zone)) then
			available = true;
			if(debugEnabled) then
				print("I changed zone to " .. zone .. " and I am now available to summon");
			end
			if (IRT_Contains(awaitingSummons, Ambiguate(playerName, "none"))) then
				if(debugEnabled) then
					print("I no longer need a summon as I am in the raid");
				end
				local code = C_ChatInfo.SendAddonMessage("IRT_SUM", "!skip", "RAID");
				if (code ~= 0) then
					IRT_DebugMessage(L.ERROR_ADDON_MESSAGE_WHISPER .. IRT_GetAddonResultMessage(code), "debug", L.OPTIONS_SUMMON_TITLE);
				end
			end
		else
			if(debugEnabled) then
				print("I changed zone and I am now in " .. zone .. " which is not a raid zone, setting availability to false");
			end
			available = false;
		end
	end
end);