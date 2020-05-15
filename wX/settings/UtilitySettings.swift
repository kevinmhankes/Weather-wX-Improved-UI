/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class UtilitySettings {

    static func isRadarInHomeScreen() -> Bool {
        let homeScreenFav = TextUtils.split(Utility.readPref("HOMESCREEN_FAV", MyApplication.homescreenFavDefault), ":")
        return homeScreenFav.contains("METAL-RADAR")
    }

    static func getHelp(_ uiv: UIViewController, _ targetButton: UIBarButtonItem, _ help: String) {
        let alert = ObjectPopUp(uiv, help, targetButton)
        alert.addAction(UIAlertAction(title: "", style: .default, handler: nil))
        alert.finish()
    }
}
