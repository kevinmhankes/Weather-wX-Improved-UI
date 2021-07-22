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

final class ExternalGeodeticCalculator {

    /**
     * Calculate the destination and final bearing after traveling a specified
     * distance, and a specified starting bearing, for an initial location. This
     * is the solution to the direct geodetic problem.
     *
     * @param ellipsoid reference ellipsoid to use
     * @param start starting location
     * @param startBearing starting bearing (degrees)
     * @param distance distance to travel (meters)
     * @param endBearing bearing at destination (degrees) element at index 0 will
     *            be populated with the result
     * @return
     */
    func calculateEndingGlobalCoordinatesLocal(
        _ ellipsoid: ExternalEllipsoid,
        _ start: ExternalGlobalCoordinates,
        _ startBearing: Double,
        _ distance: Double,
        _ endBearing: [Double]
    ) -> ExternalGlobalCoordinates {
        let a = ellipsoid.getSemiMajorAxis()
        let b = ellipsoid.getSemiMinorAxis()
        let aSquared = a * a
        let bSquared = b * b
        let f = ellipsoid.getFlattening()
        let phi1 = ExternalAngle.toRadians(degrees: start.getLatitude())
        let alpha1 = ExternalAngle.toRadians(degrees: startBearing)
        let cosAlpha1 =  cos(alpha1)
        let sinAlpha1 =  sin(alpha1)
        let s = distance
        let tanU1 = (1.0 - f) * tan(phi1)
        let cosU1 = 1.0 / sqrt(1.0 + tanU1 * tanU1)
        let sinU1 = tanU1 * cosU1
        var endBearingLocal = endBearing
        // eq. 1
        let sigma1 = atan2(tanU1, cosAlpha1)
        // eq. 2
        let sinAlpha = cosU1 * sinAlpha1
        let sin2Alpha = sinAlpha * sinAlpha
        let cos2Alpha = 1 - sin2Alpha
        let uSquared = cos2Alpha * (aSquared - bSquared) / bSquared
        // eq. 3
        let A = 1 + (uSquared / 16384) * (4096 + uSquared * (-768 + uSquared * (320 - 175 * uSquared)))
        // eq. 4
        let B = (uSquared / 1024) * (256 + uSquared * (-128 + uSquared * (74 - 47 * uSquared)))
        // iterate until there is a negligible change in sigma
        var deltaSigma: Double
        let sOverbA = s / (b * A)
        var sigma = sOverbA
        var sinSigma: Double
        var prevSigma = sOverbA
        var sigmaM2: Double
        var cosSigmaM2: Double
        var cos2SigmaM2: Double
        while true {
            // eq. 5
            sigmaM2 = 2.0 * sigma1 + sigma
            cosSigmaM2 = cos(sigmaM2)
            cos2SigmaM2 = cosSigmaM2 * cosSigmaM2
            sinSigma = sin(sigma)
            let cosSignma = cos(sigma)
            // eq. 6
            deltaSigma = B
                * sinSigma
                * (cosSigmaM2 + (B / 4.0)
                    * (cosSignma * (-1 + 2 * cos2SigmaM2) - (B / 6.0)
                        * cosSigmaM2 * (-3 + 4 * sinSigma * sinSigma) * (-3 + 4 * cos2SigmaM2)))

            // eq. 7
            sigma = sOverbA + deltaSigma
            // break after converging to tolerance
            if abs(sigma - prevSigma) < 0.0000000000001 {
                break
            }
            prevSigma = sigma
        }
        sigmaM2 = 2.0 * sigma1 + sigma
        cosSigmaM2 = cos(sigmaM2)
        cos2SigmaM2 = cosSigmaM2 * cosSigmaM2
        let cosSigma = cos(sigma)
        sinSigma = sin(sigma)
        // eq. 8
        let phi2 = atan2(sinU1 * cosSigma + cosU1 * sinSigma * cosAlpha1, (1.0 - f)
            * sqrt(sin2Alpha + pow(sinU1 * sinSigma - cosU1 * cosSigma * cosAlpha1, 2.0)))
        // eq. 9
        // This fixes the pole crossing defect spotted by Matt Feemster. When a
        // path passes a pole and essentially crosses a line of latitude twice -
        // once in each direction - the longitude calculation got messed up. Using
        // atan2 instead of atan fixes the defect. The change is in the next 3
        // lines.
        // double tanLambda = sinSigma * sinAlpha1 / (cosU1 * cosSigma - sinU1 * sinSigma * cosAlpha1)
        // double lambda = Math.atan(tanLambda)
        let lambda = atan2(sinSigma * sinAlpha1, (cosU1 * cosSigma - sinU1 * sinSigma * cosAlpha1))
        // eq. 10
        let C = (f / 16) * cos2Alpha * (4 + f * (4 - 3 * cos2Alpha))
        // eq. 11
        let L = lambda - (1 - C) * f * sinAlpha
            * (sigma + C * sinSigma * (cosSigmaM2 + C * cosSigma * (-1 + 2 * cos2SigmaM2)))
        // eq. 12
        let alpha2 = atan2(sinAlpha, -sinU1 * sinSigma + cosU1 * cosSigma * cosAlpha1)
        // build result
        let latitude = ExternalAngle.toDegrees(radians: phi2)
        let longitude = start.getLongitude() + ExternalAngle.toDegrees(radians: L)
        if endBearing.count > 0 {
            endBearingLocal[0] = ExternalAngle.toDegrees(radians: alpha2)
        }
        return  ExternalGlobalCoordinates(latitude, longitude)
    }
    /**
     * Calculate the destination after traveling a specified distance, and a
     * specified starting bearing, for an initial location. This is the solution
     * to the direct geodetic problem.
     *
     * @param ellipsoid reference ellipsoid to use
     * @param start starting location
     * @param startBearing starting bearing (degrees)
     * @param distance distance to travel (meters)
     * @return
     */
    func calculateEndingGlobalCoordinates(
        _ start: ExternalGlobalCoordinates,
        _ startBearing: Double,
        _ distance: Double
    ) -> ExternalGlobalCoordinates {
        calculateEndingGlobalCoordinatesLocal(ExternalEllipsoid.WGS84, start, startBearing, distance, [])
    }
}
