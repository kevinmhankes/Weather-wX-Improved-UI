/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

struct PressureCenter {
    var type: PressureCenterTypeEnum
    var pressureInMb: String
    var lat: Double
    var lon: Double
    
    init(_ type: PressureCenterTypeEnum, _ pressureInMb: String, _ lat: Double, _ lon: Double) {
        self.type = type
        self.pressureInMb = pressureInMb
        self.lat = lat
        self.lon = lon
        //print("PRESSURE: " + pressureInMb + " " + String(lat) + " " + String(lon))
    }
}
