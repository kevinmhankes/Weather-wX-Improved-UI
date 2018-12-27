/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

class WXGLNexradLevel3Common {

    // FIXME this should be used in storm tracks ( used in wind barb already )
    static func drawLine(_ startEc: ExternalGlobalCoordinates, _ ecc: ExternalGeodeticCalculator,
                         _ pn: ProjectionNumbers, _ start: ExternalGlobalCoordinates, _ startBearing: Double,
                         _ distance: Double, _ bearing: [Double]) -> [Double] {
        var list = [Double]()
        let start = ExternalGlobalCoordinates(startEc)
        let startCoords = UtilityCanvasProjection.computeMercatorNumbers(startEc, pn)
        list += [startCoords.0, startCoords.1]
        let ec = ecc.calculateEndingGlobalCoordinates(ExternalEllipsoid.WGS84, start, startBearing, distance, bearing)
        let tmpCoords = UtilityCanvasProjection.computeMercatorNumbers(ec, pn)
        list += [tmpCoords.0, tmpCoords.1]
        return list
    }

    static func drawLine(_ startPoint: (Double, Double), _  ecc: ExternalGeodeticCalculator,
                         _ pn: ProjectionNumbers, _ start: ExternalGlobalCoordinates,
                         _ startBearing: Double, _ distance: Double, _ bearing: [Double]) -> [Double] {
        var list = [Double]()
        list.append(startPoint.0)
        list.append(startPoint.1)
        let ec = ecc.calculateEndingGlobalCoordinates(ExternalEllipsoid.WGS84, start, startBearing, distance, bearing)
        let tmpCoords = UtilityCanvasProjection.computeMercatorNumbers(ec, pn)
        list.append(tmpCoords.0)
        list.append(tmpCoords.1)
        return list
    }
}
