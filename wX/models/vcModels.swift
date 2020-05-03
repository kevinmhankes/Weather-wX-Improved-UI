/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcModels: UIwXViewController {
    
    private var image = ObjectTouchImageView()
    private var sectorButton = ObjectToolbarIcon()
    private var statusButton = ObjectToolbarIcon()
    private var modelButton = ObjectToolbarIcon()
    private var runButton = ObjectToolbarIcon()
    private var timeButton = ObjectToolbarIcon()
    private var productButton = ObjectToolbarIcon()
    private var firstRun = true
    private var subMenu = ObjectMenuData(
        UtilityModelSpcHrefInterface.titles,
        UtilityModelSpcHrefInterface.params,
        UtilityModelSpcHrefInterface.labels
    )
    private var modelObj = ObjectModel()
    private var fabLeft: ObjectFab?
    private var fabRight: ObjectFab?
    var modelActivitySelected = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let toolbarTop = ObjectToolbar(.top)
        statusButton = ObjectToolbarIcon(self, #selector(runClicked))
        modelButton = ObjectToolbarIcon(title: "Model", self, #selector(modelClicked))
        sectorButton = ObjectToolbarIcon(title: "Sector", self, #selector(sectorClicked))
        runButton = ObjectToolbarIcon(title: "Run", self, #selector(runClicked))
        let animateButton = ObjectToolbarIcon(self, .play, #selector(getAnimation))
        toolbarTop.items = ObjectToolbarItems(
            [
                statusButton,
                GlobalVariables.flexBarButton,
                modelButton,
                sectorButton,
                runButton,
                animateButton
            ]
        ).items
        if modelActivitySelected.contains("NCAR")
            || modelActivitySelected.contains("SPCSREF")
            || modelActivitySelected.contains("SPCHREF")
            || modelActivitySelected.contains("WPCGEFS") {
            productButton = ObjectToolbarIcon(title: "Product", self, #selector(showProdMenu))
        } else {
            productButton = ObjectToolbarIcon(title: "Product", self, #selector(prodClicked))
        }
        if modelActivitySelected.contains("SPCSREF") {
            subMenu = ObjectMenuData(
                UtilityModelSpcSrefInterface.titles,
                UtilityModelSpcSrefInterface.params,
                UtilityModelSpcSrefInterface.labels
            )
        } else if modelActivitySelected.contains("SPCHREF") {
            subMenu = ObjectMenuData(
                UtilityModelSpcHrefInterface.titles,
                UtilityModelSpcHrefInterface.params,
                UtilityModelSpcHrefInterface.labels
            )
        } else if modelActivitySelected.contains("WPCGEFS") {
            subMenu = ObjectMenuData(
                UtilityModelWpcGefsInterface.titles,
                UtilityModelWpcGefsInterface.params,
                UtilityModelWpcGefsInterface.labels
            )
        }
        timeButton = ObjectToolbarIcon(title: "Time", self, #selector(timeClicked))
        let doneButton = ObjectToolbarIcon(self, .done, #selector(doneClicked))
        GlobalVariables.fixedSpace.width = UIPreferences.toolbarIconSpacing
        toolbar.items = ObjectToolbarItems(
            [
                doneButton,
                GlobalVariables.flexBarButton,
                productButton,
                timeButton
            ]
        ).items
        self.view.addSubview(toolbarTop)
        toolbarTop.setConfigWithUiv(uiv: self, toolbarType: .top)
        image = ObjectTouchImageView(self, toolbar, #selector(handleSwipes(sender:)), hasTopToolbar: true, topToolbar: toolbarTop)
        fabLeft = ObjectFab(self, #selector(leftClicked), iconType: .leftArrow)
        fabRight = ObjectFab(self, #selector(rightClicked), iconType: .rightArrow)
        fabLeft?.setToTheLeft()
        modelObj = ObjectModel(modelActivitySelected)
        modelObj.setButtons(productButton, sectorButton, runButton, timeButton, statusButton, modelButton)
        self.setupModel()
        self.getRunStatus()
    }
    
    func getRunStatus() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.modelObj.getRunStatus()
            DispatchQueue.main.async {
                self.modelObj.setRun(self.modelObj.runTimeData.mostRecentRun)
                if self.modelActivitySelected == "SPCHRRR"
                    || self.modelActivitySelected == "SPCSREF"
                    || self.modelActivitySelected == "SPCHREF" {
                    self.modelObj.timeArr = UtilityModels.updateTime(
                        UtilityString.getLastXChars(self.modelObj.run, 2),
                        self.modelObj.run,
                        self.modelObj.timeArr,
                        "",
                        false
                    )
                } else if !self.modelActivitySelected.contains("GLCFS") {
                    self.modelObj.timeArr.enumerated().forEach { idx, timeStr in
                        self.modelObj.setTimeArr(
                            idx,
                            timeStr.split(" ")[0] + " "
                                + UtilityModels.convertTimeRuntoTimeString(
                                    self.modelObj.runTimeData.timeStringConversion.replace("Z", ""),
                                    timeStr.split(" ")[0],
                                    false
                            )
                        )
                    }
                }
                if self.modelObj.timeIdx >= self.modelObj.timeArr.count {
                    self.modelObj.setTimeIdx(self.modelObj.timeArr.count - 1)
                }
                self.modelObj.timeButton.title = Utility.safeGet(self.modelObj.timeArr, self.modelObj.timeIdx)
                self.getContent()
            }
        }
    }
    
    override func willEnterForeground() {}
    
    override func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            let bitmap = self.modelObj.getImage()
            DispatchQueue.main.async {
                if self.firstRun {
                    self.image.setBitmap(bitmap)
                    self.firstRun = false
                } else {
                    self.image.updateBitmap(bitmap)
                }
                self.modelObj.setPreferences()
            }
        }
    }
    
    @objc func prodClicked() {
        _ = ObjectPopUp(self, productButton, modelObj.paramLabelArr, self.prodChanged(_:))
    }
    
    @objc func showProdMenu() {
        _ = ObjectPopUp(self, "Product Selection", productButton, subMenu.objTitles, self.showSubMenu(_:))
    }
    
    func showSubMenu(_ index: Int) {
        _ = ObjectPopUp(self, productButton, subMenu.objTitles, index, subMenu, self.prodChanged(_:))
    }
    
    @objc func sectorClicked() {
        _ = ObjectPopUp(self, title: "Region Selection", sectorButton, modelObj.sectorArr, self.sectorChanged(_:))
    }
    
    func sectorChanged(_ sector: String) {
        self.modelObj.setSector(sector)
        getRunStatus()
    }
    
    @objc func runClicked() {
        _ = ObjectPopUp(self, title: "Run Selection", runButton, modelObj.runTimeData.listRun, self.runChanged(_:))
    }
    
    func runChanged(_ run: String) {
        modelObj.setRun(run)
        self.getContent()
    }
    
    @objc func modelClicked() {
        _ = ObjectPopUp(self, title: "Model Selection", modelButton, self.modelObj.modelArr, self.modelChanged(_:))
    }
    
    func modelChanged(_ model: String) {
        self.modelObj.setModel(model)
        setupModel()
        getRunStatus()
    }
    
    func respondToSwipeGesture(gesture: UISwipeGestureRecognizer ) {
        let swipeGesture = gesture
        switch swipeGesture.direction {
        case .right:
            rightClicked()
        case .left:
            leftClicked()
        default:
            break
        }
    }
    
    @objc func leftClicked() {
        modelObj.leftClick()
        fabLeft?.close()
        getContent()
    }
    
    @objc func rightClicked() {
        modelObj.rightClick()
        fabRight?.close()
        getContent()
    }
    
    @objc func timeClicked() {
        _ = ObjectPopUp(self, title: "Time Selection", timeButton, modelObj.timeArr, self.timeChanged(_:))
    }
    
    func timeChanged(_ time: Int) {
        modelObj.setTimeIdx(time)
        self.getContent()
    }
    
    func prodChanged(_ prod: Int) {
        modelObj.setParam(prod)
        if modelActivitySelected.contains("SSEO") {
            self.modelObj.timeArr.enumerated().forEach { idx, timeStr in
                self.modelObj.setTimeArr(
                    idx,
                    timeStr.split(" ")[0]
                        + " "
                        + UtilityModels.convertTimeRuntoTimeString(
                            self.modelObj.runTimeData.timeStringConversion.replace("Z", ""),
                            timeStr.split(" ")[0],
                            false
                    )
                )
            }
        }
        self.getContent()
    }
    
    func setupModel() {
        modelObj.setModelVars(self.modelObj.model)
    }
    
    @objc func handleSwipes(sender: UISwipeGestureRecognizer) {
        if sender.direction == .left { rightClicked() }
        if sender.direction == .right { leftClicked() }
    }
    
    @objc func getAnimation() {
        DispatchQueue.global(qos: .userInitiated).async {
            let animDrawable = self.modelObj.getAnimation()
            DispatchQueue.main.async {
                self.image.startAnimating(animDrawable)
                self.firstRun = true
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { _ -> Void in self.image.refresh() })
    }
}
