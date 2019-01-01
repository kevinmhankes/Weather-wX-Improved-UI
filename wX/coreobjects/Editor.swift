/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class Editor {

    private var preferences = UserDefaults.standard

    func removeObject(_ label: String) {
        preferences.removeObject(forKey: label)
        _ = preferences.synchronize()
    }

    func putString(_ label: String, _ value: String) {
        preferences.set(value, forKey: label)
        _ = preferences.synchronize()
    }

    func putInt(_ label: String, _ value: Int) {
        preferences.set(value, forKey: label)
        _ = preferences.synchronize()
    }

    func putFloat(_ label: String, _ value: Float) {
        preferences.set(value, forKey: label)
        _ = preferences.synchronize()
    }
}
