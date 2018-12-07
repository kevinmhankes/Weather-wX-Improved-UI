/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityModelGLCFSInterface {

    static let sectors = [
            "Lake Superior",
            "Lake Michigan",
            "Lake Huron",
            "Lake Erie",
            "Lake Ontario",
            "All Lakes"
    ]

    static let params = [
            "wv",
            "wn",
            "swt",
            "sfcur",
            "wl",
            "wl1d",
            "cl",
            "at"
    ]

    static let labels = [
            "Wave height",
            "Wind speed",
            "Surface temperature",
            "Surface currents",
            "Water level displacement",
            "Water level displacement 1D",
            "Cloud cover (5 lake view only)",
            "Air temp (5 lake view only)"
    ]
}
