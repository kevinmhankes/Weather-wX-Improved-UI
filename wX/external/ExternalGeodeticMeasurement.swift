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

class ExternalGeodeticMeasurement: ExternalGeodeticCurve {

    var mElevationChange: Double = 0.0
    var mP2P: Double = 0.0

    init(ellipsoidalDistance: Double, azimuth: Double, reverseAzimuth: Double, elevationChange: Double) {
        super.init(ellipsoidalDistance: ellipsoidalDistance, azimuth: azimuth, reverseAzimuth: reverseAzimuth)
        self.mElevationChange = elevationChange
        self.mP2P = sqrt(ellipsoidalDistance * ellipsoidalDistance + mElevationChange * mElevationChange)
    }

    convenience init(averageCurve: ExternalGeodeticCurve, elevationChange: Double) {
        self.init(ellipsoidalDistance: averageCurve.getEllipsoidalDistance(),
                  azimuth: averageCurve.getAzimuth(),
                  reverseAzimuth: averageCurve.getReverseAzimuth(),
                  elevationChange: elevationChange)
    }

    func getElevationChange() -> Double {return mElevationChange}
    func getPointToPointDistance() -> Double {return mP2P}
}
