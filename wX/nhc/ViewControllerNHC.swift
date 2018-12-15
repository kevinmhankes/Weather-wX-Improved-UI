/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerNHC: UIwXViewController {

    var textprod = "AFD"
    var productButton = ObjectToolbarIcon()
    var imageProductButton = ObjectToolbarIcon()
    var glcfsButton = ObjectToolbarIcon()
    var objNHC: ObjectNHC?

    override func viewDidLoad() {
        super.viewDidLoad()
        productButton = ObjectToolbarIcon(title: " Text Prod", self, #selector(productClicked))
        imageProductButton = ObjectToolbarIcon(title: "Image Prod", self, #selector(imageProductClicked))
        glcfsButton = ObjectToolbarIcon(title: "GLCFS", self, #selector(glcfsClicked))
        toolbar.items = ObjectToolbarItems([doneButton,
                                            flexBarButton,
                                            glcfsButton,
                                            imageProductButton,
                                            productButton]).items
        _ = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        objNHC = ObjectNHC(self, stackView)
        self.getContent()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.objNHC?.getData()
            DispatchQueue.main.async {
                self.objNHC?.showData()
            }
        }
    }

    @objc func productClicked() {
        let alert = ObjectPopUp(self, "Product Selection", productButton)
        UtilityNHC.textProducts.forEach {
            let imageTypeCode = $0.split(":")
            alert.addAction(UIAlertAction(imageTypeCode[1], {_ in self.productChanged(imageTypeCode[0])}))
        }
        alert.finish()
    }

    func productChanged(_ prod: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            let html = UtilityDownload.getTextProduct(prod)
            DispatchQueue.main.async {
                ActVars.TEXTVIEWText = html
                ActVars.TEXTVIEWProd = prod
                self.goToVC("textviewer")
            }
        }
    }

    @objc func imageProductClicked() {
        let alert = ObjectPopUp(self, "Product Selection", productButton)
        UtilityNHC.imageTitles.enumerated().forEach { index, product in
            alert.addAction(UIAlertAction(product, {_ in self.imageProductChanged(UtilityNHC.imageUrls[index])}))
        }
        alert.finish()
    }

    func imageProductChanged(_ url: String) {
        ActVars.IMAGEVIEWERurl = url
        self.goToVC("imageviewer")
    }

    @objc func glcfsClicked() {
        ActVars.modelActivitySelected = "GLCFS"
        self.goToVC("modelgeneric")
    }
}
