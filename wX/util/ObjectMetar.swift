/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
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
        UtilityUSv2.obsClosestClass = obsClosest.name
        if !decodeIcon {
            let observationData = ("https://api.weather.gov/stations/"
                + obsClosest.name +  "/observations/current").getNwsHtml()
            icon = observationData.parseFirst("\"icon\": \"(.*?)\",")
            condition = observationData.parseFirst("\"textDescription\": \"(.*?)\",")
        }
        let metarData = ("http://tgftp.nws.noaa.gov/data/observations/metar/decoded/"
            + obsClosest.name +  ".TXT").getHtml()
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
        heatIndex = metarData.parseFirst("Heat index: (.*?) F")
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
            if windBlob=="" {windBlob = metar.parse(patternMetarWxogl4)}
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

        let sunTimes = UtilityTime.getSunriseSunsetFromObs(obs)
        let currentTime = Date()
        let fallsBetween = (sunTimes.0 ... sunTimes.1).contains(currentTime)
        let currentTimeTomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        let fallsBetweenTomorrow = (sunTimes.0 ... sunTimes.1).contains(currentTimeTomorrow!)
        var timeOfDay = "night"
        if fallsBetween || fallsBetweenTomorrow {
            timeOfDay = "day"
        }
        let conditionModified = condition.split(";")[0]
        let shortCondition = iconFromCondition[conditionModified] ?? ""
        return "https://api.weather.gov/icons/land/" + timeOfDay + "/" + shortCondition + "?size=medium"
    }

    // FIXME move to seperate file
    // https://www.weather.gov/forecast-icons
    let iconFromCondition = [
        "Mostly Clear": "few",

        "Fair": "skc",
        "Clear": "skc",
        "Fair with Haze": "skc",
        "Clear with Haze": "skc",
        "Fair and Breezy": "skc",
        "Clear and Breezy": "skc",

        "A Few Clouds": "few",
        "A Few Clouds with Haze": "few",
        "A Few Clouds and Breezy": "few",

        "Partly Cloudy": "sct",
        "Partly Cloudy with Haze": "sct",
        "Partly Cloudy and Breezy": "sct",

        "Mostly Cloudy": "bkn",
        "Mostly Cloudy with Haze": "bkn",
        "Mostly Cloudy and Breezy": "bkn",

        "Overcast": "ovc",
        "Overcast with Haze": "ovc",
        "Overcast and Breezy": "ovc",

        "Snow": "snow",
        "Light Drizzle, Snow And Mist": "snow",
        "Light Snow": "snow",
        "Heavy Snow": "snow",
        "Snow Showers": "snow",
        "Light Snow Showers": "snow",
        "Heavy Snow Showers": "snow",
        "Showers Snow": "snow",
        "Light Showers Snow": "snow",
        "Heavy Showers Snow": "snow",
        "Snow Fog/Mist": "snow",
        "Light Snow Fog/Mist": "snow",
        "Heavy Snow Fog/Mist": "snow",
        "Snow Showers Fog/Mist": "snow",
        "Light Snow Showers Fog/Mist": "snow",
        "Heavy Snow Showers Fog/Mist": "snow",
        "Showers Snow Fog/Mist": "snow",
        "Light Showers Snow Fog/Mist": "snow",
        "Heavy Showers Snow Fog/Mist": "snow",
        "Snow Fog": "snow",
        "Light Snow Fog": "snow",
        "Heavy Snow Fog": "snow",
        "Snow Showers Fog": "snow",
        "Light Snow Showers Fog": "snow",
        "Heavy Snow Showers Fog": "snow",
        "Showers in Vicinity Snow": "snow",
        "Snow Showers in Vicinity": "snow",
        "Snow Showers in Vicinity Fog/Mist": "snow",
        "Snow Showers in Vicinity Fog": "snow",
        "Low Drifting Snow": "snow",
        "Blowing Snow": "snow",
        "Snow Low Drifting Snow": "snow",
        "Snow Blowing Snow": "snow",
        "Light Snow Low Drifting Snow": "snow",
        "Light Snow Blowing Snow": "snow",
        "Light Snow Blowing Snow Fog/Mist": "snow",
        "Heavy Snow Low Drifting Snow": "snow",
        "Heavy Snow Blowing Snow": "snow",
        "Thunderstorm Snow": "snow",
        "Light Thunderstorm Snow": "snow",
        "Heavy Thunderstorm Snow": "snow",
        "Snow Grains": "snow",
        "Light Snow Grains": "snow",
        "Heavy Snow Grains": "snow",
        "Heavy Blowing Snow": "snow",
        "Blowing Snow in Vicinity": "snow",

        "Rain Snow": "ra_sn",
        "Light Rain Snow": "ra_sn",
        "Heavy Rain Snow": "ra_sn",
        "Snow Rain": "ra_sn",
        "Light Snow Rain": "ra_sn",
        "Heavy Snow Rain": "ra_sn",
        "Drizzle Snow": "ra_sn",
        "Light Drizzle Snow": "ra_sn",
        "Heavy Drizzle Snow": "ra_sn",
        "Snow Drizzle": "ra_sn",
        "Light Snow Drizzle": "ra_sn",

        "Rain Ice Pellets": "ra_ip",
        "Light Rain Ice Pellets": "ra_ip",
        "Heavy Rain Ice Pellets": "ra_ip",
        "Drizzle Ice Pellets": "ra_ip",
        "Light Drizzle Ice Pellets": "ra_ip",
        "Heavy Drizzle Ice Pellets": "ra_ip",
        "Ice Pellets Rain": "ra_ip",
        "Light Ice Pellets Rain": "ra_ip",
        "Heavy Ice Pellets Rain": "ra_ip",
        "Ice Pellets Drizzle": "ra_ip",
        "Light Ice Pellets Drizzle": "ra_ip",
        "Heavy Ice Pellets Drizzle": "ra_ip",

        "Freezing Rain": "fzra",
        "Freezing Drizzle": "fzra",
        "Light Freezing Rain": "fzra",
        "Light Freezing Drizzle": "fzra",
        "Heavy Freezing Rain": "fzra",
        "Heavy Freezing Drizzle": "fzra",
        "Freezing Rain in Vicinity": "fzra",
        "Freezing Drizzle in Vicinity": "fzra",

        "Freezing Rain Rain": "ra_fzra",
        "Light Freezing Rain Rain": "ra_fzra",
        "Heavy Freezing Rain Rain": "ra_fzra",
        "Rain Freezing Rain": "ra_fzra",
        "Light Rain Freezing Rain": "ra_fzra",
        "Heavy Rain Freezing Rain": "ra_fzra",
        "Freezing Drizzle Rain": "ra_fzra",
        "Light Freezing Drizzle Rain": "ra_fzra",
        "Heavy Freezing Drizzle Rain": "ra_fzra",
        "Rain Freezing Drizzle": "ra_fzra",
        "Light Rain Freezing Drizzle": "ra_fzra",
        "Heavy Rain Freezing Drizzle": "ra_fzra",

        "Freezing Rain Snow": "fzra_sn",
        "Light Freezing Rain Snow": "fzra_sn",
        "Heavy Freezing Rain Snow": "fzra_sn",
        "Freezing Drizzle Snow": "fzra_sn",
        "Light Freezing Drizzle Snow": "fzra_sn",
        "Heavy Freezing Drizzle Snow": "fzra_sn",
        "Snow Freezing Rain": "fzra_sn",
        "Light Snow Freezing Rain": "fzra_sn",
        "Heavy Snow Freezing Rain": "fzra_sn",
        "Snow Freezing Drizzle": "fzra_sn",
        "Light Snow Freezing Drizzle": "fzra_sn",
        "Heavy Snow Freezing Drizzle": "fzra_sn",

        "Ice Pellets": "ip",
        "Light Ice Pellets": "ip",
        "Heavy Ice Pellets": "ip",
        "Ice Pellets in Vicinity": "ip",
        "Showers Ice Pellets": "ip",
        "Thunderstorm Ice Pellets": "ip",
        "Ice Crystals": "ip",
        "Hail": "ip",
        "Small Hail/Snow Pellets": "ip",
        "Light Small Hail/Snow Pellets": "ip",
        "Heavy small Hail/Snow Pellets": "ip",
        "Showers Hail": "ip",
        "Hail Showers": "ip",

        "Snow Ice Pellets": "snip",

        "Light Rain": "minus_ra",
        "Drizzle": "minus_ra",
        "Light Drizzle": "minus_ra",
        "Heavy Drizzle": "minus_ra",
        "Light Rain Fog/Mist": "minus_ra",
        "Drizzle Fog/Mist": "minus_ra",
        "Light Drizzle Fog/Mist": "minus_ra",
        "Heavy Drizzle Fog/Mist": "minus_ra",
        "Light Rain Fog": "minus_ra",
        "Drizzle Fog": "minus_ra",
        "Light Drizzle Fog": "minus_ra",
        "Heavy Drizzle Fog": "minus_ra",

        "Rain": "ra",
        "Heavy Rain": "ra",
        "Rain Fog/Mist": "ra",
        "Heavy Rain Fog/Mist": "ra",
        "Rain Fog": "ra",
        "Heavy Rain Fog": "ra",
        "Precipitation": "ra",

        "Rain Showers": "shra",
        "Light Rain Showers": "shra",
        "Light Rain and Breezy": "shra",
        "Heavy Rain Showers": "shra",
        "Rain Showers in Vicinity": "shra",
        "Light Showers Rain": "shra",
        "Heavy Showers Rain": "shra",
        "Showers Rain": "shra",
        "Showers Rain in Vicinity": "shra",
        "Rain Showers Fog/Mist": "shra",
        "Light Rain Showers Fog/Mist": "shra",
        "Heavy Rain Showers Fog/Mist": "shra",
        "Rain Showers in Vicinity Fog/Mist": "shra",
        "Light Showers Rain Fog/Mist": "shra",
        "Heavy Showers Rain Fog/Mist": "shra",
        "Showers Rain Fog/Mist": "shra",
        "Showers Rain in Vicinity Fog/Mist": "shra",

        "Showers in Vicinity": "hi_shwrs",
        "Showers in Vicinity Fog/Mist": "hi_shwrs",
        "Showers in Vicinity Fog": "hi_shwrs",
        "Showers in Vicinity Haze": "hi_shwrs",

        "Thunderstorm": "tsra",
        "Thunderstorm Rain": "tsra",
        "Light Thunderstorm Rain": "tsra",
        "Heavy Thunderstorm Rain": "tsra",
        "Thunderstorm Rain Fog/Mist": "tsra",
        "Light Thunderstorm Rain Fog/Mist": "tsra",
        "Heavy Thunderstorm Rain Fog and Windy": "tsra",
        "Heavy Thunderstorm Rain Fog/Mist": "tsra",
        "Thunderstorm Showers in Vicinity": "tsra",
        "Light Thunderstorm Rain Haze": "tsra",
        "Heavy Thunderstorm Rain Haze": "tsra",
        "Thunderstorm Fog": "tsra",
        "Light Thunderstorm Rain Fog": "tsra",
        "Heavy Thunderstorm Rain Fog": "tsra",
        "Thunderstorm Light Rain": "tsra",
        "Thunderstorm Heavy Rain": "tsra",
        "Thunderstorm Light Rain Fog/Mist": "tsra",
        "Thunderstorm Heavy Rain Fog/Mist": "tsra",
        "Thunderstorm in Vicinity Fog/Mist": "tsra",
        "Thunderstorm in Vicinity Haze": "tsra",
        "Thunderstorm Haze in Vicinity": "tsra",
        "Thunderstorm Light Rain Haze": "tsra",
        "Thunderstorm Heavy Rain Haze": "tsra",
        "Thunderstorm Light Rain Fog": "tsra",
        "Thunderstorm Heavy Rain Fog": "tsra",
        "Thunderstorm Hail": "tsra",
        "Light Thunderstorm Rain Hail": "tsra",
        "Heavy Thunderstorm Rain Hail": "tsra",
        "Thunderstorm Rain Hail Fog/Mist": "tsra",
        "Light Thunderstorm Rain Hail Fog/Mist": "tsra",
        "Heavy Thunderstorm Rain Hail Fog/Hail": "tsra",
        "Thunderstorm Showers in Vicinity Hail": "tsra",
        "Light Thunderstorm Rain Hail Haze": "tsra",
        "Heavy Thunderstorm Rain Hail Haze": "tsra",
        "Thunderstorm Hail Fog": "tsra",
        "Light Thunderstorm Rain Hail Fog": "tsra",
        "Heavy Thunderstorm Rain Hail Fog": "tsra",
        "Thunderstorm Light Rain Hail": "tsra",
        "Thunderstorm Heavy Rain Hail": "tsra",
        "Thunderstorm Light Rain Hail Fog/Mist": "tsra",
        "Thunderstorm Heavy Rain Hail Fog/Mist": "tsra",
        "Thunderstorm in Vicinity Hail": "tsra",
        "Thunderstorm in Vicinity Hail Haze": "tsra",
        "Thunderstorm Haze in Vicinity Hail": "tsra",
        "Thunderstorm Light Rain Hail Haze": "tsra",
        "Thunderstorm Heavy Rain Hail Haze": "tsra",
        "Thunderstorm Light Rain Hail Fog": "tsra",
        "Thunderstorm Heavy Rain Hail Fog": "tsra",
        "Thunderstorm Small Hail/Snow Pellets": "tsra",
        "Thunderstorm Rain Small Hail/Snow Pellets": "tsra",
        "Light Thunderstorm Rain Small Hail/Snow Pellets": "tsra",
        "Heavy Thunderstorm Rain Small Hail/Snow Pellets": "tsra",
        "Light Drizzle With Thunder In The Vicinity": "tsra",
        "Thunder": "tsra",
        "Rain With Thunder": "tsra",
        "Thunder In The Vicinity And Mist": "tsra",
        "Thunder In The Vicinity And Heavy Rain and Mist": "tsra",

        "Freezing With Thunder Rain And Mist": "tsra",
        "Heavy Rain With Thunder": "tsra",
        "Light Rain With Thunder": "tsra",

        "Thunderstorm in Vicinity": "hi_tsra",
        "Thunder In The Vicinity": "hi_tsra",
        "Thunderstorm in Vicinity Fog": "hi_tsra",
        "Lightning Observed": "hi_tsra",
        "Cumulonimbus Clouds, Lightning Observed": "hi_tsra",

        "Funnel Cloud": "fc",
        "Funnel Cloud in Vicinity": "fc",
        "Tornado/Water Spout": "fc",

        "Tornado": "tor",

        "Hurricane Warning": "hur_warn",

        "Hurricane Watch": "hur_watch",

        "Tropical Storm Warning": "ts_warn",

        "Tropical Storm Watch": "ts_watch",

        "Tropical Storm Conditions presently exist w/Hurricane Warning in effect": "ts_nowarn",

        "Windy": "wind_skc",
        "Breezy": "wind_skc",
        "Fair and Windy": "wind_skc",

        "A Few Clouds and Windy": "wind_few",

        "Partly Cloudy and Windy": "wind_sct",

        "Mostly Cloudy and Windy": "wind_bkn",

        "Overcast and Windy": "wind_ovc",

        "Dust": "du",
        "Low Drifting Dust": "du",
        "Blowing Dust": "du",
        "Blowing Widespread Dust": "du",
        "Sand": "du",
        "Blowing Sand": "du",
        "Low Drifting Sand": "du",
        "Dust/Sand Whirls": "du",
        "Dust/Sand Whirls in Vicinity": "du",
        "Dust Storm": "du",
        "Heavy Dust Storm": "du",
        "Dust Storm in Vicinity": "du",
        "Sand Storm": "du",
        "Heavy Sand Storm": "du",
        "Sand Storm in Vicinity": "du",

        "Smoke": "fu",

        "Haze": "hz",
        "Hot": "hot",

        "Cold": "cold",

        "Blizzard": "blizzard",

        "Fog": "fg",
        "Fog/Mist": "fg",
        "Freezing Fog": "fg",
        "Shallow Fog": "fg",
        "Partial Fog": "fg",
        "Patches of Fog": "fg",
        "Fog in Vicinity": "fg",
        "Freezing Fog in Vicinity": "fg",
        "Shallow Fog in Vicinity": "fg",
        "Partial Fog in Vicinity": "fg",
        "Patches of Fog in Vicinity": "fg",
        //"Showers in Vicinity Fog": "fg",
        "Light Freezing Fog": "fg",
        "Heavy Freezing Fog": "fg",
        "Precipitation and Mist": "fg"
    ]
}
