/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class ObjectWatchProduct {

    private var productNumber = ""
    private var imgUrl = ""
    private var textUrl = ""
    private var title = ""
    private var prod = ""
    private var bitmap = Bitmap()
    private var text = ""
    private var wfoArr = [String]()

    init(_ type: PolygonType, _ productNumber: String) {
        self.productNumber = productNumber
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
        wfoArr = wfoStr.split("\\.\\.\\.")
    }

    func getTextForSubtitle() -> String {
        return text.parse("AREAS AFFECTED...(.*?)CONCERNING").replace("<BR>", "")
    }
}
