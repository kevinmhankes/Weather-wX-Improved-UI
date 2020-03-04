/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcCanadaText: UIwXViewControllerWithAudio {
    
    private var productButton = ObjectToolbarIcon()
    private var siteButton = ObjectToolbarIcon()
    private var html = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        product = "FOCN45"
        productButton = ObjectToolbarIcon(self, #selector(productClicked))
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
        objScrollStackView = ObjectScrollStackView(self)
        objectTextView = ObjectTextView(stackView)
        objectTextView.constrain(scrollView)
        _ = ObjectCALegal(stackView)
        product = Utility.readPref("CA_TEXT_LASTUSED", product)
        self.getContent()
    }
    
    override func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            // FIXME fix upstream data to uppercase
            self.html = UtilityDownload.getTextProduct(self.product.uppercased())
            DispatchQueue.main.async {
                self.displayContent()
            }
        }
    }
    
    @objc func productClicked() {
        _ = ObjectPopUp(self, "Product Selection", productButton, UtilityCanada.products, self.productChanged(_:))
    }
    
    func productChanged(_ product: String) {
        self.product = product
        UtilityAudio.resetAudio(&synth, playButton)
        self.getContent()
    }
    
    @objc override func shareClicked(sender: UIButton) {
        UtilityShare.share(self, sender, html)
    }
    
    private func displayContent() {
        if self.html == "" {
            self.html = "None issused by this office recently."
        }
        self.objectTextView.text = self.html
        self.productButton.title = self.product
        Utility.writePref("CA_TEXT_LASTUSED", self.product)
    }
}
