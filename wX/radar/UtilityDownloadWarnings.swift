/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

public class UtilityDownloadWarnings {

    static var timer = DownloadTimer("WARNINGS")

    static func get() {
        if !PolygonType.TST.display {
            UtilityDownloadRadar.clearPolygonVtec()
        }
        if timer.isRefreshNeeded() {
            if PolygonType.TST.display {
                UtilityDownloadRadar.getPolygonVtec()
            } else {
                UtilityDownloadRadar.clearPolygonVtec()
            }
            ObjectPolygonWarning.polygonList.forEach {
                let polygonType = ObjectPolygonWarning.polygonDataByType[$0]!
                if polygonType.isEnabled {
                    UtilityDownloadRadar.getPolygonVtecByType(polygonType)
                } else {
                    UtilityDownloadRadar.getPolygonVtecByTypeClear(polygonType)
                }
            }
        }
    }
}
