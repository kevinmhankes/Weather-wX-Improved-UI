/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class vcObservations: UIwXViewController {

    private var image = TouchImage()
    private var productButton = ToolbarIcon()
    private var index = 0
    private let prefTokenIndex = "SFC_OBS_IMG_IDX"

    override func viewDidLoad() {
        super.viewDidLoad()
        productButton = ToolbarIcon(self, #selector(productClicked))
        let shareButton = ToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ToolbarItems([doneButton, GlobalVariables.flexBarButton, productButton, shareButton]).items
        image = TouchImage(self, toolbar, #selector(handleSwipes(sender:)))
        image.setMaxScaleFromMinScale(10.0)
        image.setKZoomInFactorFromMinWhenDoubleTap(8.0)
        index = Utility.readPref(prefTokenIndex, 0)
        getContent(index)
    }

    override func willEnterForeground() {
        getContent(index)
    }

    func getContent(_ index: Int) {
        self.index = index
        Utility.writePref(prefTokenIndex, self.index)
        productButton.title = UtilityObservations.labels[self.index]
//        DispatchQueue.global(qos: .userInitiated).async {
//            let bitmap = Bitmap(UtilityObservations.urls[self.index])
//            DispatchQueue.main.async { self.display(bitmap) }
//        }
        _ = FutureBytes(UtilityObservations.urls[self.index], self.display)
    }

    private func display(_ bitmap: Bitmap) {
        image.setBitmap(bitmap)
    }

    @objc func productClicked() {
        _ = ObjectPopUp(self, productButton, UtilityObservations.labels, getContent(_:))
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.image(self, sender, image.bitmap)
    }

    @objc func handleSwipes(sender: UISwipeGestureRecognizer) {
        getContent(UtilityUI.sideSwipe(sender, index, UtilityObservations.urls))
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { _ -> Void in self.image.refresh() })
    }
}
