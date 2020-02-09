/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation

class ViewControllerSPCMCD: UIwXViewController {

    var bitmaps = [Bitmap]()
    var numbers = [String]()
    var listOfText = [String]()
    var urls = [String]()
    var playListButton = ObjectToolbarIcon()
    var playButton = ObjectToolbarIcon()
    var spcMcdNumber = ""
    var text = ""
    let synth = AVSpeechSynthesizer()
    var product = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        playButton = ObjectToolbarIcon(self, .play, #selector(playClicked))
        playListButton = ObjectToolbarIcon(self, .playList, #selector(playlistClicked))
        spcMcdNumber = ActVars.watchMcdMpdNumber
        if spcMcdNumber != "" {
            ActVars.watchMcdMpdNumber = ""
        }
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, playButton, shareButton, playListButton]).items
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        self.getContent()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            var mcdList = [String]()
            if self.spcMcdNumber == "" {
                mcdList = (MyApplication.nwsSPCwebsitePrefix + "/products/md/")
                    .getHtml()
                    .parseColumn("title=.Mesoscale Discussion #(.*?).>")
            } else {
                mcdList = [self.spcMcdNumber]
            }
            mcdList.forEach {
                let number = String(format: "%04d", (Int($0.replace(" ", "")) ?? 0))
                let imgUrl = MyApplication.nwsSPCwebsitePrefix + "/products/md/mcd" + number + ".gif"
                self.product = "SPCMCD" + number
                self.text = UtilityDownload.getTextProduct(self.product)
                self.listOfText.append(self.text)
                self.urls.append(imgUrl)
                self.bitmaps.append(Bitmap(imgUrl))
                self.numbers.append(number)
            }
            DispatchQueue.main.async {
                self.displayContent()
            }
        }
    }

    @objc func imageClicked(sender: UITapGestureRecognizerWithData) {
        ActVars.textViewText = self.listOfText[sender.data]
        self.goToVC("textviewer")
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, bitmaps, text)
    }

    @objc func playClicked() {
        UtilityActions.playClicked(text, synth, playButton)
    }

    @objc func playlistClicked() {
        UtilityPlayList.add(self.product, text, self, playListButton)
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
        text = ""
        if self.bitmaps.count > 0 {
            self.bitmaps.enumerated().forEach {
                /*var objectImage = ObjectImage(
                    self.stackView,
                    $1,
                    UITapGestureRecognizerWithData($0, self, #selector(imgClicked(sender:)))
                )*/
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
                text += listOfText[$0]
            }
            if self.bitmaps.count == 1 {
                let objectTextView: ObjectTextView
                if tabletInLandscape {
                    objectTextView = ObjectTextView(self.stackView, self.text, widthDivider: 2)
                } else {
                    objectTextView = ObjectTextView(self.stackView, self.text)
                }
                objectTextView.tv.isAccessibilityElement = true
                views.append(objectTextView.tv)
            }
        } else {
            let message = "No active SPC MCDs"
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
