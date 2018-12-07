/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class UtilityUSImgNWSMosaic {

    static let sectors = [
        "alaska",
        "hawaii",
        "pacsouthwest",
        "southrockies",
        "southplains",
        "southmissvly",
        "southeast",
        "pacnorthwest",
        "northrockies",
        "uppermissvly",
        "centgrtlakes",
        "northeast",
        "latest"
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
        "Alaska",
        "Hawaii",
        "Pacific Southwest",
        "South Rockies",
        "Southern Plains",
        "Southern MS Valley",
        "Southeast",
        "Pacific Northwest",
        "North Rockies",
        "Upper MS Valley",
        "Central Great Lakes",
        "Northeast",
        "CONUS"
        ]

    static func getNwsSectorLabelFromCode(_ code: String) -> String {return sectorToLabel[code] ?? ""}

    static func getNwsSectorFromState(_ state: String) -> String {return stateToSector[state] ?? ""}

    static func nwsMosaic(_ sector: String) -> Bitmap {
        return Bitmap("http://radar.weather.gov/Conus/RadarImg/" + sector + ".gif")
    }

    static func nwsMosaicAnimation(_ sector: String, _ numberOfFrames: String) -> AnimationDrawable {
        var sectorUrl = ""
        if sector=="latest" {
            sectorUrl = "NAT"
        } else {sectorUrl = sector}
        var sPattern = "href=.(" + sectorUrl + "_[0-9]{8}_[0-9]{4}.gif)"
        if sectorUrl=="alaska" {sPattern = "href=.(" + "NATAK" + "_[0-9]{8}_[0-9]{4}.gif)"}
        let urls = UtilityImgAnim.getUrlArray("http://radar.weather.gov/ridge/Conus/RadarImg/",
                                              sPattern, numberOfFrames)
        let baseUrl = "http://radar.weather.gov/ridge/Conus/RadarImg/"
        let bitmaps = urls.map {Bitmap(baseUrl + $0)}
        return UtilityImgAnim.getAnimationDrawableFromBitmapList(bitmaps)
    }
}
