/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class DataStorage {

    private let preference: String
    private var data: String = ""

    init(_ preference: String) {
        self.preference = preference
    }

    // update in memory value from what is on disk
    func update() {
        value = Utility.readPref(preference, "")
    }

    var value: String {
        get { data }
        set {
            data = newValue
            Utility.writePref(preference, newValue)
        }
    }
}
