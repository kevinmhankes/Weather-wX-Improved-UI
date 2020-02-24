/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation

class vcWpcText: UIwXViewController, AVSpeechSynthesizerDelegate {

    private var productButton = ObjectToolbarIcon()
    private var playButton = ObjectToolbarIcon()
    private var product = "PMDSPD"
    private var textView = ObjectTextView()
    private var playListButton = ObjectToolbarIcon()
    private var subMenu = ObjectMenuData(UtilityWpcText.titles, UtilityWpcText.labelsWithCodes, UtilityWpcText.labels)
    private var synth = AVSpeechSynthesizer()
    private var html = ""
    var wpcTextProduct = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = true
        synth.delegate = self
        productButton = ObjectToolbarIcon(self, #selector(showProductMenu))
        playButton = ObjectToolbarIcon(self, .play, #selector(playClicked))
        playListButton = ObjectToolbarIcon(self, .playList, #selector(playlistClicked))
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems(
            [
                doneButton,
                GlobalVariables.flexBarButton,
                productButton,
                playButton,
                playListButton,
                shareButton
            ]
        ).items
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        textView = ObjectTextView(stackView)
        textView.tv.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
        if wpcTextProduct == "" {
            product = Utility.readPref("WPCTEXT_PARAM_LAST_USED", product)
        } else {
            product = wpcTextProduct
            wpcTextProduct = ""
        }
        self.getContent()
    }

    @objc override func doneClicked() {
       UIApplication.shared.isIdleTimerDisabled = false
       UtilityActions.resetAudio(&synth, playButton)
       super.doneClicked()
    }

    func getContent() {
        // qos was .background
        // userInitiated
        // https://www.raywenderlich.com/148513/grand-central-dispatch-tutorial-swift-3-part-1
        // https://developer.apple.com/videos/play/wwdc2016/720/
        DispatchQueue.global(qos: .userInitiated).async {
            self.html = UtilityDownload.getTextProduct(self.product)
            DispatchQueue.main.async {
                self.textView.text = self.html
                self.productButton.title = self.product
                Utility.writePref("WPCTEXT_PARAM_LAST_USED", self.product)
            }
        }
    }

    @objc func showProductMenu() {
        _ = ObjectPopUp(self, "Product Selection", productButton, subMenu.objTitles, self.showSubMenu(_:))
    }

    func showSubMenu(_ index: Int) {
        _ = ObjectPopUp(self, productButton, subMenu.objTitles, index, subMenu, self.productChanged(_:))
    }

    func productChanged(_ index: Int) {
        let code = subMenu.params[index].split(":")[0]
        self.scrollView.scrollToTop()
        self.product = code
        UtilityActions.resetAudio(&synth, playButton)
        self.getContent()
    }

    @objc func playClicked() {
        UtilityActions.playClicked(textView.view, synth, playButton)
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.share(self, sender, textView.text)
    }

    @objc func playlistClicked() {
        UtilityPlayList.add(self.product, textView.text, self, playListButton)
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        DispatchQueue.main.async {
            UtilityActions.resetAudio(&self.synth, self.playButton)
        }
    }
}
