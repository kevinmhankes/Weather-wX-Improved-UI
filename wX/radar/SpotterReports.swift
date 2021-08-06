// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

final class SpotterReports {
    
    let firstName: String
    let lastName: String
    let location: LatLon
    let type: String
    let time: String
    let city: String
    
    init(
        _ firstName: String,
        _ lastName: String,
        _ location: LatLon,
        _ type: String,
        _ time: String,
        _ city: String
    ) {
        self.firstName = firstName
        self.lastName = lastName.replaceAll("^ ", "")
        self.location = location
        self.type = type
        self.time = time
        self.city = city
    }
}
