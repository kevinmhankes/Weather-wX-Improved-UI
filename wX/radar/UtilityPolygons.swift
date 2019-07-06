/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

public class UtilityPolygons {

    static func getData() {
        UtilityDownloadWarnings.get()
        UtilityDownloadWatch.get()
        UtilityDownloadMcd.get()
        UtilityDownloadMpd.get()
    }
}
