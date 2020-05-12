/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

class UtilityWatch {
    
    static func add(_ projectionNumbers: ProjectionNumbers, _ type: PolygonType) -> [Double] {
        var warningList = [Double]()
        var prefToken = ""
        switch type.string {
        case "MCD":
            prefToken = MyApplication.mcdLatlon.value
        case "WATCH":
            prefToken = MyApplication.watchLatlon.value
        case "WATCH_TORNADO":
            prefToken = MyApplication.watchLatlonTor.value
        case "MPD":
            prefToken = MyApplication.mpdLatlon.value
        default:
            break
        }
        if prefToken != "" {
            let polygons = prefToken.split(":")
            polygons.forEach { polygon in
                let latLons = LatLon.parseStringToLatLons(polygon, 1.0, false)
                warningList += LatLon.latLonListToListOfDoubles(latLons, projectionNumbers)
            }
        }
        return warningList
    }
    
    static func show(_ latLon: LatLon, _ type: PolygonType) -> String {
        let numberList: [String]
        let watchLatLon: String
        switch type.string {
        case "WATCH":
            numberList = MyApplication.watNoList.value.split(":")
            watchLatLon = MyApplication.watchLatlonCombined.value
        case "MCD":
            numberList = MyApplication.mcdNoList.value.split(":")
            watchLatLon = MyApplication.mcdLatlon.value
        case "MPD":
            numberList = MyApplication.mpdNoList.value.split(":")
            watchLatLon = MyApplication.mpdLatlon.value
        default:
            numberList = MyApplication.watNoList.value.split(":")
            watchLatLon = MyApplication.watchLatlon.value
        }
        let latLonsFromString = watchLatLon.split(":")
        var notFound = true
        var text = ""
        latLonsFromString.indices.forEach { z in
            let latLons = LatLon.parseStringToLatLons(latLonsFromString[z], -1.0, false)
            if latLons.count > 3 {
                let contains = ExternalPolygon.polygonContainsPoint(latLon, latLons)
                if contains && notFound {
                    text = numberList[z]
                    notFound = false
                }
            }
        }
        return text
    }
}
