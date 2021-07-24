/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class vcNhc: UIwXViewController {

    private var textProductButton = ToolbarIcon()
    private var imageProductButton = ToolbarIcon()
    private var glcfsButton = ToolbarIcon()
    private var objectNhc: ObjectNhc!
    private var objectImageSummary: ObjectImageSummary!
    private var bitmaps = [Bitmap]()
    private var urls = [String]()
    private var boxText = ObjectStackView(.fill, .vertical)
    private var boxImages = ObjectStackView(.fill, .vertical)

    override func viewDidLoad() {
        super.viewDidLoad()
        textProductButton = ToolbarIcon(title: "Text Products", self, #selector(textProductClicked))
        imageProductButton = ToolbarIcon(title: "Images", self, #selector(imageProductClicked))
        glcfsButton = ToolbarIcon(title: "GLCFS", self, #selector(glcfsClicked))
        toolbar.items = ToolbarItems([doneButton, GlobalVariables.flexBarButton, glcfsButton, imageProductButton, textProductButton]).items
        objScrollStackView = ScrollStackView(self)
        stackView.addLayout(boxText)
        stackView.addLayout(boxImages)
        objectNhc = ObjectNhc(self)
        bitmaps = [Bitmap](repeating: Bitmap(), count: 9)
        objectImageSummary = ObjectImageSummary(self, boxImages, bitmaps, imagesPerRowWide: 3)
        for region in NhcOceanEnum.allCases {
            urls += objectNhc.regionMap[region]!.urls
        }
        getContent()
    }

    override func getContent() {
        _ = FutureVoid(objectNhc.getTextData, displayText)
        for (index, url) in urls.enumerated() {
            _ = FutureVoid({ self.bitmaps[index] = Bitmap(url) }, { self.objectImageSummary.setBitmap(index, self.bitmaps[index]); self.display() })
        }
    }

    private func displayText() {
        boxText.removeChildren()
        objectNhc.showTextData()
        for (index, s) in objectNhc.stormDataList.enumerated() {
            let card = ObjectCardNhcStormReportItem(s, GestureData(index, self, #selector(gotoNhcStorm)))
            boxText.addLayout(card.get())
        }
    }

    private func display() {
        objectImageSummary.removeChildren()
        objectImageSummary = ObjectImageSummary(self, bitmaps, imagesPerRowWide: 3)
        for (index, url) in urls.enumerated() {
            objectImageSummary.objectImages[index].addGestureRecognizer(GestureData(url, self, #selector(imageClicked)))
        }
    }

    @objc func gotoNhcStorm(sender: GestureData) {
        Route.nhcStorm(self, objectNhc.stormDataList[sender.data])
    }

    @objc func textProductClicked() {
        _ = ObjectPopUp(self, title: "", textProductButton, UtilityNhc.textProductLabels, textProductChanged)
    }

    func textProductChanged(_ index: Int) {
        Route.wpcText(self, UtilityNhc.textProductCodes[index])
    }

    @objc func imageProductClicked() {
        _ = ObjectPopUp(self, title: "", imageProductButton, UtilityNhc.imageTitles, imageProductChanged)
    }

    @objc func imageClicked(sender: GestureData) {
        Route.imageViewer(self, sender.strData)
    }

    func imageProductChanged(_ index: Int) {
        Route.imageViewer(self, UtilityNhc.imageUrls[index])
    }

    @objc func glcfsClicked() {
        Route.model(self, "GLCFS")
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: nil,
            completion: { _ in self.display() }
        )
    }
}
