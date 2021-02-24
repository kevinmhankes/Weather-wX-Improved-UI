/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class UIPreferences {
    static let tabBarHeight: CGFloat = 48.0
    static let toolbarHeight: CGFloat = 44.0
    static let statusBarHeight: CGFloat = 20.0
    static let toolbarIconSpacing: CGFloat = 17.0
    static let stackviewCardSpacing: CGFloat = 1.0
    static var backButtonAnimation = true
    static var dualpaneRadarIcon = false
    static var unitsM = false
    // This is no longer configurable by the user
    static let unitsF = true
    static var nwsIconTextColor = Color.rgb(38, 97, 139)
    static var nwsIconBottomColor = Color.rgb(255, 255, 255)
    static var textviewFontSize: CGFloat = 16.0
    static var refreshLocMin = 10
    static var tilesPerRow = 3
    static var homescreenTextLength = 500
    static var radarToolbarTransparent = true
    static var mainScreenRadarFab = true
    static var mainScreenCondense = false
    static var nwsIconSize: Float = 80.0
    static var useAwcRadarMosaic = true
    static var goesUseFullResolutionImages = false
    static var useNwsApi = false

    static func initialize() {
        #if targetEnvironment(macCatalyst)
        tilesPerRow = 5
        textviewFontSize = 20.0
        #endif
        useNwsApi = Utility.readPref("USE_NWS_API_SEVEN_DAY", "false").hasPrefix("t")
        goesUseFullResolutionImages = Utility.readPref("GOES_USE_FULL_RESOLUTION_IMAGES", "false").hasPrefix("t")
        // useAwcRadarMosaic = Utility.readPref("USE_AWC_RADAR_MOSAIC", "false").hasPrefix("t")
        backButtonAnimation = Utility.readPref("BACK_ARROW_ANIM", "true").hasPrefix("t")
        dualpaneRadarIcon = Utility.readPref("DUALPANE_RADAR_ICON", "false").hasPrefix("t")
        tilesPerRow = Utility.readPref("UI_TILES_PER_ROW", tilesPerRow)
        homescreenTextLength = Utility.readPref("HOMESCREEN_TEXT_LENGTH_PREF", 500)
        unitsM = Utility.readPref("UNITS_M", "true").hasPrefix("t")
        nwsIconTextColor = Utility.readPref("NWS_ICON_TEXT_COLOR", Color.rgb(38, 97, 139))
        nwsIconBottomColor = Utility.readPref("NWS_ICON_BOTTOM_COLOR", Color.rgb(255, 255, 255))
        refreshLocMin = Utility.readPref("REFRESH_LOC_MIN", 10)
        textviewFontSize = CGFloat(Utility.readPref("TEXTVIEW_FONT_SIZE", Int(textviewFontSize)))
        radarToolbarTransparent = Utility.readPref("RADAR_TOOLBAR_TRANSPARENT", "true").hasPrefix("t")
        mainScreenRadarFab = Utility.readPref("UI_MAIN_SCREEN_RADAR_FAB", "true").hasPrefix("t")
        mainScreenCondense = Utility.readPref("UI_MAIN_SCREEN_CONDENSE", "false").hasPrefix("t")
        nwsIconSize = Utility.readPref("NWS_ICON_SIZE_PREF", 68.0)
    }
}
