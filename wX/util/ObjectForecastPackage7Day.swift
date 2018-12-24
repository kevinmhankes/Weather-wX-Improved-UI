/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectForecastPackage7Day {

    var sevenDayExtStr = ""
    var icons = [String]()
    private var shortForecastAl = [String]()
    private var detailedForecastAl = [String]()
    var locationIndex = 0

    convenience init(_ locNum: Int, _ html: String) {
        self.init()
        if Location.isUS(locNum) {
            sevenDayExtStr = get7DayExt(html)
        } else {
            sevenDayExtStr = UtilityCanada.get7Day(html)
            icons = UtilityCanada.getIcons7DayAsList(sevenDayExtStr)
            convertExt7DaytoList()
        }
    }

    convenience init(_ html: String) {
        self.init()
        sevenDayExtStr = get7DayExt(html)
    }

    var fcstList: [String] {
        return detailedForecastAl
    }

    func convertExt7DaytoList() {
        detailedForecastAl =  sevenDayExtStr.split(MyApplication.newline + MyApplication.newline)
    }

    func get7DayExt(_ html: String) -> String {
        var forecasts = [ObjectForecast]()
        let nameAl = html.parseColumn("\"name\": \"(.*?)\",")
        let temperatureAl = html.parseColumn("\"temperature\": (.*?),")
        let windSpeedAl = html.parseColumn("\"windSpeed\": \"(.*?)\",")
        let windDirectionAl = html.parseColumn("\"windDirection\": \"(.*?)\",")
        let detailedForecastAlLocal = html.parseColumn("\"detailedForecast\": \"(.*?)\"")
        self.icons = html.parseColumn("\"icon\": \"(.*?)\",")
        self.shortForecastAl = html.parseColumn("\"shortForecast\": \"(.*?)\",")
        nameAl.indices.forEach {
            let name = Utility.safeGet(nameAl, $0)
            let temperature = Utility.safeGet(temperatureAl, $0)
            let windSpeed = Utility.safeGet(windSpeedAl, $0)
            let windDirection = Utility.safeGet(windDirectionAl, $0)
            let icon = Utility.safeGet(icons, $0)
            let shortForecast = Utility.safeGet(shortForecastAl, $0)
            let detailedForecast = Utility.safeGet(detailedForecastAlLocal, $0)
            forecasts.append(ObjectForecast(name, temperature, windSpeed, windDirection,
                                            icon, shortForecast, detailedForecast))
        }
        var forecastString = MyApplication.newline + MyApplication.newline
        forecasts.forEach {
            forecastString += $0.name + ": " + $0.detailedForecast + MyApplication.newline + MyApplication.newline
            self.detailedForecastAl.append($0.name + ": " + $0.detailedForecast)
        }
        return forecastString
    }

    static var scrollView = UIScrollView()
}
