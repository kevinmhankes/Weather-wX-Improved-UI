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

final class ExternalGeodeticMeasurement: ExternalGeodeticCurve {

    private var elevationChange = 0.0
    private var p2p = 0.0

    init(ellipsoidalDistance: Double, azimuth: Double, reverseAzimuth: Double, elevationChange: Double) {
        super.init(ellipsoidalDistance: ellipsoidalDistance, azimuth: azimuth, reverseAzimuth: reverseAzimuth)
        self.elevationChange = elevationChange
        p2p = sqrt(ellipsoidalDistance * ellipsoidalDistance + elevationChange * elevationChange)
    }

    convenience init(averageCurve: ExternalGeodeticCurve, elevationChange: Double) {
        self.init(ellipsoidalDistance: averageCurve.getEllipsoidalDistance(),
                  azimuth: averageCurve.getAzimuth(),
                  reverseAzimuth: averageCurve.getReverseAzimuth(),
                  elevationChange: elevationChange)
    }

    //func getElevationChange() -> Double { mElevationChange }
    
    //func getPointToPointDistance() -> Double { mP2P }
}
