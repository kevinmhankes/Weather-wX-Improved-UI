/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class NumberPicker: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let numberPicker = UIPickerView()
    private let button = UIButton(type: UIButton.ButtonType.system)
    let prefVar: String

    init(_ stackView: UIStackView, _ prefVar: String, _ pickerMap: [String: String]) {
        self.prefVar = prefVar
        super.init()
        let label = pickerMap[prefVar]
        button.setTitle(label, for: .normal)
        button.titleLabel?.font = FontSize.medium.size
        button.setTitleColor(ColorCompatibility.label, for: .normal)
        button.contentHorizontalAlignment = .left
        button.backgroundColor = ColorCompatibility.systemBackground
        numberPicker.backgroundColor = ColorCompatibility.systemBackground
        let horizontalContainer = ObjectCardStackView(arrangedSubviews: [button, numberPicker], alignment: .center)
        stackView.addArrangedSubview(horizontalContainer.view)
        
        numberPicker.dataSource = self
        numberPicker.delegate = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // let array = Array(UtilitySettingsUI.pickerCount.keys).sorted(by: <)
        return UtilitySettingsUI.pickerCount[prefVar]!
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow int: Int, numberOfRowsInComponent component: Int) -> Int {
        // let array = Array(UtilitySettingsUI.pickerCount.keys).sorted(by: <)
        return UtilitySettingsUI.pickerCount[prefVar]!
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // let array = Array(UtilitySettingsUI.pickerDataSource.keys).sorted(by: <)
        return UtilitySettingsUI.pickerDataSource[prefVar]![row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let array = Array(UtilitySettingsUI.pickerDataSource.keys).sorted(by: <)
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
}
