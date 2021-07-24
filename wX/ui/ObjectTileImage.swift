/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectTileImage {

    private var image = ObjectImage()

    init(_ stackView: ObjectStackView, _ filename: String, _ index: Int, _ iconsPerRow: CGFloat, _ accessibilityLabel: String) {
        let bitmap = Bitmap.fromFile(filename)
        image.img.tag = index
        image.setBitmap(bitmap)
        image.img.isAccessibilityElement = true
        image.img.accessibilityLabel = accessibilityLabel
        stackView.addWidget(image.img)
        image.img.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1 / iconsPerRow).isActive = true
        image.img.heightAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1 / iconsPerRow).isActive = true
    }
    
    init(_ stackView: ObjectStackView, _ iconsPerRow: CGFloat) {
        stackView.addWidget(image.img)
        image.img.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1 / iconsPerRow).isActive = true
        image.img.heightAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1 / iconsPerRow).isActive = true
    }

    func addGesture(_ gesture: UITapGestureRecognizer) {
        image.addGestureRecognizer(gesture)
    }
}
