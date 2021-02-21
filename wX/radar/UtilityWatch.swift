/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityWatch {
    
    static func add(_ projectionNumbers: ProjectionNumbers, _ type: PolygonEnum) -> [Double] {
        var warningList = [Double]()
        var prefToken = ""
        switch type {
        case .SPCMCD:
            prefToken = MyApplication.mcdLatlon.value
        case .SPCWAT:
            prefToken = MyApplication.watchLatlon.value
        case .SPCWAT_TORNADO:
            prefToken = MyApplication.watchLatlonTor.value
        case .WPCMPD:
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
    
    static func show(_ latLon: LatLon, _ type: PolygonEnum) -> String {
        let numberList: [String]
        let watchLatLon: String
        switch type {
        case .SPCWAT:
            numberList = MyApplication.watNoList.value.split(":")
            watchLatLon = MyApplication.watchLatlonCombined.value
        case .SPCMCD:
            numberList = MyApplication.mcdNoList.value.split(":")
            watchLatLon = MyApplication.mcdLatlon.value
        case .WPCMPD:
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
