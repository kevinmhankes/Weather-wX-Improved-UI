/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation

class vcSpcWatchMcdMpd: UIwXViewController {

    var bitmaps = [Bitmap]()
    var numbers = [String]()
    var listOfText = [String]()
    var urls = [String]()
    var playListButton = ObjectToolbarIcon()
    var playButton = ObjectToolbarIcon()
    var productNumber = ""
    let synth = AVSpeechSynthesizer()
    var objectWatchProduct: ObjectWatchProduct?

    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        playButton = ObjectToolbarIcon(self, .play, #selector(playClicked))
        playListButton = ObjectToolbarIcon(self, .playList, #selector(playlistClicked))
        productNumber = ActVars.watchMcdMpdNumber
        if productNumber != "" {
            ActVars.watchMcdMpdNumber = ""
        }
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, playButton, shareButton, playListButton]).items
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        self.getContent()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            var productNumberList = [String]()
            if self.productNumber == "" {
                productNumberList = ObjectWatchProduct.getNumberList(ActVars.watchMcdMpdType)
            } else {
                productNumberList = [self.productNumber]
            }
            productNumberList.forEach {
                let number = String(format: "%04d", (Int($0.replace(" ", "")) ?? 0))
                print("NUMBER: " + number)
                self.objectWatchProduct = ObjectWatchProduct(ActVars.watchMcdMpdType, number)
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
        ActVars.textViewText = self.listOfText[sender.data]
        let vc = vcTextViewer()
        self.goToVC(vc)
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, bitmaps, self.objectWatchProduct!.text)
    }

    @objc func playClicked() {
        UtilityActions.playClicked(self.objectWatchProduct!.text, synth, playButton)
    }

    @objc func playlistClicked() {
        UtilityPlayList.add(self.objectWatchProduct!.prod, self.objectWatchProduct!.text, self, playListButton)
    }

    private func displayContent() {
        var tabletInLandscape = UtilityUI.isTablet() && UtilityUI.isLandscape() && self.bitmaps.count == 1
        #if targetEnvironment(macCatalyst)
            tabletInLandscape = self.bitmaps.count == 1
        #endif
        //tabletInLandscape = false
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
                let objectTextView: ObjectTextView
                if tabletInLandscape {
                    objectTextView = ObjectTextView(self.stackView, self.objectWatchProduct?.text ?? "", widthDivider: 2)
                } else {
                    objectTextView = ObjectTextView(self.stackView, self.objectWatchProduct?.text ?? "")
                }
                objectTextView.tv.isAccessibilityElement = true
                views.append(objectTextView.tv)
            }
        } else {
            let message = objectWatchProduct?.getTextForNoProducts() ?? "No active " + ActVars.watchMcdMpdType.string + "s"
            let objectTextView = ObjectTextView(self.stackView, message)
            objectTextView.tv.isAccessibilityElement = true
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
