/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

class DataStorage {

    private let preference: String
    private var val: String = ""

    init(_ preference: String) {
        self.preference = preference
    }

    // update in memory value from what is on disk
    func update() { value = Utility.readPref(preference, "") }

    var value: String {
        get { val }
        set {
            val = newValue
            Utility.writePref(preference, newValue)
        }
    }
}
