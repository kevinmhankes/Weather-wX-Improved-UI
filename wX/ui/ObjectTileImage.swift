/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectTileImage {

    private var image = ObjectImage()

    init(_ stackView: UIStackView, _ filename: String, _ index: Int, _ iconsPerRow: CGFloat, _ accessibilityLabel: String) {
        let bitmap = Bitmap.fromFile(filename)
        image.img.tag = index
        image.setBitmap(bitmap)
        image.img.isAccessibilityElement = true
        image.img.accessibilityLabel = accessibilityLabel
        stackView.addArrangedSubview(image.img)
        image.img.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1 / iconsPerRow).isActive = true
        image.img.heightAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1 / iconsPerRow).isActive = true

    }
    
    init(_ stackView: UIStackView, _ iconsPerRow: CGFloat) {
        stackView.addArrangedSubview(image.img)
        image.img.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1 / iconsPerRow).isActive = true
        image.img.heightAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1 / iconsPerRow).isActive = true
    }

    func addGestureRecognizer(_ gesture: UITapGestureRecognizer) {
        image.addGestureRecognizer(gesture)
    }
}
