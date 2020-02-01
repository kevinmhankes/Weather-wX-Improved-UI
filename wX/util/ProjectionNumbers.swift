/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class ProjectionNumbers {

    var scale = 0.0
    var oneDegreeScaleFactor = 0.0
    var lat = "0.0"
    var lon = "0.0"
    var xCenter = 0.0
    var yCenter = 0.0
    private var polygonWidth = 0.0
    var radarSite = ""

    init() {
        oneDegreeScaleFactor = UtilityMath.pixPerDegreeLon(xDbl, scale)
    }

    init(_ scale: Double,
         _ lat: String,
         _ lon: String,
         _ xCenter: Double,
         _ yCenter: Double,
         _ polygonWidth: Double = 0.0
    ) {
        self.scale = scale
        self.lat = lat
        self.lon = lon
        self.xCenter = xCenter
        self.yCenter = yCenter
        self.polygonWidth = polygonWidth
        oneDegreeScaleFactor = UtilityMath.pixPerDegreeLon(xDbl, scale)
    }

    init(_ radarSite: String, _ provider: ProjectionType) {
        self.radarSite = radarSite
        lat = ""
        lon = ""
        scale = 0.0
        xCenter = 0.0
        yCenter = 0.0
        polygonWidth = 2.0
        switch provider {
        case .nwsMosaic:
            scale = 110.0
            xCenter = 3400
            yCenter = 1600
        case .nwsMosaicSector:
            if radarSite=="hawaii" {
                scale = 62.00
                xCenter = 300
                yCenter = 285
            } else {
                scale = 111.0
                xCenter = 840
                yCenter = 800
            }
        case .wxRender:
            scale = 190.00
            xCenter = 500
            yCenter = 500
            polygonWidth = 2
        case .iosQuartz:
            scale = 190.00
            xCenter = 414/2
            yCenter = 738/2
            polygonWidth = 2
        case .wxRender48:
            scale = 450.00
            xCenter = 500
            yCenter = 500
            polygonWidth = 1
        case .wxOgl:
            scale = 190.00
            xCenter = 0
            yCenter = 0
            polygonWidth = 1
        case .wxOgl48:
            scale = 450.00
            xCenter = 0
            yCenter = 0
            polygonWidth = 1
        }
        //lat = Utility.readPref("RID_" + radarSite + "_X", "0.00")
        //lon = Utility.readPref("RID_" + radarSite + "_Y", "0.00")
        lat = Utility.getRadarSiteX(radarSite)
        lon = Utility.getRadarSiteY(radarSite)
        oneDegreeScaleFactor = UtilityMath.pixPerDegreeLon(xDbl, scale)
    }

    var xDbl: Double {return Double(lat) ?? 0.0}

    var xFloat: Float {return Float(lat) ?? 0.0}

    var yDbl: Double {return Double(lon) ?? 0.0}

    var yFloat: Float {return Float(lon) ?? 0.0}

    var xCenterFloat: Float {return Float(xCenter)}

    var yCenterFloat: Float {return Float(yCenter)}

    var xCenterDouble: Double {return Double(xCenter)}

    var yCenterDouble: Double {return Double(yCenter)}

    var oneDegreeScaleFactorFloat: Float {return Float(oneDegreeScaleFactor)}

    var latlon: LatLon { return LatLon(lat, lon)}
}
