/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectForecastPackage7Day {

    var sevenDayLong = ""
    var icons = [String]()
    private var shortForecastAl = [String]()
    private var detailedForecastAl = [String]()
    var locationIndex = 0

    convenience init(_ locNum: Int) {
        self.init()
        if Location.isUS(locNum) {
            let html = UtilityDownloadNws.get7DayData(Location.getLatLon(locNum))
            sevenDayLong = get7DayExt(html)
        } else {
            let html = UtilityCanada.getLocationHtml(Location.getLatLon(locNum))
            sevenDayLong = UtilityCanada.get7Day(html)
            icons = UtilityCanada.getIcons7DayAsList(sevenDayLong)
            convertExt7DaytoList()
        }
    }

    convenience init(_ latLon: LatLon) {
        self.init()
        let html = UtilityDownloadNws.get7DayData(latLon)
        sevenDayLong = get7DayExt(html)
    }

    convenience init(_ html: String) {
        self.init()
        sevenDayLong = get7DayExt(html)
    }

    var forecastList: [String] {
        return detailedForecastAl
    }

    var forecastListCondensed: [String] {
        return shortForecastAl
    }

    // Canada
    func convertExt7DaytoList() {
        detailedForecastAl =  sevenDayLong.split(MyApplication.newline + MyApplication.newline)
        shortForecastAl =  sevenDayLong.split(MyApplication.newline + MyApplication.newline)
    }

    func get7DayExt(_ html: String) -> String {
        var forecasts = [ObjectForecast]()
        let nameAl = html.parseColumn("\"name\": \"(.*?)\",")
        let temperatureAl = html.parseColumn("\"temperature\": (.*?),")
        let windSpeedAl = html.parseColumn("\"windSpeed\": \"(.*?)\",")
        let windDirectionAl = html.parseColumn("\"windDirection\": \"(.*?)\",")
        let detailedForecastAlLocal = html.parseColumn("\"detailedForecast\": \"(.*?)\"")
        self.icons = html.parseColumn("\"icon\": \"(.*?)\",")
        let shortForecastAlLocal = html.parseColumn("\"shortForecast\": \"(.*?)\",")
        print(shortForecastAl)
        nameAl.indices.forEach {
            let name = Utility.safeGet(nameAl, $0)
            let temperature = Utility.safeGet(temperatureAl, $0)
            let windSpeed = Utility.safeGet(windSpeedAl, $0)
            let windDirection = Utility.safeGet(windDirectionAl, $0)
            let icon = Utility.safeGet(icons, $0)
            let shortForecast = Utility.safeGet(shortForecastAlLocal, $0)
            let detailedForecast = Utility.safeGet(detailedForecastAlLocal, $0)
            forecasts.append(
                ObjectForecast(
                    name,
                    temperature,
                    windSpeed,
                    windDirection,
                    icon,
                    shortForecast,
                    detailedForecast
                )
            )
        }
        var forecastString = MyApplication.newline + MyApplication.newline
        forecasts.forEach {
            forecastString += $0.name + ": " + $0.detailedForecast + MyApplication.newline + MyApplication.newline
            self.detailedForecastAl.append($0.name + ": " + $0.detailedForecast)
            self.shortForecastAl.append($0.name + ": " + $0.shortForecast)
        }
        return forecastString
    }

    static var scrollView = UIScrollView()

    static func getHtml(_ latLon: LatLon) -> String {
        return UtilityDownloadNws.get7DayData(latLon)
    }
}
