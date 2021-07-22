/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class ObjectWatchProduct {

    private let productNumber: String
    let imgUrl: String
//    let textUrl: String
//    private let title: String
    let prod: String
    var bitmap = Bitmap()
    var text = ""
//    private var wfos = [String]()
    private let type: PolygonEnum
    private var stringOfLatLon = ""
    private var latLons = [String]()

    init(_ type: PolygonEnum, _ productNumber: String) {
        self.type = type
        switch type {
        case .SPCWAT_TORNADO:
            self.productNumber = productNumber.replaceAll("w", "")
            imgUrl = GlobalVariables.nwsSPCwebsitePrefix + "/products/watch/ww" + productNumber + "_radar.gif"
//            textUrl = GlobalVariables.nwsSPCwebsitePrefix + "/products/watch/ww" + productNumber + ".html"
//            title = "Watch " + productNumber
            prod = "SPCWAT" + productNumber
        case .SPCWAT:
            self.productNumber = productNumber.replaceAll("w", "")
            imgUrl = GlobalVariables.nwsSPCwebsitePrefix + "/products/watch/ww" + productNumber + "_radar.gif"
//            textUrl = GlobalVariables.nwsSPCwebsitePrefix + "/products/watch/ww" + productNumber + ".html"
//            title = "Watch " + productNumber
            prod = "SPCWAT" + productNumber
        case .SPCMCD:
            self.productNumber = productNumber
            imgUrl = GlobalVariables.nwsSPCwebsitePrefix + "/products/md/mcd" + productNumber + ".gif"
//            textUrl = GlobalVariables.nwsSPCwebsitePrefix + "/products/md/md" + productNumber + ".html"
//            title = "MCD " + productNumber
            prod = "SPCMCD" + productNumber
        case .WPCMPD:
            self.productNumber = productNumber
            imgUrl = GlobalVariables.nwsWPCwebsitePrefix + "/metwatch/images/mcd" + productNumber + ".gif"
//            textUrl = ""
//            title = "MPD " + productNumber
            prod = "WPCMPD" + productNumber
        default:
            self.productNumber = ""
            imgUrl = ""
//            textUrl = ""
//            title = ""
            prod = ""
        }
    }

    func getData() {
        text = UtilityDownload.getTextProduct(prod.uppercased()).removeHtml()
        var textWithLatLon = text
        if type == .SPCWAT || type == .SPCWAT_TORNADO {
            textWithLatLon = ObjectWatchProduct.getLatLon(productNumber)
        }
        stringOfLatLon = LatLon.storeWatchMcdLatLon(textWithLatLon).replace(":", "")
        latLons = stringOfLatLon.split(" ")
        bitmap = Bitmap(imgUrl)
//        let wfoStr = text.parse("ATTN...WFO...(.*?)...<br>")
//        wfos = wfoStr.split("\\.\\.\\.")
    }
    
    func getDataTextOnly() -> String {
        text = UtilityDownload.getTextProduct(prod.uppercased()).removeHtml()
        var textWithLatLon = text
        if type == .SPCWAT || type == .SPCWAT_TORNADO {
            textWithLatLon = ObjectWatchProduct.getLatLon(productNumber)
        }
        stringOfLatLon = LatLon.storeWatchMcdLatLon(textWithLatLon).replace(":", "")
        latLons = stringOfLatLon.split(" ")
//        let wfoStr = text.parse("ATTN...WFO...(.*?)...<br>")
//        wfos = wfoStr.split("\\.\\.\\.")
        return text
    }

//    func getTextForSubtitle() -> String {
//        text.parse("AREAS AFFECTED...(.*?)CONCERNING").replace("<BR>", "")
//    }

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
            return (GlobalVariables.nwsSPCwebsitePrefix + "/products/watch/").getHtml().parseColumn("[om] Watch #([0-9]*?)</a>")
        case .SPCMCD:
            return (GlobalVariables.nwsSPCwebsitePrefix + "/products/md/").getHtml().parseColumn("<strong><a href=./products/md/md.....html.>Mesoscale Discussion #(.*?)</a></strong>")
        case .WPCMPD:
            return [String]()
        default:
            return [String]()
        }
    }

    private func getCenterOfPolygon(_ latLons: [LatLon]) -> LatLon {
        var center = LatLon(0.0, 0.0)
        for latLon in latLons {
            center.lat += latLon.lat
            center.lon += latLon.lon
        }
        let totalPoints = latLons.count
        center.lat /= Double(totalPoints)
        center.lon /= Double(totalPoints)
        return center
    }

    func getClosestRadar() -> String {
        if latLons.count > 2 {
            let latLonList = LatLon.parseStringToLatLons(stringOfLatLon, -1.0, false)
            let center = getCenterOfPolygon(latLonList)
            let radarSites = UtilityLocation.getNearestRadarSites(center, 1, includeTdwr: false)
            if radarSites.isEmpty {
                return ""
            } else {
                return radarSites[0].name
            }
        } else {
            return ""
        }
    }
    
    static func getLatLon(_ number: String) -> String {
        let html = (GlobalVariables.nwsSPCwebsitePrefix + "/products/watch/wou" + number + ".html").getHtml()
        return UtilityString.parseLastMatch(html, GlobalVariables.pre2Pattern)
    }
}
