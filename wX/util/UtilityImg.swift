/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class UtilityImg {

    static func getAnimInterval() -> Int {
        return 50 * MyApplication.animInterval
    }

    static func layerDrawableToBitmap(_ layers: [Drawable]) -> Bitmap {
        var image = UIImage()
        if layers.count==0 {return Bitmap()}
        if layers.count < 2 {
            image = layers[0].img
        } else {
            var imgTmp = layers[0].img
            layers.forEach {imgTmp = UtilityImg.mergeImages(imgTmp, $0.img)}
            image = imgTmp
        }
        image = addColorBG(image, UIColor.white)
        return Bitmap(image)
    }

    static func layerDrawableToUIImage(_ layers: [Drawable]) -> UIImage {
        var image = UIImage()
        if layers.count < 2 {
            image = layers[0].img
        } else {
            var imgTmp = layers[0].img
            layers.forEach {imgTmp = UtilityImg.mergeImages(imgTmp, $0.img)}
            image = imgTmp
        }
        return image
    }

    static func getBitmapAddWhiteBG(_ url: String) -> Bitmap {
        let bitmap = Bitmap(url)
        let image = addColorBG(bitmap.image, UIColor.white)
        return Bitmap(image)
    }

    static func addColorBG(_ img: UIImage, _ tintColor: UIColor) -> UIImage {
        let whiteImg = createSolidImage(tintColor, CGSize(width: img.size.width, height: img.size.height))
        return mergeImages(whiteImg, img)
    }

    static func mergeImages(_ imageA: UIImage, _ imageB: UIImage) -> UIImage {
        let newSize = CGSize(width: imageA.size.width, height: imageA.size.height)
        let rendererFormat = UIGraphicsImageRendererFormat()
        rendererFormat.opaque = false
        let renderer = UIGraphicsImageRenderer(size: newSize, format: rendererFormat)
        let newImage = renderer.image {_ in
            imageA.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
            imageB.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        }
        return newImage
    }

    static func createSolidImage(_ color: UIColor, _ size: CGSize) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        let rendererFormat = UIGraphicsImageRendererFormat()
        rendererFormat.opaque = false
        rendererFormat.scale = 0.0
        let renderer = UIGraphicsImageRenderer(size: rect.size, format: rendererFormat)
        let newImage = renderer.image {_ in
            color.setFill()
            UIRectFill(rect)
        }
        return newImage
    }

    static func imgSavePosnZoom(_ img: ImageScrollView, _ uiv: UIViewController) {
        let z = Float(img.zoomScale)
        let cgpoint = img.contentOffset
        let x = Float(cgpoint.x)
        let y = Float(cgpoint.y)
        let prefStr = Utility.getClassName(uiv)
        print("save start")
        print(x)
        print(y)
        print(z)
        print("save end")
        Utility.writePref(prefStr + "_X", x)
        Utility.writePref(prefStr + "_Y", y)
        Utility.writePref(prefStr + "_ZOOM", z)
    }

    static func imgRestorePosnZoom(_ img: ImageScrollView, _ uiv: UIViewController) {
        let prefStr = Utility.getClassName(uiv)
        let z = CGFloat(Utility.readPref(prefStr + "_ZOOM", 1.0))
        var x = CGFloat(Utility.readPref(prefStr + "_X", 0.0))
        let y = CGFloat(Utility.readPref(prefStr + "_Y", 0.0))
        if x < 20.0 {
            x = 50.0
        }
        print("restore start")
        print(x)
        print(y)
        print(z)
        print("restore end")
        //if abs(ceil(x)) > 0 && abs(ceil(y)) > 0 {
        if (x + y) > 1 {
            img.restorePosition(z, center: CGPoint(x: x, y: y))
        }
    }
    
    static func imgCenter(_ img: ImageScrollView, _ uiv: UIViewController) {
            img.restorePosition(0, center: CGPoint(x: 0.0, y: 0.0))
    }
}
