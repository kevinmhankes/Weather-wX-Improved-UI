/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class vcImageViewer: UIwXViewController {

    private var image = TouchImage()
    var url = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = ToolbarIcon(self, .share, #selector(share))
        toolbar.items = ToolbarItems([doneButton, GlobalVariables.flexBarButton, shareButton]).items
        getContent()
    }

    override func willEnterForeground() {}

    override func getContent() {
        _ = FutureBytes(self.url, self.display)
    }

    private func display(_ bitmap: Bitmap) {
        image = TouchImage(self, toolbar, bitmap)
    }

    @objc func share(sender: UIButton) {
        UtilityShare.image(self, sender, image.bitmap)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { _ -> Void in self.image.refresh() })
    }
}
