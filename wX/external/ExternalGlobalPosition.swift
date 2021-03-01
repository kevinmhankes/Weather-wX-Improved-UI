/* Geodesy by Mike Gavaghan
 *
 * http://www.gavaghan.org/blog/free-source-code/geodesy-library-vincentys-formula/
 *
 * This code may be freely used and modified on any personal or professional
 * project.  It comes with no warranty.
 *
 * BitCoin tips graciously accepted at 1FB63FYQMy7hpC2ANVhZ5mSgAZEtY1aVLf
 */

/**
 * <p>
 * Encapsulates a three dimensional location on a globe (GlobalCoordinates
 * combined with an elevation in meters above a reference ellipsoid).
 * </p>
 * <p>
 * See documentation for GlobalCoordinates for details on how latitude and
 * longitude measurements are canonicalized.
 * </p>
 *
 * @author Mike Gavaghan
 */
final class ExternalGlobalPosition: ExternalGlobalCoordinates {
    /** Elevation, in meters, above the surface of the ellipsoid. */
    private var elevation: Double

    /**
     * Creates a new instance of GlobalPosition.
     *
     * @param latitude latitude in degrees
     * @param longitude longitude in degrees
     * @param elevation elevation, in meters, above the reference ellipsoid
     */
    init(latitude: Double, longitude: Double, elevation: Double) {
        self.elevation = elevation
        super.init(latitude, longitude)
    }

    /**
     * Creates a new instance of GlobalPosition.
     *
     * @param coords coordinates of the position
     * @param elevation elevation, in meters, above the reference ellipsoid
     */
    convenience init(coords: ExternalGlobalCoordinates, elevation: Double) {
        self.init(latitude: coords.getLatitude(), longitude: coords.getLongitude(), elevation: elevation)
    }

    /**
     * Get elevation.
     *
     * @return elevation about the ellipsoid in meters.
     */
    func getElevation() -> Double {
        elevation
    }

    /**
     * Set the elevation.
     *
     * @param elevation elevation about the ellipsoid in meters.
     */
    func setElevation(elevation: Double) {
        self.elevation = elevation
    }

    /**
     * Compare this position to another. Western longitudes are less than eastern
     * logitudes. If longitudes are equal, then southern latitudes are less than
     * northern latitudes. If coordinates are equal, lower elevations are less
     * than higher elevations
     *
     * @param other instance to compare to
     * @return -1, 0, or +1 as per Comparable contract
     */
    func compareTo(other: ExternalGlobalPosition ) -> Int {
        var retval: Int = super.compareTo(other: other)
        if retval == 0 {
            if elevation < other.elevation {
                retval = -1
            } else if elevation > other.elevation {
                retval = +1
            }
        }
        return retval
    }

    /**
     * Get a hash code for this position.
     *
     * @return
     */

    override func hashCode() -> Int {
        var hash: Int = super.hashCode()
        if elevation != 0 {
            hash *= Int(elevation)
        }
        return hash
    }

    /**
     * Compare this position to another object for equality.
     *
     * @param
     * @return
     */

    override func equals(obj: AnyObject ) -> Bool {
        if let  other: ExternalGlobalPosition = obj as? ExternalGlobalPosition {
            return (elevation == other.elevation) && (super.equals(obj: other))
        } else {
            return false
        }
    }
}
