/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class UtilityUS {
    
    static func getLocationHtml(_ x: String, _ y: String) -> String {
        let html = UtilityNetworkIO.getStringFromUrl("https://forecast.weather.gov/MapClick.php?lat=" + x + "&lon=" + y + "&unit=0&lg=english&FcstType=dwml")
        return html
    }

    static func getCurrentConditionsUS(_ html: String) -> [String] {
        var result = Array(repeating: "", count: 5)
        let regexpList = [
                "<temperature type=.apparent. units=.Fahrenheit..*?>(.*?)</temperature>",
                "<temperature type=.dew point. units=.Fahrenheit..*?>(.*?)</temperature>",
                "<direction type=.wind.*?>(.*?)</direction>",
                "<wind-speed type=.gust.*?>(.*?)</wind-speed>",
                "<wind-speed type=.sustained.*?>(.*?)</wind-speed>",
                "<pressure type=.barometer.*?>(.*?)</pressure>",
                "<visibility units=.*?>(.*?)</visibility>",
                "<weather-conditions weather-summary=.(.*?)./>.*?<weather-conditions>",
                "<temperature type=.maximum..*?>(.*?)</temperature>",
                "<temperature type=.minimum..*?>(.*?)</temperature>",
                "<conditions-icon type=.forecast-NWS. time-layout=.k-p12h-n1[0-9]-1..*?>(.*?)</conditions-icon>",
                "<wordedForecast time-layout=.k-p12h-n1[0-9]-1..*?>(.*?)</wordedForecast>",
                "<data type=.current observations.>.*?<area-description>(.*)</area-description>.*?</location>",
                "<moreWeatherInformation applicable-location=.point1.>http://www.nws.noaa.gov/data/obhistory/(.*).html</moreWeatherInformation>",
                "<data type=.current observations.>.*?<start-valid-time period-name=.current.>(.*)</start-valid-time>",
                "<time-layout time-coordinate=.local. summarization=.12hourly.>.*?<layout-key>k-p12h-n1[0-9]-1</layout-key>(.*?)</time-layout>",
                "<time-layout time-coordinate=.local. summarization=.12hourly.>.*?<layout-key>k-p24h-n[678]-1</layout-key>(.*?)</time-layout>",
                "<time-layout time-coordinate=.local. summarization=.12hourly.>.*?<layout-key>k-p24h-n[678]-2</layout-key>(.*?)</time-layout>",
                "<weather time-layout=.k-p12h-n1[0-9]-1.>.*?<name>.*?</name>(.*)</weather>", // 3 to [0-9] 3 places
                "<hazards time-layout.*?>(.*)</hazards>.*?<wordedF",
                "<data type=.forecast.>.*?<area-description>(.*?)</area-description>",
                "<humidity type=.relative..*?>(.*?)</humidity>"
        ]
        let rawData = UtilityString.parseXmlExt(regexpList, html)
        result[0] = rawData[10]
        result[3] = get7DayExt(rawData)
        return result
    }

    static func get7DayExt(_ rawData: [String]) -> String {
        var timeP12n13List = Array(repeating: "", count: 14)
        var weatherSummaries = Array(repeating: "", count: 14)
        let forecast = UtilityString.parseXml(rawData[11], "text")

        weatherSummaries = UtilityString.parseColumn(rawData[18], MyApplication.utilUS_weather_summary_pattern)
        weatherSummaries.insert("", at: 0)

        timeP12n13List = UtilityString.parseColumn(rawData[15], MyApplication.utilUS_period_name_pattern)
        timeP12n13List.insert("", at: 0)

        var sb = ""
        for j in 1..<forecast.count {
            sb += timeP12n13List[j]
            sb += ": "
            sb += forecast[j]
        }
        return sb
    }
}
