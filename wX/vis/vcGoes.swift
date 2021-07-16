/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class vcGoes: UIwXViewController {

    private var image = TouchImage()
    private var productButton = ToolbarIcon()
    private var sectorButton = ToolbarIcon()
    private var animateButton = ToolbarIcon()
    var savePrefs = true
    var productCode = ""
    var sectorCode = ""
    var goesFloater: Bool = false
    var url = ""
    var goesFloaterUrl = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        productButton = ToolbarIcon(self, #selector(productClicked))
        sectorButton = ToolbarIcon(self, #selector(sectorClicked))
        let shareButton = ToolbarIcon(self, .share, #selector(shareClicked))
        animateButton = ToolbarIcon(self, .play, #selector(animateClicked))
        toolbar.items = ToolbarItems([
            doneButton,
            GlobalVariables.flexBarButton,
            sectorButton,
            productButton,
            animateButton,
            shareButton
        ]).items
        image = TouchImage(self, toolbar, #selector(handleSwipes))
        image.setMaxScaleFromMinScale(10.0)
        image.setKZoomInFactorFromMinWhenDoubleTap(8.0)
        
        if url != "" {
            goesFloater = true
            goesFloaterUrl = url
            productCode = "GEOCOLOR"
            sectorCode = goesFloaterUrl
            productButton.title = productCode
        } else {
            deSerializeSettings()
        }
        
        getContent()
    }

    func serializeSettings() {
        if savePrefs {
            Utility.writePref("GOES16_PROD", productCode)
            Utility.writePref("GOES16_SECTOR", sectorCode)
        }
    }

    func deSerializeSettings() {
        if sectorCode == "" {
            productCode = Utility.readPref("GOES16_PROD", "GEOCOLOR")
            sectorCode = Utility.readPref("GOES16_SECTOR", "cgl")
            productButton.title = productCode
            sectorButton.title = sectorCode
        } else {
            productButton.title = productCode
            sectorButton.title = sectorCode
            savePrefs = false
        }
    }

    override func getContent() {
        animateButton.setImage(.play)
        if !goesFloater {
            _ = FutureBytes2({ UtilityGoes.getImage(self.productCode, self.sectorCode) }, display)
        } else {
            _ = FutureBytes(UtilityGoes.getImageGoesFloater(goesFloaterUrl, productCode), display)
        }
    }

    private func display(_ bitmap: Bitmap) {
        if !goesFloater {
            productButton.title = bitmap.info
            productCode = bitmap.info
            serializeSettings()
        }
        image.setBitmap(bitmap)
    }

    override func doneClicked() {
        super.doneClicked()
    }

    @objc func productClicked() {
        var labels: [String]
        if UtilityGoes.sectorsWithAdditional.contains(sectorCode) {
            labels = UtilityGoes.labels + UtilityGoes.additionalLabels
        } else {
            labels = UtilityGoes.labels
        }
        _ = ObjectPopUp(self, productButton, labels, productChanged)
    }

    @objc func sectorClicked() {
        _ = ObjectPopUp(self, title: "Sector Selection", sectorButton, UtilityGoes.sectors, sectorChanged(_:))
    }

    func productChanged(_ index: Int) {
        productCode = UtilityGoes.codes[index]
        productButton.title = productCode
        getContent()
    }

    func sectorChanged(_ sector: String) {
        sectorCode = sector
        sectorButton.title = sector
        getContent()
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.image(self, sender, image.bitmap)
    }

    @objc func handleSwipes(sender: UISwipeGestureRecognizer) {
        productChanged(
            UtilityUI.sideSwipe(
                sender,
                UtilityGoes.codes.firstIndex(of: productCode)!,
                UtilityGoes.codes
            )
        )
    }

    @objc func animateClicked() {
        if image.isAnimating() {
            image.stopAnimating()
            animateButton.setImage(.play)
        } else {
            _ = ObjectPopUp(
                    self,
                    title: "Select number of animation frames:",
                    animateButton,
                    stride(from: 12, to: 96 + 12, by: 12),
                    getAnimation
            )
        }
    }

//    @objc func getAnimation(_ frameCount: Int) {
//        if !goesFloater {
//            _ = FutureAnimation({ UtilityGoes.getAnimation(self.productCode, self.sectorCode, frameCount) }, image.startAnimating)
//        } else {
//            _ = FutureAnimation({ UtilityGoes.getAnimationGoesFloater(self.productCode, self.sectorCode, frameCount) }, image.startAnimating)
//        }
//    }
    
    @objc func getAnimation(_ frameCount: Int) {
        if !image.isAnimating() {
            animateButton.setImage(.stop)
            // _ = FutureAnimation({ UtilityAwcRadarMosaic.getAnimation(self.sector, self.product) }, image.startAnimating)
            if !goesFloater {
                _ = FutureAnimation({ UtilityGoes.getAnimation(self.productCode, self.sectorCode, frameCount) }, image.startAnimating)
            } else {
                _ = FutureAnimation({ UtilityGoes.getAnimationGoesFloater(self.productCode, self.sectorCode, frameCount) }, image.startAnimating)
            }
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
