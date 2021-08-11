// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class vcModels: UIwXViewController {

    private var image = TouchImage()
    private var sectorButton = ToolbarIcon()
    private var statusButton = ToolbarIcon()
    private var modelButton = ToolbarIcon()
    private var runButton = ToolbarIcon()
    private var timeButton = ToolbarIcon()
    private var productButton = ToolbarIcon()
    private var subMenu = MenuData(
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
        let toolbarTop = ObjectToolbar()
        statusButton = ToolbarIcon(self, #selector(runClicked))
        modelButton = ToolbarIcon("Model", self, #selector(modelClicked))
        sectorButton = ToolbarIcon("Sector", self, #selector(sectorClicked))
        runButton = ToolbarIcon("Run", self, #selector(runClicked))
        let animateButton = ToolbarIcon(self, .play, #selector(getAnimation))
        toolbarTop.items = ToolbarItems([
            statusButton,
            GlobalVariables.flexBarButton,
            modelButton,
            sectorButton,
            runButton,
            animateButton
        ]).items
        if modelActivitySelected.contains("NCAR")
            || modelActivitySelected.contains("SPCSREF")
            || modelActivitySelected.contains("SPCHREF")
            || modelActivitySelected.contains("WPCGEFS") {
            productButton = ToolbarIcon("Product", self, #selector(showProdMenu))
        } else {
            productButton = ToolbarIcon("Product", self, #selector(prodClicked))
        }
        if modelActivitySelected.contains("SPCSREF") {
            subMenu = MenuData(
                UtilityModelSpcSrefInterface.titles,
                UtilityModelSpcSrefInterface.params,
                UtilityModelSpcSrefInterface.labels
            )
        } else if modelActivitySelected.contains("SPCHREF") {
            subMenu = MenuData(
                UtilityModelSpcHrefInterface.titles,
                UtilityModelSpcHrefInterface.params,
                UtilityModelSpcHrefInterface.labels
            )
        } else if modelActivitySelected.contains("WPCGEFS") {
            subMenu = MenuData(
                UtilityModelWpcGefsInterface.titles,
                UtilityModelWpcGefsInterface.params,
                UtilityModelWpcGefsInterface.labels
            )
        }
        timeButton = ToolbarIcon("Time", self, #selector(timeClicked))
        let doneButton = ToolbarIcon(self, .done, #selector(doneClicked))
        GlobalVariables.fixedSpace.width = UIPreferences.toolbarIconSpacing
        toolbar.items = ToolbarItems([
            doneButton,
            GlobalVariables.flexBarButton,
            productButton,
            timeButton
        ]).items
        view.addSubview(toolbarTop)
        toolbarTop.setConfigWithUiv(uiv: self, toolbarType: .top)
        image = TouchImage(self, toolbar, #selector(handleSwipes(sender:)), hasTopToolbar: true, topToolbar: toolbarTop)
        fabLeft = ObjectFab(self, #selector(leftClicked), iconType: .leftArrow)
        fabRight = ObjectFab(self, #selector(rightClicked), iconType: .rightArrow)
        fabLeft?.setToTheLeft()
        modelObj = ObjectModel(modelActivitySelected)
        modelObj.setButtons(productButton, sectorButton, runButton, timeButton, statusButton, modelButton)
        setupModel()
        getRunStatus()
    }

    func getRunStatus() {
        _ = FutureVoid(modelObj.getRunStatus, updateAfterRunStatus)
    }
    
    private func updateAfterRunStatus() {
        modelObj.setRun(modelObj.runTimeData.mostRecentRun)
        if modelActivitySelected == "SPCHRRR"
            || modelActivitySelected == "SPCSREF"
            || modelActivitySelected == "SPCHREF" {
            modelObj.times = UtilityModels.updateTime(
                UtilityString.getLastXChars(modelObj.run, 2),
                modelObj.run,
                modelObj.times,
                ""
            )
        } else if !modelActivitySelected.contains("GLCFS") {
            modelObj.times.enumerated().forEach { idx, timeStr in
                modelObj.setTimeArr(
                    idx,
                    timeStr.split(" ")[0] + " "
                        + UtilityModels.convertTimeRunToTimeString(
                            modelObj.runTimeData.timeStringConversion.replace("Z", ""),
                            timeStr.split(" ")[0]
                    )
                )
            }
        }
        if modelObj.timeIdx >= modelObj.times.count {
            modelObj.setTimeIdx(modelObj.times.count - 1)
        }
        modelObj.timeButton.title = Utility.safeGet(modelObj.times, modelObj.timeIdx)
        getContent()
    }

    override func willEnterForeground() {}

    override func getContent() {
        _ = FutureBytes2(modelObj.getImage, display)
    }

    private func display(_ bitmap: Bitmap) {
        image.setBitmap(bitmap)
        modelObj.setPreferences()
    }

    @objc func prodClicked() {
        _ = ObjectPopUp(self, productButton, modelObj.paramLabels, prodChanged(_:))
    }

    @objc func showProdMenu() {
        _ = ObjectPopUp(self, "Product Selection", productButton, subMenu.objTitles, showSubMenu(_:))
    }

    func showSubMenu(_ index: Int) {
        _ = ObjectPopUp(self, productButton, subMenu.objTitles, index, subMenu, prodChanged(_:))
    }

    @objc func sectorClicked() {
        _ = ObjectPopUp(self, title: "Region Selection", sectorButton, modelObj.sectors, sectorChanged(_:))
    }

    func sectorChanged(_ sector: String) {
        modelObj.setSector(sector)
        getRunStatus()
    }

    @objc func runClicked() {
        _ = ObjectPopUp(self, title: "Run Selection", runButton, modelObj.runTimeData.listRun, runChanged(_:))
    }

    func runChanged(_ run: String) {
        modelObj.setRun(run)
        getContent()
    }

    @objc func modelClicked() {
        _ = ObjectPopUp(self, title: "Model Selection", modelButton, modelObj.models, modelChanged(_:))
    }

    func modelChanged(_ model: String) {
        modelObj.setModel(model)
        setupModel()
        getRunStatus()
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
        _ = ObjectPopUp(self, title: "Time Selection", timeButton, modelObj.times, timeChanged(_:))
    }

    func timeChanged(_ time: Int) {
        modelObj.setTimeIdx(time)
        getContent()
    }

    func prodChanged(_ prod: Int) {
        modelObj.setParam(prod)
        if modelActivitySelected.contains("SSEO") {
            modelObj.times.enumerated().forEach { idx, timeStr in
                modelObj.setTimeArr(
                    idx,
                    timeStr.split(" ")[0]
                        + " "
                        + UtilityModels.convertTimeRunToTimeString(
                            modelObj.runTimeData.timeStringConversion.replace("Z", ""),
                            timeStr.split(" ")[0]
                    )
                )
            }
        }
        getContent()
    }

    func setupModel() {
        modelObj.setModelVars(modelObj.model)
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
        _ = FutureAnimation(modelObj.getAnimation, image.startAnimating)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { _ in self.image.refresh() })
    }
}
