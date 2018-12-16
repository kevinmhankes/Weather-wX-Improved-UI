/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityLightning {

    static let sectorList = [
        "US",
        "Florida",
        "Texas",
        "OK / KS",
        "North America",
        "South America",
        "Australia",
        "New Zealand"
    ]

    static let timeList = [
        "15 MIN",
        "2 HR",
        "12 HR",
        "24 HR",
        "48 HR"
        ]

    static func getImage(_ sector: String, _ period: String) -> Bitmap {
        let url: String
        if sector.contains("goes") {
            let sectorCode = sector.split("_")[1]
            let html = ("https://weather.msfc.nasa.gov/cgi-bin/sportPublishData.pl?dataset=goes16glm&product=group&loc="
                + sectorCode).getHtml()
            url = "https://weather.msfc.nasa.gov"
                + html.parse("SRC=.(/sport/dynamic/goes16/glm/" + sectorCode + "/sport_goes16_glm_"
                    + sectorCode + "_group_[0-9]{8}_[0-9]{4}.png)")
        } else {
            let baseUrl = "http://images.lightningmaps.org/blitzortung/america/index.php?map="
            let baseUrlOceania = "http://images.lightningmaps.org/blitzortung/oceania/index.php?map="
            if sector.contains("australia") || sector.contains("new_zealand") {
                url = baseUrlOceania + sector + "&period=" + period
            } else {
                url = baseUrl + sector + "&period=" + period
            }
        }
        return Bitmap(url)
    }

    static func getSectorPretty(_ sector: String) -> String {
        let sectorPretty: String
        switch sector {
        case "usa_big":             sectorPretty = "US"
        case "florida_big":         sectorPretty = "Florida"
        case "texas_big":           sectorPretty = "Texas"
        case "oklahoma_kansas_big": sectorPretty = "OK / KS"
        case "north_middle_america":sectorPretty = "North America"
        case "south_america":       sectorPretty = "South America"
        case "australia_big":       sectorPretty = "Australia"
        case "new_zealand_big":     sectorPretty = "New Zealand"
        default: sectorPretty = ""
        }
        return sectorPretty
    }

    static func getSector(_ sectorPretty: String) -> String {
        let sector: String
        switch sectorPretty {
        case  "US":                                 sector = "usa_big"
        case "Florida" :                            sector = "florida_big"
        case "Texas":                               sector = "texas_big"
        case "OK / KS":                             sector = "oklahoma_kansas_big"
        case "North America":                       sector = "north_middle_america"
        case "South America":                       sector = "south_america"
        case "Australia":                           sector = "australia_big"
        case "New Zealand":                         sector = "new_zealand_big"
        default: sector = ""
        }
        return sector
    }

    // FIXME obsolete this and above with a list of short time codes
    static func getTimePretty(_ period: String) -> String {
        let periodPretty: String
        switch period {
        case "0.25": periodPretty = "15 MIN"
        case "2":    periodPretty = "2 HR"
        case "12":   periodPretty = "12 HR"
        case "24":   periodPretty = "24 HR"
        case "48":   periodPretty = "48 HR"
        default: periodPretty = ""
        }
        return periodPretty
    }

    static func getTime(_ periodPretty: String) -> String {
        let period: String
        switch periodPretty {
        case "15 MIN": period = "0.25"
        case "2 HR":    period = "2"
        case "12 HR":   period = "12"
        case "24 HR":   period = "24"
        case "48 HR":   period = "48"
        default: period = ""
        }
        return period
    }
}
