/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerGOESGLOBAL: UIwXViewController {

    var image = ObjectTouchImageView()
    var productButton = ObjectToolbarIcon()
    var index = 0
    var animateButton = ObjectToolbarIcon()
    var shareButton = ObjectToolbarIcon()
    let prefToken = "GOESFULLDISK_IMG_FAV_URL"

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        productButton = ObjectToolbarIcon(self, #selector(productClicked))
        animateButton = ObjectToolbarIcon(self, .play, #selector(getAnimation))
        shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, productButton, animateButton, shareButton]).items
        self.view.addSubview(toolbar)
        image = ObjectTouchImageView(self, toolbar, #selector(handleSwipes(sender:)))
        index = Utility.readPref(prefToken, index)
        self.getContent(index)
    }

    @objc func willEnterForeground() {
        self.getContent(index)
    }

    func getContent(_ index: Int) {
        self.index = index
        self.productButton.title = UtilityGoesFullDisk.labels[self.index]
        DispatchQueue.global(qos: .userInitiated).async {
            let bitmap = Bitmap(UtilityGoesFullDisk.urls[self.index])
            DispatchQueue.main.async {
                self.image.setBitmap(bitmap)
                if UtilityGoesFullDisk.urls[self.index].contains("jma") {
                    self.showAnimateButton()
                } else {
                    self.hideAnimateButton()
                }
                Utility.writePref(self.prefToken, self.index)
            }
        }
    }

    func showAnimateButton() {
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, productButton, animateButton, shareButton]).items
    }

    func hideAnimateButton() {
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, productButton, shareButton]).items
    }

    @objc func productClicked() {
        _ = ObjectPopUp(
            self,
            "Product Selection",
            productButton,
            UtilityGoesFullDisk.labels,
            self.getContent(_:)
        )
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, image.bitmap)
    }

    @objc func handleSwipes(sender: UISwipeGestureRecognizer) {
        getContent(UtilityUI.sideSwipe(sender, index, UtilityGoesFullDisk.urls))
    }

    @objc func getAnimation() {
        DispatchQueue.global(qos: .userInitiated).async {
            let animDrawable = UtilityGoesFullDisk.getAnimation(url: UtilityGoesFullDisk.urls[self.index])
            DispatchQueue.main.async {
                self.image.startAnimating(animDrawable)
            }
        }
    }
}
