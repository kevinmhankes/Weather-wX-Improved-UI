/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerAwcRadarMosaic: UIwXViewController {

    var image = ObjectTouchImageView()
    var productButton = ObjectToolbarIcon()
    var animateButton = ObjectToolbarIcon()
    var index = 0
    let prefToken = "AWCMOSAIC_PARAM_LAST_USED"

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
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, productButton, animateButton, shareButton]).items
        self.view.addSubview(toolbar)
        image = ObjectTouchImageView(self, toolbar, #selector(handleSwipes(sender:)))
        index = Utility.readPref(prefToken, index)
        self.getContent(index)
    }

    func getContent(_ index: Int) {
        self.index = index
        self.productButton.title = UtilityAwcRadarMosaic.labels[self.index]
        DispatchQueue.global(qos: .userInitiated).async {
            let bitmap = UtilityAwcRadarMosaic.get(UtilityAwcRadarMosaic.sectors[self.index])
            DispatchQueue.main.async {
                self.image.setBitmap(bitmap)
                Utility.writePref(self.prefToken, self.index)
            }
        }
    }

    @objc func willEnterForeground() {
        self.getContent(self.index)
    }

    @objc func productClicked() {
        _ = ObjectPopUp(
            self,
            "Product Selection",
            productButton,
            UtilityAwcRadarMosaic.labels,
            self.getContent(_:)
        )
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, image.bitmap)
    }

    /*@objc func animateClicked() {
        _ = ObjectPopUp(
            self,
            "Select number of animation frames:",
            animateButton,
            [5, 10, 20, 30],
            self.getAnimation(_:)
        )
    }*/

    @objc func getAnimation() {
        DispatchQueue.global(qos: .userInitiated).async {
            let animDrawable = UtilityAwcRadarMosaic.getAnimation(
                UtilityAwcRadarMosaic.sectors[self.index]
            )
            DispatchQueue.main.async {
                self.image.startAnimating(animDrawable)
            }
        }
    }

    @objc func handleSwipes(sender: UISwipeGestureRecognizer) {
        getContent(UtilityUI.sideSwipe(sender, index, UtilityAwcRadarMosaic.sectors))
    }
}
