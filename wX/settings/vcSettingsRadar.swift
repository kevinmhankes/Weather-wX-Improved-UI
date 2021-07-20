/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import CoreLocation

final class vcSettingsRadar: UIwXViewController, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()
    // private var objectIdToSlider = [ObjectIdentifier: ObjectSlider]()
    private var objectSliders = [ObjectSlider]()
    private var switches = [ObjectSettingsSwitch]()
    private var numberPickers = [ComboBox]()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        let statusButton = ToolbarIcon(title: "version: " + UtilityUI.getVersion(), self, nil)
        toolbar.items = ToolbarItems([doneButton, GlobalVariables.flexBarButton, statusButton]).items
        objScrollStackView = ScrollStackView(self)
        display()
    }

    override func doneClicked() {
        MyApplication.initPreferences()
        // brute force, reset timers so that fresh data is downloaded next time in nexrad radar
        RadarGeometry.resetTimerOnRadarPolygons()
        RadarGeometry.initialize()
        GeographyType.regen()
        PolygonType.regen()
        UtilityColorPaletteGeneric.loadColorMap(94)
        UtilityColorPaletteGeneric.loadColorMap(99)
        super.doneClicked()
    }

    // TODO FIXME move to class
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
            default:
                print("future options")
            }
            locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
    }

    // needed for Radar/GPS setting
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {}

    private func display() {
        objectSliders.removeAll()
        switches.removeAll()
        Array(UtilitySettingsRadar.boolean.keys).sorted(by: <).enumerated().forEach { index, prefVar in
            let switchObject = ObjectSettingsSwitch(
                stackView,
                prefVar,
                UtilitySettingsRadar.booleanDefault,
                UtilitySettingsRadar.boolean
            )
            switchObject.switchUi.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
            switchObject.switchUi.tag = index
            switches.append(switchObject)
        }
        setupSliders()
        setupComboBox()
    }
    
    func setupComboBox() {
        numberPickers.append(ComboBox(stackView, "RADAR_COLOR_PALETTE_94", "Reflectivity Colormap", "CODENH", ["CODENH", "DKenh", "NSSL", "NWSD", "GREEN", "AF", "EAK", "NWS"]))
        numberPickers.append(ComboBox(stackView, "RADAR_COLOR_PALETTE_99", "Velocity Colormap", "CODENH", ["CODENH", "AF", "EAK"]))
    }

    func setupSliders() {
//        [
//            "RADAR_HI_SIZE",
//            "RADAR_TVS_SIZE",
//            "RADAR_LOCDOT_SIZE",
//            "RADAR_OBS_EXT_ZOOM",
//            "RADAR_SPOTTER_SIZE",
//            "RADAR_AVIATION_SIZE",
//            "RADAR_OBS_EXT_ZOOM",
//            "RADAR_DATA_REFRESH_INTERVAL",
//            "WXOGL_SIZE",
//            "RADAR_TEXT_SIZE"
//            ].forEach { pref in
        for pref in UtilitySettingsRadar.sliderPreferences {
                objectSliders.append(ObjectSlider(self, pref))
                // let objectSlider = ObjectSlider(self, pref)
                // objectSlider.slider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
                // objectIdToSlider[ObjectIdentifier(objectSlider.slider)] = objectSlider
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
        coordinator.animate(alongsideTransition: nil,
            completion: { _ in
                self.refreshViews()
                self.display()
            }
        )
    }
}
