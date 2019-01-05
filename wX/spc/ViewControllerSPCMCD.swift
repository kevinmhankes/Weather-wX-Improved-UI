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
        _ = ObjectScrollStackView(self, scrollView, stackView, toolbar)
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
                self.bitmaps.append(Bitmap(imgUrl))
            }
            DispatchQueue.main.async {
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
        }
    }

    @objc func imgClicked(sender: UITapGestureRecognizerWithData) {
        ActVars.textViewText = self.listOfText[sender.data]
        self.goToVC("textviewer")
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, bitmaps)
    }

    @objc func playClicked() {
        UtilityActions.playClicked(text, synth, playButton)
    }

    @objc func playlistClicked() {
        UtilityPlayList.add(self.product, text, self, playListButton)
    }
}
