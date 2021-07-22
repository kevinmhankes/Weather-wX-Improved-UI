/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityImgAnim {

    static func getAnimationDrawableFromBitmapList(_ bitmaps: [Bitmap]) -> AnimationDrawable {
        let animDrawable = AnimationDrawable()
        bitmaps.filter { $0.isValid }.forEach { animDrawable.addFrame($0) }
        return animDrawable
    }
}
