/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class UtilityList {

    static func findex(_ value: String, _ items: [String]) -> Int {
        for index in items.indices {
            if items[index].startswith(value) {
                return index
            }
        }
        return 0
    }
}
