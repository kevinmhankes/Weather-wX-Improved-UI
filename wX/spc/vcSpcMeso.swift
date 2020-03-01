/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcSpcMeso: UIwXViewController {
    
    private var image = ObjectTouchImageView()
    private var sectorButton = ObjectToolbarIcon()
    private var sfcButton = ObjectToolbarIcon()
    private var uaButton = ObjectToolbarIcon()
    private var cpeButton = ObjectToolbarIcon()
    private var cmpButton = ObjectToolbarIcon()
    private var shrButton = ObjectToolbarIcon()
    private var layerButton = ObjectToolbarIcon()
    private var paramButton = ObjectToolbarIcon()
    private var animateButton = ObjectToolbarIcon()
    private var product = "500mb"
    private var sector = "19"
    private var prefModel = "SPCMESO"
    private let numPanesStr = "1"
    private var firstRun = true
    private let subMenu = ObjectMenuData(UtilitySpcMeso.titles, UtilitySpcMeso.params, UtilitySpcMeso.labels)
    var spcMesoFromHomeScreen = false
    var spcMesoToken = ""
    var parametars = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        let toolbarTop = ObjectToolbar(.top)
        layerButton = ObjectToolbarIcon(title: "Layers", self, #selector(layerClicked))
        animateButton = ObjectToolbarIcon(self, .play, #selector(animateClicked))
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        paramButton = ObjectToolbarIcon(self, #selector(showProductMenu))
        toolbarTop.items = ObjectToolbarItems(
            [
                GlobalVariables.flexBarButton,
                paramButton,
                GlobalVariables.fixedSpace,
                layerButton,
                GlobalVariables.fixedSpace,
                animateButton,
                GlobalVariables.fixedSpace,
                shareButton
            ]
        ).items
        sectorButton = ObjectToolbarIcon(title: "Sector", self, #selector(sectorClicked))
        sfcButton = ObjectToolbarIcon(title: "SFC", self, #selector(paramClicked))
        uaButton = ObjectToolbarIcon(title: "UA", self, #selector(paramClicked))
        cpeButton = ObjectToolbarIcon(title: "CPE", self, #selector(paramClicked))
        cmpButton = ObjectToolbarIcon(title: "CMP", self, #selector(paramClicked))
        shrButton = ObjectToolbarIcon(title: "SHR", self, #selector(paramClicked))
        toolbar.items = ObjectToolbarItems(
            [
                doneButton,
                GlobalVariables.flexBarButton,
                sfcButton,
                uaButton,
                cpeButton,
                cmpButton,
                shrButton,
                sectorButton
            ]
        ).items
        self.view.addSubview(toolbarTop)
        self.view.addSubview(toolbar)
        image = ObjectTouchImageView(self, toolbar, hasTopToolbar: true, topToolbar: toolbarTop)
        image.addGestureRecognizer(#selector(handleSwipes(sender:)))
        toolbarTop.setConfigWithUiv(uiv: self, toolbarType: .top)
        if spcMesoFromHomeScreen {
            product = spcMesoToken
            spcMesoFromHomeScreen = false
            sectorChanged(sector)
        } else {
            product = Utility.readPref(prefModel + numPanesStr + "_PARAM_LAST_USED", product)
            sectorChanged(Utility.readPref(prefModel + numPanesStr + "_SECTOR_LAST_USED", sector))
        }
    }
    
    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            let bitmap = UtilitySpcMesoInputOutput.getImage(self.product, self.sector)
            DispatchQueue.main.async {
                if self.firstRun {
                    self.image.setBitmap(bitmap)
                    self.firstRun = false
                } else {
                    self.image.updateBitmap(bitmap)
                }
                self.paramButton.title = self.product
                Utility.writePref(self.prefModel + self.numPanesStr + "_PARAM_LAST_USED", self.product)
                Utility.writePref(self.prefModel + self.numPanesStr + "_SECTOR_LAST_USED", self.sector)
            }
        }
    }
    
    @objc func willEnterForeground() {
        self.getContent()
    }
    
    @objc func sectorClicked() {
        _ = ObjectPopUp(self, "Sector Selection", sectorButton, UtilitySpcMeso.sectors, self.sectorChangedByIndex(_:))
    }
    
    func sectorChangedByIndex(_ index: Int) {
        self.sector = UtilitySpcMeso.sectorCodes[index]
        self.sectorButton.title = (UtilitySpcMeso.sectorMap[sector] ?? "").truncate(3)
        self.getContent()
    }
    
    func sectorChanged(_ sector: String) {
        self.sector = sector
        self.sectorButton.title = (UtilitySpcMeso.sectorMap[sector] ?? "").truncate(3)
        self.getContent()
    }
    
    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, image.bitmap)
    }
    
    @objc func paramClicked(sender: ObjectToolbarIcon) {
        switch sender.title! {
        case "SFC":
            parametars = UtilitySpcMeso.paramSurface
        case "UA":
            parametars = UtilitySpcMeso.paramUpperAir
        case "CPE":
            parametars = UtilitySpcMeso.paramCape
        case "CMP":
            parametars = UtilitySpcMeso.paramComp
        case "SHR":
            parametars = UtilitySpcMeso.paramShear
        default:
            break
        }
        let labels = parametars.map {$0.split(":")[1]}
        _ = ObjectPopUp(self, "Product Selection", sender, labels, self.productChangedBySubmenu(_:))
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
        case "Radar":
            toggleLayer("SPCMESO_SHOW_RADAR")
        case "SPC Outlooks":
            toggleLayer("SPCMESO_SHOW_OUTLOOK")
        case "Watches/Warnings":
            toggleLayer("SPCMESO_SHOW_WATWARN")
        case "Topography":
            toggleLayer("SPCMESO_SHOW_TOPO")
        default:
            break
        }
        getContent()
    }
    
    func isLayerSelected(_ layer: String) -> Bool {
        var isSelected = "false"
        switch layer {
        case "Radar":
            isSelected = Utility.readPref("SPCMESO_SHOW_RADAR", "false")
        case "SPC Outlooks":
            isSelected = Utility.readPref("SPCMESO_SHOW_OUTLOOK", "false")
        case "Watches/Warnings":
            isSelected = Utility.readPref("SPCMESO_SHOW_WATWARN", "false")
        case "Topography":
            isSelected = Utility.readPref("SPCMESO_SHOW_TOPO", "false")
        default:
            break
        }
        return isSelected == "true"
    }
    
    func toggleLayer(_ prefVar: String) {
        let currentValue = Utility.readPref(prefVar, "false").hasPrefix("true")
        if currentValue {
            Utility.writePref(prefVar, "false")
        } else {
            Utility.writePref(prefVar, "true")
        }
    }
    
    @objc func animateClicked() {
        _ = ObjectPopUp(self, "Select number of animation frames:", animateButton, [6, 12, 18], self.getAnimation(_:))
    }
    
    func getAnimation(_ frameCount: Int) {
        DispatchQueue.global(qos: .userInitiated).async {
            let animDrawable = UtilitySpcMesoInputOutput.getAnimation(self.sector, self.product, frameCount)
            DispatchQueue.main.async {
                self.image.startAnimating(animDrawable)
            }
        }
    }
    
    @objc func showProductMenu() {
        _ = ObjectPopUp(self, "Product Selection", paramButton, subMenu.objTitles, self.showSubMenu(_:))
    }
    
    func showSubMenu(_ index: Int) {
        _ = ObjectPopUp(self, paramButton, subMenu.objTitles, index, subMenu, self.productChanged(_:))
    }
    
    func productChangedBySubmenu(_ index: Int) {
        self.product = parametars[index].split(":")[0]
        self.getContent()
    }
    
    func productChangedByCode(_ product: String) {
        self.product = product
        self.getContent()
    }
    
    func productChanged(_ index: Int) {
        let product = subMenu.params[index]
        self.product = product
        self.getContent()
    }
    
    @objc func handleSwipes(sender: UISwipeGestureRecognizer) {
        var index = 0
        if let product = UtilitySpcMeso.productShortList.firstIndex(of: self.product) {
            index = UtilityUI.sideSwipe(sender, product, UtilitySpcMeso.productShortList)
        }
        productChangedByCode(UtilitySpcMeso.productShortList[index])
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: nil,
            completion: { _ -> Void in
                self.image.refresh()
        }
        )
    }
}
