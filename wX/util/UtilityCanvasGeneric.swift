/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class UtilityCanvasGeneric {

    static func draw(
        _ provider: ProjectionType,
        _ bitmap: Bitmap,
        _ radarSite: String,
        _ lineWidth: Int,
        _ type: GeographyType
    ) {
        let isMercato = UtilityCanvasProjection.isMercator(provider)
        let paint = Paint()
        var genericCount: Int
        var genericByteBuffer: MemoryBuffer
        switch type.string {
        case "COUNTY_LINES", "LAKES", "HIGHWAYS", "STATE_LINES":
            paint.setColor(type.color)
            genericCount = type.count
            genericByteBuffer = type.relativeBuffer
        default:
            genericCount = 0
            genericByteBuffer = RadarGeometry.stateRelativeBuffer
        }
        genericByteBuffer.position = 0
        let pn = ProjectionNumbers(radarSite, provider)
        pn.xCenter = Double(bitmap.image.size.width) / 2.0
        pn.yCenter = Double(bitmap.image.size.height) / 2.0
        var tmpCoords = (0.0, 0.0)
        var tmpCoords2 = (0.0, 0.0)
        let rendererFormat = UIGraphicsImageRendererFormat()
        rendererFormat.opaque = false
        rendererFormat.scale = 1.0
        let renderer = UIGraphicsImageRenderer(size: bitmap.image.size, format: rendererFormat)
        let newImage = renderer.image {_ in
            bitmap.image.draw(at: CGPoint.zero)
            let wallpath = UIBezierPath()
            stride(from: 0, to: genericCount, by: 4).forEach { _ in
                if isMercato {
                    tmpCoords =
                        UtilityCanvasProjection.computeMercatorNumbers(
                            Double(genericByteBuffer.getFloat()),
                            Double(genericByteBuffer.getFloat()), pn
                        )
                    tmpCoords2 =
                        UtilityCanvasProjection.computeMercatorNumbers(
                            Double(genericByteBuffer.getFloat()),
                            Double(genericByteBuffer.getFloat()), pn
                        )
                } else {
                    tmpCoords = UtilityCanvasProjection.compute4326Numbers(pn)
                    tmpCoords2 = UtilityCanvasProjection.compute4326Numbers(pn)
                }
                wallpath.move(to: CGPoint(x: CGFloat(tmpCoords.0), y: CGFloat(tmpCoords.1)))
                wallpath.addLine(to: CGPoint(x: CGFloat(tmpCoords2.0), y: CGFloat(tmpCoords2.1)))
            }
            paint.uicolor.setStroke()
            wallpath.stroke()
        }
        bitmap.image = newImage
    }
}
