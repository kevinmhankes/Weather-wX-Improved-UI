/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityImgAnim {

    static func getUrlArray (_ url: String, _ pattern: String, _ frameCount: Int) -> [String] {
        let html = url.getHtml()
        let frames = html.parseColumn(pattern)
        if frames.count > frameCount {
            return ((frames.count - frameCount)..<frames.count).map { frames[$0] }
        } else {
            return frames.indices.map { frames[$0] }
        }
    }

    static func getAnimationDrawableFromUrlList(_ urls: [String]) -> AnimationDrawable {
        let bitmaps = urls.map { Bitmap($0) }
        return getAnimationDrawableFromBitmapList(bitmaps)
    }

    static func getAnimationDrawableFromBitmapList(_ bitmaps: [Bitmap]) -> AnimationDrawable {
        let animDrawable = AnimationDrawable()
        bitmaps.filter { $0.isValid }.forEach { animDrawable.addFrame($0) }
        return animDrawable
    }
}
