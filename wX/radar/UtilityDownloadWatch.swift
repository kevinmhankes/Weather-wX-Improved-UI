/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

public class UtilityDownloadWatch {

    static let timer = DownloadTimer("WATCH")

    static func get() {
        if !PolygonType.MCD.display {
            UtilityDownloadRadar.clearWatch()
        } else if timer.isRefreshNeeded() {
            UtilityDownloadRadar.getWatch()
        }
    }
}
