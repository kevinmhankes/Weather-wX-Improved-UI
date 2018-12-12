/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
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
        toolbar.items = ObjectToolbarItems([doneButton,
                                            flexBarButton,
                                            stateButton,
                                            playButton,
                                            shareButton,
                                            playlistButton]).items
        _ = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        if ActVars.spcswoDay=="48" {stateButton.title = ""}
        self.getContent()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            if ActVars.spcswoDay=="48" {
                self.product = "SWOD" + ActVars.spcswoDay
                self.html = UtilityDownload.getTextProduct(self.product)
            } else {
                self.product = "SWODY" + ActVars.spcswoDay
                self.html = UtilityDownload.getTextProduct(self.product)
            }
            self.bitmaps = UtilitySPCSWO.getImageUrls(ActVars.spcswoDay)
            DispatchQueue.main.async {
                let objImage = ObjectImage(self.stackView, self.bitmaps[0])
                objImage.addGestureRecognizer(
                    UITapGestureRecognizerWithData(
                        data: 0,
                        target: self,
                        action: #selector(self.imgClicked(sender:))
                    )
                )
                self.textView = ObjectTextView(self.stackView, self.html)
                stride(from: 1, to: self.bitmaps.count, by: 1).forEach {
                    let objImage = ObjectImage(self.stackView, self.bitmaps[$0])
                    objImage.addGestureRecognizer(
                        UITapGestureRecognizerWithData(
                            data: $0,
                            target: self,
                            action: #selector(self.imgClicked(sender:))
                        )
                    )
                }
            }
        }
    }

    @objc func imgClicked(sender: UITapGestureRecognizerWithData) {
        ActVars.IMAGEVIEWERurl = bitmaps[sender.data].url
        self.goToVC("imageviewer")
    }

    @objc func playClicked() {
        UtilityActions.playClicked(textView.view, synth, playButton)
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, bitmaps)
    }

    @objc func playlistClicked() {
        UtilityPlayList.add(self.product, self.html, self, playlistButton)
    }

    @objc func stateClicked() {
        self.goToVC("spcswostate")
    }
}
