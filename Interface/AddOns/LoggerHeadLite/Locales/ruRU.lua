local ADDON_NAME, addon = ...
local L = LibStub("AceLocale-3.0"):NewLocale(ADDON_NAME, "ruRU")
if not L then return end

L["EXPANSION_NAME0"] = "Классические подземелья"
L["EXPANSION_NAME1"] = "Burning Crusade"
L["EXPANSION_NAME2"] = "Wrath of the Lich King"
L["Normal"] = "Обычный"
L["20 Player"] = "20 игроков"
L["40 Player"] = "40 игроков"
L["Dungeons"] = "Подземелья"

L[ [=[|cffeda55fClick|r to toggle combat logging
|cffeda55fRight-Click|r to open the options menu]=] ] = [=[Кликните для включения/отключения записи журнала боя
Клик правой кнопкой для открытия меню опций]=]
L["Disabled"] = "Отключено"
L["Enable chat logging when combat logging is enabled."] = "Включать запись чата всякий раз, когда включен журнал боя."
L["Enabled"] = "Включено"
L["Log chat"] = "Включить запись чата"
L["Profiles"] = "Профили"
L["Prompt on new zone"] = "Уведомлять о новой локации"
L["Prompt to enable logging when entering a new raid instance."] = "Уведомлять при входе в новую локацию?"
L["Show minimap icon"] = "Отображать иконку у мини-карты"
L["Toggle showing or hiding the minimap icon."] = "Вкл/Откл отображение иконки у мини-карты."
L["You have entered |cffd9d919%s|r. Enable logging for this zone?"] = "Вы вошли в |cffd9d919%s|r. Хотите включить запись для этой локации?"

