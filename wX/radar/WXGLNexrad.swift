/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class WXGLNexrad {
    
    static var wxoglDspLegendMax = 0.0

    static func getRadarTimeStamp() -> String {
        let radarTimeStamp = getRadarInfo("")
        var radarTimeFinal = ""
        if radarTimeStamp != "" {
            var radarTimeFinalWithDate = ""
            let radarTimeSplit = radarTimeStamp.split(MyApplication.newline)
            if radarTimeSplit.count > 0 {
                radarTimeFinalWithDate = radarTimeSplit[0]
                let radarTimeFinalWithDateInParts = radarTimeFinalWithDate.split(" ")
                if radarTimeFinalWithDateInParts.count > 1 {
                    radarTimeFinal = radarTimeFinalWithDateInParts[1]
                }
            }
        }
        return radarTimeFinal
    }

    static func canTilt(_ product: String) -> Bool {
        if product == "L2REF" || product == "L2VEL" {
            return false
        }
        if product.matches(regexp: "[A-Z][0-3][A-Z]") || product.matches(regexp: "T[RV][0-2]") {
            return true
        } else {
            return false
        }
    }

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
        "NSW: Base Spectrum Width",
        "NCR: Composite Reflectivity 124nm",
        "NCZ: Composite Reflectivity 248nm"
    ]

    // To add products in this file means also adding entries in global/GlobalDictionaries.swift and global/ColorPalettes.swift

    // https://www1.ncdc.noaa.gov/pub/data/radar/RadarProductsDetailedTable.pdf
    // https://www.ncdc.noaa.gov/data-access/radar-data/tdwr
    // https://www.ncdc.noaa.gov/data-access/radar-data/tdwr/tdwr-products
    // SPG https://www.roc.noaa.gov/spg/default.aspx

    /*
 
     From the URL above
     
     TDWR Level-III Products
     There are 26 TDWR Level-III products routinely available from NCEI. Most Level-III products are available as digital images, color hard copy, gray scale hard copy, or acetate overlay copies. Each copy will include state, county, and city background maps. The Certification of Data page has further information on hard copy radar products, pricing, and certification information. A Detailed List of Level-III Product Codes is also available.
     
     Brief descriptions and possible uses of these products are included below.
     
     General Products
     
     General products include Base Reflectivity and Base Velocity as well as graphical products derived from algorithms including Spectrum Width, Vertically Integrated Liquid, and the Velocity Azimuth Display (VAD) Wind Profile.
     
     Digital Base Reflectivity (TR0, TR1, TR2/181)
     A display of echo intensity measured in dBZ. These products are used to detect precipitation, evaluate storm structure, locate boundaries, and determine hail potential. The three lowest elevations angles are available, with a maximum range of 48 nm.
     
     Digital Base Velocity (TV0, TV1, TV2/182)
     A measure of the radial component of the wind either toward the radar (negative values) or away from the radar (positive values). Cool colors (green) represent negative values and warm colors (red) represent positive values. These products are used to estimate wind speed and direction, locate boundaries, locate severe weather signatures, and identify suspected areas of turbulence. The three lowest elevations angles are available, with a maximum range of 48 nm.
     
     Long Range Digital Base Reflectivity (TZL/186)
     Digital Reflectivity data are measured at an elevation angle of 0.6 degrees with a maximum range of 225 nm.
     
     Composite Reflectivity (NCR/37)
     A display of maximum reflectivity for the total volume within the range of the radar. This product is used to reveal the highest reflectivities in all echoes, examine storm structure features, and determine intensity of storms.
     
     Vertically Integrated Liquid (NVL/57)
     The water content of a 2.2 x 2.2 nm column of air, which is color-coded and plotted on a 124-nm map. This product is used as an effective hail indicator, to locate most significant storms, and to identify areas of heavy rainfall.
     
     Echo Tops (NET/41)
     An image of the echo top heights color-coded in user-defined increments. This product is used for a quick estimation of the most intense convection and higher echo tops, as an aid in identification of storm structure features, and for pilot briefing purposes.
     
     VAD Wind Profile (NVW/48)
     A graphic display of wind barbs plotted on a height staff in 500-ft or 1,000-ft increments. The current (far right) and up to 10 previous plots may be displayed simultaneously. This product is an excellent tool for meteorologists in weather forecasting, severe weather, and aviation.
     Precipitation Products
     
     Precipitation products are estimated ground accumulated rainfall. Estimates are based on a reflectivity and rainfall rate relationship called Z-R.
     
     One-Hour Precipitation (N1P/78)
     A display of estimated one hour precipitation accumulation on a 1.1-nm x 1-degree grid using the Precipitation Processing System (PPS) algorithm. This product is used to assess rainfall intensities for flash flood warnings, urban flood statements, and special weather statements.
     
     Storm Total Precipitation (NTP/80)
     The estimated storm total precipitation accumulation on a 1.1-nm x 1-degree grid continuously updated since the precipitation event began. This product uses the PPS algorithm. This product is used to locate flood potential over urban or rural areas, estimate total basin runoff, and provide rainfall data 24 hours a day.
     
     Digital Precipitation Array (DPA/81)
     An array format of estimated one-hour precipitation accumulations on the 1/4 LFM (4.7625 km HRAP) grid. This is an 8-bit product with 255 possible precipitation values. This product is used to assess rainfall intensities for flash flood warnings, urban flood statements, and special weather statements.
     Overlay Products
     
     Overlay products provide detailed information for identified storm cells.
     
     Storm Structure (NSS/62)
     A table displaying information on storm attributes, which include maximum reflectivity, maximum velocity at lowest elevation angle, storm overhang, mass weighted storm volume, storm area base and top, storm position, and storm tilt.
     
     Hail Index (NHI/59)
     A product designed to locate storms that have the potential to produce hail. Hail potential is labeled as either probable (hollow green triangle) or positive (filled green triangle). Probable means the storm is probably producing hail and positive means the storm is producing hail.
     
     Digital Mesocyclone Detection Algorithm (NMD/141)
     This product is designed to display information regarding the existence and nature of rotations associated with thunderstorms. Numerical output includes azimuth, range, and height of the mesocyclone.
     
     Tornadic Vortex Signature (NTV/61)
     A product that shows an intense gate-to-gate azimuthal shear associated with tornadic-scale rotation. It is depicted by a red triangle with numerical output of location and height.
     
     Storm Tracking Information (NST/58)
     A product that shows a plot of the past hour's movement, current location, and forecast movement for the next hour or less for each identified thunderstorm cell. This product is used to determine reliable storm movement.
     Radar Messages
     
     Radar messages provide information about the radar status and special product data.
     
     General Status Message (GSM/2)
     A text message describing the status of the radar site. A reason may be provided if the radar is not transmitting.
     
     Free Text Message (FTM/5)
     A text message describing an upcoming, ongoing, or completed event at the radar site, including downtime, maintenance, and more.
     
     Radar Status Log (RSL/152)
     A running daily log of status, errors, and messages from the Radar Product Generator (RPG) and Radar Data Acquisition (RDA) processing systems.
     
    */

    static var radarProductListTdwr = [
        "TZL: Long Range Digital Base Reflectivity",
        "TZ0: Digital Base Reflectivity",
        "TV0: Digital Base Velocity"
    ]

    static func getNumberRangeBins(_ productCode: Int) -> Int {
        switch productCode {
        case 134: return 460
        case 186: return 1390
        case 78: return 592
        case 80: return 592
        case 180: return 720
        case 181: return 720
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
        let binSize110 = 2.0 * binSize54
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
        case 78: return binSize110
        case 80: return binSize110
        case 180: return binSize08
        case 181: return binSize08
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

    static func getRadarInfo(_ pane: String) -> String {
        return Utility.readPref("WX_RADAR_CURRENT_INFO" + pane, "")
    }

    static func writeRadarInfo(_ pane: String, _ info: String) {
        Utility.writePref("WX_RADAR_CURRENT_INFO" + pane, info)
    }
}
