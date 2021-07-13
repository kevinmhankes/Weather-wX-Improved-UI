/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class vcOpc: UIwXViewController {

    private var image = ObjectTouchImageView()
    private var productButton = ToolbarIcon()
    private var index = 0
    private let prefToken = "OPC_IMG_FAV_URL"

    override func viewDidLoad() {
        super.viewDidLoad()
        productButton = ToolbarIcon(self, #selector(productClicked))
        let shareButton = ToolbarIcon(self, .share, #selector(share))
        toolbar.items = ToolbarItems([doneButton, GlobalVariables.flexBarButton, productButton, shareButton]).items
        image = ObjectTouchImageView(self, toolbar, #selector(handleSwipes(sender:)))
        index = Utility.readPref(prefToken, index)
        getContent(index)
    }

    override func willEnterForeground() {
        getContent(index)
    }

    func getContent(_ index: Int) {
        self.index = index
        Utility.writePref(prefToken, self.index)
        productButton.title = UtilityOpcImages.labels[self.index]
//        DispatchQueue.global(qos: .userInitiated).async {
//            let bitmap = Bitmap(UtilityOpcImages.urls[self.index])
//            DispatchQueue.main.async { self.display(bitmap) }
//        }
        _ = FutureBytes(UtilityOpcImages.urls[self.index], self.display)
    }

    private func display(_ bitmap: Bitmap) {
        image.setBitmap(bitmap)
    }

    @objc func productClicked() {
        _ = ObjectPopUp(self, productButton, UtilityOpcImages.labels, getContent(_:))
    }

    @objc func share(sender: UIButton) {
        UtilityShare.image(self, sender, image.bitmap)
    }

    @objc func handleSwipes(sender: UISwipeGestureRecognizer) {
        getContent(UtilityUI.sideSwipe(sender, index, UtilityOpcImages.urls))
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { _ -> Void in self.image.refresh() })
    }
}
