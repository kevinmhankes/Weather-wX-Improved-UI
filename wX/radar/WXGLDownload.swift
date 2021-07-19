/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class WXGLDownload {
        
    private static let utilnxanimPattern1 = ">(sn.[0-9]{4})</a>"
    private static let utilnxanimPattern2 = ".*?([0-9]{2}-[A-Za-z]{3}-[0-9]{4} [0-9]{2}:[0-9]{2}).*?"
    static let nwsRadarPub = "https://tgftp.nws.noaa.gov/"
    private static let nwsRadarLevel2Pub = "https://nomads.ncep.noaa.gov/pub/data/nccf/radar/nexrad_level2/"
    
    static func getNidsTab(_ product: String, _ radarSite: String, _ fileName: String) {
        let url = getRadarFileUrl(radarSite, product, false)
        let inputStream = url.getDataFromUrl()
        UtilityIO.saveInputStream(inputStream, fileName)
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
        return nwsRadarPub + "SL.us008001/DF.of/DC.radar/" + productString + "/SI." + ridPrefix + radarSite.lowercased() + "/sn.last"
    }
    
    static func getRadarFile(_ url: String, _ radarSite: String, _ product: String, _ indexString: String, _ isTdwr: Bool, _ fileStorage: FileStorage) -> String {
        let l2BaseFn = "l2"
        let l3BaseFn = "nids"
        let ridPrefix = getRidPrefix(radarSite, isTdwr)
        if !product.contains("L2") {
            let data = getRadarFileUrl(radarSite, product, isTdwr).getDataFromUrl()
            if RadarPreferences.useFileStorage {
                fileStorage.memoryBuffer = MemoryBuffer(data)
            } else {
                UtilityIO.saveInputStream(data, l3BaseFn + indexString)
            }
        } else {
            if url == "" {
                let data = getInputStreamFromURLL2(getLevel2Url(radarSite))
                if  RadarPreferences.useFileStorage {
                    fileStorage.memoryBuffer = MemoryBuffer(data)
                } else {
                    UtilityIO.saveInputStream(data, l2BaseFn + "_d" + indexString)
                }
            }
            UtilityFileManagement.deleteFile(l2BaseFn + indexString)
            UtilityFileManagement.moveFile(l2BaseFn + "_d" + indexString, l2BaseFn + indexString)
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
        return nwsRadarPub + "SL.us008001/DF.of/DC.radar/" + productString + "/SI." + ridPrefix + radarSite.lowercased() + "/"
    }
    
    // Level 3: Download a list of files and return the list as a list of Strings
    private static func getLevel3FilesForAnimation(_ frameCount: Int, _ product: String, _ ridPrefix: String, _ radarSite: String, _ fileStorage: FileStorage) -> [String] {
        var listOfFiles = [String]()
        let html = getRadarDirectoryUrl(radarSite, product, ridPrefix).getHtml()
        var snFiles = html.parseColumn(utilnxanimPattern1)
        var snDates = html.parseColumn(utilnxanimPattern2)
        if snDates.count == 0 {
            let html = getRadarDirectoryUrl(radarSite, product, ridPrefix).getHtml()
            snFiles = html.parseColumn(utilnxanimPattern1)
            snDates = html.parseColumn(utilnxanimPattern2)
        }
        if snDates.count == 0 {
            let html = getRadarDirectoryUrl(radarSite, product, ridPrefix).getHtml()
            snFiles = html.parseColumn(utilnxanimPattern1)
            snDates = html.parseColumn(utilnxanimPattern2)
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
        (0..<frameCount).forEach { _ in
            var tmpK = index
            if tmpK < 0 {
                tmpK += 251
            }
            listOfFiles.append("sn." + String(format: "%04d", tmpK))
            index += 1
        }
        
        fileStorage.animationMemoryBuffer = [MemoryBuffer](repeating: MemoryBuffer(), count: frameCount)
        (0..<frameCount).forEach { index in
            let data = (getRadarDirectoryUrl(radarSite, product, ridPrefix) + listOfFiles[index]).getDataFromUrl()
            if RadarPreferences.useFileStorage {
                fileStorage.animationMemoryBuffer[index] = MemoryBuffer(data)
            } else {
                UtilityIO.saveInputStream(data, listOfFiles[index])
            }
        }
        return listOfFiles
    }
    
    // Level 2: Download a list of files and return the list as a list of Strings
    private static func getLevel2FilesForAnimation(_ baseUrl: String, _ frameCount: Int, _ fileStorage: FileStorage) -> [String] {
        var listOfFiles = [String]()
        let list = (baseUrl + "dir.list").getHtmlSep().replace("\n", " ").split(" ")
        var additionalAdd = 0
        let fnSize = Int(list[list.count - 3]) ?? 0
        let fnPrevSize = Int(list[list.count - 5]) ?? 0
        let ratio = Double(fnSize) / Double(fnPrevSize)
        if ratio < 0.75 {
            additionalAdd = 1
        }
        fileStorage.animationMemoryBuffer = [MemoryBuffer](repeating: MemoryBuffer(), count: frameCount)
        (0..<frameCount).forEach { index in
            listOfFiles.append(list[list.count - (frameCount - index + additionalAdd) * 2])
            let data = getInputStreamFromURLL2(baseUrl + listOfFiles[index])
            if RadarPreferences.useFileStorage {
                fileStorage.animationMemoryBuffer[frameCount] = MemoryBuffer(data)
            } else {
                UtilityIO.saveInputStream(data, listOfFiles[index])
            }
        }
        return listOfFiles
    }
    
    private static func getLevel2Url(_ radarSite: String) -> String {
        let ridPrefix = getRidPrefix(radarSite, false).uppercased()
        let baseUrl = nwsRadarLevel2Pub + ridPrefix + radarSite + "/"
        let html = (baseUrl + "dir.list").getHtmlSep()
        var sizes = [String]()
        html.split("\n").forEach { sizes.append($0.split(" ")[0]) }
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
        let byteEnd = "3000000"
        let myJustDefaults = JustSessionDefaults(headers: ["Range": "bytes=0-" + byteEnd])
        let just = JustOf<HTTP>(defaults: myJustDefaults)
        let result = just.get(url)
        return result.content ?? Data()
    }
}
