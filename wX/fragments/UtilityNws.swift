/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

// TODO rename
final class UtilityNws {

    // Given the raw icon URL from NWS, determine if bitmap is on disk or must be created
    // input examples
    //  https://api.weather.gov/icons/land/day/rain_showers,60/rain_showers,30?size=medium
    //  https://api.weather.gov/icons/land/night/bkn?size=medium
    //  https://api.weather.gov/icons/land/day/tsra_hi,40?size=medium
    static func getIcon(_ url: String) -> Bitmap {
        //print("DEBUG223: " + url)
        if url == "NULL" { return Bitmap() }
        var fileName = url.replace("?size=medium", "")
            .replace("?size=small", "").replace("https://api.weather.gov/icons/land/", "")
            .replace("http://api.weather.gov/icons/land/", "").replace("day/", "")
        if fileName.contains("night") { fileName = fileName.replace("night//", "n").replace("night/", "n").replace("/", "/n") }
        if let fnResId = UtilityNwsIcon.iconMap[fileName + ".png"] {
            return UtilityIO.readBitmapResourceFromFile(fnResId)
        } else {
            return parseBitmapString(fileName)
        }
    }

    // Given one string that does not have a match on disk, decode and return a bitmap with textual labels
    // it could be composed of 2 bitmaps with one or more textual labels (if string has a "/" ) or just one bitmap with label
    // input examples
    //  rain_showers,70/tsra,80
    //  ntsra,80
    static private func parseBitmapString(_ url: String) -> Bitmap {
        if url.contains("/") {
            let items = url.split("/")
            if items.count > 1 { return getDualBitmapWithNumbers(items[0], items[1]) } else { return Bitmap() }
        } else {
            return getBitmapWithOneNumber(url)
        }
    }

    static private let dimensions = 86
    static private let numHeight = 15
    static private let textFont = UIFont(name: "HelveticaNeue-Bold", size: 12)! // HelveticaNeue-Bold

    // Given two strings return a custom bitmap made of two bitmaps with optional numeric label
    // input examples
    //  rain_showers,60 rain_showers,30
    //  nrain_showers,80 nrain_showers,70
    //  ntsra_hi,40 ntsra_hi
    //  bkn rain
    static private func getDualBitmapWithNumbers(_ iconLeftString: String, _ iconRightString: String) -> Bitmap {
        //print("DEBUG2: " + iconLeftString + " " + iconRightString)
        let textColor = wXColor(UIPreferences.nwsIconTextColor).uiColorCurrent
        let textFontAttributes = [
            NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): textFont,
            NSAttributedString.Key.foregroundColor: textColor
            ] as [NSAttributedString.Key: Any]?
        let leftTokens = iconLeftString.split(",")
        let rightTokens = iconRightString.split(",")
        let leftNumber = leftTokens.count > 1 ? leftTokens[1] : ""
        let rightNumber = rightTokens.count > 1 ? rightTokens[1] : ""
        let leftWeatherCondition: String
        let rightWeatherCondition: String
        if leftTokens.count > 0 && rightTokens.count > 0 {
            leftWeatherCondition = leftTokens[0]
            rightWeatherCondition = rightTokens[0]
        } else {
            leftWeatherCondition = ""
            rightWeatherCondition = ""
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
        if let fileNameLeft = UtilityNwsIcon.iconMap[leftWeatherCondition + ".png"] {
            bitmapLeft = UtilityIO.readBitmapResourceFromFile(fileNameLeft)
        } else {
            bitmapLeft = Bitmap()
        }
        if let fileNameRight = UtilityNwsIcon.iconMap[rightWeatherCondition + ".png"] {
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
            if leftNumber != "" {
                let rectangle = CGRect(x: 0, y: dimensions - numHeight, width: halfWidth, height: dimensions)
                fillColor.setFill()
                UIRectFill(rectangle)
                let rect = CGRect(x: xTextLeft, y: yText, width: dimensions, height: dimensions)
                let strToDraw = leftNumber + "%"
                strToDraw.draw(in: rect, withAttributes: textFontAttributes)
            }
            if rightNumber != "" {
                let rectangle = CGRect(x: middlePoint, y: dimensions - numHeight, width: halfWidth, height: dimensions)
                fillColor.setFill()
                UIRectFill(rectangle)
                let rect = CGRect(x: xText, y: yText, width: dimensions, height: dimensions)
                let strToDraw = rightNumber + "%"
                strToDraw.draw(in: rect, withAttributes: textFontAttributes)
            }
        }
        return Bitmap(newImage)
    }
    
    // Given one string return a custom bitmap with numeric label
    // input examples
    //  nrain_showers,80
    //  tsra_hi,40
    static private func getBitmapWithOneNumber(_ iconString: String) -> Bitmap {
        //print("DEBUG2: " + iconString)
        let items = iconString.split(",")
        let number = items.count > 1 ? items[1] : ""
        let weatherCondition = items.count > 0 ? items[0] : ""
        let textColor = wXColor(UIPreferences.nwsIconTextColor).uiColorCurrent
        let textFontAttributes = [
            NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): textFont ,
            NSAttributedString.Key.foregroundColor: textColor
            ]  as [NSAttributedString.Key: Any]?
        let bitmap: Bitmap
        if let fileName = UtilityNwsIcon.iconMap[weatherCondition + ".png"] {
            bitmap = UtilityIO.readBitmapResourceFromFile(fileName)
            //print("DEBUG2: " + fileName)
        } else {
            bitmap = Bitmap()
            //print("DEBUG2: empty")
        }
        //let bitmap = UtilityNwsIcon.iconMap[aLocal + ".png"] != nil ? UtilityIO.readBitmapResourceFromFile(UtilityNwsIcon.iconMap[aLocal + ".png"]!) : Bitmap()
        let imageSize = bitmap.image.size
        let xText = number == "100" ? 50 : 58
        let rendererFormat = UIGraphicsImageRendererFormat()
        rendererFormat.opaque = true
        let renderer = UIGraphicsImageRenderer(size: imageSize, format: rendererFormat)
        let newImage = renderer.image { _ in
            bitmap.image.draw(at: CGPoint.zero)
            if number != "" {
                let rectangle = CGRect(x: 0, y: dimensions - numHeight, width: dimensions, height: dimensions)
                let fillColor = wXColor(UIPreferences.nwsIconBottomColor, 0.785).uiColorCurrent
                fillColor.setFill()
                UIRectFill(rectangle)
                let rect = CGRect(x: xText, y: 70, width: dimensions, height: dimensions)
                let strToDraw = number + "%"
                strToDraw.draw(in: rect, withAttributes: textFontAttributes)
            }
        }
        return Bitmap(newImage)
    }
}
