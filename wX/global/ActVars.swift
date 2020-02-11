/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ActVars {
    static var settingsLocationEditNum = ""
    static var imageViewerUrl = ""
    static var textViewText = ""
    static var textViewProduct = ""
    static var nwsMosaicType = ""
    static var spcWatchNumber = ""
    static var wpcTextProduct = ""
    static var webViewUrl = ""
    static var webViewStateCode = ""
    static var webViewShowProduct = true
    static var webViewUseUrl = false
    static var spcStormReportsDay = ""
    static var wxoglPaneCount = ""
    static var wxoglCalledFromTimeButton = false
    static var wxoglDspLegendMax = 0.0
    static var nhcStormUrl = ""
    static var nhcStormTitle = ""
    static var nhcStormImgUrl1 = ""
    static var nhcStormImgUrl2 = ""
    static var nhcStormWallet = ""
    static var colorObject = wXColor()
    static var nhcGoesId = ""
    static var nhcGoesImageType = ""
    static var usalertsDetailUrl = ""
    static var caRadarProv = ""
    static var caRadarImageType = ""
    static var modelActivitySelected = ""
    static var adhocLocation = LatLon()
    static var vc = UIViewController()
    static var mapKitLat = ""
    static var mapKitLon = ""
    static var mapKitRadius = 0.0
    static var wpcImagesToken = ""
    static var wpcImagesFromHomeScreen = false
    static var spcMesoFromHomeScreen = false
    static var spcMesoToken = ""
    //static var wpcRainfallDay = "1"

    // used by ViewControllerSpcWatchMcdMpd
    static var watchMcdMpdType = PolygonType.WATCH
    static var watchMcdMpdNumber = ""
}
