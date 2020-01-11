/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

public class UtilityDownloadMpd {

    static var timer = DownloadTimer("MPD")

    static func get() {
        if !PolygonType.MPD.display {
            UtilityDownloadRadar.clearMpd()
        }
        if timer.isRefreshNeeded() {
            if PolygonType.MPD.display {
                UtilityDownloadRadar.getMpd()
            } else {
                UtilityDownloadRadar.clearMpd()
            }
        }
    }
}
