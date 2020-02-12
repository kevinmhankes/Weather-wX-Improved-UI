/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation

class vcSpcSwo: UIwXViewController, AVSpeechSynthesizerDelegate {

    var bitmaps = [Bitmap]()
    var html = ""
    var product = ""
    var playButton = ObjectToolbarIcon()
    var playlistButton = ObjectToolbarIcon()
    var textView = ObjectTextView()
    var synth = AVSpeechSynthesizer()
    var spcSwoDay = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        synth.delegate = self
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        let statusButton = ObjectToolbarIcon(title: "Day " + spcSwoDay, self, nil)
        playButton = ObjectToolbarIcon(self, .play, #selector(playClicked))
        playlistButton = ObjectToolbarIcon(self, .playList, #selector(playlistClicked))
        let stateButton = ObjectToolbarIcon(title: "STATE", self, #selector(stateClicked))
        toolbar.items = ObjectToolbarItems(
            [
                doneButton,
                statusButton,
                GlobalVariables.flexBarButton,
                stateButton,
                playButton,
                playlistButton,
                shareButton
            ]
        ).items
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        if spcSwoDay == "48" {
            stateButton.title = ""
        }
        self.getContent()
    }

    @objc override func doneClicked() {
        UtilityActions.resetAudio(&synth, playButton)
        super.doneClicked()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            if self.spcSwoDay == "48" {
                self.product = "SWOD" + self.spcSwoDay
                self.html = UtilityDownload.getTextProduct(self.product)
            } else {
                self.product = "SWODY" + self.spcSwoDay
                self.html = UtilityDownload.getTextProduct(self.product)
            }
            self.bitmaps = UtilitySpcSwo.getImageUrls(self.spcSwoDay)
            DispatchQueue.main.async {
               self.displayContent()
            }
        }
    }

    @objc func imgClicked(sender: UITapGestureRecognizerWithData) {
        let vc = vcImageViewer()
        vc.imageViewerUrl = bitmaps[sender.data].url
        self.goToVC(vc)
    }

    @objc func playClicked() {
        UtilityActions.playClicked(textView.view, synth, playButton)
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            UtilityActions.resetAudio(&self.synth, self.playButton)
        }
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, bitmaps, self.html)
    }

    @objc func playlistClicked() {
        UtilityPlayList.add(self.product, self.html, self, playlistButton)
    }

    @objc func stateClicked() {
        let vc = vcSpcSwoState()
        vc.day = spcSwoDay
        self.goToVC(vc)
    }

    private func displayContent() {
        let imagesPerRow = 2
        var imageStackViewList = [ObjectStackView]()
        [0, 1, 2, 3].forEach {
            imageStackViewList.append(
                ObjectStackView(
                    UIStackView.Distribution.fill,
                    NSLayoutConstraint.Axis.horizontal
                )
            )
            self.stackView.addArrangedSubview(imageStackViewList[$0].view)
        }
        var views = [UIView]()
        stride(from: 0, to: self.bitmaps.count, by: 1).forEach {
            let objectImage = ObjectImage(
                imageStackViewList[$0 / imagesPerRow].view,
                self.bitmaps[$0],
                UITapGestureRecognizerWithData($0, self, #selector(imgClicked(sender:))),
                widthDivider: imagesPerRow
            )
            objectImage.img.accessibilityLabel = "Outlook image"
            objectImage.img.isAccessibilityElement = true
            views.append(objectImage.img)
        }
        self.textView = ObjectTextView(self.stackView, self.html)
        textView.tv.isAccessibilityElement = true
        views.append(textView.tv)
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
