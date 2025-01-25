local L = IRTLocals;

IRT_InvitesOptions = CreateFrame("Frame");
IRT_InvitesOptions:Hide();

local title = IRT_InvitesOptions:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
title:SetPoint("TOP", 0, -16);
title:SetText(L.OPTIONS_TITLE);

local tabinfo = IRT_InvitesOptions:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
tabinfo:SetPoint("TOPLEFT", 16, -16);
tabinfo:SetText(L.OPTIONS_INVITES_TITLE);

local author = IRT_InvitesOptions:CreateFontString(nil, "ARTWORK", "GameFontNormal");
author:SetPoint("TOPLEFT", 450, -20);
author:SetText(L.OPTIONS_AUTHOR);

local version = IRT_InvitesOptions:CreateFontString(nil, "ARTWORK", "GameFontNormal");
version:SetPoint("TOPLEFT", author, "BOTTOMLEFT", 0, -10);
version:SetText(L.OPTIONS_VERSION);

local infoBorder = IRT_InvitesOptions:CreateTexture(nil, "BACKGROUND");
infoBorder:SetTexture("Interface\\GMChatFrame\\UI-GMStatusFrame-Pulse.PNG");
infoBorder:SetWidth(530);
infoBorder:SetHeight(120);
infoBorder:SetTexCoord(0.11,0.89,0.24,0.76);
infoBorder:SetPoint("TOP", 0, -85);

local info = IRT_InvitesOptions:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
info:SetPoint("TOPLEFT", infoBorder, "TOPLEFT", 10, -25);
info:SetSize(510, 200);
info:SetText(L.OPTIONS_INVITES_INFO);
info:SetWordWrap(true);
info:SetJustifyV("TOP");

local rankFrames = nil;

local function updateRankFrames()
	for index, frame in pairs(rankFrames) do
		frame:Show();
		local frameName = frame:GetName();
		if (string.find(frameName, "IRT_GuildRank_Checkbox_")) then
			frameName = string.sub(frameName, 23);
			if (IRT_RaidInviteRanks[frameName]) then
				frame:SetChecked(true);
			else
				frame:SetChecked(false);
			end
		end
	end
end

local inviteButton = CreateFrame("CheckButton", "IRT_InviteButton", IRT_InvitesOptions, "UIPanelButtonTemplate");
inviteButton:SetSize(200, 35);
inviteButton:SetPoint("TOPLEFT", 30, -215);
inviteButton:SetText("Raid Invite");
inviteButton:HookScript("OnClick", function(self)
	IRT_RaidInvite();
end);

local infoTexture = IRT_InvitesOptions:CreateTexture(nil, "BACKGROUND");
infoTexture:SetTexture("Interface\\addons\\InfiniteRaidTools\\Res\\Invites.tga");
infoTexture:SetPoint("TOPLEFT", inviteButton, "TOP", 100, -70);
infoTexture:SetSize(256, 16);
infoTexture:SetTexCoord(0,0.95,0,0.59);


IRT_InvitesOptions:SetScript("OnShow", function()
	if (rankFrames == nil) then
		local count = 1;
		rankFrames = {};
		for rank, enabled in pairs (IRT_RaidInviteRanks) do
			local text = IRT_InvitesOptions:CreateFontString("IRT_GuildRank_Text_" .. rank, "ARTWORK", "GameFontWhite");
			text:SetText(rank);
			text:SetPoint("TOPLEFT", 60+((count+1)%2*150), -250-(math.floor((count-1)/2))*25);
			table.insert(rankFrames, text);
			local checkButton = CreateFrame("CheckButton", "IRT_GuildRank_CheckBox_" .. rank, IRT_InvitesOptions, "UICheckButtonTemplate");
			checkButton:SetSize(20, 20);
			checkButton:SetChecked(enabled);
			checkButton:SetPoint("TOPLEFT", 150+((count+1)%2*150), -250-(math.floor((count-1)/2))*25);
			checkButton:SetScript("OnClick", function(self)
				local checked = self:GetChecked();
				if (checked) then
					IRT_RaidInviteRanks[rank] = true;
				elseif (not checked) then
					IRT_RaidInviteRanks[rank] = false;
				end
			end);
			table.insert(rankFrames, checkButton);
			count = count + 1;
		end
	else
		updateRankFrames();
	end
	inviteButton:ClearAllPoints();
	inviteButton:SetPoint("BOTTOMLEFT", rankFrames[1], "BOTTOMLEFT", 0, -(math.floor((#rankFrames-1)/2)*25));
end);

local subcategoryGM = IRT_GetSubcategory("General Modules").subcategory;
if (subcategoryGM ~= nil) then
	local subcategoryIO, layout = Settings.RegisterCanvasLayoutSubcategory(subcategoryGM, IRT_InvitesOptions, L.OPTIONS_INVITES_TITLE);
end