/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class UtilityCanvasProjection {
    
    static func computeMercatorNumbers(
        _ lat: Double,
        _ lon: Double,
        _ pn: ProjectionNumbers
    ) -> [Double] {
        let test1 = (180.0 / Double.pi * log(tan(Double.pi / 4 + lat * (Double.pi / 180) / 2)))
        let test2 = (180.0 / Double.pi * log(tan(Double.pi / 4 + pn.xDbl * (Double.pi / 180) / 2)))
        let pixYD = -((test1 - test2) *  pn.oneDegreeScaleFactor) + pn.yCenterDouble
        let pixXD = -((lon - pn.yDbl) * pn.oneDegreeScaleFactor) + pn.xCenterDouble
        return [pixXD, pixYD]
    }
    
    static func computeMercatorNumbers(_ ec: ExternalGlobalCoordinates, _ pn: ProjectionNumbers) -> [Double] {
        return computeMercatorNumbers(ec.getLatitude(), ec.getLongitude() * -1.0, pn)
    }
}
