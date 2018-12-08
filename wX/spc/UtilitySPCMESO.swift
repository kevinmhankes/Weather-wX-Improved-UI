/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilitySPCMESO {

    static let defaultSector = "19"
    
    // FIXME convert to list
    static let imageSf = ":mixr:ttd:mcon:thea:mxth:temp_chg:dwpt_chg:mixr_chg:thte_chg:925mb:850mb:700mb:500mb:300mb:sbcp:mlcp:"
        + "mucp:muli:laps:lllr:lclh:lfch:lfrh:effh:stor:stpc:cpsh:comp:lcls:lr3c:tdlr:qlcs1:qlcs2:pwtr:tran:tran_925:tran_925-850:prop:peff:fzlv:les1:"
        + "tadv_925:7tad:tadv:"

    static let titles = [
        ObjectMenuTitle("Observations", 3),
        ObjectMenuTitle("Surface", 15),
        ObjectMenuTitle("Upper Air", 24), // 1
        ObjectMenuTitle("Thermodynamics", 19),
        ObjectMenuTitle("Wind Shear", 18), // 1
        ObjectMenuTitle("Composite Indices", 21),
        ObjectMenuTitle("Multi-Parameter Fields", 10),
        ObjectMenuTitle("Heavy Rain", 8), // 3
        ObjectMenuTitle("Winter Weather", 14),
        ObjectMenuTitle("Fire Weather", 6),
        ObjectMenuTitle("Classic", 3),
        ObjectMenuTitle("Beta", 9)
        ]

    static let params = [

        "bigsfc",
        "1kmv",
        "rgnlrad",

        "pmsl",
        "ttd",
        "mcon",
        "thea",
        "mxth",
        "icon",
        "trap",
        "vtm",
        "dvvr",
        "def",
        "pchg",
        "temp_chg",
        "dwpt_chg",
        "mixr_chg",
        "thte_chg",

        "925mb",
        "850mb",
        "700mb",
        "500mb",
        "300mb",
        "dlcp",
        "sfnt",
        "tadv_925",
        "tadv",
        "7tad",
        "9fnt",
        "8fnt",
        "7fnt",
        "925f",
        "98ft",
        "857f",
        "75ft",
        "vadv",
        "padv",
        "ddiv",
        "ageo",
        "500mb_chg",
        "trap_500",
        "trap_250",

        "sbcp",
        "mlcp",
        "mucp",
        "eltm",
        "ncap",
        "dcape",
        "muli",
        "laps",
        "lllr",
        "maxlr",
        "lclh",
        "lfch",
        "lfrh",
        "sbcp_chg",
        "sbcn_chg",
        "mlcp_chg",
        "mucp_chg",
        "lllr_chg",
        "laps_chg",

        "eshr",
        "shr6",
        "shr8",
        "shr3",
        "srh1",
        "brns",
        "effh",
        "srh3",
        "srh1",
        "llsr",
        "mlsr",
        "ulsr",
        "alsr",
        "mnwd",
        "xover",
        "srh3_chg",
        "shr1_chg",
        "shr6_chg",

        "scp",
        "lscp",
        "stor",
        "stpc",
        "sigt1",
        "sigt2",
        "nstp",
        "sigh",
        "sars1",
        "sars2",
        "lghl",
        "dcp",
        "cbsig",
        "brn",
        "mcsm",
        "mbcp",
        "desp",
        "ehi1",
        "ehi3",
        "vgp3",
        "crit",

        "mlcp_eshr",
        "cpsh",
        "comp",
        "lcls",
        "lr3c",
        "3cvr",
        "tdlr",
        "hail",
        "qlcs1",
        "qlcs2",

        "pwtr",
        "pwtr2",
        "tran",
        "tran_925",
        "tran_925-850",
        "prop",
        "peff",
        "mixr",

        "ptyp",
        "fztp",
        "swbt",
        "fzlv",
        "thck",
        "epvl",
        "epvm",
        "les1",
        "les2",
        "snsq",
        "dend",
        "dendrh",
        "ddrh",
        "mxwb",

        "sfir",
        "fosb",
        "lhan",
        "mhan",
        "hhan",
        "lasi",

        "ttot",
        "kidx",
        "show",

        "sherbe",
        "moshe",
        "cwasp",
        "eehi",
        "oprh",
        "ptstpe",
        "pstpe",
        "pvstpe",
        "vtp"
        ]

    static let labels = [

        "Surface Observations",
        "Visible Satellite",
        "Radar Base Reflectivity",

        "MSL Pressure/Wind",
        "Temp/Dewpt/Wind",
        "Moisture Convergence",
        "Theta-E Advection",
        "Mixing Ratio / Theta",
        "Instantaneous Contraction Rate (sfc)",
        "Fluid Trapping (sfc)",
        "Velocity Tensor Magnitude (sfc)",
        "Divergence and Vorticity (sfc)",
        "Deformation and Axes of Dilitation (sfc)",
        "2-hour Pressure Change",
        "3-hour Temp Change",
        "3-hour Dwpt Change",
        "3-hour 100 mb Mixing Ratio Change",
        "3-hour Theta-E Change",

        "925mb Analysis",
        "850mb Analysis",
        "700mb Analysis",
        "500mb Analysis",
        "300mb Analysis",
        "Deep Moisture Convergence",
        "Sfc Frontogenesis",
        "925mb Temp Advection",
        "850mb Temp Advection",
        "700mb Temp Advection",
        "925mb Frontogenesis",
        "850mb Frontogenesis",
        "700mb Frontogenesis",
        "1000-925mb Frontogenesis",
        "925-850mb Frontogenesis",
        "850-700mb Frontogenesis",
        "700-500mb Frontogenesis",
        "700-400mb Diff. Vorticity Advection",
        "400-250mb Pot. Vorticity Advection",
        "850-250mb Diff. Divergence",
        "300mb Jet Circulation",
        "12-hour 500mb Height Change",
        "Fluid Trapping (500 mb)",
        "Fluid Trapping (250 mb)",

        "CAPE - Surface Based",
        "CAPE - 100mb Mixed-Layer",
        "CAPE - Most-Unstable / LPL Height",
        "EL Temp/MUCAPE/MUCIN",
        "CAPE - Normalized",
        "CAPE - Downdraft",
        "Surface-based Lifted Index",
        "Mid-Level Lapse Rates",
        "Low-Level Lapse Rates",
        "Max 2-6 km AGL Lapse Rate",
        "LCL Height",
        "LFC Height",
        "LCL-LFC Mean RH",
        "3-hour Surface-Based CAPE Change",
        "3-hour Surface-Based CIN Change",
        "3-hour 100mb Mixed-Layer CAPE Change",
        "3-hour Most-Unstable CAPE Change",
        "3-hour Low-Level LR Change",
        "6-hour Mid-Level LR Change",

        "Bulk Shear - Effective",
        "Bulk Shear - Sfc-6km",
        "Bulk Shear - Sfc-8km",
        "Bulk Shear - Sfc-3km",
        "Bulk Shear - Sfc-1km",
        "BRN Shear",
        "SR Helicity - Effective",
        "SR Helicity - Sfc-3km",
        "SR Helicity - Sfc-1km",
        "SR Wind - Sfc-2km",
        "SR Wind - 4-6km",
        "SR Wind - 9-11km",
        "SR Wind - Anvil Level",
        "850-300mb Mean Wind",
        "850 and 500mb Winds",
        "3hr Sfc-3km SR Helicity Change",
        "3hr Sfc-1km Bulk Shear Change",
        "3hr Sfc-6km Bulk Shear Change",

        "Supercell Composite",
        "Supercell Composite (left-moving)",
        "Sgfnt Tornado (fixed layer)",
        "Sgfnt Tornado (effective layer)",
        "Cond. Prob. Sigtor (Eqn 1)",
        "Cond. Prob. Sigtor (Eqn 2)",
        "Non-Supercell Tornado",
        "Sgfnt Hail",
        "SARS Hail Size",
        "SARS Sig. Hail Percentage",
        "Large Hail Parameter",
        "Derecho Composite",
        "Craven/Brooks Sgfnt Severe",
        "Bulk Richardson Number",
        "MCS Maintenance",
        "Microburst Composite",
        "Enhanced Stretching Potential",
        "EHI - Sfc-1km",
        "EHI - Sfc-3km",
        "VGP - Sfc-3km",
        "Critical Angle",

        "100mb Mixed-Layer CAPE / Effective Bulk Shear",
        "Most-Unstable CAPE / Effective Bulk Shear",
        "Most-Unstable LI / 850 & 500mb Winds",
        "LCL Height / Sfc-1km SR Helicity",
        "Sfc-3km Lapse Rate / Sfc-3km MLCAPE",
        "Sfc Vorticity / Sfc-3km MLCAPE",
        "Sfc Dwpt / 700-500mb Lapse Rates",
        "Hail Parameters",
        "Lowest 3km max. Theta-e diff., MUCAPE, and 0-3km vector shear",
        "Lowest 3km max. Theta-e diff., MLCAPE, and 0-3km vector shear",

        "Precipitable Water",
        "Precipitable Water (w/850mb Moisture Transport Vector)",
        "850mb Moisture Transport",
        "925mb Moisture Transport",
        "925-850mb Moisture Transport",
        "Upwind Propagation Vector",
        "Precipitation Potential Placement",
        "100mb Mean Mixing Ratio",

        "Precipitation Type",
        "Near-Freezing Surface Temp.",
        "Surface Wet-Bulb Temp",
        "Freezing Level",
        "Critical Thickness",
        "800-750mb EPVg",
        "650-500mb EPVg",
        "Lake Effect Snow 1",
        "Lake Effect Snow 2",
        "Snow Squall Parameter",
        "Dendritic Growth Layer Depth",
        "Dendritic Growth Layer RH",
        "Dendritic Growth Layer Depth & RH",
        "Max Wet Bulb Temperature",

        "Sfc RH, Temp, Wind",
        "Fosberg Index",
        "Low Altitude Haines Index",
        "Mid Altitude Haines Index",
        "High Altitude Haines Index",
        "Lower Atmospheric Severity Index",

        "Total Totals",
        "K-Index",
        "Showalter Index",

        "SHERBE",
        "Modified SHERBE",
        "CWASP",
        "Enhanced EHI",
        "OPRH",
        "Prob EF0+ (conditional on RM supercell)",
        "Prob EF2+ (conditional on RM supercell)",
        "Prob EF4+ (conditional on RM supercell)",
        "Violent Tornado Parameter (VTP)"
        ]

    static let paramSurface = [
        "bigsfc": "Surface Observations",
        "1kmv": "Visible Satellite",
        "rgnlrad": "Radar Base Reflectivity",
        "thea": "Theta-E Advection",
        "ttd": "Temp/Wind/Dwpt",
        "pmsl": "MSL Pressure/Wind"
        ]

    static let paramUpperAir = [
        "925mb": "925mb Analysis",
        "850mb": "850mb Analysis",
        "700mb": "700mb Analysis",
        "500mb": "500mb Analysis",
        "300mb": "300mb Analysis",
        "pwtr": "Precipitable water",
        "muli": "Surface-based Lifted Index"
        ]

    static let paramCape = [
        "laps": "Mid-Level Lapse Rates",
        "lllr": "Low-Level Lapse Rates",
        "lclh": "LCL Height",
        "sbcp": "CAPE - Surface Based",
        "mlcp": "CAPE - 100mb Mixed Layer",
        "mucp": "CAPE - Most Unstable / LPL Height"
        ]

    static let paramComp = [
        "sigh": "Sgfnt Hail",
        "stpc": "Sgfnt Tornado (effective layer)",
        "scp": "Supercell Composite"
        ]

    static let paramShear = [
        "srh1": "SR Helicity - Sfc-1km",
        "srh3": "SR Helicity - Sfc-3km",
        "shr6": "Bulk Shear - Sfc-6km",
        "eshr": "Bulk Shear - Effective"
        ]

    static let productShortList = [
        "bigsfc",
        "1kmv",
        "rgnlrad",
        "thea",
        "ttd",
        "pmsl",
        "925mb",
        "850mb",
        "700mb",
        "500mb",
        "300mb",
        "pwtr",
        "muli",
        "laps",
        "lllr",
        "lclh",
        "sbcp",
        "mlcp",
        "mucp",
        "sigh",
        "stpc",
        "scp",
        "srh1",
        "srh3",
        "shr6",
        "eshr"
        ]

    static let sectorMap = [
        "19": "CONUS",
        "20": "Midwest",
        "13": "North Central",
        "14": "Central",
        "15": "South Central",
        "16": "Northeast",
        "17": "Central East",
        "18": "Southeast",
        "12": "Southwest",
        "11": "Northwest"
        ]
}
