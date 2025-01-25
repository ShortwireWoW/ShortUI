local ADDON_NAME, addon = ...
local L = LibStub("AceLocale-3.0"):NewLocale(ADDON_NAME, "zhCN")
if not L then return end

L["EXPANSION_NAME0"] = "经典旧世"
L["EXPANSION_NAME1"] = "燃烧的远征"
L["EXPANSION_NAME2"] = "巫妖王之怒"
L["Normal"] = "普通"
L["20 Player"] = "20人"
L["40 Player"] = "40人"
L["Dungeons"] = "地下城"

L[ [=[|cffeda55fClick|r to toggle combat logging
|cffeda55fRight-Click|r to open the options menu]=] ] = [=[点击开启/关闭记录战斗日志
右键点击打开选项菜单]=]
L["Automatically turns on the combat log for selected raid and mythic+ instances."] = "自动为选定的副本和大秘境打开战斗日志"
L["Disabled"] = "关闭"
L["Enable chat logging when combat logging is enabled."] = "无论战斗纪录是否启用都启用聊天纪录"
L["Enabled"] = "开启"
L["Ignore partial group"] = "忽略部分团队"
L["Log chat"] = "启用聊天纪录"
L["Profiles"] = "配置文件"
L["Prompt on new zone"] = "切换地区时询问"
L["Prompt to enable logging when entering a new raid instance."] = "切换地区时询问是否记录战斗日志？"
L["Show minimap icon"] = "显示小地图图标"
L["Skip the prompt if your instance group has less than five players."] = "如果你的实际团队少于5名玩家，请跳过该提示。"
L["Toggle showing or hiding the minimap icon."] = "显示或隐藏小地图图标."
L["You have entered |cffd9d919%s|r. Enable logging for this zone?"] = "你已经进入 |cffd9d919%s|r. 你想要为此地区/副本记录战斗日志吗？"
L["You have not entered a raid instance yet! Zones will be listed after you enter them."] = "你还没有过进入实际副本！ 区域将在你进入后被列出。"

