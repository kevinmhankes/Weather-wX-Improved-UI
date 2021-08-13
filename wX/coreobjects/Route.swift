// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Foundation
import UIKit

final class Route {
    
    static func getForecast(_ uiv: UIViewController, _ latLon: LatLon) {
        let vc = vcAdhocLocation()
        vc.latLon = latLon
        uiv.goToVC(vc)
    }
    
    static func nhcStorm(_ uiv: UIViewController, _ storm: ObjectNhcStormDetails) {
        let vc = vcNhcStorm()
        vc.stormData = storm
        uiv.goToVC(vc)
    }
    
    static func colorPicker(_ uiv: UIViewController, _ color: wXColor) {
        let vc = vcSettingsColorPicker()
        vc.colorObject = color
        uiv.goToVC(vc)
    }
    
    static func spcFireOutlookForDay(_ uiv: UIViewController, _ day: Int) {
        let vc = vcSpcFireOutlook()
        vc.dayIndex = day
        uiv.goToVC(vc)
    }
    
    static func wpcRainfallForDay(_ uiv: UIViewController, _ day: Int) {
        let vc = vcWpcRainfallDiscussion()
        vc.day = day
        uiv.goToVC(vc)
    }
    
    static func textViewer(_ uiv: UIViewController, _ text: String, isFixedWidth: Bool = false) {
        let vc = vcTextViewer()
        vc.html = text
        vc.isFixedWidth = isFixedWidth
        uiv.goToVC(vc)
    }
    
    static func radarMosaicLocal(_ uiv: UIViewController) {
        let vc = vcRadarMosaicAwc()
        vc.nwsMosaicType = "local"
        uiv.goToVC(vc)
    }
    
    static func radarMosaic(_ uiv: UIViewController) {
        let vc = vcRadarMosaicAwc()
        uiv.goToVC(vc)
    }
    
    static func vis(_ uiv: UIViewController) {
        let vc = vcGoes()
        vc.productCode = ""
        vc.sectorCode = ""
        uiv.goToVC(vc)
    }
    
    static func visNhc(_ uiv: UIViewController, _ url: String) {
        let vc = vcGoes()
        vc.productCode = ""
        vc.sectorCode = ""
        vc.url = url
        vc.savePrefs = false
        uiv.goToVC(vc)
    }
    
    static func goesWaterVapor(_ uiv: UIViewController) {
        let vc = vcGoes()
        vc.productCode = "09"
        vc.sectorCode = "CONUS"
        uiv.goToVC(vc)
    }
    
    static func goesVisConus(_ uiv: UIViewController) {
        let vc = vcGoes()
        vc.productCode = "GEOCOLOR"
        vc.sectorCode = "CONUS"
        uiv.goToVC(vc)
    }
    
    static func lightning(_ uiv: UIViewController) {
        if UIPreferences.lightningUseGoes {
            let vc = vcGoes()
            vc.productCode = "GLM"
            vc.sectorCode = "CONUS"
            uiv.goToVC(vc)
        } else {
            uiv.goToVC(vcLightning())
        }
    }
    
    static func spcMcdWatchSummary(_ uiv: UIViewController, _ type: PolygonEnum) {
        let vc = vcSpcWatchMcdMpd()
        vc.watchMcdMpdType = type
        uiv.goToVC(vc)
    }
    
    static func spcMcdWatchItem(_ uiv: UIViewController, _ type: PolygonEnum, _ number: String) {
        let vc = vcSpcMcdWatchMpdViewer()
        vc.watchMcdMpdNumber = number
        vc.watchMcdMpdType = type
        uiv.goToVC(vc)
    }
    
    static func locationAdd(_ uiv: UIViewController) {
        let vc = vcSettingsLocationEdit()
        vc.settingsLocationEditNum = "0"
        uiv.goToVC(vc)
    }
    
    static func locationEdit(_ uiv: UIViewController, _ number: String) {
        let vc = vcSettingsLocationEdit()
        vc.settingsLocationEditNum = number
        uiv.goToVC(vc)
    }
    
    static func swo(_ uiv: UIViewController, _ day: String) {
        let vc = vcSpcSwo()
        vc.spcSwoDay = day
        uiv.goToVC(vc)
    }
    
    static func swoState(_ uiv: UIViewController, _ day: String) {
        let vc = vcSpcSwoState()
        vc.day = day
        uiv.goToVC(vc)
    }
    
    static func alerts(_ uiv: UIViewController) {
        if !Location.isUS {
            uiv.goToVC(vcCanadaWarnings())
        } else {
            uiv.goToVC(vcUSAlerts())
        }
    }
    
    static func alertDetail(_ uiv: UIViewController, _ url: String) {
        let vc = vcUSAlertsDetail()
        vc.usAlertsDetailUrl = url
        uiv.goToVC(vc)
    }
    
    static func spcStormReports(_ uiv: UIViewController, _ day: String) {
        let vc = vcSpcStormReports()
        vc.spcStormReportsDay = day
        uiv.goToVC(vc)
    }
    
    static func wpcText(_ uiv: UIViewController, _ product: String) {
        let vc = vcWpcText()
        vc.wpcTextProduct = product
        uiv.goToVC(vc)
    }
    
    static func wpcText(_ uiv: UIViewController) {
        let vc = vcWpcText()
        uiv.goToVC(vc)
    }
    
    static func imageViewer(_ uiv: UIViewController, _ url: String) {
        let vc = vcImageViewer()
        vc.url = url
        uiv.goToVC(vc)
    }
    
    static func radarFromMainScreen(_ uiv: UIViewController) {
        if UIPreferences.dualpaneRadarIcon {
            radar(uiv, "2")
        } else {
            radar(uiv, "1")
        }
    }
    
    static func radar(_ uiv: UIViewController, _ paneString: String) {
        let vc = vcNexradRadar()
        vc.wxoglPaneCount = paneString
        uiv.goToVC(vc)
    }
    
    static func radarNoSave(_ uiv: UIwXViewController, _ radarSite: String) {
        let vc = vcNexradRadar()
        vc.radarSiteOverride = radarSite
        vc.savePreferences = false
        uiv.goToVC(vc)
    }
    
    static func radarFromTimeButton(_ uiv: UIViewController, _ paneString: String) {
        let vc = vcNexradRadar()
        vc.wxoglPaneCount = paneString
        vc.wxoglCalledFromTimeButton = true
        vc.savePreferences = false
        uiv.goToVC(vc)
    }
    
    static func map(_ uiv: UIwXViewController, _ lat: String, _ lon: String, radius: Double = 20000.0) {
        let vc = vcMapKitView()
        vc.mapKitLat = lat
        vc.mapKitLon = lon
        vc.mapKitRadius = radius
        uiv.goToVC(vc)
    }
    
    static func web(_ uiv: UIwXViewController, _ url: String) {
        let vc = vcWebView()
        vc.showProduct = false
        vc.useUrl = true
        vc.url = url
        uiv.goToVC(vc)
    }
    
    static func webTwitter(_ uiv: UIViewController, _ url: String) {
        let vc = vcWebView()
        vc.url = ""
        vc.aStateCode = url
        uiv.goToVC(vc)
    }
    
    static func model(_ uiv: UIViewController, _ model: String) {
        let vc = vcModels()
        vc.modelActivitySelected = model
        uiv.goToVC(vc)
    }
    
    static func severeDashboard(_ uiv: UIViewController) {
        if Location.isUS {
            uiv.goToVC(vcSevereDashboard())
        } else {
            uiv.goToVC(vcCanadaWarnings())
        }
    }
    
    static func cloud(_ uiv: UIViewController) {
        vis(uiv)
    }
    
    static func goesGlobal(_ uiv: UIViewController) {
        uiv.goToVC(vcGoesGlobal())
    }
    
    static func nhc(_ uiv: UIViewController) {
        uiv.goToVC(vcNhc())
    }
    
    static func opc(_ uiv: UIViewController) {
        uiv.goToVC(vcOpc())
    }
    
    static func wfoText(_ uiv: UIViewController) {
        if Location.isUS {
            uiv.goToVC(vcWfoText())
        } else {
            uiv.goToVC(vcCanadaText())
        }
    }
    
    static func hourly(_ uiv: UIViewController) {
        if Location.isUS {
            uiv.goToVC(vcHourly())
        } else {
            uiv.goToVC(vcCanadaHourly())
        }
    }
    
    static func soundings(_ uiv: UIViewController) {
        uiv.goToVC(vcSoundings())
    }
    
    static func observations(_ uiv: UIViewController) {
        if !Location.isUS {
            Route.imageViewer(uiv, "http://weather.gc.ca/data/wxoimages/wocanmap0_e.jpg")
        } else {
            uiv.goToVC(vcObservations())
        }
    }
    
    static func obsSites(_ uiv: UIViewController) {
        uiv.goToVC(vcObsSites())
    }
    
    static func settings(_ uiv: UIViewController) {
        uiv.goToVC(vcSettingsMain())
    }
    
    static func playList(_ uiv: UIViewController) {
        uiv.goToVC(vcPlayList())
    }
    
    static func wpcImage(_ uiv: UIViewController) {
        uiv.goToVC(vcWpcImg())
    }
    
    static func wpcImageFromHomeScreen(_ uiv: UIViewController, _ token: String) {
        let vc = vcWpcImg()
        vc.wpcImagesToken = token
        vc.wpcImagesFromHomeScreen = true
        uiv.goToVC(vc)
    }
    
    static func wpcRainfallSummary(_ uiv: UIViewController) {
        uiv.goToVC(vcWpcRainfallSummary())
    }
    
    static func spcCompMap(_ uiv: UIViewController) {
        uiv.goToVC(vcSpcCompMap())
    }
    
    static func spcFireSummary(_ uiv: UIViewController) {
        uiv.goToVC(vcSpcFireSummary())
    }
    
    static func spcMeso(_ uiv: UIViewController) {
        let vc = vcSpcMeso()
        uiv.goToVC(vc)
    }
    
    static func spcSwoSummary(_ uiv: UIViewController) {
        uiv.goToVC(vcSpcSwoSummary())
    }
    
    static func spcTstormSummary(_ uiv: UIViewController) {
        uiv.goToVC(vcSpcTstormSummary())
    }
    
    static func spcMesoFromHomeScreen(_ uiv: UIViewController, _ token: String) {
        let vc = vcSpcMeso()
        vc.spcMesoToken = token
        vc.spcMesoFromHomeScreen = true
        uiv.goToVC(vc)
    }
}
