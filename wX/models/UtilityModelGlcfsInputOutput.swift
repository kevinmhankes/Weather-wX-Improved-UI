/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityModelGlcfsInputOutput {
    
    static func getImage(_ om: ObjectModel) -> Bitmap {
        var sectorLocal = om.sector
        if om.sector.split(" ").count > 1 {sectorLocal = om.sector.split(" ")[1].substring(0, 1).lowercased()}
        return Bitmap("https://www.glerl.noaa.gov/res/glcfs/fcast/" + sectorLocal + om.param + "+" + om.time + ".gif")
    }
}
