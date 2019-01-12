/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectTileImage {

    private var imgL = UIImageView()

    init(_ stackView: UIStackView, _ sV: UIStackView, _ filename: String, _ index: Int, _ iconsPerRow: CGFloat) {
        let bitmap = UtilityIO.readBitmapResourceFromFile(filename)
        imgL.contentMode = UIView.ContentMode.scaleAspectFit
        imgL.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(imgL)
        imgL.tag = index
        imgL.isUserInteractionEnabled = true
        imgL.image = UIImage(data: bitmap.data) ?? UIImage()
        let width = (UIScreen.main.bounds.width - 4.0 - UIPreferences.stackviewCardSpacing * iconsPerRow) / iconsPerRow
        imgL.widthAnchor.constraint(equalToConstant: width).isActive = true
        imgL.heightAnchor.constraint(equalToConstant: width * (bitmap.height/bitmap.width)).isActive = true
        sV.addArrangedSubview(imgL)
    }

    func addGestureRecognizer(_ gesture: UITapGestureRecognizer) {
        imgL.addGestureRecognizer(gesture)
    }
}
