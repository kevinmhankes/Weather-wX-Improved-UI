/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityCanadaImg {
    
    static let names = [
        "Vis West",
        "Vis East",
        "IR West",
        "IR East"
    ]
    
    static let urls = [
        MyApplication.canadaEcSitePrefix + "/data/satellite/goes_wcan_visible_100.jpg",
        MyApplication.canadaEcSitePrefix + "/data/satellite/goes_ecan_visible_100.jpg",
        MyApplication.canadaEcSitePrefix + "/data/satellite/goes_wcan_1070_100.jpg",
        MyApplication.canadaEcSitePrefix + "/data/satellite/goes_ecan_1070_100.jpg"
    ]
    
    static let mosaicSectors = [
        "CAN",
        "PAC",
        "WRN",
        "ONT",
        "QUE",
        "ERN"
    ]
    
    static let radarSites = [
        "WUJ: Aldergrove, BC (near Vancouver)",
        "XPG: Prince George, BC",
        "XSS: Silver Star Mountain, BC (near Vernon)",
        "XSI: Victoria, BC",
        "CASBE: Bethune, SK (near Regina)",
        "WHK: Carvel, AB (near Edmonton)",
        "CASFW: Foxwarren, MB (near Brandon)",
        "CASRA: Radisson, SK (near Saskatoon)",
        "XBU: Schuler, AB (near Medicine Hat)",
        "CASSR: Spirit River, AB (near Grande Prairie)",
        "CASSM: Strathmore, AB (near Calgary)",
        "XWL: Woodlands, MB (near Winnipeg)",
        "WHN: Jimmy Lake, AB (near Cold Lake)",
        "WBI: Britt, ON (near Sudbury)",
        "XDR: Dryden, ON",
        "CASET: Exeter, ON (near London)",
        "XFT: Franktown, ON (near Ottawa)",
        "WKR: King City, ON (near Toronto)",
        "CASMR: Montreal River, ON (near Sault Ste Marie)",
        "CASRF: Smooth Rock Falls, ON (near Timmins)",
        "XNI: Superior West, ON (near Thunder Bay)",
        "CASLA: Landrienne, QC (near Rouyn-Noranda)",
        "CASBV: Blainville, QC (near Montréal)",
        "XAM: Val d'Irène, QC (near Mont Joli)",
        "WVY: Villeroy, QC (near Trois-Rivières)",
        "WMB: Lac Castor, QC (near Saguenay)",
        "CASCM: Chipman, NB (near Fredericton)",
        "XGO: Halifax, NS",
        "WTP: Holyrood, NL (near St. John's)",
        "XME: Marble Mountain, NL",
        "CASMB: Marion Bridge, NS (near Sydney)",
        "CAN",
        "PAC",
        "WRN",
        "ONT",
        "QUE",
        "ERN"
    ]
    
    static func getGoesAnimation(_ url: String) -> AnimationDrawable {
        let frameCount = 15
        let region = url.parse("goes_(.*?)_")
        let imgType = url.parse("goes_.*?_(.*?)_")
        let urlAnim = MyApplication.canadaEcSitePrefix + "/satellite/satellite_anim_e.html?sat=goes&area=" + region + "&type=" + imgType
        let html = urlAnim.getHtml()
        let times = html.parseColumn(">([0-9]{4}/[0-9]{2}/[0-9]{2} [0-9]{2}h[0-9]{2}m)</option>")
        var bitmaps = [Bitmap]()
        let delay = UtilityImg.getAnimInterval()
        stride(from: (times.count - 1), to: (times.count - frameCount), by: -1).forEach {
            let url = MyApplication.canadaEcSitePrefix + "/data/satellite/goes_"
                + region
                + "_"
                + imgType
                + "_m_"
                + times[$0].replace(" ", "_").replace("/", "@") + ".jpg"
            bitmaps.append(Bitmap(url))
        }
        return UtilityImgAnim.getAnimationDrawableFromBitmapList(bitmaps.reversed(), delay)
    }
    
    static func getRadarAnimStringArray(_ radarSite: String, _ duration: String) -> String {
        let html = (MyApplication.canadaEcSitePrefix + "/radar/index_e.html?id=" + radarSite).getHtmlSep()
        var durationPattern = "<p>Short .1hr.:</p>(.*?)</div>"
        if duration == "long" {
            durationPattern = "<p>Long .3hr.:</p>(.*?)</div>"
        }
        let radarHtml1hr = html.parse(durationPattern)
        var timeStamps = radarHtml1hr.parseColumn("display='(.*?)'&amp;")
        let radarSiteCode = (timeStamps.first ?? "_").split("_")[0]
        var string = timeStamps.map { ":/data/radar/detailed/temp_image/" + radarSiteCode + "/" + $0 + ".GIF" }.joined()
        timeStamps = html.parseColumn("src=.(/data/radar/.*?GIF)\"")
        string += timeStamps.map { ":" + $0 }.joined()
        return string
    }
    
    static func getRadarAnimOptionsApplied(_ radarSite: String, _ frameCntStr: String) -> AnimationDrawable {
        let url = UtilityCanadaImg.getRadarAnimStringArray(radarSite, frameCntStr)
        let urls = url.split(":")
        let bitmaps = stride(from: (urls.count - 1), to: 1, by: -1).map {
            getRadarBitmapOptionsApplied(radarSite, MyApplication.canadaEcSitePrefix + urls[$0].replaceAll("detailed/", ""))
        }
        return UtilityImgAnim.getAnimationDrawableFromBitmapList(bitmaps, UtilityImg.getAnimInterval())
    }
    
    static func getRadarBitmapOptionsApplied(_ radarSite: String, _ url: String) -> Bitmap {
        let urlImg: String
        if url == "" {
            let rid1 = radarSite
            let radarHtml = (MyApplication.canadaEcSitePrefix + "/radar/index_e.html?id=" + rid1).getHtml()
            let match = "(/data/radar/.*?GIF)\""
            let summary = radarHtml.parse(match).replaceAll("detailed/", "")
            urlImg = MyApplication.canadaEcSitePrefix + "/" + summary
        } else {
            urlImg = url
        }
        return Bitmap(urlImg)
    }
    
    static func getRadarMosaicBitmapOptionsApplied(_ sector: String) -> Bitmap {
        var url = MyApplication.canadaEcSitePrefix + "/radar/index_e.html?id=" + sector
        if sector == "CAN" {
            url = MyApplication.canadaEcSitePrefix + "/radar/index_e.html"
        }
        let radarHtml = url.getHtmlSep()
        let match = "(/data/radar/.*?GIF)\""
        let summary = radarHtml.parse(match).replace("detailed/", "")
        return Bitmap(MyApplication.canadaEcSitePrefix + "/" + summary)
    }
    
    static func getRadarMosaicAnimation(_ sector: String, _ duration: String) -> AnimationDrawable {
        var url = MyApplication.canadaEcSitePrefix + "/radar/index_e.html?id=" + sector
        if sector == "CAN" {
            url = MyApplication.canadaEcSitePrefix + "/radar/index_e.html"
        }
        let radarHtml = url.getHtmlSep()
        var sectorLocal = ""
        if sector == "CAN" {
            sectorLocal = "NAT"
        } else {
            sectorLocal = sector
        }
        var durationPattern = "<p>Short .1hr.:</p>(.*?)</div>"
        if duration == "long" {
            durationPattern = "<p>Long .3hr.:</p>(.*?)</div>"
        }
        let radarHtml1hr = radarHtml.parse(durationPattern)
        var timeStamps = radarHtml1hr.parseColumn("display='(.*?)'&amp;")
        var string = timeStamps.map {":/data/radar/detailed/temp_image/COMPOSITE_" + sectorLocal + "/" + $0 + ".GIF"}.joined()
        timeStamps = radarHtml.parseColumn("src=.(/data/radar/.*?GIF)\"")
        string += timeStamps.map { ":" + $0 }.joined()
        let tokens = string.split(":")
        var urls = tokens.filter { $0 != "" }.map { MyApplication.canadaEcSitePrefix + $0.replaceAll("detailed/", "") }
        urls.reverse()
        return UtilityImgAnim.getAnimationDrawableFromUrlList(urls, UtilityImg.getAnimInterval())
    }
}
