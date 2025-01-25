local L = IRTLocals;

IRT_NexusPrincessOptions = CreateFrame("Frame");
IRT_NexusPrincessOptions:Hide();

local title = IRT_NexusPrincessOptions:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
title:SetPoint("TOP", 0, -16);
title:SetText(L.OPTIONS_TITLE);

local tabinfo = IRT_NexusPrincessOptions:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
tabinfo:SetPoint("TOPLEFT", 16, -16);
tabinfo:SetText(L.OPTIONS_NEXUSPRINCESS_TITLE);

local author = IRT_NexusPrincessOptions:CreateFontString(nil, "ARTWORK", "GameFontNormal");
author:SetPoint("TOPLEFT", 450, -20);
author:SetText(L.OPTIONS_AUTHOR);

local version = IRT_NexusPrincessOptions:CreateFontString(nil, "ARTWORK", "GameFontNormal");
version:SetPoint("TOPLEFT", author, "BOTTOMLEFT", 0, -10);
version:SetText(L.OPTIONS_VERSION);

local difficultyText = IRT_NexusPrincessOptions:CreateFontString(nil, "ARTWORK", "GameFontNormal");
difficultyText:SetPoint("TOPLEFT", version, "BOTTOMLEFT", 0, -10);
difficultyText:SetText(L.OPTIONS_DIFFICULTY);

local heroicTexture = IRT_NexusPrincessOptions:CreateTexture(nil,"BACKGROUND");
heroicTexture:SetTexture("Interface\\EncounterJournal\\UI-EJ-Icons.png");
heroicTexture:SetWidth(32);
heroicTexture:SetHeight(32);
IRT_SetFlagIcon(heroicTexture, 3);
heroicTexture:SetPoint("TOPLEFT", difficultyText, "TOPLEFT", 60, 10);

local mythicTexture = IRT_NexusPrincessOptions:CreateTexture(nil,"BACKGROUND");
mythicTexture:SetTexture("Interface\\EncounterJournal\\UI-EJ-Icons.png");
mythicTexture:SetWidth(32);
mythicTexture:SetHeight(32);
IRT_SetFlagIcon(mythicTexture, 12);
mythicTexture:SetPoint("TOPLEFT", heroicTexture, "TOPLEFT", 20, 0);

local bossTexture = IRT_NexusPrincessOptions:CreateTexture(nil,"BACKGROUND");
bossTexture:SetTexture("Interface\\ENCOUNTERJOURNAL\\UI-EJ-BOSS-Kyveza.PNG");
bossTexture:SetWidth(62);
bossTexture:SetHeight(68);
bossTexture:SetTexCoord(0,1,0,0.9);
bossTexture:SetPoint("TOPLEFT", 30, -43);

local bossBorder = IRT_NexusPrincessOptions:CreateTexture(nil,"BORDER");
bossBorder:SetTexture("Interface\\MINIMAP\\UI-MINIMAP-BORDER.PNG");
bossBorder:SetWidth(128);
bossBorder:SetHeight(128);
bossBorder:SetTexCoord(0,1,0.1,1);
bossBorder:SetPoint("TOPLEFT", -30, -35);

local infoBorder = IRT_NexusPrincessOptions:CreateTexture(nil, "BACKGROUND");
infoBorder:SetTexture("Interface\\GMChatFrame\\UI-GMStatusFrame-Pulse.PNG");
infoBorder:SetWidth(450);
infoBorder:SetHeight(250);
infoBorder:SetTexCoord(0.11,0.89,0.24,0.76);
infoBorder:SetPoint("TOP", 20, -85);

local info = IRT_NexusPrincessOptions:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
info:SetPoint("TOPLEFT", infoBorder, "TOPLEFT", 10, -8);
info:SetSize(430, 300);
info:SetText(L.OPTIONS_NEXUSPRINCESS_INFO);
info:SetWordWrap(true);
info:SetJustifyH("LEFT");
info:SetJustifyV("TOP");

local enabledButton = CreateFrame("CheckButton", "IRT_NexusPrincessEnabledCheckButton", IRT_NexusPrincessOptions, "UICheckButtonTemplate");
enabledButton:SetSize(26, 26);
enabledButton:SetPoint("TOPLEFT", 60, -345);
enabledButton:HookScript("OnClick", function(self)
	if (self:GetChecked()) then
		IRT_NexusPrincessEnabled = true;
		PlaySound(856);
	else
		IRT_NexusPrincessEnabled = false;
		PlaySound(857);
	end
end);

local enabledText = IRT_NexusPrincessOptions:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
enabledText:SetPoint("TOPLEFT", enabledButton, "TOPLEFT", 30, -7);
enabledText:SetText(L.OPTIONS_ENABLED);

local infoTexture = IRT_NexusPrincessOptions:CreateTexture(nil, "BACKGROUND");
infoTexture:SetTexture("Interface\\addons\\InfiniteRaidTools\\Res\\YellStar.tga");
infoTexture:SetPoint("TOPLEFT", enabledButton, "TOP", 200, -100);
infoTexture:SetSize(40, 94);
infoTexture:SetTexCoord(0,0.6,0,0.74);

local previewText = IRT_NexusPrincessOptions:CreateFontString(nil, "ARTWORK", "GameFontNormal");
previewText:SetPoint("TOP", enabledButton, "TOP", 225, -80);
previewText:SetText(L.OPTIONS_NEXUSPRINCESS_PREVIEW);
previewText:SetJustifyH("CENTER");
previewText:SetJustifyV("TOP");
previewText:SetSize(570,25);
previewText:SetWordWrap(true);

local RPAFEnabledButton = CreateFrame("CheckButton", "IRT_NexusPrincessRPAFEnabledCheckButton", IRT_NexusPrincessOptions, "UICheckButtonTemplate");
RPAFEnabledButton:SetSize(26, 26);
RPAFEnabledButton:SetPoint("TOPLEFT", 60, -375);
RPAFEnabledButton:HookScript("OnClick", function(self)
	if (self:GetChecked()) then
		IRT_RPAFEnabled[2920] = true;
		PlaySound(856);
	else
		IRT_RPAFEnabled[2920] = false;
		PlaySound(857);
	end
end);

local RPAFEnabledText = IRT_NexusPrincessOptions:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
RPAFEnabledText:SetPoint("TOPLEFT", RPAFEnabledButton, "TOPLEFT", 30, -7);
RPAFEnabledText:SetText(L.OPTIONS_RPAF_ENABLED);

local togglePriorityListButton = CreateFrame("Button", nil, IRT_NexusPrincessOptions, "UIPanelButtonTemplate");
togglePriorityListButton:SetSize(200, 20);
togglePriorityListButton:SetPoint("BOTTOM", 0, 10);
togglePriorityListButton:SetText(L.OPTIONS_RPAF_PRIORITY);
togglePriorityListButton:HookScript("OnClick", function(frame)
	IRT_OpenPriorityList(2920);
end);


IRT_NexusPrincessOptions:SetScript("OnShow", function(self)
	enabledButton:SetChecked(IRT_NexusPrincessEnabled);
    RPAFEnabledButton:SetChecked(IRT_RPAFEnabled[2920]);
end);

local subcategoryNP = IRT_GetSubcategory("Nerub-ar Palace").subcategory;
if (subcategoryNP ~= nil) then
	local subcategoryTO, layout = Settings.RegisterCanvasLayoutSubcategory(subcategoryNP, IRT_NexusPrincessOptions, L.OPTIONS_NEXUSPRINCESS_TITLE);
	IRT_AddSubcategory(L.OPTIONS_NEXUSPRINCESS_TITLE, subcategoryTO, layout);
end