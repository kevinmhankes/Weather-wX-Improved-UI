/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardImage {

    private let uiImageView = UIImageView()

    init(sizeFactor: CGFloat = 1.0) {
        let size = CGFloat(UIPreferences.nwsIconSize)
        uiImageView.isUserInteractionEnabled = true
        uiImageView.contentMode = UIView.ContentMode.scaleAspectFit
        uiImageView.translatesAutoresizingMaskIntoConstraints = false
        uiImageView.widthAnchor.constraint(equalToConstant: size * sizeFactor).isActive = true
        uiImageView.heightAnchor.constraint(equalToConstant: size * sizeFactor).isActive = true
    }
    
    func setBitmap(_ bitmap: Bitmap) {
        uiImageView.image = bitmap.image
    }
    
    func setImage(_ image: UIImage) {
        uiImageView.image = image
    }

    var view: UIImageView { uiImageView }
}
