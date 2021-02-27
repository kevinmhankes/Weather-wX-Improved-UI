/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

struct LatLon {
    
    private var latNum = 0.0
    private var lonNum = 0.0
    private var xStr = "0.0"
    private var yStr = "0.0"
    
    init() {}
    
    init(radarSite: String) {
        let ridX = Utility.getRadarSiteX(radarSite)
        let ridY = Utility.getRadarSiteY(radarSite)
        self.latNum = Double(ridX) ?? 0.0
        self.lonNum = -1.0 * (Double(ridY) ?? 0.0)
        self.xStr = String(self.latNum)
        self.yStr = String(self.lonNum)
    }
    
    init(_ latLon: [Double]) {
        self.latNum = latLon[0]
        self.lonNum = latLon[1]
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
    
    // SPC and WPC issue text products with LAT/LON encoded in a special format
    // points in polygons are 8 char long separated by whitespace spread over multiple
    // fixed width lines
    // notice that long over 100 are show with the leading 1 omitted
    // 35768265  <- 35.76 82.65
    // 36730423  <- 36.73 104.23
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
    
    var list: [Double] { [lat, lon] }
    
    var lat: Double {
        get { latNum }
        set {
            latNum = newValue
            self.xStr = String(latNum)
        }
    }
    
    var lon: Double {
        get { lonNum }
        set {
            lonNum = newValue
            self.yStr = String(lonNum)
        }
    }
    
    var latString: String {
        get { xStr }
        set {
            xStr = newValue
            latNum = Double(newValue) ?? 0.0
        }
    }
    
    var lonString: String {
        get { yStr }
        set {
            yStr = newValue
            lonNum = Double(newValue) ?? 0.0
        }
    }
    
    // used in adhoc location save
    func prettyPrint() -> String {
        latString.truncate(5) + ", " + lonString.truncate(5)
    }
    
    // used in UtilitySwoD1 and UtilityDownloadRadar
    func printSpaceSeparated() -> String {
        latString + " " + lonString + " "
    }
    
    func asPoint() -> ExternalPoint {
        ExternalPoint(lat, lon)
    }
    
    static func reversed(_ lon: Double, _ lat: Double) -> LatLon {
        LatLon(lat, -1.0 * lon)
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
        case .K:
            return dist * 1.609344
        case .N:
            return dist * 0.8684
        case .MILES:
            return dist
        }
    }
    
    // take a space separated list of numbers and return a list of LatLon, list is of the format
    // lon0 lat0 lon1 lat1 for watch
    // for UtilityWatch need to multiply Y by -1.0
    static func parseStringToLatLons(_ stringOfNumbers: String, _ multiplier: Double = 1.0, _ isWarning: Bool = true) -> [LatLon] {
        let list = stringOfNumbers.split(" ")
        var x = [Double]()
        var y = [Double]()
        list.indices.forEach { i in
            if isWarning {
                if i.isEven() {
                    y.append((Double(list[i]) ?? 0.0) * multiplier)
                } else {
                    x.append(Double(list[i]) ?? 0.0)
                }
            } else {
                if i.isEven() {
                    x.append(Double(list[i]) ?? 0.0)
                } else {
                    y.append((Double(list[i]) ?? 0.0) * multiplier)
                }
            }
        }
        var latLons = [LatLon]()
        if y.count > 3 && x.count > 3 && x.count == y.count {
            x.enumerated().forEach { index, _ in latLons.append(LatLon(x[index], y[index])) }
        }
        return latLons
    }
    
    static func latLonListToListOfDoubles(_ latLons: [LatLon], _ projectionNumbers: ProjectionNumbers) -> [Double] {
        var warningList = [Double]()
        if latLons.count > 0 {
            let startCoordinates = UtilityCanvasProjection.computeMercatorNumbers(latLons[0], projectionNumbers)
            warningList += startCoordinates
            (1..<latLons.count).forEach { index in
                let coordinates = UtilityCanvasProjection.computeMercatorNumbers(latLons[index], projectionNumbers)
                warningList += coordinates
                warningList += coordinates
            }
            warningList += startCoordinates
        }
        return warningList
    }
    
    static func storeWatchMcdLatLon(_ html: String) -> String {
        let coordinates = html.parseColumn("([0-9]{8}).*?")
        var string = ""
        coordinates.forEach { string += LatLon($0).printSpaceSeparated() }
        string += ":"
        return string.replace(" :", ":")
    }
}

extension LatLon: Equatable {
    static func == (lhs: LatLon, rhs: LatLon) -> Bool { lhs.latString == rhs.latString && lhs.lonString == rhs.lonString }
}
