/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class vcSpcWatchMcdMpd: UIwXViewControllerWithAudio {
    
    private var bitmaps = [Bitmap]()
    private var numbers = [String]()
    private var listOfText = [String]()
    private var urls = [String]()
    private var productNumber = ""
    private var objectWatchProduct: ObjectWatchProduct?
    var watchMcdMpdNumber = ""
    var watchMcdMpdType = PolygonEnum.SPCWAT
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = true
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        let radarButton = ObjectToolbarIcon(self, .radar, #selector(radarClicked))
        productNumber = watchMcdMpdNumber
        if productNumber != "" {
            watchMcdMpdNumber = ""
        }
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, playButton, playListButton, shareButton, radarButton]).items
        objScrollStackView = ObjectScrollStackView(self)
        self.getContent()
    }
    
    override func doneClicked() {
        UIApplication.shared.isIdleTimerDisabled = false
        super.doneClicked()
    }
    
    override func willEnterForeground() {}

    override func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            var productNumberList = [String]()
            if self.productNumber == "" {
                productNumberList = ObjectWatchProduct.getNumberList(self.watchMcdMpdType)
            } else {
                productNumberList = [self.productNumber]
            }
            productNumberList.forEach {
                let number = String(format: "%04d", (Int($0.replace(" ", "")) ?? 0))
                self.objectWatchProduct = ObjectWatchProduct(self.watchMcdMpdType, number)
                self.objectWatchProduct!.getData()
                self.listOfText.append(self.objectWatchProduct!.text)
                self.urls.append(self.objectWatchProduct!.imgUrl)
                self.bitmaps.append(self.objectWatchProduct!.bitmap)
                self.numbers.append(number)
            }
            DispatchQueue.main.async { self.display() }
        }
    }
    
    @objc func imageClicked(sender: UITapGestureRecognizerWithData) {
        if self.bitmaps.count == 1 {
            Route.imageViewer(self, urls[0])
        } else {
            Route.spcMcdWatchItem(self, self.watchMcdMpdType, self.numbers[sender.data])
        }
    }
    
    @objc override func shareClicked(sender: UIButton) {
        if let object = self.objectWatchProduct {
            UtilityShare.image(self, sender, bitmaps, object.text)
        }
    }
    
    override func playlistClicked() {
        if let object = self.objectWatchProduct {
            _ = UtilityPlayList.add(self.objectWatchProduct!.prod, object.text, self, playListButton)
        }
    }
    
    @objc func radarClicked() {
        Route.radarNoSave(self, objectWatchProduct?.getClosestRadar() ?? "")
    }
    
    private func display() {
        var tabletInLandscape = UtilityUI.isTablet() && UtilityUI.isLandscape() && self.bitmaps.count == 1
        #if targetEnvironment(macCatalyst)
        tabletInLandscape = self.bitmaps.count == 1
        #endif
        if tabletInLandscape {
            stackView.axis = .horizontal
            stackView.alignment = .firstBaseline
        }
        var views = [UIView]()
        if self.bitmaps.count > 0 {
            self.bitmaps.enumerated().forEach {
                let objectImage: ObjectImage
                if tabletInLandscape {
                    objectImage = ObjectImage(
                        self.stackView,
                        $1,
                        UITapGestureRecognizerWithData($0, self, #selector(imageClicked(sender:))),
                        widthDivider: 2
                    )
                } else {
                    objectImage = ObjectImage(
                        self.stackView,
                        $1,
                        UITapGestureRecognizerWithData($0, self, #selector(imageClicked(sender:)))
                    )
                }
                objectImage.img.accessibilityLabel = listOfText[$0]
                objectImage.img.isAccessibilityElement = true
                views.append(objectImage.img)
            }
            if self.bitmaps.count == 1 {
                if tabletInLandscape {
                    objectTextView = ObjectTextView(self.stackView, self.objectWatchProduct?.text ?? "", widthDivider: 2)
                } else {
                    objectTextView = ObjectTextView(self.stackView, self.objectWatchProduct?.text ?? "")
                }
                objectTextView.tv.isAccessibilityElement = true
                views.append(objectTextView.tv)
            }
        } else {
            let message = objectWatchProduct?.getTextForNoProducts() ?? "No active " + String(describing: watchMcdMpdType) + "s"
            let objectTextView = ObjectTextView(self.stackView, message)
            objectTextView.tv.isAccessibilityElement = true
            objectTextView.constrain(self.scrollView)
            views += [objectTextView.tv]
            objectTextView.tv.accessibilityLabel = message
        }
        self.view.bringSubviewToFront(self.toolbar)
        scrollView.accessibilityElements = views
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: nil,
            completion: { _ -> Void in
                self.refreshViews()
                self.display()
            }
        )
    }
}
