// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

struct PolygonType {
    static var NONE = PolygonType(RadarGeometry.radarColorMcd, "", false) // was "MCD"
    static var SMW = PolygonType(
        ObjectPolygonWarning.polygonDataByType[PolygonTypeGeneric.SMW]!.color,
        "SMW",
        ObjectPolygonWarning.polygonDataByType[PolygonTypeGeneric.SMW]!.isEnabled
    )
    static var SQW = PolygonType(
        ObjectPolygonWarning.polygonDataByType[PolygonTypeGeneric.SQW]!.color,
        "SQW",
        ObjectPolygonWarning.polygonDataByType[PolygonTypeGeneric.SQW]!.isEnabled
    )
    static var DSW = PolygonType(
        ObjectPolygonWarning.polygonDataByType[PolygonTypeGeneric.DSW]!.color,
        "DSW",
        ObjectPolygonWarning.polygonDataByType[PolygonTypeGeneric.DSW]!.isEnabled
    )
    static var SPS = PolygonType(
        ObjectPolygonWarning.polygonDataByType[PolygonTypeGeneric.SPS]!.color,
        "SPS",
        ObjectPolygonWarning.polygonDataByType[PolygonTypeGeneric.SPS]!.isEnabled
    )
    static var MCD = PolygonType(RadarGeometry.radarColorMcd, "MCD", RadarPreferences.watMcd)
    static var MPD = PolygonType(RadarGeometry.radarColorMpd, "MPD", RadarPreferences.mpd)
    static var WATCH = PolygonType(RadarGeometry.radarColorTstormWatch, "WATCH", RadarPreferences.watMcd)
    static var WATCH_TORNADO = PolygonType(
        RadarGeometry.radarColorTorWatch,
        "WATCH_TORNADO",
        RadarPreferences.watMcd
    )
    static var TST = PolygonType(RadarGeometry.radarColorTstorm, "TST", RadarPreferences.warnings)
    static var TOR = PolygonType(RadarGeometry.radarColorTor, "TOR", RadarPreferences.warnings)
    static var FFW = PolygonType(RadarGeometry.radarColorFfw, "FFW", RadarPreferences.warnings)
    static var SPOTTER = PolygonType(
        RadarGeometry.radarColorSpotter,
        "SPOTTER",
        RadarPreferences.spotters,
        RadarPreferences.spotterSize
    )
    static var SPOTTER_LABELS = PolygonType(
        RadarGeometry.radarColorSpotter,
        "SPOTTER_LABELS",
        RadarPreferences.spottersLabel
    )
    static var WIND_BARB_GUSTS = PolygonType(
        Color.RED,
        "WIND_BARB_GUSTS",
        RadarPreferences.obsWindbarbs,
        RadarPreferences.aviationSize
    )
    static var WIND_BARB = PolygonType(
        RadarGeometry.radarColorObsWindbarbs,
        "WIND_BARB",
        RadarPreferences.obsWindbarbs,
        RadarPreferences.aviationSize
    )
    static var WIND_BARB_CIRCLE = PolygonType(
        RadarGeometry.radarColorObsWindbarbs,
        "WIND_BARB_CIRCLE",
        RadarPreferences.obsWindbarbs,
        RadarPreferences.aviationSize
    )
    static var LOCDOT = PolygonType(
        RadarGeometry.radarColorLocdot,
        "LOCDOT",
        RadarPreferences.locDot,
        RadarPreferences.locdotSize
    )
    static var LOCDOT_CIRCLE = PolygonType(
        RadarGeometry.radarColorLocdot,
        "LOCDOT_CIRCLE",
        RadarPreferences.locdotFollowsGps,
        RadarPreferences.locdotSize
    )
    static var STI = PolygonType(RadarGeometry.radarColorSti, "STI", RadarPreferences.sti)
    static var TVS = PolygonType(
        RadarGeometry.radarColorTor,
        "TVS",
        RadarPreferences.tvs,
        RadarPreferences.tvsSize
    )
    static var HI = PolygonType(
        RadarGeometry.radarColorHi,
        "HI",
        RadarPreferences.hi,
        RadarPreferences.hiSize
    )
    static var OBS = PolygonType(
        RadarGeometry.radarColorObs,
        "OBS",
        RadarPreferences.obs
    )
    static var SWO = PolygonType(
        RadarGeometry.radarColorHi,
        "SWO",
        RadarPreferences.swo
    )
    var color = 0
    var string = ""
    var size = 0.0
    var display = false

    init(_ color: Int, _ stringValue: String, _ pref: Bool) {
        self.color = color
        string = stringValue
        display = pref
    }

    init(_ color: Int, _ stringValue: String, _ pref: Bool, _ size: Int) {
        self.init(color, stringValue, pref)
        self.size = Double(size)
    }

    static func regen() {
        NONE = PolygonType(RadarGeometry.radarColorMcd, "", false) // was "MCD"
        SMW = PolygonType(
            ObjectPolygonWarning.polygonDataByType[PolygonTypeGeneric.SMW]!.color,
            "SMW",
            ObjectPolygonWarning.polygonDataByType[PolygonTypeGeneric.SMW]!.isEnabled
        )
        SQW = PolygonType(
            ObjectPolygonWarning.polygonDataByType[PolygonTypeGeneric.SQW]!.color,
            "SQW",
            ObjectPolygonWarning.polygonDataByType[PolygonTypeGeneric.SQW]!.isEnabled
        )
        DSW = PolygonType(
            ObjectPolygonWarning.polygonDataByType[PolygonTypeGeneric.DSW]!.color,
            "DSW",
            ObjectPolygonWarning.polygonDataByType[PolygonTypeGeneric.DSW]!.isEnabled
        )
        SPS = PolygonType(
            ObjectPolygonWarning.polygonDataByType[PolygonTypeGeneric.SPS]!.color,
            "SPS",
            ObjectPolygonWarning.polygonDataByType[PolygonTypeGeneric.SPS]!.isEnabled
        )
        MCD = PolygonType(RadarGeometry.radarColorMcd, "MCD", RadarPreferences.watMcd)
        MPD = PolygonType(RadarGeometry.radarColorMpd, "MPD", RadarPreferences.mpd)
        WATCH = PolygonType(RadarGeometry.radarColorTstormWatch, "WATCH", RadarPreferences.watMcd)
        WATCH_TORNADO = PolygonType(RadarGeometry.radarColorTorWatch, "WATCH_TORNADO", RadarPreferences.watMcd)
        TST = PolygonType(RadarGeometry.radarColorTstorm, "TST", RadarPreferences.warnings)
        TOR = PolygonType(RadarGeometry.radarColorTor, "TOR", RadarPreferences.warnings)
        FFW = PolygonType(RadarGeometry.radarColorFfw, "FFW", RadarPreferences.warnings)
        SPOTTER = PolygonType(
            RadarGeometry.radarColorSpotter,
            "SPOTTER",
            RadarPreferences.spotters,
            RadarPreferences.spotterSize
        )
        SPOTTER_LABELS = PolygonType(
            RadarGeometry.radarColorSpotter,
            "SPOTTER_LABELS",
            RadarPreferences.spottersLabel
        )
        WIND_BARB_GUSTS = PolygonType(
            Color.RED,
            "WIND_BARB_GUSTS",
            RadarPreferences.obsWindbarbs,
            RadarPreferences.aviationSize
        )
        WIND_BARB = PolygonType(
            RadarGeometry.radarColorObsWindbarbs,
            "WIND_BARB",
            RadarPreferences.obsWindbarbs,
            RadarPreferences.aviationSize
        )
        WIND_BARB_CIRCLE = PolygonType(
            RadarGeometry.radarColorObsWindbarbs,
            "WIND_BARB_CIRCLE",
            RadarPreferences.obsWindbarbs,
            RadarPreferences.aviationSize
        )
        LOCDOT = PolygonType(
            RadarGeometry.radarColorLocdot,
            "LOCDOT",
            RadarPreferences.locDot,
            RadarPreferences.locdotSize
        )
        LOCDOT_CIRCLE = PolygonType(
            RadarGeometry.radarColorLocdot,
            "LOCDOT_CIRCLE",
            RadarPreferences.locdotFollowsGps,
            RadarPreferences.locdotSize
        )
        STI = PolygonType(RadarGeometry.radarColorSti, "STI", RadarPreferences.sti)
        TVS = PolygonType(RadarGeometry.radarColorTor, "TVS", RadarPreferences.tvs, RadarPreferences.tvsSize)
        HI = PolygonType(RadarGeometry.radarColorHi, "HI", RadarPreferences.hi, RadarPreferences.hiSize)
        OBS = PolygonType(RadarGeometry.radarColorObs, "OBS", RadarPreferences.obs)
        SWO = PolygonType(RadarGeometry.radarColorHi, "SWO", RadarPreferences.swo)
    }
}
