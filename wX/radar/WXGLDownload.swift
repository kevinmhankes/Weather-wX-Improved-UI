// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Foundation

final class WXGLDownload {
        
    private static let pattern1 = ">(sn.[0-9]{4})</a>"
    private static let pattern2 = ".*?([0-9]{2}-[A-Za-z]{3}-[0-9]{4} [0-9]{2}:[0-9]{2}).*?"
    private static let nwsRadarLevel2Pub = "https://nomads.ncep.noaa.gov/pub/data/nccf/radar/nexrad_level2/"
    
    static func getNidsTab(_ product: String, _ radarSite: String, _ fileStorage: FileStorage) {
        let url = getRadarFileUrl(radarSite, product, false)
        let inputStream = url.getDataFromUrl()
        fileStorage.setMemoryBufferForL3TextProducts(product, inputStream)
    }
    
    private static func getRidPrefix(_ radarSite: String, _ isTdwr: Bool) -> String {
        if isTdwr {
            return ""
        } else {
            switch radarSite {
            case "JUA":
                return "t"
            case "HKI", "HMO", "HKM", "HWA", "APD", "ACG", "AIH", "AHG", "AKC", "ABC", "AEC", "GUA":
                return "p"
            default:
                return "k"
            }
        }
    }
    
    private static func getRadarFileUrl(_ radarSite: String, _ product: String, _ isTdwr: Bool) -> String {
        let ridPrefix = getRidPrefix(radarSite, isTdwr)
        let productString = GlobalDictionaries.nexradProductString[product] ?? ""
        return GlobalVariables.tgftpSitePrefix + "/SL.us008001/DF.of/DC.radar/" + productString + "/SI." + ridPrefix + radarSite.lowercased() + "/sn.last"
    }
    
    static func getRadarFile(_ url: String, _ radarSite: String, _ product: String, _ indexString: String, _ isTdwr: Bool, _ fileStorage: FileStorage) -> String {
        let ridPrefix = getRidPrefix(radarSite, isTdwr)
        if !product.contains("L2") {
            let data = getRadarFileUrl(radarSite, product, isTdwr).getDataFromUrl()
            fileStorage.memoryBuffer = MemoryBuffer(data)
        } else {
            if url == "" {
                let data = getInputStreamFromURLL2(getLevel2Url(radarSite))
                fileStorage.memoryBufferL2 = MemoryBuffer(data)
            }
        }
        return ridPrefix
    }
    
    // Download a list of files and return the list as a list of Strings
    // Determines of Level 2 or Level 3 and calls appropriate method
    static func getRadarFilesForAnimation(_ frameCount: Int, _ prod: String, _ radarSite: String, _ fileStorage: FileStorage) -> [String] {
        let listOfFiles: [String]
        let ridPrefix = getRidPrefix(radarSite, WXGLNexrad.isProductTdwr(prod))
        if !prod.contains("L2") {
            listOfFiles = getLevel3FilesForAnimation(frameCount, prod, ridPrefix, radarSite.lowercased(), fileStorage)
        } else {
            listOfFiles = getLevel2FilesForAnimation(nwsRadarLevel2Pub + ridPrefix.uppercased() + radarSite.uppercased() + "/", frameCount, fileStorage)
        }
        return listOfFiles
    }
    
    private static func getRadarDirectoryUrl(_ radarSite: String, _ product: String, _ ridPrefix: String) -> String {
        let productString = GlobalDictionaries.nexradProductString[product] ?? ""
        return GlobalVariables.tgftpSitePrefix + "/SL.us008001/DF.of/DC.radar/" + productString + "/SI." + ridPrefix + radarSite.lowercased() + "/"
    }
    
    // Level 3: Download a list of files and return the list as a list of Strings
    private static func getLevel3FilesForAnimation(_ frameCount: Int, _ product: String, _ ridPrefix: String, _ radarSite: String, _ fileStorage: FileStorage) -> [String] {
        var listOfFiles = [String]()
        let html = getRadarDirectoryUrl(radarSite, product, ridPrefix).getHtml()
        var snFiles = html.parseColumn(pattern1)
        var snDates = html.parseColumn(pattern2)
        if snDates.count == 0 {
            let html = getRadarDirectoryUrl(radarSite, product, ridPrefix).getHtml()
            snFiles = html.parseColumn(pattern1)
            snDates = html.parseColumn(pattern2)
        }
        if snDates.count == 0 {
            let html = getRadarDirectoryUrl(radarSite, product, ridPrefix).getHtml()
            snFiles = html.parseColumn(pattern1)
            snDates = html.parseColumn(pattern2)
        }
        var mostRecentSn = ""
        let mostRecentTime = snDates.last
        (0..<snDates.count - 1).forEach {
            if snDates[$0] == mostRecentTime {
                mostRecentSn = snFiles[$0]
            }
        }
        let seq = to.Int(mostRecentSn.replace("sn.", ""))
        var index = seq - frameCount + 1
        (0..<frameCount).forEach { _ in
            var tmpK = index
            if tmpK < 0 {
                tmpK += 251
            }
            let fn = "sn." + to.stringPadLeftZeros(tmpK, 4)
            listOfFiles.append(fn)
            // listOfFiles.append("sn." + String(format: "%04d", tmpK))
            index += 1
        }
        fileStorage.animationMemoryBuffer = [MemoryBuffer](repeating: MemoryBuffer(), count: frameCount)
        (0..<frameCount).forEach { index in
            let data = (getRadarDirectoryUrl(radarSite, product, ridPrefix) + listOfFiles[index]).getDataFromUrl()
            fileStorage.animationMemoryBuffer[index] = MemoryBuffer(data)
        }
        return listOfFiles
    }
    
    // Level 2: Download a list of files and return the list as a list of Strings
    private static func getLevel2FilesForAnimation(_ baseUrl: String, _ frameCount: Int, _ fileStorage: FileStorage) -> [String] {
        var listOfFiles = [String]()
        let list = (baseUrl + "dir.list").getHtmlSep().replace("\n", " ").split(" ")
        var additionalAdd = 0
        let fnSize = to.Int(list[list.count - 3])
        let fnPrevSize = to.Int(list[list.count - 5])
        let ratio = Double(fnSize) / Double(fnPrevSize)
        if ratio < 0.75 {
            additionalAdd = 1
        }
        fileStorage.animationMemoryBuffer = [MemoryBuffer](repeating: MemoryBuffer(), count: frameCount)
        fileStorage.animationMemoryBufferL2 = [MemoryBuffer](repeating: MemoryBuffer(), count: frameCount)
        let dispatchGroup = DispatchGroup()
        (0..<frameCount).forEach { index in
            dispatchGroup.enter()
            // queueL2.async(group: dispatchGroup) {
            DispatchQueue.global().async {
                let url = list[list.count - (frameCount - index + additionalAdd) * 2]
                listOfFiles.append(url)
                let data = getInputStreamFromURLL2(baseUrl + url)
                fileStorage.animationMemoryBufferL2[index] = MemoryBuffer(data)
                UtilityWXMetalPerfL2.decompressForAnimation(fileStorage, index)
                dispatchGroup.leave()
            }
        }
        dispatchGroup.wait()
        return listOfFiles
    }
    
    private static func getLevel2Url(_ radarSite: String) -> String {
        let ridPrefix = getRidPrefix(radarSite, false).uppercased()
        let baseUrl = nwsRadarLevel2Pub + ridPrefix + radarSite + "/"
        let html = (baseUrl + "dir.list").getHtmlSep()
        var sizes = [String]()
        html.split("\n").forEach {
            sizes.append($0.split(" ")[0])
        }
        sizes.removeLast()
        let tmpArr = html.replace("<br>", " ").split(" ")
        if tmpArr.count < 4 {
            return ""
        }
        var fileName = tmpArr[tmpArr.count - 1].split("\n")[0]
        let fnPrev = tmpArr[tmpArr.count - 2].split("\n")[0]
        let fnSize = Int(sizes[sizes.count - 1]) ?? 1
        let fnPrevSize = Int(sizes[sizes.count - 2]) ?? 1
        let ratio = Double(fnSize) / Double(fnPrevSize)
        if ratio < 0.75 {
            fileName = fnPrev
        }
        return baseUrl + fileName
    }
    
    private static func getInputStreamFromURLL2(_ url: String) -> Data {
        UtilityLog.d("getInputStreamFromURLL2 " + url)
        let byteEnd = "3000000"
        let myJustDefaults = JustSessionDefaults(headers: ["Range": "bytes=0-" + byteEnd])
        let just = JustOf<HTTP>(defaults: myJustDefaults)
        let result = just.get(url)
        return result.content ?? Data()
    }
}
