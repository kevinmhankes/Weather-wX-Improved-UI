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
        "BACK_ARROW_ANIM": "Show animation with back arrow" ,
        "DUALPANE_RADAR_ICON": "Dual-pane radar from main screen",
        "WFO_REMEMBER_LOCATION": "WFO - Remember location",
        "SHOW_METAR_IN_CC": "Show Metar in CC",
        "RADAR_TOOLBAR_TRANSPARENT": "Radar: transparent toolbars",
        "UI_MAIN_SCREEN_RADAR_FAB": "Main screen radar button (requires restart)",
        "UI_MAIN_SCREEN_CONDENSE": "Show less information on main screen",
        "USE_AWC_RADAR_MOSAIC": "Use the AWC Radar mosaic images instead of the main NWS images."
    ]

    static let helpStrings = [
        "Use the AWC Radar mosaic images instead of the main NWS images.": "Use the AWC Radar "
            + "mosaic images instead of the main NWS images.",
        "Remove extra line breaks in text products": "Remove extra line breaks in text products",
        "Use Fahrenheit": "Use Fahrenheit",
        "Use Millibars": "Use Millibars",
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
            + "homescreen when not expanded. Default is 500.",
        "Show less information on main screen": "Show less information on main screen."
            + " Requires an appication restart after changing. This is a work in progress.",
        "NWS Icon size": "NWS Icon size, default size is 80. Requires an appication restart after changing."
            + " This is a work in progress."
    ]

    static let booleanDefault  = [
        "": "",
        "NWS_TEXT_REMOVELINEBREAKS": "true",
        "UNITS_F": "true",
        "UNITS_M": "true",
        "BACK_ARROW_ANIM": "true" ,
        "DUALPANE_RADAR_ICON": "false",
        "WFO_REMEMBER_LOCATION": "false",
        "SHOW_METAR_IN_CC": "false",
        "RADAR_TOOLBAR_TRANSPARENT": "true",
        "UI_MAIN_SCREEN_RADAR_FAB": "true",
        "UI_MAIN_SCREEN_CONDENSE": "false",
        "USE_AWC_RADAR_MOSAIC": "false"
    ]

    static let picker = [
        "UI_THEME": "Color theme"
    ]

    static let pickerinit = [
        "UI_THEME": "blue"
    ]

    static let pickerCount = [
        "UI_THEME": 3
    ]

    static var pickerDataSource = [
        "UI_THEME": ["blue", "black", "green"]
    ]

    static let pickerNonZeroOffset = [
        "UI_THEME"
    ]
}
