/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcWpcText: UIwXViewControllerWithAudio {
    
    private var productButton = ObjectToolbarIcon()
    private var subMenu = ObjectMenuData(UtilityWpcText.titles, UtilityWpcText.labelsWithCodes, UtilityWpcText.labels)
    private var html = ""
    var wpcTextProduct = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        product = "PMDSPD"
        UIApplication.shared.isIdleTimerDisabled = true
        productButton = ObjectToolbarIcon(self, #selector(showProductMenu))
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
        super.doneClicked()
    }
    
    override func getContent() {
        // qos was .background
        // userInitiated
        // https://www.raywenderlich.com/148513/grand-central-dispatch-tutorial-swift-3-part-1
        // https://developer.apple.com/videos/play/wwdc2016/720/
        DispatchQueue.global(qos: .userInitiated).async {
            // FIXME fix upstream data source to uppercase
            self.html = UtilityDownload.getTextProduct(self.product.uppercased())
            DispatchQueue.main.async {
                self.objectTextView.text = self.html
                
                if UtilityWpcText.needsFixedWidthFont(self.product.uppercased()) {
                    self.objectTextView.font = FontSize.hourly.size
                } else {
                    self.objectTextView.font = FontSize.medium.size
                }
                
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
        UtilityAudio.resetAudio(&synth, playButton)
        self.getContent()
    }
}
