/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
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
    private var dewpoint = ""
    private var relativeHumidity = ""
    private var seaLevelPressure = ""
    private var windDirection = ""
    private var windSpeed = ""
    private var windGust = ""
    private var visibility = ""
    private var condition = ""
    private var rawMetar = ""
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
    
    // US via LAT LON (called from adhoc location and from other init)
    convenience init(_ location: LatLon) {
        self.init()
        let conditions = getConditionsViaMetar(location)
        data = conditions.conditionAsString
        iconUrl = conditions.iconUrl
        rawMetar = conditions.metar
        status = UtilityObs.getStatusViaMetar(conditionsTimeString)
        formatCurrentConditions()
    }
    
    // FIXME don't use named tuple for language consistency
    func getConditionsViaMetar(_ location: LatLon) -> (conditionAsString: String, iconUrl: String, metar: String) {
        var string = ""
        let objMetar = ObjectMetar(location)
        conditionsTimeString = objMetar.conditionsTimeString
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
        string += self.temperature
        if objMetar.windChill != "NA" {
            string += "(" + self.windChill + ")"
        } else if objMetar.heatIndex != "NA" {
            string += "(" + self.heatIndex + ")"
        }
        string += " / " + self.dewpoint + "(" + self.relativeHumidity + ")" + " - "
        string += seaLevelPressure +  " - " + windDirection + " " + windSpeed
        if windGust != "" { string += " G " }
        string += windGust + " mph" + " - " + visibility + " mi - " + condition
        return (string, objMetar.icon, objMetar.rawMetar)
        //sb    String    "NA° / 22°(NA%) - 1016 mb - W 13 mph - 10 mi - Mostly Cloudy"
    }
    
    private func formatCurrentConditions() {
        let separator = " - "
        let dataList = data.split(separator)
        var topLineLocal = ""
        var middleLineLocal = ""
        var list = [String]()
        if dataList.count > 4 {
            list = dataList[0].split("/")
            topLineLocal = dataList[4].replaceAll("^ ", "") + " " + list[0] + dataList[2]
            middleLineLocal = list[1].replaceAll("^ ", "") + separator + dataList[1] + separator + dataList[3] + MyApplication.newline
            middleLineLocal += status
        }
        topLine = topLineLocal
        middleLine = middleLineLocal
        spokenText = condition + ", temperature is " + self.temperature + " with wind at " + self.windDirection + " "
            + self.windSpeed + "miles per hour" +
            " dew point is " + self.dewpoint + ", relative humidity is "
            + self.relativeHumidity + ", pressure in milli-bars is "
            + self.seaLevelPressure + ", visibility is " + self.visibility + " miles" + status
    }
}
