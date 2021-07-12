/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class to {

    static func String(_ i: Int) -> String {
        return Swift.String(i)
    }
    
    static func String(_ d: Double) -> String {
        return Swift.String(d)
    }
    
    static func String(_ f: Float) -> String {
        return Swift.String(f)
    }
    
    static func Int(_ s: String) -> Int {
        return Swift.Int(s) ?? 0
    }
}
