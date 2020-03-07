/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class SpotterReports {
    
    var firstName: String
    var lastName: String
    var location: LatLon
    private var narrative: String
    var type: String
    private var uniq: String
    var time: String
    var city: String
    
    init(
        _ firstName: String,
        _ lastName: String,
        _ location: LatLon,
        _ narrative: String,
        _ uniq: String,
        _ type: String,
        _ time: String,
        _ city: String
    ) {
        self.firstName = firstName
        self.lastName = lastName.replaceAll("^ ", "")
        self.location = location
        self.narrative = narrative
        self.uniq = uniq
        self.type = type
        self.time = time
        self.city = city
    }
}
