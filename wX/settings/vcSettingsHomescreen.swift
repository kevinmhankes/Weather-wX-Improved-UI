/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcSettingsHomescreen: UIwXViewController {

    private let localChoicesText = [
        "TXT-CC2": "Current Conditions with Image",
        "TXT-HAZ": "Hazards",
        "TXT-7DAY2": "7 Day Forecast with Images",
        "TXT-AFDLOC": "Area Forecast Discussion",
        "TXT-HWOLOC": "Hazardous Weather Outlook",
        "TXT-HOURLY": "Hourly Forecast",
        "METAL-RADAR": "Local NEXRAD Radar"
    ]
    private let localChoicesImages = [
        "CARAIN: Local CA Radar",
        "WEATHERSTORY: Local NWS Weather Story",
        "WFOWARNINGS: Local NWS Office Warnings"
    ]
    private var homescreenFav = [String]()
    private var addImageButton = ObjectToolbarIcon()
    private var addTextButton = ObjectToolbarIcon()
    private var addButton = ObjectToolbarIcon()

    override func viewDidLoad() {
        super.viewDidLoad()
        addButton = ObjectToolbarIcon(self, .plus, #selector(addClicked))
        let defaultButton = ObjectToolbarIcon(title: "Set to default", self, #selector(setToDefault))
        addImageButton = ObjectToolbarIcon(title: "Image", self, #selector(addImageClicked))
        addTextButton = ObjectToolbarIcon(title: "Text", self, #selector(addTextClicked))
        toolbar.items = ObjectToolbarItems(
            [
                doneButton,
                GlobalVariables.flexBarButton,
                addTextButton,
                addImageButton,
                defaultButton,
                addButton
            ]
        ).items
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        deSerializeSettings()
        displayContent()
    }

    @objc override func doneClicked() {
        serializeSettings()
        MyApplication.initPreferences()
        super.doneClicked()
    }

    func serializeSettings() {
        Utility.writePref("HOMESCREEN_FAV", TextUtils.join(":", homescreenFav))
    }

    func deSerializeSettings() {
        homescreenFav = TextUtils.split(Utility.readPref(
            "HOMESCREEN_FAV",
            MyApplication.homescreenFavDefault), ":"
        )
    }

    @objc func addClicked() {
        let alert = ObjectPopUp(self, "Product Selection", addButton)
        Array(localChoicesText.keys).sorted().forEach { rid in
            alert.addAction(
                UIAlertAction(
                    title: localChoicesText[rid],
                    style: .default,
                    handler: { _ in self.addProduct(rid)}
                )
            )
        }
        alert.finish()
    }

    func addProduct(_ selection: String) {
        if homescreenFav.contains(selection) {
            getHelp(addButton, selection + " is already in the homescreen widgets list.")
        } else {
            homescreenFav.append(selection)
        }
        displayContent()
    }

    func getHelp(
        _ targetButton: UIBarButtonItem,
        _ help: String
    ) {
        let alert = ObjectPopUp(self, help, targetButton)
        alert.addAction(UIAlertAction(title: "", style: .default, handler: nil))
        alert.finish()
    }

    @objc func addImageClicked() {
        let alert = ObjectPopUp(self, "Graphical Products", addImageButton)
        (localChoicesImages + GlobalArrays.nwsImageProducts).forEach {
            let ridArr = $0.split(":")
            alert.addAction(
                UIAlertAction(
                    title: ridArr[1],
                    style: .default,
                    handler: { _ in self.addProduct("IMG-" + ridArr[0])}
                )
            )
        }
        alert.finish()
    }

    @objc func addTextClicked() {
        let alert = ObjectPopUp(self, "Text Products", addTextButton)
        UtilityWpcText.labels.forEach {
            let ridArr = $0.split(":")
            alert.addAction(
                UIAlertAction(
                    title: ridArr[1],
                    style: .default,
                    handler: { _ in self.addProduct("TXT-" + ridArr[0])}
                )
            )
        }
        alert.finish()
    }

    @objc func setToDefault() {
        homescreenFav = TextUtils.split(MyApplication.homescreenFavDefault, ":")
        displayContent()
    }

    @objc func buttonPressed(sender: UITapGestureRecognizerWithData) {
        let index = sender.data
        let title = sender.strData
        let alert = ObjectPopUp(self, title, addButton)
        if index != 0 {
            alert.addAction(UIAlertAction(title: "Move Up", style: .default, handler: { _ in self.move(index, .up)}))
        }
        if index != (homescreenFav.count - 1) {
            alert.addAction(
                UIAlertAction(title: "Move Down", style: .default, handler: { _ in self.move(index, .down)})
            )
        }
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { _ in self.delete(selection: index)}))
        alert.finish()
    }

    func move(_ from: Int, _ to: MotionType) {
        var delta = 1
        if to == .up {
            delta = -1
        }
        let tmp = homescreenFav[from + delta]
        homescreenFav[from + delta] = homescreenFav[from]
        homescreenFav[from] = tmp
        displayContent()
    }

    // need to keep the label
    func delete(selection: Int) {
        homescreenFav.remove(at: selection)
        displayContent()
    }

    private func displayContent() {
        self.stackView.subviews.forEach { $0.removeFromSuperview() }
        homescreenFav.enumerated().forEach { index, prefVar in
            var title = localChoicesText[prefVar]
            let prefVarMod = prefVar.replace("TXT-", "").replace("IMG-", "")
            if title == nil {
                (localChoicesImages + GlobalArrays.nwsImageProducts).forEach {
                    if $0.hasPrefix(prefVarMod) {
                        title = $0.split(":")[1]
                    }
                }
            }
            if title == nil {
                UtilityWpcText.labels.forEach {
                    if $0.hasPrefix(prefVarMod) {
                        title = $0.split(":")[1]
                    }
                }
            }
            if let goodTitle = title {
                let objectTextView = ObjectTextView(
                    stackView,
                    goodTitle.trim(),
                    UITapGestureRecognizerWithData(index, goodTitle, self, #selector(buttonPressed(sender:)))
                )
                objectTextView.tv.isSelectable = false
            } else {
                let objectTextView = ObjectTextView(
                    stackView,
                    prefVar,
                    UITapGestureRecognizerWithData(index, prefVar, self, #selector(buttonPressed(sender:)))
                )
                objectTextView.tv.isSelectable = false
            }
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: nil,
            completion: { _ -> Void in
                self.refreshViews()
                self.displayContent()
            }
        )
    }
}
