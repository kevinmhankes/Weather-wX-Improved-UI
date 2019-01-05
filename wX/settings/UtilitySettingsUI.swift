/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilitySettingsUI {

    static let boolean  = [
        "NWS_TEXT_REMOVELINEBREAKS": "Remove extra line breaks in text products",
        "UNITS_F": "Use Fahrenheit",
        "UNITS_M": "Use Millibars",
        "METAL_RADAR": "Use Metal radar",
        "BACK_ARROW_ANIM": "Show animation with back arrow" ,
        "DUALPANE_RADAR_ICON": "Dual-pane radar from main screen",
        "WFO_REMEMBER_LOCATION": "WFO - Remember location",
        "SHOW_METAR_IN_CC": "Show Metar in CC",
        "RADAR_TOOLBAR_TRANSPARENT": "Radar: transparent toolbars",
        "UI_MAIN_SCREEN_RADAR_FAB": "Main screen radar button (requires restart)"
    ]

    static let helpStrings = [
        "Remove extra line breaks in text products": "Remove extra line breaks in text products",
        "Use Fahrenheit": "Use Fahrenheit",
        "Use Millibars": "Use Millibars",
        "Use Metal radar": "Use metal radar when clicking on the lightning icon",
        "Show animation with back arrow": "Show animation with back arrow",
        "Dual-pane radar from main screen": "Dual-pane radar from main screen",
        "WFO - Remember location": "Remember the last WFO used for product viewer.",
        "Show Metar in CC": "Show raw Metar in current conditions.",
        "Radar: transparent toolbars": "In the radar screen make the toolbar transparent.",
        "Main screen radar button (requires restart)": "Show a floating action button on"
            + " the main screen for access to radar.",
        "Defaut font size": "Defaut font size. Default is 16.",
        "Color theme": "The default theme is blue. For those who do not like this you can select an alternate.",
        "Refresh interval main screen(min)": "Interval for updating current conditions and"
            + " seven day for selected location.",
        "Animation frame rate": "Animation speed. Lower is faster. Default is 6.",
        "Tiles per row": "Set the number of images tiles in the 2nd and 3rd tab. Default is 3."
            + " Requires an app restart.",
        "Homescreen text length": "Set the length in characters of textual cards on the "
            + "homescreen when not expanded. Default is 500."
    ]

    static let booleanDefault  = [
        "": "",
        "NWS_TEXT_REMOVELINEBREAKS": "true",
        "UNITS_F": "true",
        "UNITS_M": "true",
        "METAL_RADAR": "true",
        "BACK_ARROW_ANIM": "true" ,
        "DUALPANE_RADAR_ICON": "false",
        "WFO_REMEMBER_LOCATION": "false",
        "SHOW_METAR_IN_CC": "false",
        "RADAR_TOOLBAR_TRANSPARENT": "true",
        "UI_MAIN_SCREEN_RADAR_FAB": "true"
    ]

    static let picker = [
        "TEXTVIEW_FONT_SIZE": "Defaut font size" ,
        "UI_THEME": "Color theme" ,
        "REFRESH_LOC_MIN": "Refresh interval main screen(min)" ,
        "ANIM_INTERVAL": "Animation frame rate" ,
        "UI_TILES_PER_ROW": "Tiles per row",
        "HOMESCREEN_TEXT_LENGTH_PREF": "Homescreen text length"
    ]

    static let pickerinit = [
        "TEXTVIEW_FONT_SIZE": "16" ,
        "UI_THEME": "blue" ,
        "REFRESH_LOC_MIN": "10",
        "ANIM_INTERVAL": "6" ,
        "UI_TILES_PER_ROW": "3" ,
        "HOMESCREEN_TEXT_LENGTH_PREF": "500"
    ]

    static let pickerCount = [
        "TEXTVIEW_FONT_SIZE": 21,
        "UI_THEME": 3,
        "REFRESH_LOC_MIN": 121,
        "ANIM_INTERVAL": 16,
        "UI_TILES_PER_ROW": 9,
        "HOMESCREEN_TEXT_LENGTH_PREF": 7
    ]

    static var pickerDataSource = [
        "TEXTVIEW_FONT_SIZE": ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12",
                               "13", "14", "15", "16", "17", "18", "19", "20"],
        "UI_THEME": ["blue", "black", "green"],
        "REFRESH_LOC_MIN": [],
        "ANIM_INTERVAL": [],
        "UI_TILES_PER_ROW": ["0", "1", "2", "3", "4", "5", "6", "7", "8"],
        "HOMESCREEN_TEXT_LENGTH_PREF": []
    ]

    static let pickerNonZeroOffset = [
        "UI_THEME",
        "HOMESCREEN_TEXT_LENGTH_PREF",
        "TEXTVIEW_FONT_SIZE"
    ]
}
