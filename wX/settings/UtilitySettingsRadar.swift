/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilitySettingsRadar {

    static let boolean = [
        "COD_WARNINGS_DEFAULT": "Show warnings" ,
        "DUALPANE_SHARE_POSN": "Multi-pane: share lat/lon/zoom",
        "WXOGL_SPOTTERS": "Show spotters",
        "WXOGL_SPOTTERS_LABEL": "Show spotter labels",
        "WXOGL_OBS": "Show observations",
        "WXOGL_OBS_WINDBARBS": "Show windbarbs",
        "LOCDOT_FOLLOWS_GPS": "Location marker follows GPS",
        "RADAR_SHOW_WATCH": "Show WAT/MCD",
        "RADAR_SHOW_COUNTY": "Show counties",
        "RADAR_COUNTY_LABELS": "Show county labels",
        "RADAR_COUNTY_HIRES": "Counties - use hires data",
        "RADAR_STATE_HIRES": "States - use hires data",
        "RADAR_SHOW_STI": "Show storm tracks",
        "RADAR_SHOW_HI": "Show Hail index",
        "RADAR_SHOW_TVS": "Show TVS",
        "RADAR_HW_ENH_EXT": "Hw data, show secondary roads",
        "RADAR_CAMX_BORDERS": "Show CA/MX borders",
        "RADAR_AUTOREFRESH": "Screen on, auto refresh",
        "WXOGL_REMEMBER_LOCATION": "Remember location",
        "RADAR_SHOW_MPD": "Show MPD",
        "COD_CITIES_DEFAULT": "Show cities",
        "COD_HW_DEFAULT": "Show highways",
        "COD_LAKES_DEFAULT": "Show lakes and rivers",
        "COD_LOCDOT_DEFAULT": "Show location marker",
        "RADAR_SHOW_LEGEND": "Show colormap legend",
        "RADAR_SHOW_SWO": "Show Day 1 Conv Otlk",
        "RADAR_SHOW_SMW": "Special Marine Warning",
        "RADAR_SHOW_SQW": "Snow Squall Warning",
        "RADAR_SHOW_DSW": "Dust Storm Warning",
        "RADAR_SHOW_SPS": "Special Weather Statement",
        "RADAR_CENTER_ON_LOCATION": "Center radar on location"
    ]

    static let helpStrings = [
        "Show warnings": "Display warning polygons for tornado, severe thunderstorm, and flash flood."
            + " This will cause a periodic task to run in "
            + "the background and pull data. Interval can be set under settings -> Notifications." ,
        "Multi-pane: share lat/lon/zoom": "If in a multi-pane radar mode each pane will share the "
            + "same zoom lat/lon provided they are using the same radar site.",
        "Show spotters": "Determines whether storm spotters are shown along with radar. "
            + "Color and size for storm spotter markers can also be configured.",
        "Show spotter labels": "Determines whether storm spotter labels are shown along with radar.",
        "Show observations": "Show nearby observations for the state the currently selected radar is in.",
        "Show windbarbs": "Show nearby windbarbs for the state the currently selected radar is in.",
        "Location marker follows GPS": "Location dot will use the GPS of your device and will update on "
            + "every scan as opposed to using the lat/lon "
            + "of youe saved location. If \"Screen on, auto refresh\" is enabled it will update location frequently.",
        "Show WAT/MCD": "Display SPC Watch or MCD polygons. This will cause a periodic task to run in the "
            + "background and pull data. Interval can be set under settings -> Notifications.",
        "Show counties": "Enable counties to be displayed.",
        "Show county labels": "Show centered labels for each county.",
        "Counties - use hires data": "Use a dataset 4 times larger then the default "
            + "county dataset: cb_2015_us_county_5m.kml",
        "States - use hires data": "Use a dataset 9 times larger then the default state dataset: "
            + "cb_2015_us_state_500k.kml This is useful for those looking for accurate coastlines.",
        "Show storm tracks": "If enabled the WXOGL radar will show storm tracks ( predicted future path / speed ).",
        "Show Hail index": "If enabled the WXOGL radar will hail signatures with hail size at or "
            + "greater then 0.50 inch at 50% or higher probability "
            + "as show via upside down green triangle. For estimate hail from 1-2 inches 2 markers will be "
            + "shown and 3 markers for hail from 2-3 inches.",
        "Show TVS": "If enabled the WXOGL radar will show tornado vortext signature as shown via "
            + "upside down triangle with color matching tornado warning/watch polygons.",
        "Hw data, show secondary roads": "Show additional roads when zoomed in.This additional "
            + "dataset is roughly 3.0MB in size.",
        "Show CA/MX borders": "Determines whether borders for Canada and Mexico should be displayed."
            + " Without this setting enabled the state borders "
            + "is roughly 800KB.With this setting enabled the combined borders is roughly 1.5MB.",
        "Screen on, auto refresh": "If enabled the WXOGL activity will attempt to prevent the "
            + "screen from turning off and will auto "
            + "refresh roughly every 3 minutes ( by default ). Interval is configurable. Additionally, "
            + "the GPS will be queried to show your current location on the radar.",
        "Remember location": "WXOGL will use the last location and zoom level instead of the "
            + "radar site for the current location in the main tab.",
        "Show MPD": "Display WPC MPD polygons. This will cause a periodic task to run in the background and pull data.",
        "Show cities": "Display city markers or labels depending on product.",
        "Show highways": "Show highways.",
        "Show lakes and rivers": "Show significant lakes.",
        "Show location marker": "Toggle location ( as in current selected location on first tab ) dot on/off.",
        "Level 2 - use NWS radar feed": "If enabled, use the direct NWS Level 2 radar "
            + "data feed instead of the one from Iowa Mesonet.",
        "Show colormap legend": "Show a colormap legend in the Nexrad radar viewer",
        "Aviation dot size": "Configure size of the circle at the end of wind barbs if configured. Default is 7.",
        "Detailed Observations Zoom": "With observations or wind barbs enabled if you zoom in "
            + "closely on an obs site the detailed METAR will appear."
            + " This setting controls how close you need to zoom. Lower numbers will show "
            + "detailed METAR without having to zoom in as far. Default is 7.",
        "Show Day 1 Conv Otlk": "Show SPC Day 1 Convective Outlook outlines.",

        "Location dot size.": "Allows one to change the size of the location marker. Default value is 5.",
        "Spotter size": "Configure size of storm spotters on radar. Default value is 4.",
        "Warning line size": "Thickness of lines for warnings. Smaller is thinner. Default is 2.",
        "Watch/MCD line size": "Thickness of lines for SPC Watch/MCD. Smaller is thinner. Default is 2.",
        "Reflectivity Colormap": "Colormap to use for Nexrad Reflectivity. Default is CODENH.",
        "Velocity Colormap": "Colormap to use for Nexrad Velocity. Default is CODENH.",
        "Hail marker size": "Allows one to change the size of the Hail markers. Default value is 4.",
        "TVS marker size": "Allows one to change the size of the TVS markers. Default value is 4.",
        "Aviation dot size": "Configure size of the circle at the end of wind barbs if configured. Default is 4.",
        "Detailed Observations Zoom": "With observations or wind barbs enabled if you zoom in closely on an obs site"
            + "the detailed METAR will appear. This setting controls how close you need to zoom."
            +  "Lower numbers will show detailed METAR without having to zoom in as far. Default is 7.",
        "Radar data refresh interval": "Controls the number of minutes before an auto  refresh is triggered "
            + "if that option is enabled. Default is 20.",
        "Radar initial view size": "Allows one to change the default view size for the radar.",
        "Special Marine Warning": "Special Marine Warning",
        "Snow Squall Warning": "Snow Squall Warning",
        "Dust Storm Warning": "Dust Storm Warning",
        "Special Weather Statement": "Special Weather Statement",
        "Center radar on location": "If location marker follows GPS is enabled this will keep the radar centered on your current location when enabled."
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
        "RADAR_CENTER_ON_LOCATION": "false"
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
        "RADAR_CENTER_ON_LOCATION": "false"
    ]
    #endif

    static let picker = [
        "RADAR_COLOR_PALETTE_94": "Reflectivity Colormap",
        "RADAR_COLOR_PALETTE_99": "Velocity Colormap"
    ]

    static let pickerinit: [String: Int] = [:]

    static let pickerCount = [
        "RADAR_COLOR_PALETTE_94": 8,
        "RADAR_COLOR_PALETTE_99": 3
    ]

    static let pickerinitString = [
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
}
