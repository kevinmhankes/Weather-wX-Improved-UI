/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityModelNsslWrfInterface {

    static let models = [
        "WRF",
        "FV3",
        "HRRRV3",
        "WRF_3KM"
    ]

    static let paramsNsslWrf = [
        "mslp",
        "10mwind",
        "sfct",
        "sfctd",
        "visibility",
        "250w",
        "500w",
        "850w",

        "mucape",
        "sbcape",
        "srh01",
        "srh03",
        "stpfixed",

        "qpf_001h",
        "qpf_006h",
        "qpf_total",
        "snowfall_total",

        "cref_uh075",
        "maxref1000m",
        "ref1000m_uh075",
        "uh03_004hmax",
        "uh25_004hmax",
        "dd_004hmax",
        "ud_004hmax",
        "wspd_004hmax",
        "graupelsize_001hmax",
        "hailcast_004hmax",
        "ltgthrt1",
        "ltgthrt2",
        "ltgthrt3"
    ]

    static let labelsNsslWrf = [
        "MSLP (mb)",
        "10 m Wind (kt)",
        "2-m Temperature",
        "2-m Dew Point",
        "Visibility",
        "250 mb",
        "500 mb",
        "850 mb",

        "MUCAPE",
        "SBCAPE",
        "0-1km SRH",
        "0-3km SRH",
        "STP",

        "1-h QPF",
        "6-h QPF",
        "Total QPF",
        "Total Snowfall",

        "Reflectivity - Composite",
        "Reflectivity - 1h-max (1km AGL)",
        "Reflectivity - 1km AGL",
        "Updraft Helicity - 4-h max (0-3km)",
        "Updraft Helicity - 4-h max (2-5km)",
        "Vertical Velocity - 4-h min Downdraft",
        "Vertical Velocity - 4-h max Updraft",
        "Wind Speed - 4-h max",
        "Hail - 1-h max Graupel",
        "Hail - 4-h max HAILCAST",
        "Lightning - 1-h max Threat1",
        "Lightning - 1-h max Threat2",
        "Lightning - 1-h max Threat3"
    ]

    static let paramsNsslFv3 = [
        "mslp",
        "10mwind",
        "sfct",
        "sfctd",
        "250w",
        "500w",
        "850w",

        "sbcape",
        "srh01",
        "srh03",
        "stpfixed",

        "qpf_001h",
        "qpf_006h",
        "qpf_total",

        "cref_uh075",
        "uh25_004hmax",
        "dd_004hmax",
        "ud_004hmax"
    ]

    static let labelsNsslFv3 = [
        "MSLP (mb)",
        "10 m Wind (kt)",
        "2-m Temperature",
        "2-m Dew Point",
        "250 mb",
        "500 mb",
        "850 mb",

        "SBCAPE",
        "0-1km SRH",
        "0-3km SRH",
        "STP",

        "1-h QPF",
        "6-h QPF",
        "Total QPF",

        "Reflectivity - Composite",
        "Updraft Helicity - 4-h max (2-5km)",
        "Vertical Velocity - 4-h min Downdraft",
        "Vertical Velocity - 4-h max Updraft"
    ]

    static let paramsNsslHrrrv3 = [
        "mslp",
        "10mwind",
        "sfct",
        "sfctd",
        "250w",
        "500w",
        "850w",

        "mucape",
        "sbcape",
        "srh01",
        "srh03",
        "stpfixed",

        "qpf_001h",
        "qpf_006h",
        "qpf_total",

        "cref_uh075",
        "maxref1000m",
        "ref1000m_uh075",
        "uh25_004hmax",
        "ud_004hmax",
        "wspd_004hmax"
    ]

    static let labelsNsslHrrrv3 = [
        "MSLP (mb)",
        "10 m Wind (kt)",
        "2-m Temperature",
        "2-m Dew Point",
        "250 mb",
        "500 mb",
        "850 mb",

        "MUCAPE",
        "SBCAPE",
        "0-1km SRH",
        "0-3km SRH",
        "STP",

        "1-h QPF",
        "6-h QPF",
        "Total QPF",

        "Reflectivity - Composite",
        "Reflectivity - 1h-max (1km AGL)",
        "Reflectivity - 1km AGL",
        "Updraft Helicity - 4-h max (2-5km)",
        "Vertical Velocity - 4-h max Updraft",
        "Wind Speed - 4-h max"
    ]

    static let sectorsLong = [
        "CONUS",
        "Central Plains",
        "Mid Atlantic",
        "Midwest",
        "Northeast",
        "Northern Plains",
        "Northwest",
        "Southeast",
        "Southern Plains",
        "Southwest"
    ]

    static let sectors = [
        "conus",
        "cp",
        "ma",
        "mw",
        "ne",
        "np",
        "nw",
        "se",
        "sp",
        "sw"
    ]
}
