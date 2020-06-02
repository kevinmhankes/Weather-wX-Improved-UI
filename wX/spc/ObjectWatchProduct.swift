/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class ObjectWatchProduct {

    private let productNumber: String
    let imgUrl: String
    private let textUrl: String
    private let title: String
    let prod: String
    var bitmap = Bitmap()
    var text = ""
    private var wfos = [String]()
    private let type: PolygonEnum

    init(_ type: PolygonEnum, _ productNumber: String) {
        self.type = type
        switch type {
        case .SPCWAT_TORNADO:
            self.productNumber = productNumber.replaceAll("w", "")
            imgUrl = MyApplication.nwsSPCwebsitePrefix + "/products/watch/ww" + productNumber + "_radar.gif"
            textUrl = MyApplication.nwsSPCwebsitePrefix + "/products/watch/ww" + productNumber + ".html"
            title = "Watch " + productNumber
            prod = "SPCWAT" + productNumber
        case .SPCWAT:
            self.productNumber = productNumber.replaceAll("w", "")
            imgUrl = MyApplication.nwsSPCwebsitePrefix + "/products/watch/ww" + productNumber + "_radar.gif"
            textUrl = MyApplication.nwsSPCwebsitePrefix + "/products/watch/ww" + productNumber + ".html"
            title = "Watch " + productNumber
            prod = "SPCWAT" + productNumber
        case .SPCMCD:
            self.productNumber = productNumber
            imgUrl = MyApplication.nwsSPCwebsitePrefix + "/products/md/mcd" + productNumber + ".gif"
            textUrl = MyApplication.nwsSPCwebsitePrefix + "/products/md/md" + productNumber + ".html"
            title = "MCD " + productNumber
            prod = "SPCMCD" + productNumber
        case .WPCMPD:
            self.productNumber = productNumber
            imgUrl = MyApplication.nwsWPCwebsitePrefix + "/metwatch/images/mcd" + productNumber + ".gif"
            textUrl = ""
            title = "MPD " + productNumber
            prod = "WPCMPD" + productNumber
        default:
            self.productNumber = ""
            imgUrl = ""
            textUrl = ""
            title = ""
            prod = ""
        }
	}

	func getData() {
        text = UtilityDownload.getTextProduct(prod.uppercased()).removeHtml()
        bitmap = Bitmap(imgUrl)
        let wfoStr = text.parse("ATTN...WFO...(.*?)...<br>")
        wfos = wfoStr.split("\\.\\.\\.")
    }

    func getTextForSubtitle() -> String { text.parse("AREAS AFFECTED...(.*?)CONCERNING").replace("<BR>", "") }

    func getTextForNoProducts() -> String {
        switch type {
        case .SPCWAT_TORNADO:
            return ""
        case .SPCWAT:
            return ""
        case .SPCMCD:
            return "No active SPC MCDs"
        case .WPCMPD:
            return ""
        default:
            return ""
        }
    }

    static func getNumberList(_ type: PolygonEnum) -> [String] {
        switch type {
        case .SPCWAT_TORNADO:
            return [String]()
        case .SPCWAT:
            return (MyApplication.nwsSPCwebsitePrefix + "/products/watch/").getHtml().parseColumn("[om] Watch #([0-9]*?)</a>")
        case .SPCMCD:
            return (MyApplication.nwsSPCwebsitePrefix + "/products/md/").getHtml().parseColumn("title=.Mesoscale Discussion #(.*?).>")
        case .WPCMPD:
            return [String]()
        default:
            return [String]()
        }
    }
}
