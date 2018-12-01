/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class Bitmap {

    var dataBm: Data
    var image: UIImage
    var url = ""

    init() {
        self.image = Bitmap.imageWithSize(size: CGSize(width: 86, height: 86),
                                          filledWithColor: UIColor.white,
                                          scale: 1.0,
                                          opaque: false)
        self.dataBm = UIImagePNGRepresentation(self.image)!
    }

    init(_ bm: Data) {
        self.dataBm = bm
        if let imgTmp = UIImage(data: self.dataBm) {
            self.image = imgTmp
        } else {
            self.image = Bitmap.imageWithSize(size: CGSize(width: 3, height: 3),
                                              filledWithColor: UIColor.white,
                                              scale: 1.0,
                                              opaque: false)
        }
    }

    init(_ url: String) {
        let bitmapLocal = url.getImage()
        self.dataBm = bitmapLocal.dataBm
        self.image = bitmapLocal.image
        self.url = url
    }

    init(_ image: UIImage) {
        self.image = image
        if let data = UIImagePNGRepresentation(image) {
            self.dataBm = data
        } else {
            self.image = Bitmap.imageWithSize(size: CGSize(width: 86, height: 86),
                                              filledWithColor: UIColor.white,
                                              scale: 1.0,
                                              opaque: false)
            self.dataBm = UIImagePNGRepresentation(self.image)!
        }
    }

    var data: Data {return dataBm}

    class func createBitmap(width: Int, height: Int, type: Int) -> Bitmap {
        let rect = CGSize(width: CGFloat(width), height: CGFloat(height))
        let img = Bitmap.imageWithSize(size: rect)
        return Bitmap(img)
    }

    class func createBitmap(bitmap: Bitmap, xPos: Int, yPos: Int, width: Int, height: Int) -> Bitmap {
        let img = UIImage(cgImage: bitmap.image.cgImage!)
        let rect = CGRect(x: CGFloat(xPos), y: CGFloat(yPos), width: CGFloat(width), height: CGFloat(height))
        let imageRef: CGImage = img.cgImage!.cropping(to: rect)!
        return Bitmap(UIImage(cgImage: imageRef))
    }

    var width: CGFloat {
        return image.size.width
    }

    var height: CGFloat {
        return image.size.height
    }

    var isValid: Bool {
        return width > 10
    }

    class Config {static let ARGB8888 = 0}

    class func imageWithSize(size: CGSize,
                             filledWithColor color: UIColor = UIColor.clear,
                             scale: CGFloat = 0.0,
                             opaque: Bool = false) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let rendererFormat = UIGraphicsImageRendererFormat()
        rendererFormat.opaque = opaque
        rendererFormat.scale = scale
        let renderer = UIGraphicsImageRenderer(size: size, format: rendererFormat)
        let newImage: UIImage = renderer.image { _ in
            color.set()
            UIRectFill(rect)
        }
        return newImage
    }

    class func resize(image: UIImage, ratio: Float) -> Bitmap {
        let originalSize = image.size
        //let widthRatio = targetSize.width / originalSize.width
        //let heightRatio = targetSize.height / originalSize.height
        //let ratio = min(widthRatio, heightRatio)
        let newSize = CGSize(width: originalSize.width * CGFloat(ratio), height: originalSize.height * CGFloat(ratio))
        // preparing rect for new image size
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Bitmap(newImage!)
    }
}
