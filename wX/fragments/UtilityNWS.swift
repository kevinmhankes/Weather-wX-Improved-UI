/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class UtilityNWS {

    static let NWSICON = [
        "bkn.png": R.Drawable.bkn,
        "blizzard.png": R.Drawable.blizzard,
        "cold.png": R.Drawable.cold,
        "du.png": R.Drawable.du,
        "fc.png": R.Drawable.fc,
        "few.png": R.Drawable.few,
        "fg.png": R.Drawable.fg,
        "fu.png": R.Drawable.fu,
        "fzra.png": R.Drawable.fzra,
        "fzra_sn.png": R.Drawable.fzra_sn,
        "hi_nshwrs.png": R.Drawable.hi_nshwrs,
        "hi_ntsra.png": R.Drawable.hi_ntsra,
        "hi_shwrs.png": R.Drawable.hi_shwrs,
        "hi_tsra.png": R.Drawable.hi_tsra,
        "hot.png": R.Drawable.hot,
        "hz.png": R.Drawable.hz,
        "ip.png": R.Drawable.ip,
        "nbkn.png": R.Drawable.nbkn,
        "nblizzard.png": R.Drawable.nblizzard,
        "ncold.png": R.Drawable.ncold,
        "ndu.png": R.Drawable.ndu,
        "nfc.png": R.Drawable.nfc,
        "nfew.png": R.Drawable.nfew,
        "nfg.png": R.Drawable.nfg,
        "nfu.png": R.Drawable.nfu,
        "nfzra.png": R.Drawable.nfzra,
        "nfzra_sn.png": R.Drawable.nfzra_sn,
        "nip.png": R.Drawable.nip,
        "novc.png": R.Drawable.novc,
        "nra_fzra.png": R.Drawable.nra_fzra,
        "nraip.png": R.Drawable.nraip,
        "nra.png": R.Drawable.nra,
        "nra_sn.png": R.Drawable.nra_sn,
        "nsct.png": R.Drawable.nsct,
        "nscttsra.png": R.Drawable.nscttsra,
        "nshra.png": R.Drawable.nshra,
        "nskc.png": R.Drawable.nskc,
        "nsn.png": R.Drawable.nsn,
        "ntor.png": R.Drawable.ntor,
        "ntsra.png": R.Drawable.ntsra,
        "nwind_bkn.png": R.Drawable.nwind_bkn,
        "nwind_few.png": R.Drawable.nwind_few,
        "nwind_ovc.png": R.Drawable.nwind_ovc,
        "nwind_sct.png": R.Drawable.nwind_sct,
        "nwind_skc.png": R.Drawable.nwind_skc,
        "ovc.png": R.Drawable.ovc,
        "ra_fzra.png": R.Drawable.ra_fzra,
        "raip.png": R.Drawable.raip,
        "ra.png": R.Drawable.ra,
        "sct.png": R.Drawable.sct,
        "scttsra.png": R.Drawable.scttsra,
        "shra.png": R.Drawable.shra,
        "skc.png": R.Drawable.skc,
        "sn.png": R.Drawable.sn,
        "tor.png": R.Drawable.tor,
        "tsra.png": R.Drawable.tsra,
        "wind_bkn.png": R.Drawable.wind_bkn,
        "wind_few.png": R.Drawable.wind_few,
        "wind_ovc.png": R.Drawable.wind_ovc,
        "wind_sct.png": R.Drawable.wind_sct,
        "wind_skc.png": R.Drawable.wind_skc,
        "rain.png": R.Drawable.ra,
        "nrain.png": R.Drawable.nra,
        "rain_showers.png": R.Drawable.shra,
        "nrain_showers.png": R.Drawable.nshra,
        "snow.png": R.Drawable.sn,
        "nsnow.png": R.Drawable.nsn,
        "ra_sn.png": R.Drawable.ra_sn,
        "sn_ip.png": R.Drawable.sn_ip,
        "snow_sleet.png": R.Drawable.sn_ip,
        "nsn_ip.png": R.Drawable.nsn_ip,
        "nsnow_sleet.png": R.Drawable.nsn_ip,
        "rasn.png": R.Drawable.rasn,
        "nrasn.png": R.Drawable.nrasn,
        "hurr.png": R.Drawable.hurr,
        "hurr-noh.png": R.Drawable.hurr_noh,
        //"tropstorm.png": R.Drawable.tropstorm,
        //"tropstorm-noh.png": R.Drawable.tropstorm_noh,
        "nmix.png": R.Drawable.nmix,
        "mix.png": R.Drawable.mix,
        //"ts.png": R.Drawable.ts,
        //"ts_hur_flags.png": R.Drawable.ts_hur_flags,
        "nsleet.png": R.Drawable.nip,
        "sleet.png": R.Drawable.ip,
        "haze.png": R.Drawable.hz,
        "nhaze.png": R.Drawable.ovc,
        "nhz.png": R.Drawable.ovc,
        "rain_fzra.png": R.Drawable.ra_fzra,
        "nrain_fzra.png": R.Drawable.nra_fzra,
        "nrain_snow.png": R.Drawable.nra_sn,
        "rain_snow.png": R.Drawable.ra_sn,
        "ntsra_hi.png": R.Drawable.hi_ntsra,
        "tsra_hi.png": R.Drawable.hi_tsra,
        "tsra_sct.png": R.Drawable.scttsra,
        "ntsra_sct.png": R.Drawable.nscttsra,
        "nfog.png": R.Drawable.nfg,
        "fog.png": R.Drawable.fg,
        "snow_fzra.png": R.Drawable.fzra_sn,
        "nsnow_fzra.png": R.Drawable.nfzra_sn,
        "minus_ra.png": R.Drawable.minus_ra,
        "nminus_ra.png": R.Drawable.nminus_ra,
        "nhi_tsra.png": R.Drawable.nhi_tsra,
        "ts.png": R.Drawable.ts,
        "ts_hur_flags.png": R.Drawable.ts_hur_flags,
        "ts_warn.png": R.Drawable.tropstorm_noh,
        "nts_warn.png": R.Drawable.tropstorm_noh,
        "hurricane.png": R.Drawable.hurr_noh,
        "nhurricane.png": R.Drawable.hurr_noh,
        "tropstorm.png": R.Drawable.tropstorm,
        "tropical_storm.png": R.Drawable.tropstorm_noh,
        "ntropical_storm.png": R.Drawable.tropstorm_noh,
        "tropstorm-noh.png": R.Drawable.tropstorm_noh,
        "nsmoke.png": R.Drawable.nfu,
        "smoke.png": R.Drawable.fu
    ]

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
        if let fnResId = NWSICON[fileName + ".png"] {
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
        } else {bitmap = dualBitmapWithNumbers(url)}
        return bitmap
    }

    static let dimens = 86
    static let numHeight = 15
    //static let textFont = UIFont(name:  "Helvetica Bold", size:  12)! // HelveticaNeue-Bold
    static let textFont = UIFont(name: "HelveticaNeue-Bold", size: 12)! // HelveticaNeue-Bold

    static func dualBitmapWithNumbers(_ iconLeftString: String, _ iconRightString: String) -> Bitmap {
        let textColor = wXColor(UIPreferences.nwsIconTextColor).uicolorCurrent
        let textFontAttributes = [
            NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): textFont,
            NSAttributedStringKey.foregroundColor: textColor
            ] as [NSAttributedStringKey: Any]?
        var num1 = ""
        var num2 = ""
        var aSplit = iconLeftString.split(",")
        var bSplit = iconRightString.split(",")
        if aSplit.count>1 {num1 = aSplit[1]}
        if bSplit.count>1 {num2 = bSplit[1]}
        var aLocal = ""
        var bLocal = ""
        if aSplit.count>0 && bSplit.count>0 {
            aLocal = aSplit[0]
            bLocal = bSplit[0]
        }
        var leftCropA = 4
        var leftCropB = 4
        let halfWidth = 41
        let middlePoint = 45
        if iconLeftString.contains("fg") {leftCropA = middlePoint}
        if iconRightString.contains("fg") {leftCropB = middlePoint}
        var bitmapLeft = Bitmap()
        var bitmapRight = Bitmap()
        if let fileNameLeft = NWSICON[aLocal + ".png"] {
            bitmapLeft = UtilityIO.readBitmapResourceFromFile(fileNameLeft)
        }
        if let fileNameRight = NWSICON[bLocal + ".png"] {
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
        if aSplit.count>1 {num1 = aSplit[1]}
        var aLocal = ""
        if aSplit.count>0 {aLocal = aSplit[0]}
        let textColor = wXColor(UIPreferences.nwsIconTextColor).uicolorCurrent
        let textFontAttributes = [
            NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): textFont ,
            NSAttributedStringKey.foregroundColor: textColor
            ]  as [NSAttributedStringKey: Any]?
        var bitmap = Bitmap()
        if let fileName = NWSICON[aLocal + ".png"] {bitmap = UtilityIO.readBitmapResourceFromFile(fileName)}
        let imageSize = bitmap.image.size
        var xText = 58
        if num1=="100" {xText = 50}
        let rendererFormat = UIGraphicsImageRendererFormat()
        rendererFormat.opaque = true
        let renderer = UIGraphicsImageRenderer(size: imageSize, format: rendererFormat)
        let newImage = renderer.image {_ in
            bitmap.image.draw(at: CGPoint.zero)
            if num1 != "" {
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
