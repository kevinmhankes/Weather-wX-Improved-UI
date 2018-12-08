/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

struct GeographyType {

    static var stateLines = GeographyType("STATE_LINES",
                                          RadarGeometry.stateRelativeBuffer,
                                          RadarGeometry.countState,
                                          RadarGeometry.radarColorState,
                                          true)
    static var countyLines = GeographyType("COUNTY_LINES",
                                           RadarGeometry.countyRelativeBuffer,
                                           RadarGeometry.countCounty,
                                           RadarGeometry.radarColorCounty,
                                           RadarPreferences.radarCounty)
    static var lakes = GeographyType("LAKES",
                                     RadarGeometry.lakesRelativeBuffer,
                                     RadarGeometry.countLakes,
                                     RadarGeometry.radarColorLakes,
                                     RadarPreferences.radarLakes)
    static var highways = GeographyType("HIGHWAYS",
                                        RadarGeometry.hwRelativeBuffer,
                                        RadarGeometry.countHw,
                                        RadarGeometry.radarColorHw,
                                        RadarPreferences.radarHw)
    static var highwaysExtended = GeographyType("HIGHWAYS_EXTENDED",
                                                RadarGeometry.hwExtRelativeBuffer,
                                                RadarGeometry.countHwExt,
                                                RadarGeometry.radarColorHwExt,
                                                RadarPreferences.radarHwEnhExt)
    static var cities = GeographyType("CITIES",
                                      MemoryBuffer(),
                                      0,
                                      RadarGeometry.radarColorCity,
                                      RadarPreferences.radarCities)
    static var countyLabels = GeographyType("COUNTY_LABELS",
                                            MemoryBuffer(),
                                            0,
                                            RadarGeometry.radarColorCountyLabels,
                                            RadarPreferences.radarCountyLabels)
    static var NONE = GeographyType("NONE",
                                    RadarGeometry.hwExtRelativeBuffer,
                                    0,
                                    RadarGeometry.radarColorHwExt,
                                    false)

    var relativeBuffer: MemoryBuffer = MemoryBuffer()
    var count = 0
    var color = 0
    var display = true
    var string = ""

    init(_ string: String, _ relativeBuffer: MemoryBuffer, _ count: Int, _ color: Int, _ pref: Bool) {
        self.relativeBuffer = relativeBuffer
        self.count = count
        self.color = color
        self.display = pref
    }

    static func regen() {
        stateLines = GeographyType("STATE_LINES",
                                   RadarGeometry.stateRelativeBuffer,
                                   RadarGeometry.countState,
                                   RadarGeometry.radarColorState,
                                   true)
        countyLines = GeographyType("COUNTY_LINES",
                                    RadarGeometry.countyRelativeBuffer,
                                    RadarGeometry.countCounty,
                                    RadarGeometry.radarColorCounty,
                                    RadarPreferences.radarCounty)
        lakes = GeographyType("LAKES",
                              RadarGeometry.lakesRelativeBuffer,
                              RadarGeometry.countLakes,
                              RadarGeometry.radarColorLakes,
                              RadarPreferences.radarLakes)
        highways = GeographyType("HIGHWAYS",
                                 RadarGeometry.hwRelativeBuffer,
                                 RadarGeometry.countHw,
                                 RadarGeometry.radarColorHw,
                                 RadarPreferences.radarHw)
        highwaysExtended = GeographyType("HIGHWAYS_EXTENDED",
                                         RadarGeometry.hwExtRelativeBuffer,
                                         RadarGeometry.countHwExt,
                                         RadarGeometry.radarColorHwExt,
                                         RadarPreferences.radarHwEnhExt)
        cities = GeographyType("CITIES",
                               MemoryBuffer(),
                               0,
                               RadarGeometry.radarColorCity,
                               RadarPreferences.radarCities)
        countyLabels = GeographyType("COUNTY_LABELS",
                                     MemoryBuffer(),
                                     0,
                                     RadarGeometry.radarColorCountyLabels,
                                     RadarPreferences.radarCountyLabels)
        NONE = GeographyType("NONE",
                             RadarGeometry.hwExtRelativeBuffer,
                             0,
                             RadarGeometry.radarColorHwExt,
                             false)
    }
}
