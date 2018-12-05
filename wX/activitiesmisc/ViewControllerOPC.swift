/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerOPC: UIwXViewController {

    var image = ObjectTouchImageView()
    var productButton = ObjectToolbarIcon()
    var index = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        productButton = ObjectToolbarIcon(self, #selector(productClicked))
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, productButton, shareButton]).items
        self.view.addSubview(toolbar)
        image = ObjectTouchImageView(self, toolbar)
        image.addGestureRecognizer(#selector(handleSwipes(sender:)))
        index = preferences.getInt("OPC_IMG_FAV_URL", index)
        self.getContent()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            let bitmap = Bitmap(UtilityOPCImages.urls[self.index])
            DispatchQueue.main.async {
                self.image.setBitmap(bitmap)
                self.productButton.title = UtilityOPCImages.labels[self.index]
                editor.putInt("OPC_IMG_FAV_URL", self.index)
            }
        }
    }

    @objc func productClicked() {
        let alert = ObjectPopUp(self, "Product Selection", productButton)
        UtilityOPCImages.labels.enumerated().forEach { index, rid in
            alert.addAction(UIAlertAction(title: rid, style: .default, handler: {_ in self.productChanged(index)}))
        }
        alert.finish()
    }

    func productChanged(_ index: Int) {
        self.index = index
        self.getContent()
    }

    @objc func shareClicked(sender: UIButton) {UtilityShare.shareImage(self, sender, image.bitmap)}

    @objc func handleSwipes(sender: UISwipeGestureRecognizer) {
        index = UtilityUI.sideSwipe(sender, index, UtilityOPCImages.urls)
        getContent()
    }
}
