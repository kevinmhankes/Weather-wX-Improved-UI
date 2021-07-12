/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class vcSpcFireSummary: UIwXViewController {

    private var bitmaps = [Bitmap]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let statusButton = ToolbarIcon(title: "SPC Fire Weather Outlooks", self, nil)
        let shareButton = ToolbarIcon(self, .share, #selector(share))
        toolbar.items = ToolbarItems([doneButton, statusButton, GlobalVariables.flexBarButton, shareButton]).items
        objScrollStackView = ScrollStackView(self)
        getContent()
    }

    override func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.bitmaps = UtilitySpcFireOutlook.urls.map { Bitmap($0) }
            DispatchQueue.main.async { self.display() }
        }
    }

    private func display() {
       refreshViews()
       _ = ObjectImageSummary(self, bitmaps)
    }

    @objc func imageClicked(sender: UITapGestureRecognizerWithData) {
        Route.spcFireOutlookForDay(self, sender.data)
    }

    @objc func share(sender: UIButton) {
        UtilityShare.image(self, sender, bitmaps)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { _ -> Void in self.display() })
    }
}
