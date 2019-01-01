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
            UtilityDownloadRadar.clearPolygonVTEC()
        }
        if !PolygonType.MPD.display {
            UtilityDownloadRadar.clearMPD()
        }
        if !PolygonType.MCD.display {
            UtilityDownloadRadar.clearMCD()
            UtilityDownloadRadar.clearWAT()
        }
        if (currentTimeSec > (lastRefresh + refreshIntervalSec)) || !initialized {
            if PolygonType.TST.display {
                UtilityDownloadRadar.getPolygonVTEC()
            } else {
                UtilityDownloadRadar.clearPolygonVTEC()
            }
            if PolygonType.MPD.display {
                UtilityDownloadRadar.getMPD()
            } else {
                UtilityDownloadRadar.clearMPD()
            }
            if PolygonType.MCD.display {
                UtilityDownloadRadar.getMCD()
                UtilityDownloadRadar.getWAT()
            } else {
                UtilityDownloadRadar.clearMCD()
                UtilityDownloadRadar.clearWAT()
            }
            initialized = true
            let currentTime: CLong = UtilityTime.currentTimeMillis()
            lastRefresh = currentTime / 1000
        }
    }
}
