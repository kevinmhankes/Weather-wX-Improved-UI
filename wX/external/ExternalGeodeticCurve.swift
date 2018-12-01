/* Geodesy by Mike Gavaghan
 *
 * http://www.gavaghan.org/blog/free-source-code/geodesy-library-vincentys-formula/
 *
 * This code may be freely used and modified on any personal or professional
 * project.  It comes with no warranty.
 *
 * BitCoin tips graciously accepted at 1FB63FYQMy7hpC2ANVhZ5mSgAZEtY1aVLf
 */

class ExternalGeodeticCurve {

    var mEllipsoidalDistance: Double=0.0
    var mAzimuth: Double=0.0
    var mReverseAzimuth: Double=0.0
    init() {}

    init(ellipsoidalDistance: Double, azimuth: Double, reverseAzimuth: Double) {
        mEllipsoidalDistance = ellipsoidalDistance
        mAzimuth = azimuth
        mReverseAzimuth = reverseAzimuth
    }

    func getEllipsoidalDistance() -> Double {return mEllipsoidalDistance}
    func getAzimuth() -> Double {return mAzimuth}
    func getReverseAzimuth() -> Double {return mReverseAzimuth}
}
