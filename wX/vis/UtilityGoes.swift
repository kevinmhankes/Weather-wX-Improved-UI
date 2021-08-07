// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Foundation

final class UtilityGoes {

    private static let sizeMap = [
        "CONUS": "1250x750",
        "CONUS-G17": "1250x750",
        "FD": "1808x1808",
        "FD-G17": "1808x1808",
        "gm": "1000x1000",
        "car": "1000x1000",
        "eus": "1000x1000",
        "eep": "2000x2000",
        "wus": "2000x2000",
        "tpw": "1800x1080",
        "taw": "1800x1080",
        "can": "1125x560",
        "mex": "1000x1000",
        "nsa": "1800x1080",
        "ssa": "1800x1080",
        "np": "1800x1080",
        "cam": "1000x1000",
        "np": "1800x1080",
        "ak": "1000x1000",
        "cak": "1200x1200",
        "sea": "1200x1200",
        "hi": "1200x1200"
    ]

    private static func getImageSize(_ sector: String) -> String {
        let size = "latest"
        if UIPreferences.goesUseFullResolutionImages {
            return size
        } else {
            return sizeMap[sector] ?? size
        }
    }
    
    static func getImageGoesFloater(_ url: String, _ product: String) -> String {
        var urlFinal = url
        urlFinal = urlFinal.replace("GEOCOLOR", product)
        return urlFinal
    }

    static func getImage(_ product: String, _ sector: String) -> Bitmap {
        var sectorLocal = "SECTOR/" + sector
        var productLocal = product
        if sector == "FD" || sector == "CONUS" || sector == "CONUS-G17" {
            sectorLocal = sector
        }
        var satellite = "GOES16"
        if sectorsInGoes17.contains(sector) {
            satellite = "GOES17"
            if sector == "CONUS-G17" {
                sectorLocal = "CONUS"
            }
            if sector == "FD-G17" {
                sectorLocal = "FD"
            }
        }
        // https://cdn.star.nesdis.noaa.gov/GOES16/ABI/SECTOR/cgl/03/
        // https://cdn.star.nesdis.noaa.gov/GOES16/ABI/SECTOR/cgl/12/latest.jpg
        // https://cdn.star.nesdis.noaa.gov/GOES17/ABI/CONUS/GEOCOLOR/1250x750.jpg
        // https://cdn.star.nesdis.noaa.gov/GOES16/ABI/CONUS/GEOCOLOR/1250x750.jpg
        // If GLM is selected and user switches to sector w/o GLM show default instead
        if additionalCodes.contains(productLocal) && !sectorsWithAdditional.contains(sector) {
            productLocal = "GEOCOLOR"
        }
        var url = GlobalVariables.goes16Url + "/" + satellite + "/ABI/" + sectorLocal + "/" + productLocal + "/" + getImageSize(sector) + ".jpg"
        if productLocal == "GLM" {
            url = url.replace("ABI", "GLM")
            url = url.replace(sectorLocal + "/GLM", sectorLocal + "/EXTENT")
        }
        let bitmap = Bitmap(url)
        bitmap.info = productLocal
        return bitmap
    }

    // https://www.star.nesdis.noaa.gov/GOES/sector_band.php?sat=G17&sector=ak&band=GEOCOLOR&length=12
    // https://www.star.nesdis.noaa.gov/GOES/sector_band.php?sat=G16&sector=cgl&band=GEOCOLOR&length=12
    static func getAnimation(_ product: String, _ sector: String, _ frameCnt: Int) -> AnimationDrawable {
        let frameCount = String(frameCnt)
        var url: String
        var satellite = "G16"
        if sectorsInGoes17.contains(sector) {
            satellite = "G17"
        }
        switch sector {
        case "FD":
            url = "https://www.star.nesdis.noaa.gov/GOES/GOES16_FullDisk_Band.php?band=" + product.replace("GLM", "EXTENT") + "&length=" + frameCount
        case "CONUS", "CONUS-G17":
            url = "https://www.star.nesdis.noaa.gov/GOES/conus_band.php?sat=" + satellite + "&band=" + product.replace("GLM", "EXTENT") + "&length=" + frameCount
        default:
            url = "https://www.star.nesdis.noaa.gov/GOES/sector_band.php?sat=" + satellite + "&sector=" + sector + "&band=" + product + "&length=" + frameCount
        }
        let html = url.getHtml().replaceAll("\n", "").replaceAll("\r", "")
        let imageHtml = html.parse("animationImages = \\[(.*?)\\];")
        let imageUrls = imageHtml.parseColumn("'(https.*?jpg)'")
        // let bitmaps = imageUrls.map { Bitmap($0) }
        var bitmaps = [Bitmap](repeating: Bitmap(), count: imageUrls.count)
        let dispatchGroup = DispatchGroup()
        for (index, url) in imageUrls.enumerated() {
            dispatchGroup.enter()
            DispatchQueue.global().async {
                bitmaps[index] = Bitmap(url)
                dispatchGroup.leave()
            }
        }
        dispatchGroup.wait()
        return UtilityImgAnim.getAnimationDrawableFromBitmapList(bitmaps)
    }
    
//    static List<String> getAnimation(String product, String sector, int frameCount) {
//        String baseUrl = UtilityGoes.getImage(product, sector)
//        String[] items = baseUrl.split("/")
//        baseUrl = String.join("/", items[0..-3]) + "/" + product + "/"
//        String html = UtilityIO.getHtml(baseUrl)
//        List<String> urlList = UtilityString.parseColumn(html.replace("\r\n", " "), "<a href=\"([^\\s]*?1200x1200.jpg)\">")
//        List<String> returnList = []
//        if (urlList.size() > frameCount) {
//            int s = -1 * frameCount
//            for (u in urlList[s..-1]) {
//                returnList.add(baseUrl + u)
//            }
//        }
//        return returnList
//        // <a href="20211842100_GOES16-ABI-FL-GEOCOLOR-AL052021-1000x1000.jpg">
//    }
    
    static func getAnimationGoesFloater(_ product: String, _ url: String, _ frameCount: Int) -> AnimationDrawable {
        var baseUrl = url
        baseUrl = baseUrl.replace("GEOCOLOR", product).replace("latest.jpg", "")
        let html = baseUrl.getHtml()
        let urlList = UtilityString.parseColumn(html.replace("\r\n", " "), "<a href=\"([^\\s]*?1000x1000.jpg)\">")
        var returnList = [String]()
        if urlList.count > frameCount {
            // let s = -1 * frameCount
            for u in urlList[(urlList.count - frameCount)..<urlList.count] {
                returnList.append(baseUrl + u)
            }
        }
        let bitmaps = returnList.map { Bitmap($0) }
        return UtilityImgAnim.getAnimationDrawableFromBitmapList(bitmaps)
    }

//    static func getNearestGoesLocation(location: LatLon) -> String {
//        var shortestDistance = 1000.00
//        var currentDistance = 0.0
//        var bestIndex = ""
//        sectorToLatLon.keys.forEach { key in
//            currentDistance = LatLon.distance(location, sectorToLatLon[key] ?? LatLon(), DistanceUnit.MILES)
//            if currentDistance < shortestDistance {
//                    shortestDistance = currentDistance
//                    bestIndex = key
//            }
//        }
//        if bestIndex == "" {
//            return "BLAH"
//        }
//        return bestIndex
//    }

    static let sectors = [
        "FD: GOES-EAST Full Disk",
        "FD-G17: GOES-WEST Full Disk",
        "CONUS: GOES-EAST US",
        "CONUS-G17: GOES-WEST US",
        "pnw: Pacific Northwest",
        "nr: Northern Rockies",
        "umv: Upper Mississippi Valley",
        "cgl: Central Great Lakes",
        "ne: Northeast",
        "psw: Pacific Southwest",
        "sr: Southern Rockies",
        "sp: Southern Plains",
        "smv: Southern Mississippi Valley",
        "se: Southeast",
        "gm: Gulf of Mexico",
        "car: Caribbean",
        "eus: U.S. Atlantic Coast",
        "pr: Puerto Rico",
        "taw: Tropical Atlantic: wide view",
        "ak: Alaska",
        "cak: Central Alaska",
        "sea: Southeastern Alaska",
        "hi: Hawaii",
        "tpw: US Pacific Coast",
        "wus: Tropical Pacific",
        "eep: Eastern Pacific",
        "np: Northern Pacific",
        "can: Canada",
        "mex: Mexico",
        "nsa: South America (north)",
        "ssa: South America (south)"
    ]

    static let sectorsWithAdditional = [
        "CONUS",
        "CONUS-G17",
        "FD",
        "FD-G17"
    ]

    private static let sectorsInGoes17 = [
        "CONUS-G17",
        "FD-G17",
        "ak",
        "cak",
        "sea",
        "hi",
        "pnw",
        "psw",
        "tpw",
        "wus",
        "np"
    ]

    static let labels = [
        "True color daytime, multispectral IR at night",
        "00.47 um (Band 1) Blue - Visible",
        "00.64 um (Band 2) Red - Visible",
        "00.86 um (Band 3) Veggie - Near IR",
        "01.37 um (Band 4) Cirrus - Near IR",
        "01.6 um (Band 5) Snow/Ice - Near IR",
        "02.2 um (Band 6) Cloud Particle - Near IR",
        "03.9 um (Band 7) Shortwave Window - IR",
        "06.2 um (Band 8) Upper-Level Water Vapor - IR",
        "06.9 um (Band 9) Mid-Level Water Vapor - IR",
        "07.3 um (Band 10) Lower-level Water Vapor - IR",
        "08.4 um (Band 11) Cloud Top - IR",
        "09.6 um (Band 12) Ozone - IR",
        "10.3 um (Band 13) Clean Longwave Window - IR",
        "11.2 um (Band 14) Longwave Window - IR",
        "12.3 um (Band 15) Dirty Longwave Window - IR",
        "13.3 um (Band 16) CO2 Longwave - IR",
        "AirMass - RGB composite based on the data from IR and WV",
        "Sandwich RGB - Bands 3 and 13 combo",
        "Day Cloud Phase",
        "Night Microphysics"
    ]

    static let additionalLabels = [
        "GLM FED+GeoColor",
        "DMW"
    ]

    static let additionalCodes = [
        "GLM",
        "DMW"
    ]

    static let codes = [
        "GEOCOLOR",
        "01",
        "02",
        "03",
        "04",
        "05",
        "06",
        "07",
        "08",
        "09",
        "10",
        "11",
        "12",
        "13",
        "14",
        "15",
        "16",
        "AirMass",
        "Sandwich",
        "DayCloudPhase",
        "NightMicrophysics",
        "GLM",
        "DMW"
    ]

//    static let sectorToLatLon = [
//        "cgl": LatLon(39.123405, -82.532938), // cgl wellston, Oh
//        "ne": LatLon(39.360611, -74.431877), // ne Atlantic City, NJ
//        "umv": LatLon(40.622777, -93.934116), // umv  Lamoni, IA
//        "pnw": LatLon(41.589703, -119.858865), // pnw Vya, NV
//        "psw": LatLon(38.524448, -118.623611), // psw Hawthorne, NV
//        "nr": LatLon(41.139980, -104.820244), // nr   Cheyenne, Wy
//        "sr": LatLon(34.653376, -108.677852), // sr Fence Lake, NM
//        "sp": LatLon(31.463787, -96.058022), // sp Buffalo, TX
//        "smv": LatLon(31.326460, -89.289658), // smv Hattiesburg, MS
//        "se": LatLon(30.332184, -81.655647) // se Jacksonville, FL
//    ]
}
