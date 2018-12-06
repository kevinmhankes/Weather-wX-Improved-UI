/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
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
        "https://weather.gc.ca/data/satellite/goes_wcan_visible_100.jpg",
        "https://weather.gc.ca/data/satellite/goes_ecan_visible_100.jpg",
        "https://weather.gc.ca/data/satellite/goes_wcan_1070_100.jpg",
        "https://weather.gc.ca/data/satellite/goes_ecan_1070_100.jpg"
        ]

    static let mosaicRids = [
        "CAN",
        "PAC",
        "WRN",
        "ONT",
        "QUE",
        "ERN"
        ]

    static let caRids = [
        "WUJ: Aldergrove, BC (near Vancouver)",
        "XPG: Prince George, BC",
        "XSS: Silver Star Mountain, BC (near Vernon)",
        "XSI: Victoria, BC",
        "XBE: Bethune, SK (near Regina)",
        "WHK: Carvel, AB (near Edmonton)",
        "XFW: Foxwarren, MB (near Brandon)",
        "XRA: Radisson, SK (near Saskatoon)",
        "XBU: Schuler, AB (near Medicine Hat)",
        "WWW: Spirit River, AB (near Grande Prairie)",
        "XSM: Strathmore, AB (near Calgary)",
        "XWL: Woodlands, MB (near Winnipeg)",
        "WHN: Jimmy Lake, AB (near Cold Lake)",
        "WBI: Britt, ON (near Sudbury)",
        "XDR: Dryden, ON",
        "WSO: Exeter, ON (near London)",
        "XFT: Franktown, ON (near Ottawa)",
        "WKR: King City, ON (near Toronto)",
        "WGJ: Montreal River, ON (near Sault Ste Marie)",
        "XTI: Northeast Ontario, ON (near Timmins)",
        "XNI: Superior West, ON (near Thunder Bay)",
        "XLA: Landrienne, QC (near Rouyn-Noranda)",
        "WMN: McGill, QC (near Montréal)",
        "XAM: Val d'Irène, QC (near Mont Joli)",
        "WVY: Villeroy, QC (near Trois-Rivières)",
        "WMB: Lac Castor, QC (near Saguenay)",
        "XNC: Chipman, NB (near Fredericton)",
        "XGO: Halifax, NS",
        "WTP: Holyrood, NL (near St. John's)",
        "XME: Marble Mountain, NL",
        "XMB: Marion Bridge, NS (near Sydney)",
        "CAN",
        "PAC",
        "WRN",
        "ONT",
        "QUE",
        "ERN"
    ]

    static func getGOESAnim(_ url: String) -> AnimationDrawable {
        let region = url.parse("goes_(.*?)_")
        let imgType = url.parse("goes_.*?_(.*?)_")
        let urlAnim = "https://weather.gc.ca/satellite/satellite_anim_e.html?sat=goes&area="
            + region + "&type=" + imgType
        let html = urlAnim.getHtml()
        let times = html.parseColumn(">([0-9]{4}/[0-9]{2}/[0-9]{2} [0-9]{2}h[0-9]{2}m)</option>")
        var bitmaps = [Bitmap]()
        let delay = UtilityImg.getAnimInterval()
        stride(from: (times.count - 1), to: 1, by: -1).forEach {
            bitmaps.append(Bitmap("https://weather.gc.ca/data/satellite/goes_"
                + region
                + "_"
                + imgType
                + "_m_"
                + times[$0].replace(" ", "_").replace("/", "@") + ".jpg"))
        }
        return UtilityImgAnim.getAnimationDrawableFromBitmapList(bitmaps.reversed(), delay)
    }

    static func getRadarAnimStringArray(_ radarSite: String, _ duration: String) -> String {
        let html = ("http://weather.gc.ca/radar/index_e.html?id=" + radarSite).getHtmlSep()
        var durationPatMatch = "<p>Short .1hr.:</p>(.*?)</div>"
        if duration=="long" {durationPatMatch = "<p>Long .3hr.:</p>(.*?)</div>"}
        let radarHtml1hr = html.parse(durationPatMatch)
        var tmpAl = radarHtml1hr.parseColumn("display='(.*?)'&amp;")
        var string = tmpAl.map {":/data/radar/detailed/temp_image/" + radarSite + "/" + $0 + ".GIF"}.joined()
        tmpAl = html.parseColumn("src=.(/data/radar/.*?GIF)\"")
        string += tmpAl.map {":" + $0}.joined()
        return string
    }

    static func getRadarAnimOptionsApplied(_ rid: String, _ frameCntStr: String) -> AnimationDrawable {
        let urlStr = UtilityCanadaImg.getRadarAnimStringArray(rid, frameCntStr)
        let urlArr = urlStr.split(":")
        let baseUrl = "http://weather.gc.ca"
        let bitmaps = stride(from: (urlArr.count - 1), to: 1, by: -1).map {
            getRadarBitmapOptionsApplied(rid, baseUrl + urlArr[$0].replaceAll("detailed/", ""))
        }
        return UtilityImgAnim.getAnimationDrawableFromBitmapList(bitmaps, UtilityImg.getAnimInterval())
    }

    static func getRadarBitmapOptionsApplied(_ rid: String, _ url: String) -> Bitmap {
        let urlImg: String
        if url=="" {
            let rid1 = rid
            let radHtml = ("https://weather.gc.ca/radar/index_e.html?id=" + rid1).getHtml()
            let matchStr = "(/data/radar/.*?GIF)\""
            let summary = radHtml.parse(matchStr).replaceAll("detailed/", "")
            urlImg = "http://weather.gc.ca/" + summary
        } else {urlImg = url}
        return Bitmap(urlImg)
    }

    static func getRadarMosaicBitmapOptionsApplied(_ sector: String) -> Bitmap {
        var url = "http://weather.gc.ca/radar/index_e.html?id=" + sector
        if sector=="CAN" {url = "http://weather.gc.ca/radar/index_e.html"}
        let radHtml = url.getHtmlSep()
        let matchStr = "(/data/radar/.*?GIF)\""
        let summary = radHtml.parse(matchStr).replace("detailed/", "")
        return Bitmap("http://weather.gc.ca/" + summary)
    }

    static func getRadarMosaicAnimation(_ sector: String, _ duration: String) -> AnimationDrawable {
        var url = "http://weather.gc.ca/radar/index_e.html?id=" + sector
        if sector=="CAN" {url = "http://weather.gc.ca/radar/index_e.html"}
        let radHtml = url.getHtmlSep()
        var sectorLocal = ""
        if sector=="CAN" {
            sectorLocal = "NAT"
        } else {
            sectorLocal = sector
        }
        var durationPatMatch = "<p>Short .1hr.:</p>(.*?)</div>"
        if duration=="long" {durationPatMatch = "<p>Long .3hr.:</p>(.*?)</div>"}
        let radarHtml1hr = radHtml.parse(durationPatMatch)
        var tmpAl = radarHtml1hr.parseColumn("display='(.*?)'&amp;")
        var string = tmpAl.map {":/data/radar/detailed/temp_image/COMPOSITE_"
            + sectorLocal + "/" + $0 + ".GIF"}.joined()
        tmpAl = radHtml.parseColumn("src=.(/data/radar/.*?GIF)\"")
        string += tmpAl.map {":" + $0}.joined()
        let urlArr = string.split(":")
        var urls = urlArr.filter {$0 != ""}.map {"http://weather.gc.ca" + $0.replaceAll("detailed/", "")}
        urls.reverse()
        return UtilityImgAnim.getAnimationDrawableFromUrlList(urls, UtilityImg.getAnimInterval())
    }
}
