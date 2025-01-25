local L = IRTLocals;

IRT_SikranOptions = CreateFrame("Frame");
IRT_SikranOptions:Hide();

local title = IRT_SikranOptions:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
title:SetPoint("TOP", 0, -16);
title:SetText(L.OPTIONS_TITLE);

local tabinfo = IRT_SikranOptions:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
tabinfo:SetPoint("TOPLEFT", 16, -16);
tabinfo:SetText(L.OPTIONS_SIKRAN_TITLE);

local author = IRT_SikranOptions:CreateFontString(nil, "ARTWORK", "GameFontNormal");
author:SetPoint("TOPLEFT", 450, -20);
author:SetText(L.OPTIONS_AUTHOR);

local version = IRT_SikranOptions:CreateFontString(nil, "ARTWORK", "GameFontNormal");
version:SetPoint("TOPLEFT", author, "BOTTOMLEFT", 0, -10);
version:SetText(L.OPTIONS_VERSION);

local difficultyText = IRT_SikranOptions:CreateFontString(nil, "ARTWORK", "GameFontNormal");
difficultyText:SetPoint("TOPLEFT", version, "BOTTOMLEFT", 0, -10);
difficultyText:SetText(L.OPTIONS_DIFFICULTY);

local heroicTexture = IRT_SikranOptions:CreateTexture(nil,"BACKGROUND");
heroicTexture:SetTexture("Interface\\EncounterJournal\\UI-EJ-Icons.png");
heroicTexture:SetWidth(32);
heroicTexture:SetHeight(32);
IRT_SetFlagIcon(heroicTexture, 3);
heroicTexture:SetPoint("TOPLEFT", difficultyText, "TOPLEFT", 60, 10);

local mythicTexture = IRT_SikranOptions:CreateTexture(nil,"BACKGROUND");
mythicTexture:SetTexture("Interface\\EncounterJournal\\UI-EJ-Icons.png");
mythicTexture:SetWidth(32);
mythicTexture:SetHeight(32);
IRT_SetFlagIcon(mythicTexture, 12);
mythicTexture:SetPoint("TOPLEFT", heroicTexture, "TOPLEFT", 20, 0);

local bossTexture = IRT_SikranOptions:CreateTexture(nil,"BACKGROUND");
bossTexture:SetTexture("Interface\\ENCOUNTERJOURNAL\\UI-EJ-BOSS-Sikran.PNG");
bossTexture:SetWidth(62);
bossTexture:SetHeight(68);
bossTexture:SetTexCoord(0,1,0,0.9);
bossTexture:SetPoint("TOPLEFT", 30, -43);

local bossBorder = IRT_SikranOptions:CreateTexture(nil,"BORDER");
bossBorder:SetTexture("Interface\\MINIMAP\\UI-MINIMAP-BORDER.PNG");
bossBorder:SetWidth(128);
bossBorder:SetHeight(128);
bossBorder:SetTexCoord(0,1,0.1,1);
bossBorder:SetPoint("TOPLEFT", -30, -35);

local infoBorder = IRT_SikranOptions:CreateTexture(nil, "BACKGROUND");
infoBorder:SetTexture("Interface\\GMChatFrame\\UI-GMStatusFrame-Pulse.PNG");
infoBorder:SetWidth(450);
infoBorder:SetHeight(250);
infoBorder:SetTexCoord(0.11,0.89,0.24,0.76);
infoBorder:SetPoint("TOP", 20, -85);

local info = IRT_SikranOptions:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
info:SetPoint("TOPLEFT", infoBorder, "TOPLEFT", 10, -8);
info:SetSize(430, 300);
info:SetText(L.OPTIONS_SIKRAN_INFO);
info:SetWordWrap(true);
info:SetJustifyH("LEFT");
info:SetJustifyV("TOP");

local enabledButton = CreateFrame("CheckButton", "IRT_SikranEnabledCheckButton", IRT_SikranOptions, "UICheckButtonTemplate");
enabledButton:SetSize(26, 26);
enabledButton:SetPoint("TOPLEFT", 60, -345);
enabledButton:HookScript("OnClick", function(self)
	if (self:GetChecked()) then
		IRT_SikranEnabled = true;
		PlaySound(856);
	else
		IRT_SikranEnabled = false;
		PlaySound(857);
	end
end);

local enabledText = IRT_SikranOptions:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
enabledText:SetPoint("TOPLEFT", enabledButton, "TOPLEFT", 30, -7);
enabledText:SetText(L.OPTIONS_ENABLED);

local infoTexture = IRT_SikranOptions:CreateTexture(nil, "BACKGROUND");
infoTexture:SetTexture("Interface\\addons\\InfiniteRaidTools\\Res\\YellOne.tga");
infoTexture:SetPoint("TOPLEFT", enabledButton, "TOP", 300, -100);
infoTexture:SetSize(40, 94);
infoTexture:SetTexCoord(0,0.6,0,0.74);

local infoTexture2 = IRT_SikranOptions:CreateTexture(nil, "BACKGROUND");
infoTexture2:SetTexture("Interface\\addons\\InfiniteRaidTools\\Res\\SikranList.tga");
infoTexture2:SetPoint("TOPLEFT", enabledButton, "TOP", 100, -100);
infoTexture2:SetSize(106, 89);
infoTexture2:SetTexCoord(0,0.84,0,0.72);

local previewText = IRT_SikranOptions:CreateFontString(nil, "ARTWORK", "GameFontNormal");
previewText:SetPoint("TOP", enabledButton, "TOP", 225, -80);
previewText:SetText(L.OPTIONS_SIKRAN_PREVIEW);
previewText:SetJustifyH("CENTER");
previewText:SetJustifyV("TOP");
previewText:SetSize(570,25);
previewText:SetWordWrap(true);

local RPAFEnabledButton = CreateFrame("CheckButton", "IRT_SikranRPAFEnabledCheckButton", IRT_SikranOptions, "UICheckButtonTemplate");
RPAFEnabledButton:SetSize(26, 26);
RPAFEnabledButton:SetPoint("TOPLEFT", 60, -375);
RPAFEnabledButton:HookScript("OnClick", function(self)
	if (self:GetChecked()) then
		IRT_RPAFEnabled[2898] = true;
		PlaySound(856);
	else
		IRT_RPAFEnabled[2898] = false;
		PlaySound(857);
	end
end);

local RPAFEnabledText = IRT_SikranOptions:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
RPAFEnabledText:SetPoint("TOPLEFT", RPAFEnabledButton, "TOPLEFT", 30, -7);
RPAFEnabledText:SetText(L.OPTIONS_RPAF_ENABLED);

local togglePriorityListButton = CreateFrame("Button", nil, IRT_SikranOptions, "UIPanelButtonTemplate");
togglePriorityListButton:SetSize(200, 20);
togglePriorityListButton:SetPoint("BOTTOM", 0, 10);
togglePriorityListButton:SetText(L.OPTIONS_RPAF_PRIORITY);
togglePriorityListButton:HookScript("OnClick", function(frame)
	IRT_OpenPriorityList(2898);
end);


IRT_SikranOptions:SetScript("OnShow", function(self)
	enabledButton:SetChecked(IRT_SikranEnabled);
	RPAFEnabledButton:SetChecked(IRT_RPAFEnabled[2898]);
end);

local subcategoryNP = IRT_GetSubcategory("Nerub-ar Palace").subcategory;
if (subcategoryNP ~= nil) then
	local subcategoryTO, layout = Settings.RegisterCanvasLayoutSubcategory(subcategoryNP, IRT_SikranOptions, L.OPTIONS_SIKRAN_TITLE);
	IRT_AddSubcategory(L.OPTIONS_SIKRAN_TITLE, subcategoryTO, layout);
end