/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

class WXGLNexradLevel3Common {

    // FIXME this should be used in storm tracks ( used in wind barb already )
    static func drawLine(
        _ startEc: ExternalGlobalCoordinates,
        _ ecc: ExternalGeodeticCalculator,
        _ pn: ProjectionNumbers,
        _ start: ExternalGlobalCoordinates,
        _ startBearing: Double,
        _ distance: Double,
        _ bearing: [Double]
    ) -> [Double] {
        let start = ExternalGlobalCoordinates(startEc)
        let startCoords = UtilityCanvasProjection.computeMercatorNumbers(startEc, pn)
        var list = [startCoords.lat, startCoords.lon]
        let ec = ecc.calculateEndingGlobalCoordinates(ExternalEllipsoid.WGS84, start, startBearing, distance, bearing)
        let tmpCoords = UtilityCanvasProjection.computeMercatorNumbers(ec, pn)
        list += [tmpCoords.lat, tmpCoords.lon]
        return list
    }

    static func drawLine(
        _ startPoint: (lat: Double, lon: Double),
        _  ecc: ExternalGeodeticCalculator,
        _ pn: ProjectionNumbers,
        _ start: ExternalGlobalCoordinates,
        _ startBearing: Double,
        _ distance: Double,
        _ bearing: [Double]
    ) -> [Double] {
        var list = [startPoint.lat, startPoint.lon]
        let ec = ecc.calculateEndingGlobalCoordinates(ExternalEllipsoid.WGS84, start, startBearing, distance, bearing)
        let tmpCoords = UtilityCanvasProjection.computeMercatorNumbers(ec, pn)
        list += [tmpCoords.lat, tmpCoords.lon]
        return list
    }
}
