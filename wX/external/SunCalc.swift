// please see LICENSE.SunCalc in the root directory

import Foundation

//typealias AzimuthCoordinate = (azimuth: Double, altitude: Double)
//typealias EclipticCoordinate = (rightAscension: Double, declination: Double)

enum SolarEvent {
    case sunrise
    case sunset
    case sunriseEnd
    case sunsetEnd
    case dawn
    case dusk
    case nauticalDawn
    case nauticalDusk
    case astronomicalDawn
    case astronomicalDusk
    case goldenHourEnd
    case goldenHour
    case noon
    case nadir

    var solarAngle: Double {
        switch self {
        case .sunrise, .sunset: return -0.833
        case .sunriseEnd, .sunsetEnd: return -0.3
        case .dawn, .dusk: return -6.0
        case .nauticalDawn, .nauticalDusk: return -12.0
        case .astronomicalDawn, .astronomicalDusk: return -18.0
        case .goldenHourEnd, .goldenHour: return 6.0
        case .noon: return 90.0
        case .nadir: return -90.0
        }
    }
}

final class SunCalc {

    struct Location {
        var latitude: Double
        var longitude: Double
    }

    enum SolarEventError: Error {
        case sunNeverRise
        case sunNeverSet
    }

    private static let e = 23.4397 * Double.radPerDegree

//    private func rightAscension(l: Double, b: Double) -> Double {
//        atan2(sin(l) * cos(SunCalc.e) - tan(b) * sin(SunCalc.e), cos(l))
//    }

    private func declination(l: Double, b: Double) -> Double {
        asin(sin(b) * cos(SunCalc.e) + cos(b) * sin(SunCalc.e) * sin(l))
    }

//    private func azimuth(h: Double, phi: Double, dec: Double) -> Double {
//        atan2(sin(h), cos(h) * sin(phi) - tan(dec) * cos(phi))
//    }

//    private func altitude(h: Double, phi: Double, dec: Double) -> Double {
//        asin(sin(phi) * sin(dec) + cos(phi) * cos(dec) * cos(h))
//    }
//
//    private func siderealTime(d: Double, lw: Double) -> Double {
//        Double.radPerDegree * (280.16 + 360.9856235 * d) - lw
//    }

//    private func astroRefraction(_ aH: Double) -> Double {
//        let h = aH < 0 ? 0 : aH
//        return 0.0002967 / tan(h + 0.00312536 / (h + 0.08901179))
//    }

    private func solarMeanAnomaly(_ d: Double) -> Double {
        Double.radPerDegree * (357.5291 + 0.98560028 * d)
    }

    private func eclipticLongitude(_ m: Double) -> Double {
        let c = Double.radPerDegree * (1.9148 * sin(m) + 0.02 * sin(2.0 * m) + 0.0003 * sin(3.0 * m))
        let p = Double.radPerDegree * 102.9372
        return m + c + p + Double.pi
    }

//    private func sunCoordinates(_ d: Double) -> EclipticCoordinate {
//        let m = solarMeanAnomaly(d)
//        let l = eclipticLongitude(m)
//        return (rightAscension(l: l, b: 0.0), declination(l: l, b: 0.0))
//    }

    private func julianCycle(d: Double, lw: Double) -> Double {
        let v = (d - Date.j0) - (lw / (2.0 * Double.pi))
        return v.rounded()
    }

    private func approximateTransit(hT: Double, lw: Double, n: Double) -> Double {
        Date.j0 + (hT + lw) / (2.0 * Double.pi) + n
    }

    private func solarTransitJ(ds: Double, m: Double, l: Double) -> Double {
        Date.j2000 + ds + 0.0053 * sin(m) - 0.0069 * sin(2.0 * l)
    }

    private func hourAngle(h: Double, phi: Double, d: Double) throws -> Double {
        let cosH = (sin(h) - sin(phi) * sin(d)) / (cos(phi) * cos(d))
        if cosH > 1 {
            throw SolarEventError.sunNeverRise
        }
        if cosH < -1 {
            throw SolarEventError.sunNeverSet
        }
        return acos(cosH)
    }

    private func getSetJ(
        h: Double,
        lw: Double,
        phi: Double,
        dec: Double,
        n: Double,
        m: Double,
        l: Double
    ) throws -> Double {
        let w = try hourAngle(h: h, phi: phi, d: dec)
        let a = approximateTransit(hT: w, lw: lw, n: n)
        return solarTransitJ(ds: a, m: m, l: l)
    }

//    func sunPosition(date: Date, location: Location) -> AzimuthCoordinate {
//        let lw = Double.radPerDegree * location.longitude * -1.0
//        let phi = Double.radPerDegree * location.latitude
//        let d = date.daysSince2000
//        let c = sunCoordinates(d)
//        let h = siderealTime(d: d, lw: lw) - c.rightAscension
//        return (azimuth(h: h, phi: phi, dec: c.declination), altitude(h: h, phi: phi, dec: c.declination))
//    }

    func time(ofDate date: Date, forSolarEvent event: SolarEvent, atLocation location: Location) throws -> Date {
        let lw = Double.radPerDegree * location.longitude * -1.0
        let phi = Double.radPerDegree * location.latitude
        let d = date.daysSince2000
        let n = julianCycle(d: d, lw: lw)
        let ds = approximateTransit(hT: 0.0, lw: lw, n: n)
        let m = solarMeanAnomaly(ds)
        let l = eclipticLongitude(m)
        let dec = declination(l: l, b: 0.0)
        let jNoon = solarTransitJ(ds: ds, m: m, l: l)
        let noon = Date(julianDays: jNoon)
        let angle = event.solarAngle
        let jSet = try getSetJ(h: angle * Double.radPerDegree, lw: lw, phi: phi, dec: dec, n: n, m: m, l: l)
        switch event {
        case .noon: return noon
        case .nadir:
            let nadir = Date(julianDays: jNoon - 0.5)
            return nadir
        case .sunset, .dusk, .goldenHour, .astronomicalDusk, .nauticalDusk:
            return Date(julianDays: jSet)
        case .sunrise, .dawn, .goldenHourEnd, .astronomicalDawn, .nauticalDawn:
            let jRise = jNoon - (jSet - jNoon)
            return Date(julianDays: jRise)
        default:
            return Date()
        }
    }
}
