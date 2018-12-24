/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardImage {

    private let image = UIImageView()

    init() {
        image.isUserInteractionEnabled = true
        image.contentMode = UIView.ContentMode.scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        image.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }

    var view: UIImageView {
        return image
    }
}
