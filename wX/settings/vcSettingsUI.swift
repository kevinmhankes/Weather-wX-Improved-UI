/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class vcSettingsUI: UIwXViewController {
    // , UIPickerViewDelegate, UIPickerViewDataSource

    // private var objectIdToSlider = [ObjectIdentifier: ObjectSlider]()
    private var objectSliders = [ObjectSlider]()
    private var switches = [ObjectSettingsSwitch]()
    private var numberPickers = [NumberPicker]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let statusButton = ToolbarIcon(title: "version: " + UtilityUI.getVersion(), self, nil)
        toolbar.items = ToolbarItems([doneButton, GlobalVariables.flexBarButton, statusButton]).items
        objScrollStackView = ScrollStackView(self)
        UtilityUI.determineDeviceType()
        display()
    }

    override func doneClicked() {
        MyApplication.initPreferences()
        AppColors.update()
        super.doneClicked()
    }

//    @objc func switchChanged(sender: UISwitch) {
//        let prefLabels = [String](UtilitySettingsUI.boolean.keys).sorted(by: <)
//        let isOnQ = sender.isOn
//        var truthString = "false"
//        if isOnQ {
//            truthString = "true"
//        }
//        Utility.writePref(prefLabels[sender.tag], truthString)
//    }

//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        let array = Array(UtilitySettingsUI.pickerCount.keys).sorted(by: <)
//        return UtilitySettingsUI.pickerCount[array[pickerView.tag]]!
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow int: Int, numberOfRowsInComponent component: Int) -> Int {
//        let array = Array(UtilitySettingsUI.pickerCount.keys).sorted(by: <)
//        return UtilitySettingsUI.pickerCount[array[pickerView.tag]]!
//    }
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        let array = Array(UtilitySettingsUI.pickerDataSource.keys).sorted(by: <)
//        return UtilitySettingsUI.pickerDataSource[array[pickerView.tag]]![row]
//    }
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        let array = Array(UtilitySettingsUI.pickerDataSource.keys).sorted(by: <)
//        switch pickerView.tag {
//        default:
//            if array[pickerView.tag] == "UI_THEME" {
//                Utility.writePref(
//                    array[pickerView.tag],
//                    UtilitySettingsUI.pickerDataSource[array[pickerView.tag]]![row]
//                )
//            } else {
//                Utility.writePref(
//                    array[pickerView.tag],
//                    Int(UtilitySettingsUI.pickerDataSource[array[pickerView.tag]]![row])!
//                )
//            }
//        }
//    }

    private func display() {
        switches.removeAll()
        objectSliders.removeAll()
        
        Array(UtilitySettingsUI.boolean.keys).sorted(by: <).enumerated().forEach { index, prefVar in
            let switchObject = ObjectSettingsSwitch(
                stackView,
                prefVar,
                UtilitySettingsUI.booleanDefault,
                UtilitySettingsUI.boolean
            )
//            switchObject.switchUi.addTarget(
//                self,
//                action: #selector(switchChanged),
//                for: UIControl.Event.valueChanged
//            )
            switchObject.addTarget()
            switchObject.switchUi.tag = index
            switches.append(switchObject)
        }
        setupSliders()
        Array(UtilitySettingsUI.picker.keys).sorted(by: <).enumerated().forEach { index, prefVar in
            let objNp = NumberPicker(stackView, prefVar, UtilitySettingsUI.picker)
//            objNp.numberPicker.dataSource = self
//            objNp.numberPicker.delegate = self
            objNp.numberPicker.tag = index
            numberPickers.append(objNp)
            if UtilitySettingsUI.pickerNonZeroOffset.contains(prefVar) {
                let prefValue = Utility.readPref(prefVar, UtilitySettingsUI.pickerInit[prefVar]!)
                var defaultRowIndex = UtilitySettingsUI.pickerDataSource[prefVar]?.firstIndex(of: prefValue)
                if defaultRowIndex == nil {
                    defaultRowIndex = 0
                }
                objNp.numberPicker.selectRow(defaultRowIndex!, inComponent: 0, animated: true)
            } else {
                objNp.numberPicker.selectRow(
                    Utility.readPref(prefVar, Int(UtilitySettingsUI.pickerInit[prefVar]!)!),
                    inComponent: 0,
                    animated: true
                )
            }
        }
    }

    func setupSliders() {
//        [
//            "TEXTVIEW_FONT_SIZE",
//            "REFRESH_LOC_MIN",
//            "ANIM_INTERVAL",
//            "UI_TILES_PER_ROW",
//            "HOMESCREEN_TEXT_LENGTH_PREF",
//            "NWS_ICON_SIZE_PREF"
//            ].forEach { pref in
        for pref in UtilitySettingsUI.sliderPreferences {
                objectSliders.append(ObjectSlider(self, pref))
                // let objSlider = ObjectSlider(self, pref)
//                objSlider.slider.addTarget(self, action: #selector(sliderValueDidChange), for: .valueChanged)
                // objectIdToSlider[ObjectIdentifier(objSlider.slider)] = objSlider
        }
    }

//    @objc func sliderValueDidChange(_ sender: UISlider!) {
//        let objId = ObjectIdentifier(sender)
//        let objSlider = objectIdToSlider[objId]!
//        objSlider.setLabel()
//        Utility.writePref(objectIdToSlider[objId]!.prefVar, Int(sender!.value))
//    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: nil,
            completion: { _ in
                self.refreshViews()
                self.display()
            }
        )
    }
}
