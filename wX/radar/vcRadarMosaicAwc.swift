/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcRadarMosaicAwc: UIwXViewController {
    
    private var image = ObjectTouchImageView()
    private var productButton = ObjectToolbarIcon()
    private var sectorButton = ObjectToolbarIcon()
    private var animateButton = ObjectToolbarIcon()
    private var index = 0
    private var product = "rad_rala"
    private let prefTokenSector = "AWCMOSAIC_SECTOR_LAST_USED"
    private let prefTokenProduct = "AWCMOSAIC_PRODUCT_LAST_USED"
    private var sector = "us"
    private var isLocal = false
    var nwsMosaicType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        image = ObjectTouchImageView(self, toolbar)
        sector = Utility.readPref(prefTokenSector, sector)
        product = Utility.readPref(prefTokenProduct, product)
        if nwsMosaicType == "local" {
            nwsMosaicType = ""
            isLocal = true
            sector = UtilityAwcRadarMosaic.getNearestMosaic(Location.latLon)
        }
        self.getContent()
    }
    
    override func getContent() {
        self.productButton.title = self.product
        self.sectorButton.title = self.sector
        DispatchQueue.global(qos: .userInitiated).async {
            let bitmap = UtilityAwcRadarMosaic.get(self.sector, self.product)
            DispatchQueue.main.async { self.displayContent(bitmap) }
        }
    }
    
    private func displayContent(_ bitmap: Bitmap) {
        self.image.setBitmap(bitmap)
        if !self.isLocal {
            Utility.writePref(self.prefTokenSector, self.sector)
            Utility.writePref(self.prefTokenProduct, self.product)
        }
    }
    
    @objc func sectorClicked() {
        _ = ObjectPopUp(
            self,
            title: "Sector Selection",
            sectorButton,
            UtilityAwcRadarMosaic.sectorLabels,
            self.sectorChanged(_:)
        )
    }
    
    @objc func productClicked() {
        _ = ObjectPopUp(
            self,
            productButton,
            UtilityAwcRadarMosaic.productLabels,
            self.productChanged(_:)
        )
    }
    
    func productChanged(_ index: Int) {
        product = UtilityAwcRadarMosaic.products[index]
        self.getContent()
    }
    
    func sectorChanged(_ index: Int) {
        sector = UtilityAwcRadarMosaic.sectors[index]
        self.getContent()
    }
    
    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, image.bitmap)
    }
    
    @objc func getAnimation() {
        DispatchQueue.global(qos: .userInitiated).async {
            let animDrawable = UtilityAwcRadarMosaic.getAnimation(self.sector, self.product)
            DispatchQueue.main.async {
                self.image.startAnimating(animDrawable)
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { _ -> Void in self.image.refresh() })
    }
}
