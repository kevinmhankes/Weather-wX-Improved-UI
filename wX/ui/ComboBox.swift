/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ComboBox: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let numberPicker = UIPickerView()
    private let button = UIButton(type: UIButton.ButtonType.system)
    let prefVar: String
    let dataList: [String]

    init(
        _ stackView: UIStackView,
        _ prefVar: String,
        _ label: String,
        _ initialValue: String,
        _ dataList: [String]
    ) {
        self.prefVar = prefVar
        self.dataList = dataList
        super.init()
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
        
        let prefValue = Utility.readPref(prefVar, initialValue)
        var defaultRowIndex = dataList.firstIndex(of: prefValue)
        if defaultRowIndex == nil {
            defaultRowIndex = 0
        }
        numberPicker.selectRow(defaultRowIndex!, inComponent: 0, animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        dataList.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow int: Int, numberOfRowsInComponent component: Int) -> Int {
        dataList.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        dataList[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        Utility.writePref(prefVar, dataList[row])
    }
}
