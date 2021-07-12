/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class vcSpcSwoSummary: UIwXViewController {

    private var bitmaps = [Bitmap]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = ToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ToolbarItems([doneButton, GlobalVariables.flexBarButton, shareButton]).items
        objScrollStackView = ScrollStackView(self)
        getContent()
    }

    override func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.bitmaps = (1...3).map { UtilitySpcSwo.getImageUrls(String($0), getAllImages: false)[0] }
            self.bitmaps += UtilitySpcSwo.getImageUrls("48", getAllImages: true)
            DispatchQueue.main.async { self.display() }
        }
    }

    private func display() {
        refreshViews()
        _ = ObjectImageSummary(self, bitmaps, imagesPerRowWide: 4)
    }

    @objc func imageClicked(sender: UITapGestureRecognizerWithData) {
        switch sender.data {
        case 0...2:
            Route.swo(self, String(sender.data + 1))
        case 3...7:
            Route.swo(self, "48")
        default:
            break
        }
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.image(self, sender, bitmaps)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { _ -> Void in self.display() })
    }
}
