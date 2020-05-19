/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class UtilityNws {

    static func getIcon(_ url: String) -> Bitmap {
        if url == "NULL" { return Bitmap() }
        var fileName = url.replace("?size=medium", "")
            .replace("?size=small", "").replace("https://api.weather.gov/icons/land/", "")
            .replace("http://api.weather.gov/icons/land/", "").replace("day/", "")
        if fileName.contains("night") { fileName = fileName.replace("night//", "n").replace("night/", "n").replace("/", "/n") }
        if let fnResId = UtilityNwsIcon.iconMap[fileName + ".png"] {
            return UtilityIO.readBitmapResourceFromFile(fnResId)
        } else {
            return parseBitmap(fileName)
        }
    }

    static func parseBitmap(_ url: String) -> Bitmap {
        let bitmap: Bitmap
        if url.contains("/") {
            let tokens = url.split("/")
            if tokens.count > 1 { bitmap = dualBitmapWithNumbers(tokens[0], tokens[1]) } else { bitmap = Bitmap() }
        } else {
            bitmap = dualBitmapWithNumbers(url)
        }
        return bitmap
    }

    static let dimensions = 86
    static let numHeight = 15
    static let textFont = UIFont(name: "HelveticaNeue-Bold", size: 12)! // HelveticaNeue-Bold

    static func dualBitmapWithNumbers(_ iconLeftString: String, _ iconRightString: String) -> Bitmap {
        let textColor = wXColor(UIPreferences.nwsIconTextColor).uiColorCurrent
        let textFontAttributes = [
            NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): textFont,
            NSAttributedString.Key.foregroundColor: textColor
            ] as [NSAttributedString.Key: Any]?
        let aSplit = iconLeftString.split(",")
        let bSplit = iconRightString.split(",")
        let num1 = aSplit.count > 1 ? aSplit[1] : ""
        let num2 = bSplit.count > 1 ? bSplit[1] : ""
        let aLocal: String
        let bLocal: String
        if aSplit.count > 0 && bSplit.count > 0 {
            aLocal = aSplit[0]
            bLocal = bSplit[0]
        } else {
            aLocal = ""
            bLocal = ""
        }
        let leftCropA: Int
        let leftCropB: Int
        let halfWidth = 41
        let middlePoint = 45
        if iconLeftString.contains("fg") { leftCropA = middlePoint } else { leftCropA = 4 }
        if iconRightString.contains("fg") { leftCropB = middlePoint } else { leftCropB = 4 }
        let bitmapLeft: Bitmap
        let bitmapRight: Bitmap
        // TODO cond ? a : b
        if let fileNameLeft = UtilityNwsIcon.iconMap[aLocal + ".png"] {
            bitmapLeft = UtilityIO.readBitmapResourceFromFile(fileNameLeft)
        } else {
            bitmapLeft = Bitmap()
        }
        if let fileNameRight = UtilityNwsIcon.iconMap[bLocal + ".png"] {
            bitmapRight = UtilityIO.readBitmapResourceFromFile(fileNameRight)
        } else {
            bitmapRight = Bitmap()
        }
        let size = CGSize(width: dimensions, height: dimensions)
        let rect = CGRect(x: leftCropA, y: 0, width: halfWidth, height: dimensions)
        let imageRef: CGImage = bitmapLeft.image.cgImage!.cropping(to: rect)!
        bitmapLeft.image = UIImage(cgImage: imageRef)
        let rectB = CGRect(x: leftCropB, y: 0, width: halfWidth, height: dimensions)
        let imageRefB = bitmapRight.image.cgImage!.cropping(to: rectB)!
        bitmapRight.image = UIImage(cgImage: imageRefB)
        let rendererFormat = UIGraphicsImageRendererFormat()
        rendererFormat.opaque = true
        let renderer = UIGraphicsImageRenderer(size: size, format: rendererFormat)
        let newImage = renderer.image { _ in
            let bgRect = CGRect(x: 0, y: 0, width: dimensions, height: dimensions)
            UIColor.white.setFill()
            UIRectFill(bgRect)
            let aSize = CGRect(x: 0, y: 0, width: halfWidth, height: dimensions)
            bitmapLeft.image.draw(in: aSize)
            let bSize = CGRect(x: middlePoint, y: 0, width: halfWidth, height: dimensions)
            bitmapRight.image.draw(in: bSize, blendMode: .normal, alpha: 1.0)
            let xText = 58
            let yText = 70
            let xTextLeft = 2
            let fillColor = wXColor(UIPreferences.nwsIconBottomColor, 0.785).uiColorCurrent
            if num1 != "" {
                let rectangle = CGRect(x: 0, y: dimensions - numHeight, width: halfWidth, height: dimensions)
                fillColor.setFill()
                UIRectFill(rectangle)
                let rect = CGRect(x: xTextLeft, y: yText, width: dimensions, height: dimensions)
                let strToDraw = num1 + "%"
                strToDraw.draw(in: rect, withAttributes: textFontAttributes)
            }
            if num2 != "" {
                let rectangle = CGRect(x: middlePoint, y: dimensions - numHeight, width: halfWidth, height: dimensions)
                fillColor.setFill()
                UIRectFill(rectangle)
                let rect = CGRect(x: xText, y: yText, width: dimensions, height: dimensions)
                let strToDraw = num2 + "%"
                strToDraw.draw(in: rect, withAttributes: textFontAttributes)
            }
        }
        return Bitmap(newImage)
    }

    static func dualBitmapWithNumbers(_ iconString: String) -> Bitmap {
        let aSplit = iconString.split(",")
        let num1 = aSplit.count > 1 ? aSplit[1] : ""
        let aLocal = aSplit.count > 0 ? aSplit[0] : ""
        let textColor = wXColor(UIPreferences.nwsIconTextColor).uiColorCurrent
        let textFontAttributes = [
            NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): textFont ,
            NSAttributedString.Key.foregroundColor: textColor
            ]  as [NSAttributedString.Key: Any]?
        let bitmap: Bitmap
        if let fileName = UtilityNwsIcon.iconMap[aLocal + ".png"] {
            bitmap = UtilityIO.readBitmapResourceFromFile(fileName)
            print("DEBUG2: " + fileName)
        } else {
            bitmap = Bitmap()
            print("DEBUG2: empty")
        }
        //let bitmap = UtilityNwsIcon.iconMap[aLocal + ".png"] != nil ? UtilityIO.readBitmapResourceFromFile(UtilityNwsIcon.iconMap[aLocal + ".png"]!) : Bitmap()
        let imageSize = bitmap.image.size
        let xText: Int
        if num1 == "100" { xText = 50 } else { xText = 58 }
        let rendererFormat = UIGraphicsImageRendererFormat()
        rendererFormat.opaque = true
        let renderer = UIGraphicsImageRenderer(size: imageSize, format: rendererFormat)
        let newImage = renderer.image { _ in
            bitmap.image.draw(at: CGPoint.zero)
            if num1 != "" {
                let rectangle = CGRect(x: 0, y: dimensions - numHeight, width: dimensions, height: dimensions)
                let fillColor = wXColor(UIPreferences.nwsIconBottomColor, 0.785).uiColorCurrent
                fillColor.setFill()
                UIRectFill(rectangle)
                let rect = CGRect(x: xText, y: 70, width: dimensions, height: dimensions)
                let strToDraw = num1 + "%"
                strToDraw.draw(in: rect, withAttributes: textFontAttributes)
            }
        }
        return Bitmap(newImage)
    }
}
