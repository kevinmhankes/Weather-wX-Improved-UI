/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class vcRadarMosaicAwc: UIwXViewController {

    private var image = TouchImage()
    private var productButton = ToolbarIcon()
    private var sectorButton = ToolbarIcon()
    private var animateButton = ToolbarIcon()
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
        image = TouchImage(self, toolbar)
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
        animateButton.setImage(.play)
        productButton.title = product
        sectorButton.title = sector
        if !isLocal {
            Utility.writePref(prefTokenSector, sector)
            Utility.writePref(prefTokenProduct, product)
        }
        _ = FutureBytes(UtilityAwcRadarMosaic.get(sector, product), image.setBitmap)
    }

    @objc func sectorClicked() {
        _ = ObjectPopUp(self, title: "Sector Selection", sectorButton, UtilityAwcRadarMosaic.sectorLabels, sectorChanged)
    }

    @objc func productClicked() {
        _ = ObjectPopUp(self, productButton, UtilityAwcRadarMosaic.productLabels, productChanged)
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
        if !image.isAnimating() {
            animateButton.setImage(.stop)
            _ = FutureAnimation({ UtilityAwcRadarMosaic.getAnimation(self.sector, self.product) }, image.startAnimating)
        } else {
            image.stopAnimating()
            animateButton.setImage(.play)
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { _ in self.image.refresh() })
    }
}
