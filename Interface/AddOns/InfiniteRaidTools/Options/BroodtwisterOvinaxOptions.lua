local L = IRTLocals;

IRT_BroodtwisterOptions = CreateFrame("Frame");
IRT_BroodtwisterOptions:Hide();

local title = IRT_BroodtwisterOptions:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
title:SetPoint("TOP", 0, -16);
title:SetText(L.OPTIONS_TITLE);

local tabinfo = IRT_BroodtwisterOptions:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
tabinfo:SetPoint("TOPLEFT", 16, -16);
tabinfo:SetText(L.OPTIONS_BROODTWISTER_TITLE);

local author = IRT_BroodtwisterOptions:CreateFontString(nil, "ARTWORK", "GameFontNormal");
author:SetPoint("TOPLEFT", 450, -20);
author:SetText(L.OPTIONS_AUTHOR);

local version = IRT_BroodtwisterOptions:CreateFontString(nil, "ARTWORK", "GameFontNormal");
version:SetPoint("TOPLEFT", author, "BOTTOMLEFT", 0, -10);
version:SetText(L.OPTIONS_VERSION);

local difficultyText = IRT_BroodtwisterOptions:CreateFontString(nil, "ARTWORK", "GameFontNormal");
difficultyText:SetPoint("TOPLEFT", version, "BOTTOMLEFT", 0, -10);
difficultyText:SetText(L.OPTIONS_DIFFICULTY);

local heroicTexture = IRT_BroodtwisterOptions:CreateTexture(nil,"BACKGROUND");
heroicTexture:SetTexture("Interface\\EncounterJournal\\UI-EJ-Icons.png");
heroicTexture:SetWidth(32);
heroicTexture:SetHeight(32);
IRT_SetFlagIcon(heroicTexture, 3);
heroicTexture:SetPoint("TOPLEFT", difficultyText, "TOPLEFT", 60, 10);

local mythicTexture = IRT_BroodtwisterOptions:CreateTexture(nil,"BACKGROUND");
mythicTexture:SetTexture("Interface\\EncounterJournal\\UI-EJ-Icons.png");
mythicTexture:SetWidth(32);
mythicTexture:SetHeight(32);
IRT_SetFlagIcon(mythicTexture, 12);
mythicTexture:SetPoint("TOPLEFT", heroicTexture, "TOPLEFT", 20, 0);

local bossTexture = IRT_BroodtwisterOptions:CreateTexture(nil,"BACKGROUND");
bossTexture:SetTexture("Interface\\ENCOUNTERJOURNAL\\UI-EJ-BOSS-Broodtwister Ovinax.PNG");
bossTexture:SetWidth(62);
bossTexture:SetHeight(68);
bossTexture:SetTexCoord(0,1,0,0.9);
bossTexture:SetPoint("TOPLEFT", 30, -43);

local bossBorder = IRT_BroodtwisterOptions:CreateTexture(nil,"BORDER");
bossBorder:SetTexture("Interface\\MINIMAP\\UI-MINIMAP-BORDER.PNG");
bossBorder:SetWidth(128);
bossBorder:SetHeight(128);
bossBorder:SetTexCoord(0,1,0.1,1);
bossBorder:SetPoint("TOPLEFT", -30, -35);

local infoBorder = IRT_BroodtwisterOptions:CreateTexture(nil, "BACKGROUND");
infoBorder:SetTexture("Interface\\GMChatFrame\\UI-GMStatusFrame-Pulse.PNG");
infoBorder:SetWidth(450);
infoBorder:SetHeight(250);
infoBorder:SetTexCoord(0.11,0.89,0.24,0.76);
infoBorder:SetPoint("TOP", 20, -85);

local info = IRT_BroodtwisterOptions:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
info:SetPoint("TOPLEFT", infoBorder, "TOPLEFT", 10, -8);
info:SetSize(430, 300);
info:SetText(L.OPTIONS_BROODTWISTER_INFO);
info:SetWordWrap(true);
info:SetJustifyH("LEFT");
info:SetJustifyV("TOP");

local enabledButton = CreateFrame("CheckButton", "IRT_BroodtwisterEnabledCheckButton", IRT_BroodtwisterOptions, "UICheckButtonTemplate");
enabledButton:SetSize(26, 26);
enabledButton:SetPoint("TOPLEFT", 60, -345);
enabledButton:HookScript("OnClick", function(self)
	if (self:GetChecked()) then
		IRT_BroodtwisterEnabled = true;
		PlaySound(856);
	else
		IRT_BroodtwisterEnabled = false;
		PlaySound(857);
	end
end);

local enabledText = IRT_BroodtwisterOptions:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
enabledText:SetPoint("TOPLEFT", enabledButton, "TOPLEFT", 30, -7);
enabledText:SetText(L.OPTIONS_ENABLED);

local extrasEnabled = CreateFrame("CheckButton", "IRT_BroodtwisterExtrasCheckButton", IRT_BroodtwisterOptions, "UICheckButtonTemplate");
extrasEnabled:SetSize(26, 26);
extrasEnabled:SetPoint("TOPLEFT", enabledButton, "TOPLEFT", 0, -30);
extrasEnabled:HookScript("OnClick", function(self)
	if (self:GetChecked()) then
		IRT_BroodtwisterExtras = true;
		PlaySound(856);
	else
		IRT_BroodtwisterExtras = false;
		PlaySound(857);
	end
end);

local extrasText = IRT_BroodtwisterOptions:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
extrasText:SetPoint("TOPLEFT", extrasEnabled, "TOPLEFT", 30, -7);
extrasText:SetText(L.OPTIONS_BROODTWISTER_EXTRAS);

local infoTexture = IRT_BroodtwisterOptions:CreateTexture(nil, "BACKGROUND");
infoTexture:SetTexture("Interface\\addons\\InfiniteRaidTools\\Res\\Dispel.tga");
infoTexture:SetPoint("TOPLEFT", enabledButton, "TOP", 0, -120);
infoTexture:SetSize(256, 30);
infoTexture:SetTexCoord(0,1,0,0.7);

local infoTexture2 = IRT_BroodtwisterOptions:CreateTexture(nil, "BACKGROUND");
infoTexture2:SetTexture("Interface\\addons\\InfiniteRaidTools\\Res\\Volcoross2.tga");
infoTexture2:SetPoint("TOPLEFT", infoTexture, "TOPLEFT", 330, 0);
infoTexture2:SetSize(168, 118);
infoTexture2:SetTexCoord(0,0.66,0,0.89);

local starTexture3 = IRT_BroodtwisterOptions:CreateTexture(nil, "BACKGROUND");
starTexture3:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcon_1");
starTexture3:SetPoint("TOPLEFT", infoTexture2, "TOPLEFT", -20, 1);
starTexture3:SetSize(20, 20);

local starTexture4 = IRT_BroodtwisterOptions:CreateTexture(nil, "BACKGROUND");
starTexture4:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcon_1");
starTexture4:SetPoint("TOPLEFT", infoTexture2, "TOPRIGHT", 1, 1);
starTexture4:SetSize(20, 20);

local previewText = IRT_BroodtwisterOptions:CreateFontString(nil, "ARTWORK", "GameFontNormal");
previewText:SetPoint("TOP", enabledButton, "TOP", 225, -80);
previewText:SetText(L.OPTIONS_BROODTWISTER_PREVIEW);
previewText:SetJustifyH("CENTER");
previewText:SetJustifyV("TOP");
previewText:SetSize(570,25);
previewText:SetWordWrap(true);

IRT_BroodtwisterOptions:SetScript("OnShow", function(self)
	enabledButton:SetChecked(IRT_BroodtwisterEnabled);
	extrasEnabled:SetChecked(IRT_BroodtwisterExtras);
end);

local subcategoryNP = IRT_GetSubcategory("Nerub-ar Palace").subcategory;
if (subcategoryNP ~= nil) then
	local subcategoryTO, layout = Settings.RegisterCanvasLayoutSubcategory(subcategoryNP, IRT_BroodtwisterOptions, L.OPTIONS_BROODTWISTER_TITLE);
	IRT_AddSubcategory(L.OPTIONS_BROODTWISTER_TITLE, subcategoryTO, layout);
end