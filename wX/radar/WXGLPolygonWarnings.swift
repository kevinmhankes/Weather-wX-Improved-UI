/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class WXGLPolygonWarnings {

    static let pVtec="([A-Z0]{1}\\.[A-Z]{3}\\.[A-Z]{4}\\.[A-Z]{2}\\.[A-Z]\\.[0-9]{4}\\.[0-9]{6}T[0-9]{4}Z\\-[0-9]{6}T[0-9]{4}Z)"

    static func addWarnings(_ pn: ProjectionNumbers, _ type: PolygonType) -> [Double] {
        var warningList = [Double]()
        var prefToken = MyApplication.severeDashboardFfw.value
        if type.string == "TOR" {
            prefToken = MyApplication.severeDashboardTor.value
        } else if type.string == "TST" {
            prefToken = MyApplication.severeDashboardTst.value
        }
        var x = [Double]()
        var y = [Double]()
        var pixXInit = 0.0
        var pixYInit = 0.0
        let warningHTML = prefToken.replace("\n", "").replace(" ", "")
        let polygonArr = warningHTML.parseColumn("\"coordinates\":\\[\\[(.*?)\\]\\]\\}")
        let vtecAl = warningHTML.parseColumn(pVtec)
        var polyCount = -1
        polygonArr.forEach { poly in
            polyCount += 1
            if vtecAl.count > polyCount
                && !vtecAl[polyCount].hasPrefix("0.EXP")
                && !vtecAl[polyCount].hasPrefix("0.CAN") {
                let polyTmp = poly.replace("[", "").replace("]", "").replace(",", " ").replace("-", "").split(" ")
                if polyTmp.count > 1 {
                    y = polyTmp.enumerated().filter {idx, _ in idx & 1 == 0}.map {_, value in Double(value) ?? 0.0}
                    x = polyTmp.enumerated().filter {idx, _ in idx & 1 != 0}.map {_, value in Double(value) ?? 0.0}
                }
                if y.count > 0 && x.count > 0 {
                    let tmpCoords = UtilityCanvasProjection.computeMercatorNumbers(x[0], y[0], pn)
                    pixXInit = tmpCoords.0
                    pixYInit = tmpCoords.1
                    warningList.append(tmpCoords.0)
                    warningList.append(tmpCoords.1)
                    if x.count == y.count {
                        (1..<x.count).forEach {
                            let tmpCoords = UtilityCanvasProjection.computeMercatorNumbers(x[$0], y[$0], pn)
                            warningList.append(tmpCoords.0)
                            warningList.append(tmpCoords.1)
                            warningList.append(tmpCoords.0)
                            warningList.append(tmpCoords.1)
                        }
                        warningList.append(pixXInit)
                        warningList.append(pixYInit)
                    }
                }
            }
        }
        return warningList
    }
}
