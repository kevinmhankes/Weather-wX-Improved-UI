/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcNhc: UIwXViewController {

    private var textprod = "AFD"
    private var textProductButton = ObjectToolbarIcon()
    private var imageProductButton = ObjectToolbarIcon()
    private var glcfsButton = ObjectToolbarIcon()
    private var objNHC: ObjectNhc?

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
        objNHC = ObjectNhc(self, scrollView, stackView)
        let serial: DispatchQueue = DispatchQueue(label: "joshuatee.wx")
        serial.async {
            self.objNHC?.getTextData()
            DispatchQueue.main.async {
                self.objNHC?.showTextData()
            }
        }
        serial.async {
            self.objNHC?.getAtlanticImageData()
            DispatchQueue.main.async {
                self.objNHC?.showImageData(self.objNHC!.bitmapsAtlantic, self.objNHC!.imageUrlsAtlanic)
            }
        }
        serial.async {
            self.objNHC?.getPacificImageData()
            DispatchQueue.main.async {
                self.objNHC?.showImageData(self.objNHC!.bitmapsPacific, self.objNHC!.imageUrlsPacific)
            }
        }
        serial.async {
            self.objNHC?.getCentralImageData()
            DispatchQueue.main.async {
                self.objNHC?.showImageData(self.objNHC!.bitmapsCentral, self.objNHC!.imageUrlsCentral)
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
    
    @objc func imageClicked(sender: UITapGestureRecognizerWithData) {
        let vc = vcImageViewer()
        vc.imageViewerUrl = sender.strData
        self.goToVC(vc)
    }

    func imageProductChanged(_ index: Int) {
        let vc = vcImageViewer()
        vc.imageViewerUrl = UtilityNhc.imageUrls[index]
        self.goToVC(vc)
    }

    @objc func glcfsClicked() {
        let vc = vcModels()
        vc.modelActivitySelected = "GLCFS"
        self.goToVC(vc)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: nil,
            completion: { _ -> Void in
                self.refreshViews()
                self.objNHC?.updateParents(self, self.stackView)
                self.objNHC?.showTextData()
                self.objNHC?.showImageData(self.objNHC!.bitmapsAtlantic, self.objNHC!.imageUrlsAtlanic)
                self.objNHC?.showImageData(self.objNHC!.bitmapsPacific, self.objNHC!.imageUrlsPacific)
                self.objNHC?.showImageData(self.objNHC!.bitmapsCentral, self.objNHC!.imageUrlsCentral)
            }
        )
    }
}
