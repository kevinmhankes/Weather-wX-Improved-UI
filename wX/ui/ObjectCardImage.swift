/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardImage {

    private let image = UIImageView()
    var size: CGFloat = 80.0

    init(sizeFactor: CGFloat = 1.0) {
        size = CGFloat(UIPreferences.nwsIconSize)
        image.isUserInteractionEnabled = true
        image.contentMode = UIView.ContentMode.scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        image.widthAnchor.constraint(equalToConstant: size * sizeFactor).isActive = true
    }

    var view: UIImageView {
        return image
    }
}
