// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Foundation

final class UtilityHourly {

    static let abbreviations = [
        "Showers And Thunderstorms": "Sh/Tst",
        "Chance": "Chc",
        "Slight": "Slt",
        "Light": "Lgt",
        "Scattered": "Sct",
        "Rain": "Rn",
        "Snow": "Sn",
        "Rn And Sn": "Rn/Sn",
        "Freezing": "Frz",
        "Drizzle": "Drz",
        "Isolated": "Iso",
        "Likely": "Lkly",
        "T-storms": "Tst",
        "Showers": "Shwr"
    ]

    static func getFooter() -> String {
        var footer = GlobalVariables.newline
        abbreviations.forEach { k, v in
            footer += v + ": " + k + GlobalVariables.newline
        }
        return footer
    }
    
    static func get(_ locationNumber: Int) -> [String] {
        if UIPreferences.useNwsApiForHourly {
            let dataList: [String] = UtilityHourly.getHourlyString(locationNumber)
            return dataList
        }
        let data = UtilityHourlyOldApi.getHourlyString(locationNumber)
        return [data, data]
    }

    static func getHourlyString(_ locationNumber: Int) -> [String] {
        var html = UtilityDownloadNws.getHourlyData(Location.getLatLon(locationNumber))
        if html == "" {
            html = UtilityDownloadNws.getHourlyData(Location.getLatLon(locationNumber))
        }
        let header = "Time".fixedLengthString(7)
            + "T".fixedLengthString(4)
            + "Wind".fixedLengthString(8)
            + "WindDir".fixedLengthString(6)
            + GlobalVariables.newline
        let footer = getFooter()
        return [header + parse(html) + footer, html]
    }

    static func parse(_ html: String) -> String {
        let startTimes = html.parseColumn("\"startTime\": \"(.*?)\",")
        let temperatures = html.parseColumn("\"temperature\": (.*?),")
        let windSpeeds = html.parseColumn("\"windSpeed\": \"(.*?)\"")
        let windDirections = html.parseColumn("\"windDirection\": \"(.*?)\"")
        let shortForecasts = html.parseColumn("\"shortForecast\": \"(.*?)\"")
        var s = ""
        startTimes.indices.forEach { index in
            let time = UtilityTime.translateTimeForHourly(startTimes[index])
            let temperature = Utility.safeGet(temperatures, index).replace("\"", "")
            let windSpeed = Utility.safeGet(windSpeeds, index).replace(" to ", "-")
            let windDirection = Utility.safeGet(windDirections, index)
            let shortForecast = Utility.safeGet(shortForecasts, index)
            s += time.fixedLengthString(7)
            s += temperature.fixedLengthString(4)
            s += windSpeed.fixedLengthString(8)
            s += windDirection.fixedLengthString(4)
            s += shortenConditions(shortForecast).fixedLengthString(18)
            s += GlobalVariables.newline
        }
        return s
    }

    static func shortenConditions(_ string: String) -> String {
        var hourly = string
        abbreviations.forEach { k, v in
            hourly = hourly.replaceAll(k, v)
        }
        return hourly
    }
}
