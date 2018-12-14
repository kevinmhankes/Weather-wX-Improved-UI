/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityCanada {

    static let products = [
        "focn45: Significant Weather Discussion, PASPC",
        "fxcn01: FXCN01",
        "awcn11: Weather Summary S. Manitoba",
        "awcn12: Weather Summary N. Manitoba",
        "awcn13: Weather Summary S. Saskatchewan",
        "awcn14: Weather Summary N. Saskatchewan",
        "awcn15: Weather Summary S. Alberta",
        "awcn16: Weather Summary N. Alberta"
        ]

    static let provList = [
        "AB: Alberta",
        "BC: British Columbia",
        "MB: Manitoba",
        "NB: New Brunswick",
        "NL: Newfoundland and Labrador",
        "NS: Nova Scotia",
        "NT: Northwest Territories",
        "NU: Nunavut",
        "ON: Ontario",
        "PE: Prince Edward Island",
        "QC: Quebec",
        "SK: Saskatchewan",
        "YT: Yukon"
        ]

    static let provHash = [
        "AB": "PAC",
        "BC": "PAC",
        "MB": "PAC",
        "NB": "ERN",
        "NL": "ERN",
        "NS": "ERN",
        "NT": "CAN",
        "NU": "CAN",
        "ON": "ONT",
        "PE": "ERN",
        "QC": "ERN",
        "SK": "PAC",
        "YT": "CAN"
        ]

    static let provCodes = [
        "bcstorm: British Columbia",
        "abstorm: Alberta",
        "skstorm: Saskatchewan",
        "mbstorm: Manitoba",
        "onstorm: Ontario",
        "meteoqc: Quebec",
        "nbstorm: New Brunswick",
        "pestorm: Prince Edward Island",
        "nsstorm: Nova Scotia",
        "ntstorm: North West Territories",
        "nlwx: Newfoundland"
        ]

    static func getIcons7DayAsList(_ html: String) -> [String] {
        let days = html.split(MyApplication.newline + MyApplication.newline)
        return days.map {translateIconName($0)}
    }

    static func translateIconName(_ s: String) -> String {
        var newName = ""
        if s.contains("reezing rain or snow")
            || s.contains("chance of flurries and risk of freezing drizzle")
            || s.contains("chance of flurries before morning with risk of freezing drizzle")
            || s.contains("Periods of freezing drizzle or flurries")
            || s.contains("Flurries or freezing drizzle") {
            newName = "fzra_sn"
        } else if s.contains("eriods of freezing drizzle")
            || s.contains("reezing Drizzle")
            || s.contains("reezing drizzle")
            || s.contains("reezing rain")
            || s.contains("isk of freezing drizzle") {
            newName = "fzra"
        } else if s.contains("Ice Crystals") || s.contains("ice pellets") {
            newName = "ip"
        } else if s.contains("hundershowers") || s.contains("hunderstorm") {
            newName = "scttsra"
        } else if s.contains("hance of rain showers or flurries")
            || s.contains("lurries or rain showers")
            || s.contains(" few rain showers or flurries")
            || s.contains("ain or snow")
            || s.contains("eriods of rain or snow")
            || s.contains("now or rain")
            || s.contains("ain changing to snow")
            || s.contains("ain showers or flurries")
            || s.contains("ain changing to periods of snow")
            || s.contains("now changing to periods of rain")
            || s.contains("Rain at times heavy changing to snow")
            || s.contains("Snow changing to periods of drizzle")
            || s.contains("Rain at times mixed with wet snow") {
            newName = "ra_sn"
        } else if s.contains("hance of showers") || s.contains("howers") {
            newName = "shra"
        } else if s.contains("hance of rain")
            || s.contains("Rain beginning")
            || s.contains("eriods of drizzle changing to rain at times")
            || s.contains("Rain at times heavy") {
            newName = "ra"
        } else if s.contains("hance of flurries")
            || s.contains("hance of snow")
            || s.contains("eriods of snow")
            || s.contains(" few flurries")
            || s.contains("eriods of light snow")
            || s.contains("Flurries")
            || s.contains("Snow")
            || s.contains("then snow")
            || s.contains("ight snow") {
            newName = "sn"
        } else if s.contains("A few showers")
            || s.contains("eriods of rain")
            || s.contains("drizzle") {
            newName = "hi_shwrs"
        } else if s.contains("Increasing cloudiness") || s.contains("Cloudy periods") {
            newName = "bkn"
        } else if s.contains("Mainly sunny") || s.contains("A few clouds") {
            newName = "few"
        } else if s.contains("loudy")
            || s.contains("Mainly cloudy")
            || s.contains("Overcast") {
            newName = "ovc"
        } else if s.contains("A mix of sun and cloud")
            || s.contains("Partly cloudy")
            || s.contains("Clearing") {
            newName = "sct"
        } else if s.contains("Clear") || s.contains("Sunny") {
            newName = "skc"
        } else if s.contains("Blizzard")
            || s.contains("Local blowing snow") {
            newName = "blizzard"
        } else if s.contains("Rain") {
            newName = "ra"
        } else if s.contains("Mist")
            || s.contains("Fog")
            || s.contains("Light Drizzle") {
            newName = "fg"
        }
        if s.contains("night") {
            if newName.contains("hi_") {
                newName = newName.replace("hi_", "hi_n")
            } else {
                newName = "n" + newName
            }
        }
        if s.contains("percent") {
            let pop = s.parse("([0-9]{2}) percent")
            newName += "," + pop
        }
        return newName
    }

    static func translateIconNameCurrentConditions(_ s: String, _ day1: String) -> String {
        var newName = ""
        if s.contains("eriods of freezing drizzle")
            || s.contains("Freezing Drizzle")
            || s.contains("Freezing Rain") {
            newName = "fzra"
        } else if s.contains("hundershowers") || s.contains("hunderstorm") {
            newName = "scttsra"
        } else if s.contains("Haze") {
            newName = "fg"
        } else if s.contains("hance of rain showers or flurries")
            || s.contains("lurries or rain showers")
            || s.contains(" few rain showers or flurries")
            || s.contains("ain or snow")
            || s.contains("ain and Snow")
            || s.contains("eriods of rain or snow")
            || s.contains("now or rain") {
            newName = "ra_sn"
        } else if s.contains("hance of showers") || s.contains("Showers") {
            newName = "shra"
        } else if s.contains("hance of rain") {
            newName = "ra"
        } else if s.contains("A few showers") || s.contains("eriods of rain")
            || s.contains("drizzle") {
            newName = "hi_shwrs"
        } else if s.contains("Blizzard")
            || s.contains("Blowing Snow")
            || s.contains("Drifting Snow") {
            newName = "blizzard"
        } else if s.contains("hance of flurries")
            || s.contains("hance of snow")
            || s.contains("eriods of snow")
            || s.contains(" few flurries")
            || s.contains("eriods of light snow")
            || s.contains("Flurries")
            || s.contains("Snow")
            || s.contains("ight snow") {
            newName = "sn"
        } else if s.contains("Increasing cloudiness") || s.contains("Cloudy periods") {
            newName = "bkn"
        } else if s.contains("Mainly sunny")
            || s.contains("A few clouds")
            || s.contains("Mainly Sunny")
            || s.contains("Mainly Clear") {
            newName = "few"
        } else if s.contains("Cloudy")
            || s.contains("Mainly cloudy")
            || s.contains("Overcast") {
            newName = "ovc"
        } else if s.contains("A mix of sun and cloud")
            || s.contains("Partly cloudy")
            || s.contains("Clearing") {
            newName = "sct"
        } else if s.contains("Clear") || s.contains("Sunny") {
            newName = "skc"
        } else if s.contains("Rain") {
            newName = "ra"
        } else if s.contains("Mist")
            || s.contains("Fog")
            || s.contains("Light Drizzle") {
            newName = "fg"
        } else if s.contains("Ice Crystals")
            || s.contains("Ice Pellets") {
            newName = "ip"
        }
        let time = day1.parse(" ([0-9]{1,2}:[0-9]{2} [AP]M) ")
        var timeArr = time.split(":")
        var hour: Int
        var daytime = true
        if timeArr.count>0 {
            hour = Int(timeArr[0]) ?? 0
            if time.contains("AM") {
                if hour < 8 {daytime = false}
            }
            if time.contains("PM") {
                if hour == 12 {hour = 0}
                if hour > 6 {daytime = false}
            }
        }
        if !daytime {
            if newName.contains("hi_") {
                newName = newName.replace("hi_", "hi_n")
            } else {
                newName = "n" + newName
            }
        }
        if s.contains("percent") {
            let pop = s.parse("([0-9]{2}) percent")
            newName += "," + pop
        }
        return newName
    }

    static func getProvHtml(_ prov: String) -> String {
        return ("http://weather.gc.ca/forecast/canada/index_e.html?id=" + prov).getHtmlSep()
    }

    static func getLocationHtml(_ location: LatLon) -> String {
        let prov = location.latString.split(":")
        let id = location.lonString.split(":")
        return ("http://weather.gc.ca/rss/city/" + prov[1].lowercased() + "-" + id[0] + "_e.xml").getHtmlSep()
    }

    static func getLocationUrl(_ x: String, _ y: String ) -> String {
        let prov = x.split(":")
        let id = y.split(":")
        return "http://weather.gc.ca/city/pages/" + prov[1].lowercased() + "-" + id[0] + "_metric_e.html"
    }

    static func getStatus(_ html: String) -> String {return html.parse("<b>Observed at:</b>(.*?)<br/>")}

    static func getRid(_ x: String, _ y: String) -> String {
        let url = "http://weather.gc.ca/city/pages/"
            + x.split(":")[1].lowercased()
            + "-"
            + y.split(":")[0]
            + "_metric_e.html"
        let html = url.getHtmlSep()
        let rid = html.parse("<a href=./radar/index_e.html.id=([a-z]{3})..*?>Weather Radar</a>").uppercased()
        return rid
    }

    static func getConditions(_ html: String) -> String {
        let sum = html.parse("<b>Condition:</b> (.*?) <br/>.*?<b>Pressure.*?:</b> .*? kPa.*?<br/>")
        let pressure = html.parse("<b>Condition:</b> .*? <br/>.*?<b>Pressure.*?:</b> (.*?) kPa.*?<br/>")
        let vis = html.parse("<b>Visibility:</b> (.*?)<br/>")
            .replaceAll("<.*?>", "")
            .replaceAll("\\s+", "")
            .replace(" miles", "mi")
        let temp = html
            .parse("<b>Temperature:</b> (.*?)&deg;C <br/>.*?<b>Humidity:</b> .*? %<br/>.*?<b>Dewpoint:</b> .*?&deg;C <br/>")
        let relativeHumdity = html
            .parse("<b>Temperature:</b> .*?&deg;C <br/>.*?<b>Humidity:</b> (.*?) %<br/>.*?<b>Dewpoint:</b> .*?&deg;C <br/>")
        let dew = html
            .parse("<b>Temperature:</b> .*?&deg;C <br/>.*?<b>Humidity:</b> .*? %<br/>.*?<b>Dewpoint:</b> (.*?)&deg;C <br/>")
        let wind = html
            .parse("<b>Wind:</b> (.*?)<br/>").replace(MyApplication.newline, "")
        return temp
            + MyApplication.degreeSymbol
            +  " / "
            + dew
            + MyApplication.degreeSymbol
            + " ("
            + relativeHumdity
            + "%) - "
            + pressure
            + "kPa - "
            + wind
            + " - "
            + vis
            + " - "
            + sum
            + " "
    }

    static func get7Day(_ html: String) -> String {
        let resultList = html
            .parseColumn("<category term=\"Weather Forecasts\"/>.*?<summary type=\"html\">(.*?\\.) Forecast.*?</summary>")
        var tmpStr = ""
        var sb2 = ""
        var resultListDay = html.parseColumn("<title>(.*?)</title>")
        resultListDay = resultListDay.filter {!$0.contains("Current Conditions")}
        resultListDay = resultListDay.filter {$0.contains(":")}
        resultListDay.enumerated().forEach { idx, value in
            tmpStr = value.split(":")[0] + ": " + resultList[idx]
            sb2 += tmpStr + MyApplication.newline + MyApplication.newline
        }
        return sb2
    }

    static func getHazards(_ html: String) -> (String, String) {
        let baseUrl = "http://weather.gc.ca"
        var result: (String, String) = ("", "")
        var urls = html.parseColumn("<div id=\"statement\" class=\"floatLeft\">.*?<a href=\"(.*?)\">.*?</a>.*?</div>")
        var titles = html.parseColumn("<div id=\"statement\" class=\"floatLeft\">.*?<a href=\".*?\">(.*?)</a>.*?</div>")
        let statementUrl = UtilityArray.joinArrayWithDelim(urls, "")
        let statement = UtilityArray.joinArrayWithDelim(titles, "<BR>")
        var chunk = html.parse("<entry>(.*?)<category term=\"Warnings and Watches\"/>")
        urls = chunk.parseColumn("<title>.*?</title>.*?<link type=\"text/html\" href=\"(.*?)\"/>")
        titles = chunk.parseColumn("<title>(.*?)</title>.*?<link type=\"text/html\" href=\".*?\"/>")
        let warningUrl = UtilityArray.joinArrayWithDelim(urls, ",")
        let warning = UtilityArray.joinArrayWithDelim(titles, "<BR>")
        chunk = html.parse("<div id=\"watch\" class=\"floatLeft\">(.*?)</div>")
        urls = chunk.parseColumn("<a href=\"(.*?)\">.*?</a>")
        titles = chunk.parseColumn("<a href=\".*?\">(.*?)</a>")
        let watchUrl = UtilityArray.joinArrayWithDelim(urls, "," + baseUrl)
        let watch = UtilityArray.joinArrayWithDelim(titles, "<BR>")
        result.0 = (warning + statement + watch)
        result.1 = (warningUrl + "," + statementUrl + "," + watchUrl)
        if !result.0.contains("No watches or warnings in effect") {
            result.1 = getHazardsFromUrl(warningUrl)
        } else {
            result.1 = result.0
        }
        return result
    }

    static func getHazardsFromUrl(_ url: String) -> String {
        var warningData = ""
        let urls = url.split(",")
        var notFound = true
        urls.forEach {
            if $0 != "" && notFound {
                warningData += $0.getHtml().parse("<main.*?container.>(.*?)</div>")
                notFound = false
            }
        }
        warningData = warningData
            .replaceAll("<li><img src=./cacheable/images/img/feed-icon-14x14.png. alt=.ATOM feed.> <a href=./rss/battleboard/.*?.>ATOM</a></li>", "")
        warningData = warningData
            .replace(" <div class=\"col-xs-12\">", "")
            .replace("<section class=\"followus hidden-print\"><h2>Follow:</h2>", "")
        warningData = warningData
            .replace("<a href=\"/rss/battleboard/.*?.xml\"><img src=\"/cacheable/images/img/feed-icon-14x14.png\" alt=\"ATOM feed\" class=\"mrgn-rght-sm\">ATOM</a>", "")
        return warningData.replace("<div class=\"row\">", "")
    }

    static func getECSectorFromProv(_ prov: String) -> String {
        return provHash[prov] ?? ""
    }

    static func isLabelPresent(_ label: String) -> Bool {
        var isPresent = false
        if !UtilityCitiesCA.cityInit {
            UtilityCitiesCA.loadCitiesArray()
        }
        for city in UtilityCitiesCA.citiesCa {
            if city.contains(label) {
                isPresent = true
                break
            }
        }
        return isPresent
    }

    static func getLatLonFromLabel(_ label: String) -> LatLonStr {
        var latLon = [Double]()
        var index = 0
        if !UtilityCitiesCA.cityInit {
            UtilityCitiesCA.loadCitiesArray()
        }
        for city in UtilityCitiesCA.citiesCa {
            if city == label {
                latLon.append(UtilityCitiesCA.latCa[index])
                latLon.append(UtilityCitiesCA.lonCa[index])
                break
            }
            index += 1
        }
        return LatLonStr(String(latLon[0]), String(latLon[1]))
    }
}
