/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

final class UtilityImgAnim {

    static func getUrlArray (_ url: String, _ pattern: String, _ cnt: String) -> [String] {
        let html = url.getHtml()
        let frames = html.parseColumn(pattern)
        let frameCnt = Int(cnt) ?? 0
        if frames.count>frameCnt {
            return ((frames.count-frameCnt)..<frames.count).map {frames[$0]}
        } else {
            return frames.indices.map {frames[$0]}
        }
    }

    static func getAnimationDrawableFromUrlList(_ urls: [String], _ delay: Int) -> AnimationDrawable {
        let animDrawable = AnimationDrawable()
        let bitmaps = urls.map {Bitmap($0)}
        bitmaps.filter {$0.isValid}.forEach {animDrawable.addFrame(Drawable($0), delay)}
        return animDrawable
    }

    static func getAnimationDrawableFromBitmapList(_ bitmaps: [Bitmap], _ delay: Int) -> AnimationDrawable {
        let animDrawable = AnimationDrawable()
        bitmaps.filter {$0.isValid}.forEach {animDrawable.addFrame(Drawable($0), delay)}
        return animDrawable
    }

    static func getAnimationDrawableFromBitmapList(_ bitmaps: [Bitmap]) -> AnimationDrawable {
        return getAnimationDrawableFromBitmapList(bitmaps, UtilityImg.getAnimInterval() * 2)
    }
}
