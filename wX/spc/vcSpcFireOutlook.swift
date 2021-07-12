/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class vcSpcFireOutlook: UIwXViewControllerWithAudio {

    private var bitmap = Bitmap()
    private var html = ""
    var dayIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        var dayString = String(dayIndex + 1)
        if dayIndex == 2 {
            dayString = "3-8"
        }
        let statusButton = ToolbarIcon(title: "Day " + dayString, self, nil)
        let shareButton = ToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ToolbarItems([
            doneButton,
            statusButton,
            GlobalVariables.flexBarButton,
            playButton,
            playListButton,
            shareButton
        ]).items
        objScrollStackView = ScrollStackView(self)
        getContent()
    }

    override func getContent() {
        getContentImage()
        getContentText()
    }

    func getContentImage() {
        DispatchQueue.global(qos: .userInitiated).async {
            let imgUrl = UtilitySpcFireOutlook.urls[self.dayIndex]
            self.bitmap = Bitmap(imgUrl)
            DispatchQueue.main.async { self.display() }
        }
    }

    func getContentText() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.product = UtilitySpcFireOutlook.products[self.dayIndex]
            self.html = UtilityDownload.getTextProduct(self.product)
            DispatchQueue.main.async { self.display() }
        }
    }

    @objc func imageClicked() {
        Route.imageViewer(self, UtilitySpcFireOutlook.urls[dayIndex])
    }

    private func display() {
        refreshViews()
        _ = ObjectImageAndText(self, bitmap, html)
    }

    override func shareClicked(sender: UIButton) {
        UtilityShare.image(self, sender, bitmap, html)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { _ -> Void in self.display() })
    }
}
