/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcRadarMosaicAwc: UIwXViewController {

    var image = ObjectTouchImageView()
    var productButton = ObjectToolbarIcon()
    var sectorButton = ObjectToolbarIcon()
    var animateButton = ObjectToolbarIcon()
    var index = 0
    var product = "rad_rala"
    let prefTokenSector = "AWCMOSAIC_SECTOR_LAST_USED"
    let prefTokenProduct = "AWCMOSAIC_PRODUCT_LAST_USED"
    var sector = "us"
    var isLocal = false

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
        animateButton = ObjectToolbarIcon(self, .play, #selector(getAnimation))
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems(
            [
                doneButton,
                GlobalVariables.flexBarButton,
                productButton,
                sectorButton,
                animateButton,
                shareButton
            ]
        ).items
        self.view.addSubview(toolbar)
        image = ObjectTouchImageView(self, toolbar)
        sector = Utility.readPref(prefTokenSector, sector)
        product = Utility.readPref(prefTokenProduct, product)
        if ActVars.nwsMosaicType == "local" {
            ActVars.nwsMosaicType = ""
            isLocal = true
            sector = UtilityAwcRadarMosaic.getNearestMosaic(Location.latLon)
        }
        self.getContent()
    }

    func getContent() {
        self.productButton.title = self.product
        self.sectorButton.title = self.sector
        DispatchQueue.global(qos: .userInitiated).async {
            let bitmap = UtilityAwcRadarMosaic.get(self.sector, self.product)
            DispatchQueue.main.async {
                self.image.setBitmap(bitmap)
                if !self.isLocal {
                    Utility.writePref(self.prefTokenSector, self.sector)
                    Utility.writePref(self.prefTokenProduct, self.product)
                }
            }
        }
    }

    @objc func willEnterForeground() {
        self.getContent()
    }

    @objc func sectorClicked() {
        _ = ObjectPopUp(
            self,
            "Sector Selection",
            sectorButton,
            UtilityAwcRadarMosaic.sectorLabels,
            self.sectorChanged(_:)
        )
    }

    @objc func productClicked() {
        _ = ObjectPopUp(
            self,
            "Product Selection",
            productButton,
            UtilityAwcRadarMosaic.productLabels,
            self.productChanged(_:)
        )
    }

    func productChanged(_ index: Int) {
        product = UtilityAwcRadarMosaic.products[index]
        productButton.title = product
        self.getContent()
    }

    func sectorChanged(_ index: Int) {
        sector = UtilityAwcRadarMosaic.sectors[index]
        sectorButton.title = sector
        self.getContent()
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, image.bitmap)
    }

    @objc func getAnimation() {
        DispatchQueue.global(qos: .userInitiated).async {
            let animDrawable = UtilityAwcRadarMosaic.getAnimation(
                self.sector,
                self.product
            )
            DispatchQueue.main.async {
                self.image.startAnimating(animDrawable)
            }
        }
    }
}
