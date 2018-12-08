/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class MyApplication {
    
    static let copyright = "©"
    static let appName = "wXL23"
    static let appCreatorEmail = "joshua.tee@gmail.com"
    static let aboutStr = "\(appName) is an efficient and configurable method to access weather content from the National Weather Service, Environment Canada, NSSL WRF, and Blitzortung.org. Software is provided \"as is\". Use at your own risk. Use for educational purposes and non-commercial purposes only. Do not use for operational purposes.  " + copyright + "2016-2018 joshua.tee@gmail.com . Please report bugs or suggestions via email to me as opposed to app store reviews. \(appName) is bi-licensed under the Mozilla Public License Version 2 as well as the GNU General Public License Version 3 or later. For more information on the licenses please go here: https://www.mozilla.org/en-US/MPL/2.0/ and http://www.gnu.org/licenses/gpl-3.0.en.html"

    static let emailAsString: String = "joshua.tee@gmail.com"
    static let nwsSPCwebsitePrefix: String = "https://www.spc.noaa.gov"
    static let nwsWPCwebsitePrefix: String = "https://www.wpc.ncep.noaa.gov"
    static let nwsAWCwebsitePrefix: String = "https://www.aviationweather.gov"
    static let nwsGraphicalWebsitePrefix: String = "http://graphical.weather.gov"
    static let nwsCPCNcepWebsitePrefix: String = "http://www.cpc.ncep.noaa.gov"
    static let nwsGoesWebsitePrefix: String = "https://www.goes.noaa.gov"
    static let nwsOpcWebsitePrefix: String = "http://www.opc.ncep.noaa.gov"
    static let nwsNhcWebsitePrefix: String = "https://www.nhc.noaa.gov"
    static let nwsRadarWebsitePrefix: String = "https://radar.weather.gov"
    static let nwsMagNcepWebsitePrefix: String = "https://mag.ncep.noaa.gov"
    static let sunMoonDataUrl: String = "https://api.usno.navy.mil"
    static let currentConditionsViaMetar = true
    static let degreeSymbol = "\u{00B0}"
    static let textviewMagicFudgeFactor: Float = 4.05
    static var deviceScale: Float = 0.0
    static let notifStrSep = ","
    static var animInterval = 250
    static let newline = "\n"
    static let prePattern = "<pre.*?>(.*?)</pre>"
    static let pre2Pattern = "<pre>(.*?)</pre>"
    static var helpMode = false
    static var radarColorPalette = [String: String]()
    static var homescreenFav = ""
    static let homescreenFavDefault = "TXT-CC2:TXT-HAZ:TXT-7DAY2:"
    static let severeDashboardTor = DataStorage("SEVERE_DASHBOARD_TOR")
    static let severeDashboardTst = DataStorage("SEVERE_DASHBOARD_TST")
    static let severeDashboardFfw = DataStorage("SEVERE_DASHBOARD_FFW")
    static let severeDashboardWat = DataStorage("SEVERE_DASHBOARD_WAT")
    static let severeDashboardMcd = DataStorage("SEVERE_DASHBOARD_MCD")
    static let severeDashboardMpd = DataStorage("SEVERE_DASHBOARD_MPD")
    static let watchLatlon = DataStorage("WATCH_LATLON")
    static let watchLatlonTor = DataStorage("WATCH_LATLON_TOR")
    static let watNoList = DataStorage("WAT_NO_LIST")
    static let mcdLatlon = DataStorage("MCD_LATLON")
    static let mcdNoList = DataStorage("MCD_NO_LIST")
    static let mpdLatlon = DataStorage("MPD_LATLON")
    static let mpdNoList = DataStorage("MPD_NO_LIST")
    static var playlistStr = ""
    static var colorMap = [Int: ObjectColorPalette]()
    static var locations = [Location]()

    class func onCreate() {
        initPreferences()
        AppColors.update()
        initData()
        if preferences.getString("SND_IAD_X", "") == "" {
            UtilityPref.prefInitStateCode()
            UtilityPref.prefInitStateCodeLookup()
            UtilityPref.prefInitNWSXY()
            UtilityPref.prefInitRIDXY()
            UtilityPref.prefInitRIDXY2()
            UtilityPref.prefInitNWSLoc()
            UtilityPref2.prefInitSetDefaults()
            UtilityPref3.prefInitRIDLoc()
            UtilityPref.prefInitBig()
            UtilityPref.prefInitTwitterCA()
            UtilityPref4.prefInitSoundingSites()
            UtilityPref4.prefInitSoundingSitesLoc()
        }
        Location.refreshLocationData()
    }

    class func initData() {
        ColorPalettes.initialize()
        RadarGeometry.initialize()
        UtilityCities.initialize()
    }

    class func initPreferences() {
        RadarPreferences.initialize()
        UIPreferences.initialize()
        fixedSpace.width = UIPreferences.toolbarIconSpacing
        RadarGeometry.setColors()
        [94, 99, 134, 135, 159, 161, 163, 165, 172].forEach {
            radarColorPalette[String($0)] = preferences.getString("RADAR_COLOR_PALETTE_" + String($0), "CODENH")
        }
        homescreenFav = preferences.getString("HOMESCREEN_FAV", homescreenFavDefault)
        animInterval = preferences.getInt("ANIM_INTERVAL", 6)
        playlistStr = preferences.getString("PLAYLIST", "")
        Location.setCurrentLocationStr(preferences.getString("CURRENT_LOC_FRAGMENT", "1"))
        severeDashboardTor.update()
        severeDashboardTst.update()
        severeDashboardFfw.update()
        severeDashboardWat.update()
        severeDashboardMcd.update()
        severeDashboardMpd.update()
        watchLatlon.update()
        watchLatlonTor.update()
        watNoList.update()
        mcdLatlon.update()
        mcdNoList.update()
        mpdLatlon.update()
        mpdNoList.update()
    }
}
