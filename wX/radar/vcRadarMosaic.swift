/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcRadarMosaic: UIwXViewController {
    
    private var image = ObjectTouchImageView()
    private var productButton = ObjectToolbarIcon()
    private var animateButton = ObjectToolbarIcon()
    private var index = 8
    private var isLocal = false
    private let prefToken = "NWSMOSAIC_PARAM_LAST_USED"
    var nwsMosaicType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productButton = ObjectToolbarIcon(self, #selector(productClicked))
        animateButton = ObjectToolbarIcon(self, .play, #selector(animateClicked))
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems(
            [
                doneButton,
                GlobalVariables.flexBarButton,
                productButton,
                animateButton,
                shareButton
        ]).items
        image = ObjectTouchImageView(self, toolbar, #selector(handleSwipes(sender:)))
        index = Utility.readPref(prefToken, index)
        if nwsMosaicType == "local" {
            nwsMosaicType = ""
            isLocal = true
            let nwsRadarMosaicSectorLabelCurrent = UtilityUSImgNwsMosaic.getSectorFromState(
                UtilityUSImgNwsMosaic.getStateFromRid()
            )
            index = UtilityUSImgNwsMosaic.sectors.firstIndex(of: nwsRadarMosaicSectorLabelCurrent) ?? 0
        }
        self.getContent(index)
    }
    
    func getContent(_ index: Int) {
        self.index = index
        self.productButton.title = UtilityUSImgNwsMosaic.labels[self.index]
        DispatchQueue.global(qos: .userInitiated).async {
            let bitmap = UtilityUSImgNwsMosaic.get(UtilityUSImgNwsMosaic.sectors[self.index])
            DispatchQueue.main.async {
                self.image.setBitmap(bitmap)
                if !self.isLocal {
                    Utility.writePref(self.prefToken, self.index)
                }
            }
        }
    }
    
    @objc override func willEnterForeground() {
        self.getContent(self.index)
    }
    
    @objc func productClicked() {
        _ = ObjectPopUp(
            self,
            "Product Selection",
            productButton,
            UtilityUSImgNwsMosaic.labels,
            self.getContent(_:)
        )
    }
    
    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, image.bitmap)
    }
    
    @objc func animateClicked() {
        _ = ObjectPopUp(
            self,
            "Select number of animation frames:",
            animateButton,
            [5, 10, 20, 30],
            self.getAnimation(_:)
        )
    }
    
    func getAnimation(_ frameCount: Int) {
        DispatchQueue.global(qos: .userInitiated).async {
            let animDrawable = UtilityUSImgNwsMosaic.getAnimation(
                UtilityUSImgNwsMosaic.sectors[self.index],
                frameCount
            )
            DispatchQueue.main.async {
                self.image.startAnimating(animDrawable)
            }
        }
    }
    
    @objc func handleSwipes(sender: UISwipeGestureRecognizer) {
        getContent(UtilityUI.sideSwipe(sender, index, UtilityUSImgNwsMosaic.sectors))
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: nil,
            completion: { _ -> Void in
                self.image.refresh()
        }
        )
    }
}
