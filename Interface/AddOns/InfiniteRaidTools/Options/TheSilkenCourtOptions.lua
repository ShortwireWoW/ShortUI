local L = IRTLocals;
local tGUI = nil;

IRT_SilkenCourtOptions = CreateFrame("Frame");
IRT_SilkenCourtOptions:Hide();

local title = IRT_SilkenCourtOptions:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
title:SetPoint("TOP", 0, -16);
title:SetText(L.OPTIONS_TITLE);

local tabinfo = IRT_SilkenCourtOptions:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
tabinfo:SetPoint("TOPLEFT", 16, -16);
tabinfo:SetText(L.OPTIONS_SILKENCOURT_TITLE);

local author = IRT_SilkenCourtOptions:CreateFontString(nil, "ARTWORK", "GameFontNormal");
author:SetPoint("TOPLEFT", 450, -20);
author:SetText(L.OPTIONS_AUTHOR);

local version = IRT_SilkenCourtOptions:CreateFontString(nil, "ARTWORK", "GameFontNormal");
version:SetPoint("TOPLEFT", author, "BOTTOMLEFT", 0, -10);
version:SetText(L.OPTIONS_VERSION);

local difficultyText = IRT_SilkenCourtOptions:CreateFontString(nil, "ARTWORK", "GameFontNormal");
difficultyText:SetPoint("TOPLEFT", version, "BOTTOMLEFT", 0, -10);
difficultyText:SetText(L.OPTIONS_DIFFICULTY);

local heroicTexture = IRT_SilkenCourtOptions:CreateTexture(nil,"BACKGROUND");
heroicTexture:SetTexture("Interface\\EncounterJournal\\UI-EJ-Icons.png");
heroicTexture:SetWidth(32);
heroicTexture:SetHeight(32);
IRT_SetFlagIcon(heroicTexture, 3);
heroicTexture:SetPoint("TOPLEFT", difficultyText, "TOPLEFT", 60, 10);

local mythicTexture = IRT_SilkenCourtOptions:CreateTexture(nil,"BACKGROUND");
mythicTexture:SetTexture("Interface\\EncounterJournal\\UI-EJ-Icons.png");
mythicTexture:SetWidth(32);
mythicTexture:SetHeight(32);
IRT_SetFlagIcon(mythicTexture, 12);
mythicTexture:SetPoint("TOPLEFT", heroicTexture, "TOPLEFT", 20, 0);

local bossTexture = IRT_SilkenCourtOptions:CreateTexture(nil,"BACKGROUND");
bossTexture:SetTexture("Interface\\ENCOUNTERJOURNAL\\UI-EJ-BOSS-The Silken Court.PNG");
bossTexture:SetWidth(62);
bossTexture:SetHeight(68);
bossTexture:SetTexCoord(0,1,0,0.9);
bossTexture:SetPoint("TOPLEFT", 30, -43);

local bossBorder = IRT_SilkenCourtOptions:CreateTexture(nil,"BORDER");
bossBorder:SetTexture("Interface\\MINIMAP\\UI-MINIMAP-BORDER.PNG");
bossBorder:SetWidth(128);
bossBorder:SetHeight(128);
bossBorder:SetTexCoord(0,1,0.1,1);
bossBorder:SetPoint("TOPLEFT", -30, -35);

local infoBorder = IRT_SilkenCourtOptions:CreateTexture(nil, "BACKGROUND");
infoBorder:SetTexture("Interface\\GMChatFrame\\UI-GMStatusFrame-Pulse.PNG");
infoBorder:SetWidth(450);
infoBorder:SetHeight(250);
infoBorder:SetTexCoord(0.11,0.89,0.24,0.76);
infoBorder:SetPoint("TOP", 20, -85);

local info = IRT_SilkenCourtOptions:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
info:SetPoint("TOPLEFT", infoBorder, "TOPLEFT", 10, -8);
info:SetSize(430, 300);
info:SetText(L.OPTIONS_SILKENCOURT_INFO);
info:SetWordWrap(true);
info:SetJustifyH("LEFT");
info:SetJustifyV("TOP");

local enabledButton = CreateFrame("CheckButton", "IRT_SilkenCourtEnabledCheckButton", IRT_SilkenCourtOptions, "UICheckButtonTemplate");
enabledButton:SetSize(26, 26);
enabledButton:SetPoint("TOPLEFT", 60, -345);
enabledButton:HookScript("OnClick", function(self)
	if (self:GetChecked()) then
		IRT_SilkenCourtEnabled = true;
		PlaySound(856);
	else
		IRT_SilkenCourtEnabled = false;
		PlaySound(857);
	end
end);

local enabledText = IRT_SilkenCourtOptions:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
enabledText:SetPoint("TOPLEFT", enabledButton, "TOPLEFT", 30, -7);
enabledText:SetText(L.OPTIONS_ENABLED);

local trackedPlayers = IRT_SilkenCourtOptions:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
trackedPlayers:SetPoint("TOPLEFT", enabledText, "TOPLEFT", 0, -50);
trackedPlayers:SetText(L.OPTIONS_SILKENCOURT_TRACKED);

local function createRow()
	local row = #tGUI+1;
	tGUI[row] = {};
	local editText = IRT_SilkenCourtOptions:CreateFontString(nil, "ARTWORK", "GameFontNormal");
	editText:SetText(row .. ":");
	if (row <= 5) then
		editText:SetPoint("TOPLEFT", trackedPlayers, "TOPLEFT", 0, -25-((row-1)*30));
	else
		editText:SetPoint("TOPLEFT", trackedPlayers, "TOPLEFT", 250, -25-((row-6)*30));
	end
	tGUI[row].editText = editText;
	local editBox = CreateFrame("EditBox", nil, IRT_SilkenCourtOptions, "InputBoxTemplate");
	editBox:SetPoint("TOPLEFT", editText, "TOPLEFT", 35, 7);
	editBox:SetAutoFocus(false);
	editBox:SetSize(200, 25);
	editBox:SetText("");
	editBox:SetScript("OnEscapePressed", function(self)
		self:SetText("");
		self:ClearFocus();
	end);
	editBox:SetScript("OnEnterPressed", function(self)
		local input = self:GetText();
		IRT_SilkenTracker[row] = input;
		tGUI[row].editBox:SetText(input);
		if (input == "") then
			IRT_SilkenTracker[row] = nil;
		end
		self:ClearFocus();
	end);
	editBox:SetScript("OnTextChanged", function(self)
		local input = self:GetText();
		if (input:find("%d")) then
			input = input:gsub("%d", "");
		end
		if (input ~= "") then
			IRT_SilkenTracker[row] = input;
		else
			IRT_SilkenTracker[row] = nil;
		end
		tGUI[row].editBox:SetText(input);
	end);
	tGUI[row].editBox = editBox;
end
--[[
	local infoTexture = IRT_SilkenCourtOptions:CreateTexture(nil, "BACKGROUND");
	infoTexture:SetTexture("Interface\\addons\\InfiniteRaidTools\\Res\\Smolderon.tga");
	infoTexture:SetPoint("TOPLEFT", enabledButton, "TOP", 200, -100);
	infoTexture:SetSize(64, 103);
	infoTexture:SetTexCoord(0,1,0,0.83);

	local previewText = IRT_SilkenCourtOptions:CreateFontString(nil, "ARTWORK", "GameFontNormal");
	previewText:SetPoint("TOP", enabledButton, "TOP", 225, -80);
	previewText:SetText(L.OPTIONS_SILKENCOURT_PREVIEW);
	previewText:SetJustifyH("CENTER");
	previewText:SetJustifyV("TOP");
	previewText:SetSize(570,25);
	previewText:SetWordWrap(true);
]]

local RPAFEnabledButton = CreateFrame("CheckButton", "IRT_SilkenCourtRPAFEnabledCheckButton", IRT_SilkenCourtOptions, "UICheckButtonTemplate");
RPAFEnabledButton:SetSize(26, 26);
RPAFEnabledButton:SetPoint("TOPLEFT", 60, -375);
RPAFEnabledButton:HookScript("OnClick", function(self)
	if (self:GetChecked()) then
		IRT_RPAFEnabled[2921] = true;
		PlaySound(856);
	else
		IRT_RPAFEnabled[2921] = false;
		PlaySound(857);
	end
end);

local RPAFEnabledText = IRT_SilkenCourtOptions:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
RPAFEnabledText:SetPoint("TOPLEFT", RPAFEnabledButton, "TOPLEFT", 30, -7);
RPAFEnabledText:SetText(L.OPTIONS_RPAF_ENABLED);

local togglePriorityListButton = CreateFrame("Button", nil, IRT_SilkenCourtOptions, "UIPanelButtonTemplate");
togglePriorityListButton:SetSize(200, 20);
togglePriorityListButton:SetPoint("BOTTOM", 0, 10);
togglePriorityListButton:SetText(L.OPTIONS_RPAF_PRIORITY);
togglePriorityListButton:HookScript("OnClick", function(frame)
	IRT_OpenPriorityList(2921);
end);

IRT_SilkenCourtOptions:SetScript("OnShow", function(self)
	if (tGUI == nil) then
		tGUI = {};
		for i=1, 10 do
			createRow();
		end
	end
	for i = 1, 10 do
		if (IRT_SilkenTracker[i]) then
			local name = IRT_SilkenTracker[i];
			tGUI[i].editBox:SetText(name);
		else
			tGUI[i].editBox:SetText("");
		end
	end
	enabledButton:SetChecked(IRT_SilkenCourtEnabled);
	RPAFEnabledButton:SetChecked(IRT_RPAFEnabled[2921]);
end);



local subcategoryNP = IRT_GetSubcategory("Nerub-ar Palace").subcategory;
if (subcategoryNP ~= nil) then
	local subcategoryTO, layout = Settings.RegisterCanvasLayoutSubcategory(subcategoryNP, IRT_SilkenCourtOptions, L.OPTIONS_SILKENCOURT_TITLE);
	IRT_AddSubcategory(L.OPTIONS_SILKENCOURT_TITLE, subcategoryTO, layout);
end