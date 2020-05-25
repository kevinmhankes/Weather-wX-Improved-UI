/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class WXGLNexradLevel3Common {

    static func drawLine(
        _ startEc: ExternalGlobalCoordinates,
        _ ecc: ExternalGeodeticCalculator,
        _ projectionNumbers: ProjectionNumbers,
        _ startBearing: Double,
        _ distance: Double
    ) -> [Double] {
        let start = ExternalGlobalCoordinates(startEc)
        let startCoords = UtilityCanvasProjection.computeMercatorNumbers(startEc, projectionNumbers)
        let ec = ecc.calculateEndingGlobalCoordinates(start, startBearing, distance)
        return startCoords + UtilityCanvasProjection.computeMercatorNumbers(ec, projectionNumbers)
    }

    static func drawLine(
        _ startPoint: [Double],
        _ ecc: ExternalGeodeticCalculator,
        _ projectionNumbers: ProjectionNumbers,
        _ start: ExternalGlobalCoordinates,
        _ startBearing: Double,
        _ distance: Double
    ) -> [Double] {
        let ec = ecc.calculateEndingGlobalCoordinates(start, startBearing, distance)
        return startPoint + UtilityCanvasProjection.computeMercatorNumbers(ec, projectionNumbers)
    }
}
