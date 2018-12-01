/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class UtilitySPCSoundings {

	static func getImage(_ nwsOffice: String) -> Bitmap {
        return UtilityImg.getBitmapAddWhiteBG(MyApplication.nwsSPCwebsitePrefix
            + "/exper/soundings/LATEST/" + nwsOffice + ".gif")
	}
}
