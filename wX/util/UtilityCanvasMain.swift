/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class UtilityCanvasMain {

    /*private static let showPolygonsCanvas = false

    static func addCanvasItems(
        _ bitmapCanvas: Bitmap,
        _ scaleType: ProjectionType,
        _ radarSite: String,
        _ hwLineWidth: Int,
        _ archive: Bool,
        _ citySize: Int
    ) {
        let highwayProvider = (scaleType == .nwsMosaicSector
            || scaleType == .nwsMosaic
            || scaleType == .wxRender48
            || scaleType == .wxRender)
        let stateLinesProvider = (scaleType == .nwsMosaicSector
            || scaleType == .nwsMosaic
            || scaleType == .wxRender48
            || scaleType == .wxRender)
        let cityProvider = true
        if showPolygonsCanvas && PolygonType.TST.display && !archive {
            UtilityCanvas.addWarnings(scaleType, bitmapCanvas, radarSite)
        }
        if GeographyType.highways.display && highwayProvider {
            UtilityCanvasGeneric.draw(scaleType, bitmapCanvas, radarSite, hwLineWidth, GeographyType.highways)
        }
        if GeographyType.cities.display && cityProvider {
            UtilityCanvas.drawCitiesUS(scaleType, bitmapCanvas, radarSite, citySize)
        }
        if stateLinesProvider {
            UtilityCanvasGeneric.draw(scaleType, bitmapCanvas, radarSite, 1, GeographyType.stateLines)
            if GeographyType.lakes.display {
                UtilityCanvasGeneric.draw(scaleType, bitmapCanvas, radarSite, hwLineWidth, GeographyType.lakes)
            }
        }
        if PolygonType.LOCDOT.display {
            UtilityCanvas.addLocationDotForCurrentLocation(scaleType, bitmapCanvas, radarSite)
        }
        if showPolygonsCanvas {
            if PolygonType.MCD.display {
                [PolygonType.MCD, PolygonType.WATCH, PolygonType.WATCH_TORNADO].forEach {
                    UtilityCanvas.addMCD(scaleType, bitmapCanvas, radarSite, $0)
                }
            }
            if PolygonType.MPD.display {
                UtilityCanvas.addMCD(scaleType, bitmapCanvas, radarSite, .MPD)
            }
        }
    }*/
}
