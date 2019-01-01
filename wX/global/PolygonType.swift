/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

struct PolygonType {

    static var NONE = PolygonType(RadarGeometry.radarColorMcd, "MCD", false)
    static var MCD = PolygonType(RadarGeometry.radarColorMcd, "MCD", RadarPreferences.radarWatMcd)
    static var MPD = PolygonType(RadarGeometry.radarColorMpd, "MPD", RadarPreferences.radarMpd)
    static var WATCH = PolygonType(RadarGeometry.radarColorTstormWatch, "WATCH", RadarPreferences.radarWatMcd)
    static var WATCH_TORNADO = PolygonType(
        RadarGeometry.radarColorTorWatch,
        "WATCH_TORNADO",
        RadarPreferences.radarWatMcd
    )
    static var TST = PolygonType(RadarGeometry.radarColorTstorm, "TST", RadarPreferences.radarWarnings)
    static var TOR = PolygonType(RadarGeometry.radarColorTor, "TOR", RadarPreferences.radarWarnings)
    static var FFW = PolygonType(RadarGeometry.radarColorFfw, "FFW", RadarPreferences.radarWarnings)
    static var SPOTTER = PolygonType(
        RadarGeometry.radarColorSpotter,
        "SPOTTER",
        RadarPreferences.radarSpotters,
        RadarPreferences.radarSpotterSize
    )
    static var SPOTTER_LABELS = PolygonType(
        RadarGeometry.radarColorSpotter,
        "SPOTTER_LABELS",
        RadarPreferences.radarSpottersLabel
    )
    static var WIND_BARB_GUSTS = PolygonType(Color.RED, "WIND_BARB_GUSTS", RadarPreferences.radarObsWindbarbs)
    static var WIND_BARB = PolygonType(
        RadarGeometry.radarColorObsWindbarbs,
        "WIND_BARB",
        RadarPreferences.radarObsWindbarbs,
        RadarPreferences.radarAviationSize
    )
    static var WIND_BARB_CIRCLE = PolygonType(
        RadarGeometry.radarColorObsWindbarbs,
        "WIND_BARB_CIRCLE",
        RadarPreferences.radarObsWindbarbs,
        RadarPreferences.radarAviationSize
    )
    static var LOCDOT = PolygonType(
        RadarGeometry.radarColorLocdot,
        "LOCDOT",
        RadarPreferences.radarLocDot,
        RadarPreferences.radarLocdotSize
    )
    static var LOCDOT_CIRCLE = PolygonType(
        RadarGeometry.radarColorLocdot,
        "LOCDOT_CIRCLE",
        RadarPreferences.locdotFollowsGps,
        RadarPreferences.radarLocdotSize
    )
    static var STI = PolygonType(RadarGeometry.radarColorSti, "STI", RadarPreferences.radarSti)
    static var TVS = PolygonType(
        RadarGeometry.radarColorTor,
        "TVS",
        RadarPreferences.radarTvs,
        RadarPreferences.radarTvsSize
    )
    static var HI = PolygonType(
        RadarGeometry.radarColorHi,
        "HI",
        RadarPreferences.radarHi,
        RadarPreferences.radarHiSize
    )
    static var OBS = PolygonType(
        RadarGeometry.radarColorObs,
        "OBS",
        RadarPreferences.radarObs
    )
    static var SWO = PolygonType(
        RadarGeometry.radarColorHi,
        "SWO",
        RadarPreferences.radarSwo
    )
    var color = 0
    var string = ""
    var size = 0.0
    var display = false

    init(_ color: Int, _ stringValue: String, _ pref: Bool) {
        self.color = color
        self.string = stringValue
        self.display = pref
    }

    init(_ color: Int, _ stringValue: String, _ pref: Bool, _ size: Int) {
        self.init(color, stringValue, pref)
        self.size = Double(size)
    }

    static func regen() {
        NONE = PolygonType(RadarGeometry.radarColorMcd, "MCD", false)
        MCD = PolygonType(RadarGeometry.radarColorMcd, "MCD", RadarPreferences.radarWatMcd)
        MPD = PolygonType(RadarGeometry.radarColorMpd, "MPD", RadarPreferences.radarMpd)
        WATCH = PolygonType(RadarGeometry.radarColorTstormWatch, "WATCH", RadarPreferences.radarWatMcd)
        WATCH_TORNADO = PolygonType(RadarGeometry.radarColorTorWatch, "WATCH_TORNADO", RadarPreferences.radarWatMcd)
        TST = PolygonType(RadarGeometry.radarColorTstorm, "TST", RadarPreferences.radarWarnings)
        TOR = PolygonType(RadarGeometry.radarColorTor, "TOR", RadarPreferences.radarWarnings)
        FFW = PolygonType(RadarGeometry.radarColorFfw, "FFW", RadarPreferences.radarWarnings)
        SPOTTER = PolygonType(
            RadarGeometry.radarColorSpotter,
            "SPOTTER",
            RadarPreferences.radarSpotters,
            RadarPreferences.radarSpotterSize
        )
        SPOTTER_LABELS = PolygonType(
            RadarGeometry.radarColorSpotter,
            "SPOTTER_LABELS",
            RadarPreferences.radarSpottersLabel
        )
        WIND_BARB_GUSTS = PolygonType(
            Color.RED,
            "WIND_BARB_GUSTS",
            RadarPreferences.radarObsWindbarbs
        )
        WIND_BARB = PolygonType(
            RadarGeometry.radarColorObsWindbarbs,
            "WIND_BARB",
            RadarPreferences.radarObsWindbarbs,
            RadarPreferences.radarAviationSize
        )
        WIND_BARB_CIRCLE = PolygonType(
            RadarGeometry.radarColorObsWindbarbs,
            "WIND_BARB_CIRCLE",
            RadarPreferences.radarObsWindbarbs,
            RadarPreferences.radarAviationSize
        )
        LOCDOT = PolygonType(
            RadarGeometry.radarColorLocdot,
            "LOCDOT",
            RadarPreferences.radarLocDot,
            RadarPreferences.radarLocdotSize
        )
        LOCDOT_CIRCLE = PolygonType(
            RadarGeometry.radarColorLocdot,
            "LOCDOT_CIRCLE",
            RadarPreferences.locdotFollowsGps,
            RadarPreferences.radarLocdotSize
        )
        STI = PolygonType(RadarGeometry.radarColorSti, "STI", RadarPreferences.radarSti)
        TVS = PolygonType(RadarGeometry.radarColorTor, "TVS", RadarPreferences.radarTvs, RadarPreferences.radarTvsSize)
        HI = PolygonType(RadarGeometry.radarColorHi, "HI", RadarPreferences.radarHi, RadarPreferences.radarHiSize)
        OBS = PolygonType(RadarGeometry.radarColorObs, "OBS", RadarPreferences.radarObs)
        SWO = PolygonType(RadarGeometry.radarColorHi, "SWO", RadarPreferences.radarSwo)
    }
}
