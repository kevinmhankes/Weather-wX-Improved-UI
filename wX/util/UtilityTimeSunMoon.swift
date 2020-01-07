/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
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
        var dawn = ""
        var dusk = ""
        do {
            let rise = try sunCalc.time(ofDate: now, forSolarEvent: .sunrise, atLocation: location)
            sunrise = formatter.string(from: rise)
            let set = try sunCalc.time(ofDate: now, forSolarEvent: .sunset, atLocation: location)
            sunset = formatter.string(from: set)
            let dawnTime = try sunCalc.time(ofDate: now, forSolarEvent: .dawn, atLocation: location)
            dawn = formatter.string(from: dawnTime)
            let duskTime = try sunCalc.time(ofDate: now, forSolarEvent: .dusk, atLocation: location)
            dusk = formatter.string(from: duskTime)
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
        return "Sunrise: " + sunrise + "  Sunset: " + sunset + MyApplication.newline + "Dawn: " + dawn + "  Dusk: " + dusk
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
