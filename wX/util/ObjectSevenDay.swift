/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectSevenDay {

    var icons = [String]()
    private var shortForecasts = [String]()
    private var detailedForecasts = [String]()
    var locationIndex = 0

    // US or CA
    convenience init(_ locNum: Int) {
        self.init()
        if Location.isUS(locNum) {
            let html = UtilityDownloadNws.get7DayData(Location.getLatLon(locNum))
            process(html)
        } else {
            let html = UtilityCanada.getLocationHtml(Location.getLatLon(locNum))
            let sevenDayLong = UtilityCanada.get7Day(html)
            icons = UtilityCanada.getIcons7DayAsList(sevenDayLong)
            processCanada(sevenDayLong)
        }
    }

    // US
    convenience init(_ latLon: LatLon) {
        self.init()
        let html = UtilityDownloadNws.get7DayData(latLon)
        process(html)
    }

    // US
    func process(_ html: String) {
        if UIPreferences.useNwsApi {
            var forecasts = [ObjectForecast]()
            let names = html.parseColumn("\"name\": \"(.*?)\",")
            let temperatures = html.parseColumn("\"temperature\": (.*?),")
            let windSpeeds = html.parseColumn("\"windSpeed\": \"(.*?)\",")
            let windDirections = html.parseColumn("\"windDirection\": \"(.*?)\",")
            let detailedLocalForecasts = html.parseColumn("\"detailedForecast\": \"(.*?)\"")
            icons = html.parseColumn("\"icon\": \"(.*?)\",")
            let shortLocalForecasts = html.parseColumn("\"shortForecast\": \"(.*?)\",")
            names.indices.forEach { index in
                let name = Utility.safeGet(names, index)
                let temperature = Utility.safeGet(temperatures, index)
                let windSpeed = Utility.safeGet(windSpeeds, index)
                let windDirection = Utility.safeGet(windDirections, index)
                let icon = Utility.safeGet(icons, index)
                let shortForecast = Utility.safeGet(shortLocalForecasts, index)
                let detailedForecast = Utility.safeGet(detailedLocalForecasts, index)
                forecasts.append(ObjectForecast(name, temperature, windSpeed, windDirection, icon, shortForecast, detailedForecast))
            }
            forecasts.forEach { forecast in
                detailedForecasts.append(forecast.name + ": " + forecast.detailedForecast)
                shortForecasts.append(forecast.name + ": " + forecast.shortForecast)
            }
        } else {
            var forecasts = [ObjectForecast]()
            let forecastStringList = UtilityUS.getCurrentConditionsUS(html)
            let forecastString = forecastStringList[1]
            let iconString = forecastStringList[0]
            let forecastStrings = forecastString.split("\n")
            icons = UtilityString.parseColumn(iconString, "<icon-link>(.*?)</icon-link>")
            var forecast = GlobalVariables.newline + GlobalVariables.newline
            forecastStrings.enumerated().forEach { index, s in
                if s != "" {
                    detailedForecasts.append(s.trim())
                    shortForecasts.append(s.trim())
                    forecast += s.trim()
                    forecast += GlobalVariables.newline + GlobalVariables.newline
                    if icons.count > index {
                        // icons.add(iconList[index]);
                    }
                    // not in kotlin
                    let stringList = s.trim().split(":")
                    let time = stringList[0].replace("\"", "")
                    var fcst = " "
                    if stringList.count > 1 {
                        fcst = stringList[1]
                    }
                    let icon = Utility.safeGet(icons, index)
                    if fcst != " " {
                        forecasts.append(ObjectForecast(time, "", "", "", icon, "short", fcst))
                    }
                }
            }
        }
    }

    // Canada
    func processCanada(_ sevenDayLong: String) {
        detailedForecasts = sevenDayLong.split(GlobalVariables.newline + GlobalVariables.newline)
        shortForecasts = sevenDayLong.split(GlobalVariables.newline + GlobalVariables.newline)
    }

    var forecastList: [String] { detailedForecasts }

    var forecastListCondensed: [String] { shortForecasts }
}
