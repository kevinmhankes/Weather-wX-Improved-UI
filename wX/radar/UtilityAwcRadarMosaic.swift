/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class UtilityAwcRadarMosaic {

    static let baseUrl = "https://www.aviationweather.gov/data/obs/radar/"

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

    static let sectorToLabel = [
        "alaska": "Alaska",
        "hawaii": "Hawaii",
        "pacsouthwest": "Pacific Southwest",
        "pacnorthwest": "Pacific Northwest",
        "southrockies": "South Rockies",
        "northrockies": "North Rockies",
        "uppermissvly": "Upper MS Valley",
        "southplains": "Southern Plains",
        "centgrtlakes": "Central Great Lakes",
        "southmissvly": "Southern MS Valley",
        "southeast": "Southeast",
        "northeast": "Northeast",
        "conus": "CONUS"
    ]

    static let stateToSector = [
        "WA": "pacnorthwest",
        "ID": "pacnorthwest",
        "OR": "pacnorthwest",
        "CA": "pacsouthwest",
        "NV": "pacsouthwest",
        "UT": "northrockies",
        "AZ": "southrockies",
        "NM": "southrockies",
        "ND": "uppermissvly",
        "SD": "uppermissvly",
        "MT": "northrockies",
        "WY": "northrockies",
        "CO": "northrockies",
        "NE": "uppermissvly",
        "KS": "uppermissvly",
        "OK": "southplains",
        "TX": "southplains",
        "LA": "southmissvly",
        "MN": "uppermissvly",
        "WI": "centgrtlakes",
        "MI": "centgrtlakes",
        "IA": "uppermissvly",
        "IN": "centgrtlakes",
        "IL": "centgrtlakes",
        "TN": "southmissvly",
        "MO": "uppermissvly",
        "AR": "southmissvly",
        "FL": "southeast",
        "MS": "southmissvly",
        "AL": "southmissvly",
        "GA": "southeast",
        "SC": "southeast",
        "NC": "southeast",
        "KY": "centgrtlakes",
        "OH": "centgrtlakes",
        "WV": "centgrtlakes",
        "VA": "northeast",
        "PA": "northeast",
        "NJ": "northeast",
        "DE": "northeast",
        "ME": "northeast",
        "MA": "northeast",
        "NH": "northeast",
        "VT": "northeast",
        "CT": "northeast",
        "RI": "northeast",
        "NY": "northeast",
        "AK": "alaska",
        "HI": "hawaii"
    ]

    static let labels = [
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
        "Las Vegas NV"
    ]

    static func getSectorLabelFromCode(_ code: String) -> String {
        return sectorToLabel[code] ?? ""
    }

    static func getSectorFromState(_ state: String) -> String {
        return stateToSector[state] ?? ""
    }

    // https://www.aviationweather.gov/data/obs/radar/rad_rala_msp.gif
    // https://www.aviationweather.gov/data/obs/radar/rad_tops-18_alb.gif
    // https://www.aviationweather.gov/data/obs/radar/rad_cref_bwi.gif

    static func get(_ sector: String) -> Bitmap {
        let product = "rala"
        return Bitmap(baseUrl + "rad_" + product + "_" + sector + ".gif")
    }

    static func getStateFromRid() -> String {
        return Utility.readPref("RID_LOC_" + Location.rid, "").split(",")[0]
    }

    static func getLocalRadarMosaic() -> Bitmap {
        let nwsRadarMosaicSectorLabelCurrent = getSectorFromState(getStateFromRid())
        let index = sectors.index(of: nwsRadarMosaicSectorLabelCurrent) ?? 0
        return get(sectors[index])
    }

    static func getAnimation(_ sector: String, _ numberOfFrames: Int) -> AnimationDrawable {
        // image_url[14] = "/data/obs/radar/20190131/22/20190131_2216_rad_rala_dtw.gif";
        let productUrl = "https://www.aviationweather.gov/radar/plot?region=" + sector
        let html = productUrl.getHtml()
        let urls = html.parseColumn(
            "image_url.[0-9]{1,2}. = ./data/obs/radar/([0-9]{8}/[0-9]{2}/[0-9]{8}_[0-9]{4}_rad_rala_" + sector + ".gif)."
        )
        //print(urls)
        let bitmaps = urls.map {Bitmap(baseUrl + $0)}
        return UtilityImgAnim.getAnimationDrawableFromBitmapList(bitmaps)
    }
}
