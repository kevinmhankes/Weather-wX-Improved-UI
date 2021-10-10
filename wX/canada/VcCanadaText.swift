// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class VcCanadaText: UIwXViewControllerWithAudio {

    private var productButton = ToolbarIcon()
    private let prefToken = "CA_TEXT_LASTUSED"

    override func viewDidLoad() {
        super.viewDidLoad()
        product = "FOCN45"
        productButton = ToolbarIcon(self, #selector(productClicked))
        let shareButton = ToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ToolbarItems([
            doneButton,
            GlobalVariables.flexBarButton,
            productButton,
            playButton,
            playListButton,
            shareButton
        ]).items
        objScrollStackView = ScrollStackView(self)
        objectTextView = Text(stackView)
        objectTextView.constrain(scrollView)
        _ = ObjectCanadaLegal(stackView.get())
        product = Utility.readPref(prefToken, product)
        getContent()
    }

    override func getContent() {
        productButton.title = product
        Utility.writePref(prefToken, product)
        _ = FutureText2({ UtilityDownload.getTextProduct(self.product.uppercased()) }, objectTextView.setText)
    }

    @objc func productClicked() {
        _ = ObjectPopUp(self, productButton, UtilityCanada.products, productChanged)
    }

    func productChanged(_ product: String) {
        self.product = product
        UtilityAudio.resetAudio(self)
        playButton.setImage(.play)
        getContent()
    }

    override func shareClicked(sender: UIButton) {
        UtilityShare.share(self, sender, objectTextView.text)
    }
}
