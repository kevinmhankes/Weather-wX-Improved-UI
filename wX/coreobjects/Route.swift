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
}
