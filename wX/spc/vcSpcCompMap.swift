// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class vcSpcCompMap: UIwXViewController {

    private var image = TouchImage()
    private var productButton = ToolbarIcon()
    private var layers: Set = ["1"]

    override func viewDidLoad() {
        super.viewDidLoad()
        productButton = ToolbarIcon(title: "Layers", self, #selector(productClicked))
        let shareButton = ToolbarIcon(self, .share, #selector(share))
        toolbar.items = ToolbarItems([doneButton, GlobalVariables.flexBarButton, productButton, shareButton]).items
        image = TouchImage(self, toolbar)
        layers = Set(TextUtils.split(Utility.readPref("SPCCOMPMAP_LAYERSTRIOS", "7:19:"), ":"))
        getContent()
    }

    override func getContent() {
        Utility.writePref("SPCCOMPMAP_LAYERSTRIOS", TextUtils.join(":", layers))
        _ = FutureBytes2({ UtilitySpcCompmap.getImage(self.layers) }, image.setBitmap)
    }

    @objc func productClicked() {
        let alert = ObjectPopUp(self, "Layer Selection", productButton)
        (["Clear All"] + UtilitySpcCompmap.labels).enumerated().forEach { index, rid in
            var pre = ""
            if index > 0 && layers.contains(UtilitySpcCompmap.urlIndices[UtilitySpcCompmap.labels.firstIndex(of: rid)!]) {
                pre = "(on) "
            }
            alert.addAction(UIAlertAction(pre + rid, { _ in self.productChanged(index) }))
        }
        alert.finish()
    }

    func productChanged(_ product: Int) {
        if product == 0 {
            layers = []
            getContent()
            return
        }
        let prodLocal = product - 1
        if layers.contains(UtilitySpcCompmap.urlIndices[prodLocal]) {
            layers.remove(UtilitySpcCompmap.urlIndices[prodLocal])
        } else {
            layers.insert(UtilitySpcCompmap.urlIndices[prodLocal])
        }
        getContent()
    }

    @objc func share(sender: UIButton) {
        UtilityShare.image(self, sender, image.bitmap)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { _ in self.image.refresh() })
    }
}
