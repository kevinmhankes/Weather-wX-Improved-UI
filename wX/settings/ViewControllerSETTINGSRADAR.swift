/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import CoreLocation

class ViewControllerSETTINGSRADAR: UIwXViewController, UIPickerViewDelegate,
UIPickerViewDataSource, CLLocationManagerDelegate {

    var locationManager = CLLocationManager()
    var objIdToSlider = [ObjectIdentifier: ObjectSlider]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.delegate = self
        let statusButton = ObjectToolbarIcon(title: "version: " + UtilityUI.getVersion(), self, nil)
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, statusButton]).items
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        self.displayContent()
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
        if isOnQ {
            truthString = "true"
        }
        Utility.writePref(prefLabels[sender.tag], truthString)
        if prefLabels[sender.tag] == "LOCDOT_FOLLOWS_GPS" && truthString == "true" {
            locationManager.requestWhenInUseAuthorization()
            switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse:
                print("already authorized")
            case .notDetermined, .restricted, .denied:
                print("show help")
                UtilitySettings.getHelp(
                    self,
                    doneButton,
                    "After the dialog for GPS permission has been shown once, all future updates to GPS"
                        + " permissions must be done via settings in iOS."
                )
            }
            locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
    }

    // needed for Radar/GPS setting
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var array = Array(UtilitySettingsRadar.pickerCount.keys).sorted(by: <)
        return UtilitySettingsRadar.pickerCount[array[pickerView.tag]]!
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow int: Int, numberOfRowsInComponent component: Int) -> Int {
        var array = Array(UtilitySettingsRadar.pickerCount.keys).sorted(by: <)
        return UtilitySettingsRadar.pickerCount[array[pickerView.tag]]!
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var array = Array(UtilitySettingsRadar.pickerDataSource.keys).sorted(by: <)
        return UtilitySettingsRadar.pickerDataSource[array[pickerView.tag]]![row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var array = Array(UtilitySettingsRadar.pickerDataSource.keys).sorted(by: <)
        switch pickerView.tag {
        default:
            if array[pickerView.tag] == "RADAR_COLOR_PALETTE_94" || array[pickerView.tag] == "RADAR_COLOR_PALETTE_99" {
                Utility.writePref(
                    array[pickerView.tag],
                    UtilitySettingsRadar.pickerDataSource[array[pickerView.tag]]![row]
                )
            } else {
                Utility.writePref(
                    array[pickerView.tag],
                    Int(UtilitySettingsRadar.pickerDataSource[array[pickerView.tag]]![row])!
                )
            }
        }
    }

    @objc func getHelp(sender: UIButton) {
        UtilitySettings.getHelp(sender, self, doneButton, UtilitySettingsRadar.helpStrings)
    }

    private func displayContent() {
        Array(UtilitySettingsRadar.boolean.keys).sorted(by: <).enumerated().forEach { index, prefVar in
            let switchObject = ObjectSettingsSwitch(
                stackView,
                prefVar,
                UtilitySettingsRadar.booleanDefault,
                UtilitySettingsRadar.boolean
            )
            switchObject.button.addTarget(self, action: #selector(getHelp(sender:)), for: .touchUpInside)
            switchObject.switchUi.addTarget(
                self, action: #selector(switchChanged), for: UIControl.Event.valueChanged
            )
            switchObject.switchUi.tag = index
        }
        Array(UtilitySettingsRadar.picker.keys).sorted(by: <).enumerated().forEach { index, prefVar in
            let objNp = ObjectNumberPicker(stackView, prefVar, UtilitySettingsRadar.picker)
            objNp.numberPicker.dataSource = self
            objNp.numberPicker.delegate = self
            objNp.numberPicker.tag = index
            objNp.button.addTarget(self, action: #selector(getHelp(sender:)), for: .touchUpInside)
            if UtilitySettingsRadar.pickerNonZeroOffset.contains(prefVar) {
                objNp.numberPicker.selectRow(
                    (UtilitySettingsRadar.pickerDataSource[prefVar]?.firstIndex(
                        of: Utility.readPref(prefVar, UtilitySettingsRadar.pickerinitString[prefVar]!))!
                        )!,
                    inComponent: 0,
                    animated: true
                )
            } else {
                objNp.numberPicker.selectRow(
                    Utility.readPref(
                        prefVar,
                        UtilitySettingsRadar.pickerinit[prefVar]!
                    ),
                    inComponent: 0,
                    animated: true
                )
            }
        }
        let objSlider = ObjectSlider(
            self,
            stackView,
            "RADAR_LOCDOT_SIZE",
            UtilitySettingsRadar.picker,
            UtilitySettingsRadar.pickerinit
        )
        let objSlider2 = ObjectSlider(
            self,
            stackView,
            "RADAR_SPOTTER_SIZE",
            UtilitySettingsRadar.picker,
            UtilitySettingsRadar.pickerinit
        )
        objSlider.slider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
        objSlider2.slider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)

        objIdToSlider[ObjectIdentifier(objSlider.slider)] = objSlider
        objIdToSlider[ObjectIdentifier(objSlider2.slider)] = objSlider2

        //print(ObjectIdentifier(objSlider))
    }

    @objc func sliderValueDidChange(_ sender: UISlider!) {
        print("Slider value changed " + String(sender.value) + " ")
        let objId = ObjectIdentifier(sender)
        //print(objId)
        //objIdToSlider[objId].button.setTitle(label + ": " + String(Int(slider.value)), for: .normal)
        objIdToSlider[objId]!.button.setTitle(String(sender!.value), for: .normal)
        
        // Use this code below only if you want UISlider to snap to values step by step
        //let roundedStepValue = round(sender.value / step) * step
        //sender.value = roundedStepValue
        //print("Slider step value \(Int(roundedStepValue))")
        //print("Slider step value \(sender.value)")
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
