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

    init(semiMajor: Double, semiMinor: Double, flattening: Double, inverseFlattening: Double) {
        semiMajorAxis = semiMajor
        semiMinorAxis = semiMinor
        self.flattening = flattening
        self.inverseFlattening = inverseFlattening
    }

    static let WGS84 = fromAAndInverseF(semiMajor: 6378137.0, inverseFlattening: 298.257223563)
    static let GRS80 = fromAAndInverseF(semiMajor: 6378137.0, inverseFlattening: 298.257222101)
    static let GRS67 = fromAAndInverseF(semiMajor: 6378160.0, inverseFlattening: 298.25)
    static let ANS = fromAAndInverseF(semiMajor: 6378160.0, inverseFlattening: 298.25)
    static let WGS72 = fromAAndInverseF(semiMajor: 6378135.0, inverseFlattening: 298.26)
    static let Clarke1858 = fromAAndInverseF(semiMajor: 6378293.645, inverseFlattening: 294.26)
    static let Clarke1880 = fromAAndInverseF(semiMajor: 6378249.145, inverseFlattening: 293.465)
    static let Sphere = fromAAndF(semiMajor: 6371000, flattening: 0.0)

    static func fromAAndInverseF(semiMajor: Double, inverseFlattening: Double) -> ExternalEllipsoid {
        let f = 1.0 / inverseFlattening
        let b = (1.0 - f) * semiMajor
        return ExternalEllipsoid(semiMajor: semiMajor,
                                 semiMinor: b,
                                 flattening: f,
                                 inverseFlattening: inverseFlattening)
    }

    static func fromAAndF(semiMajor: Double, flattening: Double) -> ExternalEllipsoid {
        let inverseF = 1.0 / flattening
        let b = (1.0 - flattening) * semiMajor
        return ExternalEllipsoid(semiMajor: semiMajor,
                                 semiMinor: b,
                                 flattening: flattening,
                                 inverseFlattening: inverseF)
    }

    func getSemiMajorAxis() -> Double { semiMajorAxis }

    func getSemiMinorAxis() -> Double { semiMinorAxis }

    func getFlattening() -> Double { flattening }

    func getInverseFlattening() -> Double { inverseFlattening }
}
