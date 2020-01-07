/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityModelSpcHrrrInterface {

    static let sectors = [
        "National",
        "Northwest US",
        "Southwest US",
        "Northern Plains",
        "Central Plains",
        "Southern Plains",
        "Northeast US",
        "Mid Atlantic",
        "Southeast US",
        "Midwest"
    ]

    static let sectorCodes = [
        "S19",
        "S11",
        "S12",
        "S13",
        "S14",
        "S15",
        "S16",
        "S17",
        "S18",
        "S20"
    ]

    static let params = [
        "refc",
        "pmsl",
        "srh3",
        "cape",
        "proxy",
        "wmax",
        "scp",
        "uh",
        "ptype",
        "ttd"
    ]

    static let labels = [
        "Composite Reflectivity",
        "MSL Pressure & Wind",
        "Shear Parameters",
        "Thermo Parameters",
        "Proxy Indicators",
        "Max Surface Wind",
        "SCP / STP",
        "Updraft Helicity",
        "Winter Parameters",
        "Temp/Dwpt"
    ]
}
