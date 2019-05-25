/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerNHC: UIwXViewController {

    var textprod = "AFD"
    var textProductButton = ObjectToolbarIcon()
    var imageProductButton = ObjectToolbarIcon()
    var glcfsButton = ObjectToolbarIcon()
    var objNHC: ObjectNhc?

    override func viewDidLoad() {
        super.viewDidLoad()
        textProductButton = ObjectToolbarIcon(title: "Text Prod", self, #selector(textProductClicked))
        imageProductButton = ObjectToolbarIcon(title: "Image Prod", self, #selector(imageProductClicked))
        glcfsButton = ObjectToolbarIcon(title: "GLCFS", self, #selector(glcfsClicked))
        toolbar.items = ObjectToolbarItems(
            [
                doneButton,
                flexBarButton,
                glcfsButton,
                imageProductButton,
                textProductButton
            ]
        ).items
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        objNHC = ObjectNhc(self, stackView)
        self.getContent()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.objNHC?.getData()
            DispatchQueue.main.async {
                self.displayContent()
            }
        }
    }

    @objc func textProductClicked() {
        _ = ObjectPopUp(
            self,
            "Product Selection",
            textProductButton,
            UtilityNhc.textProducts,
            self.textProductChanged(_:)
        )
    }

    func textProductChanged(_ prod: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            let html = UtilityDownload.getTextProduct(prod)
            DispatchQueue.main.async {
                ActVars.textViewText = html
                ActVars.textViewProduct = prod
                self.goToVC("textviewer")
            }
        }
    }

    @objc func imageProductClicked() {
        _ = ObjectPopUp(
            self,
            "Product Selection",
            imageProductButton,
            UtilityNhc.imageTitles,
            self.imageProductChanged(_:)
        )
    }

    func imageProductChanged(_ index: Int) {
        ActVars.imageViewerUrl = UtilityNhc.imageUrls[index]
        self.goToVC("imageviewer")
    }

    @objc func glcfsClicked() {
        ActVars.modelActivitySelected = "GLCFS"
        self.goToVC("modelgeneric")
    }

    private func displayContent() {
        self.objNHC?.showData()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: nil,
            completion: { _ -> Void in
                self.refreshViews()
                self.objNHC?.updateParents(self, self.stackView)
                self.displayContent()
            }
        )
    }
}
