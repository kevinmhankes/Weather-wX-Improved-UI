/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation

class vcSpcSwo: UIwXViewController, AVSpeechSynthesizerDelegate {
    
    private var bitmaps = [Bitmap]()
    private var html = ""
    private var product = ""
    private var playButton = ObjectToolbarIcon()
    private var playlistButton = ObjectToolbarIcon()
    private var textView = ObjectTextView()
    private var synth = AVSpeechSynthesizer()
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
    
    @objc func imageClicked(sender: UITapGestureRecognizerWithData) {
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
        var imageCount = 0
        var imagesPerRow = 2
        var imageStackViewList = [ObjectStackView]()
        if UtilityUI.isTablet() && UtilityUI.isLandscape() {
            imagesPerRow = 4
        }
        #if targetEnvironment(macCatalyst)
            imagesPerRow = 4
        #endif
        self.bitmaps.enumerated().forEach { imageIndex, image in
            let stackView: UIStackView
            if imageCount % imagesPerRow == 0 {
                let objectStackView = ObjectStackView(UIStackView.Distribution.fillEqually, NSLayoutConstraint.Axis.horizontal)
                imageStackViewList.append(objectStackView)
                stackView = objectStackView.view
                self.stackView.addArrangedSubview(stackView)
            } else {
                stackView = imageStackViewList.last!.view
            }
            _ = ObjectImage(
                stackView,
                image,
                UITapGestureRecognizerWithData(imageIndex, self, #selector(imageClicked(sender:))),
                widthDivider: imagesPerRow
            )
            imageCount += 1
        }
        var views = [UIView]()
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
