/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class UtilityDownloadNws {

    private static let appCreatorEmail = "joshua.tee@gmail.com"

    static func getCap(_ sector: String) -> String {
        if sector == "us" {
            return getStringFromUrlXml("https://api.weather.gov/alerts/active?region_type=land")
        } else {
            return getStringFromUrlXml("https://api.weather.gov/alerts/active?state=" + sector.uppercased())
        }
    }

    static func getStringFromUrl(_ url: String) -> String {
        print("UtilityDownloadNws.getStringFromUrl: " + url)
        let myJustDefaults = JustSessionDefaults(headers: ["User-Agent": "IOS "
            + GlobalVariables.appName
            + " "
            + appCreatorEmail])
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

    static func getStringFromUrlXml(_ url: String) -> String {
        print("UtilityDownloadNws.getStringFromUrlXml: " + url)
        let myJustDefaults = JustSessionDefaults(
            headers: [
                "User-Agent": "IOS " + GlobalVariables.appName + " " + appCreatorEmail,
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
        return hourlyUrl.getNwsHtml()
    }

    static func get7DayData(_ latLon: LatLon) -> String {
        if UIPreferences.useNwsApi {
            let pointsData = getLocationPointData(latLon)
            let forecastUrl = pointsData.parse("\"forecast\": \"(.*?)\"")
            GlobalVariables.forecastZone = forecastUrl
            return forecastUrl.getNwsHtml()
        } else {
            let html = UtilityUS.getLocationHtml(latLon.latString, latLon.lonString)
            return html
        }
    }

    static func getLocationPointData(_ latLon: LatLon) -> String {
        (GlobalVariables.nwsApiUrl + "/points/" + latLon.latString + "," + latLon.lonString).getNwsHtml()
    }
}
