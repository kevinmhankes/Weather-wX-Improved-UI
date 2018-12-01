/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class Preferences {

    private var preferences = UserDefaults.standard

    func getString(_ label: String, _ value: String) -> String {
        if preferences.object(forKey: label) == nil {
            return value
        } else {
            return preferences.string(forKey: label)!
        }
    }

    func getInt(_ label: String, _ value: Int) -> Int {
        if preferences.object(forKey: label) == nil {
            return value
        } else {
            return preferences.integer(forKey: label)
        }
    }

    func getFloat(_ label: String, _ value: Float) -> Float {
        if preferences.object(forKey: label) == nil {
            return value
        } else {
            return preferences.float(forKey: label)
        }
    }
}
