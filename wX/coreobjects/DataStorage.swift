/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

class DataStorage {

    private var preference: String
    private var val: String = ""

    init(_ preference: String) {
        self.preference = preference
    }

    // update in memory value from what is on disk
    func update() {
        value = Utility.readPref(preference, "")
    }

    var value: String {
        get {
            return val
        }
        set {
            //print(UtilityTime.getCurrentLocalTimeAsString()
            // + " " + preference + " " + newValue.truncate(20).replaceAll("\n", ""))
            val = newValue
            Utility.writePref(preference, newValue)
        }
    }
}
