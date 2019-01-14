/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation

class ViewControllerWPCTEXT: UIwXViewController {

    var productButton = ObjectToolbarIcon()
    var playButton = ObjectToolbarIcon()
    var product = "PMDSPD"
    var textView = ObjectTextView()
    var playListButton = ObjectToolbarIcon()
    var subMenu = ObjectMenuData(UtilityWPCText.titles, [], UtilityWPCText.labels)
    let synth = AVSpeechSynthesizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        productButton = ObjectToolbarIcon(self, #selector(showProductMenu))
        playButton = ObjectToolbarIcon(self, .play, #selector(playClicked))
        playListButton = ObjectToolbarIcon(self, .playList, #selector(playlistClicked))
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems(
            [
                doneButton,
                flexBarButton,
                productButton,
                playButton,
                shareButton,
                playListButton
            ]
        ).items
        _ = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        textView = ObjectTextView(stackView)
        if ActVars.wpcTextProduct == "" {
            product = Utility.readPref("WPCTEXT_PARAM_LAST_USED", product)
        } else {
            product = ActVars.wpcTextProduct
            ActVars.wpcTextProduct = ""
        }
        self.getContent()
    }

    func getContent() {
        // qos was .background
        // userInitiated
        // https://www.raywenderlich.com/148513/grand-central-dispatch-tutorial-swift-3-part-1
        // https://developer.apple.com/videos/play/wwdc2016/720/
        DispatchQueue.global(qos: .userInitiated).async {
            let html = UtilityDownload.getTextProduct(self.product)
            DispatchQueue.main.async {
                self.textView.text = html
                self.productButton.title = self.product
                editor.putString("WPCTEXT_PARAM_LAST_USED", self.product)
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
        let code = subMenu.paramLabels[index].split(":")[0]
        self.scrollView.scrollToTop()
        self.product = code
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
}
