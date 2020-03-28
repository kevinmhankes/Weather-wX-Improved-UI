/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

class WXGLNexradLevel3StormInfo {

    private static let stiPattern1 = "AZ/RAN(.*?)V"
    private static let stiPattern2 = "MVT(.*?)V"

    static func decode(_ pn: ProjectionNumbers, _ fileName: String) -> [Double] {
        var stormList = [Double]()
        WXGLDownload.getNidsTab("STI", pn.radarSite.lowercased(), fileName)
        let dis = UtilityIO.readFiletoData(fileName)
        if let retStr1 = String(data: dis, encoding: .ascii) {
            let position = retStr1.parseColumn(stiPattern1)
            let motion = retStr1.parseColumn(stiPattern2)
            var posnStr = ""
            position.forEach {
                posnStr += $0.replace("/", " ")
            }
            var motionStr = ""
            motion.forEach {
                motionStr += $0.replace("/", " ")
            }
            motionStr = motionStr.replace("NEW", "  0  0  ")
            let reg = "(\\d+) "
            let posnNumbers = posnStr.parseColumnAll(reg)
            let motNumbers = motionStr.parseColumnAll(reg)
            let bearing = [Double]()
            //var endPoint = [Double]()
            //var ecArr = [ExternalGlobalCoordinates]()
            //var tmpCoordsArr = [LatLon]()
            let sti15IncrLen = 0.40
            let degreeShift = 180
            let arrowLength = 2.0
            let arrowBend = 20.0
            if (posnNumbers.count == motNumbers.count) && posnNumbers.count > 1 {
                stride(from: 0, to: posnNumbers.count - 2, by: 2).forEach { index in
                    let ecc = ExternalGeodeticCalculator()
                    let degree = Int(posnNumbers[index]) ?? 0
                    let nm = Int(posnNumbers[index + 1]) ?? 0
                    let degree2 = Double(motNumbers[index]) ?? 0.0
                    let nm2 = Int(motNumbers[index + 1]) ?? 0
                    var start = ExternalGlobalCoordinates(pn, lonNegativeOne: true)
                    var ec = ecc.calculateEndingGlobalCoordinates(
                        ExternalEllipsoid.WGS84,
                        start,
                        Double(degree),
                        Double(nm) * 1852.0,
                        bearing
                    )
                    stormList += UtilityCanvasProjection.computeMercatorNumbers(ec, pn)
                    start = ExternalGlobalCoordinates(ec)
                    ec = ecc.calculateEndingGlobalCoordinates(
                        ExternalEllipsoid.WGS84,
                        start,
                        Double(degree2) + Double(degreeShift),
                        Double(nm2) * 1852.0,
                        bearing
                    )
                    let tmpCoords = UtilityCanvasProjection.computeMercatorNumbers(ec, pn)
                    stormList += tmpCoords
                    var ecArr = [ExternalGlobalCoordinates]()
                    var tmpCoordsArr = [LatLon]()
                    (0...3).forEach { z in
                        ecArr.append(
                            ecc.calculateEndingGlobalCoordinates(
                                ExternalEllipsoid.WGS84,
                                start,
                                Double(degree2) + Double(degreeShift),
                                Double(nm2) * 1852.0 * Double(z) * 0.25,
                                bearing
                            )
                        )
                        tmpCoordsArr.append(LatLon(UtilityCanvasProjection.computeMercatorNumbers(ecArr[z], pn)))
                    }
                    let endPoint = tmpCoords
                    if nm2 > 0 {
                        start = ExternalGlobalCoordinates(ec)
                        stormList += WXGLNexradLevel3Common.drawLine(
                            endPoint,
                            ecc,
                            pn,
                            start,
                            degree2 + arrowBend,
                            arrowLength * 1852.0,
                            bearing
                        )
                        stormList += WXGLNexradLevel3Common.drawLine(
                            endPoint,
                            ecc,
                            pn,
                            start,
                            degree2 - arrowBend,
                            arrowLength * 1852.0,
                            bearing
                        )
                        // 15,30,45 min ticks
                        let stormTrackTickMarkAngleOff90 = 30.0
                        (0...3).forEach { index in
                            // first line
                            stormList += drawTickMarks(
                                tmpCoordsArr[index],
                                ecc,
                                pn,
                                ecArr[index],
                                degree2 - (90.0 + stormTrackTickMarkAngleOff90),
                                arrowLength * 1852.0 * sti15IncrLen,
                                bearing
                            )
                            stormList += drawTickMarks(
                                tmpCoordsArr[index],
                                ecc,
                                pn,
                                ecArr[index],
                                degree2 + (90.0 - stormTrackTickMarkAngleOff90),
                                arrowLength * 1852.0 * sti15IncrLen,
                                bearing
                            )
                            // 2nd line
                            stormList += drawTickMarks(
                                tmpCoordsArr[index],
                                ecc,
                                pn,
                                ecArr[index],
                                degree2 - (90.0 - stormTrackTickMarkAngleOff90),
                                arrowLength * 1852.0 * sti15IncrLen,
                                bearing
                            )
                            stormList += drawTickMarks(
                                tmpCoordsArr[index],
                                ecc,
                                pn,
                                ecArr[index],
                                degree2 + (90.0 + stormTrackTickMarkAngleOff90),
                                arrowLength * 1852.0 * sti15IncrLen,
                                bearing
                            )
                        }
                    }
                }
            }
            return stormList
        } else {
            return [Double]()
        }
    }

    private static func drawTickMarks(
        _ startPoint: LatLon,
        _ ecc: ExternalGeodeticCalculator,
        _ pn: ProjectionNumbers,
        _ ecArr: ExternalGlobalCoordinates,
        _ startBearing: Double,
        _ distance: Double,
        _ bearing: [Double]
        ) -> [Double] {
        var list = startPoint.list
        let start = ExternalGlobalCoordinates(ecArr)
        let ec = ecc.calculateEndingGlobalCoordinates(ExternalEllipsoid.WGS84, start, startBearing, distance, bearing)
        list += UtilityCanvasProjection.computeMercatorNumbers(ec, pn)
        return list
    }
}
