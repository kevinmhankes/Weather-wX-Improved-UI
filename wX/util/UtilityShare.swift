/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class UtilityShare {

    static func shareImage(_ uiv: UIViewController, _ sender: UIButton, _ bitmap: Bitmap) {
        let objectsToShare = [bitmap.image]
        shareAction(uiv, sender, objectsToShare)
    }

    static func shareImage(_ uiv: UIViewController, _ sender: UIButton, _ bitmaps: [Bitmap]) {
        let images = bitmaps.map {$0.image}
        let objectsToShare = images as [Any]
        shareAction(uiv, sender, objectsToShare)
    }

    static func shareImage(_ uiv: UIViewController, _ sender: UIButton, _ bitmaps: [Bitmap], _ text: String) {
        let images = bitmaps.map {$0.image}
        let objectsToShare = [images, text] as [Any]
        shareAction(uiv, sender, objectsToShare)
    }

    static func share(_ uiv: UIViewController, _ sender: UIButton, _ text: String) {
        let objectsToShare = [text]
        shareAction(uiv, sender, objectsToShare)
    }

    static func shareAction(_ uiv: UIViewController, _ sender: UIButton, _ objectsToShare: [Any]) {
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        //activityVC.setValue("Shared content from wXL23", forKey: "Subject")
        activityVC.popoverPresentationController?.sourceView = sender
        uiv.present(activityVC, animated: true, completion: nil)
    }
}
