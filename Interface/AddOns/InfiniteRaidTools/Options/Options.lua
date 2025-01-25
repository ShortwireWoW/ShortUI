local L = IRTLocals;

IRT_Options = CreateFrame("Frame");
IRT_Options:Hide();

local subcategories = {};

local category, layout = Settings.RegisterCanvasLayoutCategory(IRT_Options, L.OPTIONS_TITLE);
local cID = category:GetID();
layout:AddAnchorPoint("TOPLEFT", 0, 0);
layout:AddAnchorPoint("BOTTOMRIGHT", 0, 0);

local title = IRT_Options:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
title:SetPoint("TOP", 0, -16);
title:SetText(L.OPTIONS_TITLE);

local author = IRT_Options:CreateFontString(nil, "ARTWORK", "GameFontNormal");
author:SetPoint("TOPLEFT", 450, -20);
author:SetText(L.OPTIONS_AUTHOR);

local version = IRT_Options:CreateFontString(nil, "ARTWORK", "GameFontNormal");
version:SetPoint("TOPLEFT", author, "BOTTOMLEFT", 0, -10);
version:SetText(L.OPTIONS_VERSION);

subcategories["Parent"] = category;

Settings.RegisterAddOnCategory(category);

IRT_GeneralModules = CreateFrame("Frame");
IRT_GeneralModules:SetScript("OnShow", function(IRT_GeneralModules)
	Settings.OpenToCategory(IRT_GeneralOptions);
end);
local subcategoryGM, layoutGM = Settings.RegisterCanvasLayoutSubcategory(category, IRT_GeneralModules, "General Modules");
subcategories[subcategoryGM.name] = {["subcategory"] = subcategoryGM, ["layout"] = layoutGM};

IRT_Options:SetScript("OnShow", function(IRT_OptionsFrame)
	local subcategory = IRT_GetSubcategory("General Modules").subcategory;
	--subcategory.expanded = true;
	Settings.OpenToCategory(subcategoryGM, true);
	local subcategoryGO = IRT_GetSubcategory(L.OPTIONS_GENERAL_TITLE).subcategory;
	Settings.OpenToCategory(subcategoryGO, true);
end);

IRT_NPModules = CreateFrame("Frame");
IRT_NPModules:SetScript("OnShow", function()
	--Settings.OpenToCategory(IRT_HuntsmanAltimorOptions);
end);
local subcategoryNP, layoutNP = Settings.RegisterCanvasLayoutSubcategory(category, IRT_NPModules, "Nerub-ar Palace");
subcategories[subcategoryNP.name] = {["subcategory"] = subcategoryNP, ["layout"] = layoutNP};

function IRT_GetSubcategory(name)
	if (name ~= nil and subcategories[name] ~= nil) then
		return subcategories[name];
	end
	return nil;
end

function IRT_AddSubcategory(name, cat, lo)
	if (name ~= nil and subcategories[name] == nil) then
		subcategories[name] = {["subcategory"] = cat, ["layout"] = lo};
	end
end