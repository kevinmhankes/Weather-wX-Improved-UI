/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class UtilityHomeScreen {

    static func jumpToActivity(_ vc: UIViewController, _ homeScreenToken: String) {
        var token = ""
        print("homescreen token: " + homeScreenToken)
        switch homeScreenToken {
        case "USWARN":
            token = "usalerts"
        case "VIS_1KM":
            token = "wpcimg"
        case "WPC_ANALYSIS":
            token = "wpcimg"
        case "FMAP":
            token = "wpcimg"
        case "VIS_CONUS":
            ActVars.goesSector = "CONUS"
            ActVars.goesProduct = "GEOCOLOR"
            token = "goes16"
        case "CONUSWV":
            ActVars.goesSector = "CONUS"
            ActVars.goesProduct = "09"
            token = "goes16"
        case "SWOD1":
            ActVars.spcswoDay = "1"
            token = "spcswo"
        case "SWOD2":
            ActVars.spcswoDay = "2"
            token = "spcswo"
        case "SWOD3":
            ActVars.spcswoDay = "3"
            token = "spcswo"
        case "STRPT":
            ActVars.spcStormReportsDay = "today"
            token = "spcstormreports"
        case "SND":
            token = "sounding"
        case "SPCMESO_500":
            ActVars.spcMesoToken = "500mb"
            ActVars.spcMesoFromHomeScreen = true
            token = "spcmeso"
        case "SPCMESO_MSLP":
            ActVars.spcMesoToken = "pmsl"
            ActVars.spcMesoFromHomeScreen = true
            token = "spcmeso"
        case "SPCMESO_TTD":
            ActVars.spcMesoToken = "ttd"
            ActVars.spcMesoFromHomeScreen = true
            token = "spcmeso"
        case "SPCMESO_LLLR":
            ActVars.spcMesoToken = "lllr"
            ActVars.spcMesoFromHomeScreen = true
            token = "spcmeso"
        case "SPCMESO_LAPS":
            ActVars.spcMesoToken = "laps"
            ActVars.spcMesoFromHomeScreen = true
            token = "spcmeso"
        case "SPCMESO_RGNLRAD":
            ActVars.spcMesoToken = "rgnlrad"
            ActVars.spcMesoFromHomeScreen = true
            token = "spcmeso"
        case "RAD_2KM":
            if !UIPreferences.useAwcRadarMosaic {
                ActVars.nwsMosaicType = "local"
                token = "nwsmosaic"
            } else {
                token = "awcradarmosaic"
            }
        case "GOES16":
            ActVars.goesSector = ""
            ActVars.goesProduct = ""
            token = "goes16"
        default:
            ActVars.wpcImagesToken = homeScreenToken
            ActVars.wpcImagesFromHomeScreen = true
            token = "wpcimg"
        }
        vc.goToVC(token)
        ActVars.wpcImagesFromHomeScreen = false
    }
}
