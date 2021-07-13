/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class vcRadarMosaicAwc: UIwXViewController {

    private var image = ObjectTouchImageView()
    private var productButton = ToolbarIcon()
    private var sectorButton = ToolbarIcon()
    private var animateButton = ToolbarIcon()
    private var index = 0
    private var product = "rad_rala"
    private let prefTokenSector = "AWCMOSAIC_SECTOR_LAST_USED"
    private let prefTokenProduct = "AWCMOSAIC_PRODUCT_LAST_USED"
    private var sector = "us"
    private var isLocal = false
    var nwsMosaicType = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        productButton = ToolbarIcon(self, #selector(productClicked))
        sectorButton = ToolbarIcon(self, #selector(sectorClicked))
        animateButton = ToolbarIcon(self, .play, #selector(getAnimation))
        let shareButton = ToolbarIcon(self, .share, #selector(share))
        toolbar.items = ToolbarItems([doneButton, GlobalVariables.flexBarButton, productButton, sectorButton, animateButton, shareButton]).items
        image = ObjectTouchImageView(self, toolbar)
        sector = Utility.readPref(prefTokenSector, sector)
        product = Utility.readPref(prefTokenProduct, product)
        if nwsMosaicType == "local" {
            nwsMosaicType = ""
            isLocal = true
            sector = UtilityAwcRadarMosaic.getNearestMosaic(Location.latLon)
        }
        getContent()
    }

    override func getContent() {
        productButton.title = product
        sectorButton.title = sector
//        DispatchQueue.global(qos: .userInitiated).async {
//            let bitmap = UtilityAwcRadarMosaic.get(self.sector, self.product)
//            DispatchQueue.main.async { self.display(bitmap) }
//        }
        _ = FutureBytes(UtilityAwcRadarMosaic.get(self.sector, self.product), self.display)
    }

    private func display(_ bitmap: Bitmap) {
        image.setBitmap(bitmap)
        if !isLocal {
            Utility.writePref(prefTokenSector, sector)
            Utility.writePref(prefTokenProduct, product)
        }
    }

    @objc func sectorClicked() {
        _ = ObjectPopUp(self, title: "Sector Selection", sectorButton, UtilityAwcRadarMosaic.sectorLabels, sectorChanged(_:))
    }

    @objc func productClicked() {
        _ = ObjectPopUp(self, productButton, UtilityAwcRadarMosaic.productLabels, productChanged(_:))
    }

    func productChanged(_ index: Int) {
        product = UtilityAwcRadarMosaic.products[index]
        getContent()
    }

    func sectorChanged(_ index: Int) {
        sector = UtilityAwcRadarMosaic.sectors[index]
        getContent()
    }

    @objc func share(sender: UIButton) {
        UtilityShare.image(self, sender, image.bitmap)
    }

    @objc func getAnimation() {
        DispatchQueue.global(qos: .userInitiated).async {
            let animDrawable = UtilityAwcRadarMosaic.getAnimation(self.sector, self.product)
            DispatchQueue.main.async { self.image.startAnimating(animDrawable) }
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { _ -> Void in self.image.refresh() })
    }
}
