/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import Foundation

final class UtilityMath {

    static func distanceOfLine(_ x1: Double, _ y1: Double, _ x2: Double, _ y2: Double) -> Double {
        sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2))
    }

    static func computeTipPoint(_ x0: Double, _ y0: Double, _ x1: Double, _ y1: Double, _ right: Bool) -> [Double] {
        let dx = x1 - x0
        let dy = y1 - y0
        let length = sqrt(dx * dx + dy * dy)
        let dirX = dx / length
        let dirY = dy / length
        let height = sqrt(3) / 2 * length
        let cx = x0 + dx * 0.5
        let cy = y0 + dy * 0.5
        let pDirX = -dirY
        let pDirY = dirX
        var rx = 0.0
        var ry = 0.0
        if right {
            rx = cx + height * pDirX
            ry = cy + height * pDirY
        } else {
            rx = cx - height * pDirX
            ry = cy - height * pDirY
        }
        return [rx, ry]
    }

    static func computeMiddishPoint(_ x0: Double, _ y0: Double, _ x1: Double, _ y1: Double, _ fraction: Double) -> [Double] {
       return [x0 + fraction * (x1 - x0), y0 + fraction * (y1 - y0)]
    }

    static func rHFromTD(_ temp: Double, _ dewpt: Double) -> String {
        let relativeHumidity = 100 * (exp((17.625 * dewpt) / (243.04 + dewpt)) / exp((17.625 * temp) / (243.04 + temp)))
        return roundDToString(relativeHumidity)
    }

    static func latLonFix(_ location: LatLon) -> LatLon {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        let newX = formatter.string(from: NSNumber(value: location.lat)) ?? "0.0"
        let newY = formatter.string(from: NSNumber(value: location.lon)) ?? "0.0"
        return LatLon(newX, newY)
    }

    static func knotsToMph(_ value: String) -> String {
        if value == "" {
            return ""
        }
        let tmpNum = (Double(value) ?? 0.0) * 1.152
        return roundDToString(tmpNum)
    }

    static func unitsPressure(_ value: String) -> String {
        var tmpNum = Double(value) ?? 0.0
        var value2 = value
        if UIPreferences.unitsM {
            tmpNum *= 33.8637526
            value2 = String(format: "%.2f", tmpNum) + " mb"
        } else {
            value2 = String(format: "%.2f", tmpNum) + " in"
        }
        return value2
    }

    static func unitsTemp(_ value: String) -> String {
        var value2 = value.replace("\n", "").replace(" ", "")
        if !UIPreferences.unitsF {
            let tmpNum = Int(value2) ?? 0
            let tmpNumD = (Double(tmpNum) - 32.0) * 5.0 / 9.0
            value2 = String(Int(round(tmpNumD)))
        }
        return value2
    }

    static func celsiusToFarenheit(_ value: String) -> String {
        var value2 = value
        if UIPreferences.unitsF {
            var tmpNum = Double(value) ?? 0.0
            tmpNum = tmpNum * 9 / 5 + 32
            value2 = String(round(tmpNum))
        }
        return value2
    }

    static func celsiusToFarenheit(_ value: Int) -> String {
        var retVal = ""
        var retValNum = 0.0
        if UIPreferences.unitsF {
            retValNum = Double(value) * 9.0 / 5.0 + 32.0
            retVal = String(Int(round(retValNum)))
        }
        return retVal
    }

    static func celsiusDToFarenheit(_ valueD: Double) -> String { String(Int(round(valueD * 9 / 5 + 32))) }

    static func farenheitTocelsius(_ valueD: Double) -> String { String(Int(round((valueD - 32) * 5 / 9))) }

    static func celsiusToFarenheitTable() -> String {
        var table = "C\t\tF" + MyApplication.newline
        (-40...39).forEach { degree in
            table += String(degree) + "  " + celsiusToFarenheit(degree) + MyApplication.newline
        }
        return table
    }

    static func degreesToRadians(_ deg: Double) -> Double { deg * Double.pi / 180 }

    static func pixPerDegreeLon(_ centerX: Double, _ factor: Double) -> Double {
        let radius = (180 / Double.pi) * (1 / cos(degreesToRadians(30.51))) * factor
        return radius * (Double.pi / 180) * cos(degreesToRadians(centerX))
    }

    static func deg2rad(_ deg: Double) -> Double {
        return (deg * Double.pi / 180.0)
    }

    static func rad2deg(_ rad: Double) -> Double { (rad * 180.0 / Double.pi) }

    static func convertWindDir(_ direction: Double) -> String {
        var dirStr = ""
        if direction > 337.5 || direction <= 22.5 {
            dirStr = "N"
        } else if direction > 22.5 && direction <= 67.5 {
            dirStr = "NE"
        } else if direction > 67.5 && direction <= 112.5 {
            dirStr = "E"
        } else if direction > 112.5 && direction <= 157.5 {
            dirStr = "SE"
        } else if direction > 157.5 && direction <= 202.5 {
            dirStr = "S"
        } else if direction > 202.5 && direction <= 247.5 {
            dirStr = "SW"
        } else if direction > 247.5 && direction <= 292.5 {
            dirStr = "W"
        } else if direction > 292.5 && direction <= 337.5 {
            dirStr = "NW"
        }
        return dirStr
    }

    static func roundDToString(_ valueD: Double) -> String { String(Int(round(valueD))) }

    static func metersToMileRounded(_ valueD: Double) -> String { String(Int(round(valueD / 1609.34))) }

    static func pressurePAtoMB(_ valueD: Double) -> String { String(Int(round(valueD / 100.0))) }

    static func pressureMBtoIn(_ value: String) -> String {
        var tmpNum = Double(value) ?? 0.0
        tmpNum /= 33.8637526
        return String(format: "%.2f", tmpNum) + " in"
    }

    static func metersPerSecondtoMph(_ valueD: Double) -> String {
        let valueDLocal = valueD * 2.23694
        return String(Int(round(valueDLocal)))
    }

    static func getRadarBeamHeight(_ degree: Double, _ distance: Double) -> Double {
        3.281 * (sin(deg2rad(degree)) * distance + distance * distance / 15417.82) * 1000.0
    }

    static func heatIndex(_ temp: String, _ RH: String) -> String {
        // temp >= 80 and RH >= 40
        let T = Double(temp) ?? 0.0
        let R = Double(RH) ?? 0.0
        if T > 80.0 && R > 4.0 {
            let s1 = -42.379
            let s2 = 2.04901523 * T
            let s3 = 10.14333127 * R
            let s4 = 0.22475541 * T * R
            let s5 = 6.83783 * pow(10.0, -3.0) * pow(T, 2.0)
            let s6 = 5.481717 * pow(10.0, -2.0) * pow(R, 2.0)
            let s7 = 1.22874 * pow(10.0, -3.0) * pow(T, 2.0) * R
            let s8 = 8.5282 * pow(10.0, -4.0) * T * pow(R, 2.0)
            let s9 = 1.99 * pow(10.0, -6.0) * pow(T, 2.0) * pow(R, 2.0)
            let heatIndexInt = round(s1 + s2 + s3 - s4 - s5 - s6 + s7 + s8 - s9)
            if Int(heatIndexInt) <= Int(round(T)) {
                return ""
            }
            return String(heatIndexInt)
        } else {
            return ""
        }
    }

    /*static func getWindChill( _ tempD: Double, _ mphD: Double  ) -> String {
     let windChillD = 35.74 + 0.6215 * tempD - 35.75 * pow(mphD, 0.16) + 0.4275 * tempD * pow(mphD, 0.16)
     return "(" + UtilityMath.unitsTemp(String(Int(round(windChillD)))) + MyApplication.degreeSymbol + ")"
    }*/
}
