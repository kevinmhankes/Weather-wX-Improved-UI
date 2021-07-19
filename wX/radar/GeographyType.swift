/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

struct GeographyType {
    static var stateLines = GeographyType(
        "STATE_LINES",
        RadarGeometry.stateRelativeBuffer,
        RadarGeometry.countState,
        RadarGeometry.radarColorState,
        true
    )
    static var countyLines = GeographyType(
        "COUNTY_LINES",
        RadarGeometry.countyRelativeBuffer,
        RadarGeometry.countCounty,
        RadarGeometry.radarColorCounty,
        RadarPreferences.county
    )
    static var lakes = GeographyType(
        "LAKES",
        RadarGeometry.lakesRelativeBuffer,
        RadarGeometry.countLakes,
        RadarGeometry.radarColorLakes,
        RadarPreferences.lakes
    )
    static var highways = GeographyType(
        "HIGHWAYS",
        RadarGeometry.hwRelativeBuffer,
        RadarGeometry.countHw,
        RadarGeometry.radarColorHw,
        RadarPreferences.hw
    )
    static var highwaysExtended = GeographyType(
        "HIGHWAYS_EXTENDED",
        RadarGeometry.hwExtRelativeBuffer,
        RadarGeometry.countHwExt,
        RadarGeometry.radarColorHwExt,
        RadarPreferences.hwEnhExt
    )
    static var cities = GeographyType(
        "CITIES",
        MemoryBuffer(),
        0,
        RadarGeometry.radarColorCity,
        RadarPreferences.cities
    )
    static var countyLabels = GeographyType(
        "COUNTY_LABELS",
        MemoryBuffer(),
        0,
        RadarGeometry.radarColorCountyLabels,
        RadarPreferences.countyLabels
    )
    static var NONE = GeographyType(
        "NONE",
        RadarGeometry.hwExtRelativeBuffer,
        0,
        RadarGeometry.radarColorHwExt,
        false
    )

    var relativeBuffer = MemoryBuffer()
    var count = 0
    var color = 0
    var display = true
    var string = ""

    init(_ string: String, _ relativeBuffer: MemoryBuffer, _ count: Int, _ color: Int, _ pref: Bool) {
        self.relativeBuffer = relativeBuffer
        self.count = count
        self.color = color
        display = pref
    }

    static func regen() {
        stateLines = GeographyType(
            "STATE_LINES",
            RadarGeometry.stateRelativeBuffer,
            RadarGeometry.countState,
            RadarGeometry.radarColorState,
            true
        )
        countyLines = GeographyType(
            "COUNTY_LINES",
            RadarGeometry.countyRelativeBuffer,
            RadarGeometry.countCounty,
            RadarGeometry.radarColorCounty,
            RadarPreferences.county
        )
        lakes = GeographyType(
            "LAKES",
            RadarGeometry.lakesRelativeBuffer,
            RadarGeometry.countLakes,
            RadarGeometry.radarColorLakes,
            RadarPreferences.lakes
        )
        highways = GeographyType(
            "HIGHWAYS",
             RadarGeometry.hwRelativeBuffer,
             RadarGeometry.countHw,
             RadarGeometry.radarColorHw,
             RadarPreferences.hw
        )
        highwaysExtended = GeographyType(
            "HIGHWAYS_EXTENDED",
             RadarGeometry.hwExtRelativeBuffer,
             RadarGeometry.countHwExt,
             RadarGeometry.radarColorHwExt,
             RadarPreferences.hwEnhExt
        )
        cities = GeographyType(
            "CITIES",
            MemoryBuffer(),
            0,
            RadarGeometry.radarColorCity,
            RadarPreferences.cities
        )
        countyLabels = GeographyType(
            "COUNTY_LABELS",
             MemoryBuffer(),
             0,
             RadarGeometry.radarColorCountyLabels,
             RadarPreferences.countyLabels
        )
        NONE = GeographyType(
            "NONE",
             RadarGeometry.hwExtRelativeBuffer,
             0,
             RadarGeometry.radarColorHwExt,
             false
        )
    }
}
