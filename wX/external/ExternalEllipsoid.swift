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
    private let inverseFlattening: Double

    init(_ semiMajor: Double, _ semiMinor: Double, _ flattening: Double, _ inverseFlattening: Double) {
        semiMajorAxis = semiMajor
        semiMinorAxis = semiMinor
        self.flattening = flattening
        self.inverseFlattening = inverseFlattening
    }

    static let WGS84 = fromAAndInverseF(6378137.0, 298.257223563)
    static let GRS80 = fromAAndInverseF(6378137.0, 298.257222101)
    static let GRS67 = fromAAndInverseF(6378160.0, 298.25)
    static let ANS = fromAAndInverseF(6378160.0, 298.25)
    static let WGS72 = fromAAndInverseF(6378135.0, 298.26)
    static let Clarke1858 = fromAAndInverseF(6378293.645, 294.26)
    static let Clarke1880 = fromAAndInverseF(6378249.145, 293.465)
    static let Sphere = fromAAndF(6371000, 0.0)

    static func fromAAndInverseF(_ semiMajor: Double, _ inverseFlattening: Double) -> ExternalEllipsoid {
        let flattening = 1.0 / inverseFlattening
        let semiMinor = (1.0 - flattening) * semiMajor
        return ExternalEllipsoid(semiMajor, semiMinor, flattening, inverseFlattening)
    }

    static func fromAAndF(_ semiMajor: Double, _ flattening: Double) -> ExternalEllipsoid {
        let inverseFlattening = 1.0 / flattening
        let semiMinor = (1.0 - flattening) * semiMajor
        return ExternalEllipsoid(semiMajor, semiMinor, flattening, inverseFlattening)
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

    func getInverseFlattening() -> Double {
        inverseFlattening
    }
}
