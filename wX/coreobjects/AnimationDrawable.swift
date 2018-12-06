/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class AnimationDrawable {

    var imageArray = [UIImage]()
    private var delay = 3.0
    var animationDelay = Double(MyApplication.animInterval)

    init() {
        delay = animationDelay / 2.0
    }

    func addFrame(_ layer: Drawable, _ delay: Int) {
        imageArray.append(layer.img)
    }

    func addFrame(_ layer: UIImage, _ delay: Int) {
        imageArray.append(layer)
    }
}
