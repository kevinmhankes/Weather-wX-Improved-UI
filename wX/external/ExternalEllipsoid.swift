/* Geodesy by Mike Gavaghan
 *
 * http://www.gavaghan.org/blog/free-source-code/geodesy-library-vincentys-formula/
 *
 * This code may be freely used and modified on any personal or professional
 * project.  It comes with no warranty.
 *
 * BitCoin tips graciously accepted at 1FB63FYQMy7hpC2ANVhZ5mSgAZEtY1aVLf
 */

import Foundation

final class ExternalEllipsoid {

    private let semiMajorAxis: Double
    private let semiMinorAxis: Double
    private let flattening: Double

    init(_ semiMajor: Double, _ semiMinor: Double, _ flattening: Double) {
        semiMajorAxis = semiMajor
        semiMinorAxis = semiMinor
        self.flattening = flattening
    }

    static let WGS84 = fromAAndInverseF(6378137.0, 298.257223563)

    static func fromAAndInverseF(_ semiMajor: Double, _ inverseFlattening: Double) -> ExternalEllipsoid {
        let flattening = 1.0 / inverseFlattening
        let semiMinor = (1.0 - flattening) * semiMajor
        return ExternalEllipsoid(semiMajor, semiMinor, flattening)
    }

    func getSemiMajorAxis() -> Double {
        semiMajorAxis
    }

    func getSemiMinorAxis() -> Double {
        semiMinorAxis
    }

    func getFlattening() -> Double {
        flattening
    }
}
