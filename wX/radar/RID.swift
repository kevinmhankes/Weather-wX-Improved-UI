/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

struct RID {

    var name: String
    var location: LatLon
    var distance = 0

    init(_ name: String, _ location: LatLon) {
        self.name = name
        self.location = location
    }
}
