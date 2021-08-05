// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

final class UtilityLightning {
    
    static let sectors = [
        "US",
        "Florida",
        "Texas",
        "OK / KS",
        "North America",
        "South America",
        "Australia",
        "New Zealand"
    ]
    
    static let times = [
        "15 MIN",
        "2 HR",
        "12 HR",
        "24 HR",
        "48 HR"
    ]
    
    static func getImageUrl(_ sector: String, _ period: String) -> String {
        let url: String
        if sector.contains("goes") {
            let sectorCode = sector.split("_")[1]
            let html = ("https://weather.msfc.nasa.gov/cgi-bin/sportPublishData.pl?dataset=goes16glm&product=group&loc=" + sectorCode).getHtml()
            url = "https://weather.msfc.nasa.gov" + html.parse("SRC=.(/sport/dynamic/goes16/glm/" + sectorCode + "/sport_goes16_glm_" + sectorCode + "_group_[0-9]{8}_[0-9]{4}.png)")
        } else {
            let baseUrl = "https://images.lightningmaps.org/blitzortung/america/index.php?map="
            let baseUrlOceania = "https://images.lightningmaps.org/blitzortung/oceania/index.php?map="
            if sector.contains("australia") || sector.contains("new_zealand") {
                url = baseUrlOceania + sector + "&period=" + period
            } else {
                url = baseUrl + sector + "&period=" + period
            }
        }
        return url
    }
    
    static func getSectorLabel(_ code: String) -> String {
        switch code {
        case "usa_big":
            return "US"
        case "florida_big":
            return "Florida"
        case "texas_big":
            return "Texas"
        case "oklahoma_kansas_big":
            return "OK / KS"
        case "north_middle_america":
            return "North America"
        case "south_america":
            return "South America"
        case "australia_big":
            return "Australia"
        case "new_zealand_big":
            return "New Zealand"
        default:
            return ""
        }
    }
    
    static func getSector(_ sector: String) -> String {
        switch sector {
        case "US":
            return "usa_big"
        case "Florida" :
            return "florida_big"
        case "Texas":
            return "texas_big"
        case "OK / KS":
            return "oklahoma_kansas_big"
        case "North America":
            return "north_middle_america"
        case "South America":
            return "south_america"
        case "Australia":
            return "australia_big"
        case "New Zealand":
            return "new_zealand_big"
        default:
            return ""
        }
    }
    
    static func getTimeLabel(_ period: String) -> String {
        switch period {
        case "0.25":
            return "15 MIN"
        case "2":
            return "2 HR"
        case "12":
            return "12 HR"
        case "24":
            return "24 HR"
        case "48":
            return "48 HR"
        default:
            return ""
        }
    }
    
    static func getTime(_ periodPretty: String) -> String {
        switch periodPretty {
        case "15 MIN":
            return "0.25"
        case "2 HR":
            return "2"
        case "12 HR":
            return "12"
        case "24 HR":
            return "24"
        case "48 HR":
            return "48"
        default:
            return ""
        }
    }
}
