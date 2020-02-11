/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation

class vcWpcRainfallDiscussion: UIwXViewController, AVSpeechSynthesizerDelegate {

    var bitmaps = [Bitmap]()
    var listOfText = [String]()
    var urls = [String]()
    var playListButton = ObjectToolbarIcon()
    var playButton = ObjectToolbarIcon()
    var spcMcdNumber = ""
    var text = ""
    var synth = AVSpeechSynthesizer()
    var product = ""
    var wpcRainfallDay = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        synth.delegate = self
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        playButton = ObjectToolbarIcon(self, .play, #selector(playClicked))
        playListButton = ObjectToolbarIcon(self, .playList, #selector(playlistClicked))
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, playButton, shareButton, playListButton]).items
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        self.getContent()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            let number = Int(self.wpcRainfallDay)! - 1
            let imgUrl = UtilityWpcRainfallOutlook.urls[number]
            self.product = UtilityWpcRainfallOutlook.productCode[number]
            self.text = UtilityDownload.getTextProduct(self.product)
            self.listOfText.append(self.text)
            self.urls.append(imgUrl)
            self.bitmaps.append(Bitmap(imgUrl))
            DispatchQueue.main.async {
                self.displayContent()
            }
        }
    }

    @objc override func doneClicked() {
        UtilityActions.resetAudio(&synth, playButton)
        super.doneClicked()
    }

    @objc func imageClicked(sender: UITapGestureRecognizerWithData) {
        let number = Int(wpcRainfallDay)! - 1
        ActVars.imageViewerUrl = UtilityWpcRainfallOutlook.urls[number]
        let vc = vcImageViewer()
        self.goToVC(vc)
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

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            UtilityActions.resetAudio(&self.synth, self.playButton)
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
        text = ""
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
            text += listOfText[$0]
        }
        let objectTextView: ObjectTextView
        if tabletInLandscape {
            objectTextView = ObjectTextView(self.stackView, self.text, widthDivider: 2)
        } else {
            objectTextView = ObjectTextView(self.stackView, self.text)
        }
        objectTextView.tv.isAccessibilityElement = true
        views.append(objectTextView.tv)
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
