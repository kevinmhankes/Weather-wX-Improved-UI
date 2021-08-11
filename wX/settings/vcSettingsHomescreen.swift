// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class vcSettingsHomescreen: UIwXViewController {

    private var homeScreenFav = [String]()
    private var addImageButton = ToolbarIcon()
    private var addTextButton = ToolbarIcon()
    private var addButton = ToolbarIcon()

    override func viewDidLoad() {
        super.viewDidLoad()
        addButton = ToolbarIcon(self, .plus, #selector(addClicked))
        let defaultButton = ToolbarIcon("Set to default", self, #selector(setToDefault))
        addImageButton = ToolbarIcon("Image", self, #selector(addImageClicked))
        addTextButton = ToolbarIcon("Text", self, #selector(addTextClicked))
        toolbar.items = ToolbarItems([
            doneButton,
            GlobalVariables.flexBarButton,
            addTextButton,
            addImageButton,
            defaultButton,
            addButton
        ]).items
        objScrollStackView = ScrollStackView(self)
        deSerializeSettings()
        display(saveToDisk: false)
    }

    override func doneClicked() {
        serializeSettings()
        MyApplication.initPreferences()
        super.doneClicked()
    }

    func serializeSettings() {
        Utility.writePref("HOMESCREEN_FAV", TextUtils.join(":", homeScreenFav))
    }

    func deSerializeSettings() {
        homeScreenFav = TextUtils.split(Utility.readPref("HOMESCREEN_FAV", GlobalVariables.homescreenFavDefault), ":")
    }

    @objc func addClicked() {
        let alert = ObjectPopUp(self, "Product Selection", addButton)
        Array(UtilityHomeScreen.localChoicesText.keys).sorted().forEach { item in
            alert.addAction(UIAlertAction(title: UtilityHomeScreen.localChoicesText[item], style: .default, handler: { _ in self.addProduct(item) }))
        }
        alert.finish()
    }

    func addProduct(_ selection: String) {
        if homeScreenFav.contains(selection) {
            getHelp(addButton, selection + " is already in the home screen list.")
        } else {
            homeScreenFav.append(selection)
        }
        display()
    }

    func getHelp(_ targetButton: UIBarButtonItem, _ help: String) {
        let alert = ObjectPopUp(self, help, targetButton)
        alert.addAction(UIAlertAction(title: "", style: .default, handler: nil))
        alert.finish()
    }

    @objc func addImageClicked() {
        let alert = ObjectPopUp(self, "Graphical Products", addImageButton)
        (UtilityHomeScreen.localChoicesImages + GlobalArrays.nwsImageProducts).forEach { item in
            let list = item.split(":")
            alert.addAction(UIAlertAction(title: list[1], style: .default, handler: { _ in self.addProduct("IMG-" + list[0]) }))
        }
        alert.finish()
    }

    @objc func addTextClicked() {
        let alert = ObjectPopUp(self, "Text Products", addTextButton)
        UtilityWpcText.labelsWithCodes.forEach { item in
            let list = item.split(":")
            alert.addAction(UIAlertAction(title: list[1], style: .default, handler: { _ in self.addProduct("TXT-" + list[0]) }))
        }
        alert.finish()
    }

    @objc func setToDefault() {
        homeScreenFav = TextUtils.split(GlobalVariables.homescreenFavDefault, ":")
        display()
    }

    @objc func buttonPressed(sender: GestureData) {
        let index = sender.data
        let title = sender.strData
        let alert = ObjectPopUp(self, title, addButton)
        if index != 0 {
            alert.addAction(UIAlertAction(title: "Move Up", style: .default, handler: { _ in self.move(index, .up) }))
        }
        if index != (homeScreenFav.count - 1) {
            alert.addAction(UIAlertAction(title: "Move Down", style: .default, handler: { _ in self.move(index, .down) }))
        }
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { _ in self.delete(selection: index) }))
        alert.finish()
    }

    func move(_ from: Int, _ to: MotionType) {
        var delta = 1
        if to == .up {
            delta = -1
        }
        let tmp = homeScreenFav[from + delta]
        homeScreenFav[from + delta] = homeScreenFav[from]
        homeScreenFav[from] = tmp
        display()
    }

    // need to keep the label
    func delete(selection: Int) {
        homeScreenFav.remove(at: selection)
        display()
    }

    private func display(saveToDisk: Bool = true) {
        if saveToDisk {
            serializeSettings()
        }
        stackView.removeViews()
        homeScreenFav.enumerated().forEach { index, prefVar in
            var title = UtilityHomeScreen.localChoicesText[prefVar]
            let prefVarMod = prefVar.replace("TXT-", "").replace("IMG-", "")
            if title == nil {
                (UtilityHomeScreen.localChoicesImages + GlobalArrays.nwsImageProducts).forEach { label in
                    if label.hasPrefix(prefVarMod + ":") {
                        title = label.split(":")[1]
                    }
                }
            }
            if title == nil {
                UtilityWpcText.labelsWithCodes.forEach { label in
                    if label.hasPrefix(prefVarMod + ":") {
                        title = label.split(":")[1]
                    }
                }
            }
            if let goodTitle = title {
                let objectTextView = Text(
                    stackView,
                    goodTitle.trim(),
                    GestureData(index, goodTitle, self, #selector(buttonPressed))
                )
                objectTextView.isSelectable = false
                objectTextView.constrain(scrollView)
            } else {
                let objectTextView = Text(
                    stackView,
                    prefVar,
                    GestureData(index, prefVar, self, #selector(buttonPressed))
                )
                objectTextView.isSelectable = false
                objectTextView.constrain(scrollView)
            }
        }
    }
}
