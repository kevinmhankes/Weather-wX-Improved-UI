/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class MyApplication {
    
    static var animInterval = 250
    static var homescreenFav = ""
    static var playlistStr = ""
    
    static func onCreate() {
        initPreferences()
        RadarGeometry.initialize()
        if Utility.readPref("LOC1_LABEL", "") == "" {
            UtilityStorePreferences.setDefaults()
        }
        Location.refreshLocationData()
    }

    static func initPreferences() {
        RadarPreferences.initialize()
        UIPreferences.initialize()
        GlobalVariables.fixedSpace.width = UIPreferences.toolbarIconSpacing
        RadarGeometry.setColors()
        homescreenFav = Utility.readPref("HOMESCREEN_FAV", GlobalVariables.homescreenFavDefault)
        animInterval = Utility.readPref("ANIM_INTERVAL", 6)
        playlistStr = Utility.readPref("PLAYLIST", "")
        Location.setCurrentLocationStr(Utility.readPref("CURRENT_LOC_FRAGMENT", "1"))
        AppColors.update()
        ColorPalettes.initialize()
    }
}
