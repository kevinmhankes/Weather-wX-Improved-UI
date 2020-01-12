/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

public class UtilityDownloadMcd {

    static var timer = DownloadTimer("MPD")

    static func get() {
        if !PolygonType.MCD.display {
            UtilityDownloadRadar.clearMcd()
        } else if timer.isRefreshNeeded() {
            UtilityDownloadRadar.getMcd()
        }
    }
}
