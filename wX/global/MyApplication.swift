/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class MyApplication {
    
    static var animInterval = 250
    static var radarColorPalette = [Int: String]()
    static var homescreenFav = ""
    static let severeDashboardTor = DataStorage("SEVERE_DASHBOARD_TOR")
    static let severeDashboardTst = DataStorage("SEVERE_DASHBOARD_TST")
    static let severeDashboardFfw = DataStorage("SEVERE_DASHBOARD_FFW")
    static let severeDashboardWat = DataStorage("SEVERE_DASHBOARD_WAT")
    static let severeDashboardMcd = DataStorage("SEVERE_DASHBOARD_MCD")
    static let severeDashboardMpd = DataStorage("SEVERE_DASHBOARD_MPD")
    static let watchLatlon = DataStorage("WATCH_LATLON")
    static let watchLatlonTor = DataStorage("WATCH_LATLON_TOR")
    static let watchLatlonCombined = DataStorage("WATCH_LATLON_COMBINED")
    static let watNoList = DataStorage("WAT_NO_LIST")
    static let mcdLatlon = DataStorage("MCD_LATLON")
    static let mcdNoList = DataStorage("MCD_NO_LIST")
    static let mpdLatlon = DataStorage("MPD_LATLON")
    static let mpdNoList = DataStorage("MPD_NO_LIST")
    static var playlistStr = ""
    static var colorMap = [Int: ObjectColorPalette]()

    static func onCreate() {
        initPreferences()
        AppColors.update()
        ColorPalettes.initialize()
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
        [94, 99, 134, 135, 159, 161, 163, 165, 172].forEach { product in
            radarColorPalette[product] = Utility.readPref("RADAR_COLOR_PALETTE_" + String(product), "CODENH")
        }
        homescreenFav = Utility.readPref("HOMESCREEN_FAV", GlobalVariables.homescreenFavDefault)
        animInterval = Utility.readPref("ANIM_INTERVAL", 6)
        playlistStr = Utility.readPref("PLAYLIST", "")
        Location.setCurrentLocationStr(Utility.readPref("CURRENT_LOC_FRAGMENT", "1"))
        severeDashboardTor.update()
        severeDashboardTst.update()
        severeDashboardFfw.update()
        severeDashboardWat.update()
        severeDashboardMcd.update()
        severeDashboardMpd.update()
        watchLatlon.update()
        watchLatlonTor.update()
        watchLatlonCombined.update()
        watNoList.update()
        mcdLatlon.update()
        mcdNoList.update()
        mpdLatlon.update()
        mpdNoList.update()
    }
}
