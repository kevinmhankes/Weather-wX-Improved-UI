/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class UtilityAwcRadarMosaic {

    static let baseUrl = "https://www.aviationweather.gov/data/obs/"

    static let products = [
        "rad_rala",
        "rad_cref",
        "rad_tops-18",
        "sat_irbw",
        "sat_ircol",
        "sat_irnws",
        "sat_vis",
        "sat_wv"
    ]

    static let productLabels = [
        "Reflectivity",
        "Composite Reflectivity",
        "Echo Tops",
        "Infrared (BW)",
        "Infrared (Col)",
        "Infrared (NWS)",
        "Visible",
        "Water Vapor"
    ]

    static let sectors = [
        "us",
        "alb",
        "bwi",
        "clt",
        "tpa",
        "dtw",
        "evv",
        "mgm",
        "lit",
        "pir",
        "ict",
        "aus",
        "cod",
        "den",
        "abq",
        "lws",
        "wmc",
        "las"
    ]

    // https://www.aviationweather.gov/data/obs/radar/rad_rala_msp.gif
    // https://www.aviationweather.gov/data/obs/radar/rad_tops-18_alb.gif
    // https://www.aviationweather.gov/data/obs/radar/rad_cref_bwi.gif
    // https://www.aviationweather.gov/data/obs/sat/us/sat_vis_dtw.jpg

    static func get(_ sector: String, _ product: String) -> Bitmap {
        var baseAddOn = "radar/"
        var imageType = ".gif"
        if product.contains("sat_") {
            baseAddOn = "sat/us/"
            imageType = ".jpg"
        }
        let url = baseUrl + baseAddOn + product + "_" + sector + imageType
        return Bitmap(url)
    }

    static func getAnimation(_ sector: String, _ product: String) -> AnimationDrawable {
        // image_url[14] = "/data/obs/radar/20190131/22/20190131_2216_rad_rala_dtw.gif";
        // https://www.aviationweather.gov/satellite/plot?region=us&type=wv
        var baseAddOn = "radar/"
        var baseAddOnTopUrl = "radar/"
        var imageType = ".gif"
        var topUrlAddOn = ""
        if product.contains("sat_") {
            baseAddOnTopUrl = "satellite/"
            baseAddOn = "sat/us/"
            imageType = ".jpg"
            topUrlAddOn = "&type=" + product.replace("sat_", "")
        }
        let productUrl = "https://www.aviationweather.gov/" + baseAddOnTopUrl + "plot?region=" + sector + topUrlAddOn
        let html = productUrl.getHtml()
        let urls = html.parseColumn(
            "image_url.[0-9]{1,2}. = ./data/obs/" + baseAddOn + "([0-9]{8}/[0-9]{2}/[0-9]{8}_[0-9]{4}_" + product + "_"
                + sector
                + imageType + ")."
        )
        let bitmaps = urls.map {Bitmap(baseUrl + baseAddOn + $0)}
        return UtilityImgAnim.getAnimationDrawableFromBitmapList(bitmaps)
    }
}
