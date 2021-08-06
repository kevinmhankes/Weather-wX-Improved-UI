// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class vcGoesGlobal: UIwXViewController {

    private var image = TouchImage()
    private var productButton = ToolbarIcon()
    private var index = 0
    private var animateButton = ToolbarIcon()
    private var shareButton = ToolbarIcon()
    private let prefToken = "GOESFULLDISK_IMG_FAV_URL"

    override func viewDidLoad() {
        super.viewDidLoad()
        productButton = ToolbarIcon(self, #selector(productClicked))
        animateButton = ToolbarIcon(self, .play, #selector(getAnimation))
        shareButton = ToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ToolbarItems([doneButton, GlobalVariables.flexBarButton, productButton, animateButton, shareButton]).items
        image = TouchImage(self, toolbar, #selector(handleSwipes))
        index = Utility.readPref(prefToken, index)
        if index >= UtilityGoesFullDisk.labels.count {
            index = UtilityGoesFullDisk.labels.count - 1
        }
        getContent(index)
    }

    override func willEnterForeground() {
        getContent(index)
    }

    func getContent(_ index: Int) {
        self.index = index
        productButton.title = UtilityGoesFullDisk.labels[index]
        _ = FutureBytes(UtilityGoesFullDisk.urls[index], display)
    }

    private func display(_ bitmap: Bitmap) {
        image.setBitmap(bitmap)
        if UtilityGoesFullDisk.urls[index].contains("jma") {
            showAnimateButton()
        } else {
            hideAnimateButton()
        }
        Utility.writePref(prefToken, index)
    }

    func showAnimateButton() {
        toolbar.items = ToolbarItems([doneButton, GlobalVariables.flexBarButton, productButton, animateButton, shareButton]).items
    }

    func hideAnimateButton() {
        toolbar.items = ToolbarItems([doneButton, GlobalVariables.flexBarButton, productButton, shareButton]).items
    }

    @objc func productClicked() {
        _ = ObjectPopUp(self, productButton, UtilityGoesFullDisk.labels, getContent)
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.image(self, sender, image.bitmap)
    }

    @objc func handleSwipes(sender: UISwipeGestureRecognizer) {
        getContent(UtilityUI.sideSwipe(sender, index, UtilityGoesFullDisk.urls))
    }

    @objc func getAnimation() {
        _ = FutureAnimation({ UtilityGoesFullDisk.getAnimation(url: UtilityGoesFullDisk.urls[self.index]) }, image.startAnimating)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { _ in self.image.refresh() })
    }
}
