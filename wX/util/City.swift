/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class City {

    var city = ""
    private var latitude = 0.0
    private var longitude = 0.0
    var latlon = LatLon()

    convenience init(_ label: String, _ latitude: Double, _ longitude: Double) {
        self.init()
        city = label
        self.latitude = latitude
        self.longitude = longitude
        self.latlon = LatLon(latitude, longitude)
    }

    convenience init(_ label: String, _ latlon: LatLon) {
        self.init()
        city = label
        self.latitude = latlon.lat
        self.longitude = latlon.lon
        self.latlon = latlon
    }
}
