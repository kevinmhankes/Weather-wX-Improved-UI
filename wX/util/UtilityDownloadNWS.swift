/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class UtilityDownloadNWS {

    static func getCap(_ sector: String) -> String {
        if sector == "us" {
            return getNwsStringFromUrlXml("https://api.weather.gov/alerts/active?region_type=land")
        } else {
            return getNwsStringFromUrlXml("https://api.weather.gov/alerts/active?state=" + sector.uppercased())
        }
    }

    /*static func get7DayJson(_ location: LatLon) -> String {
        let newLocation = UtilityMath.latLonFix(location)
        let url = "https://api.weather.gov/points/" + newLocation.latString + "," + newLocation.lonString + "/forecast"
        return url.getHtml()
    }*/

    static func getNwsStringFromUrls(_ url: String) -> String {
        let myJustDefaults = JustSessionDefaults(headers: ["User-Agent": "IOS "
            + MyApplication.appName
            + " "
            + MyApplication.appCreatorEmail])
        let just = JustOf<HTTP>(defaults: myJustDefaults)
        let result = just.get(url)
        return result.text ?? ""

        // https://github.com/JustHTTP/Just
        // http://docs.justhttp.net/QuickStart.html
        // is the request successful?
        //r.ok
        //r.statusCode
        // what did the server return?
        //r.headers       // response headers
        //r.content       // response body as NSData?
        //r.text          // response body as text?
        //r.json          // response body parsed by NSJSONSerielization
        //r.url           // the URL, as NSURL
        //r.isRedirect    // is this a redirect response
    }

    static func getNwsStringFromUrlXml(_ url: String) -> String {
        let myJustDefaults = JustSessionDefaults(
            headers: [
                "User-Agent": "IOS " + MyApplication.appName + " " + MyApplication.appCreatorEmail,
                "Accept": "application/atom+xml"
            ]
        )
        let just = JustOf<HTTP>(defaults: myJustDefaults)
        let result = just.get(url)
        return result.text ?? ""
    }

    static func getHourlyData(_ latLon: LatLon) -> String {
        let pointsData = getLocationPointData(latLon)
        let hourlyUrl = pointsData.parse("\"forecastHourly\": \"(.*?)\"")
        let data = hourlyUrl.getNwsHtml()
        return data
    }

    static func get7DayData(_ latLon: LatLon) -> String  {
        let pointsData = getLocationPointData(latLon)
        let forecastUrl = pointsData.parse("\"forecast\": \"(.*?)\"")
        let data = forecastUrl.getNwsHtml()
        return data
    }

    static func getLocationPointData(_ latLon: LatLon) -> String  {
        let url = MyApplication.nwsApiUrl + "/points/" + latLon.latString + "," + latLon.lonString
        let data = url.getNwsHtml()
        return data
    }
}
