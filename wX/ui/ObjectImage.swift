/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectImage {

    let img = UIImageView()
    var width: CGFloat = 0.0
    var bitmap = Bitmap()

    init() {
        img.contentMode = UIView.ContentMode.scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        img.isUserInteractionEnabled = true
    }

    convenience init(_ stackView: UIStackView, _ bitmap: Bitmap) {
        self.init()
        img.image = UIImage(data: bitmap.data) ?? UIImage()
        self.bitmap = bitmap
        setImageAnchors(UIScreen.main.bounds.width)
        stackView.addArrangedSubview(img)
        // TODO replace with utilityui
        width = UIScreen.main.bounds.width
    }

    convenience init(_ stackView: UIStackView, _ bitmap: Bitmap, hs: Bool) {
        self.init()
        img.image = bitmap.image
        self.bitmap = bitmap
        setImageAnchors(UIScreen.main.bounds.width - UIPreferences.stackviewCardSpacing * 2.0)
        stackView.addArrangedSubview(img)
        width = UIScreen.main.bounds.width
    }

    convenience init(_ stackView: UIStackView, _ bitmap: Bitmap, viewOrder: Int) {
        self.init()
        img.image = UIImage(data: bitmap.data) ?? UIImage()
        self.bitmap = bitmap
        setImageAnchors(UIScreen.main.bounds.width)
        stackView.insertArrangedSubview(img, at: viewOrder)
        width = UIScreen.main.bounds.width
    }

    convenience init(_ stackView: UIStackView) {
        self.init()
        stackView.addArrangedSubview(img)
        width = UIScreen.main.bounds.width
    }

    func setBitmap(_ bitmap: Bitmap) {
        self.bitmap = bitmap
        img.image = UIImage(data: bitmap.data) ?? UIImage()
        setImageAnchors(width)
    }

    func addGestureRecognizer(_ gesture: UITapGestureRecognizer) {
        img.addGestureRecognizer(gesture)
    }

    func setImageAnchors(_ width: CGFloat) {
        img.widthAnchor.constraint(equalToConstant: width).isActive = true
        img.heightAnchor.constraint(equalToConstant: width * (bitmap.height / bitmap.width)).isActive = true
    }
}
