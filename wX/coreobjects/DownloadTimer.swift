/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

class DownloadTimer {

    var initialized = false
    var lastRefresh: CLong = 0
    var refreshDataInMinutes = max(RadarPreferences.radarDataRefreshInterval, 6)
    var identifier: String

    init(_ identifier: String) {
        self.identifier = identifier
        print("DOWNLOAD STATUS INIT " + identifier)
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
        print("DOWNLOAD STATUS for " + identifier +  " " + String(refreshNeeded))
        return refreshNeeded
    }

    func resetTimer() {
        lastRefresh = 0
    }
}
