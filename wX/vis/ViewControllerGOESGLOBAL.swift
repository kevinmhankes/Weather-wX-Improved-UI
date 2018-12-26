/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
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

    override func viewDidLoad() {
        super.viewDidLoad()
        productButton = ObjectToolbarIcon(self, #selector(productClicked))
        animateButton = ObjectToolbarIcon(self, .play, #selector(getAnimation))
        shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, productButton, animateButton, shareButton]).items
        // FIXME can addSubview for toolbar be added to parent VC?
        self.view.addSubview(toolbar)
        // FIXME can this instantiation occur up above?
        image = ObjectTouchImageView(self, toolbar, #selector(handleSwipes(sender:)))
        // FIXME can this instantiation occur up above?
        index = preferences.getInt("GOESFULLDISK_IMG_FAV_URL", index)
        self.getContent()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            let bitmap = Bitmap(UtilityNWSGOESFullDisk.urls[self.index])
            DispatchQueue.main.async {
                self.image.setBitmap(bitmap)
                self.productButton.title = UtilityNWSGOESFullDisk.labels[self.index]
                if UtilityNWSGOESFullDisk.urls[self.index].contains("jma") {
                    self.showAnimateButton()
                } else {
                    self.hideAnimateButton()
                }
                // FIXME this should be a variable
                editor.putInt("GOESFULLDISK_IMG_FAV_URL", self.index)
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
        _ = ObjectPopUp(self,
                        "Product Selection",
                        productButton,
                        UtilityNWSGOESFullDisk.labels,
                        self.productChanged(_:))
    }

    // FIXME getContent should take an index 
    func productChanged(_ prod: Int) {
        self.index = prod
        self.getContent()
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, image.bitmap)
    }

    @objc func handleSwipes(sender: UISwipeGestureRecognizer) {
        index = UtilityUI.sideSwipe(sender, index, UtilityNWSGOESFullDisk.urls)
        getContent()
    }

    @objc func getAnimation() {
        DispatchQueue.global(qos: .userInitiated).async {
            let animDrawable = UtilityNWSGOESFullDisk.getAnimation(url: UtilityNWSGOESFullDisk.urls[self.index])
            DispatchQueue.main.async {
                self.image.startAnimating(animDrawable)
            }
        }
    }
}
