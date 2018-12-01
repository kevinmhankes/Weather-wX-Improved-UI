/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class UtilityNHC {

    static let utilNhcPattern1 = "<title>(.*?)</title>"
    static let utilNhcPattern2 = "<nhc:Cyclone>(.*?)</nhc:Cyclone>"
    static let utilNhcPattern3 = "<link>.*?(http://www.nhc.noaa.gov/text/refresh/MIATCP[AE][TP][0-9].shtml/.*?shtml).*?</link>"
    static let utilNhcPattern4 = "<nhc:wallet>(.*?)</nhc:wallet>"
    static let utilNhcPattern5 = "<img src=.(.*?png)."

    static let textProducts = [
        "MIATWOAT: ATL Tropical Weather Outlook",
        "MIATWDAT: ATL Tropical Weather Discussion",
        "MIATWOEP: EPAC Tropical Weather Outlook",
        "MIATWDEP: EPAC Tropical Weather Discussion",
        "MIATWSAT: ATL Monthly Tropical Summary",
        "MIATWSEP: EPAC Monthly Tropical Summary"
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
        "http://www.ssd.noaa.gov/PS/TROP/DATA/RT/SST/PAC/20.jpg",
        "http://www.ssd.noaa.gov/PS/TROP/DATA/RT/SST/ATL/20.jpg",
        MyApplication.nwsNhcWebsitePrefix + "/tafb/pac_anal.gif",
        MyApplication.nwsNhcWebsitePrefix + "/tafb/atl_anal.gif",
        MyApplication.nwsNhcWebsitePrefix + "/tafb/pac_anom.gif",
        MyApplication.nwsNhcWebsitePrefix + "/tafb/atl_anom.gif"
        ]

    static func getHurricaneInfo(_ rssUrl: String) -> ObjectNHCStormInfo {
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
            if urlList.count>1 {
                img1 = urlList[0]
                img2 = urlList[1]
            }
        }
        return ObjectNHCStormInfo(title, summary, url, img1, img2, wallet)
    }

    static func getAnimation(_ sector: String, _ prodId: String, _ frameCntStr: String) -> AnimationDrawable {
        let baseUrl = "http://www.ssd.noaa.gov/PS/TROP/floaters/" + sector + "/imagery/"
        let urls = UtilityImgAnim.getUrlArray(baseUrl,
                                              "<a href=\"([0-9]{8}_[0-9]{4}Z-" + prodId + "\\.gif)\">",
                                              frameCntStr)
        let bitmaps = urls.map {Bitmap(baseUrl + $0)}
        let animDrawable = AnimationDrawable()
        bitmaps.forEach {animDrawable.addFrame(Drawable($0), UtilityImg.getAnimInterval())}
        return animDrawable
    }

    static func getImage(_ sector: String, _ product: String) -> Bitmap {
        return Bitmap("http://www.ssd.noaa.gov/PS/TROP/floaters/" + sector + "/imagery/" + product + "0.gif")
    }
}
