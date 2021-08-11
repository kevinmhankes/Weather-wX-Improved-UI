// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class vcWpcRainfallSummary: UIwXViewController {

    private var bitmaps = [Bitmap]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let statusButton = ToolbarIcon("WPC Excessive Rainfall Outlooks", self, nil)
        let shareButton = ToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ToolbarItems([doneButton, statusButton, GlobalVariables.flexBarButton, shareButton]).items
        objScrollStackView = ScrollStackView(self)
        bitmaps = [Bitmap](repeating: Bitmap(), count: UtilityWpcRainfallOutlook.urls.count)
        getContent()
    }

    override func getContent() {
        UtilityWpcRainfallOutlook.urls.enumerated().forEach { i, url in
            _ = FutureVoid({ self.download(url, i) }, display)
        }
    }

    private func download(_ url: String, _ i: Int) {
        bitmaps[i] = Bitmap(url)
    }

    private func display() {
        refreshViews()
        _ = ObjectImageSummary(self, bitmaps)
    }

    @objc func imageClicked(sender: GestureData) {
        Route.wpcRainfallForDay(self, sender.data)
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.image(self, sender, bitmaps)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { _ in self.display() })
    }
}
