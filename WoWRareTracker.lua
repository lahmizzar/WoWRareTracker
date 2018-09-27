WoWRareTracker = LibStub("AceAddon-3.0"):NewAddon("WoWRareTracker", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")
local ldb = LibStub:GetLibrary("LibDataBroker-1.1");
local minimapicon = LibStub("LibDBIcon-1.0")

local L = LibStub("AceLocale-3.0"):GetLocale("WoWRareTracker")

local LibQTip = LibStub("LibQTip-1.0")
local tooltip;

local npcToolTip = CreateFrame("GameTooltip", "__WoWRareTracker_ScanTip", nil, "GameTooltipTemplate")
npcToolTip:SetOwner(WorldFrame, "ANCHOR_NONE")
local _G = _G
WoWRareTracker.WRT = {}
local WRT = WoWRareTracker.WRT

---------------
-- INITIAL VARS
---------------
WRT.version = "0.5.0beta"

WRT.rares = {
    [138122] = { name = L["rare_dooms_howl"], 				lvl = "??+",	id = 138122, questId = { 53002 }, 			wfcontrol = "a",	type = "WorldBoss", 	drop = "Toy", 		itemID = 163828, 	faction = "alliance", 	coord = 38513986,    coordEntry = "",    coordEntryText = "",    notes = "",                   sort = 1,	isKnown = false }, -- 
    [137374] = { name = L["rare_the_lions_roar"], 			lvl = "??+",	id = 137374, questId = { 52848 }, 			wfcontrol = "h",	type = "WorldBoss", 	drop = "Toy", 		itemID = 163829, 	faction = "horde", 		coord = 30155960,    coordEntry = "",    coordEntryText = "",    notes = "",                   sort = 2,	isKnown = false }, -- checked, Drop ??%
    [141618] = { name = L["rare_cresting_goliath"], 		lvl = "122+",	id = 141618, questId = { 53018, 53531 }, 	wfcontrol = "0",	type = "Elite", 		drop = "Item", 		itemID = 163700, 	faction = "all", 		coord = 62083145,    coordEntry = "",    coordEntryText = "",    notes = "",                   sort = 3,	isKnown = false }, -- checked, Drop 100%
    [141615] = { name = L["rare_burning_goliath"], 			lvl = "122+",	id = 141615, questId = { 53017, 53506 }, 	wfcontrol = "0",	type = "Elite", 		drop = "Item", 		itemID = 163691, 	faction = "all", 		coord = 30604475,    coordEntry = "",    coordEntryText = "",    notes = "",                   sort = 4,	isKnown = false }, -- checked, Drop 100%
    [141620] = { name = L["rare_rumbling_goliath"], 		lvl = "122+",	id = 141620, questId = { 53021, 53523 }, 	wfcontrol = "0",	type = "Elite", 		drop = "Item", 		itemID = 163701, 	faction = "all", 		coord = 29815989,    coordEntry = "",    coordEntryText = "",    notes = "",                   sort = 5,	isKnown = false }, -- checked, Drop 100%
    [141616] = { name = L["rare_thundering_goliath"], 		lvl = "122+",	id = 141616, questId = { 53023, 53527 }, 	wfcontrol = "0",	type = "Elite", 		drop = "Item", 		itemID = 163698, 	faction = "all", 		coord = 46305217,    coordEntry = "",    coordEntryText = "",    notes = "",                   sort = 6,	isKnown = false }, -- checked, Drop 100%
    [142709] = { name = L["rare_beastrider_kama"], 			lvl = "121+",	id = 142709, questId = { 53083, 53504 }, 	wfcontrol = "0",	type = "Rare", 			drop = "Mount", 	itemID = 163644, 	faction = "all",		coord = 65427090,    coordEntry = "",    coordEntryText = "",    notes = "",  mountID = 1180,  sort = 7,	isKnown = false }, -- chekced, Drop 3,12%
    [142692] = { name = L["rare_nimar_the_slayer"], 		lvl = "121+",	id = 142692, questId = { 53091, 53517 }, 	wfcontrol = "0",	type = "Rare", 			drop = "Mount", 	itemID = 163706, 	faction = "all", 		coord = 67606078,    coordEntry = "",    coordEntryText = "",    notes = "",  mountID = 1185,  sort = 8,	isKnown = false }, -- checked, Drop ??%
    [142423] = { name = L["rare_overseer_krix"], 			lvl = "122+",	id = 142423, questId = { 53014, 53518 }, 	wfcontrol = "0",	type = "Elite", 		drop = "Mount", 	itemID = 163646, 	faction = "horde",		coord = 27475726,    coordEntry = "",    coordEntryText = "",    notes = "",  mountID = 1182,  sort = 9,	isKnown = false }, -- checked, Drop 5,62%
--    [1424231] = { name = L["rare_overseer_krix"], 			lvl = "122+",	id = 142423, questId = { 53014, 53518 }, 	wfcontrol = "0",	type = "Elite", 		drop = "Mount", 	itemID = 163646, 	faction = "alliance",	coord = 27475726,	mountID = 1182,	sort = 9,	isKnown = false }, -- checked, Drop 5,62%
    [142437] = { name = L["rare_skullripper"], 				lvl = "122+",	id = 142437, questId = { 53022, 53526 }, 	wfcontrol = "0",	type = "Elite", 		drop = "Mount", 	itemID = 163645, 	faction = "all",		coord = 56644521,    coordEntry = "",    coordEntryText = "",    notes = "",  mountID = 1183,  sort = 10,	isKnown = false }, -- checked, Drop 13,21%
    [142739] = { name = L["rare_knight_captain_aldrin"],	lvl = "121+",	id = 142739, questId = { 53088 }, 			wfcontrol = "0",	type = "Rare", 			drop = "Mount", 	itemID = 163578, 	faction = "horde", 		coord = 48923993,    coordEntry = "",    coordEntryText = "",    notes = "",  mountID = 1173,  sort = 11,	isKnown = false }, -- checked, Drop ??% ==> He is up only when Horde has control of Stromgarde
    [142741] = { name = L["rare_doomrider_helgrim"], 		lvl = "121+",	id = 142741, questId = { 53085 }, 			wfcontrol = "0",	type = "Rare", 			drop = "Mount", 	itemID = 163579, 	faction = "alliance",	coord = 53565764,    coordEntry = "",    coordEntryText = "",    notes = "",  mountID = 1174,  sort = 12,	isKnown = false }, -- checked via WoWHead, Drop 15,2% ==> He is up only when Alliance has control of Stromgarde
    [142508] = { name = L["rare_branchlord_aldrus"], 		lvl = "122+",	id = 142508, questId = { 53013, 53505 }, 	wfcontrol = "0",	type = "Elite", 		drop = "Pet", 		itemID = 143503, 	faction = "all", 		coord = 21752217,    coordEntry = "",    coordEntryText = "",    notes = "",  petID = 143503,  sort = 13,	isKnown = false }, -- checked, Drop ??%
    [142688] = { name = L["rare_darbel_montrose"], 			lvl = "121+",	id = 142688, questId = { 53084, 53507 }, 	wfcontrol = "h",	type = "Rare", 			drop = "Pet", 		itemID = 163652, 	faction = "all", 		coord = 50446115,    coordEntry = "",    coordEntryText = "",    notes = "",  petID = 143507,  sort = 14,	isKnown = false }, -- checked, Drop 27,83%
--    [1426881] = { name = L["rare_darbel_montrose"], 		lvl = "121+",	id = 142688, questId = { 53084, 53507 }, 	wfcontrol = "a",	type = "Rare", 			drop = "Pet", 		itemID = 163652, 	faction = "all", 		coord = 50843652, 	petID = 143507,	sort = 14,	isKnown = false }, -- TODO: HAVE TO BE CHECKED
    [141668] = { name = L["rare_echo_of_myzrael"], 			lvl = "122+",	id = 141668, questId = { 53059, 53508 }, 	wfcontrol = "0",	type = "Elite", 		drop = "Pet", 		itemID = 163677, 	faction = "all",		coord = 57043475,    coordEntry = "",    coordEntryText = "",    notes = "",  petID = 143515,  sort = 15,	isKnown = false }, -- checked, Drop 38,58%
    [142433] = { name = L["rare_fozruk"], 					lvl = "122+",	id = 142433, questId = { 53019, 53510 }, 	wfcontrol = "0",	type = "Elite", 		drop = "Pet", 		itemID = 163711, 	faction = "all", 		coord = 40126133,    coordEntry = "",    coordEntryText = "",    notes = "",  petID = 143627,  sort = 16,	isKnown = false }, -- checked, Drop 21,21% ==> He is walking around and has no exact waypoint. This is the middle of his walking area
    [142716] = { name = L["rare_man_hunter_rog"], 			lvl = "121+",	id = 142716, questId = { 53090, 53515 }, 	wfcontrol = "0",	type = "Rare", 			drop = "Pet", 		itemID = 143628, 	faction = "all",		coord = 52077445,    coordEntry = "",    coordEntryText = "",    notes = "",  petID = 143628,  sort = 17,	isKnown = false }, -- checked, Drop 28,72%
    [142435] = { name = L["rare_plaguefeather"], 			lvl = "122+",	id = 142435, questId = { 53020, 53519 }, 	wfcontrol = "0",	type = "Elite", 		drop = "Pet", 		itemID = 163690, 	faction = "all", 		coord = 36746392,    coordEntry = "",    coordEntryText = "",    notes = "",  petID = 143564,  sort = 18,	isKnown = false }, -- checked, Drop 21,69%
    [142436] = { name = L["rare_ragebeak"], 				lvl = "122+",	id = 142436, questId = { 53016, 53522 }, 	wfcontrol = "h",	type = "Elite", 		drop = "Pet", 		itemID = 163689, 	faction = "all", 		coord = 11845197,    coordEntry = "",    coordEntryText = "",    notes = "",  petID = 143563,  sort = 19,	isKnown = false }, -- checked, Drop 14,29%
--	[1424361] = { name = L["rare_ragebeak"], 				lvl = "122+",	id = 142436, questId = { 53016, 53522 }, 	wfcontrol = "a",	type = "Elite", 		drop = "Pet", 		itemID = 163689, 	faction = "all", 		coord = 18412794,	petID = 143563, sort = 19,	isKnown = false }, -- checked, Drop 14,29%
    [142438] = { name = L["rare_venomarus"], 				lvl = "122+",	id = 142438, questId = { 53024, 53528 }, 	wfcontrol = "0",	type = "Elite", 		drop = "Pet", 		itemID = 163648, 	faction = "all", 		coord = 56965378,    coordEntry = "",    coordEntryText = "",    notes = "",  petID = 143499,  sort = 20,	isKnown = false }, -- checked, Drop 6,49%
    [142440] = { name = L["rare_yogursa"], 					lvl = "122+",	id = 142440, questId = { 53015, 53529 }, 	wfcontrol = "0",	type = "Elite", 		drop = "Pet", 		itemID = 163684, 	faction = "all", 		coord = 13863618,    coordEntry = "",    coordEntryText = "",    notes = "",  petID = 143533,  sort = 21,	isKnown = false }, -- checked, Drop 23,19%
    [142686] = { name = L["rare_foulbelly"], 				lvl = "121+",	id = 142686, questId = { 53086, 53509 }, 	wfcontrol = "0",	type = "Rare", 			drop = "Toy", 		itemID = 163735, 	faction = "all", 		coord = 22305106,    coordEntry = "",    coordEntryText = "",    notes = "",                   sort = 22,	isKnown = false }, -- checked, Drop 4,55% ==> Cave is at Coords 28,67 45,63
    [142662] = { name = L["rare_geomancer_flintdagger"], 	lvl = "121+",	id = 142662, questId = { 53060, 53511 }, 	wfcontrol = "0",	type = "Rare", 			drop = "Toy", 		itemID = 163713, 	faction = "all", 		coord = 79462941,    coordEntry = "",    coordEntryText = "",    notes = "",                   sort = 23,	isKnown = false }, -- checked, Drop 12,5% ==> Cave entry at 78,21 36,71
    [142725] = { name = L["rare_horrific_apparition"], 		lvl = "121+",	id = 142725, questId = { 53087, 53512 }, 	wfcontrol = "h",	type = "Rare", 			drop = "Toy", 		itemID = 163736, 	faction = "all", 		coord = 19496148,    coordEntry = "",    coordEntryText = "",    notes = "",                   sort = 24,	isKnown = false }, -- checked, Drop 10,45%
--    [1427251] = { name = L["rare_horrific_apparition"], 	lvl = "121",	id = 142725, questId = { 53087, 53512 }, 	wfcontrol = "a",	type = "Rare", 			drop = "Toy", 		itemID = 163736, 	faction = "all", 		coord = 26723278,					sort = 24,	isKnown = false },
    [142112] = { name = L["rare_korgresh_coldrage"], 		lvl = "121+",	id = 142112, questId = { 53058, 53513 }, 	wfcontrol = "0",	type = "Rare", 			drop = "Toy", 		itemID = 163744, 	faction = "all", 		coord = 49068413,    coordEntry = "",    coordEntryText = "",    notes = "",                   sort = 25,	isKnown = false }, -- checked, Drop 8,33%
    [142684] = { name = L["rare_kovork"], 					lvl = "121+",	id = 142684, questId = { 53089, 53514 }, 	wfcontrol = "0",	type = "Rare", 			drop = "Toy", 		itemID = 163750, 	faction = "all", 		coord = 25294856,    coordEntry = "",    coordEntryText = "",    notes = "",                   sort = 26,	isKnown = false },
    [141942] = { name = L["rare_molok_the_crusher"], 		lvl = "122+",	id = 141942, questId = { 53057, 53516 }, 	wfcontrol = "0",	type = "Elite",			drop = "Toy", 		itemID = 163775, 	faction = "all", 		coord = 47647789,    coordEntry = "",    coordEntryText = "",    notes = "",                   sort = 27,	isKnown = false }, -- checked, Drop 23,90%
    [142683] = { name = L["rare_ruul_onestone"], 			lvl = "121+",	id = 142683, questId = { 53092, 53524 }, 	wfcontrol = "0",	type = "Rare", 			drop = "Toy", 		itemID = 163741, 	faction = "all", 		coord = 42865645,    coordEntry = "",    coordEntryText = "",    notes = "",                   sort = 28,	isKnown = false }, -- checked, Drop 6,12%
    [142690] = { name = L["rare_singer"], 					lvl = "121+",	id = 142690, questId = { 53093, 53525 }, 	wfcontrol = "0",	type = "Rare", 			drop = "Toy", 		itemID = 163738, 	faction = "horde", 		coord = 50955777,    coordEntry = "",    coordEntryText = "",    notes = "",                   sort = 29,	isKnown = false }, -- checked, Drop 19,63%
--    [1426901] = { name = L["rare_singer"], 					lvl = "121",	id = 142690, questId = { 53093, 53525 }, 	wfcontrol = "0",	type = "Rare", 			drop = "Toy", 		itemID = 163738, 	faction = "alliance", 	coord = 50705748,					sort = 29,	isKnown = false }, -- TODO: HAVE TO BE CHECKED
    [142682] = { name = L["rare_zalas_witherbark"], 		lvl = "121+",	id = 142682, questId = { 53094, 53530 }, 	wfcontrol = "0",	type = "Rare", 			drop = "Toy", 		itemID = 163745, 	faction = "all", 		coord = 62858120,    coordEntry = "",    coordEntryText = "",    notes = "",                   sort = 30,	isKnown = false }, -- checked, Drop 5,74% ==> Cave entry at 63,25 77,63
--    [141947] = { name = L["rare_boulderfist_brute"], 		lvl = "121+",	id = 141947, questId = { 0 }, 				wfcontrol = "0",	type = "Rare", 			drop = "Nothing", 	itemID = 0, 		faction = "all",											sort = 31					},
}

WRT.isTomTomloaded = false
WRT.isZygorloaded = false
WRT.isRoutesloaded = false

-- Colorscodes by https://www.tug.org/pracjourn/2007-4/walden/color.pdf
WRT.colors = {
    white = { 1, 1, 1, 1 },
    red = { 0.7, 0.1, 0, 1 },
    blue = { 0.2, 0.5, 0.9, 1 },
    green = { 0, 0.9, 0.2, 1 },
    purple = { 0.63, 0.20, 0.93, 1 },
    turquoise = { 0.40, 0.73, 1, 1 },
    yellow = { 1, 0.82, 0, 1 },
	grey = { 0.5, 0.5, 0.5, 0.25 },
}

local defaults = {
    profile = {
        minimap = {
            hide = false,
            minimapPos = 180,
        },
        menu = {
            showMenuOn = "mouse",
            showBrokerText = true,
        },
        tomtom = {
            enableIntegration = true,
            eneableChatMessage = false,
        },
		navi = {
			addon = "t",
		},
        colorizeDrops = {
            enabled = true,
            knownColor = { 0, 1, 0, 1 },
            unknownColor = { 1, 1, 1, 1 },
        },
        colorizeStatus = {
            enabled = false,
            available = { 0, 1, 0, 1 },
            defeated = { 1, 0.12, 0.12, 1 },
        },
        enableNPCUnitFrame = true,
		warfrontControlledBy = "h",
    },
}

configOptions = {
    type = "group",
    name = L["wow_rare_tracker"],
    args = {
        minimap = {
            name = L["minimap_broker"],
            order = 1,
            type = "group",
            inline = true,
            args = {
                minimapButton = {
                    name = L["show_minimap_icon_name"],
                    desc = L["show_minimap_icon_desc"],
                    type = "toggle",
                    order = 1,
                    get = function(info)
                            return not WRT.db.profile.minimap.hide
                        end,
                    set = function(info, value)
                            WRT.db.profile.minimap.hide = not value
                            WoWRareTracker:RefreshConfig()
                        end,
                },
                brokerText = {
                    name = L["show_broker_text_name"],
                    desc = L["show_broker_text_desc"],
                    type = "toggle",
                    order = 2,
                    get = function(info)
                            return WRT.db.profile.menu.showBrokerText
                        end,
                    set = function(info, value)
                            WRT.db.profile.menu.showBrokerText = value
                            WoWRareTracker:SetBrokerText()
                        end,
                },
                showMenu = {
                    name = L["show_menu_name"],
                    desc = L["show_menu_desc"],
                    type = "select",
                    style = "dropdown",
                    order = 3,
                    values = { ["mouse"]=L["on_mouseover"], ["click"]=L["on_leftClick"] },
                    get = function(info)
                            return WRT.db.profile.menu.showMenuOn
                        end,
                    set = function(info, value)
                            WRT.db.profile.menu.showMenuOn = value
                        end,
                },
            },
        },
		warfront = {
			name = L["warfront"],
			order = 2,
			type = "group",
			inline = true,
			args = {
				warfrontControll = {
					name = L["warfront_controll_by_name"],
					desc = L["warfront_controll_by_desc"],
					type = "select",
					style = "dropdown",
					order = 1,
					values = { ["a"]=L["warfront_controll_by_alliance"], ["h"]=L["warfront_controll_by_horde"] },
					get = function(info)
							return WRT.db.profile.warfrontControlledBy
						end,
					set = function(info, value)
							WRT.db.profile.warfrontControlledBy = value
							WoWRareTracker:Print(L["warfront_controll_changed_reloadui"])
						end,
				},
			}
		},
        unitframes = {
            name = L["unit_frames"],
            order = 3,
            type = "group",
            inline = true,
            args = {
                unitframe = {
                    name = L["npc_unit_frame_text_name"],
                    desc = L["npc_unit_frame_text_desc"],
                    type = "toggle",
                    get = function(info)
                            return WRT.db.profile.enableNPCUnitFrame
                        end,
                    set = function(info, value)
                            WRT.db.profile.enableNPCUnitFrame = value
                        end,
                },
            },
        },
        tomtom = {
            name = L["tomtom_integration"],
            order = 6,
            type = "group",
            inline = true,
            args = {
                tomtomIntegration = {
                    name = L["tomtom_integration_name"],
                    desc = L["tomtom_integration_desc"],
                    type = "toggle",
                    order = 1,
                    get = function(info)
                            return WRT.db.profile.tomtom.enableIntegration
                        end,
                    set = function(info, value)
                            WRT.db.profile.tomtom.enableIntegration = value
                        end,
                    disabled = function() return not WRT.isTomTomloaded end,
                },
				addon = {
					name = L["navi_naviaddon_name"],
					desc = L["navi_naviaddon_desc"],
					type = "select",
					style = "dropdown",
					order = 2,
					values = { ["z"]=L["navi_naviaddon_zygor"], ["t"]=L["navi_naviaddon_tomtom"] },
					get = function(info)
							return WRT.db.profile.navi.addon
						end,
					set = function(info, value)
							WRT.db.profile.navi.addon = value
						end,
				},
                tomtomChatMessage = {
                    name = L["tomtom_output_to_chat_name"],
                    desc = L["tomtom_output_to_chat_desc"],
                    type = "toggle",
                    order = 3,
                    get = function(info)
                        return WRT.db.profile.tomtom.eneableChatMessage
                        end,
                    set = function(info, value)
                            WRT.db.profile.tomtom.eneableChatMessage = value
                        end,
                    disabled = function() return not WRT.isTomTomloaded end,
                }
            },
        },
        resetToDefault = {
            name = L["reset_to_default_name"],
            desc = L["reset_to_default_desc"],
            type = "execute",
            order = 10,
            confirm = function(info)
                    return L["reset_to_default_return"]
                end,
            func = function()
                    WRT.db:ResetDB()
                    WoWRareTracker:Print(L["reset_to_default_print"])
                end,
        },
        news = {
            name = "News",
            order = 9,
            type = "group",
            inline = true,
            args = {
                 text = {
                    name = function(info)
                            return WRT.db.profile.navi.addon
                        end,
                    desc = "",
                    type = "description",
                    order = 1,
                }
            },
        },
    },
}

function WoWRareTracker:OnInitialize()
    WRT.broker = ldb:NewDataObject("WoWRareTracker", {
        type = "data source",
        label = "WoWRareTracker",
        icon = "Interface\\AddOns\\WoWRareTracker\\WoWRareTracker-128",
        text = "Loading",
        OnEnter = function(self) WoWRareTracker:OnEnter(self) end,
        OnLeave = function() WoWRareTracker:OnLeave() end,
        OnClick = function(self, button) WoWRareTracker:OnClick(self, button) end,
    })

    WRT.db = LibStub("AceDB-3.0"):New("WoWRareTrackerDB", defaults, true)
    WRT.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
	WRT.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
	WRT.db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")

    minimapicon:Register("WoWRareTracker", WRT.broker, WRT.db.profile.minimap)

    LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("WoWRareTracker", configOptions)
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions("WoWRareTracker", "WoWRareTracker")

    self:RegisterChatCommand("bfararetracker", function() LibStub("AceConfigDialog-3.0"):Open("WoWRareTracker") end)
	self:RegisterChatCommand("raretracker", function() LibStub("AceConfigDialog-3.0"):Open("WoWRareTracker") end)
end

function WoWRareTracker:DelayedInitialize()
    if IsAddOnLoaded("TomTom") then
        WRT.isTomTomloaded = true
    end
    if IsAddOnLoaded("Zygor") then
        WRT.isZygorloaded = true
    end
    if IsAddOnLoaded("Routes") then
        WRT.isRoutesloaded = true
    end
    WoWRareTracker:ScanMountsAndToys()
    WoWRareTracker:ScanPets()
    WoWRareTracker:SetBrokerText()
end

function WoWRareTracker:OnEnable()
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("NEW_MOUNT_ADDED", "OnEvent")
    self:RegisterEvent("TOYS_UPDATED", "OnEvent")
    self:RegisterEvent("NEW_PET_ADDED", "OnEvent")
end

function WoWRareTracker:OnDisable()
    self:UnregisterEvent("NEW_MOUNT_ADDED")
    self:UnregisterEvent("TOYS_UPDATED")
    self:UnregisterEvent("NEW_PET_ADDED")
end

function WoWRareTracker:RefreshConfig()
    LibStub("LibDBIcon-1.0"):Refresh("WoWRareTracker", WRT.db.profile.minimap)
    WoWRareTracker:SetBrokerText()
end

function WoWRareTracker:PLAYER_ENTERING_WORLD()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
    self:ScheduleTimer("DelayedInitialize", 5)
	self:Print(format("Version: |cFFffaa00%s|r loaded!", WRT.version))
end

function WoWRareTracker:OnEvent(event, ...)
    if event == "NEW_MOUNT_ADDED" then
        WoWRareTracker:ScanMountsAndToys()
    elseif event == "TOYS_UPDATED" then
        WoWRareTracker:ScanMountsAndToys()
    elseif event == "NEW_PET_ADDED" then
        self:ScheduleTimer("ScanPets", 5)
    end
end

function WoWRareTracker:ScanMountsAndToys()
    for k, rare in pairs(WRT.rares) do
        if rare.drop == "Mount" and rare.mountID and rare.mountID ~= 0 then
            local name, spellId, _, _, _, _, _, _, _, _, isCollected = C_MountJournal.GetMountInfoByID(rare.mountID)
            if isCollected then
                rare.isKnown = true
            end
        elseif rare.drop == "Toy" and rare.itemID ~= 0 then
            if PlayerHasToy(rare.itemID) then
                rare.isKnown = true
            end
        end
    end
end

function WoWRareTracker:ScanPets()
    C_PetJournal.SetFilterChecked(LE_PET_JOURNAL_FILTER_COLLECTED, true)
    C_PetJournal.SetFilterChecked(LE_PET_JOURNAL_FILTER_NOT_COLLECTED, true)
    C_PetJournal.SetAllPetTypesChecked(true)
    C_PetJournal.SetAllPetSourcesChecked(true)
    for i = 1, C_PetJournal.GetNumPets() do
        local petUID, _, isOwned, _, _, _, _, _, _, _, companionID, _, _, _, _, _, _, _ = C_PetJournal.GetPetInfoByIndex(i)
        for k, rare in pairs(WRT.rares) do
            if rare.petID and rare.petID ~= 0 then
                if companionID == rare.petID and isOwned then
                    rare.isKnown = true
                end
            end
        end
    end
end

function WoWRareTracker:SetBrokerText()
    if WRT.db.profile.menu.showBrokerText  then
        WRT.broker.text = " " .. L["wow_rare_tracker"]
    else
        WRT.broker.text = ""
    end
end

function WoWRareTracker:ColorText(text, color)
    if text and color then
        return format("|cff%02x%02x%02x%s|r", (color[1] or 1) * 255, (color[2] or 1) * 255, (color[3] or 1) * 255, text)
    else
        return text
    end
end

function WoWRareTracker:GetNPCIDFromGUID(guid)
	if guid then
		local unit_type, _, _, _, _, mob_id = strsplit('-', guid)
		if unit_type == "Pet" or unit_type == "Player" then return 0 end
		return (guid and mob_id and tonumber(mob_id)) or 0
	end
	return 0
end

function WoWRareTracker:GetStatusText(npcid)
    local rare = WRT.rares[npcid]
    if rare.questId[1] == 0 then
        return WoWRareTracker:ColorText(L["wrt_unknown"], WRT.colors.yellow)
    else
        for k, v in pairs(rare.questId) do
            if IsQuestFlaggedCompleted(rare.questId[k]) then
                return WoWRareTracker:ColorText(L["wrt_defeated"], WRT.db.profile.colorizeStatus.enabled and WRT.db.profile.colorizeStatus.defeated or WRT.colors.red)
            end
        end
    end
    return WoWRareTracker:ColorText(L["wrt_available"], WRT.db.profile.colorizeStatus.enabled and WRT.db.profile.colorizeStatus.available or WRT.colors.green)
end

function WoWRareTracker:GetLvlText(npcid)
    local rare = WRT.rares[npcid]
    if rare.lvl == "0" then
        return WoWRareTracker:ColorText(L["wrt_unknown"], WRT.colors.yellow)
    else
		return rare.lvl
    end
end

function WoWRareTracker:GetDropText(npcid)
    local rare = WRT.rares[npcid]
    if WRT.db.profile.colorizeDrops.enabled and rare.isKnown then
        return WoWRareTracker:ColorText(rare.drop, WRT.db.profile.colorizeDrops.knownColor)
    elseif WRT.db.profile.colorizeDrops.enabled and not rare.isKnown then
        return WoWRareTracker:ColorText(rare.drop, WRT.db.profile.colorizeDrops.unknownColor)
    else
        return rare.drop
    end
end

function WoWRareTracker:IsNPCPlayerFaction(npcid)
    local playerFaction, _ = strlower(UnitFactionGroup("player"))
    local rareFaction = WRT.rares[npcid].faction
    return rareFaction == playerFaction or rareFaction == "all"
end

-- function WoWRareTracker:IsNPCPlayerWarfrontSpecific(npcid)
--    local playerFaction, _ = strlower(UnitFactionGroup("player"))
--    local rareFaction = WRT.rares[npcid].faction
--    local rareFaction = WRT.rares[npcid].faction
--    return rareFaction == playerFaction or rareFaction == "all"
-- end

function WoWRareTracker:OnClick(self, button)
    if button == "RightButton" then
        LibStub("AceConfigDialog-3.0"):Open("WoWRareTracker")
    elseif button == "LeftButton" and WRT.db.profile.menu.showMenuOn == "click" then
        WoWRareTracker:ShowMenu(self, button)
    end
end

function WoWRareTracker:OnEnter(self, button)
    if WRT.db.profile.menu.showMenuOn == "mouse" then
        WoWRareTracker:ShowMenu(self, button)
    end
end

function WoWRareTracker:OnLeave(self, button)
end

function WoWRareTracker:ShowMenu(self, button)
    tooltip = LibQTip:Acquire("WoWRareTrackerTip")
	tooltip:SmartAnchorTo(self)
    tooltip:SetAutoHideDelay(0.25, self)
    tooltip:EnableMouse(true)
    WoWRareTracker:UpdateToolTip(tooltip)
   	
	tooltip:Show()
end

function WoWRareTracker:TooltipLineOnClick(self, npcid, button)
    local rare = WRT.rares[npcid]
    if button == "LeftButton" then
        if WRT.isTomTomloaded and WRT.db.profile.tomtom.enableIntegration then
            local name = rare.name
            local mapID = 14
            local x, y = floor(rare.coord / 10000) / 10000, (rare.coord % 10000) / 10000

            TomTom:AddWaypoint(mapID, x, y, {
                title = name,
                persistent = nil,
                minimap = true,
                world = true,
            })
            if WRT.db.profile.tomtom.eneableChatMessage then
                WoWRareTracker:Print(L["tomtom_added_waypoint_to"] .. name)
            end
        end
--        if WRT.isZygorloaded and WRT.db.profile.tomtom.enableIntegration then
--            local name = rare.name
--            local mapID = 14
--            local x, y = floor(rare.coord / 10000) / 10000, (rare.coord % 10000) / 10000
--
--            TomTom:AddWaypoint(mapID, x, y, {
--                title = name,
--                persistent = nil,
--                minimap = true,
--                world = true,
--            })
--            if WRT.db.profile.tomtom.eneableChatMessage then
--                WoWRareTracker:Print(L["tomtom_added_waypoint_to"] .. name)
--            end
--        end
    end
end

function WoWRareTracker:UpdateToolTip(tooltip)
    local t = sortRares(WRT.rares)
    local line
	local controlledbyHeadline

    tooltip:Clear();
    tooltip:SetColumnLayout(4, "LEFT", "LEFT", "LEFT", "LEFT")

    line = tooltip:AddHeader()
	if WRT.db.profile.warfrontControlledBy == "h" then
		controlledbyHeadline = WoWRareTracker:ColorText(L["wow_rare_tracker"], WRT.colors.yellow) .. " - " .. L["wow_rare_tracker_controlled_by"] .. " " .. WoWRareTracker:ColorText(L["wow_rare_tracker_controlled_by_horde"], WRT.colors.red)
	end
	if WRT.db.profile.warfrontControlledBy == "a" then
		controlledbyHeadline = WoWRareTracker:ColorText(L["wow_rare_tracker"], WRT.colors.yellow) .. " - " .. L["wow_rare_tracker_controlled_by"] .. " " .. WoWRareTracker:ColorText(L["wow_rare_tracker_controlled_by_alliance"], WRT.colors.blue)
	end
    tooltip:SetCell(line, 1,controlledbyHeadline , tooltip:GetHeaderFont(), "CENTER", 4)
    line = tooltip:AddLine()
    tooltip:SetCell(line, 1, " ", nil, "LEFT", 3)

    line = tooltip:AddHeader()
    line = tooltip:SetCell(line, 1, L["wrt_table_1"])
	-- line = tooltip:SetCell(line, sortNumber, cellName, nil, allign, 1, LibQTip.LabelProvider, marginLeft, nil, maxWidth, minWidth)
	line = tooltip:SetCell(line, 2, L["wrt_table_2"], nil, "LEFT", 1, LibQTip.LabelProvider, 20, nil, 100, 60)
    line = tooltip:SetCell(line, 3, L["wrt_table_3"], nil, "LEFT", 1, LibQTip.LabelProvider, 20, nil, 100, 60)
    line = tooltip:SetCell(line, 4, L["wrt_table_4"])
    tooltip:AddSeparator()

	-- k is arrayid, value the array values as array
    for k, value in pairs(sortRares(WRT.rares)) do
        local npcid = value.id
        if WoWRareTracker:IsNPCPlayerFaction(npcid) then
            local name = value.name
            if value.type == "WorldBoss" then
                name = WoWRareTracker:ColorText(name, WRT.colors.purple)
            end
			local lvl = WoWRareTracker:GetLvlText(npcid)
            local drop = WoWRareTracker:GetDropText(npcid)
            local status = WoWRareTracker:GetStatusText(npcid)

            line = tooltip:AddLine()
            line = tooltip:SetCell(line, 1, name)
            line = tooltip:SetCell(line, 2, lvl, nil, "LEFT", 1, LibQTip.LabelProvider, 20, nil, 100, 60)
            line = tooltip:SetCell(line, 3, drop, nil, "LEFT", 1, LibQTip.LabelProvider, 20, nil, 100, 60)
            line = tooltip:SetCell(line, 4, status)
            tooltip:SetLineScript(line, "OnEnter", function(self, npcid) WoWRareTracker:ShowExtraTooltip(self, npcid) end, npcid)
            tooltip:SetLineScript(line, "OnLeave", function() WoWRareTracker:HideExtraTooltip() end)
            tooltip:SetLineScript(line, "OnMouseUp", function(self, npcid, button) WoWRareTracker:TooltipLineOnClick(self, npcid, button) end, npcid)
        end
    end
    tooltip:AddSeparator()
    line = tooltip:AddLine()
    line = tooltip:SetCell(line, 1, format(WoWRareTracker:ColorText(L["wrt_description_arathi_faction_control"], WRT.colors.grey), WRT.version), "CENTER", 4)

    tooltip:AddSeparator()
    line = tooltip:AddLine()
    line = tooltip:SetCell(line, 1, WoWRareTracker:ColorText(L["wrt_mouse_option_right"], WRT.colors.turquoise), "LEFT", 4)
    if WRT.isTomTomloaded and WRT.db.profile.tomtom.enableIntegration then
        line = tooltip:AddLine()
        line = tooltip:SetCell(line, 1, WoWRareTracker:ColorText(L["wrt_mouse_option_left"], WRT.colors.turquoise), "LEFT", 4)
    end
end

function WoWRareTracker:ShowExtraTooltip(self, npcid)
    if LibQTip:IsAcquired("WoWRareTrackerLootTip") and tooltip2 then
        LibQTip.Release(tooltip2)
        tooltip2 = nil
    end
    tooltip2 = LibQTip:Acquire("WoWRareTrackerLootTip", 2, "LEFT", "RIGHT")
    tooltip2:ClearAllPoints()
    tooltip2:SetClampedToScreen(true)
    tooltip2:SetPoint("RIGHT", self, "LEFT", -15, 0)
        
    local rare = WRT.rares[npcid]
    if rare.itemID ~= 0 then
        local itemName, itemLink, _, _, _, _, _, _, _, itemTexture, _ = GetItemInfo(rare.itemID)

        if itemTexture ~= nil then
            tooltip2:AddHeader(itemLink or itemName, "|T" .. itemTexture .. ":22|t")
        else
            tooltip2:AddHeader(itemLink or itemName)
        end
        
        npcToolTip:SetItemByID(rare.itemID)
        for i = 2, npcToolTip:NumLines() do
            local tooltipLine =  _G["__WoWRareTracker_ScanTipTextLeft" .. i]
            local text = tooltipLine:GetText()
            local color = {}
            color[1], color[2], color[3], color[4] = tooltipLine:GetTextColor()

            if string.len(text) > 1 then
                local line = tooltip2:AddLine()
                tooltip2:SetCell(line, 1, WoWRareTracker:ColorText(text, color), nil, nil, 2, LibQTip.LabelProvider, nil, nil, 200)
            end
        end
        if tooltip2:GetLineCount() > 1 then
            tooltip2:Show()
        end
    end
end

function WoWRareTracker:HideExtraTooltip()
    if tooltip2 then
        LibQTip:Release(tooltip2)
        tooltip2 = nil
    end
end

function WoWRareTracker:ZONE_CHANGED()
    self:Print("This is a zone change notification!")
end

----------------
-- NPC UnitFrame
GameTooltip:HookScript("OnTooltipSetUnit", function(self)
    if WRT.db.profile.enableNPCUnitFrame then
        local name, unit = self:GetUnit()
        if not unit then 
            return
        end
        local creatureType = UnitCreatureType(unit)
        if creatureType == "Critter" or creatureType == "Non-combat Pet" or creatureType == "Wild Pet" then
            return
        end
        local guid = UnitGUID(unit)
        if not unit or not guid then return end
        if not UnitCanAttack("player", unit) then return end -- Something you can't attack
        if UnitIsPlayer(unit) then return end -- A player
        if UnitIsPVP(unit) then return end -- A PVP flagged unit

        local npcid = WoWRareTracker:GetNPCIDFromGUID(guid)
        local rare = WRT.rares[npcid]
        if rare and type(rare) == "table" and WoWRareTracker:IsNPCPlayerFaction(npcid) then
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine(WoWRareTracker:ColorText(L["wow_rare_tracker"] .. ": ", WRT.colors.yellow) .. WoWRareTracker:GetStatusText(npcid))
            if rare.itemID ~= 0 then
                local itemName, itemLink, itemRarity, _, _, itemType, _, _, _, _, _ = GetItemInfo(rare.itemID)
                if itemLink or itemName then
                    GameTooltip:AddLine(WoWRareTracker:ColorText(L["wrt_tooltip_drop"] .. " " .. rare.drop .. ": ", WRT.colors.yellow) .. (itemLink or itemName))
                end
            end
        end
    end
end)

local function compareNum(a, b)
    if not a or not b then return 0 end
    if type(a) ~= "table" or type(b) ~= "table" then return 0 end
    return (a.sort or 0) < (b.sort or 0)
end

function sortRares(t)
    local newTable = {}
    local i, j, n, min = 0, 0, 0, 0
    local k, v
    for k, v in pairs(t) do
        if type(v) == "table" and v.sort then
            n = n + 1
            newTable[n]  = v
        end
    end
    for i = 1, n, 1 do
        min = i
        for j = i + 1, n, 1 do
            if compareNum(newTable[j], newTable[min]) then min = j end
        end
        newTable[i], newTable[min] = newTable[min], newTable[i]
    end
    return newTable
end
