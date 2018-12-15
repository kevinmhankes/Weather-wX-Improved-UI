/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerSPCMESO: UIwXViewController {

    var image = ObjectTouchImageView()
    var sectorButton = ObjectToolbarIcon()
    var sfcButton = ObjectToolbarIcon()
    var uaButton = ObjectToolbarIcon()
    var cpeButton = ObjectToolbarIcon()
    var cmpButton = ObjectToolbarIcon()
    var shrButton = ObjectToolbarIcon()
    var layerButton = ObjectToolbarIcon()
    var paramButton = ObjectToolbarIcon()
    var animateButton = ObjectToolbarIcon()
    var product = "500mb"
    var sector = "19"
    var prefModel = "SPCMESO"
    let numPanesStr = "1"
    var firstRun = true
    let subMenu = ObjectMenuData(UtilitySPCMESO.titles, UtilitySPCMESO.params, UtilitySPCMESO.labels)

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willEnterForeground),
                                               name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        let toolbarTop = ObjectToolbar(.top)
        layerButton = ObjectToolbarIcon(title: "Layers", self, #selector(self.layerClicked))
        animateButton = ObjectToolbarIcon(self, .play, #selector(animateClicked))
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        paramButton = ObjectToolbarIcon(self, #selector(showProductMenu))
        toolbarTop.items = ObjectToolbarItems([flexBarButton,
                                               paramButton,
                                               fixedSpace,
                                               layerButton,
                                               fixedSpace,
                                               animateButton,
                                               fixedSpace,
                                               shareButton]).items
        sectorButton = ObjectToolbarIcon(title: "Sector", self, #selector(sectorClicked))
        sfcButton = ObjectToolbarIcon(title: "SFC", self, #selector(paramClicked))
        uaButton = ObjectToolbarIcon(title: "UA", self, #selector(paramClicked))
        cpeButton = ObjectToolbarIcon(title: "CPE", self, #selector(paramClicked))
        cmpButton = ObjectToolbarIcon(title: "CMP", self, #selector(paramClicked))
        shrButton = ObjectToolbarIcon(title: "SHR", self, #selector(paramClicked))
        toolbar.items = ObjectToolbarItems([doneButton,
                                            flexBarButton,
                                            sfcButton,
                                            uaButton,
                                            cpeButton,
                                            cmpButton,
                                            shrButton,
                                            sectorButton]).items
        image = ObjectTouchImageView(self, toolbar)
        image.addGestureRecognizer(#selector(handleSwipes(sender:)))
        self.view.addSubview(toolbarTop)
        self.view.addSubview(toolbar)
        product = preferences.getString(prefModel + numPanesStr + "_PARAM_LAST_USED", product)
        sectorChanged(preferences.getString(prefModel + numPanesStr + "_SECTOR_LAST_USED", sector))
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            let bitmap = UtilitySPCMESOInputOutput.getImage(self.product, self.sector)
            DispatchQueue.main.async {
                if self.firstRun {
                    self.image.setBitmap(bitmap)
                    //UtilityImg.imgRestorePosnZoom(self.image.img, self)
                    self.firstRun = false
                } else {
                    self.image.updateBitmap(bitmap)
                }
                self.paramButton.title = self.product
                editor.putString(self.prefModel + self.numPanesStr + "_PARAM_LAST_USED", self.product)
                editor.putString(self.prefModel + self.numPanesStr + "_SECTOR_LAST_USED", self.sector)
            }
        }
    }

    @objc override func doneClicked() {
        UtilityImg.imgSavePosnZoom(image.img, self)
        super.doneClicked()
    }

    @objc func willEnterForeground() {
        self.getContent()
    }

    @objc func sectorClicked() {
        let alert = ObjectPopUp(self, "Sector Selection", sectorButton)
        UtilitySPCMESO.sectorMap.keys.forEach { sector in
            alert.addAction(UIAlertAction(title: UtilitySPCMESO.sectorMap[sector],
                                          style: .default,
                                          handler: {_ in self.sectorChanged(sector)}))
        }
        alert.finish()
    }

    func productChanged(_ product: String) {
        self.product = product
        self.getContent()
    }

    func sectorChanged(_ sector: String) {
        self.sector = sector
        self.sectorButton.title = (UtilitySPCMESO.sectorMap[sector] ?? "").truncate(3)
        self.getContent()
    }

    @objc func shareClicked(sender: UIButton) {UtilityShare.shareImage(self, sender, image.bitmap)}

    @objc func paramClicked(sender: ObjectToolbarIcon) {
        var paramArray = [String: String]()
        switch sender.title! {
        case "SFC": paramArray = UtilitySPCMESO.paramSurface
        case "UA":  paramArray = UtilitySPCMESO.paramUpperAir
        case "CPE": paramArray = UtilitySPCMESO.paramCape
        case "CMP": paramArray = UtilitySPCMESO.paramComp
        case "SHR": paramArray = UtilitySPCMESO.paramShear
        default: break
        }
        let alert = ObjectPopUp(self, "Product Selection", sender)
        paramArray.keys.sorted().forEach { productCode in
            alert.addAction(UIAlertAction(paramArray[productCode]!, {_ in self.productChanged(productCode)}))
        }
        alert.finish()
    }

    @objc func layerClicked(sender: ObjectToolbarIcon) {
        let alert = ObjectPopUp(self, "Toggle Layers", layerButton)
        ["Radar", "SPC Outlooks", "Watches/Warnings", "Topography"].forEach { layer in
            var pre = ""
            if isLayerSelected(layer) {
                pre = "(on) "
            }
            alert.addAction(UIAlertAction(pre + layer, { _ in self.layerChanged(layer)}))
        }
        alert.finish()
    }

    func layerChanged(_ layer: String) {
        switch layer {
        case "Radar":            toggleLayer("SPCMESO_SHOW_RADAR")
        case "SPC Outlooks":     toggleLayer("SPCMESO_SHOW_OUTLOOK")
        case "Watches/Warnings": toggleLayer("SPCMESO_SHOW_WATWARN")
        case "Topography":       toggleLayer("SPCMESO_SHOW_TOPO")
        default: break
        }
        getContent()
    }

    func isLayerSelected(_ layer: String) -> Bool {
        var isSelected = "false"
        switch layer {
        case "Radar":            isSelected = preferences.getString("SPCMESO_SHOW_RADAR", "false")
        case "SPC Outlooks":     isSelected = preferences.getString("SPCMESO_SHOW_OUTLOOK", "false")
        case "Watches/Warnings": isSelected = preferences.getString("SPCMESO_SHOW_WATWARN", "false")
        case "Topography":       isSelected = preferences.getString("SPCMESO_SHOW_TOPO", "false")
        default: break
        }
        return isSelected == "true"
    }

    func toggleLayer(_ prefVar: String) {
        let currentValue = preferences.getString(prefVar, "false").hasPrefix("true")
        if currentValue {
            editor.putString(prefVar, "false")
        } else {
            editor.putString(prefVar, "true")
        }
    }

    @objc func animateClicked() {
        let alert = ObjectPopUp(self, "Select number of animation frames:", animateButton)
        [6, 12, 18].forEach { count in
            alert.addAction(UIAlertAction(count, { _ in self.getAnimation(count)}))
        }
        alert.finish()
    }

    func getAnimation(_ frameCount: Int) {
        DispatchQueue.global(qos: .userInitiated).async {
            let animDrawable = UtilitySPCMESOInputOutput.getAnimation(self.sector, self.product, frameCount)
            DispatchQueue.main.async {
                self.image.startAnimating(animDrawable)
            }
        }
    }

    @objc func showProductMenu() {
        let alert = ObjectPopUp(self, "Product Selection", paramButton)
        subMenu.objTitles.enumerated().forEach { index, title in
            alert.addAction(UIAlertAction(title.title, { _ in self.showSubMenu(index)}))
        }
        alert.finish()
    }

    func showSubMenu(_ index: Int) {
        let startIdx  = ObjectMenuTitle.getStart(subMenu.objTitles, index)
        let count = subMenu.objTitles[index].count
        let title = subMenu.objTitles[index].title
        let alert = ObjectPopUp(self, title, paramButton)
        (startIdx..<(startIdx+count)).forEach { index in
            let ii = subMenu.params[index]
            let paramTitle = subMenu.paramLabels[index]
            alert.addAction(UIAlertAction(title: paramTitle, style: .default, handler: {_ in self.productChanged(ii)}))
        }
        alert.finish()
    }

    @objc func handleSwipes(sender: UISwipeGestureRecognizer) {
        var index = 0
        if let product = UtilitySPCMESO.productShortList.index(of: self.product) {
            index = UtilityUI.sideSwipe(sender, product, UtilitySPCMESO.productShortList)
        }
        productChanged(UtilitySPCMESO.productShortList[index])
    }
}
