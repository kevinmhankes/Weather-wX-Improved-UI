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

public class ExternalGeodeticCalculator {

    let TwoPi: Double = 2.0 * Double.pi

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
    func  calculateEndingGlobalCoordinates(_ ellipsoid: ExternalEllipsoid, _ start: ExternalGlobalCoordinates, _ startBearing: Double, _ distance: Double,
                                           _ endBearing: [Double]) -> ExternalGlobalCoordinates {
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

        var endBearingLocal: [Double] = endBearing

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
        //for ()
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
                    * (cosSignma * (-1 + 2 * cos2SigmaM2) - (B / 6.0) * cosSigmaM2 * (-3 + 4 * sinSigma * sinSigma) * (-3 + 4 * cos2SigmaM2)))

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
        let L = lambda - (1 - C) * f * sinAlpha * (sigma + C * sinSigma * (cosSigmaM2 + C * cosSigma * (-1 + 2 * cos2SigmaM2)))

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
    func  calculateEndingGlobalCoordinates(_ ellipsoid: ExternalEllipsoid = ExternalEllipsoid.WGS84,
                                           _ start: ExternalGlobalCoordinates, _ startBearing: Double,
                                           _ distance: Double) -> ExternalGlobalCoordinates {
        return calculateEndingGlobalCoordinates(ellipsoid, start, startBearing, distance, [])
    }
    /**
     * Calculate the geodetic curve between two points on a specified reference
     * ellipsoid. This is the solution to the inverse geodetic problem.
     *
     * @param ellipsoid reference ellipsoid to use
     * @param start starting coordinates
     * @param end ending coordinates
     * @return
     */
    func  calculateGeodeticCurve(ellipsoid: ExternalEllipsoid, start: ExternalGlobalCoordinates, end: ExternalGlobalCoordinates) -> ExternalGeodeticCurve {
        //
        // All equation numbers refer back to Vincenty's publication:
        // See http://www.ngs.noaa.gov/PUBS_LIB/inverse.pdf
        //

        // get constants
        let a = ellipsoid.getSemiMajorAxis()
        let b = ellipsoid.getSemiMinorAxis()
        let f = ellipsoid.getFlattening()

        // get parameters as radians
        let phi1 = ExternalAngle.toRadians(degrees: start.getLatitude())
        let lambda1 = ExternalAngle.toRadians(degrees: start.getLongitude())
        let phi2 = ExternalAngle.toRadians(degrees: end.getLatitude())
        let lambda2 = ExternalAngle.toRadians(degrees: end.getLongitude())

        // calculations
        let a2 = a * a
        let b2 = b * b
        let a2b2b2 = (a2 - b2) / b2

        let omega = lambda2 - lambda1

        let tanphi1 = tan(phi1)
        let tanU1 = (1.0 - f) * tanphi1
        let U1 = atan(tanU1)
        let sinU1 = sin(U1)
        let cosU1 = cos(U1)

        let tanphi2 = tan(phi2)
        let tanU2 = (1.0 - f) * tanphi2
        let U2 = atan(tanU2)
        let sinU2 = sin(U2)
        let cosU2 = cos(U2)

        let sinU1sinU2 = sinU1 * sinU2
        let cosU1sinU2 = cosU1 * sinU2
        let sinU1cosU2 = sinU1 * cosU2
        let cosU1cosU2 = cosU1 * cosU2

        // eq. 13
        var lambda = omega

        // intermediates we'll need to compute 's'
        var A = 0.0
        var B = 0.0
        var sigma = 0.0
        var deltasigma = 0.0
        var lambda0: Double
        var converged = false

        for i in ( 0..<20) {
            lambda0 = lambda

            let sinlambda = sin(lambda)
            let coslambda = cos(lambda)
            // eq. 14
            let sin2sigma = (cosU2 * sinlambda * cosU2 * sinlambda) + (cosU1sinU2 - sinU1cosU2 * coslambda) * (cosU1sinU2 - sinU1cosU2 * coslambda)
            let sinsigma = sqrt(sin2sigma)
            // eq. 15
            let cossigma = sinU1sinU2 + (cosU1cosU2 * coslambda)
            // eq. 16
            sigma = atan2(sinsigma, cossigma)
            // eq. 17 Careful! sin2sigma might be almost 0!
            let sinalpha = (sin2sigma == 0) ? 0.0 : cosU1cosU2 * sinlambda / sinsigma
            let alpha = asin(sinalpha)
            let cosalpha = cos(alpha)
            let cos2alpha = cosalpha * cosalpha
            // eq. 18 Careful! cos2alpha might be almost 0!
            let cos2sigmam = cos2alpha == 0.0 ? 0.0 : cossigma - 2 * sinU1sinU2 / cos2alpha
            let u2 = cos2alpha * a2b2b2
            let cos2sigmam2 = cos2sigmam * cos2sigmam
            // eq. 3
            A = 1.0 + u2 / 16384 * (4096 + u2 * (-768 + u2 * (320 - 175 * u2)))
            // eq. 4
            B = u2 / 1024 * (256 + u2 * (-128 + u2 * (74 - 47 * u2)))
            // eq. 6
            deltasigma = B * sinsigma
                * (cos2sigmam + B / 4 * (cossigma * (-1 + 2 * cos2sigmam2) - B / 6 * cos2sigmam * (-3 + 4 * sin2sigma) * (-3 + 4 * cos2sigmam2)))

            // eq. 10
            let C = f / 16 * cos2alpha * (4 + f * (4 - 3 * cos2alpha))
            // eq. 11 (modified)
            lambda = omega + (1 - C) * f * sinalpha * (sigma + C * sinsigma * (cos2sigmam + C * cossigma * (-1 + 2 * cos2sigmam2)))
            // see how much improvement we got
            let change = abs((lambda - lambda0) / lambda)
            if (i > 1) && (change < 0.0000000000001) {
                converged = true
                break
            }
        }
        // eq. 19
        let s = b * A * (sigma - deltasigma)
        var alpha1: Double
        var alpha2: Double
        // didn't converge? must be N/S
        if !converged {
            if phi1 > phi2 {
                alpha1 = 180.0
                alpha2 = 0.0
            } else if phi1 < phi2 {
                alpha1 = 0.0
                alpha2 = 180.0
            } else {
                alpha1 = Double(nan: 0, signaling: false)
                alpha2 = Double(nan: 0, signaling: false)
            }
        }
            // else, it converged, so do the math
        else {
            var radians: Double
            // eq. 20
            radians = atan2(cosU2 * sin(lambda), (cosU1sinU2 - sinU1cosU2 * cos(lambda)))
            if radians < 0.0 {
                radians += TwoPi
            }
            alpha1 = ExternalAngle.toDegrees(radians: radians)
            // eq. 21
            radians = atan2(cosU1 * sin(lambda), (-sinU1cosU2 + cosU1sinU2 * cos(lambda))) + Double.pi
            if radians < 0.0 {
                radians += TwoPi
            }
            alpha2 = ExternalAngle.toDegrees(radians: radians)
        }
        if alpha1 >= 360.0 {
            alpha1 -= 360.0
        }
        if alpha2 >= 360.0 {
            alpha2 -= 360.0
        }
        return  ExternalGeodeticCurve(ellipsoidalDistance: s, azimuth: alpha1, reverseAzimuth: alpha2)
    }

    /**
     * <p>
     * Calculate the three dimensional geodetic measurement between two positions
     * measured in reference to a specified ellipsoid.
     * </p>
     * <p>
     * This calculation is performed by first computing a new ellipsoid by
     * expanding or contracting the reference ellipsoid such that the new
     * ellipsoid passes through the average elevation of the two positions. A
     * geodetic curve across the new ellisoid is calculated. The point-to-point
     * distance is calculated as the hypotenuse of a right triangle where the
     * length of one side is the ellipsoidal distance and the other is the
     * difference in elevation.
     * </p>
     *
     * @param refEllipsoid reference ellipsoid to use
     * @param start starting position
     * @param end ending position
     * @return
     */
    func  calculateGeodeticMeasurement(refEllipsoid: ExternalEllipsoid, start: ExternalGlobalPosition, end: ExternalGlobalPosition) -> ExternalGeodeticMeasurement {
        // calculate elevation differences
        let elev1 = start.getElevation()
        let elev2 = end.getElevation()
        let elev12 = (elev1 + elev2) / 2.0
        // calculate latitude differences
        let phi1 = ExternalAngle.toRadians(degrees: start.getLatitude())
        let phi2 = ExternalAngle.toRadians(degrees: end.getLatitude())
        let phi12 = (phi1 + phi2) / 2.0
        // calculate a new ellipsoid to accommodate average elevation
        let refA = refEllipsoid.getSemiMajorAxis()
        let f = refEllipsoid.getFlattening()
        let a = refA + elev12 * (1.0 + f * sin(phi12))
        let ellipsoid = ExternalEllipsoid.fromAAndF(semiMajor: a, flattening: f)

        // calculate the curve at the average elevation
        let averageCurve = calculateGeodeticCurve(ellipsoid: ellipsoid, start: start, end: end)

        // return the measurement
        return  ExternalGeodeticMeasurement(averageCurve: averageCurve, elevationChange: elev2 - elev1)
    }
}
