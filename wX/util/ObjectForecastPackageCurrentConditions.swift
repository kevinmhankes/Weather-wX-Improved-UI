/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class ObjectForecastPackageCurrentConditions {

    var data1 = ""
    var iconUrl = ""
    private var conditionsTimeStr = ""
    var status = ""
    var ccLine1 = ""
    var ccLine2 = ""
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

    convenience init(_ locNum: Int) {
        self.init(Location.getLatLon(locNum))
    }

    // US via LAT LON
    convenience init(_ location: LatLon) {
        self.init()
        if MyApplication.currentConditionsViaMetar {
            let tmpArr = getConditionsViaMetar(location)
            data1 = tmpArr.0
            iconUrl = tmpArr.1
            rawMetar = tmpArr.2
        } else {
            let tmpArr = getConditions(location)
            data1 = tmpArr.0
            iconUrl = tmpArr.1
        }
        if MyApplication.currentConditionsViaMetar {
            status = UtilityUSv2.getStatusViaMetar(conditionsTimeStr)
        } else {
            status = UtilityUSv2.getStatus(conditionsTimeStr)
        }
        formatCC()
    }

    // CA
    convenience init(_ html: String) {
        self.init()
        data1 = UtilityCanada.getConditions(html)
        status = UtilityCanada.getStatus(html)
        formatCC()
    }

    // CA
    static func createForCanada(_ html: String) -> ObjectForecastPackageCurrentConditions {
        let obj = ObjectForecastPackageCurrentConditions()
        obj.data1 = UtilityCanada.getConditions(html)
        obj.status = UtilityCanada.getStatus(html)
        obj.formatCC()
        return obj
    }

    func getConditionsViaMetar(_ location: LatLon) -> (String, String, String) {
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

    func getConditions(_ location: LatLon) -> (String, String) {
        var sb = ""
        let obsClosest = UtilityUSv2.getObsFromLatLon(location)
        let observationData = ("https://api.weather.gov/stations/" + obsClosest +  "/observations/current").getNwsHtml()
        let icon = observationData.parseFirst("\"icon\": \"(.*?)\",")
        let condition = observationData.parseFirst("\"textDescription\": \"(.*?)\",")
        var temperature = observationData.parseFirst("\"temperature\":.*?\"value\": (.*?),")
        var dewpoint = observationData.parseFirst("\"dewpoint\":.*?\"value\": (.*?),")
        var windDirection = observationData.parseFirst("\"windDirection\":.*?\"value\": (.*?),")
        var windSpeed = observationData.parseFirst("\"windSpeed\":.*?\"value\": (.*?),")
        var windGust = observationData.parseFirst("\"windGust\":.*?\"value\": (.*?),")
        var seaLevelPressure = observationData.parseFirst("\"barometricPressure\":.*?\"value\": (.*?),")
        var visibility = observationData.parseFirst("\"visibility\":.*?\"value\": (.*?),")
        var relativeHumidity = observationData.parseFirst("\"relativeHumidity\":.*?\"value\": (.*?),")
        var windChill = observationData.parseFirst("\"windChill\":.*?\"value\": (.*?),")
        var heatIndex = observationData.parseFirst("\"heatIndex\":.*?\"value\": (.*?),")
        conditionsTimeStr = observationData.parseFirst("\"timestamp\": \"(.*?)\"")
        if !temperature.contains("NA") &&  temperature != "null" {
            if let tempD = Double(temperature) {
                if UIPreferences.unitsF {
                    temperature = tempD.celsiusToFarenheit()
                } else {
                    temperature = tempD.roundToString()
                }
            }
        } else {
            temperature = "NA"
        }
        if !windChill.contains("NA") &&  windChill != "null" {
            if let tempD = Double(windChill) {
                if UIPreferences.unitsF {
                    windChill = tempD.celsiusToFarenheit()
                } else {
                    windChill = tempD.roundToString()
                }
            }
        } else {
            windChill = "NA"
        }
        if !heatIndex.contains("NA") &&  heatIndex != "null" {
            if let tempD = Double(heatIndex) {
                if UIPreferences.unitsF {
                    heatIndex = tempD.celsiusToFarenheit()
                } else {
                    heatIndex = tempD.roundToString()
                }
            }
        } else {
            heatIndex = "NA"
        }
        if !dewpoint.contains("NA") &&  dewpoint != "null" {
            if let tempD = Double(dewpoint) {
                if UIPreferences.unitsF {
                    dewpoint = tempD.celsiusToFarenheit()
                } else {
                    dewpoint = tempD.roundToString()
                }
            }
        } else {
            dewpoint = "NA"
        }
        if !windDirection.contains("NA") &&  windDirection != "null" {
            if windDirection != "" && windDirection != "null" {
                windDirection = UtilityMath.convertWindDir(Double(windDirection) ?? 0.0)
            }
        } else {
            windDirection = "NA"
        }
        if windSpeed != "null" {
            if let tempD = Double(windSpeed) {
                windSpeed = UtilityMath.metersPerSecondtoMPH(tempD)
            } else {
                windSpeed = "NA"
            }
        } else {
            windSpeed = "NA"
        }
        if !relativeHumidity.contains("NA") &&  relativeHumidity != "null" {
            if let tempD = Double(relativeHumidity) {
                relativeHumidity = tempD.roundToString()
            }
        } else {
            relativeHumidity = "NA"
        }
        if let tempD = Double(visibility) {
            visibility = UtilityMath.metersToMileRounded(tempD)
        } else {
            visibility = "NA"
        }
        if let tempD = Double(seaLevelPressure) {
            if !UIPreferences.unitsM {
                seaLevelPressure = UtilityMath.pressureMBtoIn(seaLevelPressure)
            } else {
                seaLevelPressure = UtilityMath.pressurePAtoMB(tempD) + " mb"
            }
        } else {
            seaLevelPressure = "NA"
        }
        if windGust != "null" {
            if let tempD = Double(windGust) {
                windGust = UtilityMath.metersPerSecondtoMPH(tempD)
                windGust = "G " + windGust
            }
        } else {
            windGust = ""
        }
        self.temperature = temperature + MyApplication.degreeSymbol
        self.windChill = windChill + MyApplication.degreeSymbol
        self.heatIndex = heatIndex + MyApplication.degreeSymbol
        self.dewpoint = dewpoint + MyApplication.degreeSymbol
        self.relativeHumidity = relativeHumidity + "%"
        self.seaLevelPressure = seaLevelPressure
        self.windDirection = windDirection
        self.windSpeed = windSpeed
        self.windGust = windGust
        self.visibility = visibility
        self.condition = condition
        sb += temperature
        sb += MyApplication.degreeSymbol
        if windChill != "NA" {
            sb += "(" + windChill + MyApplication.degreeSymbol + ")"
        } else if heatIndex != "NA" {
            sb += "(" + heatIndex + MyApplication.degreeSymbol + ")"
        }
        sb += " / " + dewpoint + MyApplication.degreeSymbol + "(" + relativeHumidity + "%)" + " - "
        sb += seaLevelPressure +  " - " + windDirection + " " + windSpeed
        if windGust != "" {
            sb += " "
        }
        sb += windGust + " mph" + " - " + visibility + " mi - " + condition
        return (sb, icon)
    }

    func formatCC() {
        let sep = " - "
        var tmpArrCc = data1.split(sep)
        var retStr = ""
        var retStr2 = ""
        var tempArr = [String]()
        if tmpArrCc.count > 4 {
            tempArr = tmpArrCc[0].split("/")
            retStr = tmpArrCc[4].replaceAll("^ ", "") + " " + tempArr[0] + tmpArrCc[2]
            retStr2 = tempArr[1].replaceAll("^ ", "") + sep + tmpArrCc[1] + sep + tmpArrCc[3] + MyApplication.newline
            retStr2 += status
        }
        ccLine1 = retStr
        ccLine2 = retStr2
    }
}
