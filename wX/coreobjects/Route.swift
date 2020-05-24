/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation
import UIKit

final class Route {
    
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
    
    static func wpcRainfallForDay(_ uiv: UIViewController, _ day: String) {
        let vc = vcWpcRainfallDiscussion()
        vc.day = day
        uiv.goToVC(vc)
    }
    
    static func textViewer(_ uiv: UIViewController, _ text: String) {
        let vc = vcTextViewer()
        vc.textViewText = text
        uiv.goToVC(vc)
    }
    
    static func radarMosaicLocal(_ uiv: UIViewController) {
        if Location.isUS {
            if !UIPreferences.useAwcRadarMosaic {
                let vc = vcRadarMosaic()
                vc.nwsMosaicType = "local"
                uiv.goToVC(vc)
            } else {
                let vc = vcRadarMosaicAwc()
                vc.nwsMosaicType = "local"
                uiv.goToVC(vc)
            }
        } else {
            let prov = MyApplication.locations[Location.getLocationIndex].prov
            let vc = vcCanadaRadar()
            vc.caRadarProvince = UtilityCanada.getECSectorFromProvidence(prov)
            vc.caRadarImageType = "radar"
            uiv.goToVC(vc)
        }
    }
    
    static func radarMosaic(_ uiv: UIViewController) {
        if !UIPreferences.useAwcRadarMosaic {
            let vc = vcRadarMosaic()
            uiv.goToVC(vc)
        } else {
            let vc = vcRadarMosaicAwc()
            uiv.goToVC(vc)
        }
    }
    
    static func vis(_ uiv: UIViewController) {
        let vc = vcGoes()
        vc.productCode = ""
        vc.sectorCode = ""
        uiv.goToVC(vc)
    }
    
    static func visCanada(_ uiv: UIViewController) {
        let vc = vcCanadaRadar()
        vc.caRadarImageType = "vis"
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
    
    static func spcMcdWatchSummary(_ uiv: UIViewController, _ type: PolygonType) {
        let vc = vcSpcWatchMcdMpd()
        vc.watchMcdMpdType = type
        uiv.goToVC(vc)
    }
    
    static func spcMcdWatchItem(_ uiv: UIViewController, _ type: PolygonType, _ number: String) {
        let vc = vcSpcWatchMcdMpd()
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
    
    static func imageViewer(_ uiv: UIViewController, _ url: String) {
        let vc = vcImageViewer()
        vc.url = url
        uiv.goToVC(vc)
    }
    
    static func radarFromMainScreen(_ uiv: UIViewController) {
        if !Location.isUS {
            radarCanada(uiv)
        } else {
            if UIPreferences.dualpaneRadarIcon { radar(uiv, "2") } else { radar(uiv, "1") }
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
    
    static func radarCanada(_ uiv: UIViewController) {
        let vc = vcCanadaRadar()
        vc.caRadarImageType = "radar"
        vc.caRadarProvince = ""
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
        if Location.isUS { uiv.goToVC(vcSevereDashboard()) } else { uiv.goToVC(vcCanadaWarnings()) }
    }
    
    static func cloud(_ uiv: UIViewController) {
        if Location.isUS { vis(uiv) } else { visCanada(uiv) }
    }
    
    static func wfoText(_ uiv: UIViewController) {
        if Location.isUS { uiv.goToVC(vcWfoText()) } else { uiv.goToVC(vcCanadaText()) }
    }
    
    static func hourly(_ uiv: UIViewController) {
        if Location.isUS { uiv.goToVC(vcHourly()) } else { uiv.goToVC(vcCanadaHourly()) }
    }
    
    static func soundings(_ uiv: UIViewController) {
        uiv.goToVC(vcSoundings())
    }
}
