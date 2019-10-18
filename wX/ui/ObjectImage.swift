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
        (width, _) = UtilityUI.getScreenBoundsCGFloat()
    }

    convenience init(_ stackView: UIStackView, _ bitmap: Bitmap, widthDivider: Int = 1) {
        self.init()
        img.image = UIImage(data: bitmap.data) ?? UIImage()
        self.bitmap = bitmap
        setImageAnchors(width / CGFloat(widthDivider) - UIPreferences.stackviewCardSpacing)
        stackView.addArrangedSubview(img)
    }

    convenience init(
        _ stackView: UIStackView,
        _ bitmap: Bitmap,
        _ gesture: UITapGestureRecognizer,
        widthDivider: Int = 1
    ) {
        self.init(stackView, bitmap, widthDivider: widthDivider)
        addGestureRecognizer(gesture)
    }

    convenience init(_ stackView: UIStackView, _ bitmap: Bitmap, hs: Bool) {
        self.init()
        img.image = bitmap.image
        self.bitmap = bitmap
        setImageAnchors(width - UIPreferences.stackviewCardSpacing * 2.0)
        stackView.addArrangedSubview(img)
    }

    convenience init(_ stackView: UIStackView, _ bitmap: Bitmap, viewOrder: Int) {
        self.init()
        img.image = UIImage(data: bitmap.data) ?? UIImage()
        self.bitmap = bitmap
        setImageAnchors(width)
        stackView.insertArrangedSubview(img, at: viewOrder)
    }

    convenience init(_ stackView: UIStackView) {
        self.init()
        stackView.addArrangedSubview(img)
    }

    func setBitmap(_ bitmap: Bitmap) {
        self.bitmap = bitmap
        img.image = UIImage(data: bitmap.data) ?? UIImage()
        setImageAnchors(width)
    }

    func addGestureRecognizer(_ gesture: UITapGestureRecognizer) {
        img.addGestureRecognizer(gesture)
    }

    private func setImageAnchors(_ width: CGFloat) {
        img.widthAnchor.constraint(equalToConstant: width).isActive = true
        img.heightAnchor.constraint(equalToConstant: width * (bitmap.height / bitmap.width)).isActive = true
    }
}
