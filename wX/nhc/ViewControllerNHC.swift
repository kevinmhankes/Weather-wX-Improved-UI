/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerNHC: UIwXViewController {

    var textprod = "AFD"
    var textProductButton = ObjectToolbarIcon()
    var imageProductButton = ObjectToolbarIcon()
    var glcfsButton = ObjectToolbarIcon()
    var objNHC: ObjectNHC?

    override func viewDidLoad() {
        super.viewDidLoad()
        textProductButton = ObjectToolbarIcon(title: "Text Prod", self, #selector(textProductClicked))
        imageProductButton = ObjectToolbarIcon(title: "Image Prod", self, #selector(imageProductClicked))
        glcfsButton = ObjectToolbarIcon(title: "GLCFS", self, #selector(glcfsClicked))
        toolbar.items = ObjectToolbarItems([doneButton,
                                            flexBarButton,
                                            glcfsButton,
                                            imageProductButton,
                                            textProductButton]).items
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

    @objc func textProductClicked() {
        _ = ObjectPopUp(self,
                        "Product Selection",
                        textProductButton,
                        UtilityNHC.textProducts,
                        self.textProductChanged(_:)
        )
    }

    func textProductChanged(_ prod: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            let html = UtilityDownload.getTextProduct(prod)
            DispatchQueue.main.async {
                ActVars.TEXTVIEWText = html
                ActVars.TEXTVIEWProd = prod
                self.goToVC("textviewer")
            }
        }
    }

    // FIXME method should have arg as UIButton so that button can be genericall specified
    @objc func imageProductClicked() {
        _ = ObjectPopUp(self,
                        "Product Selection",
                        imageProductButton,
                        UtilityNHC.imageTitles,
                        self.imageProductChanged(_:)
        )
    }

    func imageProductChanged(_ index: Int) {
        ActVars.IMAGEVIEWERurl = UtilityNHC.imageUrls[index]
        self.goToVC("imageviewer")
    }

    @objc func glcfsClicked() {
        ActVars.modelActivitySelected = "GLCFS"
        self.goToVC("modelgeneric")
    }
}
