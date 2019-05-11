/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class UtilityTimeSunMoon {

    static func getSunTimesForHomescreen() -> String {
        let sunCalc = SunCalc()
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        let location = SunCalc.Location(latitude: Location.xDbl, longitude: Location.yDbl)
        var sunrise = ""
        var sunset = ""
        do {
            let rise = try sunCalc.time(ofDate: now, forSolarEvent: .sunrise, atLocation: location)
            sunrise = formatter.string(from: rise)
            let set = try sunCalc.time(ofDate: now, forSolarEvent: .sunset, atLocation: location)
            sunset = formatter.string(from: set)
        } catch let e as SunCalc.SolarEventError {
            switch e {
            case .sunNeverRise:
                print("Sun never rise")
            case .sunNeverSet:
                print("Sun never set")
            }
        } catch let e {
            print("Unknown error: \(e)")
        }
        return "Sunrise: " + sunrise + "  Sunset: " + sunset
    }

    static func getMoonTimesForHomescreen() -> String {
        let sunCalc = SunCalc()
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        let location = SunCalc.Location(latitude: Location.xDbl, longitude: Location.yDbl)
        var moonrise = ""
        var moonset = ""
        do {
            let moonTimes = try sunCalc.moonTimes(date: now, location: location)
            moonrise = formatter.string(from: moonTimes.moonSetTime)
            moonset = formatter.string(from: moonTimes.moonRiseTime)
        } catch let e as SunCalc.LunarEventError {
            switch e {
            case .moonNeverRise:
                print("Moon never rise")
            case .moonNeverSet:
                print("Moon never set")
            }
        } catch let e {
            print("Unknown error: \(e)")
        }
        return "Moonrise: " + moonrise + "  Moonset: " + moonset
    }

    static func getSunriseSunsetFromObs(_ obs: RID) -> (Date, Date) {
        var rise = Date()
        var set = Date()
        let sunCalc = SunCalc()
        let now = Date()
        let location = SunCalc.Location(latitude: obs.location.lat, longitude: obs.location.lon)
        do {
            rise = try sunCalc.time(ofDate: now, forSolarEvent: .sunrise, atLocation: location)
            set = try sunCalc.time(ofDate: now, forSolarEvent: .sunset, atLocation: location)
        } catch let e as SunCalc.SolarEventError {
            switch e {
            case .sunNeverRise:
                print("Sun never rise")
            case .sunNeverSet:
                print("Sun never set")
            }
        } catch let e {
            print("Unknown error: \(e)")
        }
        return(rise, set)
    }
}
