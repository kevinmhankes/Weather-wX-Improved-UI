/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

public class UtilityDownloadMcd {

    static var initialized = false
    static var currentTime: CLong = 0
    static var currentTimeSeconds: CLong = 0
    static var refreshIntervalSeconds: CLong = 0
    static var lastRefresh: CLong = 0
    static var refreshDataInMinutes = max(RadarPreferences.radarDataRefreshInterval, 6)

    static func get() {
        currentTime = UtilityTime.currentTimeMillis()
        currentTimeSeconds = currentTime / 1000
        refreshIntervalSeconds = refreshDataInMinutes * 60
        if !PolygonType.MCD.display {
            UtilityDownloadRadar.clearMcd()
        }
        if (currentTimeSeconds > (lastRefresh + refreshIntervalSeconds)) || !initialized {
            if PolygonType.MCD.display {
                UtilityDownloadRadar.getMcd()
            } else {
                UtilityDownloadRadar.clearMcd()
            }
            initialized = true
            let currentTime: CLong = UtilityTime.currentTimeMillis()
            lastRefresh = currentTime / 1000
        }
    }
}
