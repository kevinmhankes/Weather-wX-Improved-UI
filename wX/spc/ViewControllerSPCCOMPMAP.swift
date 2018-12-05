/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerSPCCOMPMAP: UIwXViewController {

    var image = ObjectTouchImageView()
    var productButton = ObjectToolbarIcon()
    var layers: Set = ["1"]

    override func viewDidLoad() {
        super.viewDidLoad()
        productButton = ObjectToolbarIcon(title: "Layers", self, #selector(productClicked))
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, productButton, shareButton]).items
        image = ObjectTouchImageView(self, toolbar)
        self.view.addSubview(toolbar)
        deSerializeSettings()
        self.getContent()
    }

    func serializeSettings() {editor.putString("SPCCOMPMAP_LAYERSTRIOS", TextUtils.join(":", layers))}

    func deSerializeSettings() {
        layers = Set(TextUtils.split(preferences.getString("SPCCOMPMAP_LAYERSTRIOS", "7:19:"), ":"))
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            let bitmap = UtilitySPCCompmap.getImage(self.layers)
            DispatchQueue.main.async {
                self.image.setBitmap(bitmap)
                self.serializeSettings()
            }
        }
    }

    @objc func productClicked() {
        let alert = ObjectPopUp(self, "Layer Selection", productButton)
        (["Clear All"] + UtilitySPCCompmap.labels).enumerated().forEach { index, rid in
            var pre = ""
            if index > 0 && layers.contains(UtilitySPCCompmap.urlIndices[UtilitySPCCompmap.labels.index(of: rid)!]) {
                pre = "(on) "
            }
            alert.addAction(UIAlertAction(title: pre + rid, style: .default, handler: {_ in
                self.productChanged(index)}))
        }
        alert.finish()
    }

    func productChanged(_ product: Int) {
        if product==0 {
            layers = []
            self.getContent()
            return
        }
        let prodLocal = product - 1
        if layers.contains(UtilitySPCCompmap.urlIndices[prodLocal]) {
            layers.remove(UtilitySPCCompmap.urlIndices[prodLocal])
        } else {
            layers.insert(UtilitySPCCompmap.urlIndices[prodLocal])
        }
        self.getContent()
    }

    @objc func shareClicked(sender: UIButton) {UtilityShare.shareImage(self, sender, image.bitmap)}
}
