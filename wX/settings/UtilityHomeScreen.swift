/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class UtilityHomeScreen {

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
            ActVars.spcStormReportsDay = "today"
            let vc = vcSpcStormReports()
            uiv.goToVC(vc)
        case "SND":
            let vc = vcSoundings()
            uiv.goToVC(vc)
        case "SPCMESO_500":
            ActVars.spcMesoToken = "500mb"
            ActVars.spcMesoFromHomeScreen = true
            let vc = vcSpcMeso()
            uiv.goToVC(vc)
        case "SPCMESO_MSLP":
            ActVars.spcMesoToken = "pmsl"
            ActVars.spcMesoFromHomeScreen = true
            let vc = vcSpcMeso()
            uiv.goToVC(vc)
        case "SPCMESO_TTD":
            ActVars.spcMesoToken = "ttd"
            ActVars.spcMesoFromHomeScreen = true
            let vc = vcSpcMeso()
            uiv.goToVC(vc)
        case "SPCMESO_LLLR":
            ActVars.spcMesoToken = "lllr"
            ActVars.spcMesoFromHomeScreen = true
            let vc = vcSpcMeso()
            uiv.goToVC(vc)
        case "SPCMESO_LAPS":
            ActVars.spcMesoToken = "laps"
            ActVars.spcMesoFromHomeScreen = true
            let vc = vcSpcMeso()
            uiv.goToVC(vc)
        case "SPCMESO_RGNLRAD":
            ActVars.spcMesoToken = "rgnlrad"
            ActVars.spcMesoFromHomeScreen = true
            let vc = vcSpcMeso()
            uiv.goToVC(vc)
        case "RAD_2KM":
            if !UIPreferences.useAwcRadarMosaic {
                ActVars.nwsMosaicType = "local"
                let vc = vcRadarMosaic()
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
            ActVars.wpcImagesToken = homeScreenToken
            ActVars.wpcImagesFromHomeScreen = true
            let vc = vcWpcImg()
            uiv.goToVC(vc)
        }
        ActVars.wpcImagesFromHomeScreen = false
    }
}
