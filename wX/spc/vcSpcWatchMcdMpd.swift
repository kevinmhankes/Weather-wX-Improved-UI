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
        let shareButton = ToolbarIcon(self, .share, #selector(shareClicked))
        let radarButton = ToolbarIcon(self, .radar, #selector(radarClicked))
        productNumber = watchMcdMpdNumber
        if productNumber != "" {
            watchMcdMpdNumber = ""
        }
        toolbar.items = ToolbarItems([doneButton, GlobalVariables.flexBarButton, playButton, playListButton, shareButton, radarButton]).items
        objScrollStackView = ScrollStackView(self)
        getContent()
    }

    override func doneClicked() {
        UIApplication.shared.isIdleTimerDisabled = false
        super.doneClicked()
    }

    override func willEnterForeground() {}

    override func getContent() {
        _ = FutureVoid(download, display)
    }

    private func download() {
        var productNumberList = [String]()
        if productNumber == "" {
            productNumberList = ObjectWatchProduct.getNumberList(watchMcdMpdType)
        } else {
            productNumberList = [productNumber]
        }
        productNumberList.forEach {
            let number = String(format: "%04d", (Int($0.replace(" ", "")) ?? 0))
            objectWatchProduct = ObjectWatchProduct(watchMcdMpdType, number)
            objectWatchProduct!.getData()
            listOfText.append(objectWatchProduct!.text)
            urls.append(objectWatchProduct!.imgUrl)
            bitmaps.append(objectWatchProduct!.bitmap)
            numbers.append(number)
        }
    }

    @objc func imageClicked(sender: GestureData) {
        if bitmaps.count == 1 {
            Route.imageViewer(self, urls[0])
        } else {
            Route.spcMcdWatchItem(self, watchMcdMpdType, numbers[sender.data])
        }
    }

    override func shareClicked(sender: UIButton) {
        if let object = objectWatchProduct {
            UtilityShare.image(self, sender, bitmaps, object.text)
        }
    }

    override func playlistClicked() {
        if let object = objectWatchProduct {
            _ = UtilityPlayList.add(objectWatchProduct!.prod, object.text, self, playListButton)
        }
    }

    @objc func radarClicked() {
        Route.radarNoSave(self, objectWatchProduct?.getClosestRadar() ?? "")
    }

    private func display() {
        var tabletInLandscape = UtilityUI.isTablet() && UtilityUI.isLandscape() && bitmaps.count == 1
        #if targetEnvironment(macCatalyst)
        tabletInLandscape = bitmaps.count == 1
        #endif
        if tabletInLandscape {
            stackView.axis = .horizontal
            stackView.alignment = .firstBaseline
        }
        var views = [UIView]()
        if bitmaps.count > 0 {
            bitmaps.enumerated().forEach {
                let objectImage: ObjectImage
                if tabletInLandscape {
                    objectImage = ObjectImage(
                        stackView,
                        $1,
                        GestureData($0, self, #selector(imageClicked(sender:))),
                        widthDivider: 2
                    )
                } else {
                    objectImage = ObjectImage(
                        stackView,
                        $1,
                        GestureData($0, self, #selector(imageClicked(sender:)))
                    )
                }
                objectImage.img.accessibilityLabel = listOfText[$0]
                objectImage.img.isAccessibilityElement = true
                views.append(objectImage.img)
            }
            if bitmaps.count == 1 {
                if tabletInLandscape {
                    objectTextView = Text(stackView, objectWatchProduct?.text ?? "", widthDivider: 2)
                } else {
                    objectTextView = Text(stackView, objectWatchProduct?.text ?? "")
                }
                objectTextView.tv.isAccessibilityElement = true
                views.append(objectTextView.tv)
            }
        } else {
            let message = objectWatchProduct?.getTextForNoProducts() ?? "No active " + String(describing: watchMcdMpdType) + "s"
            let objectTextView = Text(stackView, message)
            objectTextView.tv.isAccessibilityElement = true
            objectTextView.constrain(scrollView)
            views += [objectTextView.tv]
            objectTextView.tv.accessibilityLabel = message
        }
        view.bringSubviewToFront(toolbar)
        scrollView.accessibilityElements = views
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: nil,
            completion: { _ in
                self.refreshViews()
                self.display()
            }
        )
    }
}
