/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
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
    static var radarSpotterSize = 0
    static var radarAviationSize = 0
    static var radarTextSize: Float = 0.0
    static var radarLocdotSize = 0
    static var radarHiSize = 0
    static var radarTvsSize = 0
    static var wxoglSize = 0
    static var wxoglRememberLocation = true
    static var wxoglRadarAutorefresh = false
    static var nexradRadarBackgroundColor = 0

    static func initialize() {
        radarWarnings = preferences.getString("COD_WARNINGS_DEFAULT", "true").hasPrefix("t")
        locdotFollowsGps = preferences.getString("LOCDOT_FOLLOWS_GPS", "false").hasPrefix("t")
        dualpaneshareposn = preferences.getString("DUALPANE_SHARE_POSN", "true").hasPrefix("t")
        radarSpotters = preferences.getString("WXOGL_SPOTTERS", "false").hasPrefix("t")
        radarSpottersLabel = preferences.getString("WXOGL_SPOTTERS_LABEL", "false").hasPrefix("t")
        radarSwo = preferences.getString("RADAR_SHOW_SWO", "false").hasPrefix("t")
        radarObs = preferences.getString("WXOGL_OBS", "false").hasPrefix("t")
        radarObsWindbarbs = preferences.getString("WXOGL_OBS_WINDBARBS", "false").hasPrefix("t")
        radarCities = preferences.getString("COD_CITIES_DEFAULT", "").hasPrefix("t")
        radarHw = preferences.getString("COD_HW_DEFAULT", "true").hasPrefix("t")
        radarLocDot = preferences.getString("COD_LOCDOT_DEFAULT", "true").hasPrefix("t")
        radarLakes = preferences.getString("COD_LAKES_DEFAULT", "false").hasPrefix("t")
        radarCounty = preferences.getString("RADAR_SHOW_COUNTY", "false").hasPrefix("t")
        radarWatMcd = preferences.getString("RADAR_SHOW_WATCH", "false").hasPrefix("t")
        radarMpd = preferences.getString("RADAR_SHOW_MPD", "false").hasPrefix("t")
        radarSti = preferences.getString("RADAR_SHOW_STI", "false").hasPrefix("t")
        radarHi = preferences.getString("RADAR_SHOW_HI", "false").hasPrefix("t")
        radarTvs = preferences.getString("RADAR_SHOW_TVS", "false").hasPrefix("t")
        radarHwEnhExt = preferences.getString("RADAR_HW_ENH_EXT", "false").hasPrefix("t")
        radarCamxBorders = preferences.getString("RADAR_CAMX_BORDERS", "false").hasPrefix("t")
        radarCountyLabels = preferences.getString("RADAR_COUNTY_LABELS", "false").hasPrefix("t")
        radarCountyHires = preferences.getString("RADAR_COUNTY_HIRES", "false").hasPrefix("t")
        radarStateHires = preferences.getString("RADAR_STATE_HIRES", "false").hasPrefix("t")
        radarShowLegend = preferences.getString("RADAR_SHOW_LEGEND", "false").hasPrefix("t")
        radarObsExtZoom = preferences.getInt("RADAR_OBS_EXT_ZOOM", 7)
        radarSpotterSize = preferences.getInt("RADAR_SPOTTER_SIZE", 4)
        radarAviationSize = preferences.getInt("RADAR_AVIATION_SIZE", 4)
        radarTextSize = preferences.getFloat("RADAR_TEXT_SIZE", 1.0)
        radarLocdotSize = preferences.getInt("RADAR_LOCDOT_SIZE", 4)
        radarHiSize = preferences.getInt("RADAR_HI_SIZE", 4)
        radarTvsSize = preferences.getInt("RADAR_TVS_SIZE", 4)
        wxoglSize = preferences.getInt("WXOGL_SIZE", 10)
        wxoglRememberLocation = preferences.getString("WXOGL_REMEMBER_LOCATION", "true").hasPrefix("t")
        wxoglRadarAutorefresh = preferences.getString("RADAR_AUTOREFRESH", "false").hasPrefix("t")
        radarDataRefreshInterval = preferences.getInt("RADAR_DATA_REFRESH_INTERVAL", 5)
        nexradRadarBackgroundColor = preferences.getInt("NEXRAD_RADAR_BACKGROUND_COLOR", Color.rgb(0, 0, 0))
    }
}
