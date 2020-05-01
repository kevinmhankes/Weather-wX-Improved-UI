/* Geodesy by Mike Gavaghan
 *
 * http://www.gavaghan.org/blog/free-source-code/geodesy-library-vincentys-formula/
 *
 * This code may be freely used and modified on any personal or professional
 * project.  It comes with no warranty.
 *
 * BitCoin tips graciously accepted at 1FB63FYQMy7hpC2ANVhZ5mSgAZEtY1aVLf
 */

class ExternalAngle {

    static let PiOver180 = Double.pi / 180.0

    init() {}

    static func toRadians(degrees: Double) -> Double {
        degrees * PiOver180
    }

    static func toDegrees(radians: Double) -> Double {
        radians / PiOver180
    }
}
