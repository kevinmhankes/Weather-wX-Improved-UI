/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation

class ViewControllerSPCMCD: UIwXViewController {

    var bitmaps = [Bitmap]()
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
        spcMcdNumber = ActVars.spcMcdNumber
        if spcMcdNumber != "" {
            ActVars.spcMcdNumber = ""
        }
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, playButton, shareButton, playListButton]).items
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
            }
            DispatchQueue.main.async {
                self.displayContent()
            }
        }
    }

    @objc func imgClicked(sender: UITapGestureRecognizerWithData) {
        ActVars.imageViewerUrl = self.urls[sender.data]
        self.goToVC("imageviewer")
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
        if self.bitmaps.count > 0 {
            self.bitmaps.enumerated().forEach {
                let objImage = ObjectImage(self.stackView, $1)
                objImage.addGestureRecognizer(
                    UITapGestureRecognizerWithData($0, self, #selector(self.imgClicked(sender:)))
                )
            }
            if self.bitmaps.count == 1 {
                _ = ObjectTextView(self.stackView, self.text)
            }
        } else {
            _ = ObjectTextView(self.stackView, "No active SPC MCDs")
        }
        self.view.bringSubviewToFront(self.toolbar)
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
