/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class UtilityUSImgNwsMosaic {

    static let sectors = [
        "latest",
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
        "northeast"
    ]

    private static let sectorToLabel = [
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

    private static let stateToSector = [
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
        "CONUS",
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
        "Northeast"
    ]

    static func getSectorLabelFromCode(_ code: String) -> String { sectorToLabel[code] ?? "" }

    static func getSectorFromState(_ state: String) -> String { stateToSector[state] ?? "" }

    static func get(_ sector: String) -> Bitmap { Bitmap(GlobalVariables.nwsRadarWebsitePrefix + "/Conus/RadarImg/" + sector + ".gif") }

    static func getStateFromRid() -> String { Utility.getRadarSiteName(Location.rid).split(",")[0] }

    static func getLocalRadarMosaic() -> Bitmap {
        let nwsRadarMosaicSectorLabelCurrent = getSectorFromState(getStateFromRid())
        let index = sectors.firstIndex(of: nwsRadarMosaicSectorLabelCurrent) ?? 0
        return get(sectors[index])
    }

    static func getAnimation(_ sector: String, _ numberOfFrames: Int) -> AnimationDrawable {
        let sectorUrl = sector == "latest" ?  "NAT" : sector
        let regExp = sectorUrl == "alaska" ? "href=.(" + "NATAK" + "_[0-9]{8}_[0-9]{4}.gif)" : "href=.(" + sectorUrl + "_[0-9]{8}_[0-9]{4}.gif)"
        let urls = UtilityImgAnim.getUrlArray(GlobalVariables.nwsRadarWebsitePrefix + "/ridge/Conus/RadarImg/", regExp, numberOfFrames)
        let baseUrl = GlobalVariables.nwsRadarWebsitePrefix + "/ridge/Conus/RadarImg/"
        let bitmaps = urls.map { Bitmap(baseUrl + $0) }
        return UtilityImgAnim.getAnimationDrawableFromBitmapList(bitmaps)
    }
}
