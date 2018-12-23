/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerSETTINGSUI: UIwXViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton]).items
        _ = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        Array(UtilitySettingsUI.boolean.keys).sorted(by: <).enumerated().forEach {
            let switchObject = ObjectSettingsSwitch(stackView,
                                                    $1,
                                                    UtilitySettingsUI.booleanDefault,
                                                    UtilitySettingsUI.boolean)
            switchObject.vw.addTarget(self,
                                      action: #selector(self.getHelp(sender:)),
                                      for: .touchUpInside)
            switchObject.sw.addTarget(self,
                                      action: #selector(self.switchChanged(sender:)),
                                      for: UIControlEvents.valueChanged)
            switchObject.sw.tag = $0
        }
        generatePickerValues("REFRESH_LOC_MIN", from: 0, to: 121, by: 1)
        generatePickerValues("ANIM_INTERVAL", from: 0, to: 16, by: 1)
        generatePickerValues("HOMESCREEN_TEXT_LENGTH_PREF", from: 250, to: 2000, by: 250)
        Array(UtilitySettingsUI.picker.keys).sorted(by: <).enumerated().forEach { index, prefVar in
            let objNp = ObjectNumberPicker(stackView, prefVar, UtilitySettingsUI.picker)
            objNp.sw.dataSource = self
            objNp.sw.delegate = self
            objNp.sw.tag = index
            objNp.vw.addTarget(self, action: #selector(self.getHelp(sender:)), for: .touchUpInside)
            if UtilitySettingsUI.pickerNonZeroOffset.contains(prefVar) {
                let prefValue = preferences.getString(prefVar, UtilitySettingsUI.pickerinit[prefVar]!)
                var defaultRowIndex = UtilitySettingsUI.pickerDataSource[prefVar]?.index(of: prefValue)
                if defaultRowIndex == nil {
                    defaultRowIndex = 0
                }
                objNp.sw.selectRow(defaultRowIndex!, inComponent: 0, animated: true)
            } else {
                objNp.sw.selectRow(preferences.getInt(prefVar, Int(UtilitySettingsUI.pickerinit[prefVar]!)!),
                                   inComponent: 0,
                                   animated: true)
            }
        }
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
        editor.putString(prefLabels[sender.tag], truthString)
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
            if array[pickerView.tag]=="UI_THEME" {
                editor.putString(array[pickerView.tag], UtilitySettingsUI.pickerDataSource[array[pickerView.tag]]![row])
            } else {
                editor.putInt(array[pickerView.tag],
                              Int(UtilitySettingsUI.pickerDataSource[array[pickerView.tag]]![row])!)
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
}
