/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityMetar {

    static let patternMetarWxogl1 = ".*? (M?../M?..) .*?"
    static let patternMetarWxogl2 = ".*? A([0-9]{4})"
    static let patternMetarWxogl3 = "AUTO ([0-9].*?KT) .*?"
    static let patternMetarWxogl4 = "Z ([0-9].*?KT) .*?"
    static let patternMetarWxogl5 = "SM (.*?) M?[0-9]{2}/"

    static var initialized = false
    static var initializedObsMap = false
    static var obsArr = [String]()
    static var obsArrExt = [String]()
    static var obsArrWb = [String]()
    static var obsArrWbGust = [String]()
    static var obsArrX = [Double]()
    static var obsArrY = [Double]()
    static var obsArrAviationColor = [Int]()
    static var obsStateOld = ""
    static var lastRefresh: CLong = 0
    static var refreshLocMin = RadarPreferences.radarDataRefreshInterval
    static var obsLatlon = [String: LatLon]()

    static func rawFileToStringArray(_ rawFile: String) -> [String] {
        return UtilityIO.readTextFile(rawFile).split("\n")
    }

    static func getStateMetarArrayForWXOGL(_ radarSite: String) {
        let currentTime1: CLong = UtilityTime.currentTimeMillis()
        let currentTimeSec: CLong = currentTime1 / 1000
        let refreshIntervalSec: CLong = refreshLocMin * 60
        if (currentTimeSec > (lastRefresh + refreshIntervalSec)) || !initialized || radarSite != obsStateOld {
            var obsAl = [String]()
            var obsAlExt = [String]()
            var obsAlWb = [String]()
            var obsAlWbGust = [String]()
            var obsAlX = [Double]()
            var obsAlY = [Double]()
            var obsAlAviationColor = [Int]()
            obsStateOld = radarSite
            let obsList = getObservationSites(radarSite)
            let html = (MyApplication.nwsAWCwebsitePrefix + "/adds/metars/index?submit=1&station_ids="
                + obsList + "&chk_metars=on").getHtml()
            let metarArrTmp = html.parseColumn("<FONT FACE=\"Monospace,Courier\">(.*?)</FONT><BR>")
            let metarArr = condenseObs(metarArrTmp)
            if !initializedObsMap {
                var lines = rawFileToStringArray(R.Raw.us_metar3)
                _ = lines.popLast()
                lines.forEach {
                    let tmpArr = $0.split(" ")
                    obsLatlon[tmpArr[0]] = LatLon(tmpArr[1], tmpArr[2])
                }
                initializedObsMap = true
            }
            var tmpArr2 = [String]()
            var obsSite = ""
            var tmpBlob = ""
            var pressureBlob = ""
            var windBlob = ""
            var conditionsBlob = ""
            var timeBlob = ""
            var visBlob = ""
            var visBlobDisplay = ""
            var visBlobArr = [String]()
            var visInt = 0
            var aviationColor = 0
            var TDArr = [String]()
            var temperature = ""
            var dewpoint = ""
            var latlon = LatLon()
            var windDir = ""
            var windInKt = ""
            var windgustInKt = ""
            var windDirD = 0.0
            var validWind = false
            var validWindGust = false
            metarArr.forEach { metar in
                validWind = false
                validWindGust = false
                if (metar.hasPrefix("K") || metar.hasPrefix("P")) && !metar.contains("NIL") {
                    tmpArr2 = metar.split(" ")
                    tmpBlob = metar.parse(patternMetarWxogl1)
                    TDArr = tmpBlob.split("/")
                    if tmpArr2.count>1 {
                        timeBlob = tmpArr2[1]
                    }
                    pressureBlob = metar.parse(patternMetarWxogl2)
                    windBlob = metar.parse(patternMetarWxogl3)
                    if windBlob=="" {
                        windBlob = metar.parse(patternMetarWxogl4)
                    }
                    conditionsBlob = metar.parse(patternMetarWxogl5)
                    visBlob = metar.parse(" ([0-9].*?SM) ")
                    visBlobArr = visBlob.split(" ")
                    visBlobDisplay = visBlobArr[visBlobArr.count - 1]
                    visBlob = visBlobArr[visBlobArr.count - 1].replace("SM", "")
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
                    var lowestCig: Int
                    if ovcStr != "" {
                        ovcStr += "00"
                        ovcInt = Int(ovcStr) ?? 0
                    }
                    if bknStr != "" {
                        bknStr += "00"
                        bknInt = Int(bknStr) ?? 0
                    }
                    if bknInt < ovcInt {
                        lowestCig = bknInt
                    } else {
                        lowestCig = ovcInt
                    }
                    aviationColor = Color.GREEN
                    if visInt > 5 && lowestCig > 3000 {aviationColor = Color.GREEN}
                    if (visInt >= 3 &&  visInt <= 5) || ( lowestCig >= 1000 && lowestCig <= 3000) {
                        aviationColor = Color.rgb(0, 100, 255)
                    }
                    if (visInt >= 1 &&  visInt < 3) || ( lowestCig >= 500 && lowestCig < 1000) {
                        aviationColor = Color.RED
                    }
                    if visInt < 1  || lowestCig < 500 {
                        aviationColor = Color.MAGENTA
                    }
                    if pressureBlob.count == 4 {
                        pressureBlob = pressureBlob.insert(pressureBlob.count - 2, ".")
                        pressureBlob = UtilityMath.unitsPressure(pressureBlob)
                    }
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
                        windgustInKt = windBlob.substring(6, 8)
                        windDirD = Double(windDir) ?? 0.0
                        windBlob = windDir + " (" + UtilityMath.convertWindDir(windDirD) + ") "
                            + windInKt + " G " + windgustInKt + " kt"
                    }
                    if TDArr.count>1 {
                        temperature = TDArr[0]
                        dewpoint = TDArr[1]
                        temperature = UtilityMath.celsiusToFarenheit(temperature.replace("M", "-")).replace(".0", "")
                        dewpoint = UtilityMath.celsiusToFarenheit(dewpoint.replace("M", "-")).replace(".0", "")
                        obsSite = tmpArr2[0]
                        latlon = obsLatlon[obsSite] ?? LatLon()
                        latlon.lonString = latlon.lonString.replace("-0", "-")
                        obsAl.append(latlon.latString + ":" + latlon.lonString + ":" + temperature + "/" + dewpoint)
                        obsAlExt.append(latlon.latString + ":" + latlon.lonString + ":" + temperature
                            + "/" + dewpoint + " (" + obsSite + ")" + MyApplication.newline + pressureBlob
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
                                + windgustInKt)
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
            initialized = true
            let currentTime: CLong = UtilityTime.currentTimeMillis()
            lastRefresh = currentTime / 1000
        }
    }

    static func getObsArrAviationColor() -> [Int] {
        return obsArrAviationColor
    }

    static func findClosestMetar(_ location: LatLon) -> String {
        var lines = rawFileToStringArray(R.Raw.us_metar3)
        _ = lines.popLast()
        var metarSites = [RID]()
        lines.forEach {
            let tmpArr = $0.split(" ")
            metarSites.append(RID(tmpArr[0], LatLon(tmpArr[1], tmpArr[2])))
        }
        var shortestDistance = 1000.00
        var currentDistance = 0.0
        var bestIndex = -1
        metarSites.indices.forEach {
            currentDistance = LatLon.distance(location, metarSites[$0].location, .K)
            if currentDistance < shortestDistance {
                shortestDistance = currentDistance
                bestIndex = $0
            }
        }
        if bestIndex == -1 {
            return "Please select a location in the United States."
        } else {
            let url = (WXGLDownload.nwsRadarPub + "data/observations/metar/decoded/"
                + metarSites[bestIndex].name + ".TXT")
            let html = url.getHtmlSep()
            return html.replace("<br>", MyApplication.newline)
        }
    }

    static func findClosestObservation(_ location: LatLon) -> RID {
        var lines = rawFileToStringArray(R.Raw.us_metar3)
        _ = lines.popLast()
        var metarSites = [RID]()
        lines.forEach {
            let tmpArr = $0.split(" ")
            metarSites.append(RID(tmpArr[0], LatLon(tmpArr[1], tmpArr[2])))
        }
        var shortestDistance = 1000.00
        var currentDistance = 0.0
        var bestIndex = -1
        metarSites.indices.forEach {
            currentDistance = LatLon.distance(location, metarSites[$0].location, .K)
            if currentDistance < shortestDistance {
                shortestDistance = currentDistance
                bestIndex = $0
            }
        }
        if bestIndex == -1 {
            return metarSites[0]
        } else {
            return metarSites[bestIndex]
        }
    }

    static func getObservationSites(_ radarSite: String) -> String {
        var obsListSb = ""
        let radarLocation = LatLon(radarSite, isRadar: true)
        var lines = rawFileToStringArray(R.Raw.us_metar3)
        _ = lines.popLast()
        var obsSites = [RID]()
        lines.forEach {
            let tmpArr = $0.split(" ")
            obsSites.append(RID(tmpArr[0], LatLon(tmpArr[1], tmpArr[2])))
        }
        let obsSiteRange = 200.0
        var currentDistance = 0.0
        obsSites.indices.forEach {
            currentDistance = LatLon.distance(radarLocation, obsSites[$0].location, .M)
            if currentDistance < obsSiteRange {obsListSb += obsSites[$0].name + ","}
        }
        return obsListSb.replaceAll(",$", "")
    }

    // used to condense a list of metar that contains multiple entries for one site,
    // newest is first so simply grab first/append
    static func condenseObs(_ list: [String]) -> [String] {
        var siteMap = [String: Bool]()
        var goodObsList = [String]()
        list.forEach {
            let tokens = $0.split(" ")
            if tokens.count > 3 {
                if siteMap[tokens[0]] != true {
                    siteMap[tokens[0]] = true
                    goodObsList.append($0)
                }
            }
        }
        return goodObsList
    }
}
