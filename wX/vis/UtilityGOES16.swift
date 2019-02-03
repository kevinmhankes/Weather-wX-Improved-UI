/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityGOES16 {

    static let sizeMap = [
        "CONUS": "2500x1500",
        "FD": "1808x1808",
        "gm": "1000x1000",
        "car": "1000x1000",
        "eus": "1000x1000",
        "taw": "1800x1080"
    ]

    static func getImageSize(_ product: String, _ sector: String) -> String {
        let size = "1200x1200"
        return sizeMap[sector] ?? size
    }

    static func getImage(_ product: String, _ sector: String) -> Bitmap {
        var sectorLocal = "SECTOR/" + sector
        if sector == "FD" || sector == "CONUS" {
            sectorLocal = sector
        }
        // https://cdn.star.nesdis.noaa.gov/GOES16/ABI/SECTOR/cgl/03/
        // https://cdn.star.nesdis.noaa.gov/GOES16/ABI/SECTOR/cgl/12/latest.jpg
        return Bitmap(MyApplication.goes16Url + "/GOES16/ABI/" + sectorLocal + "/" + product + "/latest.jpg")
    }

    static func getAnimation(_ product: String, _ sector: String, _ frameCnt: Int) -> AnimationDrawable {
        let frameCount = String(frameCnt)
        var url: String
        switch sector {
        case "FD": url = "https://www.star.nesdis.noaa.gov/GOES/GOES16_FullDisk_Band.php?band="
            + product + "&length=" + frameCount
        case "CONUS": url = "https://www.star.nesdis.noaa.gov/GOES/GOES16_CONUS_Band.php?band="
            + product + "&length=" + frameCount
        default: url = "https://www.star.nesdis.noaa.gov/GOES/GOES16_sector_band.php?sector="
            + sector + "&band=" + product + "&length=" + frameCount
        }
        let html = url.getHtml().replaceAll("\n", "").replaceAll("\r", "")
        let imageHtml = html.parse("animationImages = \\[(.*?)\\];")
        let imageUrls = imageHtml.parseColumn("'(https.*?jpg)'")
        let bitmaps = imageUrls.map {Bitmap($0)}
        return UtilityImgAnim.getAnimationDrawableFromBitmapList(bitmaps, UtilityImg.getAnimInterval())
    }

    static let sectors = [
        "FD: Full Disk",
        "CONUS: US",
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
        "taw: Tropical Atlantic: wide view"
    ]

    static let products = [
        "00 True color daytime, multispectral IR at night": "00GEOCOLOR",
        "00.47 um (Band 1) Blue - Visible": "01",
        "00.64 um (Band 2) Red - Visible": "02",
        "00.86 um (Band 3) Veggie - Near IR": "03",
        "01.37 um (Band 4) Cirrus - Near IR": "04",
        "01.6 um (Band 5) Snow/Ice - Near IR": "05",
        "02.2 um (Band 6) Cloud Particle - Near IR": "06",
        "03.9 um (Band 7) Shortwave Window - IR": "07",
        "06.2 um (Band 8) Upper-Level Water Vapor - IR": "08",
        "06.9 um (Band 9) Mid-Level Water Vapor - IR": "09",
        "07.3 um (Band 10) Lower-level Water Vapor - IR": "10",
        "08.4 um (Band 11) Cloud Top - IR": "11",
        "09.6 um (Band 12) Ozone - IR": "12",
        "10.3 um (Band 13) Clean Longwave Window - IR": "13",
        "11.2 um (Band 14) Longwave Window - IR": "14",
        "12.3 um (Band 15) Dirty Longwave Window - IR": "15",
        "13.3 um (Band 16) CO2 Longwave - IR": "16"
    ]

    static let productCodes = [
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
        "16"
    ]
}
