/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class DownloadTimer {

    private var initialized = false
    private var lastRefresh: CLong = 0
//    private var refreshDataInMinutes = max(RadarPreferences.radarDataRefreshInterval, 6)
    private var refreshDataInMinutes = 6
    private let identifier: String

    init(_ identifier: String) {
        self.identifier = identifier
    }

    func isRefreshNeeded() -> Bool {
        // refreshDataInMinutes = max(RadarPreferences.radarDataRefreshInterval, 6)
        refreshDataInMinutes = 6
        if identifier.contains("WARNINGS") {
            // refreshDataInMinutes = max(RadarPreferences.radarDataRefreshInterval, 3)
            refreshDataInMinutes = 3
        } else if identifier.contains("MAIN_LOCATION_TAB") {
            refreshDataInMinutes = UIPreferences.refreshLocMin
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
