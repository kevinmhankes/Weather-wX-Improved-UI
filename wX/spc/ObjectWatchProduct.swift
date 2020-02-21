/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class ObjectWatchProduct {

    private var productNumber = ""
    var imgUrl = ""
    private var textUrl = ""
    private var title = ""
    var prod = ""
    var bitmap = Bitmap()
    var text = ""
    private var wfos = [String]()
    private var type: PolygonType

    init(_ type: PolygonType, _ productNumber: String) {
        self.productNumber = productNumber
        self.type = type
        switch type.string {
        case "WATCH_TORNADO":
            self.productNumber = productNumber.replaceAll("w", "")
            imgUrl = MyApplication.nwsSPCwebsitePrefix + "/products/watch/ww" + productNumber + "_radar.gif"
            textUrl = MyApplication.nwsSPCwebsitePrefix + "/products/watch/ww" + productNumber + ".html"
            title = "Watch " + productNumber
            prod = "SPCWAT" + productNumber
        case "WATCH":
            self.productNumber = productNumber.replaceAll("w", "")
            imgUrl = MyApplication.nwsSPCwebsitePrefix + "/products/watch/ww" + productNumber + "_radar.gif"
            textUrl = MyApplication.nwsSPCwebsitePrefix + "/products/watch/ww" + productNumber + ".html"
            title = "Watch " + productNumber
            prod = "SPCWAT" + productNumber
        case "MCD":
            imgUrl = MyApplication.nwsSPCwebsitePrefix + "/products/md/mcd" + productNumber + ".gif"
            textUrl = MyApplication.nwsSPCwebsitePrefix + "/products/md/md" + productNumber + ".html"
            title = "MCD " + productNumber
            prod = "SPCMCD" + productNumber
        case "MPD":
            imgUrl = MyApplication.nwsWPCwebsitePrefix + "/metwatch/images/mcd" + productNumber + ".gif"
            title = "MPD " + productNumber
            prod = "WPCMPD" + productNumber
        default: break
        }
	}

	func getData() {
        text = UtilityDownload.getTextProduct(prod)
        bitmap = Bitmap(imgUrl)
        let wfoStr = text.parse("ATTN...WFO...(.*?)...<br>")
        wfos = wfoStr.split("\\.\\.\\.")
    }

    func getTextForSubtitle() -> String {
        return text.parse("AREAS AFFECTED...(.*?)CONCERNING").replace("<BR>", "")
    }

    func getTextForNoProducts() -> String {
        switch type.string {
        case "WATCH_TORNADO":
            return ""
        case "WATCH":
            return ""
        case "MCD":
            return "No active SPC MCDs"
        case "MPD":
            return ""
        default:
            return ""
        }
    }

    static func getNumberList(_ type: PolygonType) -> [String] {
        switch type.string {
        case "WATCH_TORNADO":
            return [String]()
        case "WATCH":
            return (MyApplication.nwsSPCwebsitePrefix + "/products/watch/").getHtml().parseColumn("[om] Watch #([0-9]*?)</a>")
        case "MCD":
            return (MyApplication.nwsSPCwebsitePrefix + "/products/md/").getHtml().parseColumn("title=.Mesoscale Discussion #(.*?).>")
        case "MPD":
            return [String]()
        default:
            return [String]()
        }
    }
}
