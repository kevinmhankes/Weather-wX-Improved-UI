/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class RadarPreferences {

    static var warnings = true
    static var locdotFollowsGps = false
    static var dualpaneshareposn = true
    static var spotters = false
    static var spottersLabel = false
    static var obs = false
    static var obsWindbarbs = false
    static var swo = false
    static var cities = false
    static var hw = true
    static var locDot = false
    static var lakes = false
    static var county = true
    static var countyLabels = false
    static var countyHires = false
    static var stateHires = false
    static var watMcd = false
    static var mpd = false
    static var sti = false
    static var hi = false
    static var tvs = false
    static var hwEnh = true
    static var hwEnhExt = false
    static var camxBorders = false
    static var dataRefreshInterval = 5
    static var showLegend = false
    static var obsExtZoom = 0
    static var spotterSize = 4
    static var aviationSize = 4
    static var textSizePref: Float = 10.0
    static var textSize: Float = 1.0
    static var locdotSize = 4
    static var hiSize = 4
    static var tvsSize = 4
    static var wxoglSize = 10
    static var wxoglRememberLocation = true
    static var wxoglRadarAutorefresh = false
    static var wxoglRadarAutorefreshBoolString = "false"
    static var nexradRadarBackgroundColor = 0
    static var wxoglCenterOnLocation = false
    static var radarShowWpcFronts = false
    static var showRadarWhenPan = true
    static let nexradContinuousMode = true
    static var useFileStorage = false

    static func initialize() {
        if UtilityUI.isTablet() {
            locdotSize = 2
            aviationSize = 2
            spotterSize = 2
        }
        #if targetEnvironment(macCatalyst)
        locdotSize = 1
        hiSize = 1
        tvsSize = 1
        aviationSize = 2
        spotterSize = 1
        textSizePref = 15.0
        textSize = 1.5
        wxoglRadarAutorefreshBoolString = "true"
        #endif
        ObjectPolygonWarning.load()
        ObjectPolygonWatch.load()
        warnings = Utility.readPref("COD_WARNINGS_DEFAULT", "true").hasPrefix("t")
        locdotFollowsGps = Utility.readPref("LOCDOT_FOLLOWS_GPS", "false").hasPrefix("t")
        dualpaneshareposn = Utility.readPref("DUALPANE_SHARE_POSN", "true").hasPrefix("t")
        spotters = Utility.readPref("WXOGL_SPOTTERS", "false").hasPrefix("t")
        spottersLabel = Utility.readPref("WXOGL_SPOTTERS_LABEL", "false").hasPrefix("t")
        swo = Utility.readPref("RADAR_SHOW_SWO", "false").hasPrefix("t")
        obs = Utility.readPref("WXOGL_OBS", "false").hasPrefix("t")
        obsWindbarbs = Utility.readPref("WXOGL_OBS_WINDBARBS", "false").hasPrefix("t")
        cities = Utility.readPref("COD_CITIES_DEFAULT", "").hasPrefix("t")
        hw = Utility.readPref("COD_HW_DEFAULT", "true").hasPrefix("t")
        locDot = Utility.readPref("COD_LOCDOT_DEFAULT", "true").hasPrefix("t")
        lakes = Utility.readPref("COD_LAKES_DEFAULT", "false").hasPrefix("t")
        county = Utility.readPref("RADAR_SHOW_COUNTY", "true").hasPrefix("t")
        watMcd = Utility.readPref("RADAR_SHOW_WATCH", "false").hasPrefix("t")
        mpd = Utility.readPref("RADAR_SHOW_MPD", "false").hasPrefix("t")
        sti = Utility.readPref("RADAR_SHOW_STI", "false").hasPrefix("t")
        hi = Utility.readPref("RADAR_SHOW_HI", "false").hasPrefix("t")
        tvs = Utility.readPref("RADAR_SHOW_TVS", "false").hasPrefix("t")
        hwEnhExt = Utility.readPref("RADAR_HW_ENH_EXT", "false").hasPrefix("t")
        camxBorders = Utility.readPref("RADAR_CAMX_BORDERS", "false").hasPrefix("t")
        countyLabels = Utility.readPref("RADAR_COUNTY_LABELS", "false").hasPrefix("t")
        countyHires = Utility.readPref("RADAR_COUNTY_HIRES", "false").hasPrefix("t")
        stateHires = Utility.readPref("RADAR_STATE_HIRES", "false").hasPrefix("t")
        showLegend = Utility.readPref("RADAR_SHOW_LEGEND", "false").hasPrefix("t")
        obsExtZoom = Utility.readPref("RADAR_OBS_EXT_ZOOM", 7)
        spotterSize = Utility.readPref("RADAR_SPOTTER_SIZE", spotterSize)
        aviationSize = Utility.readPref("RADAR_AVIATION_SIZE", aviationSize)
        textSizePref = Utility.readPref("RADAR_TEXT_SIZE", textSizePref)
        textSize = textSizePref / 10.0
        locdotSize = Utility.readPref("RADAR_LOCDOT_SIZE", locdotSize)
        hiSize = Utility.readPref("RADAR_HI_SIZE", hiSize)
        tvsSize = Utility.readPref("RADAR_TVS_SIZE", tvsSize)
        wxoglSize = Utility.readPref("WXOGL_SIZE", wxoglSize)
        wxoglRememberLocation = Utility.readPref("WXOGL_REMEMBER_LOCATION", "true").hasPrefix("t")
        wxoglRadarAutorefresh = Utility.readPref("RADAR_AUTOREFRESH", wxoglRadarAutorefreshBoolString).hasPrefix("t")
        dataRefreshInterval = Utility.readPref("RADAR_DATA_REFRESH_INTERVAL", 5)
        nexradRadarBackgroundColor = Utility.readPref("NEXRAD_RADAR_BACKGROUND_COLOR", Color.rgb(0, 0, 0))
        wxoglCenterOnLocation = Utility.readPref("RADAR_CENTER_ON_LOCATION", "false").hasPrefix("t")
        radarShowWpcFronts = Utility.readPref("RADAR_SHOW_WPC_FRONTS", "false").hasPrefix("t")
        showRadarWhenPan = Utility.readPref("SHOW_RADAR_WHEN_PAN", "true").hasPrefix("t")
    }
}
