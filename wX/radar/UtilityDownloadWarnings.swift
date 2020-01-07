/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

public class UtilityDownloadWarnings {

    static var initialized = false
    static var currentTime: CLong = 0
    static var currentTimeSeconds: CLong = 0
    static var refreshIntervalSeconds: CLong = 0
    static var lastRefresh: CLong = 0
    static var refreshDataInMinutes = RadarPreferences.radarDataRefreshInterval

    static func get() {
        currentTime = UtilityTime.currentTimeMillis()
        currentTimeSeconds = currentTime / 1000
        refreshIntervalSeconds = refreshDataInMinutes * 60
        if !PolygonType.TST.display {
            UtilityDownloadRadar.clearPolygonVtec()
        }
        if (currentTimeSeconds > (lastRefresh + refreshIntervalSeconds)) || !initialized {
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
            initialized = true
            let currentTime: CLong = UtilityTime.currentTimeMillis()
            lastRefresh = currentTime / 1000
        }
    }
}
