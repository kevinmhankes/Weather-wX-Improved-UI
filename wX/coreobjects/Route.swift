// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Foundation
import UIKit

final class Route {
    
    static func getForecast(_ uiv: UIViewController, _ latLon: LatLon) {
        let vc = VcAdhocLocation()
        vc.latLon = latLon
        uiv.goToVC(vc)
    }
    
    static func nhcStorm(_ uiv: UIViewController, _ storm: ObjectNhcStormDetails) {
        let vc = VcNhcStorm()
        vc.stormData = storm
        uiv.goToVC(vc)
    }
    
    static func colorPicker(_ uiv: UIViewController, _ color: wXColor) {
        let vc = VcSettingsColorPicker()
        vc.colorObject = color
        uiv.goToVC(vc)
    }
    
    static func spcFireOutlookForDay(_ uiv: UIViewController, _ day: Int) {
        let vc = VcSpcFireOutlook()
        vc.dayIndex = day
        uiv.goToVC(vc)
    }
    
    static func wpcRainfallForDay(_ uiv: UIViewController, _ day: Int) {
        let vc = VcWpcRainfallDiscussion()
        vc.day = day
        uiv.goToVC(vc)
    }
    
    static func textViewer(_ uiv: UIViewController, _ text: String, isFixedWidth: Bool = false) {
        let vc = VcTextViewer()
        vc.html = text
        vc.isFixedWidth = isFixedWidth
        uiv.goToVC(vc)
    }
    
    static func radarMosaicLocal(_ uiv: UIViewController) {
        let vc = VcRadarMosaicAwc()
        vc.nwsMosaicType = "local"
        uiv.goToVC(vc)
    }
    
    static func radarMosaic(_ uiv: UIViewController) {
        let vc = VcRadarMosaicAwc()
        uiv.goToVC(vc)
    }
    
    static func vis(_ uiv: UIViewController) {
        let vc = VcGoes()
        vc.productCode = ""
        vc.sectorCode = ""
        uiv.goToVC(vc)
    }
    
    static func visNhc(_ uiv: UIViewController, _ url: String) {
        let vc = VcGoes()
        vc.productCode = ""
        vc.sectorCode = ""
        vc.url = url
        vc.savePrefs = false
        uiv.goToVC(vc)
    }
    
    static func goesWaterVapor(_ uiv: UIViewController) {
        let vc = VcGoes()
        vc.productCode = "09"
        vc.sectorCode = "CONUS"
        uiv.goToVC(vc)
    }
    
    static func goesVisConus(_ uiv: UIViewController) {
        let vc = VcGoes()
        vc.productCode = "GEOCOLOR"
        vc.sectorCode = "CONUS"
        uiv.goToVC(vc)
    }
    
    static func lightning(_ uiv: UIViewController) {
        if UIPreferences.lightningUseGoes {
            let vc = VcGoes()
            vc.productCode = "GLM"
            vc.sectorCode = "CONUS"
            uiv.goToVC(vc)
        } else {
            uiv.goToVC(VcLightning())
        }
    }
    
    static func spcMcdWatchSummary(_ uiv: UIViewController, _ type: PolygonEnum) {
        let vc = VcSpcWatchMcdMpd()
        vc.watchMcdMpdType = type
        uiv.goToVC(vc)
    }
    
    static func spcMcdWatchItem(_ uiv: UIViewController, _ type: PolygonEnum, _ number: String) {
        let vc = VcSpcMcdWatchMpdViewer()
        vc.watchMcdMpdNumber = number
        vc.watchMcdMpdType = type
        uiv.goToVC(vc)
    }
    
    static func locationAdd(_ uiv: UIViewController) {
        let vc = VcSettingsLocationEdit()
        vc.settingsLocationEditNum = "0"
        uiv.goToVC(vc)
    }
    
    static func locationEdit(_ uiv: UIViewController, _ number: String) {
        let vc = VcSettingsLocationEdit()
        vc.settingsLocationEditNum = number
        uiv.goToVC(vc)
    }
    
    static func swo(_ uiv: UIViewController, _ day: String) {
        let vc = VcSpcSwo()
        vc.spcSwoDay = day
        uiv.goToVC(vc)
    }
    
    static func swoState(_ uiv: UIViewController, _ day: String) {
        let vc = VcSpcSwoState()
        vc.day = day
        uiv.goToVC(vc)
    }
    
    static func alerts(_ uiv: UIViewController) {
        if !Location.isUS {
            uiv.goToVC(VcCanadaWarnings())
        } else {
            uiv.goToVC(VcUSAlerts())
        }
    }
    
    static func alertDetail(_ uiv: UIViewController, _ url: String) {
        let vc = VcUSAlertsDetail()
        vc.usAlertsDetailUrl = url
        uiv.goToVC(vc)
    }
    
    static func spcStormReports(_ uiv: UIViewController, _ day: String) {
        let vc = VcSpcStormReports()
        vc.spcStormReportsDay = day
        uiv.goToVC(vc)
    }
    
    static func wpcText(_ uiv: UIViewController, _ product: String) {
        let vc = VcWpcText()
        vc.wpcTextProduct = product
        uiv.goToVC(vc)
    }
    
    static func wpcText(_ uiv: UIViewController) {
        let vc = VcWpcText()
        uiv.goToVC(vc)
    }
    
    static func imageViewer(_ uiv: UIViewController, _ url: String) {
        let vc = VcImageViewer()
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
        let vc = VcNexradRadar()
        vc.wxoglPaneCount = paneString
        uiv.goToVC(vc)
    }
    
    static func radarNoSave(_ uiv: UIwXViewController, _ radarSite: String) {
        let vc = VcNexradRadar()
        vc.radarSiteOverride = radarSite
        vc.savePreferences = false
        uiv.goToVC(vc)
    }
    
    static func radarFromTimeButton(_ uiv: UIViewController, _ paneString: String) {
        let vc = VcNexradRadar()
        vc.wxoglPaneCount = paneString
        vc.wxoglCalledFromTimeButton = true
        vc.savePreferences = false
        uiv.goToVC(vc)
    }
    
    static func map(_ uiv: UIwXViewController, _ lat: String, _ lon: String, radius: Double = 20000.0) {
        let vc = VcMapKitView()
        vc.mapKitLat = lat
        vc.mapKitLon = lon
        vc.mapKitRadius = radius
        uiv.goToVC(vc)
    }
    
    static func web(_ uiv: UIwXViewController, _ url: String) {
        let vc = VcWebView()
        vc.showProduct = false
        vc.useUrl = true
        vc.url = url
        uiv.goToVC(vc)
    }
    
    static func webTwitter(_ uiv: UIViewController, _ url: String) {
        let vc = VcWebView()
        vc.url = ""
        vc.aStateCode = url
        uiv.goToVC(vc)
    }
    
    static func model(_ uiv: UIViewController, _ model: String) {
        let vc = VcModels()
        vc.modelActivitySelected = model
        uiv.goToVC(vc)
    }
    
    static func severeDashboard(_ uiv: UIViewController) {
        if Location.isUS {
            uiv.goToVC(VcSevereDashboard())
        } else {
            uiv.goToVC(VcCanadaWarnings())
        }
    }
    
    static func cloud(_ uiv: UIViewController) {
        vis(uiv)
    }
    
    static func goesGlobal(_ uiv: UIViewController) {
        uiv.goToVC(VcGoesGlobal())
    }
    
    static func nhc(_ uiv: UIViewController) {
        uiv.goToVC(VcNhc())
    }
    
    static func opc(_ uiv: UIViewController) {
        uiv.goToVC(VcOpc())
    }
    
    static func wfoText(_ uiv: UIViewController) {
        if Location.isUS {
            uiv.goToVC(VcWfoText())
        } else {
            uiv.goToVC(VcCanadaText())
        }
    }
    
    static func hourly(_ uiv: UIViewController) {
        if Location.isUS {
            uiv.goToVC(VcHourly())
        } else {
            uiv.goToVC(VcCanadaHourly())
        }
    }
    
    static func lsrByWfo(_ uiv: UIViewController) {
        uiv.goToVC(VcLsrByWfo())
    }
    
    static func soundings(_ uiv: UIViewController) {
        uiv.goToVC(VcSoundings())
    }
    
    static func observations(_ uiv: UIViewController) {
        if !Location.isUS {
            Route.imageViewer(uiv, "http://weather.gc.ca/data/wxoimages/wocanmap0_e.jpg")
        } else {
            uiv.goToVC(VcObservations())
        }
    }
    
    static func obsSites(_ uiv: UIViewController) {
        uiv.goToVC(VcObsSites())
    }
    
    static func settings(_ uiv: UIViewController) {
        uiv.goToVC(VcSettingsMain())
    }
    
    static func settingsAbout(_ uiv: UIViewController) {
        uiv.goToVC(VcSettingsAbout())
    }
    
    static func settingsLocationCanada(_ uiv: UIViewController) {
        uiv.goToVC(VcSettingsLocationCanada())
    }
    
    static func settingsColors(_ uiv: UIViewController) {
        uiv.goToVC(VcSettingsColorListing())
    }
    
    static func settingsHomeScreen(_ uiv: UIViewController) {
        uiv.goToVC(VcSettingsHomescreen())
    }
    
    static func settingsLocation(_ uiv: UIViewController) {
        uiv.goToVC(VcSettingsLocation())
    }
    
    static func settingsRadar(_ uiv: UIViewController) {
        uiv.goToVC(VcSettingsRadar())
    }
    
    static func settingsUI(_ uiv: UIViewController) {
        uiv.goToVC(VcSettingsUI())
    }
    
    static func spotters(_ uiv: UIViewController) {
        uiv.goToVC(VcSpotters())
    }
    
    static func spotterReports(_ uiv: UIViewController) {
        uiv.goToVC(VcSpotterReports())
    }
    
    static func playList(_ uiv: UIViewController) {
        uiv.goToVC(VcPlayList())
    }
    
    static func wpcImage(_ uiv: UIViewController) {
        uiv.goToVC(VcWpcImg())
    }
    
    static func wpcImageFromHomeScreen(_ uiv: UIViewController, _ token: String) {
        let vc = VcWpcImg()
        vc.wpcImagesToken = token
        vc.wpcImagesFromHomeScreen = true
        uiv.goToVC(vc)
    }
    
    static func wpcRainfallSummary(_ uiv: UIViewController) {
        uiv.goToVC(VcWpcRainfallSummary())
    }
    
    static func spcCompMap(_ uiv: UIViewController) {
        uiv.goToVC(VcSpcCompMap())
    }
    
    static func spcFireSummary(_ uiv: UIViewController) {
        uiv.goToVC(VcSpcFireSummary())
    }
    
    static func spcMeso(_ uiv: UIViewController) {
        let vc = VcSpcMeso()
        uiv.goToVC(vc)
    }
    
    static func spcSwoSummary(_ uiv: UIViewController) {
        uiv.goToVC(VcSpcSwoSummary())
    }
    
    static func spcTstormSummary(_ uiv: UIViewController) {
        uiv.goToVC(VcSpcTstormSummary())
    }
    
    static func spcMesoFromHomeScreen(_ uiv: UIViewController, _ token: String) {
        let vc = VcSpcMeso()
        vc.spcMesoToken = token
        vc.spcMesoFromHomeScreen = true
        uiv.goToVC(vc)
    }
    
    static func subMenuClicked(_ uiv: UIViewController, _ button: ToolbarIcon) {
        // items in the list below need to match items in menuItemClicked's switch
        var menuList = [
            "Hourly Forecast",
            "Radar Mosaic",
            "US Alerts",
            "Observations",
            "Soundings",
            "PlayList",
            "Settings"
        ]
        if !Location.isUS {
            menuList = [
                "Hourly Forecast",
                "Radar Mosaic",
                "Canadian Alerts",
                "Observations",
                "Soundings",
                "PlayList",
                "Settings"
            ]
        }
        let alert = UIAlertController(title: "Select from:", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        alert.view.tintColor = ColorCompatibility.label
        menuList.forEach { item in
            let action = UIAlertAction(title: item, style: .default, handler: { _ in subMenuItemClicked(uiv, item) })
            if let popoverController = alert.popoverPresentationController {
                popoverController.barButtonItem = button
            }
            alert.addAction(action)
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        uiv.present(alert, animated: UIPreferences.backButtonAnimation, completion: nil)
    }
    
    static func subMenuItemClicked(_ uiv: UIViewController, _ menuItem: String) {
        switch menuItem {
        case "Soundings":
            soundings(uiv)
        case "Hourly Forecast":
            hourly(uiv)
        case "Settings":
            settings(uiv)
        case "Observations":
            observations(uiv)
        case "PlayList":
            playList(uiv)
        case "Radar Mosaic":
            radarMosaicLocal(uiv)
        case "Canadian Alerts":
            alerts(uiv)
        case "US Alerts":
            alerts(uiv)
        default:
            hourly(uiv)
        }
    }
}
