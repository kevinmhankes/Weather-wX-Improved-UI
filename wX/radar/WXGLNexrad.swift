/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class WXGLNexrad {

    static var radarProductList = [
        "N0Q: Base Reflectivity",
        "N0U: Base Velocity",
        "L2REF: Level 2 Reflectivity",
        "L2VEL: Level 2 Velocity",
        "EET: Enhanced Echo Tops",
        "DVL: Vertically Integrated Liquid",
        "N0X: Differential Reflectivity",
        "N0C: Correlation Coefficient",
        "N0K: Specific Differential Phase",
        "H0C: Hydrometer Classification",
        "DSP: Digital Storm Total Precipitation",
        "DAA: Digital Accumulation Array",
        "N0S: Storm Relative Mean Velocity",
        "NSW: Base Spectrum Width"
        ]

    static var radarProductListTDWR = [
        "TZL: Long Range Digital Base Reflectivity",
        "TV0: Digital Base Velocity"
        ]

    static let TDWR = [
        "DTX": "DTW",
        "LOT": "ORD",
        "MKX": "MKE",
        "MPX": "MSP",
        "FTG": "DEN",
        "BOX": "BOS",
        "CLE": "LVE",
        "EAX": "MCI",
        "FFC": "ATL",
        "FWS": "DFW",
        "GSP": "CLT",
        "HGX": "HOU",
        "IND": "IDS",
        "LIX": "MSY",
        "LVX": "SDF",
        "LSX": "STL",
        "NQA": "MEM",
        "AMX": "MIA",
        "OHX": "BNA",
        "OKX": "JFK",
        "TLX": "OKC",
        "PBZ": "PIT",
        "DIX": "PHL",
        "IWA": "PHX",
        "RAX": "RDU",
        "MTX": "SLC",
        "TBW": "TPA",
        "INX": "TUL",
        "ESX": "LAS",
        "TBW": "TPA",
        "JUA": "SJU",
        "LWX": "DCA",
        "ILN": "CMH",
        "MLB": "MCO",
        "ICT": "ICT",
        "CMH": "CMH",
        "CVG": "CVG",
        "DAL": "DAL",
        "DAY": "DAY",
        "EWR": "EWR",
        "FLL": "FLL",
        "IAD": "IAD",
        "IAH": "IAH",
        "MDW": "MDW",
        "PBI": "PBI"
    ]

    static func getNumberRangeBins(_ productCode: Int) -> Int {
        switch productCode {
        case 134: return 460
        case 186: return 1390
        case 182: return 720
        case 135: return 1200
        case 99:  return 1200
        case 159: return 1200
        case 161: return 1200
        case 163: return 1200
        case 170: return 1200
        case 172: return 1200
        default:  return 460
        }
    }

    static func getBinSize(_ productCode: Int16) -> Double {
        let binSize54 = 2.0
        let binSize13 = 0.50
        let binSize08 = 0.295011
        let binSize16 = 0.590022
        switch productCode {
        case 134: return binSize54
        case 135: return binSize54
        case 186: return binSize16
        case 159: return binSize13
        case 161: return binSize13
        case 163: return binSize13
        case 165: return binSize13
        case 99:  return binSize13
        case 170: return binSize13
        case 172: return binSize13
        case 182: return binSize08
        case 153: return binSize13
        case 154: return binSize13
        default:  return binSize54
        }
    }

    static func isRidTdwr(_ radarSite: String) -> Bool {
        return getTdwrShortList().contains(radarSite)
    }

    static func getTdwrShortList() -> [String] {
        return GlobalArrays.tdwrRadars.map {$0.split(" ")[0]}
    }

    static func getTDWRFromRID (_ radarSite: String) -> String {
        return TDWR[radarSite] ?? ""
    }
}
