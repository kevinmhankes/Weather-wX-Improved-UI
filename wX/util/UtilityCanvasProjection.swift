/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class UtilityCanvasProjection {

    static func compute4326Numbers(_ lat: Double, _ lon: Double, _ centerX: Double,
                                   _ centerY: Double, _ xImageCenterPixels: Double,
                                   _ yImageCenterPixels: Double, _ scaleFactor: Double ) -> (Double, Double) {
        return ((-((lon - centerY) * scaleFactor) + xImageCenterPixels), (-((lat - centerX) *  scaleFactor) + yImageCenterPixels))
    }

    static func compute4326Numbers(_ pn: ProjectionNumbers) -> (Double, Double) {
        return ((-((pn.yDbl - pn.yCenterDouble) * pn.scale) + pn.xCenterDouble), (-((pn.xDbl - pn.xCenterDouble) *  pn.scale) + pn.yCenterDouble))
    }

    static func compute4326Numbers(_ location: LatLon, _ pn: ProjectionNumbers) -> (Double, Double) {
        return compute4326Numbers(pn)
    }

    static func computeMercatorNumbers(_ lat: Double, _ lon: Double, _ pn: ProjectionNumbers) -> (Double, Double) {
        let test1 = (180.0 / Double.pi * log(tan(Double.pi / 4 + lat * (Double.pi / 180) / 2)))
        let test2 = (180.0 / Double.pi * log(tan(Double.pi / 4 + pn.xDbl * (Double.pi / 180) / 2)))
        let pixYD = -((test1 - test2) *  pn.oneDegreeScaleFactor) + pn.yCenterDouble
        let pixXD = -((lon - pn.yDbl) * pn.oneDegreeScaleFactor) + pn.xCenterDouble
        return (pixXD, pixYD)
    }

    static func computeMercatorNumbers(_ ec: ExternalGlobalCoordinates, _ pn: ProjectionNumbers) -> (Double, Double) {
        return computeMercatorNumbers(ec.getLatitude(), ec.getLongitude() * -1.0, pn)
    }

    static func computeMercatorNumbers(_ location: LatLon, _ pn: ProjectionNumbers, multLonNegativeOne: Bool = true) -> (Double, Double) {
        if multLonNegativeOne {
            return computeMercatorNumbers(location.lat, location.lon * -1.0, pn)
        } else {
            return computeMercatorNumbers(location.lat, location.lon, pn)
        }
    }

    static func isMercator(_ provider: ProjectionType) -> Bool {
        return !(provider == .nwsMosaic || provider == .nwsMosaicSector)
    }

    static func needDarkPaint(_ provider: ProjectionType) -> Bool {return false}
}
