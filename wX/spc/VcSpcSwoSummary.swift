// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class VcSpcSwoSummary: UIwXViewController {

    private var urls = [String]()
    private var objectImageSummary: ObjectImageSummary!

    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = ToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ToolbarItems([doneButton, GlobalVariables.flexBarButton, shareButton]).items
        objScrollStackView = ScrollStackView(self)
        getContent()
    }

    override func getContent() {
        urls.removeAll()
        refreshViews()
        objectImageSummary = ObjectImageSummary(self, [Bitmap](repeating: Bitmap(815, 555), count: 8), imagesPerRowWide: 4)
        urls = [String](repeating: "", count: 3)
        _ = FutureVoid(download13, {})
        _ = FutureVoid(download48, {})
    }
    
    private func download13() {
        for day in (1...3) {
            _ = FutureVoid({ self.urls[day - 1] = UtilitySpcSwo.getUrls(to.String(day))[0] }, { self.download13Bitmap(day - 1)})
        }
    }
    
    private func download13Bitmap(_ day: Int) {
        _ = FutureBytes(urls[day]) { bitmap in self.objectImageSummary.setBitmap(day, bitmap) }
    }
    
    private func download48() {
        for day in (4...8) {
            let url = UtilitySpcSwo.getImageUrlsDays48(to.String(day))
            _ = FutureBytes(url) { bitmap in self.objectImageSummary.setBitmap(day - 1, bitmap) }
        }
    }

    private func display() {
        refreshViews()
        objectImageSummary = ObjectImageSummary(self, objectImageSummary.bitmaps, imagesPerRowWide: 4)
    }

    @objc func imageClicked(sender: GestureData) {
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
        UtilityShare.image(self, sender, objectImageSummary.bitmaps)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { _ in self.display() }
    }
}
