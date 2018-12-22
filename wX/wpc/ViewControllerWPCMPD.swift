/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation

class ViewControllerWPCMPD: UIwXViewController {

    var bitmaps = [Bitmap]()
    var txtArr = [String]()
    var mpdNumber = ""
    var text = ""
    var product = ""
    var playListButton = ObjectToolbarIcon()
    var playButton = ObjectToolbarIcon()
    let synth = AVSpeechSynthesizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        playButton = ObjectToolbarIcon(self, .play, #selector(playClicked))
        playListButton = ObjectToolbarIcon(self, .playList, #selector(playlistClicked))
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, playButton, shareButton, playListButton]).items
        _ = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        mpdNumber = ActVars.WPCMPDNo
        if mpdNumber != "" {
            ActVars.WPCMPDNo = ""
        }
        self.getContent()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            var mpdList = [String]()
            if self.mpdNumber == "" {
                let dataAsString = (MyApplication.nwsWPCwebsitePrefix + "/metwatch/metwatch_mpd.php").getHtml()
                mpdList = dataAsString.parseColumn(">MPD #(.*?)</a></strong>")
            } else {
                mpdList = [self.mpdNumber]
            }
            mpdList.forEach {
                let imgUrl = MyApplication.nwsWPCwebsitePrefix + "/metwatch/images/mcd" + $0 + ".gif"
                self.product = "WPCMPD" + $0
                self.text = UtilityDownload.getTextProduct(self.product)
                self.txtArr.append(self.text)
                self.bitmaps.append(Bitmap(imgUrl))
            }
            DispatchQueue.main.async {
                if !self.bitmaps.isEmpty {
                    self.bitmaps.enumerated().forEach {
                        let imgObject = ObjectImage(self.stackView, $1)
                        imgObject.addGestureRecognizer(
                            UITapGestureRecognizerWithData($0, self, #selector(self.imgClicked(sender:)))
                        )
                    }
                    if self.bitmaps.count == 1 {
                        _ = ObjectTextView(self.stackView, self.text)
                    }
                }
                self.view.bringSubview(toFront: self.toolbar)
            }
        }
    }

    @objc func imgClicked(sender: UITapGestureRecognizerWithData) {
        ActVars.TEXTVIEWText = self.txtArr[sender.data]
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
}
