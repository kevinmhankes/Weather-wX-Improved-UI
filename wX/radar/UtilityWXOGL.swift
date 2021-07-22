/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityWXOGL {

    static func showTextProducts(_ latLon: LatLon) -> String {        
        var warningChunk = ""
        for type1 in [PolygonTypeGeneric.TOR, PolygonTypeGeneric.FFW, PolygonTypeGeneric.TST] {
            warningChunk += ObjectPolygonWarning.polygonDataByType[type1]!.getData()
        }
        
        for data in ObjectPolygonWarning.polygonList {
            let it = ObjectPolygonWarning.polygonDataByType[data]!
            if it.isEnabled {
                warningChunk += it.storage.value
            }
        }
        let warnings = ObjectWarning.parseJson(warningChunk)
        var urlToOpen = ""
        var notFound = true
        for w in warnings {
            let latLons = w.getPolygonAsLatLons(1)
            if latLons.count > 0 {
                let contains = ExternalPolygon.polygonContainsPoint(latLon, latLons)
                if contains && notFound {
                    urlToOpen = w.getUrl()
                    notFound = false
                }
            }
        }
        return urlToOpen
    }
}
