/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

class UtilityWfoText {
    
    static func needsFixedWidthFont(_ product: String) -> Bool {
        let productList = [
            "RWR",
            "RVA",
            "LSR",
            "ESF",
            "NSH",
            "PNS"
        ]
        if product.hasPrefix("RTP") || productList.contains(product) {
            return true
        } else {
            return false
        }
    }
    
    static let wfoProdList = [
        "AFD: Area Forecast Discussion",
        "ESF: Hydrologic Outlook",
        "FWF: Fire weather Forecast",
        "HWO: Hazardous Weather Outlook",
        "LSR: Local Storm Report",
        "NSH: Nearshore Marine Forecast",
        "PNS: Public Information Statement",
        "RER: Record Event Report",
        "RTP: Regional Temp/Precip Summary",
        "RTPZZ: Regional Temp/Precip Summary by State",
        "RVA: Hydrologic Summary",
        "RWR: Regional Weather Roundup",
        "SPS: Special Weather Statement",
        "VFD: Aviation Only AFD"
    ]
    
    static let wfoProdListNoCode = [
        "Area Forecast Discussion",
        "Hydrologic Outlook",
        "Fire weather Forecast",
        "Hazardous Weather Outlook",
        "Local Storm Report",
        "Nearshore Marine Forecast",
        "Public Information Statement",
        "Record Event Report",
        "Regional Temp/Precip Summary",
        "Regional Temp/Precip Summary by State",
        "Hydrologic Summary",
        "Regional Weather Roundup",
        "Special Weather Statement",
        "Aviation Only AFD"
    ]
}
