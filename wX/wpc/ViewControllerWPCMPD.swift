/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation

class ViewControllerWPCMPD: UIwXViewController {
    
    // TODO FIXME class is deprecated and will be removed

    var bitmaps = [Bitmap]()
    var txtArr = [String]()
    var urls = [String]()
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
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, playButton, shareButton, playListButton]).items
        _ = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        //mpdNumber = ActVars.wpcMpdNumber
        //if mpdNumber != "" {
        //    ActVars.wpcMpdNumber = ""
        //}
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
                self.urls.append(imgUrl)
                self.bitmaps.append(Bitmap(imgUrl))
            }
            DispatchQueue.main.async {
                self.displayContent()
            }
        }
    }

    @objc func imageClicked(sender: UITapGestureRecognizerWithData) {
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
        var tabletInLandscape = UtilityUI.isTablet() && UtilityUI.isLandscape() && self.bitmaps.count == 1
        #if targetEnvironment(macCatalyst)
            tabletInLandscape = self.bitmaps.count == 1
        #endif
        //tabletInLandscape = false
        if tabletInLandscape {
            stackView.axis = .horizontal
            stackView.alignment = .firstBaseline
        }
        if !self.bitmaps.isEmpty {
            self.bitmaps.enumerated().forEach {
                if tabletInLandscape {
                    _ = ObjectImage(
                        self.stackView,
                        $1,
                        UITapGestureRecognizerWithData($0, self, #selector(imageClicked(sender:))),
                        widthDivider: 2
                    )
                } else {
                    _ = ObjectImage(
                        self.stackView,
                        $1,
                        UITapGestureRecognizerWithData($0, self, #selector(imageClicked(sender:)))
                    )
                }
            }
            if self.bitmaps.count == 1 {
                if tabletInLandscape {
                    _ = ObjectTextView(self.stackView, self.text, widthDivider: 2)
                } else {
                    _ = ObjectTextView(self.stackView, self.text)
                }
            }
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
