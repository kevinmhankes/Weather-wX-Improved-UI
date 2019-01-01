/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerGOES16: UIwXViewController {

    var image = ObjectTouchImageView()
    var productButton = ObjectToolbarIcon()
    var sectorButton = ObjectToolbarIcon()
    var animateButton = ObjectToolbarIcon()
    var productCode = ""
    var sectorCode = ""
    var savePrefs = true
    var firstRun = true

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        productButton = ObjectToolbarIcon(self, #selector(productClicked))
        sectorButton = ObjectToolbarIcon(self, #selector(sectorClicked))
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        animateButton = ObjectToolbarIcon(self, .play, #selector(animateClicked))
        toolbar.items = ObjectToolbarItems([
            doneButton,
            flexBarButton,
            sectorButton,
            productButton,
            animateButton,
            shareButton
        ]).items
        image = ObjectTouchImageView(self, toolbar, #selector(handleSwipes(sender:)))
        image.setMaxScaleFromMinScale(10.0)
        image.setKZoomInFactorFromMinWhenDoubleTap(8.0)
        self.view.addSubview(toolbar)
        deSerializeSettings()
        self.getContent()
    }

    @objc func willEnterForeground() {
        self.getContent()
    }

    func serializeSettings() {
        if savePrefs {
            editor.putString("GOES16_PROD", productCode)
            editor.putString("GOES16_SECTOR", sectorCode)
        }
    }

    func deSerializeSettings() {
        if ActVars.goesSector == "" {
            productCode = preferences.getString("GOES16_PROD", "GEOCOLOR")
            sectorCode = preferences.getString("GOES16_SECTOR", "cgl")
            productButton.title = productCode
            sectorButton.title = sectorCode
        } else {
            productCode = ActVars.goesProduct
            sectorCode = ActVars.goesSector
            productButton.title = productCode
            sectorButton.title = sectorCode
            savePrefs = false
        }
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            let bitmap = UtilityGOES16.getImage(self.productCode, self.sectorCode)
            self.serializeSettings()
            DispatchQueue.main.async {
                self.image.setBitmap(bitmap)
                if self.firstRun {
                    self.firstRun = false
                }
            }
        }
    }

    @objc override func doneClicked() {
        super.doneClicked()
    }

    @objc func productClicked() {
        let list: [String] = [String] (UtilityGOES16.products.keys.sorted())
        _ = ObjectPopUp(self, "Product Selection", productButton, list, self.productChanged(_:))
    }

    @objc func sectorClicked() {
        _ = ObjectPopUp(self, "Sector Selection", productButton, UtilityGOES16.sectors, self.sectorChanged(_:))
    }

    func productChanged(_ index: Int) {
        productCode = UtilityGOES16.productCodes[index]
        productButton.title = productCode
        self.getContent()
    }

    func sectorChanged(_ sector: String) {
        sectorCode = sector
        sectorButton.title = sector
        self.getContent()
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, image.bitmap)
    }

    @objc func handleSwipes(sender: UISwipeGestureRecognizer) {
        productChanged(
            UtilityUI.sideSwipe(
                sender,
                UtilityGOES16.productCodes.index(of: productCode)!,
                UtilityGOES16.productCodes
            )
        )
    }

    @objc func animateClicked() {
        _ = ObjectPopUp(
            self,
            "Select number of animation frames:",
            animateButton,
            stride(from: 24, to: 96 + 12, by: 12),
            self.getAnimation(_:)
        )
    }

    @objc func getAnimation(_ frameCount: Int) {
        DispatchQueue.global(qos: .userInitiated).async {
            let animDrawable = UtilityGOES16.getAnimation(self.productCode, self.sectorCode, frameCount)
            DispatchQueue.main.async {
                self.image.startAnimating(animDrawable)
            }
        }
    }
}
