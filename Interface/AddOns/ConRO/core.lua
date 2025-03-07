local addonName, addon = ...;
ConRO = LibStub('AceAddon-3.0'):NewAddon('ConRO', 'AceConsole-3.0', 'AceEvent-3.0', 'AceTimer-3.0');
ConRO.Version = C_AddOns.GetAddOnMetadata('ConRO', "Version");
local addoninfo = 'Main Version: ' .. ConRO.Version;

BINDING_HEADER_ConRO = "ConRO Hotkeys"
BINDING_NAME_CONROUNLOCK = "Lock/Unlock ConRO"
BINDING_NAME_CONROTOGGLE = "Target Set Toggle (Single/AoE)"
BINDING_NAME_CONROBOSSTOGGLE = "Enemy Set Toggle (Burst/Full)"

ConRO.rc = LibStub("LibRangeCheck-3.0");
ConRO.Textures = {
	['Skull'] = 'Interface\\AddOns\\ConRO\\images\\skull',
	['Starburst'] = 'Interface\\AddOns\\ConRO\\images\\starburst',
	['Shield'] = 'Interface\\AddOns\\ConRO\\images\\shield2',
	['Rage'] = 'Interface\\AddOns\\ConRO\\images\\rage',

	['Lightning'] = 'Interface\\AddOns\\ConRO\\images\\lightning',
	['MagicCircle'] = 'Interface\\AddOns\\ConRO\\images\\magiccircle',
	['Plus'] = 'Interface\\AddOns\\ConRO\\images\\plus',
	['DoubleArrow'] = 'Interface\\AddOns\\ConRO\\images\\arrow',

	['KozNicSquare'] = 'Interface\\AddOns\\ConRO\\images\\KozNic_square',
	['Circle'] = 'Interface\\AddOns\\ConRO\\images\\Circle',
};
ConRO.FinalTexture = nil;

ConRO.Colors = {
	Info = '|cFF1394CC',
	Error = '|cFFF0563D',
	Success = '|cFFBCCF02',
	[1] = '|cFFC79C6E',
	[2] = '|cFFF58CBA',
	[3] = '|cFFABD473',
	[4] = '|cFFFFF569',
	[5] = '|cFFFFFFFF',
	[6] = '|cFFC41F3B',
	[7] = '|cFF0070DE',
	[8] = '|cFF69CCF0',
	[9] = '|cFF9482C9',
	[10] = '|cFF00FF96',
	[11] = '|cFFFF7D0A',
	[12] = '|cFFA330C9',
	[13] = '|cFF33937F',
}

ConRO.ClassRGB = {
	[1] = {r = 0.78,g = 0.61,b = 0.43, a = 1.00},
	[2] = {r = 0.96,g = 0.55,b = 0.73, a = 1.00},
	[3] = {r = 0.67,g = 0.83,b = 0.45, a = 1.00},
	[4] = {r = 1.00,g = 0.96,b = 0.41, a = 1.00},
	[5] = {r = 1.00,g = 1.00,b = 1.00, a = 1.00},
	[6] = {r = 0.77,g = 0.12,b = 0.23, a = 1.00},
	[7] = {r = 0.00,g = 0.44,b = 0.87, a = 1.00},
	[8] = {r = 0.25,g = 0.78,b = 0.92, a = 1.00},
	[9] = {r = 0.53,g = 0.53,b = 0.93, a = 1.00},
	[10] = {r = 0.00,g = 1.00,b = 0.60, a = 1.00},
	[11] = {r = 1.00,g = 0.49,b = 0.04, a = 1.00},
	[12] = {r = 0.64,g = 0.19,b = 0.79, a = 1.00},
	[13] = {r = 0.16,g = 0.45,b = 0.39, a = 1.00},
}

ConRO.Classes = {
	[1] = 'Warrior',
	[2] = 'Paladin',
	[3] = 'Hunter',
	[4] = 'Rogue',
	[5] = 'Priest',
	[6] = 'DeathKnight',
	[7] = 'Shaman',
	[8] = 'Mage',
	[9] = 'Warlock',
	[10] = 'Monk',
	[11] = 'Druid',
	[12] = 'DemonHunter',
	[13] = 'Evoker'
}

local defaultOptions = {
	profile = {
		_Disable_Info_Messages = true,
		_Intervals = 0.20,
		_Unlock_ConRO = true,

		_Spec_1_Enabled = true,
		_Spec_2_Enabled = true,
		_Spec_3_Enabled = true,
		_Spec_4_Enabled = true,

		_Damage_Overlay_Alpha = true,
		_Damage_Overlay_Color = {r = 0.8,g = 0.8,b = 0.8,a = 1},
		_Damage_Overlay_Size = 1,
		_Damage_Icon_Style = 1,
		_Damage_Alpha_Mode = 1,
		_Damage_Overlay_Class_Color = false,
		_Cooldown_Overlay_Color = {r = 1,g = 0.6,b = 0,a = 1},
		_Cooldown_Overlay_Size = 1,
		_Cooldown_Icon_Style = 2,
		_Cooldown_Alpha_Mode = 2,

		_Defense_Overlay_Alpha = true,
		_Defense_Overlay_Color = {r = 0,g = 0.7,b = 1,a = 1},
		_Defense_Overlay_Size = 1,
		_Defense_Icon_Style = 3,
		_Defense_Alpha_Mode = 2,
		_Taunt_Overlay_Color = {r = 0.8,g = 0,b = 0, a = 1},
		_Taunt_Overlay_Size = 1,
		_Taunt_Icon_Style = 4,
		_Taunt_Alpha_Mode = 1,

		_Notifier_Overlay_Alpha = true,
		_Interrupt_Overlay_Color = {r = 1,g = 1,b = 1,a = 1},
		_Interrupt_Overlay_Size = 1,
		_Interrupt_Icon_Style = 5,
		_Interrupt_Alpha_Mode = 1,
		_Purge_Overlay_Color = {r = 0.6,g = 0,b = .9,a = 1},
		_Purge_Overlay_Size = 1,
		_Purge_Icon_Style = 6,
		_Purge_Alpha_Mode = 1,
		_RaidBuffs_Overlay_Color = {r = 0,g = 0.6,b = 0, a = 1},
		_RaidBuffs_Overlay_Size = 1,
		_RaidBuffs_Icon_Style = 7,
		_RaidBuffs_Alpha_Mode = 1,
		_Movement_Overlay_Color = {r = 0.2,g = 0.9,b = 0.2, a = 1},
		_Movement_Overlay_Size = 1,
		_Movement_Icon_Style = 8,
		_Movement_Alpha_Mode = 1,

		enableWindow = true,
		combatWindow = false,
		enableWindowCooldown = true,
		enableNextWindow = true,
		enableWindowSpellName = true,
		enableWindowKeybinds = true,
		_Reverse_Direction = false,
		_Reverse_Direction1 = "RIGHT",
		_Reverse_Direction2 = "LEFT",
		_Reverse_Direction3 = -3,
		_Reverse_Direction4 = 5,
		transparencyWindow = 0.9,
		windowIconSize = 50,
		flashIconSize = 50,
		enableDefenseWindow = true,
		enableInterruptWindow = true,
		enablePurgeWindow = true,

		_Hide_Toggle = false,
		toggleButtonSize = 1.2,
		toggleButtonOrientation = 2,
		_Burst_Threshold = 90,
	}
}

local orientations = {
		"Vertical",
		"Horizontal",
}

local _Overlay_Styles = {
	'Skull',
	'Starburst',
	'Shield',
	'Rage',
	'Lightning',
	'MagicCircle',
	'Plus',
	'DoubleArrow',
	'KozNic Square',
	'Circle',
}

local _Alpha_Modes = {
	'BLEND',
	'ADD',
	'MOD',
	'ALPHAKEY',
	'DISABLE',
}

local _, _, classIdv = UnitClass('player');
local cversion = C_AddOns.GetAddOnMetadata('ConRO_' .. ConRO.Classes[classIdv], 'Version');
local classinfo = " ";
	if cversion ~= nil then
		classinfo = ConRO.Classes[classIdv] .. ' Version: ' .. cversion;
	end

local options = {
	type = 'group',
	name = '-= |cffFFFFFFConRO  (Conflict Rotation Optimizer)|r =-',
	inline = false,
	childGroups = "tab",
	args = {
		versionPull = {
			order = 1,
			type = "description",
			width = "normal",
			name = addoninfo,
		},
		spacer2 = {
			order = 2,
			type = "description",
			width = "normal",
			name = "\n\n",
		},
		authorPull = {
			order = 3,
			type = "description",
			width = "normal",
			name = "Author: Vae",
		},
		cversionPull = {
			order = 4,
			type = "description",
			width = "full",
			name = classinfo,
		},
		spacer10 = {
			order = 10,
			type = "description",
			width = "full",
			name = "\n\n",
		},
--Generic Addon Settings
		_Disable_Info_Messages = {
			name = "Disable info messages",
			desc = "Enables / disables info messages, if you have issues with addon, make sure to deselect this.",
			type = "toggle",
			width = "normal",
			order = 11,
			set = function(info, val)
				ConRO.db.profile._Disable_Info_Messages = val;
			end,
			get = function(info) return ConRO.db.profile._Disable_Info_Messages end
		},
		spacer12 = {
			order = 12,
			type = "description",
			width = "normal",
			name = "\n\n",
		},
		_Intervals = {
			name = "Interval in seconds",
			desc = "Sets how frequent rotation updates will be. Low value will result in fps drops.",
			type = "range",
			width = "normal",
			order = 13,
			hidden = true,
			min = 0.01,
			max = 2,
			set = function(info,val) ConRO.db.profile._Intervals = val end,
			get = function(info) return ConRO.db.profile._Intervals end
		},
		_Unlock_ConRO = {
			name = "Unlock ConRO",
			desc = "Make display windows movable.",
			type = "toggle",
			width = "normal",
			order = 14,
			set = function(info, val)
				ConRO.db.profile._Unlock_ConRO = val;
				ConROWindow:EnableMouse(ConRO.db.profile._Unlock_ConRO);
				ConRODefenseWindow:EnableMouse(ConRO.db.profile._Unlock_ConRO);
				ConROInterruptWindow:EnableMouse(ConRO.db.profile._Unlock_ConRO);
				ConROPurgeWindow:EnableMouse(ConRO.db.profile._Unlock_ConRO);
				if val == true and ConRO.db.profile.enableInterruptWindow == true then
					ConROInterruptWindow:Show();
				else
					ConROInterruptWindow:Hide();
				end
				if val == true and ConRO.db.profile.enablePurgeWindow == true then
					ConROPurgeWindow:Show();
				else
					ConROPurgeWindow:Hide();
				end
			end,
			get = function(info) return ConRO.db.profile._Unlock_ConRO end
		},

--Class Settings
		classSettings = {
			type = 'group',
			name = 'Class Settings',
			order = 20,
			args = {
				_Spec_1_Enabled = {
					name = function() return "\124T".. select(4, GetSpecializationInfo(1)) ..":0\124t ".. select(2, GetSpecializationInfo(1)) end,
					desc = function() return select(3, GetSpecializationInfo(1)) end,
					type = "toggle",
					width = .80,
					order = 1,
					set = function(info, val)
						ConRO.db.profile._Spec_1_Enabled = val;

						ConRO:DisableRotation();
						ConRO:DisableDefense();
						ConRO:LoadModule();
						ConRO:EnableRotation();
						ConRO:EnableDefense();

						if ConRO:HealSpec() then
							ConROWindow:Hide();
							ConROWindow2:Hide();
							ConROWindow3:Hide();
						elseif ConRO.db.profile.enableWindow and not ConRO.db.profile.combatWindow then
							ConROWindow:Show();
							if ConRO.db.profile.enableNextWindow then
								ConROWindow2:Show();
								ConROWindow3:Show();
							end
						else
							ConROWindow:Hide();
							ConROWindow2:Hide();
							ConROWindow3:Hide();
						end
					end,
					get = function(info) return ConRO.db.profile._Spec_1_Enabled end
				},
				_Spec_2_Enabled = {
					name = function() return "\124T".. select(4, GetSpecializationInfo(2)) ..":0\124t ".. select(2, GetSpecializationInfo(2)) end,
					desc = function() return select(3, GetSpecializationInfo(2)) end,
					type = "toggle",
					width = .80,
					order = 2,
					set = function(info, val)
						ConRO.db.profile._Spec_2_Enabled = val;

						ConRO:DisableRotation();
						ConRO:DisableDefense();
						ConRO:LoadModule();
						ConRO:EnableRotation();
						ConRO:EnableDefense();

						if ConRO:HealSpec() then
							ConROWindow:Hide();
							ConROWindow2:Hide();
							ConROWindow3:Hide();
						elseif ConRO.db.profile.enableWindow and not ConRO.db.profile.combatWindow then
							ConROWindow:Show();
							if ConRO.db.profile.enableNextWindow then
								ConROWindow2:Show();
								ConROWindow3:Show();
							end
						else
							ConROWindow:Hide();
							ConROWindow2:Hide();
							ConROWindow3:Hide();
						end
					end,
					get = function(info) return ConRO.db.profile._Spec_2_Enabled end
				},
				_Spec_3_Enabled = {
					name = function() if GetNumSpecializations() >= 3 then return "\124T".. select(4, GetSpecializationInfo(3)) ..":0\124t ".. select(2, GetSpecializationInfo(3)); end end,
					desc = function() if GetNumSpecializations() >= 3 then return select(3, GetSpecializationInfo(3)); end end,
					type = "toggle",
					width = .80,
					order = 3,
					hidden = function() if GetNumSpecializations() >= 3 then return false; else return true; end end,
					set = function(info, val)
						ConRO.db.profile._Spec_3_Enabled = val;

						ConRO:DisableRotation();
						ConRO:DisableDefense();
						ConRO:LoadModule();
						ConRO:EnableRotation();
						ConRO:EnableDefense();

						if ConRO:HealSpec() then
							ConROWindow:Hide();
							ConROWindow2:Hide();
							ConROWindow3:Hide();
						elseif ConRO.db.profile.enableWindow and not ConRO.db.profile.combatWindow then
							ConROWindow:Show();
							if ConRO.db.profile.enableNextWindow then
								ConROWindow2:Show();
								ConROWindow3:Show();
							end
						else
							ConROWindow:Hide();
							ConROWindow2:Hide();
							ConROWindow3:Hide();
						end
					end,
					get = function(info) return ConRO.db.profile._Spec_3_Enabled end
				},
				_Spec_4_Enabled = {
					name = function() if GetNumSpecializations() >= 4 then return "\124T".. select(4, GetSpecializationInfo(4)) ..":0\124t ".. select(2, GetSpecializationInfo(4)); end end,
					desc = function() if GetNumSpecializations() >= 4 then return select(3, GetSpecializationInfo(4)); end end,
					type = "toggle",
					width = .80,
					order = 4,
					hidden = function() if GetNumSpecializations() >= 4 then return false; else return true; end end,
					set = function(info, val)
						ConRO.db.profile._Spec_4_Enabled = val;

						ConRO:DisableRotation();
						ConRO:DisableDefense();
						ConRO:LoadModule();
						ConRO:EnableRotation();
						ConRO:EnableDefense();

						if ConRO:HealSpec() then
							ConROWindow:Hide();
							ConROWindow2:Hide();
							ConROWindow3:Hide();
						elseif ConRO.db.profile.enableWindow and not ConRO.db.profile.combatWindow then
							ConROWindow:Show();
							if ConRO.db.profile.enableNextWindow then
								ConROWindow2:Show();
								ConROWindow3:Show();
							end
						else
							ConROWindow:Hide();
							ConROWindow2:Hide();
							ConROWindow3:Hide();
						end
					end,
					get = function(info) return ConRO.db.profile._Spec_4_Enabled end
				},
			},
		},

--Overlay Settings
		overlaySettings = {
			type = 'group',
			name = 'Overlay Settings',
			order = 21,
			args = {
				spacer1 = {
					type = "description",
					width = .1,
					name = "\n\n",
					order = 2.5,
				},
				_Damage_Overlay_Alpha = {
					name = 'Show Damage Overlay',
					desc = 'Turn damage overlay on and off.',
					type = 'toggle',
					width = 'default',
					order = 3,
					set = function(info, val)
						ConRO.db.profile._Damage_Overlay_Alpha = val;
						if ConRO.db.profile._Damage_Overlay_Alpha then
							local _Frame_Tables_ConRO = {ConRO.DamageFrames, ConRO.CoolDownFrames};
							for _, frameTable in pairs(_Frame_Tables_ConRO) do
								for k, overlay in pairs(frameTable) do
									if overlay ~= nil then
										overlay:SetAlpha(1);
									end
								end
							end
						else
							local _Frame_Tables_ConRO = {ConRO.DamageFrames, ConRO.CoolDownFrames};
							for _, frameTable in pairs(_Frame_Tables_ConRO) do
								for k, overlay in pairs(frameTable) do
									if overlay ~= nil then
										overlay:SetAlpha(0);
									end
								end
							end
						end
					end,
					get = function(info) return ConRO.db.profile._Damage_Overlay_Alpha end
				},
				spacer3 = {
					type = "description",
					width = .1,
					name = "\n\n",
					order = 3.5,
				},
				_Defense_Overlay_Alpha = {
					name = 'Show Defense Overlay',
					desc = 'Turn defense overlay on and off.',
					type = 'toggle',
					width = 'default',
					order = 4,
					set = function(info, val)
						ConRO.db.profile._Defense_Overlay_Alpha = val;
						if ConRO.db.profile._Defense_Overlay_Alpha then
							local _Frame_Tables_ConRO = {ConRO.DefenseFrames, ConRO.TauntFrames};
							for _, frameTable in pairs(_Frame_Tables_ConRO) do
								for k, overlay in pairs(frameTable) do
									if overlay ~= nil then
										overlay:SetAlpha(1);
									end
								end
							end
						else
							local _Frame_Tables_ConRO = {ConRO.DefenseFrames, ConRO.TauntFrames};
							for _, frameTable in pairs(_Frame_Tables_ConRO) do
								for k, overlay in pairs(frameTable) do
									if overlay ~= nil then
										overlay:SetAlpha(0);
									end
								end
							end
						end
					end,
					get = function(info) return ConRO.db.profile._Defense_Overlay_Alpha end
				},
				spacer4 = {
					type = "description",
					width = .1,
					name = "\n\n",
					order = 4.5,
				},
				_Notifier_Overlay_Alpha = {
					name = 'Show Notifier Overlay',
					desc = 'Turn interrupt, raid buff and purge overlays on and off.',
					type = 'toggle',
					width = 'default',
					order = 5,
					set = function(info, val)
						ConRO.db.profile._Notifier_Overlay_Alpha = val;
						if ConRO.db.profile._Notifier_Overlay_Alpha then
							local _Frame_Tables_ConRO = {ConRO.InterruptFrames, ConRO.PurgableFrames, ConRO.RaidBuffsFrames, ConRO.MovementFrames};
							for _, frameTable in pairs(_Frame_Tables_ConRO) do
								for k, overlay in pairs(frameTable) do
									if overlay ~= nil then
										overlay:SetAlpha(1);
									end
								end
							end
						else
							local _Frame_Tables_ConRO = {ConRO.InterruptFrames, ConRO.PurgableFrames, ConRO.RaidBuffsFrames, ConRO.MovementFrames};
							for _, frameTable in pairs(_Frame_Tables_ConRO) do
								for k, overlay in pairs(frameTable) do
									if overlay ~= nil then
										overlay:SetAlpha(0);
									end
								end
							end
						end
					end,
					get = function(info) return ConRO.db.profile._Notifier_Overlay_Alpha end
				},
				_Damage_Spacer = {
					type = "description",
					width = "full",
					name = "\n\n",
					order = 10,
				},
				_Damage_Overlays = {
					type = "header",
					name = "Damage Overlays",
					order = 11,
				},
				_Damage_Overlay_Class_Color = {
					name = 'Class Colors',
					desc = 'Change damage overlays to class colors.',
					type = 'toggle',
					disabled = function()
						if ConRO.db.profile._Damage_Overlay_Alpha then
							return false;
						else
							return true;
						end
					end,
					width = "full",
					order = 11.5,
					set = function(info, val)
						ConRO.db.profile._Damage_Overlay_Class_Color = val;
						if val == true then
							local _, _, classId = UnitClass('player');
							local c = ConRO.ClassRGB[classId];
							for k, overlay in pairs(ConRO.DamageFrames) do
								if overlay ~= nil then
									overlay.texture:SetVertexColor(c.r, c.g, c.b);
									overlay.texture:SetAlpha(c.a);
								end
							end
						else
							local t = ConRO.db.profile._Damage_Overlay_Color;
							for k, overlay in pairs(ConRO.DamageFrames) do
								if overlay ~= nil then
									overlay.texture:SetVertexColor(t.r, t.g, t.b);
									overlay.texture:SetAlpha(t.a);
								end
							end
						end
					end,
					get = function(info) return ConRO.db.profile._Damage_Overlay_Class_Color end
				},
				_Damage_Overlay_Color = {
					name = 'Damage',
					desc = 'Change damage overlays color.',
					type = 'color',
					disabled = function()
						if ConRO.db.profile._Damage_Overlay_Alpha and not ConRO.db.profile._Damage_Overlay_Class_Color then
							return false;
						else
							return true;
						end
					end,
					hasAlpha = true,
					width = .75,
					order = 12,
					set = function(info, r, g, b, a)
						local t = ConRO.db.profile._Damage_Overlay_Color;
						t.r, t.g, t.b, t.a = r, g, b, a;
						for k, overlay in pairs(ConRO.DamageFrames) do
							if overlay ~= nil then
								overlay.texture:SetVertexColor(r, g, b);
								overlay.texture:SetAlpha(a);
							end
						end
					end,
					get = function(info)
						local t = ConRO.db.profile._Damage_Overlay_Color;
						return t.r, t.g, t.b, t.a;
					end
				},
				spacer12 = {
					type = "description",
					width = .1,
					name = "\n\n",
					order = 12.5,
				},
				_Damage_Overlay_Size = {
					name = 'Size',
					desc = 'Sets the scale of the damage overlay texture.',
					type = 'range',
					disabled = function()
						if ConRO.db.profile._Damage_Overlay_Alpha then
							return false;
						else
							return true;
						end
					end,
					width = .75,
					order = 13,
					min = .5,
					max = 1.5,
					step = .1,
					set = function(info,val)
						ConRO.db.profile._Damage_Overlay_Size = val;
						for k, overlay in pairs(ConRO.DamageFrames) do
							if overlay ~= nil then
								overlay:SetScale(val);
							end
						end
					end,
					get = function(info) return ConRO.db.profile._Damage_Overlay_Size end
				},
				spacer13 = {
					type = "description",
					width = .1,
					name = "\n\n",
					order = 13.5,
				},
				_Damage_Icon_Style = {
					name = "Style",
					desc = "Sets the style of the damage overlay texture.",
					type = "select",
					disabled = function()
						if ConRO.db.profile._Damage_Overlay_Alpha then
							return false;
						else
							return true;
						end
					end,
					width = .75,
					order = 14,
					values = _Overlay_Styles,
					style = "dropdown",
					set = function(info,val)
						ConRO.db.profile._Damage_Icon_Style = val;
						for k, overlay in pairs(ConRO.DamageFrames) do
							if overlay ~= nil then
								if ConRO.db.profile._Damage_Icon_Style == 1 then
									overlay.texture:SetTexture(ConRO.Textures.Skull);
									overlay.texture:SetBlendMode('BLEND');
								elseif ConRO.db.profile._Damage_Icon_Style == 2 then
									overlay.texture:SetTexture(ConRO.Textures.Starburst);
									overlay.texture:SetBlendMode('BLEND');
								elseif ConRO.db.profile._Damage_Icon_Style == 3 then
									overlay.texture:SetTexture(ConRO.Textures.Shield);
									overlay.texture:SetBlendMode('BLEND');
								elseif ConRO.db.profile._Damage_Icon_Style == 4 then
									overlay.texture:SetTexture(ConRO.Textures.Rage);
									overlay.texture:SetBlendMode('BLEND');
								elseif ConRO.db.profile._Damage_Icon_Style == 5 then
									overlay.texture:SetTexture(ConRO.Textures.Lightning);
									overlay.texture:SetBlendMode('BLEND');
								elseif ConRO.db.profile._Damage_Icon_Style == 6 then
									overlay.texture:SetTexture(ConRO.Textures.MagicCircle);
									overlay.texture:SetBlendMode('BLEND');
								elseif ConRO.db.profile._Damage_Icon_Style == 7 then
									overlay.texture:SetTexture(ConRO.Textures.Plus);
									overlay.texture:SetBlendMode('BLEND');
								elseif ConRO.db.profile._Damage_Icon_Style == 8 then
									overlay.texture:SetTexture(ConRO.Textures.DoubleArrow);
									overlay.texture:SetBlendMode('BLEND');
								elseif ConRO.db.profile._Damage_Icon_Style == 9 then
									overlay.texture:SetTexture(ConRO.Textures.KozNicSquare);
									overlay.texture:SetBlendMode('BLEND');
								elseif ConRO.db.profile._Damage_Icon_Style == 10 then
									overlay.texture:SetTexture(ConRO.Textures.Circle);
									overlay.texture:SetBlendMode('BLEND');
								end
							end
						end
					end,
					get = function(info) return ConRO.db.profile._Damage_Icon_Style end
				},
				spacer14 = {
					type = "description",
					width = .1,
					name = "\n\n",
					order = 14.5,
				},
				_Damage_Alpha_Mode = {
					name = "Alpha",
					desc = "Sets the mode of the damage texture alpha.",
					type = "select",
					disabled = function()
						if ConRO.db.profile._Damage_Overlay_Alpha then
							return false;
						else
							return true;
						end
					end,
					width = .75,
					order = 15,
					values = _Alpha_Modes,
					style = "dropdown",
					set = function(info,val)
						ConRO.db.profile._Damage_Alpha_Mode = val;
						for k, overlay in pairs(ConRO.DamageFrames) do
							if overlay ~= nil then
								if ConRO.db.profile._Damage_Alpha_Mode == 1 then
									overlay.texture:SetBlendMode('BLEND');
								elseif ConRO.db.profile._Damage_Alpha_Mode == 2 then
									overlay.texture:SetBlendMode('ADD');
								elseif ConRO.db.profile._Damage_Alpha_Mode == 3 then
									overlay.texture:SetBlendMode('MOD');
								elseif ConRO.db.profile._Damage_Alpha_Mode == 4 then
									overlay.texture:SetBlendMode('ALPHAKEY');
								elseif ConRO.db.profile._Damage_Alpha_Mode == 5 then
									overlay.texture:SetBlendMode('DISABLE');
								end
							end
						end
					end,
					get = function(info) return ConRO.db.profile._Damage_Alpha_Mode end
				},
				_Cooldown_Overlay_Color = {
					name = 'Cooldown',
					desc = 'Change cooldown burst overlays color.',
					type = 'color',
					disabled = function()
						if ConRO.db.profile._Damage_Overlay_Alpha then
							return false;
						else
							return true;
						end
					end,
					hasAlpha = true,
					width = .75,
					order = 17,
					set = function(info, r, g, b, a)
						local t = ConRO.db.profile._Cooldown_Overlay_Color;
						t.r, t.g, t.b, t.a = r, g, b, a;
						for k, overlay in pairs(ConRO.CoolDownFrames) do
							if overlay ~= nil then
								overlay.texture:SetVertexColor(r, g, b);
								overlay.texture:SetAlpha(a);
							end
						end
					end,
					get = function(info)
						local t = ConRO.db.profile._Cooldown_Overlay_Color;
						return t.r, t.g, t.b, t.a;
					end
				},
				spacer17 = {
					type = "description",
					width = .1,
					name = "\n\n",
					order = 17.5,
				},
				_Cooldown_Overlay_Size = {
					name = 'Size',
					desc = 'Sets the scale of the cooldown overlay texture.',
					type = 'range',
					disabled = function()
						if ConRO.db.profile._Damage_Overlay_Alpha then
							return false;
						else
							return true;
						end
					end,
					width = .75,
					order = 18,
					min = .5,
					max = 1.5,
					step = .1,
					set = function(info,val)
						ConRO.db.profile._Cooldown_Overlay_Size = val;
						for k, overlay in pairs(ConRO.CoolDownFrames) do
							if overlay ~= nil then
								overlay:SetScale(val);
							end
						end
					end,
					get = function(info) return ConRO.db.profile._Cooldown_Overlay_Size end
				},
				spacer18 = {
					type = "description",
					width = .1,
					name = "\n\n",
					order = 18.5,
				},
				_Cooldown_Icon_Style = {
					name = "Style",
					desc = "Sets the style of the cooldown overlay texture.",
					type = "select",
					disabled = function()
						if ConRO.db.profile._Damage_Overlay_Alpha then
							return false;
						else
							return true;
						end
					end,
					width = .75,
					order = 19,
					values = _Overlay_Styles,
					style = "dropdown",
					set = function(info,val)
						ConRO.db.profile._Cooldown_Icon_Style = val;
						for k, overlay in pairs(ConRO.CoolDownFrames) do
							if overlay ~= nil then
								if ConRO.db.profile._Cooldown_Icon_Style == 1 then
									overlay.texture:SetTexture(ConRO.Textures.Skull);
								elseif ConRO.db.profile._Cooldown_Icon_Style == 2 then
									overlay.texture:SetTexture(ConRO.Textures.Starburst);
								elseif ConRO.db.profile._Cooldown_Icon_Style == 3 then
									overlay.texture:SetTexture(ConRO.Textures.Shield);
								elseif ConRO.db.profile._Cooldown_Icon_Style == 4 then
									overlay.texture:SetTexture(ConRO.Textures.Rage);
								elseif ConRO.db.profile._Cooldown_Icon_Style == 5 then
									overlay.texture:SetTexture(ConRO.Textures.Lightning);
								elseif ConRO.db.profile._Cooldown_Icon_Style == 6 then
									overlay.texture:SetTexture(ConRO.Textures.MagicCircle);
								elseif ConRO.db.profile._Cooldown_Icon_Style == 7 then
									overlay.texture:SetTexture(ConRO.Textures.Plus);
								elseif ConRO.db.profile._Cooldown_Icon_Style == 8 then
									overlay.texture:SetTexture(ConRO.Textures.DoubleArrow);
								elseif ConRO.db.profile._Cooldown_Icon_Style == 9 then
									overlay.texture:SetTexture(ConRO.Textures.KozNicSquare);
								elseif ConRO.db.profile._Cooldown_Icon_Style == 10 then
									overlay.texture:SetTexture(ConRO.Textures.Circle);
								end
							end
						end
					end,
					get = function(info) return ConRO.db.profile._Cooldown_Icon_Style end
				},
				spacer19 = {
					type = "description",
					width = .1,
					name = "\n\n",
					order = 19.5,
				},
				_Cooldown_Alpha_Mode = {
					name = "Alpha",
					desc = "Sets the mode of the cooldown texture alpha.",
					type = "select",
					disabled = function()
						if ConRO.db.profile._Damage_Overlay_Alpha then
							return false;
						else
							return true;
						end
					end,
					width = .75,
					order = 20,
					values = _Alpha_Modes,
					style = "dropdown",
					set = function(info,val)
						ConRO.db.profile._Cooldown_Alpha_Mode = val;
						for k, overlay in pairs(ConRO.CoolDownFrames) do
							if overlay ~= nil then
								if ConRO.db.profile._Cooldown_Alpha_Mode == 1 then
									overlay.texture:SetBlendMode('BLEND');
								elseif ConRO.db.profile._Cooldown_Alpha_Mode == 2 then
									overlay.texture:SetBlendMode('ADD');
								elseif ConRO.db.profile._Cooldown_Alpha_Mode == 3 then
									overlay.texture:SetBlendMode('MOD');
								elseif ConRO.db.profile._Cooldown_Alpha_Mode == 4 then
									overlay.texture:SetBlendMode('ALPHAKEY');
								elseif ConRO.db.profile._Cooldown_Alpha_Mode == 5 then
									overlay.texture:SetBlendMode('DISABLE');
								end
							end
						end
					end,
					get = function(info) return ConRO.db.profile._Cooldown_Alpha_Mode end
				},
				_Defense_Spacer = {
					type = "description",
					width = "full",
					name = "\n\n",
					order = 30,
				},
				_Defense_Overlays = {
					type = "header",
					name = "Defense Overlays",
					order = 31,
				},
				_Defense_Overlay_Color = {
					name = 'Defense',
					desc = 'Change defense overlays color.',
					type = 'color',
					disabled = function()
						if ConRO.db.profile._Defense_Overlay_Alpha then
							return false;
						else
							return true;
						end
					end,
					hasAlpha = true,
					width = .75,
					order = 32,
					set = function(info, r, g, b, a)
						local t = ConRO.db.profile._Defense_Overlay_Color;
						t.r, t.g, t.b, t.a = r, g, b, a;
						for k, overlay in pairs(ConRO.DefenseFrames) do
							if overlay ~= nil then
								overlay.texture:SetVertexColor(r, g, b);
								overlay.texture:SetAlpha(a);
							end
						end
					end,
					get = function(info)
						local t = ConRO.db.profile._Defense_Overlay_Color;
						return t.r, t.g, t.b, t.a;
					end
				},
				spacer32 = {
					type = "description",
					width = .1,
					name = "\n\n",
					order = 32.5,
				},
				_Defense_Overlay_Size = {
					name = 'Size',
					desc = 'Sets the scale of the defense overlay texture.',
					type = 'range',
					disabled = function()
						if ConRO.db.profile._Defense_Overlay_Alpha then
							return false;
						else
							return true;
						end
					end,
					width = .75,
					order = 33,
					min = .5,
					max = 1.5,
					step = .1,
					set = function(info,val)
						ConRO.db.profile._Defense_Overlay_Size = val;
						for k, overlay in pairs(ConRO.DefenseFrames) do
							if overlay ~= nil then
								overlay:SetScale(val);
							end
						end
					end,
					get = function(info) return ConRO.db.profile._Defense_Overlay_Size end
				},
				spacer33 = {
					type = "description",
					width = .1,
					name = "\n\n",
					order = 33.5,
				},
				_Defense_Icon_Style = {
					name = "Style",
					desc = "Sets the style of the defense overlay texture.",
					type = "select",
					disabled = function()
						if ConRO.db.profile._Defense_Overlay_Alpha then
							return false;
						else
							return true;
						end
					end,
					width = .75,
					order = 34,
					values = _Overlay_Styles,
					style = "dropdown",
					set = function(info,val)
						ConRO.db.profile._Defense_Icon_Style = val
						for k, overlay in pairs(ConRO.DefenseFrames) do
							if overlay ~= nil then
								if ConRO.db.profile._Defense_Icon_Style == 1 then
									overlay.texture:SetTexture(ConRO.Textures.Skull);
								elseif ConRO.db.profile._Defense_Icon_Style == 2 then
									overlay.texture:SetTexture(ConRO.Textures.Starburst);
								elseif ConRO.db.profile._Defense_Icon_Style == 3 then
									overlay.texture:SetTexture(ConRO.Textures.Shield);
								elseif ConRO.db.profile._Defense_Icon_Style == 4 then
									overlay.texture:SetTexture(ConRO.Textures.Rage);
								elseif ConRO.db.profile._Defense_Icon_Style == 5 then
									overlay.texture:SetTexture(ConRO.Textures.Lightning);
								elseif ConRO.db.profile._Defense_Icon_Style == 6 then
									overlay.texture:SetTexture(ConRO.Textures.MagicCircle);
								elseif ConRO.db.profile._Defense_Icon_Style == 7 then
									overlay.texture:SetTexture(ConRO.Textures.Plus);
								elseif ConRO.db.profile._Defense_Icon_Style == 8 then
									overlay.texture:SetTexture(ConRO.Textures.DoubleArrow);
								elseif ConRO.db.profile._Defense_Icon_Style == 9 then
									overlay.texture:SetTexture(ConRO.Textures.KozNicSquare);
								elseif ConRO.db.profile._Defense_Icon_Style == 10 then
									overlay.texture:SetTexture(ConRO.Textures.Circle);
								end
							end
						end
					end,
					get = function(info) return ConRO.db.profile._Defense_Icon_Style end
				},
				spacer34 = {
					type = "description",
					width = .1,
					name = "\n\n",
					order = 34.5,
				},
				_Defense_Alpha_Mode = {
					name = "Alpha",
					desc = "Sets the mode of the defense texture alpha.",
					type = "select",
					disabled = function()
						if ConRO.db.profile._Defense_Overlay_Alpha then
							return false;
						else
							return true;
						end
					end,
					width = .75,
					order = 35,
					values = _Alpha_Modes,
					style = "dropdown",
					set = function(info,val)
						ConRO.db.profile._Defense_Alpha_Mode = val;
						for k, overlay in pairs(ConRO.DefenseFrames) do
							if overlay ~= nil then
								if ConRO.db.profile._Defense_Alpha_Mode == 1 then
									overlay.texture:SetBlendMode('BLEND');
								elseif ConRO.db.profile._Defense_Alpha_Mode == 2 then
									overlay.texture:SetBlendMode('ADD');
								elseif ConRO.db.profile._Defense_Alpha_Mode == 3 then
									overlay.texture:SetBlendMode('MOD');
								elseif ConRO.db.profile._Defense_Alpha_Mode == 4 then
									overlay.texture:SetBlendMode('ALPHAKEY');
								elseif ConRO.db.profile._Defense_Alpha_Mode == 5 then
									overlay.texture:SetBlendMode('DISABLE');
								end
							end
						end
					end,
					get = function(info) return ConRO.db.profile._Defense_Alpha_Mode end
				},
				_Taunt_Overlay_Color = {
					name = 'Taunt',
					desc = 'Change taunt overlays color.',
					type = 'color',
					disabled = function()
						if ConRO.db.profile._Defense_Overlay_Alpha then
							return false;
						else
							return true;
						end
					end,
					hasAlpha = true,
					width = .75,
					order = 36,
					set = function(info, r, g, b, a)
						local t = ConRO.db.profile._Taunt_Overlay_Color;
						t.r, t.g, t.b, t.a = r, g, b, a;
						for k, overlay in pairs(ConRO.TauntFrames) do
							if overlay ~= nil then
								overlay.texture:SetVertexColor(r, g, b);
								overlay.texture:SetAlpha(a);
							end
						end
					end,
					get = function(info)
						local t = ConRO.db.profile._Taunt_Overlay_Color;
						return t.r, t.g, t.b, t.a;
					end
				},
				spacer36 = {
					type = "description",
					width = .1,
					name = "\n\n",
					order = 36.5,
				},
				_Taunt_Overlay_Size = {
					name = 'Size',
					desc = 'Sets the scale of the taunt overlay texture.',
					type = 'range',
					disabled = function()
						if ConRO.db.profile._Defense_Overlay_Alpha then
							return false;
						else
							return true;
						end
					end,
					width = .75,
					order = 37,
					min = .5,
					max = 1.5,
					step = .1,
					set = function(info,val)
						ConRO.db.profile._Taunt_Overlay_Size = val;
						for k, overlay in pairs(ConRO.TauntFrames) do
							if overlay ~= nil then
								overlay:SetScale(val);
							end
						end
					end,
					get = function(info) return ConRO.db.profile._Taunt_Overlay_Size end
				},
				spacer37 = {
					type = "description",
					width = .1,
					name = "\n\n",
					order = 37.5,
				},
				_Taunt_Icon_Style = {
					name = "Style",
					desc = "Sets the style of the taunt overlay texture.",
					type = "select",
					disabled = function()
						if ConRO.db.profile._Defense_Overlay_Alpha then
							return false;
						else
							return true;
						end
					end,
					width = .75,
					order = 38,
					values = _Overlay_Styles,
					style = "dropdown",
					set = function(info,val)
						ConRO.db.profile._Taunt_Icon_Style = val
						for k, overlay in pairs(ConRO.TauntFrames) do
							if overlay ~= nil then
								if ConRO.db.profile._Taunt_Icon_Style == 1 then
									overlay.texture:SetTexture(ConRO.Textures.Skull);
								elseif ConRO.db.profile._Taunt_Icon_Style == 2 then
									overlay.texture:SetTexture(ConRO.Textures.Starburst);
								elseif ConRO.db.profile._Taunt_Icon_Style == 3 then
									overlay.texture:SetTexture(ConRO.Textures.Shield);
								elseif ConRO.db.profile._Taunt_Icon_Style == 4 then
									overlay.texture:SetTexture(ConRO.Textures.Rage);
								elseif ConRO.db.profile._Taunt_Icon_Style == 5 then
									overlay.texture:SetTexture(ConRO.Textures.Lightning);
								elseif ConRO.db.profile._Taunt_Icon_Style == 6 then
									overlay.texture:SetTexture(ConRO.Textures.MagicCircle);
								elseif ConRO.db.profile._Taunt_Icon_Style == 7 then
									overlay.texture:SetTexture(ConRO.Textures.Plus);
								elseif ConRO.db.profile._Taunt_Icon_Style == 8 then
									overlay.texture:SetTexture(ConRO.Textures.DoubleArrow);
								elseif ConRO.db.profile._Taunt_Icon_Style == 9 then
									overlay.texture:SetTexture(ConRO.Textures.KozNicSquare);
								elseif ConRO.db.profile._Taunt_Icon_Style == 10 then
									overlay.texture:SetTexture(ConRO.Textures.Circle);
								end
							end
						end
					end,
					get = function(info) return ConRO.db.profile._Taunt_Icon_Style end
				},
				spacer38 = {
					type = "description",
					width = .1,
					name = "\n\n",
					order = 38.5,
				},
				_Taunt_Alpha_Mode = {
					name = "Alpha",
					desc = "Sets the mode of the taunt texture alpha.",
					type = "select",
					disabled = function()
						if ConRO.db.profile._Defense_Overlay_Alpha then
							return false;
						else
							return true;
						end
					end,
					width = .75,
					order = 39,
					values = _Alpha_Modes,
					style = "dropdown",
					set = function(info,val)
						ConRO.db.profile._Taunt_Alpha_Mode = val;
						for k, overlay in pairs(ConRO.TauntFrames) do
							if overlay ~= nil then
								if ConRO.db.profile._Taunt_Alpha_Mode == 1 then
									overlay.texture:SetBlendMode('BLEND');
								elseif ConRO.db.profile._Taunt_Alpha_Mode == 2 then
									overlay.texture:SetBlendMode('ADD');
								elseif ConRO.db.profile._Taunt_Alpha_Mode == 3 then
									overlay.texture:SetBlendMode('MOD');
								elseif ConRO.db.profile._Taunt_Alpha_Mode == 4 then
									overlay.texture:SetBlendMode('ALPHAKEY');
								elseif ConRO.db.profile._Taunt_Alpha_Mode == 5 then
									overlay.texture:SetBlendMode('DISABLE');
								end
							end
						end
					end,
					get = function(info) return ConRO.db.profile._Taunt_Alpha_Mode end
				},
				_Notifier_Spacer = {
					type = "description",
					width = "full",
					name = "\n\n",
					order = 50,
				},
				_Notifier_Overlays = {
					type = "header",
					name = "Notifier Overlays",
					order = 51,
				},
				_Interrupt_Overlay_Color = {
					name = 'Interrupt',
					desc = 'Change interrupt overlays color.',
					type = 'color',
					disabled = function()
						if ConRO.db.profile._Notifier_Overlay_Alpha then
							return false;
						else
							return true;
						end
					end,
					hasAlpha = true,
					width = .75,
					order = 52,
					set = function(info, r, g, b, a)
						local t = ConRO.db.profile._Interrupt_Overlay_Color;
						t.r, t.g, t.b, t.a = r, g, b, a;
						for k, overlay in pairs(ConRO.InterruptFrames) do
							if overlay ~= nil then
								overlay.texture:SetVertexColor(r, g, b);
								overlay.texture:SetAlpha(a);
							end
						end
					end,
					get = function(info)
						local t = ConRO.db.profile._Interrupt_Overlay_Color;
						return t.r, t.g, t.b, t.a;
					end
				},
				spacer52 = {
					type = "description",
					width = .1,
					name = "\n\n",
					order = 52.5,
				},
				_Interrupt_Overlay_Size = {
					name = 'Size',
					desc = 'Sets the scale of the interrupt overlay texture.',
					type = 'range',
					disabled = function()
						if ConRO.db.profile._Notifier_Overlay_Alpha then
							return false;
						else
							return true;
						end
					end,
					width = .75,
					order = 53,
					min = .5,
					max = 1.5,
					step = .1,
					set = function(info,val)
						ConRO.db.profile._Interrupt_Overlay_Size = val;
						for k, overlay in pairs(ConRO.InterruptFrames) do
							if overlay ~= nil then
								overlay:SetScale(val);
							end
						end
					end,
					get = function(info) return ConRO.db.profile._Interrupt_Overlay_Size end
				},
				spacer53 = {
					type = "description",
					width = .1,
					name = "\n\n",
					order = 53.5,
				},
				_Interrupt_Icon_Style = {
					name = "Style",
					desc = "Sets the style of the interrupt overlay texture.",
					type = "select",
					disabled = function()
						if ConRO.db.profile._Notifier_Overlay_Alpha then
							return false;
						else
							return true;
						end
					end,
					width = .75,
					order = 54,
					values = _Overlay_Styles,
					style = "dropdown",
					set = function(info,val)
						ConRO.db.profile._Interrupt_Icon_Style = val;
						for k, overlay in pairs(ConRO.InterruptFrames) do
							if overlay ~= nil then
								if ConRO.db.profile._Interrupt_Icon_Style == 1 then
									overlay.texture:SetTexture(ConRO.Textures.Skull);
								elseif ConRO.db.profile._Interrupt_Icon_Style == 2 then
									overlay.texture:SetTexture(ConRO.Textures.Starburst);
								elseif ConRO.db.profile._Interrupt_Icon_Style == 3 then
									overlay.texture:SetTexture(ConRO.Textures.Shield);
								elseif ConRO.db.profile._Interrupt_Icon_Style == 4 then
									overlay.texture:SetTexture(ConRO.Textures.Rage);
								elseif ConRO.db.profile._Interrupt_Icon_Style == 5 then
									overlay.texture:SetTexture(ConRO.Textures.Lightning);
								elseif ConRO.db.profile._Interrupt_Icon_Style == 6 then
									overlay.texture:SetTexture(ConRO.Textures.MagicCircle);
								elseif ConRO.db.profile._Interrupt_Icon_Style == 7 then
									overlay.texture:SetTexture(ConRO.Textures.Plus);
								elseif ConRO.db.profile._Interrupt_Icon_Style == 8 then
									overlay.texture:SetTexture(ConRO.Textures.DoubleArrow);
								elseif ConRO.db.profile._Interrupt_Icon_Style == 9 then
									overlay.texture:SetTexture(ConRO.Textures.KozNicSquare);
								elseif ConRO.db.profile._Interrupt_Icon_Style == 10 then
									overlay.texture:SetTexture(ConRO.Textures.Circle);
								end
							end
						end
					end,
					get = function(info) return ConRO.db.profile._Interrupt_Icon_Style end
				},
				spacer54 = {
					type = "description",
					width = .1,
					name = "\n\n",
					order = 54.5,
				},
				_Interrupt_Alpha_Mode = {
					name = "Alpha",
					desc = "Sets the mode of the interrupt texture alpha.",
					type = "select",
					disabled = function()
						if ConRO.db.profile._Notifier_Overlay_Alpha then
							return false;
						else
							return true;
						end
					end,
					width = .75,
					order = 55,
					values = _Alpha_Modes,
					style = "dropdown",
					set = function(info,val)
						ConRO.db.profile._Interrupt_Alpha_Mode = val;
						for k, overlay in pairs(ConRO.InterruptFrames) do
							if overlay ~= nil then
								if ConRO.db.profile._Interrupt_Alpha_Mode == 1 then
									overlay.texture:SetBlendMode('BLEND');
								elseif ConRO.db.profile._Interrupt_Alpha_Mode == 2 then
									overlay.texture:SetBlendMode('ADD');
								elseif ConRO.db.profile._Interrupt_Alpha_Mode == 3 then
									overlay.texture:SetBlendMode('MOD');
								elseif ConRO.db.profile._Interrupt_Alpha_Mode == 4 then
									overlay.texture:SetBlendMode('ALPHAKEY');
								elseif ConRO.db.profile._Interrupt_Alpha_Mode == 5 then
									overlay.texture:SetBlendMode('DISABLE');
								end
							end
						end
					end,
					get = function(info) return ConRO.db.profile._Interrupt_Alpha_Mode end
				},
				_Purge_Overlay_Color = {
					name = 'Purgable',
					desc = 'Change purge overlays color.',
					type = 'color',
					disabled = function()
						if ConRO.db.profile._Notifier_Overlay_Alpha then
							return false;
						else
							return true;
						end
					end,
					hasAlpha = true,
					width = .75,
					order = 56,
					set = function(info, r, g, b, a)
						local t = ConRO.db.profile._Purge_Overlay_Color;
						t.r, t.g, t.b, t.a = r, g, b, a;
						for k, overlay in pairs(ConRO.PurgableFrames) do
							if overlay ~= nil then
								overlay.texture:SetVertexColor(r, g, b);
								overlay.texture:SetAlpha(a);
							end
						end
					end,
					get = function(info)
						local t = ConRO.db.profile._Purge_Overlay_Color;
						return t.r, t.g, t.b, t.a;
					end
				},
				spacer56 = {
					type = "description",
					width = .1,
					name = "\n\n",
					order = 56.5,
				},
				_Purge_Overlay_Size = {
					name = 'Size',
					desc = 'Sets the scale of the purge overlay texture.',
					type = 'range',
					disabled = function()
						if ConRO.db.profile._Notifier_Overlay_Alpha then
							return false;
						else
							return true;
						end
					end,
					width = .75,
					order = 57,
					min = .5,
					max = 1.5,
					step = .1,
					set = function(info,val)
						ConRO.db.profile._Purge_Overlay_Size = val;
						for k, overlay in pairs(ConRO.PurgableFrames) do
							if overlay ~= nil then
								overlay:SetScale(val);
							end
						end
					end,
					get = function(info) return ConRO.db.profile._Purge_Overlay_Size end
				},
				spacer57 = {
					type = "description",
					width = .1,
					name = "\n\n",
					order = 57.5,
				},
				_Purge_Icon_Style = {
					name = "Style",
					desc = "Sets the style of the purge overlay texture.",
					type = "select",
					disabled = function()
						if ConRO.db.profile._Notifier_Overlay_Alpha then
							return false;
						else
							return true;
						end
					end,
					width = .75,
					order = 58,
					values = _Overlay_Styles,
					style = "dropdown",
					set = function(info,val)
						ConRO.db.profile._Purge_Icon_Style = val;
						for k, overlay in pairs(ConRO.PurgeFrames) do
							if overlay ~= nil then
								if ConRO.db.profile._Purge_Icon_Style == 1 then
									overlay.texture:SetTexture(ConRO.Textures.Skull);
								elseif ConRO.db.profile._Purge_Icon_Style == 2 then
									overlay.texture:SetTexture(ConRO.Textures.Starburst);
								elseif ConRO.db.profile._Purge_Icon_Style == 3 then
									overlay.texture:SetTexture(ConRO.Textures.Shield);
								elseif ConRO.db.profile._Purge_Icon_Style == 4 then
									overlay.texture:SetTexture(ConRO.Textures.Rage);
								elseif ConRO.db.profile._Purge_Icon_Style == 5 then
									overlay.texture:SetTexture(ConRO.Textures.Lightning);
								elseif ConRO.db.profile._Purge_Icon_Style == 6 then
									overlay.texture:SetTexture(ConRO.Textures.MagicCircle);
								elseif ConRO.db.profile._Purge_Icon_Style == 7 then
									overlay.texture:SetTexture(ConRO.Textures.Plus);
								elseif ConRO.db.profile._Purge_Icon_Style == 8 then
									overlay.texture:SetTexture(ConRO.Textures.DoubleArrow);
								elseif ConRO.db.profile._Purge_Icon_Style == 9 then
									overlay.texture:SetTexture(ConRO.Textures.KozNicSquare);
								elseif ConRO.db.profile._Purge_Icon_Style == 10 then
									overlay.texture:SetTexture(ConRO.Textures.Circle);
								end
							end
						end
					end,
					get = function(info) return ConRO.db.profile._Purge_Icon_Style end
				},
				spacer58 = {
					type = "description",
					width = .1,
					name = "\n\n",
					order = 58.5,
				},
				_Purge_Alpha_Mode = {
					name = "Alpha",
					desc = "Sets the mode of the purge texture alpha.",
					type = "select",
					disabled = function()
						if ConRO.db.profile._Notifier_Overlay_Alpha then
							return false;
						else
							return true;
						end
					end,
					width = .75,
					order = 59,
					values = _Alpha_Modes,
					style = "dropdown",
					set = function(info,val)
						ConRO.db.profile._Purge_Alpha_Mode = val;
						for k, overlay in pairs(ConRO.PurgableFrames) do
							if overlay ~= nil then
								if ConRO.db.profile._Purge_Alpha_Mode == 1 then
									overlay.texture:SetBlendMode('BLEND');
								elseif ConRO.db.profile._Purge_Alpha_Mode == 2 then
									overlay.texture:SetBlendMode('ADD');
								elseif ConRO.db.profile._Purge_Alpha_Mode == 3 then
									overlay.texture:SetBlendMode('MOD');
								elseif ConRO.db.profile._Purge_Alpha_Mode == 4 then
									overlay.texture:SetBlendMode('ALPHAKEY');
								elseif ConRO.db.profile._Purge_Alpha_Mode == 5 then
									overlay.texture:SetBlendMode('DISABLE');
								end
							end
						end
					end,
					get = function(info) return ConRO.db.profile._Purge_Alpha_Mode end
				},
				_RaidBuffs_Overlay_Color = {
					name = 'Raid Buffs',
					desc = 'Change raid buffs overlays color.',
					type = 'color',
					disabled = function()
						if ConRO.db.profile._Notifier_Overlay_Alpha then
							return false;
						else
							return true;
						end
					end,
					width = .75,
					hasAlpha = true,
					order = 60,
					set = function(info, r, g, b, a)
						local t = ConRO.db.profile._RaidBuffs_Overlay_Color;
						t.r, t.g, t.b, t.a = r, g, b, a;
						for k, overlay in pairs(ConRO.RaidBuffsFrames) do
							if overlay ~= nil then
								overlay.texture:SetVertexColor(r, g, b);
								overlay.texture:SetAlpha(a);
							end
						end
					end,
					get = function(info)
						local t = ConRO.db.profile._RaidBuffs_Overlay_Color;
						return t.r, t.g, t.b, t.a;
					end
				},
				spacer60 = {
					type = "description",
					width = .1,
					name = "\n\n",
					order = 60.5,
				},
				_RaidBuffs_Overlay_Size = {
					name = 'Size',
					desc = 'Sets the scale of the raid buffs overlay texture.',
					type = 'range',
					disabled = function()
						if ConRO.db.profile._Notifier_Overlay_Alpha then
							return false;
						else
							return true;
						end
					end,
					width = .75,
					order = 61,
					min = .5,
					max = 1.5,
					step = .1,
					set = function(info,val)
						ConRO.db.profile._RaidBuffs_Overlay_Size = val;
						for k, overlay in pairs(ConRO.RaidBuffsFrames) do
							if overlay ~= nil then
								overlay:SetScale(val);
							end
						end
					end,
					get = function(info) return ConRO.db.profile._RaidBuffs_Overlay_Size end
				},
				spacer61 = {
					type = "description",
					width = .1,
					name = "\n\n",
					order = 61.5,
				},
				_RaidBuffs_Icon_Style = {
					name = "Style",
					desc = "Sets the style of the raid buffs overlay texture.",
					type = "select",
					disabled = function()
						if ConRO.db.profile._Notifier_Overlay_Alpha then
							return false;
						else
							return true;
						end
					end,
					width = .75,
					order = 62,
					values = _Overlay_Styles,
					style = "dropdown",
					set = function(info,val)
						ConRO.db.profile._RaidBuffs_Icon_Style = val;
						for k, overlay in pairs(ConRO.RaidBuffsFrames) do
							if overlay ~= nil then
								if ConRO.db.profile._RaidBuffs_Icon_Style == 1 then
									overlay.texture:SetTexture(ConRO.Textures.Skull);
								elseif ConRO.db.profile._RaidBuffs_Icon_Style == 2 then
									overlay.texture:SetTexture(ConRO.Textures.Starburst);
								elseif ConRO.db.profile._RaidBuffs_Icon_Style == 3 then
									overlay.texture:SetTexture(ConRO.Textures.Shield);
								elseif ConRO.db.profile._RaidBuffs_Icon_Style == 4 then
									overlay.texture:SetTexture(ConRO.Textures.Rage);
								elseif ConRO.db.profile._RaidBuffs_Icon_Style == 5 then
									overlay.texture:SetTexture(ConRO.Textures.Lightning);
								elseif ConRO.db.profile._RaidBuffs_Icon_Style == 6 then
									overlay.texture:SetTexture(ConRO.Textures.MagicCircle);
								elseif ConRO.db.profile._RaidBuffs_Icon_Style == 7 then
									overlay.texture:SetTexture(ConRO.Textures.Plus);
								elseif ConRO.db.profile._RaidBuffs_Icon_Style == 8 then
									overlay.texture:SetTexture(ConRO.Textures.DoubleArrow);
								elseif ConRO.db.profile._RaidBuffs_Icon_Style == 9 then
									overlay.texture:SetTexture(ConRO.Textures.KozNicSquare);
								elseif ConRO.db.profile._RaidBuffs_Icon_Style == 10 then
									overlay.texture:SetTexture(ConRO.Textures.Circle);
								end
							end
						end
					end,
					get = function(info) return ConRO.db.profile._RaidBuffs_Icon_Style end
				},
				spacer62 = {
					type = "description",
					width = .1,
					name = "\n\n",
					order = 62.5,
				},
				_RaidBuffs_Alpha_Mode = {
					name = "Alpha",
					desc = "Sets the mode of the raid buffs texture alpha.",
					type = "select",
					disabled = function()
						if ConRO.db.profile._Notifier_Overlay_Alpha then
							return false;
						else
							return true;
						end
					end,
					width = .75,
					order = 63,
					values = _Alpha_Modes,
					style = "dropdown",
					set = function(info,val)
						ConRO.db.profile._RaidBuffs_Alpha_Mode = val;
						for k, overlay in pairs(ConRO.TauntFrames) do
							if overlay ~= nil then
								if ConRO.db.profile._RaidBuffs_Alpha_Mode == 1 then
									overlay.texture:SetBlendMode('BLEND');
								elseif ConRO.db.profile._RaidBuffs_Alpha_Mode == 2 then
									overlay.texture:SetBlendMode('ADD');
								elseif ConRO.db.profile._RaidBuffs_Alpha_Mode == 3 then
									overlay.texture:SetBlendMode('MOD');
								elseif ConRO.db.profile._RaidBuffs_Alpha_Mode == 4 then
									overlay.texture:SetBlendMode('ALPHAKEY');
								elseif ConRO.db.profile._RaidBuffs_Alpha_Mode == 5 then
									overlay.texture:SetBlendMode('DISABLE');
								end
							end
						end
					end,
					get = function(info) return ConRO.db.profile._RaidBuffs_Alpha_Mode end
				},
				_Movement_Overlay_Color = {
					name = 'Movement',
					desc = 'Change movement overlays color.',
					type = 'color',
					disabled = function()
						if ConRO.db.profile._Notifier_Overlay_Alpha then
							return false;
						else
							return true;
						end
					end,
					width = .75,
					hasAlpha = true,
					order = 64,
					set = function(info, r, g, b, a)
						local t = ConRO.db.profile._Movement_Overlay_Color;
						t.r, t.g, t.b, t.a = r, g, b, a;
						for k, overlay in pairs(ConRO.MovementFrames) do
							if overlay ~= nil then
								overlay.texture:SetVertexColor(r, g, b);
								overlay.texture:SetAlpha(a);
							end
						end
					end,
					get = function(info)
						local t = ConRO.db.profile._Movement_Overlay_Color;
						return t.r, t.g, t.b, t.a;
					end
				},
				spacer64 = {
					type = "description",
					width = .1,
					name = "\n\n",
					order = 64.5,
				},
				_Movement_Overlay_Size = {
					name = 'Size',
					desc = 'Sets the scale of the movement overlay texture.',
					type = 'range',
					disabled = function()
						if ConRO.db.profile._Notifier_Overlay_Alpha then
							return false;
						else
							return true;
						end
					end,
					width = .75,
					order = 65,
					min = .5,
					max = 1.5,
					step = .1,
					set = function(info,val)
						ConRO.db.profile._Movement_Overlay_Size = val;
						for k, overlay in pairs(ConRO.MovementFrames) do
							if overlay ~= nil then
								overlay:SetScale(val);
							end
						end
					end,
					get = function(info) return ConRO.db.profile._Movement_Overlay_Size end
				},
				spacer65 = {
					type = "description",
					width = .1,
					name = "\n\n",
					order = 65.5,
				},
				_Movement_Icon_Style = {
					name = "Style",
					desc = "Sets the style of the movement overlay texture.",
					type = "select",
					disabled = function()
						if ConRO.db.profile._Notifier_Overlay_Alpha then
							return false;
						else
							return true;
						end
					end,
					width = .75,
					order = 66,
					values = _Overlay_Styles,
					style = "dropdown",
					set = function(info,val)
						ConRO.db.profile._Movement_Icon_Style = val;
						for k, overlay in pairs(ConRO.MovementFrames) do
							if overlay ~= nil then
								if ConRO.db.profile._Movement_Icon_Style == 1 then
									overlay.texture:SetTexture(ConRO.Textures.Skull);
								elseif ConRO.db.profile._Movement_Icon_Style == 2 then
									overlay.texture:SetTexture(ConRO.Textures.Starburst);
								elseif ConRO.db.profile._Movement_Icon_Style == 3 then
									overlay.texture:SetTexture(ConRO.Textures.Shield);
								elseif ConRO.db.profile._Movement_Icon_Style == 4 then
									overlay.texture:SetTexture(ConRO.Textures.Rage);
								elseif ConRO.db.profile._Movement_Icon_Style == 5 then
									overlay.texture:SetTexture(ConRO.Textures.Lightning);
								elseif ConRO.db.profile._Movement_Icon_Style == 6 then
									overlay.texture:SetTexture(ConRO.Textures.MagicCircle);
								elseif ConRO.db.profile._Movement_Icon_Style == 7 then
									overlay.texture:SetTexture(ConRO.Textures.Plus);
								elseif ConRO.db.profile._Movement_Icon_Style == 8 then
									overlay.texture:SetTexture(ConRO.Textures.DoubleArrow);
								elseif ConRO.db.profile._Movement_Icon_Style == 9 then
									overlay.texture:SetTexture(ConRO.Textures.KozNicSquare);
								elseif ConRO.db.profile._Movement_Icon_Style == 10 then
									overlay.texture:SetTexture(ConRO.Textures.Circle);
								end
							end
						end
					end,
					get = function(info) return ConRO.db.profile._Movement_Icon_Style end
				},
				spacer66 = {
					type = "description",
					width = .1,
					name = "\n\n",
					order = 66.5,
				},
				_Movement_Alpha_Mode = {
					name = "Alpha",
					desc = "Sets the mode of the movement texture alpha.",
					type = "select",
					disabled = function()
						if ConRO.db.profile._Notifier_Overlay_Alpha then
							return false;
						else
							return true;
						end
					end,
					width = .75,
					order = 67,
					values = _Alpha_Modes,
					style = "dropdown",
					set = function(info,val)
						ConRO.db.profile._Movement_Alpha_Mode = val;
						for k, overlay in pairs(ConRO.MovementFrames) do
							if overlay ~= nil then
								if ConRO.db.profile._Movement_Alpha_Mode == 1 then
									overlay.texture:SetBlendMode('BLEND');
								elseif ConRO.db.profile._Movement_Alpha_Mode == 2 then
									overlay.texture:SetBlendMode('ADD');
								elseif ConRO.db.profile._Movement_Alpha_Mode == 3 then
									overlay.texture:SetBlendMode('MOD');
								elseif ConRO.db.profile._Movement_Alpha_Mode == 4 then
									overlay.texture:SetBlendMode('ALPHAKEY');
								elseif ConRO.db.profile._Movement_Alpha_Mode == 5 then
									overlay.texture:SetBlendMode('DISABLE');
								end
							end
						end
					end,
					get = function(info) return ConRO.db.profile._Movement_Alpha_Mode end
				},
			},
		},

--Display Window Settings
		displayWindowSettings = {
			type = "group",
			name = "Display Window Settings",
			order = 22,
			args = {
				enableWindow = {
					name = 'Enable Display Window',
					desc = 'Show movable display window.',
					type = 'toggle',
					width = 'default',
					order = 73,
					set = function(info, val)
						ConRO.db.profile.enableWindow = val;
						if val == true and not ConRO:HealSpec() then
							ConROWindow:Show();
							if ConRO.db.profile.enableNextWindow then
								ConROWindow2:Show();
								ConROWindow3:Show();
							end
						else
							ConROWindow:Hide();
							ConROWindow2:Hide();
							ConROWindow3:Hide();
						end
					end,
					get = function(info) return ConRO.db.profile.enableWindow end
				},
				combatWindow = {
					name = 'Only Display with Hostile',
					desc = 'Show display window only when hostile target selected.',
					type = 'toggle',
					width = 'default',
					order = 74,
					set = function(info, val)
						ConRO.db.profile.combatWindow = val;
						if val == true and not ConRO:HealSpec() then
							ConROWindow:Hide();
							ConROWindow2:Hide();
							ConROWindow3:Hide();
							ConRODefenseWindow:Hide();
						else
							ConROWindow:Show();
							if ConRO.db.profile.enableNextWindow then
								ConROWindow2:Show();
								ConROWindow3:Show();
							end
							if ConRO.db.profile.enableDefenseWindow then
								ConRODefenseWindow:Show();
							end
						end
					end,
					get = function(info) return ConRO.db.profile.combatWindow end
				},
				enableWindowCooldown = {
					name = 'Enable Cooldown Swirl',
					desc = 'Show cooldown swirl on Display Windows. REQUIRES RELOAD',
					type = 'toggle',
					width = 'normal',
					order = 75,
					set = function(info, val)
						ConRO.db.profile.enableWindowCooldown = val;
					end,
					get = function(info) return ConRO.db.profile.enableWindowCooldown end
				},
				enableNextWindow = {
					name = 'Enable Next Windows',
					desc = 'Show movable future spell windowss.',
					type = 'toggle',
					width = 'default',
					order = 75.5,
					set = function(info, val)
						ConRO.db.profile.enableNextWindow = val;
						if val == true then
							ConROWindow2:Show();
							ConROWindow3:Show();
						else
							ConROWindow2:Hide();
							ConROWindow3:Hide();
						end
					end,
					get = function(info) return ConRO.db.profile.enableNextWindow end
				},
				enableWindowSpellName = {
					name = 'Show Spellname',
					desc = 'Show spellname above Display Windows.',
					type = 'toggle',
					width = 'normal',
					order = 76,
					set = function(info, val)
						ConRO.db.profile.enableWindowSpellName = val;
						if val == true then
							ConROWindow.font:Show();
							ConRODefenseWindow.font:Show();
						else
							ConROWindow.font:Hide();
							ConRODefenseWindow.font:Hide();
						end
					end,
					get = function(info) return ConRO.db.profile.enableWindowSpellName end
				},
				enableWindowKeybinds = {
					name = 'Show Keybind',
					desc = 'Show keybinds below Display Windows.',
					type = 'toggle',
					width = 'normal',
					order = 77,
					set = function(info, val)
						ConRO.db.profile.enableWindowKeybinds = val;
						if val == true then
							ConROWindow.fontkey:Show();
							ConROWindow2.fontkey:Show();
							ConROWindow3.fontkey:Show();
							ConRODefenseWindow.fontkey:Show();
						else
							ConROWindow.fontkey:Hide();
							ConROWindow2.fontkey:Hide();
							ConROWindow3.fontkey:Hide();
							ConRODefenseWindow.fontkey:Hide();
						end
					end,
					get = function(info) return ConRO.db.profile.enableWindowKeybinds end
				},
				_Reverse_Direction = {
					name = 'Reverse Direction',
					desc = 'Reverse the direction of the next spell frames.',
					type = 'toggle',
					width = 'normal',
					order = 78,
					set = function(info, val)
						ConRO.db.profile._Reverse_Direction = val;
						if val == true then
							ConRO.db.profile._Reverse_Direction1 = "LEFT";
							ConRO.db.profile._Reverse_Direction2 = "RIGHT";
							ConRO.db.profile._Reverse_Direction3 = 3;
							ConRO.db.profile._Reverse_Direction4 = -5;
							ConROWindow2:ClearAllPoints();
							ConROWindow3:ClearAllPoints();
							ConROInterruptWindow:ClearAllPoints();
							ConROPurgeWindow:ClearAllPoints();
							ConROWindow2:SetPoint("BOTTOM" .. ConRO.db.profile._Reverse_Direction1, ConROWindow, "BOTTOM" .. ConRO.db.profile._Reverse_Direction2, ConRO.db.profile._Reverse_Direction3, 0);
							ConROWindow3:SetPoint("BOTTOM" .. ConRO.db.profile._Reverse_Direction1, ConROWindow2, "BOTTOM" .. ConRO.db.profile._Reverse_Direction2, ConRO.db.profile._Reverse_Direction3, 0);
							ConROInterruptWindow:SetPoint(ConRO.db.profile._Reverse_Direction2, "ConROWindow", "TOP" .. ConRO.db.profile._Reverse_Direction1, ConRO.db.profile._Reverse_Direction4, 0);
							ConROPurgeWindow:SetPoint(ConRO.db.profile._Reverse_Direction2, "ConROWindow", "BOTTOM" .. ConRO.db.profile._Reverse_Direction1, ConRO.db.profile._Reverse_Direction4, 0);
						else
							ConRO.db.profile._Reverse_Direction1 = "RIGHT";
							ConRO.db.profile._Reverse_Direction2 = "LEFT";
							ConRO.db.profile._Reverse_Direction3 = -3;
							ConRO.db.profile._Reverse_Direction4 = 5;
							ConROWindow2:ClearAllPoints();
							ConROWindow3:ClearAllPoints();
							ConROInterruptWindow:ClearAllPoints();
							ConROPurgeWindow:ClearAllPoints();
							ConROWindow2:SetPoint("BOTTOM" .. ConRO.db.profile._Reverse_Direction1, ConROWindow, "BOTTOM" .. ConRO.db.profile._Reverse_Direction2, ConRO.db.profile._Reverse_Direction3, 0);
							ConROWindow3:SetPoint("BOTTOM" .. ConRO.db.profile._Reverse_Direction1, ConROWindow2, "BOTTOM" .. ConRO.db.profile._Reverse_Direction2, ConRO.db.profile._Reverse_Direction3, 0);
							ConROInterruptWindow:SetPoint(ConRO.db.profile._Reverse_Direction2, "ConROWindow", "TOP" .. ConRO.db.profile._Reverse_Direction1, ConRO.db.profile._Reverse_Direction4, 0);
							ConROPurgeWindow:SetPoint(ConRO.db.profile._Reverse_Direction2, "ConROWindow", "BOTTOM" .. ConRO.db.profile._Reverse_Direction1, ConRO.db.profile._Reverse_Direction4, 0);
						end
					end,
					get = function(info) return ConRO.db.profile._Reverse_Direction end
				},
				spacer78 = {
					order = 78.5,
					type = "description",
					width = "double",
					name = "\n\n",
				},
				transparencyWindow = {
					name = 'Window Transparency',
					desc = 'Change transparency of your windows and texts.',
					type = 'range',
					width = 'normal',
					order = 79,
					min = 0,
					max = 1,
					step = 0.01,
					set = function(info, val)
						ConRO.db.profile.transparencyWindow = val;
						ConROWindow:SetAlpha(val);
						ConROWindow2:SetAlpha(val);
						ConROWindow3:SetAlpha(val);
						ConRODefenseWindow:SetAlpha(val);
						ConROInterruptWindow:SetAlpha(val);
						ConROPurgeWindow:SetAlpha(val);
					end,
					get = function(info) return ConRO.db.profile.transparencyWindow end
				},
				windowIconSize = {
					name = 'Display windows Icon size.',
					desc = 'Sets the size of the icon in your display windows. REQUIRES RELOAD',
					type = 'range',
					width = 'normal',
					order = 80,
					min = 20,
					max = 100,
					step = 2,
					set = function(info, val)
						ConRO.db.profile.windowIconSize = val;
					end,
					get = function(info) return ConRO.db.profile.windowIconSize end
				},
				flashIconSize = {
					name = 'Flasher Icon size.',
					desc = 'Sets the size of the icon that flashes for Interrupts and Purges.',
					type = 'range',
					width = 'normal',
					order = 81,
					min = 20,
					max = 100,
					step = 2,
					set = function(info, val)
						ConRO.db.profile.flashIconSize = val;
						ConROInterruptWindow:SetSize(ConRO.db.profile.flashIconSize * .25, ConRO.db.profile.flashIconSize * .25);
						ConROPurgeWindow:SetSize(ConRO.db.profile.flashIconSize * .25, ConRO.db.profile.flashIconSize * .25);
					end,
					get = function(info) return ConRO.db.profile.flashIconSize end
				},
				enableDefenseWindow = {
					name = 'Enable Defense Window',
					desc = 'Show movable defense window.',
					type = 'toggle',
					width = 'default',
					order = 82,
					set = function(info, val)
						ConRO.db.profile.enableDefenseWindow = val;
						if val == true then
							ConRODefenseWindow:Show();
						else
							ConRODefenseWindow:Hide();
						end
					end,
					get = function(info) return ConRO.db.profile.enableDefenseWindow end
				},
				enableInterruptWindow = {
					name = 'Enable Interrupt Icon',
					desc = 'Show movable interrupt icon.',
					type = 'toggle',
					width = 'default',
					order = 83,
					set = function(info, val)
						ConRO.db.profile.enableInterruptWindow = val;
						if val == true and ConRO.db.profile._Unlock_ConRO == true then
							ConROInterruptWindow:Show();
						else
							ConROInterruptWindow:Hide();
						end
					end,
					get = function(info) return ConRO.db.profile.enableInterruptWindow end
				},
				enablePurgeWindow = {
					name = 'Enable Purge Icon',
					desc = 'Show movable purge icon.',
					type = 'toggle',
					width = 'default',
					order = 84,
					set = function(info, val)
						ConRO.db.profile.enablePurgeWindow = val;
						if val == true and ConRO.db.profile._Unlock_ConRO == true then
							ConROPurgeWindow:Show();
						else
							ConROPurgeWindow:Hide();
						end
					end,
					get = function(info) return ConRO.db.profile.enablePurgeWindow end
				},
				spacer84 = {
					order = 85,
					type = "description",
					width = "normal",
					name = "\n\n",
				},
			},
		},

--Toggle Button Settings
		toggleButtonSettings = {
			type = "group",
			name = "Toggle Buttons",
			order = 23,
			args = {
				_Hide_Toggle = {
					name = "Hide Toggle Button",
					desc = "Hides toggle buttons from view, but they are still operational.",
					type = "toggle",
					width = "normal",
					order = 10,
					set = function(info, val)
						ConRO.db.profile._Hide_Toggle = val;
						if val == true then
							ConROButtonFrame:SetAlpha(0);
						else
							ConROButtonFrame:SetAlpha(1);
						end
					end,
					get = function(info) return ConRO.db.profile._Hide_Toggle end
				},
				toggleButtonSize = {
					name = "Toggle Button Size",
					desc = "Sets the scale of the toggle buttons.",
					type = "range",
					width = "normal",
					order = 11,
					min = 1,
					max = 2,
					step = .1,
					set = function(info,val)
					ConRO.db.profile.toggleButtonSize = val
					ConROButtonFrame:SetScale(ConRO.db.profile.toggleButtonSize)
					end,
					get = function(info) return ConRO.db.profile.toggleButtonSize end
				},
				toggleButtonOrientation = {
					name = "Toggle Button Orientation",
					desc = "Sets the orientation of the button for the toggle buttons.",
					type = "select",
					width = "normal",
					order = 12,
					values = orientations,
					style = "dropdown",
					set = function(info,val)
						ConRO.db.profile.toggleButtonOrientation = val
						local vert = 2;
						local hori = 1;
							if val == 1 then
								vert = 2;
								hori = 1;
							elseif val == 2 then
								vert = 1;
								hori = 2;
							end
						ConROButtonFrame:SetSize((40 * hori) + 14, (15 * vert) + 14)

					end,
					get = function(info) return ConRO.db.profile.toggleButtonOrientation end
				},
				_Spacer_Toggle_20 = {
					order = 20,
					type = "description",
					width = "full",
					name = "\n\n",
				},
				_Burst_Settings = {
					type = "header",
					name = "Burst Settings",
					order = 21,
				},
				_Burst_Threshold = {
					name = "Burst Threshold",
					desc = "Sets the burst mode threshold in seconds.",
					type = "range",
					width = "normal",
					order = 22,
					min = 45,
					max = 180,
					step = 5,
					set = function(info,val)
					ConRO.db.profile._Burst_Threshold = val
					end,
					get = function(info) return ConRO.db.profile._Burst_Threshold end
				},
			},
		},

--Reset Buttons
		reloadButton = {
			name = "ReloadUI",
			desc = "Reloads UI after making changes that need it.",
			type = "execute",
			width = "normal",
			order = 31,
			func = function(info)
				ReloadUI();
			end
		},
		resetExtraWindows = {
			name = "Reset Positions",
			desc = "Reset ConRO UI positions back to default. RELOAD REQUIRED",
			type = "execute",
			width = "normal",
			order = 32,
			confirm = true,
			func = function(info)
				ConROButtonFrame:SetUserPlaced(false);
				ConROWindow:SetUserPlaced(false);
				ConRODefenseWindow:SetUserPlaced(false);
				ConROInterruptWindow:SetUserPlaced(false);
				ConROPurgeWindow:SetUserPlaced(false);
				ReloadUI();
			end
		},
		resetButton = {
			name = "Reset Settings",
			desc = "Resets ConRO option settings back to default. RELOAD REQUIRED",
			type = "execute",
			width = "normal",
			order = 33,
			confirm = true,
			func = function(info)
				ConRO.db:ResetProfile();
				ReloadUI();
			end
		},
	},
}

function ConRO:GetTexture()
	if self.db.profile.customTexture ~= '' and self.db.profile.customTexture ~= nil then
		self.FinalTexture = self.db.profile.customTexture;
		return self.FinalTexture;
	end

	self.FinalTexture = self.Textures[self.db.profile.texture];
	if self.FinalTexture == '' or self.FinalTexture == nil then
		self.FinalTexture = 'Interface\\Cooldown\\ping4';
	end

	return self.FinalTexture;
end

function ConRO:OnInitialize()
	LibStub('AceConfig-3.0'):RegisterOptionsTable('Conflict Rotation Optimizer', options, {'conflictrotationoptimizer'});
	self.db = LibStub('AceDB-3.0'):New('ConROPreferences', defaultOptions);
	self.optionsFrame = LibStub('AceConfigDialog-3.0'):AddToBlizOptions('Conflict Rotation Optimizer', 'ConRO');
	self:DisplayWindowFrame();
	self:DefenseWindowFrame();
	self:InterruptWindowFrame();
	self:PurgeWindowFrame();
	self:DisplayToggleFrame();
	self:CreateAutoButton();
	self:CreateSingleButton();
	self:CreateAoEButton();
	self:CreateBurstButton();
	self:CreateFullButton();
	self:CreatePvPButton();
	self:CreateBlockBurstButton();
	self:CreateBlockAoEButton();
end

ConRO.DefaultPrint = ConRO.Print;
function ConRO:Print(...)
	if self.db.profile._Disable_Info_Messages then
		return;
	end
	ConRO:DefaultPrint(...);
end

function ConRO:EnableRotation()
	if self.NextSpell == nil or self.rotationEnabled then
		self:Print(self.Colors.Error .. 'Failed to enable addon!');
		return;
	end

	self:Fetch();
	self:CheckTalents();
	self:CheckPvPTalents();

	if self.ModuleOnEnable then
		self.ModuleOnEnable();
	end

	self:EnableRotationTimer();
	self.rotationEnabled = true;
end

function ConRO:EnableDefense()
	if self.NextDef == nil or self.defenseEnabled then
		self:Print(self.Colors.Error .. 'Failed to enable defense module!');
		return;
	end

	self:FetchDef();
	self:CheckTalents();
	self:CheckPvPTalents();

	if self.ModuleOnEnable then
		self.ModuleOnEnable();
	end

	self:EnableDefenseTimer();
	self.defenseEnabled = true;
end

function ConRO:EnableRotationTimer()
	self.RotationTimer = self:ScheduleRepeatingTimer('InvokeNextSpell', self.db.profile._Intervals);
end

function ConRO:EnableDefenseTimer()
	self.DefenseTimer = self:ScheduleRepeatingTimer('InvokeNextDef', self.db.profile._Intervals);
end

function ConRO:DisableRotation()
	if not self.rotationEnabled then
		return;
	end
	--self:Print(self.Colors.Success .. 'Disabled Rotation.');
	self:DisableRotationTimer();

	self:DestroyDamageOverlays();
	self:DestroyInterruptOverlays();
	self:DestroyCoolDownOverlays();
	self:DestroyPurgableOverlays();
	self:DestroyRaidBuffsOverlays();
	self:DestroyMovementOverlays();
	self:DestroyTauntOverlays();

	self.Spell = nil;
	self.rotationEnabled = false;
end

function ConRO:DisableDefense()
	if not self.defenseEnabled then
		return;
	end
--	self:Print(self.Colors.Success .. 'Disabled Defense.');
	self:DisableDefenseTimer();

	self:DestroyDefenseOverlays();

	self.Def = nil;
	self.defenseEnabled = false;
end

function ConRO:DisableRotationTimer()
	if self.RotationTimer then
		self:CancelTimer(self.RotationTimer);
	end
end

function ConRO:DisableDefenseTimer()
	if self.DefenseTimer then
		self:CancelTimer(self.DefenseTimer);
	end
end

function ConRO:OnEnable()
	self:RegisterEvent('PLAYER_TARGET_CHANGED');
	self:RegisterEvent('ACTIVE_PLAYER_SPECIALIZATION_CHANGED');
	self:RegisterEvent('ACTIVE_COMBAT_CONFIG_CHANGED');
	self:RegisterEvent('TRAIT_CONFIG_UPDATED');
	self:RegisterEvent('ACTIONBAR_SLOT_CHANGED');
	self:RegisterEvent('PLAYER_REGEN_DISABLED');
	self:RegisterEvent('PLAYER_REGEN_ENABLED');
	self:RegisterEvent('PLAYER_ENTERING_WORLD');
	self:RegisterEvent('PLAYER_LEAVING_WORLD');
	self:RegisterEvent('UPDATE_SHAPESHIFT_FORM');
	self:RegisterEvent('UPDATE_STEALTH');
	self:RegisterEvent('LOADING_SCREEN_ENABLED');
	self:RegisterEvent('LOADING_SCREEN_DISABLED');
	self:RegisterEvent('ACTIONBAR_HIDEGRID');
	self:RegisterEvent('PLAYER_MOUNT_DISPLAY_CHANGED');
	self:RegisterEvent('ACTIONBAR_PAGE_CHANGED');
	self:RegisterEvent('LEARNED_SPELL_IN_TAB');
	self:RegisterEvent('CHARACTER_POINTS_CHANGED');
	self:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED');
	self:RegisterEvent('PLAYER_SPECIALIZATION_CHANGED');
	self:RegisterEvent('UPDATE_MACROS');
	
	self:RegisterEvent('VEHICLE_UPDATE');
	self:RegisterEvent('UNIT_ENTERED_VEHICLE');
	self:RegisterEvent('UNIT_EXITED_VEHICLE');

	self:RegisterEvent('PLAYER_CONTROL_LOST');
	self:RegisterEvent('PLAYER_CONTROL_GAINED');

	self:RegisterEvent('PET_BATTLE_OPENING_START');
	self:RegisterEvent('PET_BATTLE_OVER');

	self:Print(self.Colors.Info .. 'Initialized');
end

function ConRO:ACTIVE_PLAYER_SPECIALIZATION_CHANGED()
--self:Print(self.Colors.Success .. 'Talent');
	C_Timer.After(2, function()
		self:DisableRotation();
		self:DisableDefense();
		self:LoadModule();
		self:EnableRotation();
		self:EnableDefense();

		if ConRO:HealSpec() then
			ConROWindow:Hide();
			ConROWindow2:Hide();
			ConROWindow3:Hide();
		elseif ConRO.db.profile.enableWindow and not ConRO.db.profile.combatWindow then
			ConROWindow:Show();
			if ConRO.db.profile.enableNextWindow then
				ConROWindow2:Show();
				ConROWindow3:Show();
			end
		else
			ConROWindow:Hide();
			ConROWindow2:Hide();
			ConROWindow3:Hide();
		end

		ConRO:ButtonFetch()
	end);
end

function ConRO:ACTIVE_COMBAT_CONFIG_CHANGED()
	--self:Print(self.Colors.Success .. 'Talent');
	C_Timer.After(2, function()
		self:DisableRotation();
		self:DisableDefense();
		self:LoadModule();
		self:EnableRotation();
		self:EnableDefense();

		if ConRO:HealSpec() then
			ConROWindow:Hide();
			ConROWindow2:Hide();
			ConROWindow3:Hide();
		elseif ConRO.db.profile.enableWindow and not ConRO.db.profile.combatWindow then
			ConROWindow:Show();
			if ConRO.db.profile.enableNextWindow then
				ConROWindow2:Show();
				ConROWindow3:Show();
			end
		else
			ConROWindow:Hide();
			ConROWindow2:Hide();
			ConROWindow3:Hide();
		end

		ConRO:ButtonFetch()
	end);
end

function ConRO:PLAYER_SPECIALIZATION_CHANGED()
	--self:Print(self.Colors.Success .. 'Talent');
	C_Timer.After(1, function()
		self:DisableRotation();
		self:DisableDefense();
		self:LoadModule();
		self:EnableRotation();
		self:EnableDefense();

		if ConRO:HealSpec() then
			ConROWindow:Hide();
			ConROWindow2:Hide();
			ConROWindow3:Hide();
		elseif ConRO.db.profile.enableWindow and not ConRO.db.profile.combatWindow then
			ConROWindow:Show();
			if ConRO.db.profile.enableNextWindow then
				ConROWindow2:Show();
				ConROWindow3:Show();
			end
		else
			ConROWindow:Hide();
			ConROWindow2:Hide();
			ConROWindow3:Hide();
		end

		ConRO:ButtonFetch()
	end);
end

function ConRO:TRAIT_CONFIG_UPDATED()
--self:Print(self.Colors.Success .. 'Talent');
	C_Timer.After(1, function()
		self:DisableRotation();
		self:DisableDefense();
		self:LoadModule();
		self:EnableRotation();
		self:EnableDefense();
		self:UpdateButtonGlow();

		if ConRO:HealSpec() then
			ConROWindow:Hide();
			ConROWindow2:Hide();
			ConROWindow3:Hide();
		elseif ConRO.db.profile.enableWindow and not ConRO.db.profile.combatWindow then
			ConROWindow:Show();
			if ConRO.db.profile.enableNextWindow then
				ConROWindow2:Show();
				ConROWindow3:Show();
			end
		else
			ConROWindow:Hide();
			ConROWindow2:Hide();
			ConROWindow3:Hide();
		end

		ConRO:ButtonFetch()
	end);
end

function ConRO:ACTIONBAR_HIDEGRID()
	if self.rotationEnabled then
		if self.fetchTimer then
			self:CancelTimer(self.fetchTimer);
			self:CancelTimer(self.fetchdefTimer);
		end
		self.fetchTimer = self:ScheduleTimer('Fetch', 0.5);
		self.fetchdefTimer = self:ScheduleTimer('FetchDef', 0.5);
	end

	self:DestroyInterruptOverlays();
	self:DestroyCoolDownOverlays();
	self:DestroyPurgableOverlays();
	self:DestroyRaidBuffsOverlays();
	self:DestroyMovementOverlays();
	self:DestroyTauntOverlays();
end

function ConRO:PLAYER_MOUNT_DISPLAY_CHANGED()
	C_Timer.After(1, function()
		if ConRO:Dragonriding() and self.ModuleLoaded then
			self:DisableRotation();
			self:DisableDefense();
		end

		if not ConRO:Dragonriding() then
			self:DisableRotation();
			self:DisableDefense();
			self:EnableRotation();
			self:EnableDefense();
		end
	end);
end

function ConRO:UNIT_ENTERED_VEHICLE(event, unit)
--	self:Print(self.Colors.Success .. 'Vehicle!');
	if unit == 'player' and self.ModuleLoaded then
		self:DisableRotation();
		self:DisableDefense();
	end
end

function ConRO:UNIT_EXITED_VEHICLE(event, unit)
--self:Print(self.Colors.Success .. 'Vehicle!');
	if unit == 'player' then
		self:DisableRotation();
		self:DisableDefense();
		self:EnableRotation();
		self:EnableDefense();
	end
end

function ConRO:PET_BATTLE_OPENING_START()
--	self:Print(self.Colors.Success .. 'Pet Battle Started!');

	self:DisableRotation();
	self:DisableDefense();
	ConROWindow:Hide();
	ConROWindow2:Hide();
	ConROWindow3:Hide();
	ConRODefenseWindow:Hide();
end

function ConRO:PET_BATTLE_OVER()
--	self:Print(self.Colors.Success .. 'Pet Battle Over!');

	self:DisableRotation();
	self:DisableDefense();
	self:EnableRotation();
	self:EnableDefense();

	if ConRO.db.profile.enableWindow and (ConRO.db.profile.combatWindow or ConRO:HealSpec()) and ConRO:TarHostile() then
		ConROWindow:Show();
		if ConRO.db.profile.enableNextWindow then
			ConROWindow2:Show();
			ConROWindow3:Show();
		end
	elseif ConRO.db.profile.enableWindow and not (ConRO.db.profile.combatWindow or ConRO:HealSpec()) then
		ConROWindow:Show();
		if ConRO.db.profile.enableNextWindow then
			ConROWindow2:Show();
			ConROWindow3:Show();
		end
	else
		ConROWindow:Hide();
		ConROWindow2:Hide();
		ConROWindow3:Hide();
	end

	if ConRO.db.profile.enableDefenseWindow and ConRO.db.profile.combatWindow and ConRO:TarHostile() then
		ConRODefenseWindow:Show();
	elseif ConRO.db.profile.enableDefenseWindow and not ConRO.db.profile.combatWindow then
		ConRODefenseWindow:Show();
	else
		ConRODefenseWindow:Hide();
	end
end

function ConRO:PLAYER_CONTROL_LOST()
--	self:Print(self.Colors.Success .. 'Lost Control!');
	self:DisableRotation();
	self:DisableDefense();
end

function ConRO:PLAYER_CONTROL_GAINED()
	if not C_PetBattles.IsInBattle() then
--		self:Print(self.Colors.Success .. 'Control Gained!');
		self:DisableRotation();
		self:DisableDefense();
		self:EnableRotation();
		self:EnableDefense();
	end
end

function ConRO:PLAYER_LEAVING_WORLD()
	--	self:Print(self.Colors.Success .. 'Lost Control!');
	self:DisableRotation();
	self:DisableDefense();
end

function ConRO:PLAYER_ENTERING_WORLD()
	C_Timer.After(3, function()
		self:UpdateButtonGlow();
		if not self.rotationEnabled and not UnitHasVehicleUI("player") then
			self:Print(self.Colors.Success .. 'Auto enable on login!');
			self:Print(self.Colors.Info .. 'Loading class module');
			self:LoadModule();
			self:EnableRotation()
			self:EnableDefense();
		end
	end);
end

function ConRO:LOADING_SCREEN_ENABLED()
	--	self:Print(self.Colors.Success .. 'Lost Control!');
	self:DisableRotation();
	self:DisableDefense();
end

function ConRO:LOADING_SCREEN_DISABLED()
	C_Timer.After(3, function()
		self:UpdateButtonGlow();
		if not self.rotationEnabled and not UnitHasVehicleUI("player") then
			self:Print(self.Colors.Success .. 'Auto enable on login!');
			self:Print(self.Colors.Info .. 'Loading class module');
			self:LoadModule();
			self:EnableRotation();
			self:EnableDefense();
		end
	end);
end

function ConRO:PLAYER_TARGET_CHANGED()
--	self:Print(self.Colors.Success .. 'Target Changed!');

	if self.rotationEnabled then
		if ConRO.db.profile.enableWindow then
			if (ConRO.db.profile.combatWindow or ConRO:HealSpec()) and not ConRO:TarHostile() then
				ConROWindow:Hide();
				ConROWindow2:Hide();
				ConROWindow3:Hide();
			else
				ConROWindow:Show();
				if ConRO.db.profile.enableNextWindow then
					ConROWindow2:Show();
					ConROWindow3:Show();
				end
			end
		else
			ConROWindow:Hide();
			ConROWindow2:Hide();
			ConROWindow3:Hide();
		end

		if (UnitIsFriend('player', 'target')) then
			return;
		else
			self:DestroyInterruptOverlays();
			self:DestroyPurgableOverlays();
			self:InvokeNextSpell();
			self:InvokeNextDef();
		end
	end
end

function ConRO:PLAYER_REGEN_DISABLED()
	C_Timer.After(1, function()
		self:UpdateButtonGlow();
		if not self.rotationEnabled and not UnitHasVehicleUI("player") and not ConRO:Dragonriding() then
			self:LoadModule();
			self:EnableRotation();
			self:EnableDefense();
		end
	end);
end

function ConRO:ACTIONBAR_SLOT_CHANGED()
	self:UpdateButtonGlow();
	ConRO:ButtonFetch()
end

function ConRO:UPDATE_MACROS()
	self:UpdateButtonGlow();
	ConRO:ButtonFetch()
end

function ConRO:ButtonFetch()
	if self.rotationEnabled then
		if self.fetchTimer then
			self:CancelTimer(self.fetchTimer);
			self:CancelTimer(self.fetchdefTimer);
		end
		self.fetchTimer = self:ScheduleTimer('Fetch', 0.5);
		self.fetchdefTimer = self:ScheduleTimer('FetchDef', 0.5);
	end
end

ConRO.PLAYER_REGEN_ENABLED = ConRO.ButtonFetch;
ConRO.ACTIONBAR_PAGE_CHANGED = ConRO.ButtonFetch;
ConRO.UPDATE_SHAPESHIFT_FORM = ConRO.ButtonFetch;
ConRO.UPDATE_STEALTH = ConRO.ButtonFetch;
ConRO.LEARNED_SPELL_IN_TAB = ConRO.ButtonFetch;
ConRO.CHARACTER_POINTS_CHANGED = ConRO.ButtonFetch;
ConRO.ACTIVE_TALENT_GROUP_CHANGED = ConRO.ButtonFetch;
ConRO.VEHICLE_UPDATE = ConRO.ButtonFetch;

function ConRO:InvokeNextSpell()
	local oldSkill = self.Spell;

	local timeShift, currentSpell, gcd = ConRO:EndCast();
	local iterate = self:NextSpell(timeShift, currentSpell, gcd, self.PlayerTalents, self.PvPTalents);
	self.Spell = self.SuggestedSpells[1];

	ConRO:GetTimeToDie();
--	ConRO:UpdateRotation();
--	ConRO:UpdateButtonGlow();

	local spellName, spellTexture;
	-- Get info for the first suggested spell
	if self.Spell then
		if type(self.Spell) == "string" then
			self.Spell = tonumber(self.Spell)
			spellName, _, _, _, _, _, _, _, _, spellTexture = GetItemInfo(self.Spell);
		else
			local spellInfo1 = C_Spell.GetSpellInfo(self.Spell);
			spellName = spellInfo1 and spellInfo1.name;
			spellTexture = spellInfo1 and spellInfo1.originalIconID;
		end
	end

	local spellTexture2;
	-- Get info for the second suggested spell, only if it exists
	if self.SuggestedSpells[2] then
		if type(self.SuggestedSpells[2]) == "string" then
			spell_2 = tonumber(self.SuggestedSpells[2])
			_, _, _, _, _, _, _, _, _, spellTexture2 = GetItemInfo(self.SuggestedSpells[2]);
		else
			local spellInfo2 = C_Spell.GetSpellInfo(self.SuggestedSpells[2]);
			spellTexture2 = spellInfo2 and spellInfo2.originalIconID;
		end
	end

	local spellTexture3;
	-- Get info for the third suggested spell, only if it exists
	if self.SuggestedSpells[3] then
		if type(self.SuggestedSpells[3]) == "string" then
			spell_3 = tonumber(self.SuggestedSpells[3])
			_, _, _, _, _, _, _, _, _, spellTexture3 = GetItemInfo(self.SuggestedSpells[3]);
		else
			local spellInfo3 = C_Spell.GetSpellInfo(self.SuggestedSpells[3]);
			spellTexture3 = spellInfo3 and spellInfo3.originalIconID;
		end
	end

	if (oldSkill ~= self.Spell or oldSkill == nil) and self.Spell ~= nil then
		self:GlowNextSpell(self.Spell);
		ConROWindow.fontkey:SetText(ConRO:improvedGetBindingText(ConRO:FindKeybinding(self.Spell)));
		ConROWindow2.fontkey:SetText(ConRO:improvedGetBindingText(ConRO:FindKeybinding(self.SuggestedSpells[2])));
		ConROWindow3.fontkey:SetText(ConRO:improvedGetBindingText(ConRO:FindKeybinding(self.SuggestedSpells[3])));
		if spellName ~= nil then
			ConROWindow.texture:SetTexture(spellTexture);
			ConROWindow.font:SetText(spellName);
			ConROWindow2.texture:SetTexture(spellTexture2);
			ConROWindow3.texture:SetTexture(spellTexture3);
		else
			local itemName, _, _, _, _, _, _, _, _, itemTexture = GetItemInfo(self.Spell);
			local _, _, _, _, _, _, _, _, _, itemTexture2 = GetItemInfo(self.SuggestedSpells[2]);
			local _, _, _, _, _, _, _, _, _, itemTexture3 = GetItemInfo(self.SuggestedSpells[3]);
			ConROWindow.texture:SetTexture(itemTexture);
			ConROWindow.font:SetText(itemName);
			ConROWindow2.texture:SetTexture(itemTexture2);
			ConROWindow3.texture:SetTexture(itemTexture3);
		end
	end

	if self.Spell == nil and oldSkill ~= nil then
		self:GlowClear();
		ConROWindow.texture:SetTexture('Interface\\AddOns\\ConRO\\images\\Bigskull');
		ConROWindow.font:SetText(" ");
		ConROWindow.fontkey:SetText(" ");
		ConROWindow2.texture:SetTexture('Interface\\AddOns\\ConRO\\images\\Bigskull');
		ConROWindow2.fontkey:SetText(" ");
		ConROWindow3.texture:SetTexture('Interface\\AddOns\\ConRO\\images\\Bigskull');
		ConROWindow3.fontkey:SetText(" ");
	end
end

function ConRO:InvokeNextDef()
	local oldSkill = self.Def;

	local timeShift, currentSpell, gcd = ConRO:EndCast();

	local iterateDef = self:NextDef(timeShift, currentSpell, gcd, self.PlayerTalents, self.PvPTalents);
	self.Def = self.SuggestedDefSpells[1];

	local spellName, spellTexture;
	if self.Def then
		local spellInfo = C_Spell.GetSpellInfo(self.Def);
		if spellInfo then
			spellName = spellInfo.name;
			spellTexture = spellInfo.originalIconID;
		end
	end
	local color = ConRO.db.profile._Defense_Overlay_Color;

	if (oldSkill ~= self.Def or oldSkill == nil) and self.Def ~= nil then
		self:GlowNextDef(self.Def);
		ConRODefenseWindow.texture:SetVertexColor(1, 1, 1);
		ConRODefenseWindow.fontkey:SetText(ConRO:improvedGetBindingText(ConRO:FindKeybinding(self.Def)));
		if spellName ~= nil then
			ConRODefenseWindow.texture:SetTexture(spellTexture);
			ConRODefenseWindow.font:SetText(spellName);
		else
			local itemName, _, _, _, _, _, _, _, _, itemTexture = GetItemInfo(self.Def);
			ConRODefenseWindow.texture:SetTexture(itemTexture);
			ConRODefenseWindow.font:SetText(itemName);
		end
	end

	if self.Def == nil and oldSkill ~= nil then
		self:GlowClearDef();
		ConRODefenseWindow.texture:SetTexture('Interface\\AddOns\\ConRO\\images\\shield2');
		ConRODefenseWindow.texture:SetVertexColor(color.r, color.g, color.b);
		ConRODefenseWindow.font:SetText(" ");
		ConRODefenseWindow.fontkey:SetText(" ");
	end
end

function ConRO:LoadModule()
	local _, _, classId = UnitClass('player');
		if self.Classes[classId] == nil then
			self:Print(self.Colors.Error, 'Invalid player class, please contact author of addon.');
			return;
		end

	local module = 'ConRO_' .. self.Classes[classId];
	local _, _, _, loadable, reason = C_AddOns.GetAddOnInfo(module);

	if C_AddOns.IsAddOnLoaded(module) then
		local mode = ConRO:CheckSpecialization();

		self:EnableRotationModule(mode);
		self:EnableDefenseModule(mode);
		return;
	end

	if reason == 'MISSING' or reason == 'DISABLED' then
		self:Print(self.Colors.Error .. 'Could not find class module ' .. module .. ', reason: ' .. reason);
		return;
	end

	C_AddOns.LoadAddOn(module)

	local mode = ConRO:CheckSpecialization();

	self:InitTTD();
	self:EnableRotationModule(mode);
	self:EnableDefenseModule(mode);
	self:Print(self.Colors[classId] .. self.Description);

	self:Print(self.Colors.Info .. 'Finished Loading class module');
	self.ModuleLoaded = true;
end

function ConRO:CheckSpecialization()
	local mode = GetSpecialization();
	local _Player_Level = UnitLevel("player");
		if _Player_Level <= 9 then
			mode = 0;
		end
		if mode == nil then
			mode = 0;
		elseif mode >= 5 then
			mode = 0;
		end

	return mode;
end

function ConRO:HealSpec()
	local _, _, classId = UnitClass('player');
	local specId = ConRO:CheckSpecialization();
	--[[[1] = 'Warrior',
		[2] = 'Paladin',
		[3] = 'Hunter',
		[4] = 'Rogue',
		[5] = 'Priest',
		[6] = 'DeathKnight',
		[7] = 'Shaman',
		[8] = 'Mage',
		[9] = 'Warlock',
		[10] = 'Monk',
		[11] = 'Druid',
		[12] = 'DemonHunter',
		[13] = 'Evoker']]

	if (classId == 2 and specId == 1) or
	(classId == 5 and specId == 2) or
	(classId == 7 and specId == 3) or
	(classId == 10 and specId == 2) or
	(classId == 11 and specId == 4)	or
	(classId == 13 and specId == 2) then
		return true;
	end
	return false;
end
