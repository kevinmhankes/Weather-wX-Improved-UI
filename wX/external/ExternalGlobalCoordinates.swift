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

/**
 * <p>
 * Encapsulation of latitude and longitude coordinates on a globe. Negative
 * latitude is southern hemisphere. Negative longitude is western hemisphere.
 * </p>
 * <p>
 * Any angle may be specified for longtiude and latitude, but all angles will be
 * canonicalized such that:
 * </p>
 *
 * <pre>
 * -90 &lt= latitude &lt= +90 - 180 &lt longitude &lt= +180
 * </pre>
 *
 * @author Mike Gavaghan
 */
class ExternalGlobalCoordinates {
    /** Latitude in degrees. Negative latitude is southern hemisphere. */
    private var mLatitude: Double

    /** Longitude in degrees. Negative longitude is western hemisphere. */
    private var mLongitude: Double
    
    init(_ latitude: Double, _ longitude: Double) {
        mLatitude = latitude
        mLongitude = longitude
        canonicalize()
    }

    convenience init(_ ec: ExternalGlobalCoordinates, lonNegativeOne: Bool = false) {
        if lonNegativeOne {
            self.init(ec.getLatitude(), ec.getLongitude() * -1.0)
        } else {
            self.init(ec.getLatitude(), ec.getLongitude())
        }
    }

    convenience init(_ pn: ProjectionNumbers, lonNegativeOne: Bool = false) {
        if lonNegativeOne {
            self.init(pn.xDbl, pn.yDbl * -1.0)
        } else {
            self.init(pn.xDbl, pn.yDbl)
        }
    }

    /**
     * Canonicalize the current latitude and longitude values such that:
     *
     * <pre>
     * -90 &lt= latitude &lt= +90 - 180 &lt longitude &lt= +180
     * </pre>
     */
    func canonicalize() {
        mLatitude += 180
        mLatitude = mLatitude.truncatingRemainder(dividingBy: 360)
        if mLatitude < 0 {
            mLatitude += 360
        }
        mLatitude -= 180
        if mLatitude > 90 {
            mLatitude = 180 - mLatitude
            mLongitude += 180
        } else if mLatitude < -90 {
            mLatitude = -180 - mLatitude
            mLongitude += 180
        }
        mLongitude += 180
        mLongitude = mLongitude.truncatingRemainder(dividingBy: 360)
        if mLongitude <= 0 {
            mLongitude += 360
        }
        mLongitude -= 180
    }

    /**
     * Construct a new GlobalCoordinates. Angles will be canonicalized.
     *
     * @param latitude latitude in degrees
     * @param longitude longitude in degrees
     */
    /**
     * Get latitude.
     *
     * @return latitude in degrees
     */
    func getLatitude() -> Double {
        mLatitude
    }

    /**
     * Get longitude.
     *
     * @return longitude in degrees
     */
    func getLongitude() -> Double {
        mLongitude
    }
}
