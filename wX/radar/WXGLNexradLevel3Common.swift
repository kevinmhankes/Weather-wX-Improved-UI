/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

class WXGLNexradLevel3Common {

    static func drawLine(
        _ startEc: ExternalGlobalCoordinates,
        _ ecc: ExternalGeodeticCalculator,
        _ projectionNumbers: ProjectionNumbers,
        _ start: ExternalGlobalCoordinates,
        _ startBearing: Double,
        _ distance: Double,
        _ bearing: [Double]
    ) -> [Double] {
        let start = ExternalGlobalCoordinates(startEc)
        let startCoords = UtilityCanvasProjection.computeMercatorNumbers(startEc, projectionNumbers)
        var list = startCoords
        let ec = ecc.calculateEndingGlobalCoordinates(ExternalEllipsoid.WGS84, start, startBearing, distance, bearing)
        list += UtilityCanvasProjection.computeMercatorNumbers(ec, projectionNumbers)
        return list
    }

    static func drawLine(
        _ startPoint: [Double],
        _ ecc: ExternalGeodeticCalculator,
        _ projectionNumbers: ProjectionNumbers,
        _ start: ExternalGlobalCoordinates,
        _ startBearing: Double,
        _ distance: Double,
        _ bearing: [Double]
    ) -> [Double] {
        var list = startPoint
        let ec = ecc.calculateEndingGlobalCoordinates(ExternalEllipsoid.WGS84, start, startBearing, distance, bearing)
        list += UtilityCanvasProjection.computeMercatorNumbers(ec, projectionNumbers)
        return list
    }
}
