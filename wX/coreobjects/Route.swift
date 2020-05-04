/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class Route {
    
    static func join(_ delimiter: String, _ data: Set<String>) -> String {
        var string = ""
        data.forEach { string += $0 + delimiter }
        return string
    }
}
