/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectForecastPackage7Day {
    
    var sevenDayLong = ""
    var icons = [String]()
    private var shortForecasts = [String]()
    private var detailedForecasts = [String]()
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
    
    var forecastList: [String] {
        return detailedForecasts
    }
    
    var forecastListCondensed: [String] {
        return shortForecasts
    }
    
    // Canada
    func convertExt7DaytoList() {
        detailedForecasts =  sevenDayLong.split(MyApplication.newline + MyApplication.newline)
        shortForecasts =  sevenDayLong.split(MyApplication.newline + MyApplication.newline)
    }
    
    func get7DayExt(_ html: String) -> String {
        var forecasts = [ObjectForecast]()
        let names = html.parseColumn("\"name\": \"(.*?)\",")
        let temperatures = html.parseColumn("\"temperature\": (.*?),")
        let windSpeeds = html.parseColumn("\"windSpeed\": \"(.*?)\",")
        let windDirections = html.parseColumn("\"windDirection\": \"(.*?)\",")
        let detailedLocalForecasts = html.parseColumn("\"detailedForecast\": \"(.*?)\"")
        self.icons = html.parseColumn("\"icon\": \"(.*?)\",")
        let shortLocalForecasts = html.parseColumn("\"shortForecast\": \"(.*?)\",")
        names.indices.forEach { index in
            let name = Utility.safeGet(names, index)
            let temperature = Utility.safeGet(temperatures, index)
            let windSpeed = Utility.safeGet(windSpeeds, index)
            let windDirection = Utility.safeGet(windDirections, index)
            let icon = Utility.safeGet(icons, index)
            let shortForecast = Utility.safeGet(shortLocalForecasts, index)
            let detailedForecast = Utility.safeGet(detailedLocalForecasts, index)
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
        forecasts.forEach { forecast in
            forecastString += forecast.name + ": " + forecast.detailedForecast + MyApplication.newline + MyApplication.newline
            self.detailedForecasts.append(forecast.name + ": " + forecast.detailedForecast)
            self.shortForecasts.append(forecast.name + ": " + forecast.shortForecast)
        }
        return forecastString
    }
    
    static var scrollView = UIScrollView()
    
    static func getHtml(_ latLon: LatLon) -> String {
        return UtilityDownloadNws.get7DayData(latLon)
    }
}
