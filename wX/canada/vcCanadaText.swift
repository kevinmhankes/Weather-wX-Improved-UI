/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation

class vcCanadaText: UIwXViewController {
    
    private var product = "FOCN45"
    private var objectTextView = ObjectTextView()
    private var productButton = ObjectToolbarIcon()
    private var siteButton = ObjectToolbarIcon()
    private var html = ""
    private var playButton = ObjectToolbarIcon()
    private var playlistButton = ObjectToolbarIcon()
    private let synth = AVSpeechSynthesizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productButton = ObjectToolbarIcon(self, #selector(productClicked))
        playButton = ObjectToolbarIcon(self, .play, #selector(playClicked))
        playlistButton = ObjectToolbarIcon(self, .playList, #selector(playlistClicked))
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems(
            [
                doneButton,
                GlobalVariables.flexBarButton,
                productButton,
                playButton,
                shareButton,
                playlistButton
            ]
        ).items
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        product = Utility.readPref("CA_TEXT_LASTUSED", product)
        self.getContent()
    }
    
    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            // FIXME fix upstream data to uppercase
            self.html = UtilityDownload.getTextProduct(self.product.uppercased())
            DispatchQueue.main.async {
                self.displayContent()
            }
        }
    }
    
    @objc func playClicked() {
        UtilityActions.playClicked(objectTextView.view, synth, playButton)
    }
    
    @objc func productClicked() {
        _ = ObjectPopUp(self, "Product Selection", productButton, UtilityCanada.products, self.productChanged(_:))
    }
    
    func productChanged(_ product: String) {
        self.product = product
        self.getContent()
    }
    
    @objc func shareClicked(sender: UIButton) {
        UtilityShare.share(self, sender, html)
    }
    
    @objc func playlistClicked() {
        UtilityPlayList.add(self.product, self.html, self, playlistButton)
    }
    
    private func displayContent() {
        self.refreshViews()
        objectTextView = ObjectTextView(stackView)
        objectTextView.tv.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
        _ = ObjectCALegal(stackView)
        if self.html == "" {
            self.html = "None issused by this office recently."
        }
        self.objectTextView.text = self.html
        self.productButton.title = self.product
        Utility.writePref("CA_TEXT_LASTUSED", self.product)
    }
}
