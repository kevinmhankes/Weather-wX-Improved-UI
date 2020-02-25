/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import MapKit

final class UtilityMap {
    
    static func genMapURL(_ xStr: String, _ yStr: String, _ zoomLevel: String) -> String {
        return "http://www.openstreetmap.org/?mlat=" + xStr + "&mlon=" + yStr + "&zoom=" + zoomLevel + "&layers=M"
    }
    
    static func genMapURLFromStreetAddress(_ streetAddr: String) -> String {
        return "http://www.openstreetmap.org/search?query=" + streetAddr.replace(",", "%2C").replace(" ", "%20")
    }
}
