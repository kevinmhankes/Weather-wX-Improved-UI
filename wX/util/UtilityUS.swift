// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import Foundation

final class UtilityUS {

    static func getLocationHtml(_ x: String, _ y: String) -> String {
        let html = UtilityNetworkIO.getStringFromUrl("https://forecast.weather.gov/MapClick.php?lat=" + x + "&lon=" + y + "&unit=0&lg=english&FcstType=dwml")
        return html.replace("\n", " ")
    }

    static func getCurrentConditionsUS(_ html: String) -> [String] {
        var result = [String]()
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
        result.append(rawData[10])
        result.append(get7DayExt(rawData))
        return result
    }

    static func get7DayExt(_ rawData: [String]) -> String {
        let forecast = UtilityString.parseXml(rawData[11], "text")
        var timeP12n13List = UtilityString.parseColumn(rawData[15], GlobalVariables.utilUSPeriodNamePattern)
        timeP12n13List.insert("", at: 0)
        var forecastString = ""
        for j in 1..<forecast.count {
            forecastString += timeP12n13List[j]
            forecastString += ": "
            forecastString += forecast[j]
            forecastString += GlobalVariables.newline
        }
        return forecastString
    }
}
