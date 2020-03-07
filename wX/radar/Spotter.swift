/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class Spotter {

    var firstName: String
    var lastName: String
    var reportedAt: String
    var email: String
    var phone: String
    private var uniq: String
    var location = LatLon()

    init(
        _ firstName: String,
        _ lastName: String,
        _ location: LatLon,
        _ reportedAt: String,
        _ email: String,
        _ phone: String,
        _ uniq: String
    ) {
        self.firstName = firstName
        self.lastName = lastName.replaceAll("^ ", "").capitalized
        self.location = location
        self.reportedAt = reportedAt
        self.email = email
        self.phone = phone
        self.uniq = uniq
    }
}
