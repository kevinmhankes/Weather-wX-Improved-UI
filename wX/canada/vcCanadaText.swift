/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class vcCanadaText: UIwXViewControllerWithAudio {
    
    private var productButton = ObjectToolbarIcon()
    private var siteButton = ObjectToolbarIcon()
    private let prefToken = "CA_TEXT_LASTUSED"
    
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
        _ = ObjectCanadaLegal(stackView)
        product = Utility.readPref(prefToken, product)
        self.getContent()
    }
    
    override func getContent() {
        self.productButton.title = self.product
        Utility.writePref(prefToken, self.product)
        DispatchQueue.global(qos: .userInitiated).async {
            // FIXME fix upstream data to uppercase
            let html = UtilityDownload.getTextProduct(self.product.uppercased())
            DispatchQueue.main.async { self.display(html) }
        }
    }
    
    private func display(_ html: String) {
        self.objectTextView.text = html
    }
    
    @objc func productClicked() {
        _ = ObjectPopUp(self, productButton, UtilityCanada.products, self.productChanged(_:))
    }
    
    func productChanged(_ product: String) {
        self.product = product
        UtilityAudio.resetAudio(self, playButton)
        self.getContent()
    }
    
    @objc override func shareClicked(sender: UIButton) {
        UtilityShare.share(self, sender, objectTextView.text)
    }
}
