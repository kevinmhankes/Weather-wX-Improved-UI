/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityDownloadMpd {

    static let timer = DownloadTimer("MPD")

    static func get() {
        if !PolygonType.MPD.display {
            UtilityDownloadRadar.clearMpd()
        } else if timer.isRefreshNeeded() {
            UtilityDownloadRadar.getMpd()
        }
    }
}
