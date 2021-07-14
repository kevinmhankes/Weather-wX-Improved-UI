/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityPolygons {

    static func get() {
        UtilityDownloadWarnings.get()
        
//        UtilityDownloadWatch.get()
//        UtilityDownloadMcd.get()
//        UtilityDownloadMpd.get()
        
//        for t in [PolygonEnum.SPCWAT, PolygonEnum.SPCMCD, PolygonEnum.WPCMPD] {
//            ObjectPolygonWatch.polygonDataByType[t]?.download()
//        }
        
        if PolygonType.MCD.display {
            ObjectPolygonWatch.polygonDataByType[PolygonEnum.SPCMCD]?.download()
        }
        
        if PolygonType.WATCH.display {
            ObjectPolygonWatch.polygonDataByType[PolygonEnum.SPCWAT]?.download()
        }
        
        if PolygonType.MPD.display {
            ObjectPolygonWatch.polygonDataByType[PolygonEnum.WPCMPD]?.download()
        }
    }
}
