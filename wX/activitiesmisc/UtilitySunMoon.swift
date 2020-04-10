/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
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
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        let fullMoonFormatter = DateFormatter()
        fullMoonFormatter.dateStyle = .short
        fullMoonFormatter.timeStyle = .none
        let location = SunCalc.Location(latitude: Location.xDbl, longitude: Location.yDbl)
        do {
            let time = try sunCalc.time(ofDate: now, forSolarEvent: .dawn, atLocation: location)
            let timeFormatted = formatter.string(from: time)
            data += "Dawn:     " + timeFormatted + MyApplication.newline
            let rise = try sunCalc.time(ofDate: now, forSolarEvent: .sunrise, atLocation: location)
            let sunrise = formatter.string(from: rise)
            data += "Sunrise:  " + sunrise + MyApplication.newline
            let set = try sunCalc.time(ofDate: now, forSolarEvent: .sunset, atLocation: location)
            let sunset = formatter.string(from: set)
            data += "Sunset:   " + sunset + MyApplication.newline
            let aDusk = try sunCalc.time(ofDate: now, forSolarEvent: .dusk, atLocation: location)
            let astronomicalDusk = formatter.string(from: aDusk)
            data += "Dusk:     " + astronomicalDusk + MyApplication.newline
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
        return data
    }
}
