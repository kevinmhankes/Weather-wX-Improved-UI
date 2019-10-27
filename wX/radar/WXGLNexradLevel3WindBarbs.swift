/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

class WXGLNexradLevel3WindBarbs {

    static func decocodeAndPlot(_ pn: ProjectionNumbers, isGust: Bool) -> [Double] {
        var stormList = [Double]()
        var arrWb = [String]()
        if !isGust {
            arrWb = UtilityMetar.obsArrWb
            //print(arrWb)
        } else {
            arrWb = UtilityMetar.obsArrWbGust
            //print(arrWb)
        }
        var degree = 0.0
        var nm = 0.0
        var degree2 = 0.0
        let bearing = [Double]()
        var start = ExternalGlobalCoordinates(pn)
        var end = ExternalGlobalCoordinates(pn)
        var ec = ExternalGlobalCoordinates(pn)
        var tmpCoords = (lat: 0.0, lon: 0.0)
        let degreeShift = 180.00
        let arrowLength = 2.5
        let arrowSpacing = 3.0
        let barbLengthScaleFactor = 0.4
        let arrowBend = 60.0
        let nmScaleFactor = -1852.0
        var startLength = 0.0
        let barbLength = 15.0
        let barbOffset = 0.0
        var above50 = false
        arrWb.forEach { windBarb in
            let ecc = ExternalGeodeticCalculator()
            let metarArr = windBarb.split(":")
            var angle = 0
            var length = 0
            var locXDbl = 0.0
            var locYDbl = 0.0
            if metarArr.count > 3 {
                locXDbl = Double(metarArr[0]) ?? 0.0
                locYDbl = Double(metarArr[1]) ?? 0.0
                angle = Int(metarArr[2]) ?? 0
                length = Int(metarArr[3]) ?? 0
            }
            if length > 4 {
                degree = 0.0
                nm = 0.0
                degree2 = Double(angle)
                startLength = nm * nmScaleFactor
                start =  ExternalGlobalCoordinates(locXDbl, locYDbl)
                ec =  ecc.calculateEndingGlobalCoordinates(
                    ExternalEllipsoid.WGS84,
                    start,
                    degree,
                    nm * nmScaleFactor * barbLengthScaleFactor,
                    bearing
                )
                tmpCoords = UtilityCanvasProjection.computeMercatorNumbers(ec, pn)
                stormList += [tmpCoords.lat, tmpCoords.lon]
                start = ExternalGlobalCoordinates(ec)
                ec = ecc.calculateEndingGlobalCoordinates(
                    ExternalEllipsoid.WGS84,
                    start,
                    degree2 + degreeShift,
                    barbLength * nmScaleFactor * barbLengthScaleFactor,
                    bearing
                )
                end = ExternalGlobalCoordinates(ec)
                tmpCoords = UtilityCanvasProjection.computeMercatorNumbers(ec, pn)
                stormList += [tmpCoords.0, tmpCoords.1]
                var barbCount = Int(length / 10)
                var halfBarb = false
                var oneHalfBarb = false
                if ((length - barbCount * 10) > 4 && length > 10) || (length > 4 && length < 10) {
                    halfBarb = true
                }
                if length > 4 && length < 10 {
                    oneHalfBarb = true
                }
                if length > 49 {
                    above50 = true
                    barbCount -= 4
                } else {
                    above50 = false
                }
                var index = 0
                if above50 {
                    // initial angled line
                    ec = ecc.calculateEndingGlobalCoordinates(
                        ExternalEllipsoid.WGS84,
                        end,
                        degree2,
                        barbOffset + startLength + Double(index) * arrowSpacing
                            * nmScaleFactor * barbLengthScaleFactor,
                        bearing
                    )
                    stormList += WXGLNexradLevel3Common.drawLine(
                        ec,
                        ecc,
                        pn,
                        start,
                        degree2 - arrowBend * 2.0,
                        startLength + arrowLength * nmScaleFactor,
                        bearing
                    )
                    // perpendicular line from main barb
                    ec = ecc.calculateEndingGlobalCoordinates(
                        ExternalEllipsoid.WGS84,
                        end,
                        degree2,
                        barbOffset + startLength + -1.0 * arrowSpacing
                            * nmScaleFactor * barbLengthScaleFactor,
                        bearing
                    )
                    stormList += WXGLNexradLevel3Common.drawLine(
                        ec,
                        ecc,
                        pn,
                        start,
                        degree2 - 90.0,
                        startLength + 0.80 * arrowLength * nmScaleFactor,
                        bearing
                    )
                    // connecting line parallel to main barb
                    ec = ecc.calculateEndingGlobalCoordinates(
                        ExternalEllipsoid.WGS84,
                        end,
                        degree2,
                        barbOffset + startLength
                            + Double(index) * arrowSpacing
                            * nmScaleFactor * barbLengthScaleFactor,
                        bearing
                    )
                    stormList += WXGLNexradLevel3Common.drawLine(
                        ec,
                        ecc,
                        pn,
                        start,
                        degree2 - 180.0,
                        startLength + 0.5 * arrowLength * nmScaleFactor,
                        bearing
                    )
                    index += 1
                }
                (index..<barbCount).forEach { _ in
                    ec = ecc.calculateEndingGlobalCoordinates(
                        ExternalEllipsoid.WGS84,
                        end,
                        degree2,
                        barbOffset + startLength
                            + Double(index) * arrowSpacing
                            * nmScaleFactor * barbLengthScaleFactor,
                        bearing
                    )
                    stormList += WXGLNexradLevel3Common.drawLine(ec,
                                          ecc,
                                          pn,
                                          start,
                                          degree2 - arrowBend * 2.0,
                                          startLength + arrowLength * nmScaleFactor,
                                          bearing)
                    index += 1
                }
                var halfBarbOffsetFudge = 0.0
                if oneHalfBarb {halfBarbOffsetFudge = nmScaleFactor * 1.0}
                if halfBarb {
                    ec = ecc.calculateEndingGlobalCoordinates(
                        ExternalEllipsoid.WGS84,
                        end,
                        degree2,
                        barbOffset + halfBarbOffsetFudge + startLength
                            + Double(index) * arrowSpacing
                            * nmScaleFactor * barbLengthScaleFactor,
                        bearing
                    )
                    stormList += WXGLNexradLevel3Common.drawLine(
                        ec,
                        ecc,
                        pn,
                        start,
                        degree2 - arrowBend * 2.0,
                        startLength + arrowLength / 2.0 * nmScaleFactor,
                        bearing
                    )
                }
            }
        }
        return stormList
    }
}
