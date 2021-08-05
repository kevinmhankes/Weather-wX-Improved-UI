// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

final class UtilityModelGlcfsInputOutput {
    
    static func getImage(_ om: ObjectModel) -> Bitmap {
        Bitmap("https://www.glerl.noaa.gov/res/glcfs/lakes/cur/" + om.param + "-" + om.time + ".gif")
    }
}
