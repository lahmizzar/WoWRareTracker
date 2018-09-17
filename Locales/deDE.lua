-- Localization file for deDE by Lahmizzar (valeryon.tv/lahmizzar)
local L = LibStub("AceLocale-3.0"):NewLocale("WoWRareTracker", "deDE")
if not L then return end

--Debug
L["string1"] = "Zeichenkette1"

--Config
L["wow_rare_tracker"] = "WoW Rare Tracker"
L["minimap_broker"] = "Minimap & Data Broker"
L["show_minimap_icon_name"] = "Zeige Minimap Icon"
L["show_minimap_icon_desc"] = "Aktiviert oder Deaktiviert das Minimap Icon"
L["show_broker_text_name"] = "Zeige Data Broker Text"
L["show_broker_text_desc"] = "Wenn aktiviert, wird neben dem Icon der Addon name stehen. (Erfordert ein entsprechendes Data Broker Addon)"
L["show_menu_name"] = "Zeige Rare Menü am Mimimap Button durch"
L["show_menu_desc"] = "Art und weise, wie das Rare Menü angezeigt werden soll."
L["on_mouseover"] = "mit dem Mauszeiger drauf zeigen"
L["on_leftClick"] = "mit der linken Maustaste drauf klicken"
L["unit_frames"] = "Einheitenfenster"
L["npc_unit_frame_text_name"] = "Text im NPC Einheitenfenster (Tooltip)"
L["npc_unit_frame_text_desc"] = "Fügt zusätzliche WoWRareTracker Informationen im Einheitenfenster (Tooltip) an"
L["colorize_drops_column"] = "Farbvarianten in der 'Drop' Spalte"
L["colorize_known_items_name"] = "Benutze Eigene Dropfarben"
L["colorize_known_items_desc"] = "Eigene Farben für bereits erhaltene oder nicht erhaltene Drops anpassen (Deaktiviert = Standardfarben)"
L["color_of_known_items_name"] = "Farbe für erhaltene Items"
L["color_of_known_items_desc"] = "Anpassen der Farbe für bereits erhaltene/bekannte Gegenstände"
L["color_of_unknown_items_name"] = "Farbe für nicht erhaltene Items"
L["color_of_unknown_items_desc"] = "Anpassen der Farbe für noch nicht erhaltene/bekannte Gegenstände"
L["colorize_status_text"] = "Farbvarianten in der 'Status' Spalte"
L["use_custom_colors_name"] = "Benutze Eigene Statusfarben"
L["use_custom_colors_desc"] = "Eigene Farben für noch nicht und bereits getötete Rares anpassen. (Deaktiviert = Standardfarben)"
L["color_of_available_name"] = "Verfügbar"
L["color_of_available_desc"] = "Anpassen der Farbe für den Status 'Verfügbar'"
L["color_of_defeated_name"] = "Nicht verfügbar"
L["color_of_defeated_desc"] = "Anpassen der Farbe für den Status 'Nicht Verfügbar'"
L["tomtom_integration"] = "TomTom Integration (Benötigt TomTom)"
L["tomtom_integration_name"] = "TomTom Integration"
L["tomtom_integration_desc"] = "Erstellt einen TomTom Wegpunkt wenn auf einen Rare mit der linken Maustaste geklickt wird"
L["tomtom_output_to_chat_name"] = "Chatausgabe"
L["tomtom_output_to_chat_desc"] = "Gibt eine Nachricht in deinem Chatfenster aus, wenn ein Wegpunkt erstellt wurde"
L["reset_to_default_name"] = "Standardeinstellungen"
L["reset_to_default_desc"] = "Setzt das Addon zurück auf die Standardeinstellungen"
L["reset_to_default_return"] = "Bist du dir wirklich sicher?"
L["reset_to_default_print"] = "Einstellungen wurden zurückgesetzt!"

-- Addon Menu
L["wrt_table_1"] = "Rare"
L["wrt_table_2"] = "Drop"
L["wrt_table_3"] = "Status"
L["wrt_unknown"] = "Unbekannt"
L["wrt_defeated"] = "Nicht verfügbar"
L["wrt_available"] = "Verfügbar"
L["wrt_mouse_option_left"] = "Links-Klick: Erstellt einen TomTom Wegpunkt."
L["wrt_mouse_option_right"] = "Rechts-Klick: Öffnet die Einstellungen."

-- TomTom
L["tomtom_added_waypoint_to"] = "WRT => Wegpunkt hinzugefügt zu: "

-- Tooltip
L["wrt_tooltip_drop"] = "Drop"

--Rares
L["rare_dooms_howl"] = format("(|cFFffaa00%s|r) Die Heulende Verdammnis", "??+")
L["rare_the_lions_roar"] = "(??+) Der Brüllende Löwe"
L["rare_cresting_goliath"] = "(122) Überschäumender Goliath"
L["rare_burning_goliath"] = "(122) Brennender Goliath"
L["rare_rumbling_goliath"] = "(122) Grollender Goliath"
L["rare_thundering_goliath"] = "(122) Donnernder Goliath"
L["rare_beastrider_kama"] = "(121) Bestienreiter Kama"
L["rare_nimar_the_slayer"] = "(121) Nimar der Töter"
L["rare_overseer_krix"] = "(122) Aufseher Krix"
L["rare_skullripper"] = "(122) Schädelreißer"
L["rare_knight_captain_aldrin"] = "() Kürassier Aldrin"
L["rare_doomrider_helgrim"] = "() Verdammnisreiter Helgrim"
L["rare_branchlord_aldrus"] = "(122) Zweigfürst Aldrus"
L["rare_darbel_montrose"] = "(121) Darbel Montrose"
L["rare_echo_of_myzrael"] = "(122) Echo von Myzrael"
L["rare_fozruk"] = "(122) Fozruk"
L["rare_man_hunter_rog"] = "(122) Menschenjäger Rog"
L["rare_plaguefeather"] = "(122) Seuchenfeder"
L["rare_ragebeak"] = "(122) Zornschnabel"
L["rare_venomarus"] = "(122) Venomarus"
L["rare_yogursa"] = "(122) Yogursa"
L["rare_foulbelly"] = "(121) Faulbauch"
L["rare_geomancer_flintdagger"] = "(121) Geomant Flintdolch"
L["rare_horrific_apparition"] = "(121) Schreckliche Erscheinung"
L["rare_korgresh_coldrage"] = "(121) Kor'gresh Frostzorn"
L["rare_kovork"] = "(121) Kovork"
L["rare_molok_the_crusher"] = "(122) Molok der Zermalmer"
L["rare_ruul_onestone"] = "(121) Ruul Zweistein"
L["rare_singer"] = "(121) Sängerin"
L["rare_zalas_witherbark"] = "(121) Zalas Bleichborke"
L["rare_boulderfist_brute"] = "(121) Schläger der Felsfäuste"
