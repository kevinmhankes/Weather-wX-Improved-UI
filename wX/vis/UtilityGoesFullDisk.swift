/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityGoesFullDisk {

    static let labels = [
        "GOES East Infrared",
        "GOES East Visible",
        "GOES West Infrared",
        "GOES West Visible",
        "Meteosat Infrared",
        "Meteosat Visible",
        "Meteosat India Ocean Infrared",
        "Meteosat India Ocean Visible",
        "Himawari-8 Infrared",
        "Himawari-8 IR, Ch. 4",
        "Himawari-8 Water Vapor",
        "Himawari-8 Water Vapor (Blue)",
        "Himawari-8 Visible",
        "Himawari-8 AVN Infrared",
        "Himawari-8 Funktop Infrared",
        "Himawari-8 RBTop Infrared, Ch. 4"
    ]

    static let urls = [
        "http://www.goes.noaa.gov/FULLDISK/GEIR.JPG",
        "http://www.goes.noaa.gov/FULLDISK/GEVS.JPG",
        "http://www.goes.noaa.gov/FULLDISK/GWIR.JPG",
        "http://www.goes.noaa.gov/FULLDISK/GWVS.JPG",
        "http://www.goes.noaa.gov/FULLDISK/GMIR.JPG",
        "http://www.goes.noaa.gov/FULLDISK/GMVS.JPG",
        "http://www.goes.noaa.gov/FULLDISK/GIIR.JPG",
        "http://www.goes.noaa.gov/FULLDISK/GIVS.JPG",
        "http://www.goes.noaa.gov/dimg/jma/fd/rb/10.gif",
        "http://www.goes.noaa.gov/dimg/jma/fd/ir4/10.gif",
        "http://www.goes.noaa.gov/dimg/jma/fd/wv/10.gif",
        "http://www.goes.noaa.gov/dimg/jma/fd/wvblue/10.gif",
        "http://www.goes.noaa.gov/dimg/jma/fd/vis/10.gif",
        "http://www.goes.noaa.gov/dimg/jma/fd/avn/10.gif",
        "http://www.goes.noaa.gov/dimg/jma/fd/ft/10.gif",
        "http://www.goes.noaa.gov/dimg/jma/fd/rbtop/10.gif"
    ]

    static func getAnimation(url: String) -> AnimationDrawable {
        let url2 = url.replace("10.gif", "")
        let bitmaps = (0...9).map {Bitmap(url2 + String($0+1) + ".gif")}
        return UtilityImgAnim.getAnimationDrawableFromBitmapList(bitmaps, UtilityImg.getAnimInterval())
    }
}
