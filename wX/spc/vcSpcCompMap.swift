/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class vcSpcCompMap: UIwXViewController {
    
    private var image = ObjectTouchImageView()
    private var productButton = ObjectToolbarIcon()
    private var layers: Set = ["1"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productButton = ObjectToolbarIcon(title: "Layers", self, #selector(productClicked))
        let shareButton = ObjectToolbarIcon(self, .share, #selector(share))
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, productButton, shareButton]).items
        image = ObjectTouchImageView(self, toolbar)
        deSerializeSettings()
        getContent()
    }

    func serializeSettings() {
        Utility.writePref("SPCCOMPMAP_LAYERSTRIOS", TextUtils.join(":", layers))
    }
    
    func deSerializeSettings() {
        layers = Set(TextUtils.split(Utility.readPref("SPCCOMPMAP_LAYERSTRIOS", "7:19:"), ":"))
    }
    
    override func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            let bitmap = UtilitySpcCompmap.getImage(self.layers)
            DispatchQueue.main.async { self.display(bitmap) }
        }
    }
    
    private func display(_ bitmap: Bitmap) {
        image.setBitmap(bitmap)
        serializeSettings()
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
        coordinator.animate(alongsideTransition: nil, completion: { _ -> Void in self.image.refresh() })
    }
}
