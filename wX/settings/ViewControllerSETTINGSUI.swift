/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerSETTINGSUI: UIwXViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        let statusButton = ObjectToolbarIcon(title: "version: " + UtilityUI.getVersion(), self, nil)
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, statusButton]).items
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        UtilityUI.determineDeviceType()
        self.displayContent()
    }

    @objc override func doneClicked() {
        MyApplication.initPreferences()
        AppColors.update()
        super.doneClicked()
    }

    @objc func switchChanged(sender: UISwitch) {
        let prefLabels = [String](UtilitySettingsUI.boolean.keys).sorted(by: <)
        let isOnQ = sender.isOn
        var truthString = "false"
        if isOnQ {
            truthString = "true"
        }
        Utility.writePref(prefLabels[sender.tag], truthString)
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var array = Array(UtilitySettingsUI.pickerCount.keys).sorted(by: <)
        return UtilitySettingsUI.pickerCount[array[pickerView.tag]]!
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow int: Int, numberOfRowsInComponent component: Int) -> Int {
        var array = Array(UtilitySettingsUI.pickerCount.keys).sorted(by: <)
        return UtilitySettingsUI.pickerCount[array[pickerView.tag]]!
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var array = Array(UtilitySettingsUI.pickerDataSource.keys).sorted(by: <)
        return UtilitySettingsUI.pickerDataSource[array[pickerView.tag]]![row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var array = Array(UtilitySettingsUI.pickerDataSource.keys).sorted(by: <)
        switch pickerView.tag {
        default:
            if array[pickerView.tag] == "UI_THEME" {
                Utility.writePref(
                    array[pickerView.tag],
                    UtilitySettingsUI.pickerDataSource[array[pickerView.tag]]![row]
                )
            } else {
                Utility.writePref(
                    array[pickerView.tag],
                    Int(UtilitySettingsUI.pickerDataSource[array[pickerView.tag]]![row])!
                )
            }
        }
    }

    func generatePickerValues(_ key: String, from: Int, to: Int, by: Int) {
        UtilitySettingsUI.pickerDataSource[key] = []
        stride(from: from, to: to, by: by).forEach {UtilitySettingsUI.pickerDataSource[key]!.append(String($0))}
    }

    @objc func getHelp(sender: UIButton) {
        UtilitySettings.getHelp(sender, self, doneButton, UtilitySettingsUI.helpStrings)
    }

    private func displayContent() {
        Array(UtilitySettingsUI.boolean.keys).sorted(by: <).enumerated().forEach {
            let switchObject = ObjectSettingsSwitch(
                stackView,
                $1,
                UtilitySettingsUI.booleanDefault,
                UtilitySettingsUI.boolean
            )
            switchObject.button.addTarget(
                self,
                action: #selector(getHelp(sender:)),
                for: .touchUpInside
            )
            switchObject.switchUi.addTarget(
                self,
                action: #selector(switchChanged(sender:)),
                for: UIControl.Event.valueChanged
            )
            switchObject.switchUi.tag = $0
        }
        // TODO move into maps in util
        generatePickerValues("REFRESH_LOC_MIN", from: 0, to: 121, by: 1)
        generatePickerValues("ANIM_INTERVAL", from: 0, to: 16, by: 1)
        generatePickerValues("HOMESCREEN_TEXT_LENGTH_PREF", from: 250, to: 2000, by: 250)
        generatePickerValues("NWS_ICON_SIZE_PREF", from: 0, to: 100, by: 1)
        Array(UtilitySettingsUI.picker.keys).sorted(by: <).enumerated().forEach { index, prefVar in
            let objNp = ObjectNumberPicker(stackView, prefVar, UtilitySettingsUI.picker)
            objNp.numberPicker.dataSource = self
            objNp.numberPicker.delegate = self
            objNp.numberPicker.tag = index
            objNp.button.addTarget(self, action: #selector(getHelp(sender:)), for: .touchUpInside)
            if UtilitySettingsUI.pickerNonZeroOffset.contains(prefVar) {
                let prefValue = Utility.readPref(prefVar, UtilitySettingsUI.pickerinit[prefVar]!)
                var defaultRowIndex = UtilitySettingsUI.pickerDataSource[prefVar]?.firstIndex(of: prefValue)
                if defaultRowIndex == nil {
                    defaultRowIndex = 0
                }
                objNp.numberPicker.selectRow(defaultRowIndex!, inComponent: 0, animated: true)
            } else {
                objNp.numberPicker.selectRow(
                    Utility.readPref(prefVar, Int(UtilitySettingsUI.pickerinit[prefVar]!)!),
                    inComponent: 0,
                    animated: true
                )
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
