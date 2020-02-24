/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

class DownloadTimer {

    private var initialized = false
    private var lastRefresh: CLong = 0
    private var refreshDataInMinutes = max(RadarPreferences.radarDataRefreshInterval, 6)
    private var identifier: String

    init(_ identifier: String) {
        self.identifier = identifier
    }

    func isRefreshNeeded() -> Bool {
        refreshDataInMinutes = max(RadarPreferences.radarDataRefreshInterval, 6)
        if identifier == "WARNINGS" {
            refreshDataInMinutes = max(RadarPreferences.radarDataRefreshInterval, 3)
        }
        var refreshNeeded = false
        let currentTime = UtilityTime.currentTimeMillis()
        let currentTimeSeconds = currentTime / 1000
        let refreshIntervalSeconds = refreshDataInMinutes * 60
        if (currentTimeSeconds > (lastRefresh + refreshIntervalSeconds)) || !initialized {
            refreshNeeded = true
            initialized = true
            lastRefresh = currentTime / 1000
        }
        return refreshNeeded
    }

    func resetTimer() {
        lastRefresh = 0
    }
}
