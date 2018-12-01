/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerSETTINGSRADAR: UIwXViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton]).items
        _ = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        Array(UtilitySettingsRadar.boolean.keys).sorted(by: <).enumerated().forEach { index, prefVar in
            let switchObject = ObjectSettingsSwitch(stackView,
                                                    prefVar,
                                                    UtilitySettingsRadar.booleanDefault,
                                                    UtilitySettingsRadar.boolean)
            switchObject.vw.addTarget(self, action: #selector(self.getHelp(sender:)), for: .touchUpInside)
            switchObject.sw.addTarget(self, action: #selector(self.switchChanged), for: UIControlEvents.valueChanged)
            switchObject.sw.tag = index
        }
        Array(UtilitySettingsRadar.picker.keys).sorted(by: <).enumerated().forEach { index, prefVar in
            let objNp = ObjectNumberPicker(stackView, prefVar, UtilitySettingsRadar.picker)
            objNp.sw.dataSource = self
            objNp.sw.delegate = self
            objNp.sw.tag = index
            if UtilitySettingsRadar.pickerNonZeroOffset.contains(prefVar) {
                objNp.sw.selectRow((UtilitySettingsRadar.pickerDataSource[prefVar]?.index(of: preferences.getString(prefVar, UtilitySettingsRadar.pickerinitString[prefVar]!))!)!,
                                   inComponent: 0,
                                   animated: true)
            } else {
                objNp.sw.selectRow(preferences.getInt(prefVar, UtilitySettingsRadar.pickerinit[prefVar]!),
                                   inComponent: 0,
                                   animated: true)
            }
        }
    }

    @objc override func doneClicked() {
        UtilityPolygons.initialized = false
        MyApplication.initPreferences()
        RadarGeometry.initialize()
        GeographyType.regen()
        PolygonType.regen()
        UtilityColorPaletteGeneric.loadColorMap("94")
        UtilityColorPaletteGeneric.loadColorMap("99")
        super.doneClicked()
    }

    @objc func switchChanged(sender: UISwitch) {
        let prefLabels = Array(UtilitySettingsRadar.boolean.keys).sorted(by: <)
        let isOnQ = sender.isOn
        var truthString = "false"
        if isOnQ {truthString = "true"}
        editor.putString(prefLabels[sender.tag], truthString)
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var array = Array(UtilitySettingsRadar.pickerCount.keys).sorted(by: <)
        return UtilitySettingsRadar.pickerCount[array[pickerView.tag]]!
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow int: Int, numberOfRowsInComponent component: Int) -> Int {
        var array = Array(UtilitySettingsRadar.pickerCount.keys).sorted(by: <)
        return UtilitySettingsRadar.pickerCount[array[pickerView.tag]]!
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {return 1}

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var array = Array(UtilitySettingsRadar.pickerDataSource.keys).sorted(by: <)
        return UtilitySettingsRadar.pickerDataSource[array[pickerView.tag]]![row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var array = Array(UtilitySettingsRadar.pickerDataSource.keys).sorted(by: <)
        switch pickerView.tag {
        default:
            if array[pickerView.tag]=="RADAR_COLOR_PALETTE_94"||array[pickerView.tag]=="RADAR_COLOR_PALETTE_99" {
                editor.putString(array[pickerView.tag], UtilitySettingsRadar.pickerDataSource[array[pickerView.tag]]![row])
            } else {
                editor.putInt(array[pickerView.tag], Int(UtilitySettingsRadar.pickerDataSource[array[pickerView.tag]]![row])!)
            }
        }
    }

    @objc func getHelp(sender: UIButton) {
        UtilitySettings.getHelp(sender, self, doneButton, UtilitySettingsRadar.helpStrings)
    }
}
