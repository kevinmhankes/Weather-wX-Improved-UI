/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class UtilityNhc {

    static let textProductCodes = [
        "MIATWOAT",
        "MIATWDAT",
        "MIATWSAT",
        "MIATWOEP",
        "MIATWDEP",
        "MIATWSEP",
        "HFOTWOCP"
    ]
    
    static let textProductLabels = [
        "ATL Tropical Weather Outlook",
        "ATL Tropical Weather Discussion",
        "ATL Monthly Tropical Summary",
        "EPAC Tropical Weather Outlook",
        "EPAC Tropical Weather Discussion",
        "EPAC Monthly Tropical Summary",
        "CPAC Tropical Weather Outlook"
    ]
    
    static let imageTitles = [
        "EPAC Daily Analysis",
        "ATL Daily Analysis",
        "EPAC 7-Day Analysis",
        "ATL 7-Day Analysis",
        "EPAC SST Anomaly",
        "ATL SST Anomaly"
    ]
    
    static let imageUrls = [
        "https://www.ssd.noaa.gov/PS/TROP/DATA/RT/SST/PAC/20.jpg",
        "https://www.ssd.noaa.gov/PS/TROP/DATA/RT/SST/ATL/20.jpg",
        GlobalVariables.nwsNhcWebsitePrefix + "/tafb/pac_anal.gif",
        GlobalVariables.nwsNhcWebsitePrefix + "/tafb/atl_anal.gif",
        GlobalVariables.nwsNhcWebsitePrefix + "/tafb/pac_anom.gif",
        GlobalVariables.nwsNhcWebsitePrefix + "/tafb/atl_anom.gif"
    ]
}
