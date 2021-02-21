/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class UtilityCanvasProjection {
    
    static func computeMercatorNumbers(_ lat: Double, _ lon: Double, _ projectionNumbers: ProjectionNumbers) -> [Double] {
        let test1 = (180.0 / Double.pi * log(tan(Double.pi / 4 + lat * (Double.pi / 180) / 2)))
        let test2 = (180.0 / Double.pi * log(tan(Double.pi / 4 + projectionNumbers.xDbl * (Double.pi / 180) / 2)))
        let y = -((test1 - test2) *  projectionNumbers.oneDegreeScaleFactor) + projectionNumbers.yCenterDouble
        let x = -((lon - projectionNumbers.yDbl) * projectionNumbers.oneDegreeScaleFactor) + projectionNumbers.xCenterDouble
        return [x, y]
    }
    
    static func computeMercatorNumbers(_ latLon: LatLon, _ projectionNumbers: ProjectionNumbers) -> [Double] {
        computeMercatorNumbers(latLon.lat, latLon.lon, projectionNumbers)
    }

    static func computeMercatorNumbers(_ ec: ExternalGlobalCoordinates, _ projectionNumbers: ProjectionNumbers) -> [Double] {
        computeMercatorNumbers(ec.getLatitude(), ec.getLongitude() * -1.0, projectionNumbers)
    }
}
