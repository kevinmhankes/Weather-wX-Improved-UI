/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class UtilityHourly {

    static let hourlyAbbreviationsFirst = [
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
        "T-storms": "Tst"
    ]

    static let hourlyAbbreviationsSecond = [
        "Showers": "Shwr",
        "Rn And Sn": "Rn/Sn"
    ]

    static func getFooter() -> String {
        var footer = GlobalVariables.newline
        hourlyAbbreviationsFirst.forEach { k, v in
            footer += v + ": " + k + GlobalVariables.newline
        }
        hourlyAbbreviationsSecond.forEach { k, v in
            footer += v + ": " + k + GlobalVariables.newline
        }
        return footer
    }
    
    static func get(_ locationNumber: Int) -> [String] {
        if UIPreferences.useNwsApiForHourly {
            let dataList: [String] = UtilityHourly.getHourlyString1(locationNumber)
            return dataList
        }
        let data = UtilityHourlyOldApi.getHourlyString(locationNumber)
        return [data, data]
    }

    static func getHourlyString1(_ locationNumber: Int) -> [String] {
        let html = UtilityDownloadNws.getHourlyData(Location.getLatLon(locationNumber))
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
            let time = translateTime(startTimes[index])
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
        hourlyAbbreviationsFirst.forEach { k, v in
            hourly = hourly.replaceAll(k, v)
        }
        hourlyAbbreviationsSecond.forEach { k, v in
            hourly = hourly.replaceAll(k, v)
        }
        return hourly
    }

    static func translateTime(_ originalTime: String) -> String {
        let originalTimeComponents = originalTime.replace("T", "-").split("-")
        let year = to.Int(originalTimeComponents[0])
        let month = to.Int(originalTimeComponents[1])
        let day = to.Int(originalTimeComponents[2])
        let hour = to.Int(originalTimeComponents[3].replace(":00:00", ""))
        let hourString = String(hour)
        let dayOfTheWeek: String
        var futureDateComp = DateComponents()
        futureDateComp.year = year
        futureDateComp.month = month
        futureDateComp.day = day
        let calendar = Calendar.current
        let futureDate = calendar.date(from: futureDateComp)!
        let dayOfTheWeekIndex = calendar.component(.weekday, from: futureDate)
        switch dayOfTheWeekIndex {
        case 2:
            dayOfTheWeek = "Mon"
        case 3:
            dayOfTheWeek = "Tue"
        case 4:
            dayOfTheWeek = "Wed"
        case 5:
            dayOfTheWeek = "Thu"
        case 6:
            dayOfTheWeek = "Fri"
        case 7:
            dayOfTheWeek = "Sat"
        case 1:
            dayOfTheWeek = "Sun"
        default:
            dayOfTheWeek = ""
        }
        return dayOfTheWeek + " " + hourString
    }
}
