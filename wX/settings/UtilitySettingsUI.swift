/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilitySettingsUI {

    static let boolean  = [
        "UNITS_M": "Use Millibars",
        "BACK_ARROW_ANIM": "Show animation with back arrow" ,
        "DUALPANE_RADAR_ICON": "Lightning button opens dual pane radar",
        "WFO_REMEMBER_LOCATION": "WFO text viewer remembers location",
        "RADAR_TOOLBAR_TRANSPARENT": "Radar uses transparent toolbars",
        "UI_MAIN_SCREEN_RADAR_FAB": "Main screen radar button (requires restart)",
        "UI_MAIN_SCREEN_CONDENSE": "Show less information on main screen",
        "USE_AWC_RADAR_MOSAIC": "Use the AWC Radar mosaic images instead of the NWS images",
        "GOES_USE_FULL_RESOLUTION_IMAGES": "Use full resolution GOES images",
        "USE_NWS_API_SEVEN_DAY": "Use new NWS API for 7 day"
    ]

    static let booleanDefault  = [
        "": "",
        "UNITS_M": "true",
        "BACK_ARROW_ANIM": "true" ,
        "DUALPANE_RADAR_ICON": "false",
        "WFO_REMEMBER_LOCATION": "false",
        "RADAR_TOOLBAR_TRANSPARENT": "true",
        "UI_MAIN_SCREEN_RADAR_FAB": "true",
        "UI_MAIN_SCREEN_CONDENSE": "false",
        "USE_AWC_RADAR_MOSAIC": "false",
        "GOES_USE_FULL_RESOLUTION_IMAGES": "false",
        "USE_NWS_API_SEVEN_DAY": "true"
    ]

    static let picker = [
        "UI_THEME": "Color theme"
    ]

    static let pickerInit = [
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
