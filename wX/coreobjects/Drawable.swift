/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class Drawable {

    // TODO what is this used for? can it be removed
    
	private var bitmap: Bitmap?
    var img = UIImage()

    convenience init(_ bitmap: Bitmap) {
        self.init()
        self.bitmap = bitmap
        img = UIImage(data: bitmap.data) ?? UIImage()
    }
}
