/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class UtilitySettings {

    static func isRadarInHomeScreen() -> Bool {
        let homeScreenFav = TextUtils.split(Utility.readPref("HOMESCREEN_FAV", GlobalVariables.homescreenFavDefault), ":")
        return homeScreenFav.contains("METAL-RADAR")
    }
}
