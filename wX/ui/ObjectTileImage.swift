/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectTileImage {

    private var image = ObjectImage()

    init(_ stackView: UIStackView, _ sV: UIStackView, _ filename: String, _ index: Int, _ iconsPerRow: CGFloat) {
        let bitmap = UtilityIO.readBitmapResourceFromFile(filename)
        stackView.addArrangedSubview(image.img)
        let (width, _) = UtilityUI.getScreenBoundsCGFloat()
        image.img.tag = index
        image.width = (width - 4.0 - UIPreferences.stackviewCardSpacing * iconsPerRow) / iconsPerRow
        image.setBitmap(bitmap)
        sV.addArrangedSubview(image.img)
    }

    func addGestureRecognizer(_ gesture: UITapGestureRecognizer) {
        image.addGestureRecognizer(gesture)
    }
}
