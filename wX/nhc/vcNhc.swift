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
        
        stackView.addArrangedSubview(boxText.get())
        stackView.addArrangedSubview(boxImages.get())
        
        objectNhc = ObjectNhc(self)
        bitmaps = [Bitmap](repeating: Bitmap(), count: 9)
        objectImageSummary = ObjectImageSummary(self, boxImages, bitmaps, imagesPerRowWide: 3)

        for region in NhcOceanEnum.allCases {
            urls += objectNhc.regionMap[region]!.urls
        }
        
        getContent()
    }

    override func getContent() {
//        refreshViews()
//        let serial = DispatchQueue(label: "joshuatee.wx")
//        serial.async {
//            self.objectNhc.getTextData()
//            DispatchQueue.main.async { self.objectNhc.showTextData() }
//        }
        
        _ = FutureVoid(objectNhc.getTextData, displayText)
        for (index, url) in urls.enumerated() {
            _ = FutureVoid({ self.bitmaps[index] = Bitmap(url) }, { self.objectImageSummary.setBitmap(index, self.bitmaps[index]); self.display() })
        }
        
//        NhcOceanEnum.allCases.forEach { type in
//            serial.async {
//                self.objectNhc.regionMap[type]!.getImages()
//                DispatchQueue.main.async { self.objectNhc.showImageData(type) }
//            }
//        }
    }
    
    private func displayText() {
        boxText.removeChildren()
        objectNhc.showTextData()
        for (index, s) in objectNhc.stormDataList.enumerated() {
            let card = ObjectCardNhcStormReportItem(s, UITapGestureRecognizerWithData(index, self, #selector(gotoNhcStorm)))
            boxText.addLayout(card.get())
        }
    }
    
    private func display() {
        // boxImages.removeChildren()
        // boxImages.get().removeViews()
        objectImageSummary.removeChildren()
        objectImageSummary = ObjectImageSummary(self, bitmaps, imagesPerRowWide: 3)
        
        for (index, url) in urls.enumerated() {
            objectImageSummary.objectImages[index].addGestureRecognizer(UITapGestureRecognizerWithData(url, self, #selector(imageClicked)))
        }
        
        // objectImageSummary.changeWidth()
    }
    
    @objc func gotoNhcStorm(sender: UITapGestureRecognizerWithData) {
        Route.nhcStorm(self, objectNhc.stormDataList[sender.data])
    }

    @objc func textProductClicked() {
        _ = ObjectPopUp(self, title: "", textProductButton, UtilityNhc.textProductLabels, textProductChanged(_:))
    }

    func textProductChanged(_ index: Int) {
        Route.wpcText(self, UtilityNhc.textProductCodes[index])
    }

    @objc func imageProductClicked() {
        _ = ObjectPopUp(self, title: "", imageProductButton, UtilityNhc.imageTitles, imageProductChanged(_:))
    }

    @objc func imageClicked(sender: UITapGestureRecognizerWithData) {
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
            completion: { _ -> Void in
                self.display()
//                self.refreshViews()
//                self.objectNhc.showTextData()
//                NhcOceanEnum.allCases.forEach { type in self.objectNhc.showImageData(type) }
            }
        )
    }
}
