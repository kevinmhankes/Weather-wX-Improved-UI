/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

struct LatLon {

    private var latNum = 0.0
    private var lonNum = 0.0
    private var xStr = "0.0"
    private var yStr = "0.0"

    init() {}

    init(_ radarSite: String, isRadar: Bool) {
        let ridX = Utility.readPref("RID_" + radarSite + "_X", "0.00")
        let ridY = Utility.readPref("RID_" + radarSite + "_Y", "0.00")
        self.latNum = Double(ridX) ?? 0.0
        self.lonNum = -1.0 * (Double(ridY) ?? 0.0)
        self.xStr = String(self.latNum)
        self.yStr = String(self.lonNum)
    }

    init(_ latlon: [Double]) {
        self.latNum = latlon[0]
        self.lonNum = latlon[1]
        self.xStr = String(self.latNum)
        self.yStr = String(self.lonNum)
    }

    init(_ latlon: (lat: Double, lon: Double)) {
        self.latNum = latlon.lat
        self.lonNum = latlon.lon
        self.xStr = String(self.latNum)
        self.yStr = String(self.lonNum)
    }

    init(_ lat: Double, _ lon: Double) {
        self.latNum = lat
        self.lonNum = lon
        self.xStr = String(self.latNum)
        self.yStr = String(self.lonNum)
    }

    init(_ xStr: String, _ yStr: String) {
        self.xStr = xStr
        self.yStr = yStr
        self.latNum = Double(self.xStr) ?? 0.0
        self.lonNum = Double(self.yStr) ?? 0.0
    }

    init(_ temp: String) {
        self.xStr = temp.substring(0, 4)
        self.yStr = temp.substring(4, 8)
        self.xStr = UtilityString.addPeriodBeforeLastTwoChars(self.xStr)
        self.yStr = UtilityString.addPeriodBeforeLastTwoChars(self.yStr)
        var tmpDbl = Double(self.yStr) ?? 0.0
        if tmpDbl < 40.00 {
            tmpDbl += 100
            self.yStr = String(tmpDbl)
        }
        self.latNum = Double(self.xStr) ?? 0.0
        self.lonNum = Double(self.yStr) ?? 0.0
    }

    var lat: Double {
        get {return latNum}
        set {
            latNum = newValue
            self.xStr = String(latNum)
        }
    }

    var lon: Double {
        get {return lonNum}
        set {
            lonNum = newValue
            self.yStr = String(lonNum)
        }
    }

    var latString: String {
        get {return xStr}
        set {
            xStr = newValue
            latNum = Double(newValue) ?? 0.0
        }
    }

    var lonString: String {
        get {return yStr}
        set {
            yStr = newValue
            lonNum = Double(newValue) ?? 0.0
        }
    }

    func print() -> String {
        return latString + " " + lonString + " "
    }

    static func reversed(_ lon: Double, _ lat: Double) -> LatLon {
        return LatLon(lat, -1.0 * lon)
    }

    static func distance(_ location1: LatLon, _ location2: LatLon, _ unit: DistanceUnit) -> Double {
        let theta = location1.lon - location2.lon
        var dist = sin(
            UtilityMath.deg2rad(location1.lat))
            * sin(UtilityMath.deg2rad(location2.lat)) + cos(UtilityMath.deg2rad(location1.lat))
            * cos(UtilityMath.deg2rad(location2.lat)) * cos(UtilityMath.deg2rad(theta)
        )
        dist = acos(dist)
        dist = UtilityMath.rad2deg(dist)
        dist = dist * 60 * 1.1515
        switch unit {
        case .K: return dist * 1.609344
        case .N: return dist * 0.8684
        case .MILES: return dist
        }
    }
}

extension LatLon: Equatable {
    static func == (lhs: LatLon, rhs: LatLon) -> Bool {
        return lhs.latString == rhs.latString && lhs.lonString == rhs.lonString
    }
}
