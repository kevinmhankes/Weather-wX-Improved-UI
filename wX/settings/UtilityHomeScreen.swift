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
        print("homescreen token: " + homeScreenToken)
        switch homeScreenToken {
        case "USWARN":
            let vc = vcUSAlerts()
            uiv.goToVC(vc)
        case "VIS_1KM":
            let vc = vcWpcImg()
            uiv.goToVC(vc)
        case "WPC_ANALYSIS":
            let vc = vcWpcImg()
            uiv.goToVC(vc)
        case "FMAP":
            let vc = vcWpcImg()
            uiv.goToVC(vc)
        case "VIS_CONUS":
            let vc = vcGoes()
            vc.productCode = "GEOCOLOR"
            vc.sectorCode = "CONUS"
            uiv.goToVC(vc)
        case "CONUSWV":
            let vc = vcGoes()
            vc.productCode = "09"
            vc.sectorCode = "CONUS"
            uiv.goToVC(vc)
        case "SWOD1":
            let vc = vcSpcSwo()
            vc.spcSwoDay = "1"
            uiv.goToVC(vc)
        case "SWOD2":
            let vc = vcSpcSwo()
            vc.spcSwoDay = "2"
            uiv.goToVC(vc)
        case "SWOD3":
            let vc = vcSpcSwo()
            vc.spcSwoDay = "3"
            uiv.goToVC(vc)
        case "STRPT":
            let vc = vcSpcStormReports()
            vc.spcStormReportsDay = "today"
            uiv.goToVC(vc)
        case "SND":
            let vc = vcSoundings()
            uiv.goToVC(vc)
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
            if !UIPreferences.useAwcRadarMosaic {
                let vc = vcRadarMosaic()
                vc.nwsMosaicType = "local"
                uiv.goToVC(vc)
            } else {
                let vc = vcRadarMosaicAwc()
                uiv.goToVC(vc)
            }
        case "GOES16":
            let vc = vcGoes()
            vc.productCode = ""
            vc.sectorCode = ""
            uiv.goToVC(vc)
        default:
            let vc = vcWpcImg()
            vc.wpcImagesToken = homeScreenToken
            vc.wpcImagesFromHomeScreen = true
            uiv.goToVC(vc)
        }
    }

    static func goToSpcMesoFromHS(_ uiv: UIViewController, _ token: String) {
        let vc = vcSpcMeso()
        vc.spcMesoToken = token
        vc.spcMesoFromHomeScreen = true
        uiv.goToVC(vc)
    }
}
