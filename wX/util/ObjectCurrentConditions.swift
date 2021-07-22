/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class ObjectCurrentConditions {

    var data = ""
    var iconUrl = ""
    private var conditionsTimeString = ""
    var status = ""
    var topLine = ""
    var middleLine = ""
    private var temperature = ""
    private var windChill = ""
    private var heatIndex = ""
    private var dewPoint = ""
    private var relativeHumidity = ""
    private var seaLevelPressure = ""
    private var windDirection = ""
    private var windSpeed = ""
    private var windGust = ""
    private var visibility = ""
    private var condition = ""
    var spokenText = ""

    convenience init(_ locNum: Int) {
        self.init()
        if Location.isUS(locNum) {
            self.init(Location.getLatLon(locNum))
        } else {
            let html = UtilityCanada.getLocationHtml(Location.getLatLon(locNum))
            data = UtilityCanada.getConditions(html)
            status = UtilityCanada.getStatus(html)
        }
        formatCurrentConditions()
    }

    // US via LAT LON (called from adhoc location and from other init)
    convenience init(_ location: LatLon) {
        self.init()
        let conditions = getConditionsViaMetar(location)
        data = conditions.conditionAsString
        iconUrl = conditions.iconUrl
        // rawMetar = conditions.metar
        status = UtilityObs.getStatusViaMetar(conditionsTimeString)
        formatCurrentConditions()
    }

    // FIXME don't use named tuple for language consistency
    func getConditionsViaMetar(_ location: LatLon) -> (conditionAsString: String, iconUrl: String, metar: String) {
        var s = ""
        let objectMetar = ObjectMetar(location)
        conditionsTimeString = objectMetar.conditionsTimeString
        temperature = objectMetar.temperature + GlobalVariables.degreeSymbol
        windChill = objectMetar.windChill + GlobalVariables.degreeSymbol
        heatIndex = objectMetar.heatIndex + GlobalVariables.degreeSymbol
        dewPoint = objectMetar.dewPoint + GlobalVariables.degreeSymbol
        relativeHumidity = objectMetar.relativeHumidity + "%"
        seaLevelPressure = objectMetar.seaLevelPressure
        windDirection = objectMetar.windDirection
        windSpeed = objectMetar.windSpeed
        windGust = objectMetar.windGust
        visibility = objectMetar.visibility
        condition = objectMetar.condition
        s += temperature
        if objectMetar.windChill != "NA" {
            s += "(" + windChill + ")"
        } else if objectMetar.heatIndex != "NA" {
            s += "(" + heatIndex + ")"
        }
        s += " / " + dewPoint + "(" + relativeHumidity + ")" + " - "
        s += seaLevelPressure + " - " + windDirection + " " + windSpeed
        if windGust != "" {
            s += " G "
        }
        s += windGust + " mph" + " - " + visibility + " mi - " + condition
        return (s, objectMetar.icon, objectMetar.rawMetar)
        // sb String "NA° / 22°(NA%) - 1016 mb - W 13 mph - 10 mi - Mostly Cloudy"
    }

    private func formatCurrentConditions() {
        let separator = " - "
        let dataList = data.split(separator)
        var topLineLocal = ""
        var middleLineLocal = ""
        if dataList.count > 4 {
            let list = dataList[0].split("/")
            topLineLocal = dataList[4].replaceAll("^ ", "") + " " + list[0] + dataList[2]
            middleLineLocal = list[1].replaceAll("^ ", "") + separator + dataList[1] + separator + dataList[3] + GlobalVariables.newline
            middleLineLocal += status
        }
        topLine = topLineLocal
        middleLine = middleLineLocal
        spokenText = condition + ", temperature is " + temperature + " with wind at " + windDirection + " "
            + windSpeed + "miles per hour" +
            " dew point is " + dewPoint + ", relative humidity is "
            + relativeHumidity + ", pressure in milli-bars is "
            + seaLevelPressure + ", visibility is " + visibility + " miles" + status
    }
}
