/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class UtilityAwcRadarMosaic {

    private static let baseUrl = "https://www.aviationweather.gov/data/obs/"

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
        "msp",
        "lit",
        "pir",
        "ict",
        "aus",
        "cod",
        "den",
        "abq",
        "lws",
        "wmc",
        "las",
        "ak",
        "hi",
        "carib"
    ]

    static let sectorLabels = [
        "CONUS US",
        "Albany NY",
        "Baltimore MD",
        "Charlotte NC",
        "Tampa FL",
        "Detroit MI",
        "Evansville IN",
        "Montgomery AL",
        "Minneapolis MN",
        "Little Rock AR",
        "Pierre SD",
        "Wichita KS",
        "Austin TX",
        "Cody WY",
        "Denver CO",
        "Albuquerque NM",
        "Lewiston ID",
        "Winnemuca NV",
        "Las Vegas NV",
        "Alaska",
        "Hawaii",
        "Caribbean"
    ]

    private static let cityToLatLon = [
        "Albany NY": LatLon(42.65, -73.75),
        "Baltimore MD": LatLon(39.29, -76.60),
        "Charlotte NC": LatLon(35.22, -80.84),
        "Tampa FL": LatLon(27.96, -82.45),
        "Detroit MI": LatLon(42.33, -83.04),
        "Evansville IN": LatLon(37.97, -87.55),
        "Montgomery AL": LatLon(32.36, -86.29),
        "Minneapolis MN": LatLon(44.98, -93.25),
        "Little Rock AR": LatLon(34.74, -92.28),
        "Pierre SD": LatLon(44.36, -100.33),
        "Wichita KS": LatLon(37.69, -97.31),
        "Austin TX": LatLon(30.28, -97.73),
        "Cody WY": LatLon(44.52, -109.05),
        "Denver CO": LatLon(39.74, -104.99),
        "Albuquerque NM": LatLon(35.10, -106.62),
        "Lewiston ID": LatLon(46.41, -117.01),
        "Winnemuca NV": LatLon(40.97, -117.73),
        "Las Vegas NV": LatLon(36.11, -115.17),
        "Alaska": LatLon(59.199, -150.605),
        "Hawaii": LatLon(19.8181, -156.5595)
    ]

    static func getNearestMosaic(_ location: LatLon) -> String {
        var shortestDistance = 1000.00
        var currentDistance = 0.0
        var bestIndex = ""
        cityToLatLon.keys.forEach { key in
            currentDistance = LatLon.distance(location, cityToLatLon[key]!, .MILES)
            if currentDistance < shortestDistance {
                shortestDistance = currentDistance
                bestIndex = key
            }
        }
        if bestIndex == "" {
            return "BLAH"
        }
        let index = sectorLabels.firstIndex(of: bestIndex)
        return sectors[index!]
    }

    // https://www.aviationweather.gov/data/obs/radar/rad_rala_msp.gif
    // https://www.aviationweather.gov/data/obs/radar/rad_tops-18_alb.gif
    // https://www.aviationweather.gov/data/obs/radar/rad_cref_bwi.gif
    // https://www.aviationweather.gov/data/obs/sat/us/sat_vis_dtw.jpg

    static func get(_ sector: String, _ product: String) -> String {
        var baseAddOn = "radar/"
        var imageType = ".gif"
        if product.contains("sat_") {
            baseAddOn = "sat/us/"
            imageType = ".jpg"
        }
        return baseUrl + baseAddOn + product + "_" + sector + imageType
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
        } else if product.hasPrefix("rad_") {
          topUrlAddOn = "&type=" + product.replace("rad_", "") + "&date="
        }
        let productUrl = "https://www.aviationweather.gov/" + baseAddOnTopUrl + "plot?region=" + sector + topUrlAddOn
        let html = productUrl.getHtml()
        let urls = html.parseColumn(
            "image_url.[0-9]{1,2}. = ./data/obs/" + baseAddOn + "([0-9]{8}/[0-9]{2}/[0-9]{8}_[0-9]{4}_" + product + "_"
                + sector
                + imageType + ")."
        )
        let bitmaps = urls.map { Bitmap(baseUrl + baseAddOn + $0) }
        return UtilityImgAnim.getAnimationDrawableFromBitmapList(bitmaps)
    }
}
