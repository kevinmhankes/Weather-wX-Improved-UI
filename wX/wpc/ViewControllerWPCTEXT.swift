/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
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
    var html = "a"
    var playListButton = ObjectToolbarIcon()
    var subMenu = ObjectMenuData(UtilityWPCText.titles, [], UtilityWPCText.labels)
    let synth = AVSpeechSynthesizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        productButton = ObjectToolbarIcon(self, #selector(showProductMenu))
        playButton = ObjectToolbarIcon(self, .play, #selector(playClicked))
        playListButton = ObjectToolbarIcon(self, .playList, #selector(playlistClicked))
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems([doneButton,
                                            flexBarButton,
                                            productButton,
                                            playButton,
                                            shareButton,
                                            playListButton]).items
        _ = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        textView = ObjectTextView(stackView)
        if ActVars.WPCTXTProd == "" {
            product = preferences.getString("WPCTEXT_PARAM_LAST_USED", product)
        } else {
            product = ActVars.WPCTXTProd
            ActVars.WPCTXTProd = ""
        }
        self.getContent()
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
                editor.putString("WPCTEXT_PARAM_LAST_USED", self.product)
            }
        }
    }

    @objc func showProductMenu() {
        let alert = ObjectPopUp(self, "Product Selection", productButton)
        subMenu.objTitles.enumerated().forEach { index, title in
            alert.addAction(UIAlertAction(title.title, {_ in self.showSubMenu(index)}))
        }
        alert.finish()
    }

    func showSubMenu(_ index: Int) {
        let startIdx = ObjectMenuTitle.getStart(subMenu.objTitles, index)
        let count = subMenu.objTitles[index].count
        let title = subMenu.objTitles[index].title
        let alert = ObjectPopUp(self, title, productButton)
        (startIdx..<(startIdx + count)).forEach { idx in
            let strArr = subMenu.paramLabels[idx].split(":")
            alert.addAction(UIAlertAction(strArr[1], { _ in self.productChanged(strArr[0])}))
        }
        alert.finish()
    }

    func productChanged(_ product: String) {
        self.scrollView.scrollToTop()
        self.product = product
        self.getContent()
    }

    @objc func playClicked() {
        UtilityActions.playClicked(textView.view, synth, playButton)
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.share(self, sender, html)
    }

    @objc func playlistClicked() {
        UtilityPlayList.add(self.product, self.html, self, playListButton)
    }
}
