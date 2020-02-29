/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcSpcWatchMcdMpd: UIwXViewControllerWithAudio {
    
    private var bitmaps = [Bitmap]()
    private var numbers = [String]()
    private var listOfText = [String]()
    private var urls = [String]()
    private var productNumber = ""
    private var objectWatchProduct: ObjectWatchProduct?
    var watchMcdMpdNumber = ""
    var watchMcdMpdType = PolygonType.WATCH
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = true
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        // FIXME redundant vars
        productNumber = watchMcdMpdNumber
        if productNumber != "" {
            watchMcdMpdNumber = ""
        }
        toolbar.items = ObjectToolbarItems(
            [
                doneButton,
                GlobalVariables.flexBarButton,
                playButton,
                playListButton,
                shareButton
        ]).items
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        self.getContent()
    }
    
    @objc override func doneClicked() {
        UIApplication.shared.isIdleTimerDisabled = false
        super.doneClicked()
    }
    
    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            var productNumberList = [String]()
            if self.productNumber == "" {
                productNumberList = ObjectWatchProduct.getNumberList(self.watchMcdMpdType)
            } else {
                productNumberList = [self.productNumber]
            }
            productNumberList.forEach {
                let number = String(format: "%04d", (Int($0.replace(" ", "")) ?? 0))
                print("NUMBER: " + number)
                self.objectWatchProduct = ObjectWatchProduct(self.watchMcdMpdType, number)
                self.objectWatchProduct!.getData()
                self.listOfText.append(self.objectWatchProduct!.text)
                self.urls.append(self.objectWatchProduct!.imgUrl)
                self.bitmaps.append(self.objectWatchProduct!.bitmap)
                self.numbers.append(number)
            }
            DispatchQueue.main.async {
                self.displayContent()
            }
        }
    }
    
    @objc func imageClicked(sender: UITapGestureRecognizerWithData) {
        if self.bitmaps.count == 1 {
            let vc = vcImageViewer()
            vc.imageViewerUrl = urls[0]
            self.goToVC(vc)
            
        } else {
            let vc = vcSpcWatchMcdMpd()
            vc.watchMcdMpdNumber = self.numbers[sender.data]
            vc.watchMcdMpdType = self.watchMcdMpdType
            self.goToVC(vc)
        }
    }
    
    @objc override func shareClicked(sender: UIButton) {
        if let object = self.objectWatchProduct {
            UtilityShare.shareImage(self, sender, bitmaps, object.text)
        }
    }
    
    @objc override func playlistClicked() {
        if let object = self.objectWatchProduct {
            _ = UtilityPlayList.add(self.objectWatchProduct!.prod, object.text, self, playListButton)
        }
    }
    
    private func displayContent() {
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
            let message = objectWatchProduct?.getTextForNoProducts() ?? "No active " + watchMcdMpdType.string + "s"
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
                self.displayContent()
        }
        )
    }
}
