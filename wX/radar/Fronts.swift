/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class Fronts {
    
    let type: FrontTypeEnum
    var coordinates = [LatLon]()

    init(_ type: FrontTypeEnum) {
        self.type = type
    }
}
