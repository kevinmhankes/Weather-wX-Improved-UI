/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class UtilityNWS {

    static func getIcon(_ url: String) -> Bitmap {
        //print(url)
        var bitmap = Bitmap()
        if url == "NULL" {
            return bitmap
        }
        var fileName = url.replace("?size=medium", "")
            .replace("?size=small", "")
            .replace("https://api.weather.gov/icons/land/", "")
            .replace("http://api.weather.gov/icons/land/", "")
            .replace("day/", "")
        if fileName.contains("night") {
            fileName = fileName.replace("night//", "n").replace("night/", "n").replace("/", "/n")
        }
        //print(fileName)
        if let fnResId = UtilityNwsIcon.iconMap[fileName + ".png"] {
            bitmap = UtilityIO.readBitmapResourceFromFile(fnResId)
        } else {
            bitmap = parseBitmap(fileName)
        }
        //return Bitmap.resize(image: bitmap.image, ratio: 0.50)
        return bitmap
    }

    static func parseBitmap(_ url: String) -> Bitmap {
        var bitmap = Bitmap()
        if url.contains("/") {
            var tmpArr = [String]()
            tmpArr = url.split("/")
            if tmpArr.count > 1 {
                bitmap = dualBitmapWithNumbers(tmpArr[0], tmpArr[1])
            }
        } else {
            bitmap = dualBitmapWithNumbers(url)
        }
        return bitmap
    }

    static let dimens = 86
    static let numHeight = 15
    //static let textFont = UIFont(name:  "Helvetica Bold", size:  12)! // HelveticaNeue-Bold
    static let textFont = UIFont(name: "HelveticaNeue-Bold", size: 12)! // HelveticaNeue-Bold

    static func dualBitmapWithNumbers(_ iconLeftString: String, _ iconRightString: String) -> Bitmap {
        let textColor = wXColor(UIPreferences.nwsIconTextColor).uicolorCurrent
        let textFontAttributes = [
            NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): textFont,
            NSAttributedString.Key.foregroundColor: textColor
            ] as [NSAttributedString.Key: Any]?
        var num1 = ""
        var num2 = ""
        var aSplit = iconLeftString.split(",")
        var bSplit = iconRightString.split(",")
        if aSplit.count > 1 {
            num1 = aSplit[1]
        }
        if bSplit.count > 1 {
            num2 = bSplit[1]
        }
        var aLocal = ""
        var bLocal = ""
        if aSplit.count > 0 && bSplit.count > 0 {
            aLocal = aSplit[0]
            bLocal = bSplit[0]
        }
        var leftCropA = 4
        var leftCropB = 4
        let halfWidth = 41
        let middlePoint = 45
        if iconLeftString.contains("fg") {
            leftCropA = middlePoint
        }
        if iconRightString.contains("fg") {
            leftCropB = middlePoint
        }
        var bitmapLeft = Bitmap()
        var bitmapRight = Bitmap()
        if let fileNameLeft = UtilityNwsIcon.iconMap[aLocal + ".png"] {
            bitmapLeft = UtilityIO.readBitmapResourceFromFile(fileNameLeft)
        }
        if let fileNameRight = UtilityNwsIcon.iconMap[bLocal + ".png"] {
            bitmapRight = UtilityIO.readBitmapResourceFromFile(fileNameRight)
        }
        let size = CGSize(width: dimens, height: dimens)
        let rect = CGRect(x: leftCropA, y: 0, width: halfWidth, height: dimens)
        let imageRef: CGImage = bitmapLeft.image.cgImage!.cropping(to: rect)!
        bitmapLeft.image = UIImage(cgImage: imageRef)
        let rectB = CGRect(x: leftCropB, y: 0, width: halfWidth, height: dimens)
        let imageRefB = bitmapRight.image.cgImage!.cropping(to: rectB)!
        bitmapRight.image = UIImage(cgImage: imageRefB)
        let rendererFormat = UIGraphicsImageRendererFormat()
        rendererFormat.opaque = true
        let renderer = UIGraphicsImageRenderer(size: size, format: rendererFormat)
        let newImage = renderer.image {_ in
            let bgRect = CGRect(x: 0, y: 0, width: dimens, height: dimens)
            UIColor.white.setFill()
            UIRectFill(bgRect)
            let aSize = CGRect(x: 0, y: 0, width: halfWidth, height: dimens)
            bitmapLeft.image.draw(in: aSize)
            let bSize = CGRect(x: middlePoint, y: 0, width: halfWidth, height: dimens)
            bitmapRight.image.draw(in: bSize, blendMode: .normal, alpha: 1.0)
            let xText = 58
            let yText = 70
            let xTextLeft = 2
            let fillColor = wXColor(UIPreferences.nwsIconBottomColor, 0.785).uicolorCurrent
            if num1 != "" {
                let rectangle = CGRect(x: 0, y: dimens - numHeight, width: halfWidth, height: dimens)
                fillColor.setFill()
                UIRectFill(rectangle)
                let rect = CGRect(x: xTextLeft, y: yText, width: dimens, height: dimens)
                let strToDraw = num1 + "%"
                strToDraw.draw(in: rect, withAttributes: textFontAttributes)
            }
            if num2 != "" {
                let rectangle = CGRect(x: middlePoint, y: dimens - numHeight, width: halfWidth, height: dimens)
                fillColor.setFill()
                UIRectFill(rectangle)
                let rect = CGRect(x: xText, y: yText, width: dimens, height: dimens)
                let strToDraw = num2 + "%"
                strToDraw.draw(in: rect, withAttributes: textFontAttributes)
            }
        }
        return Bitmap(newImage)
    }

    static func dualBitmapWithNumbers(_ iconString: String) -> Bitmap {
        var num1 = ""
        var aSplit = iconString.split(",")
        if aSplit.count > 1 {
            num1 = aSplit[1]
        }
        var aLocal = ""
        if aSplit.count > 0 {
            aLocal = aSplit[0]
        }
        let textColor = wXColor(UIPreferences.nwsIconTextColor).uicolorCurrent
        let textFontAttributes = [
            NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): textFont ,
            NSAttributedString.Key.foregroundColor: textColor
            ]  as [NSAttributedString.Key: Any]?
        var bitmap = Bitmap()
        if let fileName = UtilityNwsIcon.iconMap[aLocal + ".png"] {
            bitmap = UtilityIO.readBitmapResourceFromFile(fileName)
        }
        let imageSize = bitmap.image.size
        var xText = 58
        if num1 == "100" {
            xText = 50
        }
        let rendererFormat = UIGraphicsImageRendererFormat()
        rendererFormat.opaque = true
        let renderer = UIGraphicsImageRenderer(size: imageSize, format: rendererFormat)
        let newImage = renderer.image {_ in
            bitmap.image.draw(at: CGPoint.zero)
            if num1 != "" {
                // FIXME method
                let rectangle = CGRect(x: 0, y: dimens - numHeight, width: dimens, height: dimens)
                let fillColor = wXColor(UIPreferences.nwsIconBottomColor, 0.785).uicolorCurrent
                fillColor.setFill()
                UIRectFill(rectangle)
                let rect = CGRect(x: xText, y: 70, width: dimens, height: dimens)
                let strToDraw = num1 + "%"
                strToDraw.draw(in: rect, withAttributes: textFontAttributes)
            }
        }
        return Bitmap(newImage)
    }
}
