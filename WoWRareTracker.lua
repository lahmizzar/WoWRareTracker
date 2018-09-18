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

WRT.version = "0.3.1"

WRT.rares = {
    [138122] = { name = L["rare_dooms_howl"], 				lvl = "??+",	id = 138122, questId = { 53002 }, 			type = "WorldBoss", 	drop = "Toy", 		itemID = 163828, 	faction = "alliance", 	coord = 37093921,					sort = 1,	isKnown = false },
    [137374] = { name = L["rare_the_lions_roar"], 			lvl = "??+",	id = 137374, questId = { 0 }, 				type = "WorldBoss", 	drop = "Toy", 		itemID = 163829, 	faction = "horde", 		coord = 30155960,					sort = 2,	isKnown = false }, -- Need Horde Quest ID
    [141618] = { name = L["rare_cresting_goliath"], 		lvl = "122",	id = 141618, questId = { 53018, 53531 }, 	type = "Elite", 		drop = "Item", 		itemID = 163700, 	faction = "all", 		coord = 62513084,					sort = 3,	isKnown = false },
    [141615] = { name = L["rare_burning_goliath"], 			lvl = "0",	id = 141615, questId = { 53017, 53506 }, 	type = "Elite", 		drop = "Item", 		itemID = 163691, 	faction = "all", 		coord = 30604475,					sort = 4,	isKnown = false },
    [141620] = { name = L["rare_rumbling_goliath"], 		lvl = "122",	id = 141620, questId = { 53021, 53523 }, 	type = "Elite", 		drop = "Item", 		itemID = 163701, 	faction = "all", 		coord = 29405834,					sort = 5,	isKnown = false },
    [141616] = { name = L["rare_thundering_goliath"], 		lvl = "122",	id = 141616, questId = { 53023, 53527 }, 	type = "Elite", 		drop = "Item", 		itemID = 163698, 	faction = "all", 		coord = 46245222,					sort = 6,	isKnown = false },
    [142709] = { name = L["rare_beastrider_kama"], 			lvl = "121",	id = 142709, questId = { 53083, 53504 }, 	type = "Rare", 			drop = "Mount", 	itemID = 163644, 	faction = "all",		coord = 65347116,	mountID = 1180, sort = 7,	isKnown = false },
    [142692] = { name = L["rare_nimar_the_slayer"], 		lvl = "121",	id = 142692, questId = { 53091, 53517 }, 	type = "Rare", 			drop = "Mount", 	itemID = 163706, 	faction = "all", 		coord = 67486058,	mountID = 1185,	sort = 8,	isKnown = false },
    [142423] = { name = L["rare_overseer_krix"], 			lvl = "122",	id = 142423, questId = { 53014, 53518 }, 	type = "Rare", 			drop = "Mount", 	itemID = 163646, 	faction = "all",		coord = 33693676,	mountID = 1182,	sort = 9,	isKnown = false },
    [142437] = { name = L["rare_skullripper"], 				lvl = "122",	id = 142437, questId = { 53022, 53526 }, 	type = "Rare", 			drop = "Mount", 	itemID = 163645, 	faction = "all",		coord = 57154575,	mountID = 1183,	sort = 10,	isKnown = false },
    [142739] = { name = L["rare_knight_captain_aldrin"],	lvl = "0",	id = 142739, questId = { 0 }, 				type = "Rare", 			drop = "Mount", 	itemID = 163578, 	faction = "horde", 		coord = 49274005,	mountID = 1173,	sort = 11,	isKnown = false }, -- Need Horde Quest ID
    [142741] = { name = L["rare_doomrider_helgrim"], 		lvl = "0",	id = 142741, questId = { 53085 }, 			type = "Rare", 			drop = "Mount", 	itemID = 163579, 	faction = "alliance",	coord = 53565764,	mountID = 1174,	sort = 12,	isKnown = false },
    [142508] = { name = L["rare_branchlord_aldrus"], 		lvl = "122",	id = 142508, questId = { 53013, 53505 }, 	type = "Rare", 			drop = "Pet", 		itemID = 143503, 	faction = "all", 		coord = 21752217, 	petID = 143503,	sort = 13,	isKnown = false },
    [142688] = { name = L["rare_darbel_montrose"], 			lvl = "121",	id = 142688, questId = { 53084, 53507 }, 	type = "Rare", 			drop = "Pet", 		itemID = 163652, 	faction = "all", 		coord = 50673675, 	petID = 143507,	sort = 14,	isKnown = false },
    [141668] = { name = L["rare_echo_of_myzrael"], 			lvl = "122",	id = 141668, questId = { 53059, 53508 }, 	type = "Rare", 			drop = "Pet", 		itemID = 163677, 	faction = "all",		coord = 57073506,   petID = 143515, sort = 15,	isKnown = false },
    [142433] = { name = L["rare_fozruk"], 					lvl = "122",	id = 142433, questId = { 53019 }, 			type = "Rare", 			drop = "Pet", 		itemID = 163711, 	faction = "all", 		coord = 59422773,	petID = 143627, sort = 16,	isKnown = false }, -- Need Horde Quest ID
    [142716] = { name = L["rare_man_hunter_rog"], 			lvl = "122",	id = 142716, questId = { 53090, 53515 }, 	type = "Rare", 			drop = "Pet", 		itemID = 143628, 	faction = "all",		coord = 51827562,	petID = 143628, sort = 17,	isKnown = false },
    [142435] = { name = L["rare_plaguefeather"], 			lvl = "122",	id = 142435, questId = { 53020, 53519 }, 	type = "Rare", 			drop = "Pet", 		itemID = 163690, 	faction = "all", 		coord = 35606435,	petID = 143564, sort = 18,	isKnown = false },
    [142436] = { name = L["rare_ragebeak"], 				lvl = "122",	id = 142436, questId = { 53016, 53522 }, 	type = "Rare", 			drop = "Pet", 		itemID = 163689, 	faction = "all", 		coord = 18412794,	petID = 143563, sort = 19,	isKnown = false },
    [142438] = { name = L["rare_venomarus"], 				lvl = "122",	id = 142438, questId = { 53024, 53528 }, 	type = "Rare", 			drop = "Pet", 		itemID = 163648, 	faction = "all", 		coord = 56945330,	petID = 143499, sort = 20,	isKnown = false },
    [142440] = { name = L["rare_yogursa"], 					lvl = "122",	id = 142440, questId = { 53015, 53529 }, 	type = "Rare", 			drop = "Pet", 		itemID = 163684, 	faction = "all", 		coord = 13273534,	petID = 143533, sort = 21,	isKnown = false },
    [142686] = { name = L["rare_foulbelly"], 				lvl = "121",	id = 142686, questId = { 53086, 53509 }, 	type = "Rare", 			drop = "Toy", 		itemID = 163735, 	faction = "all", 		coord = 22305106,					sort = 22,	isKnown = false },
    [142662] = { name = L["rare_geomancer_flintdagger"], 	lvl = "121",	id = 142662, questId = { 53060, 53511 }, 	type = "Rare", 			drop = "Toy", 		itemID = 163713, 	faction = "all", 		coord = 78153687,					sort = 23,	isKnown = false },
    [142725] = { name = L["rare_horrific_apparition"], 		lvl = "121",	id = 142725, questId = { 53087, 53512 }, 	type = "Rare", 			drop = "Toy", 		itemID = 163736, 	faction = "all", 		coord = 26723278,					sort = 24,	isKnown = false },
    [142112] = { name = L["rare_korgresh_coldrage"], 		lvl = "121",	id = 142112, questId = { 53058, 53513 }, 	type = "Rare", 			drop = "Toy", 		itemID = 163744, 	faction = "all", 		coord = 49318426,					sort = 25,	isKnown = false },
    [142684] = { name = L["rare_kovork"], 					lvl = "121",	id = 142684, questId = { 53089, 53514 }, 	type = "Rare", 			drop = "Toy", 		itemID = 163750, 	faction = "all", 		coord = 25294856,					sort = 26,	isKnown = false },
    [141942] = { name = L["rare_molok_the_crusher"], 		lvl = "122",	id = 141942, questId = { 53057, 53516 }, 	type = "Rare", 			drop = "Toy", 		itemID = 163775, 	faction = "all", 		coord = 47657800,					sort = 27,	isKnown = false },
    [142683] = { name = L["rare_ruul_onestone"], 			lvl = "121",	id = 142683, questId = { 53092, 53524 }, 	type = "Rare", 			drop = "Toy", 		itemID = 163741, 	faction = "all", 		coord = 42905660,					sort = 28,	isKnown = false },
    [142690] = { name = L["rare_singer"], 					lvl = "121",	id = 142690, questId = { 53093, 53525 }, 	type = "Rare", 			drop = "Toy", 		itemID = 163738, 	faction = "all", 		coord = 51213999,					sort = 29,	isKnown = false },
    [142682] = { name = L["rare_zalas_witherbark"], 		lvl = "121",	id = 142682, questId = { 53094, 53530 }, 	type = "Rare", 			drop = "Toy", 		itemID = 163745, 	faction = "all", 		coord = 62858120,					sort = 30,	isKnown = false },
    [141947] = { name = L["rare_boulderfist_brute"], 		lvl = "121",	id = 141947, questId = { 0 }, 				type = "Rare", 			drop = "Nothing", 	itemID = 0, 		faction = "all",											sort = 31					},
}

WRT.isTomTomloaded = false

WRT.colors = {
    white = { 1, 1, 1, 1 },
    red = { 1, 0.12, 0.12, 1 },
    green = { 0, 1, 0, 1 },
    purple = { 0.63, 0.20, 0.93, 1 },
    turqoise = { 0.40, 0.73, 1, 1 },
    yellow = { 1, 0.82, 0, 1 },
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
        unitframes = {
            name = L["unit_frames"],
            order = 2,
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
        colorizeDrops = {
            name = L["colorize_drops_collum"],
            order = 3,
            type = "group",
            inline = true,
            args = {
                enableColorizeDrops = {
                    name = L["colorize_known_items_name"],
                    desc = L["colorize_known_items_desc"],
                    type = "toggle",
                    order = 1,
                    get = function(info)
                            return WRT.db.profile.colorizeDrops.enabled
                        end,
                    set = function(info, value)
                            WRT.db.profile.colorizeDrops.enabled = value
                        end,
                },
                knownColor = {
                    name = L["color_of_known_items_name"],
                    desc = L["color_of_known_items_desc"],
                    type = "color",
                    order = 2,
                    hasAlpha = false,
                    get = function(info)
                            local color = WRT.db.profile.colorizeDrops.knownColor
                            return color[1], color[2], color[3], color[4]
                        end,
                    set = function(info, r, g, b, a)
                            local color = WRT.db.profile.colorizeDrops.knownColor
                            color[1], color[2], color[3], color[4] = r, g, b, a
                        end,
                    disabled = function() return not WRT.db.profile.colorizeDrops.enabled end,
                },
                unknownColor = {
                    name = L["color_of_unknown_items_name"],
                    desc = L["color_of_unknown_items_desc"],
                    type = "color",
                    order = 3,
                    hasAlpha = false,
                    get = function(info)
                            local color = WRT.db.profile.colorizeDrops.unknownColor
                            return color[1], color[2], color[3], color[4]
                        end,
                    set = function(info, r, g, b, a)
                            local color = WRT.db.profile.colorizeDrops.unknownColor
                            color[1], color[2], color[3], color[4] = r, g, b, a
                        end,
                    disabled = function() return not WRT.db.profile.colorizeDrops.enabled end,
                },
            },
        },
        colorizeStatus = {
            name = L["colorize_status_text"],
            order = 4,
            type = "group",
            inline = true,
            args = {
                enableColorizeStatus = {
                    name = L["use_custom_colors_name"],
                    desc = L["use_custom_colors_desc"],
                    type = "toggle",
                    order = 1,
                    get = function(info)
                            return WRT.db.profile.colorizeStatus.enabled
                        end,
                    set = function(info, value)
                            WRT.db.profile.colorizeStatus.enabled = value
                        end,
                },
                available = {
                    name = L["color_of_available_name"],
                    desc = L["color_of_available_desc"],
                    type = "color",
                    order = 2,
                    hasAlpha = false,
                    get = function(info)
                            local color = WRT.db.profile.colorizeStatus.available
                            return color[1], color[2], color[3], color[4]
                        end,
                    set = function(info, r, g, b, a)
                            local color = WRT.db.profile.colorizeStatus.available
                            color[1], color[2], color[3], color[4] = r, g, b, a
                        end,
                    disabled = function() return not WRT.db.profile.colorizeStatus.enabled end,
                },
                defeated = {
                    name = L["color_of_defeated_name"],
                    desc = L["color_of_defeated_desc"],
                    type = "color",
                    order = 3,
                    hasAlpha = false,
                    get = function(info)
                            local color = WRT.db.profile.colorizeStatus.defeated
                            return color[1], color[2], color[3], color[4]
                        end,
                    set = function(info, r, g, b, a)
                            local color = WRT.db.profile.colorizeStatus.defeated
                            color[1], color[2], color[3], color[4] = r, g, b, a
                        end,
                    disabled = function() return not WRT.db.profile.colorizeStatus.enabled end,
                },
            },
        },
        tomtom = {
            name = L["tomtom_integration"],
            order = 5,
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
                tomtomChatMessage = {
                    name = L["tomtom_output_to_chat_name"],
                    desc = L["tomtom_output_to_chat_desc"],
                    type = "toggle",
                    order = 2,
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
    },
}

function WoWRareTracker:OnInitialize()
    WRT.broker = ldb:NewDataObject("WoWRareTracker", {
        type = "data source",
        label = "WoWRareTracker",
        icon = "Interface\\Icons\\ability_ensnare",
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

    self:RegisterChatCommand("wowraretracker", function() LibStub("AceConfigDialog-3.0"):Open("WoWRareTracker") end)
	self:RegisterChatCommand("wrt", function() LibStub("AceConfigDialog-3.0"):Open("WoWRareTracker") end)
end

function WoWRareTracker:DelayedInitialize()
    if IsAddOnLoaded("TomTom") then
        WRT.isTomTomloaded = true
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
        WRT.broker.text = L["wow_rare_tracker"]
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
    end
end

function WoWRareTracker:UpdateToolTip(tooltip)
    local t = sortRares(WRT.rares)
    local line

    tooltip:Clear();
    tooltip:SetColumnLayout(4, "LEFT", "LEFT", "LEFT", "LEFT")

    line = tooltip:AddHeader()
    tooltip:SetCell(line, 1, WoWRareTracker:ColorText(L["wow_rare_tracker"], WRT.colors.yellow), tooltip:GetHeaderFont(), "CENTER", 3)
    line = tooltip:AddLine()
    tooltip:SetCell(line, 1, " ", nil, "LEFT", 3)

    line = tooltip:AddHeader()
    line = tooltip:SetCell(line, 1, L["wrt_table_1"])
	-- line = tooltip:SetCell(line, sortNumber, cellName, nil, allign, 1, LibQTip.LabelProvider, marginLeft, nil, maxWidth, minWidth)
	line = tooltip:SetCell(line, 2, L["wrt_table_2"], nil, "LEFT", 1, LibQTip.LabelProvider, 20, nil, 100, 60)
    line = tooltip:SetCell(line, 3, L["wrt_table_3"], nil, "LEFT", 1, LibQTip.LabelProvider, 20, nil, 100, 60)
    line = tooltip:SetCell(line, 4, L["wrt_table_4"])
    tooltip:AddSeparator()

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
    line = tooltip:SetCell(line, 1, WoWRareTracker:ColorText(L["wrt_mouse_option_right"], WRT.colors.turqoise), "LEFT", 3)
    if WRT.isTomTomloaded and WRT.db.profile.tomtom.enableIntegration then
        line = tooltip:AddLine()
        line = tooltip:SetCell(line, 1, WoWRareTracker:ColorText(L["wrt_mouse_option_left"], WRT.colors.turqoise), "LEFT", 3)
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