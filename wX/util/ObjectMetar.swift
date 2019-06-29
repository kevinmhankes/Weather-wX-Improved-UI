/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class ObjectMetar {

    let decodeIcon = true
    var condition = ""
    var temperature = ""
    var dewpoint = ""
    var windDirection = ""
    var windSpeed = ""
    var windGust = ""
    var seaLevelPressure = ""
    var visibility = ""
    var relativeHumidity = ""
    var windChill = ""
    var heatIndex = ""
    var conditionsTimeStr = ""
    var icon = ""
    var rawMetar = ""
    var metarSkyCondition = ""
    var metarWeatherCondition = ""

    init(_ location: LatLon) {
        let obsClosest = UtilityMetar.findClosestObservation(location)
        UtilityObs.obsClosestClass = obsClosest.name
        if !decodeIcon {
            let observationData = ("https://api.weather.gov/stations/"
                + obsClosest.name +  "/observations/current").getNwsHtml()
            icon = observationData.parseFirst("\"icon\": \"(.*?)\",")
            condition = observationData.parseFirst("\"textDescription\": \"(.*?)\",")
        }
        let metarData = (WXGLDownload.nwsRadarPub
            + "/data/observations/metar/decoded/" + obsClosest.name +  ".TXT").getHtml()
        temperature = metarData.parseFirst("Temperature: (.*?) F")
        dewpoint = metarData.parseFirst("Dew Point: (.*?) F")
        windDirection = metarData.parseFirst("Wind: from the (.*?) \\(.*? degrees\\) at .*? MPH ")
        windSpeed = metarData.parseFirst("Wind: from the .*? \\(.*? degrees\\) at (.*?) MPH ")
        windGust = metarData.parseFirst("Wind: from the .*? \\(.*? degrees\\) at .*? "
            + "MPH \\(.*? KT\\) gusting to (.*?) MPH")
        seaLevelPressure = metarData.parseFirst("Pressure \\(altimeter\\): .*? in. Hg \\((.*?) hPa\\)")
        visibility = metarData.parseFirst("Visibility: (.*?) mile")
        relativeHumidity = metarData.parseFirst("Relative Humidity: (.*?)%")
        windChill = metarData.parseFirst("Windchill: (.*?) F")
        //heatIndex = metarData.parseFirst("Heat index: (.*?) F")
        heatIndex = UtilityMath.heatIndex(temperature, relativeHumidity)
        rawMetar = metarData.parseFirst("ob: (.*?)" + MyApplication.newline)
        metarSkyCondition = metarData.parseFirst("Sky conditions: (.*?)" + MyApplication.newline).capitalized
        metarWeatherCondition = metarData.parseFirst("Weather: (.*?)" + MyApplication.newline).capitalized
        if decodeIcon {
            if metarWeatherCondition == "" {
                condition = metarSkyCondition
            } else {
                condition = metarWeatherCondition
            }
            condition = condition.replace("; Lightning Observed", "")
            condition = condition.replace("; Cumulonimbus Clouds, Lightning Observed", "")
            if condition == "Mist" {
                condition = "Fog/Mist"
            }
            icon = decodeIconFromMetar(condition, obsClosest)
            condition = condition.replace(";", " and")
        }

        //decodeMetar(rawMetar)
        // forecast.weather.gov/zipcity.php?inputstring=KSAD
        //rawMetar += metarSkyCondition + " " + metarWeatherCondition + " icon:" + icon

        // METAR Condition Icon
        // SCT Partly Cloudy sct
        // FEW Mostly Clear few
        // OVC Overcast (Cloudy) ovc
        // CLR Clear skc
        // -RA BR Overcast Light Rain; Mist (Light Rain and Fog/Mist)  rain
        // -SN BR Obscured Light Snow; Mist (Light Snow) snow

        /*
         ANN ARBOR MUNICIPAL AIRPORT, MI, United States (KARB) 42-13N 083-45W 251M
         Feb 11, 2018 - 06:53 PM EST / 2018.02.11 2353 UTC
         Wind: from the WSW (250 degrees) at 9 MPH (8 KT):0
         Visibility: 10 mile(s):0
         Sky conditions: clear
         Temperature: 24.1 F (-4.4 C)
         Windchill: 14 F (-10 C):1
         Dew Point: 19.9 F (-6.7 C)
         Relative Humidity: 83%
         Pressure (altimeter): 30.02 in. Hg (1016 hPa)
         Pressure tendency: 0.12 inches (4.1 hPa) higher than three hours ago
         ob: KARB 112353Z 25008KT 10SM CLR M04/M07 A3002 RMK AO2 SLP177 60000 T10441067 11033 21044 51041
         cycle: 0
         
         Oceanside, Oceanside Municipal Airport, CA, United States (KOKH) 33-13-10N 117-20-58W 8M
         Dec 31, 2008 - 10:56 AM EST / 2008.12.31 1556 UTC
         Wind: from the SW (230 degrees) at 16 MPH (14 KT) gusting to 26 MPH (23 KT):0
         Visibility: 10 mile(s):0
         Sky conditions: overcast
         Temperature: 37 F (3 C)
         Dew Point: 32 F (0 C)
         Relative Humidity: 80%
         Pressure (altimeter): 29.95 in. Hg (1014 hPa)
         ob: KOKH 311556Z AUTO 23014G23KT 10SM SCT017 BKN041 OVC065 03/00 A2995 RMK FIRST
         cycle: 16
        
         */

        let metarDataList = metarData.split(MyApplication.newline)
        if metarDataList.count > 2 {
            let localStatus = metarDataList[1].split("/")
            if localStatus.count > 1 {
                conditionsTimeStr = UtilityTime.convertFromUTCForMetar(localStatus[1].replace(" UTC", ""))
            }
        }
        seaLevelPressure = changePressureUnits(seaLevelPressure)
        temperature = changeDegreeUnits(temperature)
        dewpoint = changeDegreeUnits(dewpoint)
        windChill = changeDegreeUnits(windChill)
        heatIndex = changeDegreeUnits(heatIndex)
        if windSpeed == "" {
            windSpeed = "0"
        }
        if condition == "" {
            condition = "NA"
        }
    }

    func changeDegreeUnits(_ value: String) -> String {
        var newValue = "NA"
        if value != "" {
            let tempD = Double(value) ?? 0.0
            if UIPreferences.unitsF {
                newValue = tempD.roundToString()
            } else {
                newValue = tempD.farenheitToCelsius()
            }
        }
        return newValue
    }

    func changePressureUnits(_ value: String) -> String {
        var newValue = "NA"
        if !UIPreferences.unitsM {
            newValue = UtilityMath.pressureMBtoIn(value)
        } else {
            newValue = value + " mb"
        }
        return newValue
    }

    func decodeMetar(_ metar: String) {
        let patternMetarWxogl1 = ".*? (M?../M?..) .*?"
        let patternMetarWxogl2 = ".*? A([0-9]{4})"
        let patternMetarWxogl3 = "AUTO ([0-9].*?KT) .*?"
        let patternMetarWxogl4 = "Z ([0-9].*?KT) .*?"
        var tmpBlob = ""
        var pressureBlob = ""
        var windBlob = ""
        var visBlob = ""
        var visBlobArr = [String]()
        var TDArr = [String]()
        var temperature = ""
        var dewpoint = ""
        var windDir = ""
        var windInKt = ""
        var windgustInKt = ""
        var windDirD = 0.0
        if (metar.hasPrefix("K") || metar.hasPrefix("P")) && !metar.contains("NIL") {
            tmpBlob = metar.parse(patternMetarWxogl1)
            TDArr = tmpBlob.split("/")
            pressureBlob = metar.parse(patternMetarWxogl2)
            windBlob = metar.parse(patternMetarWxogl3)
            if windBlob == "" {
                windBlob = metar.parse(patternMetarWxogl4)
            }
            visBlob = metar.parse(" ([0-9].*?SM) ")
            visBlobArr = visBlob.split(" ")
            visBlob = visBlobArr[visBlobArr.count - 1].replace("SM", "")
            if pressureBlob.count == 4 {
                pressureBlob = pressureBlob.insert(pressureBlob.count - 2, ".")
                pressureBlob = UtilityMath.unitsPressure(pressureBlob)
            }
            if windBlob.contains("KT") && windBlob.count == 7 {
                windDir = windBlob.substring(0, 3)
                windInKt = windBlob.substring(3, 5)
                windDirD = Double(windDir) ?? 0.0
                windBlob = windDir + " (" + UtilityMath.convertWindDir(windDirD) + ") " + windInKt + " kt"
            } else if windBlob.contains("KT") && windBlob.count == 10 {
                windDir = windBlob.substring(0, 3)
                windInKt = windBlob.substring(3, 5)
                windgustInKt = windBlob.substring(6, 8)
                windDirD = Double(windDir) ?? 0.0
                windBlob = windDir + " (" + UtilityMath.convertWindDir(windDirD) + ") "
                    + windInKt + " G " + windgustInKt + " kt"
            }
            if TDArr.count > 1 {
                temperature = TDArr[0]
                dewpoint = TDArr[1]
                temperature = UtilityMath.celsiusToFarenheit(temperature.replace("M", "-")).replace(".0", "")
                dewpoint = UtilityMath.celsiusToFarenheit(dewpoint.replace("M", "-")).replace(".0", "")
            }
        }
    }

    func decodeIconFromMetar(_ condition: String, _ obs: RID) -> String {
        // https://api.weather.gov/icons/land/day/ovc?size=medium
        let sunTimes = UtilityTimeSunMoon.getSunriseSunsetFromObs(obs)
        let currentTime = Date()
        let fallsBetween = (sunTimes.0 ... sunTimes.1).contains(currentTime)
        let currentTimeTomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        let fallsBetweenTomorrow = (sunTimes.0 ... sunTimes.1).contains(currentTimeTomorrow!)
        var timeOfDay = "night"
        if fallsBetween || fallsBetweenTomorrow {
            timeOfDay = "day"
        }
        let conditionModified = condition.split(";")[0]
        print("CONDITION: " + conditionModified)
        let shortCondition = UtilityMetarConditions.iconFromCondition[conditionModified] ?? ""
        return "https://api.weather.gov/icons/land/" + timeOfDay + "/" + shortCondition + "?size=medium"
    }
}
