/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class UtilityUSHourlyV2 {

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
        var footer = MyApplication.newline
        hourlyAbbreviationsFirst.keys.forEach {
            footer += hourlyAbbreviationsFirst[$0]! + ": " + $0 + MyApplication.newline
        }
        hourlyAbbreviationsSecond.keys.forEach {
            footer += hourlyAbbreviationsSecond[$0]! + ": " + $0 + MyApplication.newline
        }
        return footer
    }

    static func getHourlyString(_ locNumumber: Int) -> (String, String) {
        let location = UtilityMath.latLonFix(Location.getLatLon(locNumumber))
        let url = "https://api.weather.gov/points/" + location.latString
            + "," + location.lonString +  "/forecast/hourly"
        let html = url.getNwsHtml()
        let header = fixedLengthString("Time", 7) + fixedLengthString("T", 4)
            + fixedLengthString("Wind", 8) + fixedLengthString("WindDir", 6) +  MyApplication.newline
        let footer = getFooter()
        return (header + parse(html) + footer, html)
    }

    static func fixedLengthString(_ string: String, _ length: Int) -> String {
        if string.count < length {
            var stringLocal = string
            (string.count...length).forEach {_ in stringLocal += " "}
            return stringLocal
        } else {
            return string
        }
    }

    static func parse(_ html: String) -> String {
        let startTime = html.parseColumn("\"startTime\": \"(.*?)\",")
        let temperatures = html.parseColumn("\"temperature\": (.*?),")
        let windSpeeds = html.parseColumn("\"windSpeed\": \"(.*?)\"")
        let windDirections = html.parseColumn("\"windDirection\": \"(.*?)\"")
        let shortForecasts = html.parseColumn("\"shortForecast\": \"(.*?)\"")
        var string = ""
        startTime.indices.forEach {
            let time = translateTime(startTime[$0])
            let temperature = Utility.safeGet(temperatures, $0)
            let windSpeed = Utility.safeGet(windSpeeds, $0).replace(" to ", "-")
            let windDirection = Utility.safeGet(windDirections, $0)
            let shortForecast = Utility.safeGet(shortForecasts, $0)
            string += fixedLengthString(time, 7)
            string += fixedLengthString(temperature, 4)
            string += fixedLengthString(windSpeed, 8)
            string += fixedLengthString(windDirection, 4)
            string += fixedLengthString(shortenConditions(shortForecast), 18)
            string += MyApplication.newline
        }
        return string
    }

    static func shortenConditions(_ str: String) -> String {
        var hourly = str
        hourlyAbbreviationsFirst.keys.forEach { hourly = hourly.replaceAll($0, hourlyAbbreviationsFirst[$0]!)}
        hourlyAbbreviationsSecond.keys.forEach { hourly = hourly.replaceAll($0, hourlyAbbreviationsSecond[$0]!)}
        return hourly
    }

    static func translateTime(_ originalTime: String) -> String {
        let year = UtilityTime.getYear()
        let originalTimeComponents = originalTime.replace("T", "-").split("-")
        let month = Int(originalTimeComponents[1]) ?? 0
        let day = Int(originalTimeComponents[2]) ?? 0
        let hour = Int(originalTimeComponents[3].replace(":00:00", "")) ?? 0
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
        case 2: dayOfTheWeek = "Mon"
        case 3: dayOfTheWeek = "Tue"
        case 4: dayOfTheWeek = "Wed"
        case 5: dayOfTheWeek = "Thu"
        case 6: dayOfTheWeek = "Fri"
        case 7: dayOfTheWeek = "Sat"
        case 1: dayOfTheWeek = "Sun"
        default: dayOfTheWeek = ""
        }
        return (dayOfTheWeek + " " + hourString)
    }
}
