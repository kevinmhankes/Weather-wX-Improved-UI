/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

public class UtilityDownloadMpd {

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
        if !PolygonType.MPD.display {
            UtilityDownloadRadar.clearMpd()
        }
        if (currentTimeSeconds > (lastRefresh + refreshIntervalSeconds)) || !initialized {
            if PolygonType.MPD.display {
                UtilityDownloadRadar.getMpd()
            } else {
                UtilityDownloadRadar.clearMpd()
            }
            initialized = true
            let currentTime: CLong = UtilityTime.currentTimeMillis()
            lastRefresh = currentTime / 1000
        }
    }
}
