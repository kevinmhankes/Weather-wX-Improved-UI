/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class UIPreferences {
    static var toolbarHeight: CGFloat = 44.0
    static var toolbarIconSize = 26
    static var toolbarIconPadding: CGFloat = 11
    static var statusBarHeight: CGFloat = 20.0
    static var toolbarIconSpacing: CGFloat = 17.0
    static var stackviewCardSpacing: CGFloat = 4.0
    static var backButtonAnimation = true
    static var dualpaneRadarIcon = false
    static var showMetarInCC = false
    static var unitsM = false
    static var unitsF = true
    static var nwsIconTextColor = 0
    static var nwsIconBottomColor = 0
    static var textviewFontSize: CGFloat = 16.0
    static var refreshLocMin = 0
    static var nwsTextRemovelinebreaks = false
    static var tilesPerRow = 3
    static var homescreenTextLength = 0
    static var radarToolbarTransparent = true
    static var mainScreenRadarFab = true

    static func initialize() {
        showMetarInCC = preferences.getString("SHOW_METAR_IN_CC", "false").hasPrefix("t")
        backButtonAnimation = preferences.getString("BACK_ARROW_ANIM", "true").hasPrefix("t")
        dualpaneRadarIcon = preferences.getString("DUALPANE_RADAR_ICON", "false").hasPrefix("t")
        tilesPerRow = preferences.getInt("UI_TILES_PER_ROW", tilesPerRow)
        homescreenTextLength = preferences.getInt("HOMESCREEN_TEXT_LENGTH_PREF", 500)
        unitsM = preferences.getString("UNITS_M", "true").hasPrefix("t")
        unitsF = preferences.getString("UNITS_F", "true").hasPrefix("t")
        nwsIconTextColor = preferences.getInt("NWS_ICON_TEXT_COLOR", Color.rgb(38, 97, 139))
        nwsIconBottomColor = preferences.getInt("NWS_ICON_BOTTOM_COLOR", Color.rgb(255, 255, 255))
        refreshLocMin = preferences.getInt("REFRESH_LOC_MIN", 10)
        nwsTextRemovelinebreaks = preferences.getString("NWS_TEXT_REMOVELINEBREAKS", "true").hasPrefix("t")
        textviewFontSize = CGFloat(preferences.getInt("TEXTVIEW_FONT_SIZE", Int(textviewFontSize)))
        radarToolbarTransparent = preferences.getString("RADAR_TOOLBAR_TRANSPARENT", "true").hasPrefix("t")
        mainScreenRadarFab = Utility.readPref("UI_MAIN_SCREEN_RADAR_FAB", "true").hasPrefix("t")
    }
}
