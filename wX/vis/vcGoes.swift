/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class vcGoes: UIwXViewController {
    
    private var image = ObjectTouchImageView()
    private var productButton = ObjectToolbarIcon()
    private var sectorButton = ObjectToolbarIcon()
    private var animateButton = ObjectToolbarIcon()
    private var savePrefs = true
    private var firstRun = true
    var productCode = ""
    var sectorCode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productButton = ObjectToolbarIcon(self, #selector(productClicked))
        sectorButton = ObjectToolbarIcon(self, #selector(sectorClicked))
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        animateButton = ObjectToolbarIcon(self, .play, #selector(animateClicked))
        toolbar.items = ObjectToolbarItems([
            doneButton,
            GlobalVariables.flexBarButton,
            sectorButton,
            productButton,
            animateButton,
            shareButton
        ]).items
        image = ObjectTouchImageView(self, toolbar, #selector(handleSwipes(sender:)))
        image.setMaxScaleFromMinScale(10.0)
        image.setKZoomInFactorFromMinWhenDoubleTap(8.0)
        deSerializeSettings()
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
        DispatchQueue.global(qos: .userInitiated).async {
            let bitmap = UtilityGoes.getImage(self.productCode, self.sectorCode)
            DispatchQueue.main.async {
                self.productButton.title = bitmap.info
                self.productCode = bitmap.info
                self.display(bitmap)
            }
        }
    }
    
    private func display(_ bitmap: Bitmap) {
        serializeSettings()
        image.setBitmap(bitmap)
        if firstRun {
            firstRun = false
        }
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
        _ = ObjectPopUp(self, productButton, labels, productChanged(_:))
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
        _ = ObjectPopUp(
                self,
                title: "Select number of animation frames:",
                animateButton,
                stride(from: 12, to: 96 + 12, by: 12),
                getAnimation(_:)
        )
    }
    
    @objc func getAnimation(_ frameCount: Int) {
        DispatchQueue.global(qos: .userInitiated).async {
            let animationDrawable = UtilityGoes.getAnimation(self.productCode, self.sectorCode, frameCount)
            DispatchQueue.main.async { self.image.startAnimating(animationDrawable) }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { _ -> Void in self.image.refresh() })
    }
}
