/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import AVFoundation
import UIKit

final class GlobalVariables {
    
    static let flexBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
    static let fixedSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
    static let preferences = Preferences()
    static let editor = Editor()
    static let appName = "wXL23"
    static var forecastZone = ""
    
    static let mainScreenCaDisclaimor = "Data for Canada forecasts and radar provided by" + " https://weather.gc.ca/canada_e.html."
    static let nwsSPCwebsitePrefix = "https://www.spc.noaa.gov"
    static let nwsWPCwebsitePrefix = "https://www.wpc.ncep.noaa.gov"
    static let nwsAWCwebsitePrefix = "https://www.aviationweather.gov"
    static let nwsGraphicalWebsitePrefix = "https://graphical.weather.gov"
    static let nwsCPCNcepWebsitePrefix = "https://www.cpc.ncep.noaa.gov"
    static let nwsOpcWebsitePrefix = "https://ocean.weather.gov"
    static let nwsNhcWebsitePrefix = "https://www.nhc.noaa.gov"
    static let nwsSwpcWebSitePrefix = "https://services.swpc.noaa.gov"
    static let canadaEcSitePrefix = "https://weather.gc.ca"
    static let goes16Url = "https://cdn.star.nesdis.noaa.gov"
    static let nwsApiUrl = "https://api.weather.gov"
    static let tgftpSitePrefix = "https://tgftp.nws.noaa.gov"
    // static let nwsRadarPub = "https://tgftp.nws.noaa.gov/"
    static let degreeSymbol = "\u{00B0}"
    static let newline = "\n"
    static let prePattern = "<pre.*?>(.*?)</pre>"
    static let pre2Pattern = "<pre>(.*?)</pre>"
    static let homescreenFavDefault = "TXT-CC2:TXT-HAZ:TXT-7DAY2:"
    static let vtecPattern = "([A-Z0]{1}\\.[A-Z]{3}\\.[A-Z]{4}\\.[A-Z]{2}\\.[A-Z]\\.[0-9]"
        + "{4}\\.[0-9]{6}T[0-9]{4}Z\\-[0-9]{6}T[0-9]{4}Z)"
    static let warningLatLonPattern = "\"coordinates\":\\[\\[(.*?)\\]\\]\\}"
    
    //
    // Legacy forecast support
    //
    static let utilUSPeriodNamePattern = ".*?period-name=(.*?)>.*?"
    static let xmlValuePattern = "<value>"
}
