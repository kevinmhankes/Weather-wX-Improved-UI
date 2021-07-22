/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class ProjectionNumbers {
    
    private var scale = 0.0
    var oneDegreeScaleFactor = 0.0
    private var lat = "0.0"
    private var lon = "0.0"
    private var xCenter = 0.0
    private var yCenter = 0.0
    var radarSite = ""
    
    init() {
        oneDegreeScaleFactor = UtilityMath.pixPerDegreeLon(xDbl, scale)
    }
    
    init(_ radarSite: String, _ provider: ProjectionType) {
        self.radarSite = radarSite
        lat = ""
        lon = ""
        scale = 0.0
        xCenter = 0.0
        yCenter = 0.0
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
        case .iosQuartz:
            scale = 190.00
            xCenter = 414 / 2
            yCenter = 738 / 2
        case .wxRender48:
            scale = 450.00
            xCenter = 500
            yCenter = 500
        case .wxOgl:
            scale = 190.00
            xCenter = 0
            yCenter = 0
        case .wxOgl48:
            scale = 450.00
            xCenter = 0
            yCenter = 0
        }
        lat = Utility.getRadarSiteX(radarSite)
        lon = Utility.getRadarSiteY(radarSite)
        oneDegreeScaleFactor = UtilityMath.pixPerDegreeLon(xDbl, scale)
    }
    
    var xDbl: Double { to.Double(lat) }
    
    var xFloat: Float { to.Float(lat) }
    
    var yDbl: Double { to.Double(lon) }
    
    var yFloat: Float { to.Float(lon) }
    
    var xCenterFloat: Float { Float(xCenter) }
    
    var yCenterFloat: Float { Float(yCenter) }
    
    var xCenterDouble: Double { Double(xCenter) }
    
    var yCenterDouble: Double { Double(yCenter) }
    
    var oneDegreeScaleFactorFloat: Float { Float(oneDegreeScaleFactor) }
}
