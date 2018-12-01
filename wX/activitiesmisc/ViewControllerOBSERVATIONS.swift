/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerOBSERVATIONS: UIwXViewController {

    var image = ObjectTouchImageView()
    var productButton = ObjectToolbarIcon()
    var index = 0
    var url = ""
    let prefToken = "SFC_OBS_IMG"
    let prefTokenIdx = "SFC_OBS_IMG_IDX"

    override func viewDidLoad() {
        super.viewDidLoad()
        productButton = ObjectToolbarIcon(self, #selector(productClicked))
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, productButton, shareButton]).items
        self.view.addSubview(toolbar)
        image = ObjectTouchImageView(self, toolbar)
        image.addGestureRecognizer(#selector(handleSwipes(sender:)))
        image.setMaxScaleFromMinScale(10.0)
        image.setKZoomInFactorFromMinWhenDoubleTap(8.0)
        self.url = preferences.getString(prefToken, UtilityObservations.URLS[0])
        self.index = preferences.getInt(prefTokenIdx, 0)
        self.getContent()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            let bitmap = Bitmap(self.url)
            DispatchQueue.main.async {
                self.image.setBitmap(bitmap)
                self.productButton.title = UtilityObservations.NAMES[self.index]
                editor.putString(self.prefToken, self.url)
                editor.putInt(self.prefTokenIdx, self.index)
            }
        }
    }

    @objc func productClicked() {
        let alert = ObjectPopUp(self, "Product Selection", productButton)
        UtilityObservations.NAMES.enumerated().forEach { index, rid in
            alert.addAction(UIAlertAction(title: rid, style: .default, handler: {_ in self.productChanged(index)}))
        }
        alert.finish()
    }

    func productChanged(_ index: Int) {
        self.index = index
        self.url = UtilityObservations.URLS[index]
        self.getContent()
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, image.bitmap)
    }

    @objc func handleSwipes(sender: UISwipeGestureRecognizer) {
        index = UtilityUI.sideSwipe(sender, index, UtilityObservations.URLS)
        self.url = UtilityObservations.URLS[index]
        getContent()
    }
}
