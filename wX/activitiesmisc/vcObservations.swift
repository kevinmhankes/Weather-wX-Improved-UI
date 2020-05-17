/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class vcObservations: UIwXViewController {
    
    private var image = ObjectTouchImageView()
    private var productButton = ObjectToolbarIcon()
    private var index = 0
    private let prefTokenIndex = "SFC_OBS_IMG_IDX"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productButton = ObjectToolbarIcon(self, #selector(productClicked))
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, productButton, shareButton]).items
        image = ObjectTouchImageView(self, toolbar, #selector(handleSwipes(sender:)))
        image.setMaxScaleFromMinScale(10.0)
        image.setKZoomInFactorFromMinWhenDoubleTap(8.0)
        self.index = Utility.readPref(prefTokenIndex, 0)
        self.getContent(index)
    }
    
    override func willEnterForeground() {
        self.getContent(index)
    }
    
    func getContent(_ index: Int) {
        self.index = index
        Utility.writePref(self.prefTokenIndex, self.index)
        self.productButton.title = UtilityObservations.labels[self.index]
        DispatchQueue.global(qos: .userInitiated).async {
            let bitmap = Bitmap(UtilityObservations.urls[self.index])
            DispatchQueue.main.async { self.displayContent(bitmap) }
        }
    }
    
    private func displayContent(_ bitmap: Bitmap) {
        self.image.setBitmap(bitmap)
    }
    
    @objc func productClicked() {
        _ = ObjectPopUp(self, productButton, UtilityObservations.labels, self.getContent(_:))
    }
    
    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, image.bitmap)
    }
    
    @objc func handleSwipes(sender: UISwipeGestureRecognizer) {
        getContent(UtilityUI.sideSwipe(sender, index, UtilityObservations.urls))
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { _ -> Void in self.image.refresh() })
    }
}
