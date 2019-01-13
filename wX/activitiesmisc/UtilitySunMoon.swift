/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class UtilitySunMoon {

    // TODO consolidate error handling below

    static func computeData() -> String {
        var data = ""
        let sunCalc = SunCalc()
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        let fullMoonFormatter = DateFormatter()
        fullMoonFormatter.dateStyle = .short
        fullMoonFormatter.timeStyle = .none
        let location = SunCalc.Location(latitude: Location.xDbl, longitude: Location.yDbl)
        do {
            let time = try sunCalc.time(ofDate: now, forSolarEvent: .dawn, atLocation: location)
            let timeFormatted = formatter.string(from: time)
            data += "Dawn:     \(timeFormatted)"
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
            data += "Sunrise:  \(sunrise)"
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
            data += "Sunset:   \(sunset)"
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
            data += "Dusk:     \(astronomicalDusk)"
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
            data += "Moonset:  \(formatter.string(from: moonTimes.moonSetTime))"
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
        let moonIllumination = sunCalc.moonIllumination(date: now)
        data += "Moon Phase: "
            + moonPhaseFromIllumination(moonIllumination.phase)
            +  " "
            + String(moonIllumination.phase.roundTo(places: 3))
            + MyApplication.newline
        data += MyApplication.newline
        data += "Approximate Full Moon: "
        data += MyApplication.newline
        (1...360).forEach {
            let future = Calendar.current.date(byAdding: .day, value: $0, to: now)
            let moonIlluminationFuture = sunCalc.moonIllumination(date: future!)
            if moonIlluminationFuture.phase > 0.479 && moonIlluminationFuture.phase < 0.521 {
                data += fullMoonFormatter.string(from: future!) // + " " + String(moonIlluminationFuture.phase)
                data += MyApplication.newline
            }
        }
        data += MyApplication.newline
        data += "Moon phase description:" + MyApplication.newline
        data += "Phase    Name" + MyApplication.newline
        data += "0    New Moon" + MyApplication.newline
        data += "Waxing Crescent" + MyApplication.newline
        data += "0.25    First Quarter" + MyApplication.newline
        data += "Waxing Gibbous" + MyApplication.newline
        data += "0.5    Full Moon" + MyApplication.newline
        data += "Waning Gibbous" + MyApplication.newline
        data += "0.75    Last Quarter" + MyApplication.newline
        data += "Waning Crescent" + MyApplication.newline
        return data
    }

    static func moonPhaseFromIllumination(_ phase: Double) -> String {
        var phaseString = ""
        switch phase {
        case 0..<0.02: phaseString = "New Moon"
        case 0.02..<0.23: phaseString = "Waxing Crescent"
        case 0.23..<0.27: phaseString = "First Quarter"
        case 0.27..<0.47: phaseString = "Waxing Gibbous"
        case 0.47..<0.52: phaseString = "Full Moon"
        case 0.52..<0.73: phaseString = "Waning Gibbous"
        case 0.73..<0.77: phaseString = "Last Quarter"
        case 0.77..<1.01: phaseString = "Waning Crescent"
        default: phaseString = "unknown"
        }
        return phaseString
    }
}
