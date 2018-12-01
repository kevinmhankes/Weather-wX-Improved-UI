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

public class ExternalEllipsoid {

    var mSemiMajorAxis: Double
    var mSemiMinorAxis: Double
    var mFlattening: Double
    var mInverseFlattening: Double

    init(semiMajor: Double, semiMinor: Double, flattening: Double, inverseFlattening: Double) {
        mSemiMajorAxis = semiMajor
        mSemiMinorAxis = semiMinor
        mFlattening = flattening
        mInverseFlattening = inverseFlattening
    }

    static let WGS84: ExternalEllipsoid = fromAAndInverseF(semiMajor: 6378137.0, inverseFlattening: 298.257223563)
    static let GRS80: ExternalEllipsoid = fromAAndInverseF(semiMajor: 6378137.0, inverseFlattening: 298.257222101)
    static let GRS67: ExternalEllipsoid = fromAAndInverseF(semiMajor: 6378160.0, inverseFlattening: 298.25)
    static let ANS: ExternalEllipsoid = fromAAndInverseF(semiMajor: 6378160.0, inverseFlattening: 298.25)
    static let WGS72: ExternalEllipsoid = fromAAndInverseF(semiMajor: 6378135.0, inverseFlattening: 298.26)
    static let Clarke1858: ExternalEllipsoid = fromAAndInverseF(semiMajor: 6378293.645, inverseFlattening: 294.26)
    static let Clarke1880: ExternalEllipsoid = fromAAndInverseF(semiMajor: 6378249.145, inverseFlattening: 293.465)
    static let Sphere: ExternalEllipsoid = fromAAndF(semiMajor: 6371000, flattening: 0.0)

    class func fromAAndInverseF(semiMajor: Double, inverseFlattening: Double) -> ExternalEllipsoid {
        let f = 1.0 / inverseFlattening
        let b = (1.0 - f) * semiMajor
        return ExternalEllipsoid(semiMajor: semiMajor, semiMinor: b, flattening: f, inverseFlattening: inverseFlattening)
    }

    class func fromAAndF(semiMajor: Double, flattening: Double) -> ExternalEllipsoid {
        let inverseF = 1.0 / flattening
        let b = (1.0 - flattening) * semiMajor
        return ExternalEllipsoid(semiMajor: semiMajor, semiMinor: b, flattening: flattening, inverseFlattening: inverseF)
    }

    func getSemiMajorAxis() -> Double {return mSemiMajorAxis}
    func getSemiMinorAxis() -> Double {return mSemiMinorAxis}
    func getFlattening() -> Double {return mFlattening}
    func getInverseFlattening() -> Double {return mInverseFlattening}
}
