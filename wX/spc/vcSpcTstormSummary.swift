/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class vcSpcTstormSummary: UIwXViewController {

    private var bitmaps = [Bitmap]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = ToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ToolbarItems([doneButton, GlobalVariables.flexBarButton, shareButton]).items
        objScrollStackView = ScrollStackView(self)
        getContent()
    }

    override func getContent() {
        _ = FutureVoid(download, display)
    }

    private func download() {
        let urls = UtilitySpc.getTstormOutlookUrls()
        self.bitmaps = urls.map { Bitmap($0) }
    }

    private func display() {
        refreshViews()
        _ = ObjectImageSummary(self, bitmaps)
    }

    @objc func imageClicked(sender: GestureData) {
        Route.imageViewer(self, bitmaps[sender.data].url)
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.image(self, sender, bitmaps)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { _ in self.display() })
    }
}
