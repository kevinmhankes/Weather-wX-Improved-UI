// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

final class UtilityWpcText {
    
    static func needsFixedWidthFont(_ product: String) -> Bool {
        let productList = ["RWRMX", "UVICAC", "MIATWSEP", "MIATWSAT"]
        if product.startsWith("TPT")
            || product.startsWith("SWPC")
            || product.startsWith("MIAPW")
            || product.startsWith("MIATCM")
            || productList.contains(product) {
            return true
        } else {
            return false
        }
    }
    
    static let titles = [
        ObjectMenuTitle("General Forecast Discussions", 10),
        ObjectMenuTitle("Precipitation Discussions", 2),
        ObjectMenuTitle("Hazards", 7),
        ObjectMenuTitle("Ocean Weather", 38),
        ObjectMenuTitle("Misc North American Weather", 5),
        ObjectMenuTitle("Misc Intl Weather", 4),
        ObjectMenuTitle("SPC", 8),
        ObjectMenuTitle("NHC", 6),
        ObjectMenuTitle("Great Lakes", 7),
        ObjectMenuTitle("Canada", 11),
        ObjectMenuTitle("Space Weather", 6)
    ]
    
    static let labels = [
        "Short Range Forecast Discussion",
        "Extended Forecast Discussion",
        
        "Hawaii Extended Forecast Discussion",
        "Alaska Extended Forecast Discussion",
        "South American Synoptic Discussion",
        "Tropical Discussion",
        "Prognostic disc for 6-10 and 8-14 Day Outlooks",
        "Prognostic disc for Monthly Outlook",
        "Prognostic disc for long-lead Seasonal Outlooks",
        "Prognostic disc for long-lead Hawaiian Outlooks",
        
        "Excessive Rainfall Discussion",
        "Heavy Snow and Icing Discussion",
        
        "CPC US Hazards Outlook Days 3-7",
        "CPC US Hazards Outlook Days 8-14",
        "Storm Summary 1",
        "Storm Summary 2",
        "Storm Summary 3",
        "Storm Summary 4",
        "Storm Summary 5",
        
        "High Seas Forecasts - Atlantic",
        "High Seas Forecasts - NE Pacific",
        "High Seas Forecasts - SE Pacific",
        "High Seas Forecasts - N Atlantic",
        "High Seas Forecasts - N Pacific",
        "High Seas Forecasts - E and C N Pacific",
        "Marine Weather disc for N PAC Ocean",
        "Marine fsct for WA and ORE Waters",
        "Marine fcst for N CA Waters",
        "Marine fcst for S CA Waters",
        "Offshore Waters fsct - PAC 1",
        "Offshore Waters fsct - PAC 2",
        "(VOBRA) for Offshore Waters - WA/OR",
        "(VOBRA) for Offshore Waters - CA",
        "Marine disc for N Atlantic Ocean",
        "Navtex Marine fcst for NE US Waters",
        "Navtex Marine fcst for Atlantic States Waters",
        "Navtex Marine fcst for SE US Waters",
        "Navtex Marine fcst for SE Gulf Of Mexico",
        "Navtex Marine fcst for San Jaun Atlantic Waters",
        "Navtex Marine fcst for NW Gulf Of Mexico",
        "Offshore Waters fsct - ATL 1",
        "Offshore Waters fsct - ATL 2",
        "Offshore Waters fsct - Caribbean & SW North Atlantic",
        "Offshore Waters fsct - Gulf of Mexico",
        "(VOBRA) for Offshore Waters - New England",
        "(VOBRA) for Offshore Waters - West Central North Atlantic",
        "Offshore Waters fsct - Eastern Gulf of Alaska",
        "Offshore Waters fsct - Western Gulf of Alaska",
        "Offshore Waters fsct - Bering Sea",
        "Offshore Waters fsct - US Artic Waters",
        "Offshore Waters fsct - Hawaii",
        "Navtex Marine fcst for Hawaii",
        "Navtex Marine fcst for Kodiak, AK (SE)",
        "Navtex Marine fcst for Kodiak, AK (N Gulf)",
        "Navtex Marine fcst for Kodiak, AK (West)",
        "Navtex Marine fcst for Kodiak, AK (NW)",
        "Navtex Marine fcst for Kodiak, AK(Arctic)",
        
        "NOAA/EPA Ultraviolet Index /UVI/ Forecast",
        "Hourly temp/wx for Western US",
        "Hourly temp/wx for Central US",
        "Hourly temp/wx for Eastern US",
        "Hourly temp/wx for NA Cities",
        
        "Latin America and Caribbean Regional Weather Roundup",
        "Canadian temp and precip Table",
        "Foreign temp and weather table",
        "Latin American temp and weather table",
        
        "Most recent MCD",
        "Day 1 Convective Outlook",
        "Day 2 Convective Outlook",
        "Day 3 Convective Outlook",
        "Day 4-8 Convective Outlook",
        "Day 1 Fire Weather Outlook",
        "Day 2 Fire Weather Outlook",
        "Days 3-8 Fire Weather Outlook",
        
        "ATL Tropical Weather Outlook",
        "ATL Tropical Weather Discussion",
        "EPAC Tropical Weather Outlook",
        "EPAC Tropical Weather Discussion",
        "ATL Monthly Tropical Summary",
        "EPAC Monthly Tropical Summary",
        
        "Lake Michigan - Open Lake Forecast",
        "Lake Superior - Open Lake Forecast",
        "Lake Huron - Open Lake Forecast",
        "Lake St Clair - Open Lake Forecast",
        "Lake Erie - Open Lake Forecast",
        "Lake Ontario - Open Lake Forecast",
        "Saint Lawrence River",
        
        "Significant Weather Discussion, PASPC",
        "FXCN01 D1-3 WEST",
        "FXCN01 D4-7 WEST",
        "FXCN01 D1-3 EAST",
        "FXCN01 D4-7 EAST",
        "Weather Summary S. Manitoba",
        "Weather Summary N. Manitoba",
        "Weather Summary S. Saskatchewan",
        "Weather Summary N. Saskatchewan",
        "Weather Summary S. Alberta",
        "Weather Summary N. Alberta",
        
        "NOAA Geomagnetic Activity Observation and Forecast",
        "NOAA Geomagnetic Activity Probabilities",
        "Weekly Highlights and Forecasts",
        "27-day Space Weather Outlook Table",
        "Forecast Discussion",
        "Advisory Outlook"
    ]
    
    static let labelsWithCodes = [
        "pmdspd: Short Range Forecast Discussion",
        "pmdepd: Extended Forecast Discussion",
        
        "pmdhi: Hawaii Extended Forecast Discussion",
        "pmdak: Alaska Extended Forecast Discussion",
        "pmdsa: South American Synoptic Discussion",
        "pmdca: Tropical Discussion",
        "pmdmrd: Prognostic disc for 6-10 and 8-14 Day Outlooks",
        "pmd30d: Prognostic disc for Monthly Outlook",
        "pmd90d: Prognostic disc for long-lead Seasonal Outlooks",
        "pmdhco: Prognostic disc for long-lead Hawaiian Outlooks",
        
        "qpferd: Excessive Rainfall Discussion",
        "qpfhsd: Heavy Snow and Icing Discussion",
        
        "ushzd37: CPC US Hazards Outlook Days 3-7",
        "pmdthr: CPC US Hazards Outlook Days 8-14",
        "sccns1: Storm Summary 1",
        "sccns2: Storm Summary 2",
        "sccns3: Storm Summary 3",
        "sccns4: Storm Summary 4",
        "sccns5: Storm Summary 5",
        
        "miahsfat2: High Seas Forecasts - Atlantic",
        "miahsfep2: High Seas Forecasts - NE Pacific",
        "miahsfep3: High Seas Forecasts - SE Pacific",
        "nfdhsfat1: High Seas Forecasts - N Atlantic",
        "nfdhsfep1: High Seas Forecasts - N Pacific",
        "nfdhsfepi: High Seas Forecasts - E and C N Pacific",
        "mimpac: Marine Weather disc for N PAC Ocean",
        "offn09: Marine fsct for WA and ORE Waters",
        "offn08: Marine fcst for N CA Waters",
        "offn07: Marine fcst for S CA Waters",
        "offpz5: Offshore Waters fsct - PAC 1",
        "offpz6: Offshore Waters fsct - PAC 2",
        "nfdoffn35: (VOBRA) for Offshore Waters - WA/OR",
        "nfdoffn36: (VOBRA) for Offshore Waters - CA",
        "mimatn: Marine disc for N Atlantic Ocean",
        "offn01: Navtex Marine fcst for NE US Waters",
        "offn02: Navtex Marine fcst for Atlantic States Waters",
        "offn03: Navtex Marine fcst for SE US Waters",
        "offn04: Navtex Marine fcst for SE Gulf Of Mexico",
        "offn05: Navtex Marine fcst for San Jaun Atlantic Waters",
        "offn06: Navtex Marine fcst for NW Gulf Of Mexico",
        "offnt1: Offshore Waters fsct - ATL 1",
        "offnt2: Offshore Waters fsct - ATL 2",
        "offnt3: Offshore Waters fsct - Caribbean & SW North Atlantic",
        "offnt4: Offshore Waters fsct - Gulf of Mexico",
        "nfdoffn31: (VOBRA) for Offshore Waters - New England",
        "nfdoffn32: (VOBRA) for Offshore Waters - West Central North Atlantic",
        "offajk: Offshore Waters fsct - Eastern Gulf of Alaska",
        "offaer: Offshore Waters fsct - Western Gulf of Alaska",
        "offalu: Offshore Waters fsct - Bering Sea",
        "offafg: Offshore Waters fsct - US Artic Waters",
        "offhfo: Offshore Waters fsct - Hawaii",
        "offn10: Navtex Marine fcst for Hawaii",
        "offn11: Navtex Marine fcst for Kodiak, AK (SE)",
        "offn12: Navtex Marine fcst for Kodiak, AK (N Gulf)",
        "offn13: Navtex Marine fcst for Kodiak, AK (West)",
        "offn14: Navtex Marine fcst for Kodiak, AK (NW)",
        "offn15: Navtex Marine fcst for Kodiak, AK(Arctic)",
        
        "uvicac: NOAA/EPA Ultraviolet Index /UVI/ Forecast",
        "tptwrn: Hourly temp/wx for Western US",
        "tptcrn: Hourly temp/wx for Central US",
        "tptern: Hourly temp/wx for Eastern US",
        "tptnam: Hourly temp/wx for NA Cities",
        
        "rwrmx: Latin America and Caribbean Regional Weather Roundup",
        "tptcan: Canadian temp and precip Table",
        "tptint: Foreign temp and weather table",
        "tptlat: Latin American temp and weather table",
        
        "swomcd: Most recent MCD",
        "swody1: Day 1 Convective Outlook",
        "swody2: Day 2 Convective Outlook",
        "swody3: Day 3 Convective Outlook",
        "swod48: Day 4-8 Convective Outlook",
        "fwddy1: Day 1 Fire Weather Outlook",
        "fwddy2: Day 2 Fire Weather Outlook",
        "fwddy38: Days 3-8 Fire Weather Outlook",
        
        "miatwoat: ATL Tropical Weather Outlook",
        "miatwdat: ATL Tropical Weather Discussion",
        "miatwoep: EPAC Tropical Weather Outlook",
        "miatwdep: EPAC Tropical Weather Discussion",
        "miatwsat: ATL Monthly Tropical Summary",
        "miatwsep: EPAC Monthly Tropical Summary",
        
        "GLFLM: Lake Michigan - Open Lake Forecast",
        "GLFLS: Lake Superior - Open Lake Forecast",
        "GLFLH: Lake Huron - Open Lake Forecast",
        "GLFSC: Lake St Clair - Open Lake Forecast",
        "GLFLE: Lake Erie - Open Lake Forecast",
        "GLFLO: Lake Ontario - Open Lake Forecast",
        "GLFSL: Saint Lawrence River",
        
        "focn45: Significant Weather Discussion, PASPC",
        "fxcn01_d1-3_west: FXCN01 D1-3 WEST",
        "fxcn01_d4-7_west: FXCN01 D4-7 WEST",
        "fxcn01_d1-3_east: FXCN01 D1-3 EAST",
        "fxcn01_d4-7_east: FXCN01 D4-7 EAST",
        "awcn11: Weather Summary S. Manitoba",
        "awcn12: Weather Summary N. Manitoba",
        "awcn13: Weather Summary S. Saskatchewan",
        "awcn14: Weather Summary N. Saskatchewan",
        "awcn15: Weather Summary S. Alberta",
        "awcn16: Weather Summary N. Alberta",
        
        "swpc3day: NOAA Geomagnetic Activity Observation and Forecast",
        "swpc3daygeo: NOAA Geomagnetic Activity Probabilities",
        "swpchigh: Weekly Highlights and Forecasts",
        "swpc27day: 27-day Space Weather Outlook Table",
        "swpcdisc: Forecast Discussion",
        "swpcwwa: Advisory Outlook"
    ]
}
