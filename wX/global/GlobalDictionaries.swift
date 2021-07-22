/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class GlobalDictionaries {
    
    static let nexradProductString = [
        "L2REF": "DS.p153r0",
        "L2VEL": "DS.p154r0",
        // "N0R": "DS.p19r0",
        // "N1R": "DS.p19r1",
        // "N2R": "DS.p19r2",
        // "N3R": "DS.p19r3",
        // "NSP": "DS.p28sw",
        "NSW": "DS.p30sw",
        "N0Q": "DS.p94r0",
        "N1Q": "DS.p94r1",
        "N2Q": "DS.p94r2",
        "N3Q": "DS.p94r3",
        // "N0V": "DS.p27v0",
        // "N1V": "DS.p27v1",
        // "N2V": "DS.p27v2",
        // "N3V": "DS.p27v3",
        "N0U": "DS.p99v0",
        "N1U": "DS.p99v1",
        "N2U": "DS.p99v2",
        "N3U": "DS.p99v3",
        "N0S": "DS.56rm0",
        "N1S": "DS.56rm1",
        "N2S": "DS.56rm2",
        "N3S": "DS.56rm3",
        "STI": "DS.58sti",
        "TVS": "DS.61tvs",
        "HI": "DS.p59hi",
        // "N1P": "DS.78ohp",
        // "NTP": "DS.80stp",
        "DVL": "DS.134il",
        "EET": "DS.135et",
        "TZ0": "DS.180z0",
        "TZ1": "DS.180z1",
        "TZ2": "DS.180z2",
        // "TR0": "DS.181r0",
        // "TR1": "DS.181r1",
        // "TR2": "DS.181r2",
        // "TR3": "DS.181r3",
        "TV0": "DS.182v0",
        "TV1": "DS.182v1",
        "TV2": "DS.182v2",
        "TV3": "DS.182v3",
        "TZL": "DS.186zl",
        // "NTP": "DS.80stp",
        // "NVL": "DS.57vil",
        "N0X": "DS.159x0",
        "N1X": "DS.159x1",
        "N2X": "DS.159x2",
        "N3X": "DS.159x3",
        "N0C": "DS.161c0",
        "N1C": "DS.161c1",
        "N2C": "DS.161c2",
        "N3C": "DS.161c3",
        "N0K": "DS.163k0",
        "N1K": "DS.163k1",
        "N2K": "DS.163k2",
        "N3K": "DS.163k3",
        "DAA": "DS.170aa",
        "DSA": "DS.172dt",
        "DSP": "DS.172dt",
        "H0C": "DS.165h0",
        "H1C": "DS.165h1",
        "H2C": "DS.165h2",
        "H3C": "DS.165h3",
        "NCR": "DS.p37cr",
        "NCZ": "DS.p38cr"
    ]
    
    static let radarProductStringToShortInt: [String: Int16] = [
        "L2REF": 153,
        "L2VEL": 154,
        // "N0R": 19,
        // "N1R": 19,
        // "N2R": 19,
        // "N3R": 19,
        "N0Q": 94,
        "N1Q": 94,
        "N2Q": 94,
        "N3Q": 94,
        // "N0V": 27,
        // "N1V": 27,
        // "N2V": 27,
        // "N3V": 27,
        // "NSP": 28,
        "NSW": 30,
        "N0U": 99,
        "N1U": 99,
        "N2U": 99,
        "N3U": 99,
        "N0S": 56,
        "N1S": 56,
        "N2S": 56,
        "N3S": 56,
        "STI": 58,
        "TVS": 61,
        "HI": 59,
        // "N1P": 78,
        // "NTP": 80,
        "DVL": 134,
        "EET": 135,
        "TZ0": 180,
        "TZ1": 180,
        "TZ2": 180,
        // "TR0": 181,
        // "TR1": 181,
        // "TR2": 181,
        // "TR3": 181,
        "TV0": 182,
        "TV1": 182,
        "TV2": 182,
        "TV3": 182,
        "TZL": 186,
        // "NTP": 80,
        // "NVL": 57,
        "N0X": 159,
        "N1X": 159,
        "N2X": 159,
        "N3X": 159,
        "N0C": 161,
        "N1C": 161,
        "N2C": 161,
        "N3C": 161,
        "N0K": 163,
        "N1K": 163,
        "N2K": 163,
        "N3K": 163,
        "DAA": 170,
        "DSA": 172,
        "DSP": 172,
        "H0C": 165,
        "H1C": 165,
        "H2C": 165,
        "H3C": 165,
        "NCR": 37,
        "NCZ": 38
    ]
    
//    static let wfoToRadarSite = [
//        "ABQ": "ABX",
//        "ABR": "ABR",
//        "AFC": "AHG",
//        "AFG": "APD",
//        "AJK": "ACG",
//        "AKQ": "AKQ",
//        "ALY": "ENX",
//        "AMA": "AMA",
//        "ANC": "ANC",
//        "APX": "APX",
//        "ARX": "ARX",
//        "BGM": "BGM",
//        "BIS": "BIS",
//        "BMX": "BMX",
//        "BOI": "CBX",
//        "BOU": "FTG",
//        "BOX": "BOX",
//        "BRO": "BRO",
//        "BTV": "CXX",
//        "BUF": "BUF",
//        "BYZ": "BLX",
//        "CAE": "CAE",
//        "CAR": "CBW",
//        "CHS": "CLX",
//        "CLE": "CLE",
//        "CRP": "CRP",
//        "CTP": "CCX",
//        "CYS": "CYS",
//        "DDC": "DDC",
//        "DLH": "DLH",
//        "DMX": "DMX",
//        "DTX": "DTX",
//        "DVN": "DVN",
//        "EAX": "EAX",
//        "EKA": "BHX",
//        "EPZ": "EPZ",
//        "EWX": "EWX",
//        "FFC": "FFC",
//        "FGF": "MVX",
//        "FGZ": "FSX",
//        "FSD": "FSD",
//        "FWD": "FWS",
//        "GGW": "GGW",
//        "GID": "UEX",
//        "GJT": "GJX",
//        "GLD": "GLD",
//        "GRB": "GRB",
//        "GRR": "GRR",
//        "GSP": "GSP",
//        "GUM": "GUA",
//        "GYX": "GYX",
//        "HFO": "HMO",
//        "HGX": "HGX",
//        "HNX": "HNX",
//        "HUN": "HTX",
//        "ICT": "ICT",
//        "ILM": "LTX",
//        "ILN": "ILN",
//        "ILX": "ILX",
//        "IND": "IND",
//        "IWX": "IWX",
//        "JAN": "DGX",
//        "JAX": "JAX",
//        "JKL": "JKL",
//        "KEY": "BYX",
//        "LBF": "LNX",
//        "LCH": "LCH",
//        "LIX": "LIX",
//        "LKN": "LRX",
//        "LMK": "LVX",
//        "LOT": "LOT",
//        "LOX": "VTX",
//        "LSX": "LSX",
//        "LUB": "LBB",
//        "LWX": "LWX",
//        "LZK": "LZK",
//        "MAF": "MAF",
//        "MEG": "NQA",
//        "MFL": "AMX",
//        "MFR": "MAX",
//        "MHX": "MHX",
//        "MKX": "MKX",
//        "MLB": "MLB",
//        "MOB": "MOB",
//        "MPX": "MPX",
//        "MQT": "MQT",
//        "MRX": "MRX",
//        "MSO": "MSX",
//        "MTR": "MUX",
//        "OAX": "OAX",
//        "OHX": "OHX",
//        "OKX": "OKX",
//        "OTX": "OTX",
//        "OUN": "TLX",
//        "PAH": "PAH",
//        "PBZ": "PBZ",
//        "PDT": "PDT",
//        "PHI": "DIX",
//        "PIH": "SFX",
//        "PQR": "RTX",
//        "PSR": "IWA",
//        "PUB": "PUX",
//        "RAH": "RAX",
//        "REV": "RGX",
//        "RIW": "RIW",
//        "RLX": "RLX",
//        "RNK": "FCX",
//        "SEW": "ATX",
//        "SGF": "SGF",
//        "SGX": "NKX",
//        "SHV": "SHV",
//        "SJT": "SJT",
//        "SJU": "JUA",
//        "JSJ": "JUA",
//        "SLC": "MTX",
//        "STO": "DAX",
//        "TAE": "TLH",
//        "TBW": "TBW",
//        "TFX": "TFX",
//        "TOP": "TWX",
//        "TSA": "INX",
//        "TWC": "EMX",
//        "UNR": "UDX",
//        "VEF": "ESX"
//    ]
}
