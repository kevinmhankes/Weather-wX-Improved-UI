/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class LatLonStr {

    var latStr: String = ""
    var lonStr: String = ""

    init() {}

    init(_ latStr: String, _ lonStr: String) {
        self.latStr = latStr
        self.lonStr = lonStr
    }
}
