/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
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
    
    /*if Location.isUS(locNum) {
    let html = UtilityDownloadNWS.get7DayData(Location.getLatLon(locNum))
    return ObjectForecastPackage7Day(locNum, html)
    } else {
    let html = UtilityCanada.getLocationHtml(Location.getLatLon(locNum))
    return ObjectForecastPackage7Day(locNum, html)
    }*/

    convenience init(_ locNum: Int) {
        self.init()
        if Location.isUS(locNum) {
            let html = UtilityDownloadNws.get7DayData(Location.getLatLon(locNum))
            sevenDayExtStr = get7DayExt(html)
        } else {
            let html = UtilityCanada.getLocationHtml(Location.getLatLon(locNum))
            sevenDayExtStr = UtilityCanada.get7Day(html)
            icons = UtilityCanada.getIcons7DayAsList(sevenDayExtStr)
            convertExt7DaytoList()
        }
    }
    
    convenience init(_ latLon: LatLon) {
        self.init()
        let html = UtilityDownloadNws.get7DayData(latLon)
        sevenDayExtStr = get7DayExt(html)
        //iconsAsString = getIcons7Day(html)
        //sevenDayLong = get7DayExt(html)
        //sevenDayShort = get7DayShort(html)
    }

    convenience init(_ html: String) {
        self.init()
        sevenDayExtStr = get7DayExt(html)
    }

    var fcstList: [String] {
        return detailedForecastAl
    }

    var fcstListCondensed: [String] {
        return shortForecastAl
    }

    // Canada
    func convertExt7DaytoList() {
        detailedForecastAl =  sevenDayExtStr.split(MyApplication.newline + MyApplication.newline)
        shortForecastAl =  sevenDayExtStr.split(MyApplication.newline + MyApplication.newline)
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
        let html = UtilityDownloadNws.get7DayData(latLon)
        return html
    }
}
