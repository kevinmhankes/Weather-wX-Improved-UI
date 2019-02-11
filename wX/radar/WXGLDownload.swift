/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class WXGLDownload {

    static let utilnxanimPattern1 = ">(sn.[0-9]{4})</a>"
    static let utilnxanimPattern2 = ".*?([0-9]{2}-[A-Za-z]{3}-[0-9]{4} [0-9]{2}:[0-9]{2}).*?"
    static var nwsRadarPub = "https://tgftp.nws.noaa.gov/"
    static var nwsRadarLevel2Pub = "https://nomads.ncep.noaa.gov/pub/data/nccf/radar/nexrad_level2/"
    private var radarSite = ""
    private var prod = ""

    static func getNidsTab(_ product: String, _ radarSite: String, _ fileName: String) {
        let ridPrefix = WXGLDownload().getRidPrefix(radarSite, false)
        let url = WXGLDownload.nwsRadarPub + "SL.us008001/DF.of/DC.radar/"
            + GlobalDictionaries.nexradProductString[product]! + "/SI."
            + ridPrefix + radarSite.lowercased() + "/sn.last"
        let inputstream = UtilityDownload.getInputStreamFromUrl(url)
        UtilityIO.saveInputStream(inputstream, fileName)
    }

    func getRidPrefix(_ radarSite: String, _ tdwr: Bool) -> String {
        var ridPrefix = "k"
        switch radarSite {
        case "JUA":
            ridPrefix = "t"
        case "HKI", "HMO", "HKM", "HWA", "APD", "ACG", "AIH", "AHG", "AKC", "ABC", "AEC", "GUA":
            ridPrefix = "p"
        default:
            ridPrefix = "k"
        }
        if tdwr {
            ridPrefix = ""
        }
        return ridPrefix
    }

    func getRidPrefix(_ radarSite: String, _ product: String) -> String {
        var ridPrefix = "k"
        switch radarSite {
        case "JUA":
            ridPrefix = "t"
        case "HKI", "HMO", "HKM", "HWA", "APD", "ACG", "AIH", "AHG", "AKC", "ABC", "AEC", "GUA":
            ridPrefix = "p"
        default:
            ridPrefix = "k"
        }
        if product=="TV0" || product=="TZL" {
            ridPrefix = ""
        }
        return ridPrefix
    }

    func getRadarFile(_ urlStr: String, _ rid: String, _ prod: String, _ idxStr: String, _ tdwr: Bool) -> String {
        let l2BaseFn = "l2"
        let l3BaseFn = "nids"
        let ridPrefix = getRidPrefix(rid, tdwr)
        self.radarSite = rid
        self.prod = prod
        let ridPrefixGlobal = ridPrefix
        let productId = GlobalDictionaries.nexradProductString[prod] ?? ""
        if !prod.contains("L2") {
            let data = UtilityDownload.getInputStreamFromUrl(WXGLDownload.nwsRadarPub
                + "SL.us008001/DF.of/DC.radar/" + productId + "/SI."
                + ridPrefix + rid.lowercased() + "/sn.last")
            UtilityIO.saveInputStream(data, l3BaseFn + idxStr)
        } else {
            if urlStr == "" {
                let data = getInputStreamFromURLL2(getLevel2Url())
                UtilityIO.saveInputStream(data, l2BaseFn + "_d" + idxStr)
            }
            UtilityFileManagement.deleteFile(l2BaseFn + idxStr)
            UtilityFileManagement.moveFile(l2BaseFn + "_d" + idxStr, l2BaseFn + idxStr)
        }
        return ridPrefixGlobal
    }

    // Download a list of files and return the list as a list of Strings
    // Determines of Level 2 or Level 3 and calls appropriate method
    func getRadarFilesForAnimation(_ frameCount: Int) -> [String] {
        var listOfFiles = [String]()
        let ridPrefix = getRidPrefix(radarSite, prod)
        if !prod.contains("L2") {
            listOfFiles = getLevel3FilesForAnimation(frameCount, prod, ridPrefix, radarSite.lowercased())
        } else {
            listOfFiles = getLevel2FilesForAnimation(WXGLDownload.nwsRadarLevel2Pub
                + ridPrefix.uppercased() + radarSite.uppercased() + "/", frameCount)
        }
        return listOfFiles
    }

    // Level 3: Download a list of files and return the list as a list of Strings
    func getLevel3FilesForAnimation(
        _ frameCount: Int,
        _ product: String,
        _ ridPrefix: String,
        _ rid: String
        ) -> [String] {
        var listOfFiles = [String]()
        let productId = GlobalDictionaries.nexradProductString[prod] ?? ""
        let html = (WXGLDownload.nwsRadarPub + "SL.us008001/DF.of/DC.radar/"
            + productId + "/SI." + ridPrefix + rid.lowercased() + "/").getHtml()
        var snFiles = html.parseColumn(WXGLDownload.utilnxanimPattern1)
        var snDates = html.parseColumn(WXGLDownload.utilnxanimPattern2)
        // FIXME below method is for rety, redo this - ugly
        if snDates.count == 0 {
            let html = (WXGLDownload.nwsRadarPub + "SL.us008001/DF.of/DC.radar/"
                + productId + "/SI." + ridPrefix + rid.lowercased() + "/").getHtml()
            snFiles = html.parseColumn(WXGLDownload.utilnxanimPattern1)
            snDates = html.parseColumn(WXGLDownload.utilnxanimPattern2)
        }
        if snDates.count == 0 {
            let html = (WXGLDownload.nwsRadarPub + "SL.us008001/DF.of/DC.radar/"
                + productId + "/SI." + ridPrefix + rid.lowercased() + "/").getHtml()
            snFiles = html.parseColumn(WXGLDownload.utilnxanimPattern1)
            snDates = html.parseColumn(WXGLDownload.utilnxanimPattern2)
        }
        var mostRecentSn = ""
        let mostRecentTime = snDates.last
        (0..<snDates.count - 1).forEach {
            if snDates[$0] == mostRecentTime {
                mostRecentSn = snFiles[$0]
            }
        }
        let seq = Int(mostRecentSn.replace("sn.", "")) ?? 0
        var index = seq - frameCount + 1
        (0..<frameCount).forEach {_ in
            var tmpK = index
            if tmpK < 0 {
                tmpK += 251
            }
            listOfFiles.append("sn." + String(format: "%04d", tmpK))
            index += 1
        }
        (0..<frameCount).forEach {
            let data = UtilityDownload.getInputStreamFromUrl(WXGLDownload.nwsRadarPub
                + "SL.us008001/DF.of/DC.radar/"
                + GlobalDictionaries.nexradProductString[prod]!
                + "/SI." + ridPrefix + rid.lowercased()
                + "/" + listOfFiles[$0])
            UtilityIO.saveInputStream(data, listOfFiles[$0])
        }
        return listOfFiles
    }

    // Level 2: Download a list of files and return the list as a list of Strings
    func getLevel2FilesForAnimation(_ baseUrl: String, _ frameCnt: Int) -> [String] {
        var listOfFiles = [String]()
        let tmpArr = (baseUrl + "dir.list").getHtmlSep().replace("\n", " ").split(" ")
        var additionalAdd = 0
        let fnSize = Int(tmpArr[tmpArr.count - 3]) ?? 0
        let fnPrevSize = Int(tmpArr[tmpArr.count - 5]) ?? 0
        let ratio = Double(fnSize) / Double(fnPrevSize)
        if ratio < 0.75 {
            additionalAdd = 1
        }
        (0..<frameCnt).forEach {
            listOfFiles.append(tmpArr[tmpArr.count - (frameCnt - $0 + additionalAdd) * 2])
            let data = getInputStreamFromURLL2(baseUrl + listOfFiles[$0])
            UtilityIO.saveInputStream(data, listOfFiles[$0])
        }
        return listOfFiles
    }

    func getLevel2Url() -> String {
        let ridPrefix = getRidPrefix(radarSite, false).uppercased()
        let baseUrl = WXGLDownload.nwsRadarLevel2Pub + ridPrefix + radarSite + "/"
        let tmpArr = (baseUrl + "dir.list").getHtmlSep().replace("<br>", " ").split(" ")
        if tmpArr.count < 4 {
            return ""
        }
        var fileName = tmpArr[tmpArr.count - 1].split("\n")[0]
        let fnPrev = tmpArr[tmpArr.count - 3]
        let fnSize = Int(tmpArr[tmpArr.count - 2]) ?? 1
        let fnPrevSize = Int(tmpArr[tmpArr.count - 4]) ?? 1
        let ratio = Double(fnSize) / Double(fnPrevSize)
        if ratio < 0.75 {
            fileName = fnPrev
        }
        return baseUrl + fileName
    }

    func getInputStreamFromURLL2(_ url: String) -> Data {
        let byteEnd = "3000000"
        let myJustDefaults = JustSessionDefaults(headers: ["Range": "bytes=0-" + byteEnd])
        let just = JustOf<HTTP>(defaults: myJustDefaults)
        let result = just.get(url)
        return result.content ?? Data()
    }
}
