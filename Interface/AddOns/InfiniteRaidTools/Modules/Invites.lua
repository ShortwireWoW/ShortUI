local L = IRTLocals;
local f = CreateFrame("Frame");

f:RegisterEvent("PLAYER_LOGIN");

f:SetScript("OnEvent", function(self, event, ...)
	if (event == "PLAYER_LOGIN") then
		if (IRT_RaidInviteRanks == nil) then
			IRT_RaidInviteRanks = {};
		end
		for i = 1, GetNumGuildMembers() do
			local rank = select(2, GetGuildRosterInfo(i));
			if (IRT_RaidInviteRanks[rank] == nil) then
				IRT_RaidInviteRanks[rank] = false;
			end
		end
	elseif (event == "GROUP_ROSTER_UPDATE") then
		if (not IsInRaid()) then
			C_PartyInfo.ConvertToRaid();
		else
			f:UnregisterEvent("GROUP_ROSTER_UPDATE");
		end
	end
end);

function IRT_RaidInvite()
	if (C_GuildInfo.IsGuildOfficer()) then
		f:RegisterEvent("GROUP_ROSTER_UPDATE");
		SendChatMessage("IRT: Raid group is created and invites has been sent out!", "GUILD");
		for i = 1, GetNumGuildMembers() do
			local name, rank, _, _, _, _, _, _, online  = GetGuildRosterInfo(i);
			if (name and (IRT_RaidInviteRanks[rank]) and online and not UnitIsUnit(name, "player")) then
				C_PartyInfo.InviteUnit(name);
			end
		end
	else
		DEFAULT_CHAT_FRAME:AddMessage(L.RAIDINVITE_NOT_OFFICER, 1, 0, 0);
	end
end