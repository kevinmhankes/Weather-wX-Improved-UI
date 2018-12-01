/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class Spotter {

    var firstName: String
    var lastName: String
    var lat: String
    var lon: String
    var reportedAt: String
    var email: String
    var phone: String
    private var uniq: String
    var latD: Double
    var lonD: Double
    var location = LatLon()

    init(_ firstName: String, _ lastName: String, _ lat: String, _ lon: String,
         _ reportedAt: String, _ email: String, _ phone: String, _ uniq: String) {
        self.firstName = firstName
        self.lastName = lastName.replaceAll("^ ", "").capitalized
        self.lat = lat
        self.lon = lon
        self.reportedAt = reportedAt
        self.email = email
        self.phone = phone
        self.uniq = uniq
        latD = Double(lat) ?? 0.0
        lonD = -1.0 * (Double(lon) ?? 0.0)
        location = LatLon(latD, lonD)
    }
}
