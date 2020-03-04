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
    private var objectNhc: ObjectNhc?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        objScrollStackView = ObjectScrollStackView(self)
        self.getContent()
    }
    
    override func getContent() {
        self.refreshViews()
        objectNhc = ObjectNhc(self)
        let serial: DispatchQueue = DispatchQueue(label: "joshuatee.wx")
        serial.async {
            self.objectNhc?.getTextData()
            DispatchQueue.main.async {
                self.objectNhc?.showTextData()
            }
        }
        
        NhcOceanEnum.allCases.forEach { type in
            serial.async {
                self.objectNhc?.regionMap[type]!.getImages()
                DispatchQueue.main.async {
                    self.objectNhc?.showImageData(type)
                }
            }
        }
    }
    
    @objc func textProductClicked() {
        _ = ObjectPopUp(
            self,
            "Product Selection",
            textProductButton,
            UtilityNhc.textProductLabels,
            self.textProductChanged(_:)
        )
    }
    
    func textProductChanged(_ index: Int) {
        let vc = vcWpcText()
        vc.wpcTextProduct = UtilityNhc.textProductCodes[index]
        self.goToVC(vc)
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
                self.objectNhc?.showTextData()
                NhcOceanEnum.allCases.forEach { type in
                    self.objectNhc?.showImageData(type)
                }
        }
        )
    }
}
