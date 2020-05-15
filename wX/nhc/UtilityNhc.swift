/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class UtilityNhc {
    
    static let utilNhcPattern1 = "<title>(.*?)</title>"
    static let utilNhcPattern2 = "<nhc:Cyclone>(.*?)</nhc:Cyclone>"
    static let utilNhcPattern3 = "<link>.*?(https://www.nhc.noaa.gov/text/refresh/" + "MIATCP[AE][TP][0-9].shtml/.*?shtml).*?</link>"
    static let utilNhcPattern4 = "<nhc:wallet>(.*?)</nhc:wallet>"
    static let utilNhcPattern5 = "<img src=.(.*?png)."
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
    static let imageType = [
        "vis: Visible",
        "wv: Water Vapor",
        "swir: Shortwave IR",
        "ir: Unenhanced IR",
        "avn: AVN",
        "bd: Dvorak",
        "jsl: JSL",
        "rgb: RGB",
        "ft: Funktop",
        "rb: Rainbow"
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
        MyApplication.nwsNhcWebsitePrefix + "/tafb/pac_anal.gif",
        MyApplication.nwsNhcWebsitePrefix + "/tafb/atl_anal.gif",
        MyApplication.nwsNhcWebsitePrefix + "/tafb/pac_anom.gif",
        MyApplication.nwsNhcWebsitePrefix + "/tafb/atl_anom.gif"
    ]
    
    static func getHurricaneInfo(_ rssUrl: String) -> ObjectNhcStormInfo {
        var title = ""
        var summary = ""
        var url = ""
        var img1 = ""
        var img2 = ""
        var wallet = ""
        var urlList = [String]()
        let html = rssUrl.getHtml()
        if !html.contains("No current storm in") {
            title = html.parse(utilNhcPattern1 )
            summary = html.parse(utilNhcPattern2)
            url = html.parse(utilNhcPattern3)
            summary = summary.replaceAll("</.*?>", "<br>")
            wallet =  html.parse(utilNhcPattern4)
            urlList = html.parseColumn(utilNhcPattern5)
            if urlList.count > 1 {
                img1 = urlList[0]
                img2 = urlList[1]
            }
        }
        return ObjectNhcStormInfo(title, summary, url, img1, img2, wallet)
    }
    
    static func getImage(_ sector: String, _ product: String) -> Bitmap {
        Bitmap("https://www.ssd.noaa.gov/PS/TROP/floaters/" + sector + "/imagery/" + product + "0.gif")
    }
}
