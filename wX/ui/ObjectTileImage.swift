/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectTileImage {

    private var image = ObjectImage()

    init(
        _ stackView: UIStackView,
        _ filename: String,
        _ index: Int,
        _ iconsPerRow: CGFloat,
        _ accessibilityLabel: String
    ) {
        let bitmap = Bitmap.fromFile(filename)
        let (width, _) = UtilityUI.getScreenBoundsCGFloat()
        image.img.tag = index
        image.width = (width - 4.0 - UIPreferences.stackviewCardSpacing * iconsPerRow) / iconsPerRow
        image.setBitmap(bitmap)
        image.img.isAccessibilityElement = true
        image.img.accessibilityLabel = accessibilityLabel
        stackView.addArrangedSubview(image.img)
    }

    func addGestureRecognizer(_ gesture: UITapGestureRecognizer) {
        image.addGestureRecognizer(gesture)
    }
}
