/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityWatch {
    
    static func add(_ projectionNumbers: ProjectionNumbers, _ type: PolygonEnum) -> [Double] {
        var warningList = [Double]()
        let prefToken = ObjectPolygonWatch.polygonDataByType[type]?.latLonList.getValue() ?? ""
        if prefToken != "" {
            let polygons = prefToken.split(":")
            polygons.forEach { polygon in
                let latLons = LatLon.parseStringToLatLons(polygon, 1.0, false)
                warningList += LatLon.latLonListToListOfDoubles(latLons, projectionNumbers)
            }
        }
        return warningList
    }
    
    static func show(_ latLon: LatLon, _ type: PolygonEnum) -> String {
        let numberList: [String]
        let watchLatLon: String
        if type == PolygonEnum.SPCWAT {
            watchLatLon = ObjectPolygonWatch.watchLatlonCombined.getValue()
            numberList = ObjectPolygonWatch.polygonDataByType[PolygonEnum.SPCWAT]!.numberList.getValue().split(":")
        } else {
            numberList = ObjectPolygonWatch.polygonDataByType[type]!.numberList.getValue().split(":")
            watchLatLon = ObjectPolygonWatch.polygonDataByType[type]!.latLonList.getValue()
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
