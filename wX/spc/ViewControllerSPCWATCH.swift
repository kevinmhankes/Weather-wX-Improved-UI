/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation

class ViewControllerSPCWATCH: UIwXViewController {

    var bitmaps = [Bitmap]()
    var listOfText = [String]()
    var spcWatchNumber = ""
    //var playListButton = ObjectToolbarIcon()
    var playButton = ObjectToolbarIcon()
    var text = ""
    let synth = AVSpeechSynthesizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        playButton = ObjectToolbarIcon(self, .play, #selector(playClicked))
        //playListButton = ObjectToolbarIcon(self, .playList, #selector(playlistClicked))
        spcWatchNumber = ActVars.spcWatchNumber
        if spcWatchNumber != "" {
            ActVars.spcWatchNumber = ""
        }
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, playButton, shareButton]).items
        _ = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        self.getContent()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            var mcdList = [String]()
            var mcdTxt = ""
            if self.spcWatchNumber == "" {
                let dataAsString = (MyApplication.nwsSPCwebsitePrefix + "/products/watch/").getHtml()
                mcdList = dataAsString.parseColumn("[om] Watch #([0-9]*?)</a>")
            } else {
                mcdList = [self.spcWatchNumber]
            }
            mcdList.forEach {
                let number = String(format: "%04d", Int($0) ?? 0)
                let imgUrl = MyApplication.nwsSPCwebsitePrefix + "/products/watch/ww" + number + "_radar.gif"
                mcdTxt = UtilityDownload.getTextProduct("SPCWAT" + number)
                self.listOfText.append(mcdTxt)
                self.bitmaps.append(Bitmap(imgUrl))
            }
            DispatchQueue.main.async {
                var views = [UIView]()
                if self.bitmaps.count > 0 {
                    self.bitmaps.enumerated().forEach {
                        let objectImage = ObjectImage(
                            self.stackView,
                            $1,
                            UITapGestureRecognizerWithData($0, self, #selector(self.imgClicked(sender:)))
                        )
                        self.text += self.listOfText[$0]
                        objectImage.img.isAccessibilityElement = true
                        views += [objectImage.img]
                        //print(self.listOfText[$0])
                        let number = self.listOfText[$0].parse("Severe Thunderstorm Watch Number ([0-9]*)\\b")
                        objectImage.img.accessibilityLabel = number + " " + self.listOfText[$0].parse("Severe Thunderstorm Watch for (.*?)\n")
                    }
                    if self.bitmaps.count == 1 {
                        _ = ObjectTextView(self.stackView, mcdTxt)
                    }
                } else {
                    let message = "No active watches"
                    let objectTextView = ObjectTextView(self.stackView, message)
                    objectTextView.tv.isAccessibilityElement = true
                    views += [objectTextView.tv]
                    objectTextView.tv.accessibilityLabel = message
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

    //@objc func playlistClicked() {
    //    UtilityPlayList.add(self.product, text, self, playListButton)
    //}
}
