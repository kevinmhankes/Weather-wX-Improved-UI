/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class Drawable {

    private var color = 0
	private var bitmap: Bitmap?
    var img = UIImage()

    convenience init(_ bitmap: Bitmap) {
        self.init()
        self.bitmap = bitmap
        img = UIImage(data: bitmap.data) ?? UIImage()
    }

	convenience init(_ color: Int) {
        self.init()
		self.color = color
		self.bitmap = nil
        img = UIImage()
	}
}
