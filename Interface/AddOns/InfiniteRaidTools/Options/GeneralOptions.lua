local L = IRTLocals;

IRT_GeneralOptions = CreateFrame("Frame");
IRT_GeneralOptions:Hide();

local subcategoryGM = IRT_GetSubcategory("General Modules").subcategory;
if (subcategoryGM ~= nil) then
	local subcategoryGO, layout = Settings.RegisterCanvasLayoutSubcategory(subcategoryGM, IRT_GeneralOptions, L.OPTIONS_GENERAL_TITLE);
	IRT_AddSubcategory(L.OPTIONS_GENERAL_TITLE, subcategoryGO, layout);
end

local title = IRT_GeneralOptions:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
title:SetPoint("TOP", 0, -16);
title:SetText(L.OPTIONS_TITLE);

local tabinfo = IRT_GeneralOptions:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
tabinfo:SetPoint("TOPLEFT", 16, -16);
tabinfo:SetText(L.OPTIONS_GENERAL_TITLE);

local author = IRT_GeneralOptions:CreateFontString(nil, "ARTWORK", "GameFontNormal");
author:SetPoint("TOPLEFT", 450, -20);
author:SetText(L.OPTIONS_AUTHOR);

local version = IRT_GeneralOptions:CreateFontString(nil, "ARTWORK", "GameFontNormal");
version:SetPoint("TOPLEFT", author, "BOTTOMLEFT", 0, -10);
version:SetText(L.OPTIONS_VERSION);

local infoBorder = IRT_GeneralOptions:CreateTexture(nil, "BACKGROUND");
infoBorder:SetTexture("Interface\\GMChatFrame\\UI-GMStatusFrame-Pulse.PNG");
infoBorder:SetWidth(530);
infoBorder:SetHeight(120);
infoBorder:SetTexCoord(0.11,0.89,0.24,0.76);
infoBorder:SetPoint("TOP", 0, -85);

local info = IRT_GeneralOptions:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
info:SetPoint("TOPLEFT", infoBorder, "TOPLEFT", 10, -25);
info:SetSize(510, 200);
info:SetText(L.OPTIONS_GENERAL_INFO);
info:SetWordWrap(true);
info:SetJustifyV("TOP");

local fontOptionsText = IRT_GeneralOptions:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
fontOptionsText:SetPoint("TOPLEFT", 30, -230);
fontOptionsText:SetText(L.OPTIONS_POPUPSETTINGS_TEXT);

local fontText = IRT_GeneralOptions:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
fontText:SetPoint("TOPLEFT", fontOptionsText, "TOPLEFT", 0, -25);
fontText:SetText(L.OPTIONS_FONTSIZE_TEXT);

local fontSizeText = IRT_GeneralOptions:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
fontSizeText:SetPoint("TOPLEFT", fontText, "TOPLEFT", 65, -27);

local fontSlider = CreateFrame("Slider", "IRT_FontSlider", IRT_GeneralOptions, "OptionsSliderTemplate");
fontSlider:SetPoint("TOPLEFT", fontText, "TOPLEFT", 0, -10);
fontSlider:SetMinMaxValues(15, 80);
fontSlider:SetValueStep(1);
IRT_FontSliderLow:SetText(15);
IRT_FontSliderHigh:SetText(80);
fontSlider:SetScript("OnValueChanged", function(self)
	IRT_PopupTextFontSize = math.floor(fontSlider:GetValue());
	fontSizeText:SetText(IRT_PopupTextFontSize);
	IRT_PopupUpdateFontSize();
end);

local popupToggleButton = CreateFrame("Button", "IRT_PopupToggleButton", IRT_GeneralOptions, "UIPanelButtonTemplate");
popupToggleButton:SetSize(150, 35);
popupToggleButton:SetPoint("TOPLEFT", fontText, "TOPLEFT", 190, 0);
popupToggleButton:SetText(L.OPTIONS_FONTSLIDER_BUTTON_TEXT);
popupToggleButton:HookScript("OnClick", function(self)
	IRT_PopupMove();
end);

local infoBoxText = IRT_GeneralOptions:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
infoBoxText:SetPoint("TOPLEFT", fontText, "TOPLEFT", 0, -50);
infoBoxText:SetText(L.OPTIONS_INFOBOXSETTINGS_TEXT);

local infoBoxToggleButton = CreateFrame("Button", "IRT_InfoBoxToggleButton", IRT_GeneralOptions, "UIPanelButtonTemplate");
infoBoxToggleButton:SetSize(150, 35);
infoBoxToggleButton:SetPoint("TOPLEFT", infoBoxText, "TOPLEFT", 0, -25);
infoBoxToggleButton:SetText(L.OPTIONS_INFOBOX_BUTTON_TEXT);
infoBoxToggleButton:HookScript("OnClick", function(self)
	IRT_InfoBoxMove();
end);

local RPAFText = IRT_GeneralOptions:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
RPAFText:SetPoint("TOPLEFT", infoBoxText, "TOPLEFT", 0, -70);
RPAFText:SetText(L.OPTIONS_RPAFSETTINGS_TEXT);

local RPAFToggleButton = CreateFrame("Button", "IRT_RPAFToggleButton", IRT_GeneralOptions, "UIPanelButtonTemplate");
RPAFToggleButton:SetSize(160, 35);
RPAFToggleButton:SetPoint("TOPLEFT", RPAFText, "TOPLEFT", 0, -25);
RPAFToggleButton:SetText(L.OPTIONS_RPAF_BUTTON_TEXT);
RPAFToggleButton:HookScript("OnClick", function(self)
	IRT_RPAFMove();
end);

local layoutMenu = CreateFrame("DropdownButton", nil, IRT_GeneralOptions, "WowStyle1DropdownTemplate");
layoutMenu:SetPoint("LEFT", RPAFToggleButton, "RIGHT", 30, -2);
layoutMenu:SetWidth(130);
layoutMenu:SetupMenu(function(dropdown, rootDescription)
	rootDescription:CreateButton("VERTICAL", function()
		IRT_RPAFLayout = "VERTICAL";
		IRT_RPAFUpdateLayout();
	end);
	rootDescription:CreateButton("HORIZONTAL", function(self)
		IRT_RPAFLayout = "HORIZONTAL";
		IRT_RPAFUpdateLayout();
	end);
	rootDescription:CreateButton("LIST", function(self)
		IRT_RPAFLayout = "LIST";
		IRT_RPAFUpdateLayout();
	end);
end);
layoutMenu:SetSelectionText(function(selections)
	return IRT_RPAFLayout;
end);


local layoutText = IRT_GeneralOptions:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
layoutText:SetPoint("TOP", layoutMenu, "TOP", 0, 15);
layoutText:SetText(L.OPTIONS_RPAF_LAYOUT_TEXT);

local generalText = IRT_GeneralOptions:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
generalText:SetPoint("TOPLEFT", RPAFText, "TOPLEFT", 0, -70);
generalText:SetText(L.OPTIONS_GENERALSETTINGS_TEXT);

--[[ DEPRECATED

	local minimapModeText = IRT_GeneralOptions:CreateFontString(nil, "ARTWORK", "GameFontWhite");
	minimapModeText:SetText(L.OPTIONS_MINIMAP_MODE_TEXT);
	minimapModeText:SetPoint("TOPLEFT", generalText, "TOPLEFT", 0, -25);

	local minimapStateMenu = CreateFrame("Button", nil, IRT_GeneralOptions, "UIDropDownMenuTemplate");
	minimapStateMenu:SetPoint("TOPLEFT", minimapModeText, "TOPLEFT", 175, 8);

	local minimapStates = {"Always", "On Hover", "Never"};

	local function minimapState_OnClick(self)
		UIDropDownMenu_SetSelectedID(minimapStateMenu, self:GetID());
		local state = self:GetText();
		IRT_MinimapMode = state;
		if (state == "Always") then
			IRT_MinimapButton:Show();
		else
			IRT_MinimapButton:Hide();
		end
	end

	local function Initialize_MinimapState(self, level)
		for k, v in pairs(minimapStates) do
			local dropDownInfo = UIDropDownMenu_CreateInfo();
			dropDownInfo.text = v
			dropDownInfo.value = v
			dropDownInfo.func = minimapState_OnClick
			UIDropDownMenu_AddButton(dropDownInfo, level);
		end
	end

	UIDropDownMenu_SetWidth(minimapStateMenu, 110)
	UIDropDownMenu_SetButtonWidth(minimapStateMenu, 110)
	UIDropDownMenu_JustifyText(minimapStateMenu, "CENTER")
	UIDropDownMenu_Initialize(minimapStateMenu, Initialize_MinimapState)

]]

local vcText = IRT_GeneralOptions:CreateFontString(nil, "ARTWORK", "GameFontWhite");
vcText:SetText(L.OPTIONS_VERSIONCHECK_TEXT);
vcText:SetPoint("TOPLEFT", generalText, "TOPLEFT", 0, -25);

local vcButton = CreateFrame("Button", "IRT_VCButton", IRT_GeneralOptions, "UIPanelButtonTemplate");
vcButton:SetSize(150, 35);
vcButton:SetPoint("TOPLEFT", vcText, "TOPLEFT", 190, 15);
vcButton:SetText(L.OPTIONS_VERSIONCHECK_BUTTON_TEXT);
vcButton:HookScript("OnClick", function(self)
	local code = C_ChatInfo.SendAddonMessage("IRT_VC", "vc", "RAID");
	if (code ~= 0) then
		IRT_DebugMessage(L.ERROR_ADDON_MESSAGE_WHISPER .. IRT_GetAddonResultMessage(code), "debug", L.OPTIONS_GENERAL_TITLE);
	end
end);

local resetPositionsText = IRT_GeneralOptions:CreateFontString(nil, "ARTWORK", "GameFontWhite");
resetPositionsText:SetText(L.OPTIONS_RESETPOSITIONS_TEXT);
resetPositionsText:SetPoint("TOPLEFT", vcText, "TOPLEFT", 0, -50);

local resetPositionsButton = CreateFrame("Button", "IRT_VCButton", IRT_GeneralOptions, "UIPanelButtonTemplate");
resetPositionsButton:SetSize(150, 35);
resetPositionsButton:SetPoint("TOPLEFT", resetPositionsText, "TOPLEFT", 190, 15);
resetPositionsButton:SetText(L.OPTIONS_RESETPOSITIONS_BUTTON);
resetPositionsButton:HookScript("OnClick", function(self)
	StaticPopup_Show("IRT_RESETPOSITIONS");
end);

StaticPopupDialogs["IRT_RESETPOSITIONS"] = {
  text = L.WARNING_RESETPOSITIONS_DIALOG,
  button1 = "Yes",
  button2 = "No",
  OnAccept = function()
		IRT_InfoBoxSetPosition("TOPLEFT", 30, -150, nil, nil);
		IRT_PopupSetPosition("TOP", 0, -30, nil, nil);
		IRT_AutoOilSetPosition("RIGHT", ReadyCheckFrame, "RIGHT", 40, -15);
		--IRT_SetMinimapPoint(42);
  end,
  timeout = 0,
  whileDead = true,
  hideOnEscape = true,
  preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
};

IRT_GeneralOptions:SetScript("OnShow", function(self)
	fontSlider:SetValue(IRT_PopupTextFontSize);
	fontSizeText:SetText(IRT_PopupTextFontSize);
	layoutMenu:SetDefaultText(IRT_RPAFLayout);
	--Initialize_MinimapState();
	--UIDropDownMenu_SetSelectedName(minimapStateMenu, IRT_MinimapMode);
end);
