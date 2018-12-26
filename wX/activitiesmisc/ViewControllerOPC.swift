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
    let prefToken = "OPC_IMG_FAV_URL"

    override func viewDidLoad() {
        super.viewDidLoad()
        productButton = ObjectToolbarIcon(self, #selector(productClicked))
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, productButton, shareButton]).items
        self.view.addSubview(toolbar)
        image = ObjectTouchImageView(self, toolbar, #selector(handleSwipes(sender:)))
        index = preferences.getInt(prefToken, index)
        self.getContent(index)
    }

    func getContent(_ index: Int) {
        self.index = index
        self.productButton.title = UtilityOPCImages.labels[self.index]
        DispatchQueue.global(qos: .userInitiated).async {
            let bitmap = Bitmap(UtilityOPCImages.urls[self.index])
            DispatchQueue.main.async {
                self.image.setBitmap(bitmap)
                editor.putInt(self.prefToken, self.index)
            }
        }
    }

    @objc func productClicked() {
        _ = ObjectPopUp(self, "Product Selection", productButton, UtilityOPCImages.labels, self.getContent(_:))
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, image.bitmap)
    }

    @objc func handleSwipes(sender: UISwipeGestureRecognizer) {
        getContent(UtilityUI.sideSwipe(sender, index, UtilityOPCImages.urls))
    }
}
