/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class UtilitySunMoon {

    static func computeData() -> String {
        var data = ""
        let sunCalc = SunCalc()
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        let location = SunCalc.Location(latitude: Location.xDbl, longitude: Location.yDbl)
        do {
            let time = try sunCalc.time(ofDate: now, forSolarEvent: .dawn, atLocation: location)
            let timeFormatted = formatter.string(from: time)
            data += "Dawn: \(timeFormatted)"
            data += MyApplication.newline
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
        do {
            let rise = try sunCalc.time(ofDate: now, forSolarEvent: .sunrise, atLocation: location)
            let sunrise = formatter.string(from: rise)
            data += "Sunrise: \(sunrise)"
            data += MyApplication.newline
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
        do {
            let set = try sunCalc.time(ofDate: now, forSolarEvent: .sunset, atLocation: location)
            let sunset = formatter.string(from: set)
            data += "Sunset: \(sunset)"
            data += MyApplication.newline
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
        do {
            let aDusk = try sunCalc.time(ofDate: now, forSolarEvent: .dusk, atLocation: location)
            let astronomicalDusk = formatter.string(from: aDusk)
            data += "Dusk: \(astronomicalDusk)"
            data += MyApplication.newline
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
        do {
            let moonTimes = try sunCalc.moonTimes(date: now, location: location)
            data += "Moonset: \(formatter.string(from: moonTimes.moonSetTime))"
            data += MyApplication.newline
            data += "Moonrise: \(formatter.string(from: moonTimes.moonRiseTime))"
            data += MyApplication.newline
        } catch let e as SunCalc.LunarEventError {
            switch e {
            case .moonNeverRise:
                print("Moon never rise")
            case .moonNeverSet:
                print("Moon never set")
            }
        } catch {
            // Catch any other errors
        }
        return data
    }
}
