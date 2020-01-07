/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

class RadarPreferences {
    static var radarWarnings = false
    static var locdotFollowsGps = false
    static var dualpaneshareposn = true
    static var radarSpotters = false
    static var radarSpottersLabel = false
    static var radarObs = false
    static var radarObsWindbarbs = false
    static var radarSwo = false
    static var radarCities = false
    static var radarHw = true
    static var radarLocDot = false
    static var radarLakes = false
    static var radarCounty = true
    static var radarCountyLabels = false
    static var radarCountyHires = false
    static var radarStateHires = false
    static var radarWatMcd = false
    static var radarMpd = false
    static var radarSti = false
    static var radarHi = false
    static var radarTvs = false
    static var radarHwEnh = true
    static var radarHwEnhExt = false
    static var radarCamxBorders = false
    static var radarDataRefreshInterval = 5
    static var radarShowLegend = false
    static var radarObsExtZoom = 0
    static var radarSpotterSize = 4
    static var radarAviationSize = 4
    static var radarTextSizePref: Float = 10.0
    static var radarTextSize: Float = 1.0
    static var radarLocdotSize = 4
    static var radarHiSize = 4
    static var radarTvsSize = 4
    static var wxoglSize = 10
    static var wxoglRememberLocation = true
    static var wxoglRadarAutorefresh = false
    static var wxoglRadarAutorefreshBoolString = "false"
    static var nexradRadarBackgroundColor = 0
    static var wxoglCenterOnLocation = false
    static var radarShowWpcFronts = false

    static func initialize() {
        #if targetEnvironment(macCatalyst)
        radarLocdotSize = 1
        radarHiSize = 1
        radarTvsSize = 1
        radarAviationSize = 2
        radarSpotterSize = 2
        radarTextSizePref = 15.0
        radarTextSize = 1.5
        wxoglSize = 20
        wxoglRadarAutorefreshBoolString = "true"
        #endif
        ObjectPolygonWarning.load()
        radarWarnings = Utility.readPref("COD_WARNINGS_DEFAULT", "true").hasPrefix("t")
        locdotFollowsGps = Utility.readPref("LOCDOT_FOLLOWS_GPS", "false").hasPrefix("t")
        dualpaneshareposn = Utility.readPref("DUALPANE_SHARE_POSN", "true").hasPrefix("t")
        radarSpotters = Utility.readPref("WXOGL_SPOTTERS", "false").hasPrefix("t")
        radarSpottersLabel = Utility.readPref("WXOGL_SPOTTERS_LABEL", "false").hasPrefix("t")
        radarSwo = Utility.readPref("RADAR_SHOW_SWO", "false").hasPrefix("t")
        radarObs = Utility.readPref("WXOGL_OBS", "false").hasPrefix("t")
        radarObsWindbarbs = Utility.readPref("WXOGL_OBS_WINDBARBS", "false").hasPrefix("t")
        radarCities = Utility.readPref("COD_CITIES_DEFAULT", "").hasPrefix("t")
        radarHw = Utility.readPref("COD_HW_DEFAULT", "true").hasPrefix("t")
        radarLocDot = Utility.readPref("COD_LOCDOT_DEFAULT", "true").hasPrefix("t")
        radarLakes = Utility.readPref("COD_LAKES_DEFAULT", "false").hasPrefix("t")
        radarCounty = Utility.readPref("RADAR_SHOW_COUNTY", "false").hasPrefix("t")
        radarWatMcd = Utility.readPref("RADAR_SHOW_WATCH", "false").hasPrefix("t")
        radarMpd = Utility.readPref("RADAR_SHOW_MPD", "false").hasPrefix("t")
        radarSti = Utility.readPref("RADAR_SHOW_STI", "false").hasPrefix("t")
        radarHi = Utility.readPref("RADAR_SHOW_HI", "false").hasPrefix("t")
        radarTvs = Utility.readPref("RADAR_SHOW_TVS", "false").hasPrefix("t")
        radarHwEnhExt = Utility.readPref("RADAR_HW_ENH_EXT", "false").hasPrefix("t")
        radarCamxBorders = Utility.readPref("RADAR_CAMX_BORDERS", "false").hasPrefix("t")
        radarCountyLabels = Utility.readPref("RADAR_COUNTY_LABELS", "false").hasPrefix("t")
        radarCountyHires = Utility.readPref("RADAR_COUNTY_HIRES", "false").hasPrefix("t")
        radarStateHires = Utility.readPref("RADAR_STATE_HIRES", "false").hasPrefix("t")
        radarShowLegend = Utility.readPref("RADAR_SHOW_LEGEND", "false").hasPrefix("t")
        radarObsExtZoom = Utility.readPref("RADAR_OBS_EXT_ZOOM", 7)
        radarSpotterSize = Utility.readPref("RADAR_SPOTTER_SIZE", radarSpotterSize)
        radarAviationSize = Utility.readPref("RADAR_AVIATION_SIZE", radarAviationSize)
        radarTextSizePref = Utility.readPref("RADAR_TEXT_SIZE", radarTextSizePref)
        radarTextSize = radarTextSizePref / 10.0
        radarLocdotSize = Utility.readPref("RADAR_LOCDOT_SIZE", radarLocdotSize)
        radarHiSize = Utility.readPref("RADAR_HI_SIZE", radarHiSize)
        radarTvsSize = Utility.readPref("RADAR_TVS_SIZE", radarTvsSize)
        wxoglSize = Utility.readPref("WXOGL_SIZE", wxoglSize)
        wxoglRememberLocation = Utility.readPref("WXOGL_REMEMBER_LOCATION", "true").hasPrefix("t")
        wxoglRadarAutorefresh = Utility.readPref("RADAR_AUTOREFRESH", wxoglRadarAutorefreshBoolString).hasPrefix("t")
        radarDataRefreshInterval = Utility.readPref("RADAR_DATA_REFRESH_INTERVAL", 5)
        nexradRadarBackgroundColor = Utility.readPref("NEXRAD_RADAR_BACKGROUND_COLOR", Color.rgb(0, 0, 0))
        wxoglCenterOnLocation = Utility.readPref("RADAR_CENTER_ON_LOCATION", "false").hasPrefix("t")
        radarShowWpcFronts = Utility.readPref("RADAR_SHOW_WPC_FRONTS", "false").hasPrefix("t")
    }
}
