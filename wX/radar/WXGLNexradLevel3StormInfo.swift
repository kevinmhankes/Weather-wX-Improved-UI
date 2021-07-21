/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class WXGLNexradLevel3StormInfo {
    
    static func decode(_ projectionNumbers: ProjectionNumbers, _ fileStorage: FileStorage) {
        let productCode = "STI"
        WXGLDownload.getNidsTab(productCode, projectionNumbers.radarSite.lowercased(), fileStorage)
        let retStr1 = fileStorage.level3TextProductMap[productCode] ?? ""
        var stormList = [Double]()
        if retStr1.count > 10 {
            let position = retStr1.parseColumn("AZ/RAN(.*?)V")
            let motion = retStr1.parseColumn("MVT(.*?)V")
            var posnStr = ""
            position.forEach { posnStr += $0.replace("/", " ") }
            var motionStr = ""
            motion.forEach { motionStr += $0.replace("/", " ") }
            motionStr = motionStr.replace("NEW", "  0  0  ")
            let reg = "(\\d+) "
            let posnNumbers = posnStr.parseColumnAll(reg)
            let motNumbers = motionStr.parseColumnAll(reg)
            let sti15IncrLen = 0.40
            let degreeShift = 180
            let arrowLength = 2.0
            let arrowBend = 20.0
            if (posnNumbers.count == motNumbers.count) && posnNumbers.count > 1 {
                stride(from: 0, to: posnNumbers.count - 2, by: 2).forEach { index in
                    let ecc = ExternalGeodeticCalculator()
                    let degree = to.Int(posnNumbers[index])
                    let nm = to.Int(posnNumbers[index + 1])
                    let degree2 = to.Double(motNumbers[index])
                    let nm2 = to.Int(motNumbers[index + 1])
                    var start = ExternalGlobalCoordinates(projectionNumbers, lonNegativeOne: true)
                    var ec = ecc.calculateEndingGlobalCoordinates(start, Double(degree), Double(nm) * 1852.0)
                    stormList += UtilityCanvasProjection.computeMercatorNumbers(ec, projectionNumbers)
                    start = ExternalGlobalCoordinates(ec)
                    ec = ecc.calculateEndingGlobalCoordinates(start, Double(degree2) + Double(degreeShift), Double(nm2) * 1852.0)
                    let tmpCoords = UtilityCanvasProjection.computeMercatorNumbers(ec, projectionNumbers)
                    stormList += tmpCoords
                    var ecArr = [ExternalGlobalCoordinates]()
                    var latLons = [LatLon]()
                    (0...3).forEach { z in
                        ecArr.append(
                            ecc.calculateEndingGlobalCoordinates(start, Double(degree2) + Double(degreeShift), Double(nm2) * 1852.0 * Double(z) * 0.25)
                        )
                        latLons.append(LatLon(UtilityCanvasProjection.computeMercatorNumbers(ecArr[z], projectionNumbers)))
                    }
                    let endPoint = tmpCoords
                    if nm2 > 0 {
                        start = ExternalGlobalCoordinates(ec)
                        [degree2 + arrowBend, degree2 - arrowBend].forEach {
                            stormList += WXGLNexradLevel3Common.drawLine(endPoint, ecc, projectionNumbers, start, $0, arrowLength * 1852.0)
                        }
                        // 15,30,45 min ticks
                        let stormTrackTickMarkAngleOff90 = 30.0
                        (0...3).forEach { index in
                            [
                                degree2 - (90.0 + stormTrackTickMarkAngleOff90),
                                degree2 + (90.0 - stormTrackTickMarkAngleOff90),
                                degree2 - (90.0 - stormTrackTickMarkAngleOff90),
                                degree2 + (90.0 + stormTrackTickMarkAngleOff90)
                                ].forEach {
                                    stormList += drawTickMarks(latLons[index], ecc, projectionNumbers, ecArr[index], $0, arrowLength * 1852.0 * sti15IncrLen)
                            }
                        }
                    }
                }
            }
        }
        fileStorage.stiList = stormList
    }
    
    private static func drawTickMarks(
        _ startPoint: LatLon,
        _ ecc: ExternalGeodeticCalculator,
        _ projectionNumbers: ProjectionNumbers,
        _ ecArr: ExternalGlobalCoordinates,
        _ startBearing: Double,
        _ distance: Double
    ) -> [Double] {
        var list = startPoint.list
        let start = ExternalGlobalCoordinates(ecArr)
        let ec = ecc.calculateEndingGlobalCoordinates(start, startBearing, distance)
        list += UtilityCanvasProjection.computeMercatorNumbers(ec, projectionNumbers)
        return list
    }
}
