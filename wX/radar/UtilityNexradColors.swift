/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityNexradColors {

    private static func interpolate(_ colorA: Double, _ colorB: Double, _ proportion: Double) -> Double {
        colorA + ((colorB - colorA) * proportion)
    }

    private static func interpolateHue(_ colorA: Double, _ colorB: Double, _ proportion: Double) -> Double {
        let diff = colorB - colorA
        var ret: Double
        let total = 1.0
        if diff > total / 2 {
            ret = (total - (colorB - colorA)) * -1.0
            if ret < 0 { return ret + total } else { return ret }
        } else {
            return (colorA + ((colorB - colorA) * proportion))
        }
    }

    static func interpolateColor(_ colorA: Int, _ colorB: Int, _ proportion: Double) -> Int {
        let hsva = Color.colorToHsv(colorA)
        var hsvb = Color.colorToHsv(colorB)
        (0...2).forEach { index in
            if index > 0 {
                hsvb[index] = interpolate(hsva[index], hsvb[index], Double(proportion))
            } else {
                hsvb[index] = interpolateHue(hsva[index], hsvb[index], Double(proportion))
            }
        }
        return Color.hsvToColor(hsvb)
    }
}
