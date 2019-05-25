/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation

class ViewControllerSPCSWOV2: UIwXViewController {

    var bitmaps = [Bitmap]()
    var html = ""
    var product = ""
    var playButton = ObjectToolbarIcon()
    var playlistButton = ObjectToolbarIcon()
    var textView = ObjectTextView()
    let synth = AVSpeechSynthesizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        playButton = ObjectToolbarIcon(self, .play, #selector(playClicked))
        playlistButton = ObjectToolbarIcon(self, .playList, #selector(playlistClicked))
        let stateButton = ObjectToolbarIcon(title: "STATE", self, #selector(stateClicked))
        toolbar.items = ObjectToolbarItems(
            [
                doneButton,
                flexBarButton,
                stateButton,
                playButton,
                shareButton,
                playlistButton
            ]
        ).items
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        if ActVars.spcswoDay == "48" {
            stateButton.title = ""
        }
        self.getContent()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            if ActVars.spcswoDay == "48" {
                self.product = "SWOD" + ActVars.spcswoDay
                self.html = UtilityDownload.getTextProduct(self.product)
            } else {
                self.product = "SWODY" + ActVars.spcswoDay
                self.html = UtilityDownload.getTextProduct(self.product)
            }
            self.bitmaps = UtilitySpcSwo.getImageUrls(ActVars.spcswoDay)
            DispatchQueue.main.async {
               self.displayContent()
            }
        }
    }

    @objc func imgClicked(sender: UITapGestureRecognizerWithData) {
        ActVars.imageViewerUrl = bitmaps[sender.data].url
        self.goToVC("imageviewer")
    }

    @objc func playClicked() {
        UtilityActions.playClicked(textView.view, synth, playButton)
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, bitmaps, self.html)
    }

    @objc func playlistClicked() {
        UtilityPlayList.add(self.product, self.html, self, playlistButton)
    }

    @objc func stateClicked() {
        self.goToVC("spcswostate")
    }

    private func displayContent() {
        _ = ObjectImage(
            self.stackView,
            self.bitmaps[0],
            UITapGestureRecognizerWithData(0, self, #selector(imgClicked(sender:)))
        )
        self.textView = ObjectTextView(self.stackView, self.html)
        stride(from: 1, to: self.bitmaps.count, by: 1).forEach {
            _ = ObjectImage(
                self.stackView,
                self.bitmaps[$0],
                UITapGestureRecognizerWithData($0, self, #selector(imgClicked(sender:)))
            )
        }
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
