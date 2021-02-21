/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class WXGLNexradLevel3WindBarbs {

    static func decodeAndPlot(_ projectionNumbers: ProjectionNumbers, isGust: Bool) -> [Double] {
        var stormList = [Double]()
        let arrWb = !isGust ? UtilityMetar.obsArrWb : UtilityMetar.obsArrWbGust
        let degreeShift = 180.00
        let arrowLength = 2.5
        let arrowSpacing = 3.0
        let barbLengthScaleFactor = 0.4
        let arrowBend = 60.0
        let nmScaleFactor = -1852.0
        let barbLength = 15.0
        let barbOffset = 0.0
        arrWb.forEach { windBarb in
            let ecc = ExternalGeodeticCalculator()
            let metarArr = windBarb.split(":")
            var angle = 0
            var length = 0
            var locXDbl = 0.0
            var locYDbl = 0.0
            var above50 = false
            if metarArr.count > 3 {
                locXDbl = Double(metarArr[0]) ?? 0.0
                locYDbl = Double(metarArr[1]) ?? 0.0
                angle = Int(metarArr[2]) ?? 0
                length = Int(metarArr[3]) ?? 0
            }
            if length > 4 {
                let degree = 0.0
                let nm = 0.0
                let degree2 = Double(angle)
                let startLength = nm * nmScaleFactor
                var start =  ExternalGlobalCoordinates(locXDbl, locYDbl)
                var ec =  ecc.calculateEndingGlobalCoordinates(start, degree, nm * nmScaleFactor * barbLengthScaleFactor)
                stormList += UtilityCanvasProjection.computeMercatorNumbers(ec, projectionNumbers)
                start = ExternalGlobalCoordinates(ec)
                ec = ecc.calculateEndingGlobalCoordinates(start, degree2 + degreeShift, barbLength * nmScaleFactor * barbLengthScaleFactor)
                let end = ExternalGlobalCoordinates(ec)
                stormList += UtilityCanvasProjection.computeMercatorNumbers(ec, projectionNumbers)
                var barbCount = Int(length / 10)
                var halfBarb = false
                var oneHalfBarb = false
                if ((length - barbCount * 10) > 4 && length > 10) || (length > 4 && length < 10) { halfBarb = true }
                if length > 4 && length < 10 { oneHalfBarb = true }
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
                        end,
                        degree2,
                        barbOffset + startLength + Double(index) * arrowSpacing * nmScaleFactor * barbLengthScaleFactor
                    )
                    stormList += WXGLNexradLevel3Common.drawLine(ec, ecc, projectionNumbers, degree2 - arrowBend * 2.0, startLength + arrowLength * nmScaleFactor)
                    // perpendicular line from main barb
                    ec = ecc.calculateEndingGlobalCoordinates(
                        end,
                        degree2,
                        barbOffset + startLength + -1.0 * arrowSpacing * nmScaleFactor * barbLengthScaleFactor
                    )
                    stormList += WXGLNexradLevel3Common.drawLine(ec, ecc, projectionNumbers, degree2 - 90.0, startLength + 0.80 * arrowLength * nmScaleFactor)
                    // connecting line parallel to main barb
                    ec = ecc.calculateEndingGlobalCoordinates(
                        end,
                        degree2,
                        barbOffset + startLength + Double(index) * arrowSpacing * nmScaleFactor * barbLengthScaleFactor
                    )
                    stormList += WXGLNexradLevel3Common.drawLine(ec, ecc, projectionNumbers, degree2 - 180.0, startLength + 0.5 * arrowLength * nmScaleFactor)
                    index += 1
                }
                (index..<barbCount).forEach { _ in
                    ec = ecc.calculateEndingGlobalCoordinates(
                        end,
                        degree2,
                        barbOffset + startLength + Double(index) * arrowSpacing * nmScaleFactor * barbLengthScaleFactor
                    )
                    stormList += WXGLNexradLevel3Common.drawLine(ec, ecc, projectionNumbers, degree2 - arrowBend * 2.0, startLength + arrowLength * nmScaleFactor)
                    index += 1
                }
                var halfBarbOffsetFudge = 0.0
                if oneHalfBarb {halfBarbOffsetFudge = nmScaleFactor * 1.0}
                if halfBarb {
                    ec = ecc.calculateEndingGlobalCoordinates(
                        end,
                        degree2,
                        barbOffset + halfBarbOffsetFudge + startLength + Double(index) * arrowSpacing * nmScaleFactor * barbLengthScaleFactor
                    )
                    stormList += WXGLNexradLevel3Common.drawLine(ec, ecc, projectionNumbers, degree2 - arrowBend * 2.0, startLength + arrowLength / 2.0 * nmScaleFactor)
                }
            }
        }
        return stormList
    }
}
