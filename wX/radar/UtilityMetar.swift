/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityMetar {
    
    // FIXME var naming
    private static let patternMetarWxogl1 = ".*? (M?../M?..) .*?"
    private static let patternMetarWxogl2 = ".*? A([0-9]{4})"
    private static let patternMetarWxogl3 = "AUTO ([0-9].*?KT) .*?"
    private static let patternMetarWxogl4 = "Z ([0-9].*?KT) .*?"
    private static let patternMetarWxogl5 = "SM (.*?) M?[0-9]{2}/"
    private static var initializedObsMap = false
    static var obsArr = [String]()
    static var obsArrExt = [String]()
    static var obsArrWb = [String]()
    static var obsArrWbGust = [String]()
    static var obsArrX = [Double]()
    static var obsArrY = [Double]()
    private static var obsArrAviationColor = [Int]()
    private static var obsStateOld = ""
    private static var obsLatlon = [String: LatLon]()
    private static var timer = DownloadTimer("METAR")
    
    static func getStateMetarArrayForWXOGL(_ radarSite: String) {
        if timer.isRefreshNeeded() || radarSite != obsStateOld {
            var obsAl = [String]()
            var obsAlExt = [String]()
            var obsAlWb = [String]()
            var obsAlWbGust = [String]()
            var obsAlX = [Double]()
            var obsAlY = [Double]()
            var obsAlAviationColor = [Int]()
            obsStateOld = radarSite
            let obsList = getObservationSites(radarSite)
            let html = (MyApplication.nwsAWCwebsitePrefix + "/adds/metars/index?submit=1&station_ids=" + obsList + "&chk_metars=on").getHtml()
            let metarArr = condenseObs(html.parseColumn("<FONT FACE=\"Monospace,Courier\">(.*?)</FONT><BR>"))
            if !initializedObsMap {
                var lines = UtilityIO.rawFileToStringArray(R.Raw.us_metar3)
                _ = lines.popLast()
                lines.forEach { line in
                    let items = line.split(" ")
                    obsLatlon[items[0]] = LatLon(items[1], items[2])
                }
                initializedObsMap = true
            }
            metarArr.forEach { metar in
                var validWind = false
                var validWindGust = false
                if (metar.hasPrefix("K") || metar.hasPrefix("P")) && !metar.contains("NIL") {
                    let metarItems = metar.split(" ")
                    let TDArr = metar.parse(patternMetarWxogl1).split("/")
                    let timeBlob = metarItems.count > 1 ? metarItems[1] : ""
                    var pressureBlob = metar.parse(patternMetarWxogl2)
                    var windBlob = metar.parse(patternMetarWxogl3)
                    if windBlob == "" { windBlob = metar.parse(patternMetarWxogl4) }
                    let conditionsBlob = metar.parse(patternMetarWxogl5)
                    var visBlob = metar.parse(" ([0-9].*?SM) ")
                    let visBlobArr = visBlob.split(" ")
                    let visBlobDisplay = visBlobArr[visBlobArr.count - 1]
                    visBlob = visBlobArr[visBlobArr.count - 1].replace("SM", "")
                    var visInt = 0
                    if visBlob.contains("/") {
                        visInt = 0
                    } else if visBlob != "" {
                        visInt = Int(visBlob) ?? 0
                    } else {
                        visInt = 20000
                    }
                    var ovcStr = conditionsBlob.parse("OVC([0-9]{3})")
                    var bknStr = conditionsBlob.parse("BKN([0-9]{3})")
                    var ovcInt = 100000
                    var bknInt = 100000
                    if ovcStr != "" {
                        ovcStr += "00"
                        ovcInt = Int(ovcStr) ?? 0
                    }
                    if bknStr != "" {
                        bknStr += "00"
                        bknInt = Int(bknStr) ?? 0
                    }
                    let lowestCig = bknInt < ovcInt ? bknInt : ovcInt
                    var aviationColor = Color.GREEN
                    if visInt > 5 && lowestCig > 3000 { aviationColor = Color.GREEN }
                    if (visInt >= 3 &&  visInt <= 5) || ( lowestCig >= 1000 && lowestCig <= 3000) { aviationColor = Color.rgb(0, 100, 255) }
                    if (visInt >= 1 &&  visInt < 3) || ( lowestCig >= 500 && lowestCig < 1000) { aviationColor = Color.RED }
                    if visInt < 1  || lowestCig < 500 { aviationColor = Color.MAGENTA }
                    if pressureBlob.count == 4 {
                        pressureBlob = pressureBlob.insert(pressureBlob.count - 2, ".")
                        pressureBlob = UtilityMath.unitsPressure(pressureBlob)
                    }
                    var windDir = ""
                    var windInKt = ""
                    var windGustInKt = ""
                    var windDirD = 0.0
                    if windBlob.contains("KT") && windBlob.count==7 {
                        validWind = true
                        windDir = windBlob.substring(0, 3)
                        windInKt = windBlob.substring(3, 5)
                        windDirD = Double(windDir) ?? 0.0
                        windBlob = windDir + " (" + UtilityMath.convertWindDir(windDirD) + ") " + windInKt + " kt"
                    } else if windBlob.contains("KT") && windBlob.count==10 {
                        validWind = true
                        validWindGust = true
                        windDir = windBlob.substring(0, 3)
                        windInKt = windBlob.substring(3, 5)
                        windGustInKt = windBlob.substring(6, 8)
                        windDirD = Double(windDir) ?? 0.0
                        windBlob = windDir + " (" + UtilityMath.convertWindDir(windDirD) + ") " + windInKt + " G " + windGustInKt + " kt"
                    }
                    if TDArr.count > 1 {
                        var temperature = TDArr[0]
                        var dewPoint = TDArr[1]
                        temperature = UtilityMath.celsiusToFahrenheit(temperature.replace("M", "-")).replace(".0", "")
                        dewPoint = UtilityMath.celsiusToFahrenheit(dewPoint.replace("M", "-")).replace(".0", "")
                        let obsSite = metarItems[0]
                        var latlon = obsLatlon[obsSite] ?? LatLon()
                        latlon.lonString = latlon.lonString.replace("-0", "-")
                        obsAl.append(latlon.latString + ":" + latlon.lonString + ":" + temperature + "/" + dewPoint)
                        obsAlExt.append(latlon.latString + ":" + latlon.lonString + ":" + temperature
                            + "/" + dewPoint + " (" + obsSite + ")" + MyApplication.newline + pressureBlob
                            + " - " + visBlobDisplay + MyApplication.newline + windBlob + MyApplication.newline
                            + conditionsBlob + MyApplication.newline + timeBlob)
                        if validWind {
                            obsAlWb.append(latlon.latString + ":" + latlon.lonString + ":" + windDir + ":" + windInKt)
                            obsAlX.append(latlon.lat)
                            obsAlY.append(latlon.lon * -1.0)
                            obsAlAviationColor.append(aviationColor)
                        }
                        if validWindGust {
                            obsAlWbGust.append(latlon.latString
                                + ":"
                                + latlon.lonString
                                + ":"
                                + windDir
                                + ":"
                                + windGustInKt)
                        }
                    }
                }
            }
            obsArr = []
            obsArr = obsAl
            obsArrExt = []
            obsArrExt = obsAlExt
            obsArrWb = []
            obsArrWb = obsAlWb
            obsArrWbGust = []
            obsArrWbGust = obsAlWbGust
            obsArrX = []
            obsArrX = obsAlX
            obsArrY = []
            obsArrY = obsAlY
            obsArrAviationColor = []
            obsArrAviationColor = obsAlAviationColor
        }
    }
    
    static func getObsArrAviationColor() -> [Int] { obsArrAviationColor }
    
    private static var metarDataRaw = [String]()
    private static var metarSites = [RID]()
    
    static func readMetarData() {
        if metarDataRaw.isEmpty {
            metarDataRaw = UtilityIO.rawFileToStringArray(R.Raw.us_metar3)
            _ = metarDataRaw.popLast()
            metarSites = [RID]()
            metarDataRaw.forEach { metar in
                let items = metar.split(" ")
                metarSites.append(RID(items[0], LatLon(items[1], items[2])))
            }
        }
    }
    
    static func findClosestMetar(_ location: LatLon) -> String {
        readMetarData()
        var shortestDistance = 1000.00
        var currentDistance = 0.0
        var bestIndex = -1
        metarSites.indices.forEach { index in
            currentDistance = LatLon.distance(location, metarSites[index].location, .K)
            if currentDistance < shortestDistance {
                shortestDistance = currentDistance
                bestIndex = index
            }
        }
        if bestIndex == -1 {
            return "Please select a location in the United States."
        } else {
            let url = (WXGLDownload.nwsRadarPub + "data/observations/metar/decoded/" + metarSites[bestIndex].name + ".TXT")
            let html = url.getHtmlSep()
            return html.replace("<br>", MyApplication.newline)
        }
    }
    
    static func findClosestObservation(_ location: LatLon) -> RID {
        readMetarData()
        var shortestDistance = 1000.00
        var currentDistance = 0.0
        var bestIndex = -1
        metarSites.indices.forEach { index in
            currentDistance = LatLon.distance(location, metarSites[index].location, .K)
            if currentDistance < shortestDistance {
                shortestDistance = currentDistance
                bestIndex = index
            }
        }
        if bestIndex == -1 { return metarSites[0] } else { return metarSites[bestIndex] }
    }
    
    static func getObservationSites(_ radarSite: String) -> String {
        var obsListSb = ""
        let radarLocation = LatLon(radarSite: radarSite)
        readMetarData()
        let obsSiteRange = 200.0
        var currentDistance = 0.0
        metarSites.indices.forEach { index in
            currentDistance = LatLon.distance(radarLocation, metarSites[index].location, .MILES)
            if currentDistance < obsSiteRange { obsListSb += metarSites[index].name + "," }
        }
        return obsListSb.replaceAll(",$", "")
    }
    
    // used to condense a list of metar that contains multiple entries for one site,
    // newest is first so simply grab first/append
    private static func condenseObs(_ list: [String]) -> [String] {
        var siteMap = [String: Bool]()
        var goodObsList = [String]()
        list.forEach {
            let items = $0.split(" ")
            if items.count > 3 {
                if siteMap[items[0]] != true {
                    siteMap[items[0]] = true
                    goodObsList.append($0)
                }
            }
        }
        return goodObsList
    }
}
