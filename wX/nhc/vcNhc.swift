/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcNhc: UIwXViewController {

    var textprod = "AFD"
    var textProductButton = ObjectToolbarIcon()
    var imageProductButton = ObjectToolbarIcon()
    var glcfsButton = ObjectToolbarIcon()
    var objNHC: ObjectNhc?

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        textProductButton = ObjectToolbarIcon(title: "Text Prod", self, #selector(textProductClicked))
        imageProductButton = ObjectToolbarIcon(title: "Image Prod", self, #selector(imageProductClicked))
        glcfsButton = ObjectToolbarIcon(title: "GLCFS", self, #selector(glcfsClicked))
        toolbar.items = ObjectToolbarItems(
            [
                doneButton,
                GlobalVariables.flexBarButton,
                glcfsButton,
                imageProductButton,
                textProductButton
            ]
        ).items
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        self.getContent()
    }

    @objc func willEnterForeground() {
        self.getContent()
    }

    func getContent() {
        refreshViews()
        objNHC = ObjectNhc(self, stackView)
        let serial: DispatchQueue = DispatchQueue(label: "joshuatee.wx")
        serial.async {
            self.objNHC?.getTextData()
            DispatchQueue.main.async {
                self.displayTextContent()
            }
        }
        serial.async {
            self.objNHC?.getAtlanticImageData()
            DispatchQueue.main.async {
                self.displayAtlanticImageContent()
            }
        }
        serial.async {
            self.objNHC?.getPacificImageData()
            DispatchQueue.main.async {
                self.displayPacificImageContent()
            }
        }
        serial.async {
            self.objNHC?.getCentralImageData()
            DispatchQueue.main.async {
                self.displayCentralImageContent()
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
                let vc = vcTextViewer()
                vc.textViewText = html
                vc.textViewProduct = prod
                self.goToVC(vc)
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
        let vc = vcImageViewer()
        vc.imageViewerUrl = UtilityNhc.imageUrls[index]
        self.goToVC(vc)
    }

    @objc func glcfsClicked() {
        ActVars.modelActivitySelected = "GLCFS"
        let vc = vcModels()
        self.goToVC(vc)
    }

    private func displayTextContent() {
        self.objNHC?.showTextData()
    }

    private func displayAtlanticImageContent() {
        self.objNHC?.showAtlanticImageData()
    }

    private func displayPacificImageContent() {
        self.objNHC?.showPacificImageData()
    }

    private func displayCentralImageContent() {
        self.objNHC?.showCentralImageData()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: nil,
            completion: { _ -> Void in
                self.refreshViews()
                self.objNHC?.updateParents(self, self.stackView)
                self.displayTextContent()
                self.displayAtlanticImageContent()
                self.displayPacificImageContent()
                self.displayCentralImageContent()
            }
        )
    }
}
