/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class ObjectForecastPackageCurrentConditions {

    var data = ""
    var iconUrl = ""
    private var conditionsTimeStr = ""
    var status = ""
    var topLine = ""
    var middleLine = ""
    var temperature = ""
    var windChill = ""
    var heatIndex = ""
    var dewpoint = ""
    var relativeHumidity = ""
    var seaLevelPressure = ""
    var windDirection = ""
    var windSpeed = ""
    var windGust = ""
    var visibility = ""
    var condition = ""
    var rawMetar = ""
    var spokenText = ""

    convenience init(_ locNum: Int) {
        self.init()
        if Location.isUS(locNum) {
            self.init(Location.getLatLon(locNum))
        } else {
            let html = UtilityCanada.getLocationHtml(Location.getLatLon(locNum))
            self.data = UtilityCanada.getConditions(html)
            self.status = UtilityCanada.getStatus(html)
        }
        self.formatCurrentConditions()
    }

    // US via LAT LON
    convenience init(_ location: LatLon) {
        self.init()
        let tmpArr = getConditionsViaMetar(location)
        data = tmpArr.conditionAsString
        iconUrl = tmpArr.iconUrl
        rawMetar = tmpArr.metar
        status = UtilityObs.getStatusViaMetar(conditionsTimeStr)
        formatCurrentConditions()
    }

    // CA
    convenience init(_ html: String) {
        self.init()
        data = UtilityCanada.getConditions(html)
        status = UtilityCanada.getStatus(html)
        formatCurrentConditions()
    }

    func getConditionsViaMetar(_ location: LatLon) -> (conditionAsString: String, iconUrl: String, metar: String) {
        var sb = ""
        let objMetar = ObjectMetar(location)
        conditionsTimeStr = objMetar.conditionsTimeStr
        self.temperature = objMetar.temperature + MyApplication.degreeSymbol
        self.windChill = objMetar.windChill + MyApplication.degreeSymbol
        self.heatIndex = objMetar.heatIndex + MyApplication.degreeSymbol
        self.dewpoint = objMetar.dewpoint + MyApplication.degreeSymbol
        self.relativeHumidity = objMetar.relativeHumidity + "%"
        self.seaLevelPressure = objMetar.seaLevelPressure
        self.windDirection = objMetar.windDirection
        self.windSpeed = objMetar.windSpeed
        self.windGust = objMetar.windGust
        self.visibility = objMetar.visibility
        self.condition = objMetar.condition
        sb += self.temperature
        if objMetar.windChill != "NA" {
            sb += "(" + self.windChill + ")"
        } else if objMetar.heatIndex != "NA" {
            sb += "(" + self.heatIndex + ")"
        }
        sb += " / " + self.dewpoint + "(" + self.relativeHumidity + ")" + " - "
        sb += seaLevelPressure +  " - " + windDirection + " " + windSpeed
        if windGust != "" {
            sb += " G "
        }
        sb += windGust + " mph" + " - " + visibility + " mi - " + condition
        return (sb, objMetar.icon, objMetar.rawMetar)
        //sb    String    "NA° / 22°(NA%) - 1016 mb - W 13 mph - 10 mi - Mostly Cloudy"
    }

    private func formatCurrentConditions() {
        let sep = " - "
        var tmpArrCc = data.split(sep)
        var retStr = ""
        var retStr2 = ""
        var tempArr = [String]()
        if tmpArrCc.count > 4 {
            tempArr = tmpArrCc[0].split("/")
            retStr = tmpArrCc[4].replaceAll("^ ", "") + " " + tempArr[0] + tmpArrCc[2]
            retStr2 = tempArr[1].replaceAll("^ ", "") + sep + tmpArrCc[1] + sep + tmpArrCc[3] + MyApplication.newline
            retStr2 += status
        }
        topLine = retStr
        middleLine = retStr2
        spokenText = condition + ", temperature is " + self.temperature + " with wind at " + self.windDirection + " "
            + self.windSpeed + "miles per hour" +
            " dew point is " + self.dewpoint + ", relative humidity is "
            + self.relativeHumidity + ", pressure in milli-bars is "
            + self.seaLevelPressure + ", vibilibity is " + self.visibility + " miles" + status
    }
}
