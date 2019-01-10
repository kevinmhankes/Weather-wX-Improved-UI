/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

class UtilityNexradColors {

    static func interpolate(_ colorA: Double, _ colorB: Double, _ proportion: Double) -> Double {
        return (colorA + ((colorB - colorA) * proportion))
    }

    static func interpolateHue(_ colorA: Double, _ colorB: Double, _ proportion: Double) -> Double {
        let diff = colorB - colorA
        var ret: Double
        let total = 1.0
        if diff > total / 2 {
            ret = (total - (colorB - colorA)) * -1.0
            if ret < 0 {
                return ret + total
            } else {
                return ret
            }
        } else {
            return (colorA + ((colorB - colorA) * proportion))
        }
    }

    static func interpolateColor(_ colorA: Int, _ colorB: Int, _ proportion: Double) -> Int {
        var hsva = [Double]()
        var hsvb = [Double]()
        hsva = Color.colorToHsv(colorA, hsva)
        hsvb = Color.colorToHsv(colorB, hsvb)
        (0...2).forEach {
            if $0 > 0 {
                hsvb[$0] = interpolate(hsva[$0], hsvb[$0], Double(proportion))
            } else {
                hsvb[$0] = interpolateHue(hsva[$0], hsvb[$0], Double(proportion))
            }
        }
        return Color.hsvToColor(hsvb)
    }
}
