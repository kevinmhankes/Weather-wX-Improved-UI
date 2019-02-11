/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

public class UtilityPolygons {

    static var initialized = false
    static var currentTime: CLong = 0
    static var currentTimeSec: CLong = 0
    static var refreshIntervalSec: CLong = 0
    static var lastRefresh: CLong = 0
    static var refreshLocMin = RadarPreferences.radarDataRefreshInterval

    static func getData() {
        currentTime = UtilityTime.currentTimeMillis()
        currentTimeSec = currentTime / 1000
        refreshIntervalSec = refreshLocMin * 60
        if !PolygonType.TST.display {
            UtilityDownloadRadar.clearPolygonVtec()
        }
        if !PolygonType.MPD.display {
            UtilityDownloadRadar.clearMpd()
        }
        if !PolygonType.MCD.display {
            UtilityDownloadRadar.clearMcd()
            UtilityDownloadRadar.clearWatch()
        }
        if (currentTimeSec > (lastRefresh + refreshIntervalSec)) || !initialized {
            if PolygonType.TST.display {
                UtilityDownloadRadar.getPolygonVtec()
            } else {
                UtilityDownloadRadar.clearPolygonVtec()
            }
            if PolygonType.MPD.display {
                UtilityDownloadRadar.getMpd()
            } else {
                UtilityDownloadRadar.clearMpd()
            }
            if PolygonType.MCD.display {
                UtilityDownloadRadar.getMcd()
                UtilityDownloadRadar.getWatch()
            } else {
                UtilityDownloadRadar.clearMcd()
                UtilityDownloadRadar.clearWatch()
            }
            initialized = true
            let currentTime: CLong = UtilityTime.currentTimeMillis()
            lastRefresh = currentTime / 1000
        }
    }
}
