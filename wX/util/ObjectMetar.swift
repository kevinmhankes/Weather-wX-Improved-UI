/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class ObjectMetar {

    private let decodeIcon = true
    var condition = ""
    var temperature: String
    var dewPoint: String
    let windDirection: String
    var windSpeed: String
    var windGust: String
    var seaLevelPressure: String
    let visibility: String
    let relativeHumidity: String
    var windChill: String
    var heatIndex: String
    var conditionsTimeString = ""
    var icon = ""
    let rawMetar: String
    private let metarSkyCondition: String
    private let metarWeatherCondition: String

    init(_ location: LatLon) {
        let obsClosest = UtilityMetar.findClosestObservation(location)
        UtilityObs.obsClosestClass = obsClosest.name
        if !decodeIcon {
            let observationData = ("https://api.weather.gov/stations/" + obsClosest.name + "/observations/current").getNwsHtml()
            icon = observationData.parseFirst("\"icon\": \"(.*?)\",")
            condition = observationData.parseFirst("\"textDescription\": \"(.*?)\",")
        }
        let metarData = (GlobalVariables.tgftpSitePrefix + "/data/observations/metar/decoded/" + obsClosest.name + ".TXT").getHtml()
        temperature = metarData.parseFirst("Temperature: (.*?) F")
        dewPoint = metarData.parseFirst("Dew Point: (.*?) F")
        windDirection = metarData.parseFirst("Wind: from the (.*?) \\(.*? degrees\\) at .*? MPH ")
        windSpeed = metarData.parseFirst("Wind: from the .*? \\(.*? degrees\\) at (.*?) MPH ")
        windGust = metarData.parseFirst("Wind: from the .*? \\(.*? degrees\\) at .*? " + "MPH \\(.*? KT\\) gusting to (.*?) MPH")
        seaLevelPressure = metarData.parseFirst("Pressure \\(altimeter\\): .*? in. Hg \\((.*?) hPa\\)")
        visibility = metarData.parseFirst("Visibility: (.*?) mile")
        relativeHumidity = metarData.parseFirst("Relative Humidity: (.*?)%")
        windChill = metarData.parseFirst("Windchill: (.*?) F")
        heatIndex = UtilityMath.heatIndex(temperature, relativeHumidity)
        rawMetar = metarData.parseFirst("ob: (.*?)" + GlobalVariables.newline)
        metarSkyCondition = metarData.parseFirst("Sky conditions: (.*?)" + GlobalVariables.newline).capitalized
        metarWeatherCondition = metarData.parseFirst("Weather: (.*?)" + GlobalVariables.newline).capitalized
        if decodeIcon {
            if metarWeatherCondition == "" || metarWeatherCondition.contains("Inches Of Snow On Ground") {
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

        let metarDataList = metarData.split(GlobalVariables.newline)
        if metarDataList.count > 2 {
            let localStatus = metarDataList[1].split("/")
            if localStatus.count > 1 {
                conditionsTimeString = UtilityTime.convertFromUTCForMetar(localStatus[1].replace(" UTC", ""))
            }
        }
        seaLevelPressure = changePressureUnits(seaLevelPressure)
        temperature = changeDegreeUnits(temperature)
        dewPoint = changeDegreeUnits(dewPoint)
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
        if value != "" {
            return (Double(value) ?? 0.0).roundToString()
        } else {
            return "NA"
        }
    }

    func changePressureUnits(_ value: String) -> String {
        if !UIPreferences.unitsM {
            return UtilityMath.pressureMBtoIn(value)
        } else {
            return value + " mb"
        }
    }

    func decodeIconFromMetar(_ condition: String, _ obs: RID) -> String {
        // https://api.weather.gov/icons/land/day/ovc?size=medium
        let sunTimes = UtilityTimeSunMoon.getSunriseSunsetFromObs(obs)
        let currentTime = Date()
        let fallsBetween = (sunTimes.0 ... sunTimes.1).contains(currentTime)
        let currentTimeTomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        let fallsBetweenTomorrow = (sunTimes.0 ... sunTimes.1).contains(currentTimeTomorrow!)
        let timeOfDay = fallsBetween || fallsBetweenTomorrow ? "day" : "night"
        let conditionModified = condition.split(";")[0]
        let shortCondition = UtilityMetarConditions.iconFromCondition[conditionModified] ?? ""
        return GlobalVariables.nwsApiUrl + "/icons/land/" + timeOfDay + "/" + shortCondition + "?size=medium"
    }
}
