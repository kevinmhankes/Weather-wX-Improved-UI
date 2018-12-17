/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerMODELGENERIC: UIwXViewController {

    var image = ObjectTouchImageView()
    var sectorButton = ObjectToolbarIcon()
    var statusButton = ObjectToolbarIcon()
    var modelButton = ObjectToolbarIcon()
    var runButton = ObjectToolbarIcon()
    var timeButton = ObjectToolbarIcon()
    var productButton = ObjectToolbarIcon()
    var firstRun = true
    var subMenu = ObjectMenuData(UtilityModelSPCHREFInterface.titles,
                                 UtilityModelSPCHREFInterface.params,
                                 UtilityModelSPCHREFInterface.labels
    )
    var modelObj = ObjectModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        let toolbarTop = ObjectToolbar(.top)
        statusButton = ObjectToolbarIcon(self, #selector(runClicked))
        modelButton = ObjectToolbarIcon(title: "Model", self, #selector(modelClicked))
        sectorButton = ObjectToolbarIcon(title: "Sector", self, #selector(sectorClicked))
        runButton = ObjectToolbarIcon(title: "Run", self, #selector(runClicked))
        let animateButton = ObjectToolbarIcon(self, .play, #selector(getAnimation))
        toolbarTop.items = ObjectToolbarItems([statusButton,
                                               flexBarButton,
                                               modelButton,
                                               sectorButton,
                                               runButton,
                                               animateButton]).items
        if ActVars.modelActivitySelected.contains("NCAR")
            || ActVars.modelActivitySelected.contains("SPCSREF")
            || ActVars.modelActivitySelected.contains("SPCHREF")
            || ActVars.modelActivitySelected.contains("WPCGEFS") {
            productButton = ObjectToolbarIcon(title: "Product", self, #selector(self.showProdMenu))
        } else {
            productButton = ObjectToolbarIcon(title: "Product", self, #selector(self.prodClicked))
        }
        if ActVars.modelActivitySelected.contains("SPCSREF") {
            subMenu = ObjectMenuData(UtilityModelsSPCSREFInterface.titles,
                                     UtilityModelsSPCSREFInterface.params,
                                     UtilityModelsSPCSREFInterface.labels)
        } else if ActVars.modelActivitySelected.contains("SPCHREF") {
            subMenu = ObjectMenuData(UtilityModelSPCHREFInterface.titles,
                                     UtilityModelSPCHREFInterface.params,
                                     UtilityModelSPCHREFInterface.labels)
        } else if ActVars.modelActivitySelected.contains("WPCGEFS") {
            subMenu = ObjectMenuData(UtilityModelWPCGEFSInterface.titles,
                                     UtilityModelWPCGEFSInterface.params,
                                     UtilityModelWPCGEFSInterface.labels)
        }
        timeButton = ObjectToolbarIcon(title: "Time", self, #selector(self.timeClicked))
        let doneButton = ObjectToolbarIcon(self, .done, #selector(self.doneClicked))
        let leftButton = ObjectToolbarIcon(self, .leftArrow, #selector(self.leftClicked))
        let rightButton = ObjectToolbarIcon(self, .rightArrow, #selector(self.rightClicked))
        fixedSpace.width = UIPreferences.toolbarIconSpacing
        toolbar.items = ObjectToolbarItems([doneButton,
                                            flexBarButton,
                                            productButton,
                                            timeButton,
                                            leftButton,
                                            rightButton]).items
        image = ObjectTouchImageView(self, toolbar, #selector(handleSwipes(sender:)))
        self.view.addSubview(toolbar)
        self.view.addSubview(toolbarTop)
        modelObj = ObjectModel(ActVars.modelActivitySelected)
        modelObj.setButtons(productButton, sectorButton, runButton, timeButton, statusButton, modelButton)
        self.setupModel()
        self.getRunStatus()
    }

    func getRunStatus() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.modelObj.getRunStatus()
            DispatchQueue.main.async {
                self.modelObj.setRun(self.modelObj.runTimeData.mostRecentRun)
                if ActVars.modelActivitySelected == "SPCHRRR"
                    || ActVars.modelActivitySelected == "SPCSREF"
                    || ActVars.modelActivitySelected == "SPCHREF" {
                    self.modelObj.timeArr = UtilityModels.updateTime(UtilityString.getLastXChars(self.modelObj.run, 2),
                                                                     self.modelObj.run,
                                                                     self.modelObj.timeArr,
                                                                     "",
                                                                     false)
                } else if !ActVars.modelActivitySelected.contains("GLCFS") {
                    self.modelObj.timeArr.enumerated().forEach { idx, timeStr in
                        self.modelObj.setTimeArr(idx,
                                                 timeStr.split(" ")[0] + " "
                                                    + UtilityModels.convertTimeRuntoTimeString(
                                                        self.modelObj.runTimeData.timeStrConv.replace("Z", ""),
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

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            let bitmap = self.modelObj.getImage()
            DispatchQueue.main.async {
                if self.firstRun {
                    self.image.setBitmap(bitmap)
                    self.firstRun = false
                } else {
                    self.image.updateBitmap(bitmap)
                }
                self.modelObj.setPrefs()
            }
        }
    }

    @objc func prodClicked() {
        _ = ObjectPopUp(self, "Product Selection", productButton, modelObj.paramLabelArr, self.prodChanged(_:))
    }

    //
    // Submenu code
    //
    @objc func showProdMenu() {
        _ = ObjectPopUp(self, "Product Selection", productButton, subMenu.objTitles, self.showSubMenu(_:))
    }

    // FIXME move to ObjectPopUp
    func showSubMenu(_ index: Int) {
        let startIdx = ObjectMenuTitle.getStart(subMenu.objTitles, index)
        let count = subMenu.objTitles[index].count
        let title = subMenu.objTitles[index].title
        let alert = ObjectPopUp(self, title, productButton)
        (startIdx..<(startIdx + count)).forEach { idx in
            let paramTitle = subMenu.paramLabels[idx]
            alert.addAction(UIAlertAction(paramTitle, { _ in self.prodChanged(idx)}))
        }
        alert.finish()
    }

    //
    // end submenu code
    //

    @objc func sectorClicked() {
        _ = ObjectPopUp(self, "Region Selection", sectorButton, modelObj.sectorArr, self.sectorChanged(_:))
    }

    func sectorChanged(_ sector: String) {
        self.modelObj.setSector(sector)
        getRunStatus()
    }

    @objc func runClicked() {
        _ = ObjectPopUp(self, "Run Selection", runButton, modelObj.runTimeData.listRun, self.runChanged(_:))
    }

    func runChanged(_ run: String) {
        modelObj.setRun(run)
        self.getContent()
    }

    @objc func modelClicked() {
        _ = ObjectPopUp(self, "Model Selection", modelButton, self.modelObj.modelArr, self.modelChanged(_:))
    }

    func modelChanged(_ model: String) {
        self.modelObj.setModel(model)
        setupModel()
        getRunStatus()
    }

    // FIXME
    func respondToSwipeGesture(gesture: UISwipeGestureRecognizer ) {
        let swipeGesture = gesture
        switch swipeGesture.direction {
        case .right: rightClicked()
        case .left: leftClicked()
        default: break
        }
    }

    @objc func leftClicked() {
        modelObj.leftClick()
        getContent()
    }

    @objc func rightClicked() {
        modelObj.rightClick()
        getContent()
    }

    @objc func timeClicked() {
        _ = ObjectPopUp(self, "Time Selection", timeButton, modelObj.timeArr, self.timeChanged(_:))
    }

    func timeChanged(_ time: Int) {
        modelObj.setTimeIdx(time)
        self.getContent()
    }

    func prodChanged(_ prod: Int) {
        modelObj.setParam(prod)
        if ActVars.modelActivitySelected.contains("SSEO") {
            self.modelObj.timeArr.enumerated().forEach { idx, timeStr in
                self.modelObj.setTimeArr(idx,
                                         timeStr.split(" ")[0]
                                            + " "
                                            + UtilityModels.convertTimeRuntoTimeString(
                                                self.modelObj.runTimeData.timeStrConv.replace("Z", ""),
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
        if sender.direction == .left {
            rightClicked()
        }
        if sender.direction == .right {
            leftClicked()
        }
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
}
