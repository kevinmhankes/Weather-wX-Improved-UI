/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
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

    static let providences = [
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

    static let providenceToMosaicSector = [
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

    static let providenceCodes = [
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

    static func translateIconName(_ condition: String) -> String {
        var newName = ""
        if condition.contains("reezing rain or snow")
            || condition.contains("chance of flurries and risk of freezing drizzle")
            || condition.contains("chance of flurries before morning with risk of freezing drizzle")
            || condition.contains("Periods of freezing drizzle or flurries")
            || condition.contains("Flurries or freezing drizzle") {
            newName = "fzra_sn"
        } else if condition.contains("eriods of freezing drizzle")
            || condition.contains("reezing Drizzle")
            || condition.contains("reezing drizzle")
            || condition.contains("reezing rain")
            || condition.contains("isk of freezing drizzle") {
            newName = "fzra"
        } else if condition.contains("Ice Crystals") || condition.contains("ice pellets") {
            newName = "ip"
        } else if condition.contains("hundershowers") || condition.contains("hunderstorm") {
            newName = "scttsra"
        } else if condition.contains("hance of rain showers or flurries")
            || condition.contains("lurries or rain showers")
            || condition.contains(" few rain showers or flurries")
            || condition.contains("ain or snow")
            || condition.contains("eriods of rain or snow")
            || condition.contains("now or rain")
            || condition.contains("ain changing to snow")
            || condition.contains("ain showers or flurries")
            || condition.contains("ain changing to periods of snow")
            || condition.contains("now changing to periods of rain")
            || condition.contains("Rain at times heavy changing to snow")
            || condition.contains("Snow changing to periods of drizzle")
            || condition.contains("Rain at times mixed with wet snow") {
            newName = "ra_sn"
        } else if condition.contains("hance of showers") || condition.contains("howers") {
            newName = "shra"
        } else if condition.contains("hance of rain")
            || condition.contains("Rain beginning")
            || condition.contains("eriods of drizzle changing to rain at times")
            || condition.contains("Rain at times heavy") {
            newName = "ra"
        } else if condition.contains("hance of flurries")
            || condition.contains("hance of snow")
            || condition.contains("eriods of snow")
            || condition.contains(" few flurries")
            || condition.contains("eriods of light snow")
            || condition.contains("Flurries")
            || condition.contains("Snow")
            || condition.contains("then snow")
            || condition.contains("ight snow") {
            newName = "sn"
        } else if condition.contains("A few showers")
            || condition.contains("eriods of rain")
            || condition.contains("drizzle") {
            newName = "hi_shwrs"
        } else if condition.contains("Increasing cloudiness") || condition.contains("Cloudy periods") {
            newName = "bkn"
        } else if condition.contains("Mainly sunny") || condition.contains("A few clouds") {
            newName = "few"
        } else if condition.contains("loudy")
            || condition.contains("Mainly cloudy")
            || condition.contains("Overcast") {
            newName = "ovc"
        } else if condition.contains("A mix of sun and cloud")
            || condition.contains("Partly cloudy")
            || condition.contains("Clearing") {
            newName = "sct"
        } else if condition.contains("Clear") || condition.contains("Sunny") {
            newName = "skc"
        } else if condition.contains("Blizzard")
            || condition.contains("Local blowing snow") {
            newName = "blizzard"
        } else if condition.contains("Rain") {
            newName = "ra"
        } else if condition.contains("Mist")
            || condition.contains("Fog")
            || condition.contains("Light Drizzle") {
            newName = "fg"
        }
        if condition.contains("night") {
            if newName.contains("hi_") {
                newName = newName.replace("hi_", "hi_n")
            } else {
                newName = "n" + newName
            }
        }
        if condition.contains("percent") {
            let pop = condition.parse("([0-9]{2}) percent")
            newName += "," + pop
        }
        return newName
    }

    static func translateIconNameCurrentConditions(_ condition: String, _ day1: String) -> String {
        var newName = ""
        if condition.contains("eriods of freezing drizzle")
            || condition.contains("Freezing Drizzle")
            || condition.contains("Freezing Rain") {
            newName = "fzra"
        } else if condition.contains("hundershowers") || condition.contains("hunderstorm") {
            newName = "scttsra"
        } else if condition.contains("Haze") {
            newName = "fg"
        } else if condition.contains("hance of rain showers or flurries")
            || condition.contains("lurries or rain showers")
            || condition.contains(" few rain showers or flurries")
            || condition.contains("ain or snow")
            || condition.contains("ain and Snow")
            || condition.contains("eriods of rain or snow")
            || condition.contains("now or rain") {
            newName = "ra_sn"
        } else if condition.contains("hance of showers") || condition.contains("Showers") {
            newName = "shra"
        } else if condition.contains("hance of rain") {
            newName = "ra"
        } else if condition.contains("A few showers") || condition.contains("eriods of rain")
            || condition.contains("drizzle") {
            newName = "hi_shwrs"
        } else if condition.contains("Blizzard")
            || condition.contains("Blowing Snow")
            || condition.contains("Drifting Snow") {
            newName = "blizzard"
        } else if condition.contains("hance of flurries")
            || condition.contains("hance of snow")
            || condition.contains("eriods of snow")
            || condition.contains(" few flurries")
            || condition.contains("eriods of light snow")
            || condition.contains("Flurries")
            || condition.contains("Snow")
            || condition.contains("ight snow") {
            newName = "sn"
        } else if condition.contains("Increasing cloudiness") || condition.contains("Cloudy periods") {
            newName = "bkn"
        } else if condition.contains("Mainly sunny")
            || condition.contains("A few clouds")
            || condition.contains("Mainly Sunny")
            || condition.contains("Mainly Clear") {
            newName = "few"
        } else if condition.contains("Cloudy")
            || condition.contains("Mainly cloudy")
            || condition.contains("Overcast") {
            newName = "ovc"
        } else if condition.contains("A mix of sun and cloud")
            || condition.contains("Partly cloudy")
            || condition.contains("Clearing") {
            newName = "sct"
        } else if condition.contains("Clear") || condition.contains("Sunny") {
            newName = "skc"
        } else if condition.contains("Rain") {
            newName = "ra"
        } else if condition.contains("Mist")
            || condition.contains("Fog")
            || condition.contains("Light Drizzle") {
            newName = "fg"
        } else if condition.contains("Ice Crystals")
            || condition.contains("Ice Pellets") {
            newName = "ip"
        }
        let time = day1.parse(" ([0-9]{1,2}:[0-9]{2} [AP]M) ")
        var timeArr = time.split(":")
        var hour: Int
        var daytime = true
        if timeArr.count > 0 {
            hour = Int(timeArr[0]) ?? 0
            if time.contains("AM") {
                if hour < 8 {
                    daytime = false
                }
            }
            if time.contains("PM") {
                if hour == 12 {
                    hour = 0
                }
                if hour > 6 {
                    daytime = false
                }
            }
        }
        if !daytime {
            if newName.contains("hi_") {
                newName = newName.replace("hi_", "hi_n")
            } else {
                newName = "n" + newName
            }
        }
        if condition.contains("percent") {
            let pop = condition.parse("([0-9]{2}) percent")
            newName += "," + pop
        }
        return newName
    }

    static func getProvidenceHtml(_ prov: String) -> String {
        return (MyApplication.canadaEcSitePrefix + "/forecast/canada/index_e.html?id=" + prov).getHtmlSep()
    }

    static func getLocationHtml(_ location: LatLon) -> String {
        let prov = location.latString.split(":")
        let id = location.lonString.split(":")
        return (MyApplication.canadaEcSitePrefix + "/rss/city/" + prov[1].lowercased() + "-" + id[0] + "_e.xml").getHtmlSep()
    }

    static func getLocationUrl(_ lat: String, _ lon: String ) -> String {
        let prov = lat.split(":")
        let id = lon.split(":")
        return MyApplication.canadaEcSitePrefix + "/city/pages/" + prov[1].lowercased() + "-" + id[0] + "_metric_e.html"
    }

    static func getStatus(_ html: String) -> String {
        return html.parse("<b>Observed at:</b>(.*?)<br/>")
    }

    static func getRadarSite(_ lat: String, _ lon: String) -> String {
        let url = MyApplication.canadaEcSitePrefix + "/city/pages/"
            + lat.split(":")[1].lowercased()
            + "-"
            + lon.split(":")[0]
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
            .parse("<b>Temperature:</b> (.*?)&deg;C <br/>.*?<b>Humidity:</b> .*? %<br/>"
                + ".*?<b>Dewpoint:</b> .*?&deg;C <br/>")
        let relativeHumdity = html
            .parse("<b>Temperature:</b> .*?&deg;C <br/>.*?<b>Humidity:</b> (.*?) %<br/>"
                + ".*?<b>Dewpoint:</b> .*?&deg;C <br/>")
        let dew = html
            .parse("<b>Temperature:</b> .*?&deg;C <br/>.*?<b>Humidity:</b> .*? %<br/>"
                + ".*?<b>Dewpoint:</b> (.*?)&deg;C <br/>")
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
            .parseColumn("<category term=\"Weather Forecasts\"/>.*?<summary "
                + "type=\"html\">(.*?\\.) Forecast.*?</summary>")
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

    // FIXME move away from tuple
    static func getHazards(_ html: String) -> (String, String) {
        var result: (String, String) = ("", "")
        var urls = html.parseColumn("<div id=\"statement\" class=\"floatLeft\">.*?<a href=\"(.*?)\">.*?</a>.*?</div>")
        var titles = html.parseColumn("<div id=\"statement\" class=\"floatLeft\">.*?<a href=\".*?\">(.*?)</a>.*?</div>")
        let statementUrl = urls.joined()
        let statement = titles.joined(separator: "<BR>")
        var chunk = html.parse("<entry>(.*?)<category term=\"Warnings and Watches\"/>")
        urls = chunk.parseColumn("<title>.*?</title>.*?<link type=\"text/html\" href=\"(.*?)\"/>")
        titles = chunk.parseColumn("<title>(.*?)</title>.*?<link type=\"text/html\" href=\".*?\"/>")
        let warningUrl = urls.joined(separator: ",")
        let warning = titles.joined(separator: "<BR>")
        chunk = html.parse("<div id=\"watch\" class=\"floatLeft\">(.*?)</div>")
        urls = chunk.parseColumn("<a href=\"(.*?)\">.*?</a>")
        titles = chunk.parseColumn("<a href=\".*?\">(.*?)</a>")
        let watchUrl = urls.joined(separator: "," + MyApplication.canadaEcSitePrefix)
        let watch = titles.joined(separator: "<BR>")
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
            .replaceAll("<li><img src=./cacheable/images/img/feed-icon-14x14.png. alt=.ATOM"
                + " feed.> <a href=./rss/battleboard/.*?.>ATOM</a></li>", "")
        warningData = warningData
            .replace(" <div class=\"col-xs-12\">", "")
            .replace("<section class=\"followus hidden-print\"><h2>Follow:</h2>", "")
        warningData = warningData
            .replace("<a href=\"/rss/battleboard/.*?.xml\"><img src=\"/cacheable/images/img/"
                + "feed-icon-14x14.png\" alt=\"ATOM feed\" class=\"mrgn-rght-sm\">ATOM</a>", "")
        return warningData.replace("<div class=\"row\">", "")
    }

    static func getECSectorFromProvidence(_ providence: String) -> String {
        return providenceToMosaicSector[providence] ?? ""
    }

    static func isLabelPresent(_ label: String) -> Bool {
        var isPresent = false
        if !UtilityCitiesCanada.cityInit {
            UtilityCitiesCanada.loadCitiesArray()
        }
        for city in UtilityCitiesCanada.citiesCa {
            if city.contains(label) {
                isPresent = true
                break
            }
        }
        return isPresent
    }

    static func getLatLonFromLabel(_ label: String) -> LatLon {
        var latLon = [Double]()
        var index = 0
        if !UtilityCitiesCanada.cityInit {
            UtilityCitiesCanada.loadCitiesArray()
        }
        for city in UtilityCitiesCanada.citiesCa {
            if city == label {
                latLon.append(UtilityCitiesCanada.latCa[index])
                latLon.append(UtilityCitiesCanada.lonCa[index])
                break
            }
            index += 1
        }
        return LatLon(latLon[0], latLon[1])
    }
}
