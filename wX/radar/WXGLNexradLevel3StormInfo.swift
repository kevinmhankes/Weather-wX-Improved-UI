/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

class WXGLNexradLevel3StormInfo {

    static let stiPattern1 = "AZ/RAN(.*?)V"
    static let stiPattern2 = "MVT(.*?)V"

    static func decocodeAndPlotNexradStormMotion(_ pn: ProjectionNumbers, _ fileName: String) -> [Double] {
        var stormList = [Double]()
        WXGLDownload.getNidsTab("STI", pn.radarSite.lowercased(), fileName)
        let dis = UtilityIO.readFiletoData(fileName)
        if let retStr1 = String(data: dis, encoding: .ascii) {
            let posn = retStr1.parseColumn(stiPattern1)
            let motion = retStr1.parseColumn(stiPattern2)
            var posnStr = ""
            var motionStr = ""
            posn.forEach {posnStr += $0.replace("/", " ")}
            motion.forEach {motionStr += $0.replace("/", " ")}
            motionStr = motionStr.replace("NEW", "  0  0  ")
            let reg = "(\\d+) "
            let posnNumbers = posnStr.parseColumnAll(reg)
            let motNumbers = motionStr.parseColumnAll(reg)
            var degree = 0
            var nm = 0
            var degree2 = 0.0
            var nm2 = 0
            let bearing = [Double]()
            var start = ExternalGlobalCoordinates(pn, lonNegativeOne: true)
            var ec = ExternalGlobalCoordinates(pn, lonNegativeOne: true)
            var tmpCoords = (0.0, 0.0)
            var endPoint = (0.0, 0.0)
            var ecArr = [ExternalGlobalCoordinates]()
            var tmpCoordsArr = [LatLon]()
            let sti15IncrLen = 0.40
            let degreeShift = 180
            let arrowLength = 2.0
            let arrowBend = 20.0
            if (posnNumbers.count == motNumbers.count) && posnNumbers.count > 1 {
                stride(from: 0, to: posnNumbers.count - 2, by: 2).forEach { index in
                    let ecc = ExternalGeodeticCalculator()
                    degree = Int(posnNumbers[index]) ?? 0
                    nm = Int(posnNumbers[index + 1]) ?? 0
                    degree2 = Double(motNumbers[index]) ?? 0.0
                    nm2 = Int(motNumbers[index + 1]) ?? 0
                    start = ExternalGlobalCoordinates(pn, lonNegativeOne: true)
                    ec = ecc.calculateEndingGlobalCoordinates(
                        ExternalEllipsoid.WGS84,
                        start,
                        Double(degree),
                        Double(nm) * 1852.0,
                        bearing
                    )
                    tmpCoords = UtilityCanvasProjection.computeMercatorNumbers(ec, pn)
                    stormList.append(tmpCoords.0)
                    stormList.append(tmpCoords.1)
                    start = ExternalGlobalCoordinates(ec)
                    ec = ecc.calculateEndingGlobalCoordinates(
                        ExternalEllipsoid.WGS84,
                        start,
                        Double(degree2) + Double(degreeShift),
                        Double(nm2) * 1852.0,
                        bearing
                    )
                    tmpCoords = UtilityCanvasProjection.computeMercatorNumbers(ec, pn)
                    stormList.append(tmpCoords.0)
                    stormList.append(tmpCoords.1)
                    ecArr = []
                    tmpCoordsArr = []
                    (0...3).forEach { index in
                        ecArr.append(
                            ecc.calculateEndingGlobalCoordinates(
                                ExternalEllipsoid.WGS84,
                                start,
                                Double(degree2) + Double(degreeShift),
                                Double(nm2) * 1852.0 * Double(index) * 0.25,
                                bearing
                            )
                        )
                        tmpCoordsArr.append(LatLon(UtilityCanvasProjection.computeMercatorNumbers(ecArr[index], pn)))
                    }
                    endPoint = tmpCoords
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

    static func drawTickMarks(
        _ startPoint: LatLon,
        _ ecc: ExternalGeodeticCalculator,
        _ pn: ProjectionNumbers,
        _ ecArr: ExternalGlobalCoordinates,
        _ startBearing: Double,
        _ distance: Double,
        _ bearing: [Double]
        ) -> [Double] {
        var list = [Double]()
        list.append(startPoint.lat)
        list.append(startPoint.lon)
        let start = ExternalGlobalCoordinates(ecArr)
        let ec = ecc.calculateEndingGlobalCoordinates(ExternalEllipsoid.WGS84, start, startBearing, distance, bearing)
        let tmpCoords = UtilityCanvasProjection.computeMercatorNumbers(ec, pn)
        list.append(tmpCoords.0)
        list.append(tmpCoords.1)
        return list
    }
}
