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
        self.view.addSubview(toolbar)
        image = ObjectTouchImageView(self, toolbar)
        image.addGestureRecognizer(#selector(handleSwipes(sender:)))
        index = preferences.getInt("GOESFULLDISK_IMG_FAV_URL", index)
        self.getContent()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            let bitmap = Bitmap(UtilityNWSGOESFullDisk.URLS[self.index])
            DispatchQueue.main.async {
                self.image.setBitmap(bitmap)
                self.productButton.title = UtilityNWSGOESFullDisk.LABELS[self.index]
                if UtilityNWSGOESFullDisk.URLS[self.index].contains("jma") {
                    self.showAnimateButton()
                } else {
                    self.hideAnimateButton()
                }
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
        let alert = ObjectPopUp(self, "Product Selection", productButton)
        UtilityNWSGOESFullDisk.LABELS.enumerated().forEach { index, rid in
            alert.addAction(UIAlertAction(title: rid, style: .default, handler: {_ in self.productChanged(index)}))
        }
        alert.finish()
    }

    func productChanged(_ prod: Int) {
        self.index = prod
        self.getContent()
    }

    @objc func shareClicked(sender: UIButton) {UtilityShare.shareImage(self, sender, image.bitmap)}

    @objc func handleSwipes(sender: UISwipeGestureRecognizer) {
        index = UtilityUI.sideSwipe(sender, index, UtilityNWSGOESFullDisk.URLS)
        getContent()
    }

    @objc func getAnimation() {
        DispatchQueue.global(qos: .userInitiated).async {
            let animDrawable = UtilityNWSGOESFullDisk.getAnimation(url: UtilityNWSGOESFullDisk.URLS[self.index])
            DispatchQueue.main.async {
                self.image.startAnimating(animDrawable)
            }
        }
    }
}
