/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class WXGLPolygonWarnings {
    
    static func addGeneric(_ projectionNumbers: ProjectionNumbers, _ type: ObjectPolygonWarning) -> [Double] {
        let html = type.storage.value
        let warnings = ObjectWarning.parseJson(html)
        var warningList = [Double]()
        for w in warnings {
            if type.type == PolygonTypeGeneric.SPS || type.type == PolygonTypeGeneric.SMW || w.isCurrent {
                let latLons = w.getPolygonAsLatLons(-1)
                warningList += LatLon.latLonListToListOfDoubles(latLons, projectionNumbers)
            }
        }
        return warningList
    }
    
    static func add(_ projectionNumbers: ProjectionNumbers, _ type: PolygonEnum) -> [Double] {
        let html = ObjectPolygonWarning.polygonDataByType[changeType(type)]!.getData()
        let warnings = ObjectWarning.parseJson(html)
        var warningList = [Double]()
        for w in warnings {
            if w.isCurrent {
                let latLons = w.getPolygonAsLatLons(-1)
                warningList += LatLon.latLonListToListOfDoubles(latLons, projectionNumbers)
            }
        }
        return warningList
    }
    
    static func getCount( _ type: PolygonEnum) -> String {
        let html = ObjectPolygonWarning.polygonDataByType[changeType(type)]!.getData()
        if html == "" {
            return "-"
        }
        let warningList = ObjectWarning.parseJson(html)
        var i = 0
        for s in warningList {
            if s.isCurrent {
                i += 1
            }
        }
        return String(i)
    }
    
    static func changeType(_ type: PolygonEnum) -> PolygonTypeGeneric {
        switch type {
        case PolygonEnum.TOR:
            return PolygonTypeGeneric.TOR
        case PolygonEnum.TST:
            return PolygonTypeGeneric.TST
        case PolygonEnum.FFW:
            return PolygonTypeGeneric.FFW
        default:
            return PolygonTypeGeneric.FFW
        }
    }
}
