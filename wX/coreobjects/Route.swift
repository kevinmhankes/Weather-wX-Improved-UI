/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class Route {
    
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
}
