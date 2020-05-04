/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation
import UIKit

final class Route {
    
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
    
    static func map(_ uiv: UIwXViewController, _ lat: String, _ lon: String, radius: Double = 20000.0) {
        let vc = vcMapKitView()
        vc.mapKitLat = lat
        vc.mapKitLon = lon
        vc.mapKitRadius = 20000.0
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
}
