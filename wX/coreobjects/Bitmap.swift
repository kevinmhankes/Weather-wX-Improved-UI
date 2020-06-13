/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class Bitmap {

    let dataBm: Data
    var image: UIImage
    var url = ""
    var info = "" // used in GOES viewer to store additional info

    init() {
        self.image = Bitmap.imageWithSize(
            size: CGSize(width: 86, height: 86),
            filledWithColor: UIColor.white,
            scale: 1.0,
            opaque: false
        )
        self.dataBm = self.image.pngData()!
    }

    init(_ bm: Data) {
        self.dataBm = bm
        if let imgTmp = UIImage(data: self.dataBm) {
            self.image = imgTmp
        } else {
            self.image = Bitmap.imageWithSize(
                size: CGSize(width: 3, height: 3),
                filledWithColor: UIColor.white,
                scale: 1.0,
                opaque: false
            )
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
        if let data = image.pngData() {
            self.dataBm = data
        } else {
            self.image = Bitmap.imageWithSize(
                size: CGSize(width: 86, height: 86),
                filledWithColor: UIColor.white,
                scale: 1.0,
                opaque: false
            )
            self.dataBm = self.image.pngData()!
        }
    }

    var data: Data { dataBm }

    var width: CGFloat { image.size.width }

    var height: CGFloat { image.size.height }

    var isValid: Bool { width > 10 }

    var isValidForNhc: Bool { width > 100 }

    static func imageWithSize(
        size: CGSize,
        filledWithColor color: UIColor = UIColor.clear,
        scale: CGFloat = 0.0,
        opaque: Bool = false
    ) -> UIImage {
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

    static func fromFile(_ filename: String) -> Bitmap { UtilityIO.readBitmapResourceFromFile(filename) }
}
