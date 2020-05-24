/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class UtilityHomeScreen {
    
    static let localChoicesText = [
        "METAL-RADAR": "Local NEXRAD Radar",
        "TXT-AFDLOC": "Area Forecast Discussion",
        "TXT-HWOLOC": "Hazardous Weather Outlook",
        "TXT-HOURLY": "Hourly Forecast",
        "TXT-CC2": "Current Conditions with Image",
        "TXT-HAZ": "Hazards",
        "TXT-7DAY2": "7 Day Forecast with Images"
    ]

    static let localChoicesImages = [
        "CARAIN: Local CA Radar",
        "WEATHERSTORY: Local NWS Weather Story",
        "WFOWARNINGS: Local NWS Office Warnings"
    ]

    static func jumpToActivity(_ uiv: UIViewController, _ homeScreenToken: String) {
        //print("homescreen token: " + homeScreenToken)
        switch homeScreenToken {
        case "USWARN":
            Route.alerts(uiv)
        case "VIS_1KM":
            Route.wpcImage(uiv)
        case "FMAP":
            Route.wpcImage(uiv)
        case "VIS_CONUS":
            Route.goesVisConus(uiv)
        case "CONUSWV":
            Route.goesWaterVapor(uiv)
        case "SWOD1":
            Route.swo(uiv, "1")
        case "SWOD2":
            Route.swo(uiv, "2")
        case "SWOD3":
            Route.swo(uiv, "3")
        case "STRPT":
            Route.spcStormReports(uiv, "today")
        case "SND":
            Route.soundings(uiv)
        case "SPCMESO_500":
            goToSpcMesoFromHS(uiv, "500mb")
        case "SPCMESO_MSLP":
            goToSpcMesoFromHS(uiv, "pmsl")
        case "SPCMESO_TTD":
            goToSpcMesoFromHS(uiv, "ttd")
        case "SPCMESO_LLLR":
            goToSpcMesoFromHS(uiv, "lllr")
        case "SPCMESO_LAPS":
            goToSpcMesoFromHS(uiv, "laps")
        case "SPCMESO_RGNLRAD":
            goToSpcMesoFromHS(uiv, "rgnlrad")
        case "RAD_2KM":
            Route.radarMosaic(uiv)
        case "GOES16":
            Route.vis(uiv)
        default:
            Route.wpcImageFromHomeScreen(uiv, homeScreenToken)
        }
    }

    static func goToSpcMesoFromHS(_ uiv: UIViewController, _ token: String) {
        let vc = vcSpcMeso()
        vc.spcMesoToken = token
        vc.spcMesoFromHomeScreen = true
        uiv.goToVC(vc)
    }
}
