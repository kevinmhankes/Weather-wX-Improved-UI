/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class Spotter {

    let firstName: String
    let lastName: String
    let reportedAt: String
    private let uniq: String
    let location: LatLon

    init(
        _ firstName: String,
        _ lastName: String,
        _ location: LatLon,
        _ reportedAt: String,
        _ uniq: String
    ) {
        self.firstName = firstName
        self.lastName = lastName.replaceAll("^ ", "").capitalized
        self.location = location
        self.reportedAt = reportedAt
        self.uniq = uniq
    }
}
