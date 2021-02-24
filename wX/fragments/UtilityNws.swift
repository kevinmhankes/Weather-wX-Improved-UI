/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class UtilityNws {

    // Given the raw icon URL from NWS, determine if bitmap is on disk or must be created
    // Note that the url given to getIcon can handle either the new or old format below
    //
    // NEW API input examples
    //  https://api.weather.gov/icons/land/day/rain_showers,60/rain_showers,30?size=medium
    //  https://api.weather.gov/icons/land/night/bkn?size=medium
    //  https://api.weather.gov/icons/land/day/tsra_hi,40?size=medium
    //
    // OLD API input examples
    //
    // <icon-link>http://forecast.weather.gov/DualImage.php?i=nbkn&j=nsn&jp=60</icon-link>
    // <icon-link>http://forecast.weather.gov/newimages/medium/ra_sn30.png</icon-link>
    // <icon-link>http://forecast.weather.gov/newimages/medium/nsct.png</icon-link>
    // <icon-link>http://forecast.weather.gov/DualImage.php?i=sn&j=ra_sn&ip=30&jp=30</icon-link>
    static func getIcon(_ url: String) -> Bitmap {
        // print("DEBUG223: " + url)
        if url == "NULL" || url == "" {
            return Bitmap()
        }
        var fileName = url.replace("?size=medium", "")
            .replace("?size=small", "")
            .replace("https://api.weather.gov/icons/land/", "")
            .replace("http://api.weather.gov/icons/land/", "")
            .replace("day/", "")
        
        // legacy add
        fileName = fileName.replace("http://forecast.weather.gov/newimages/medium/", "")
        fileName = fileName.replace(".png", "")
        fileName = fileName.replace("http://forecast.weather.gov/DualImage.php?", "")
        fileName = fileName.replace("&amp", "")
        // legacy add end
        
        if fileName.contains("night") {
            fileName = fileName.replace("night//", "n")
                .replace("night/", "n")
                .replace("/", "/n")
        }
        
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
        if url.contains("/") || url.contains(";j=") || (url.contains("i=") && url.contains("j=")) {
            let items = url.split("/")
            if items.count > 1 {
                return getDualBitmapWithNumbers(items[0], items[1])
            } else {
                // legacy add
                var urlTmp = url.replace("i=", "")
                urlTmp = urlTmp.replace("j=", "")
                urlTmp = urlTmp.replace("ip=", "")
                urlTmp = urlTmp.replace("jp=", "")
                let items = urlTmp.split(";")
                
//                if items.count > 3 {
//                    return getDualBitmapWithNumbers(items[0] + items[2], items[1] + items[3])
//                } else {
//                    return getDualBitmapWithNumbers(items[0], items[1])
//                }
                
                if items.count > 3 {
                    return getDualBitmapWithNumbers(items[0] + items[2], items[1] + items[3])
                } else if items.count > 2 {
                    if url.contains(";jp=") {
                        return getDualBitmapWithNumbers(items[0], items[1] + items[2])
                    } else {
                        return getDualBitmapWithNumbers(items[0] + items[2], items[1])
                    }
                } else {
                    return getDualBitmapWithNumbers(items[0], items[1])
                }
                
                // legacy add end
                // return Bitmap()
            }
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
        let textColor = wXColor(UIPreferences.nwsIconTextColor).uiColorCurrent
        let textFontAttributes = [
            NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): textFont,
            NSAttributedString.Key.foregroundColor: textColor
            ] as [NSAttributedString.Key: Any]?
        let leftTokens = iconLeftString.split(",")
        let rightTokens = iconRightString.split(",")
        var leftNumber = leftTokens.count > 1 ? leftTokens[1] : ""
        var rightNumber = rightTokens.count > 1 ? rightTokens[1] : ""
        var leftWeatherCondition: String
        var rightWeatherCondition: String
        if leftTokens.count > 0 && rightTokens.count > 0 {
            leftWeatherCondition = leftTokens[0]
            rightWeatherCondition = rightTokens[0]
        } else {
            leftWeatherCondition = ""
            rightWeatherCondition = ""
        }
        
        // legacy add
        if !iconLeftString.contains(",") && !iconRightString.contains(",") {
            leftNumber = UtilityString.parse(iconLeftString, ".*?([0-9]+)")
            leftWeatherCondition = UtilityString.parse(iconLeftString, "([a-z_]+)")
            rightNumber = UtilityString.parse(iconRightString, ".*?([0-9]+)")
            rightWeatherCondition = UtilityString.parse(iconRightString, "([a-z_]+)")
        }
        // legacy add end
        
        let halfWidth = 41
        let middlePoint = 45
        let leftCropA = iconLeftString.contains("fg") ? middlePoint : 4
        let leftCropB = iconRightString.contains("fg") ? middlePoint : 4
        let bitmapLeft: Bitmap
        let bitmapRight: Bitmap
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
        let items = iconString.split(",")
        var number = items.count > 1 ? items[1] : ""
        var weatherCondition = items.count > 0 ? items[0] : ""
        
        // legacy add
        if !iconString.contains(",") {
            number = UtilityString.parse(iconString, ".*?([0-9]+)")
            weatherCondition = UtilityString.parse(iconString, "([a-z_]+)")
        }
        // legacy add end
        
        let textColor = wXColor(UIPreferences.nwsIconTextColor).uiColorCurrent
        let textFontAttributes = [
            NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): textFont ,
            NSAttributedString.Key.foregroundColor: textColor
            ]  as [NSAttributedString.Key: Any]?
        let bitmap: Bitmap
        if let fileName = UtilityNwsIcon.iconMap[weatherCondition + ".png"] {
            bitmap = UtilityIO.readBitmapResourceFromFile(fileName)
        } else {
            bitmap = Bitmap()
        }
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
