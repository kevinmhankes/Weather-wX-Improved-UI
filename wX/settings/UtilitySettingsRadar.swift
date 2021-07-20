/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilitySettingsRadar {

    static let boolean = [
        "COD_WARNINGS_DEFAULT": "Warnings (Tor/Tstorm/Ffw)" ,
        "DUALPANE_SHARE_POSN": "Multi-pane: share lat/lon/zoom",
        "WXOGL_SPOTTERS": "Spotters",
        "WXOGL_SPOTTERS_LABEL": "Spotter Labels",
        "WXOGL_OBS": "Observations",
        "WXOGL_OBS_WINDBARBS": "Windbarbs",
        "LOCDOT_FOLLOWS_GPS": "Location marker follows GPS",
        "RADAR_SHOW_WATCH": "Watches and MCDs",
        "RADAR_SHOW_COUNTY": "County Lines",
        "RADAR_COUNTY_LABELS": "County Labels",
        "RADAR_COUNTY_HIRES": "Counties use high resolution data",
        "RADAR_STATE_HIRES": "States use high resolution data",
        "RADAR_SHOW_STI": "Storm Tracks",
        "RADAR_SHOW_HI": "Hail Index",
        "RADAR_SHOW_TVS": "Tornado Vortex Signatures",
        "RADAR_HW_ENH_EXT": "Secondary Roads",
        "RADAR_CAMX_BORDERS": "Canadian and Mexican borders",
        "RADAR_AUTOREFRESH": "Screen stays on and auto refresh radar",
        "WXOGL_REMEMBER_LOCATION": "Remember location",
        "RADAR_SHOW_MPD": "WPC MPD: Mesoscale Precipitation Discussions",
        "COD_CITIES_DEFAULT": "Cities",
        "COD_HW_DEFAULT": "Highways",
        "COD_LAKES_DEFAULT": "Lakes and Rivers",
        "COD_LOCDOT_DEFAULT": "Location Markers",
        "RADAR_SHOW_LEGEND": "Colormap Legend",
        "RADAR_SHOW_SWO": "Day 1 Convective Outlook",
        "RADAR_SHOW_SMW": "Special Marine Warning",
        "RADAR_SHOW_SQW": "Snow Squall Warning",
        "RADAR_SHOW_DSW": "Dust Storm Warning",
        "RADAR_SHOW_SPS": "Special Weather Statement",
        "RADAR_CENTER_ON_LOCATION": "Center radar on location",
        "RADAR_SHOW_WPC_FRONTS": "WPC Fronts and pressure highs and lows",
        "SHOW_RADAR_WHEN_PAN": "Show radar during a pan/drag motion"
    ]

    #if !targetEnvironment(macCatalyst)
    static let booleanDefault = [
        "COD_WARNINGS_DEFAULT": "true" ,
        "DUALPANE_SHARE_POSN": "true",
        "WXOGL_SPOTTERS": "false",
        "WXOGL_SPOTTERS_LABEL": "false",
        "WXOGL_OBS": "false",
        "WXOGL_OBS_WINDBARBS": "false",
        "LOCDOT_FOLLOWS_GPS": "false",
        "RADAR_SHOW_WATCH": "false",
        "RADAR_SHOW_COUNTY": "true",
        "RADAR_COUNTY_LABELS": "false",
        "RADAR_COUNTY_HIRES": "false",
        "RADAR_STATE_HIRES": "false",
        "RADAR_SHOW_STI": "false",
        "RADAR_SHOW_HI": "false",
        "RADAR_SHOW_TVS": "false",
        "RADAR_HW_ENH_EXT": "false",
        "RADAR_CAMX_BORDERS": "false",
        "RADAR_AUTOREFRESH": "false",
        "WXOGL_REMEMBER_LOCATION": "true",
        "RADAR_SHOW_MPD": "false",
        "COD_CITIES_DEFAULT": "false",
        "COD_HW_DEFAULT": "true",
        "COD_LAKES_DEFAULT": "false",
        "COD_LOCDOT_DEFAULT": "true",
        "RADAR_LEVEL2_USE_NWS": "true",
        "RADAR_SHOW_LEGEND": "false",
        "RADAR_SHOW_SWO": "false",
        "RADAR_SHOW_SMW": "false",
        "RADAR_SHOW_SQW": "false",
        "RADAR_SHOW_DSW": "false",
        "RADAR_SHOW_SPS": "false",
        "RADAR_CENTER_ON_LOCATION": "false",
        "RADAR_SHOW_WPC_FRONTS": "false",
        "SHOW_RADAR_WHEN_PAN": "true"
    ]
    #endif
    #if targetEnvironment(macCatalyst)
    static let booleanDefault = [
        "COD_WARNINGS_DEFAULT": "true" ,
        "DUALPANE_SHARE_POSN": "true",
        "WXOGL_SPOTTERS": "false",
        "WXOGL_SPOTTERS_LABEL": "false",
        "WXOGL_OBS": "false",
        "WXOGL_OBS_WINDBARBS": "false",
        "LOCDOT_FOLLOWS_GPS": "false",
        "RADAR_SHOW_WATCH": "false",
        "RADAR_SHOW_COUNTY": "true",
        "RADAR_COUNTY_LABELS": "false",
        "RADAR_COUNTY_HIRES": "false",
        "RADAR_STATE_HIRES": "false",
        "RADAR_SHOW_STI": "false",
        "RADAR_SHOW_HI": "false",
        "RADAR_SHOW_TVS": "false",
        "RADAR_HW_ENH_EXT": "false",
        "RADAR_CAMX_BORDERS": "false",
        "RADAR_AUTOREFRESH": "true",
        "WXOGL_REMEMBER_LOCATION": "true",
        "RADAR_SHOW_MPD": "false",
        "COD_CITIES_DEFAULT": "false",
        "COD_HW_DEFAULT": "true",
        "COD_LAKES_DEFAULT": "false",
        "COD_LOCDOT_DEFAULT": "true",
        "RADAR_LEVEL2_USE_NWS": "true",
        "RADAR_SHOW_LEGEND": "false",
        "RADAR_SHOW_SWO": "false",
        "RADAR_SHOW_SMW": "false",
        "RADAR_SHOW_SQW": "false",
        "RADAR_SHOW_DSW": "false",
        "RADAR_SHOW_SPS": "false",
        "RADAR_CENTER_ON_LOCATION": "false",
        "RADAR_SHOW_WPC_FRONTS": "false",
        "SHOW_RADAR_WHEN_PAN": "true"
    ]
    #endif

    static let picker = [
        "RADAR_COLOR_PALETTE_94": "Reflectivity Colormap",
        "RADAR_COLOR_PALETTE_99": "Velocity Colormap"
    ]

    static let pickerInit: [String: Int] = [:]

    static let pickerCount = [
        "RADAR_COLOR_PALETTE_94": 8,
        "RADAR_COLOR_PALETTE_99": 3
    ]

    static let pickerInitString = [
        "RADAR_COLOR_PALETTE_94": "CODENH",
        "RADAR_COLOR_PALETTE_99": "CODENH"
    ]

    static let pickerDataSource = [
        "RADAR_COLOR_PALETTE_94": ["CODENH", "DKenh", "NSSL", "NWSD", "GREEN", "AF", "EAK", "NWS"],
        "RADAR_COLOR_PALETTE_99": ["CODENH", "AF", "EAK"]
    ]

    static let pickerNonZeroOffset = [
        "RADAR_COLOR_PALETTE_94",
        "RADAR_COLOR_PALETTE_99"
    ]
    
    static let sliderPreferences = [
        "RADAR_HI_SIZE",
        "RADAR_TVS_SIZE",
        "RADAR_LOCDOT_SIZE",
        "RADAR_OBS_EXT_ZOOM",
        "RADAR_SPOTTER_SIZE",
        "RADAR_AVIATION_SIZE",
        "RADAR_OBS_EXT_ZOOM",
        "RADAR_DATA_REFRESH_INTERVAL",
        "WXOGL_SIZE",
        "RADAR_TEXT_SIZE"
    ]
}
