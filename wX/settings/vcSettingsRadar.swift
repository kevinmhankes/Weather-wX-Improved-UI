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
    private var switches = [Switch]()
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
//        Array(UtilitySettingsRadar.boolean.keys).sorted(by: <).enumerated().forEach { index, prefVar in
//            let switchObject = ObjectSettingsSwitch(
//                stackView,
//                prefVar,
//                UtilitySettingsRadar.booleanDefault,
//                UtilitySettingsRadar.boolean
//            )
//            switchObject.switchUi.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
//            switchObject.switchUi.tag = index
//            switches.append(switchObject)
//        }
        setupSwitch()
        setupSliders()
        setupComboBox()
    }
    
    func setupSwitch() {
        switches.append(Switch(stackView, "RADAR_CENTER_ON_LOCATION", "Center radar on location", "false"))
        switches.append(Switch(stackView, "RADAR_CAMX_BORDERS", "Canadian and Mexican borders", "false"))
        switches.append(Switch(stackView, "COD_CITIES_DEFAULT", "Cities", "false"))
        switches.append(Switch(stackView, "RADAR_SHOW_LEGEND", "Colormap Legend", "false"))
        switches.append(Switch(stackView, "RADAR_COUNTY_HIRES", "Counties use high resolution data", "false"))
        switches.append(Switch(stackView, "RADAR_SHOW_COUNTY", "County Lines", "true"))
        switches.append(Switch(stackView, "RADAR_COUNTY_LABELS", "County Labels", "false"))
        switches.append(Switch(stackView, "RADAR_SHOW_SWO", "Day 1 Convective Outlook", "false"))
        switches.append(Switch(stackView, "RADAR_SHOW_DSW", "Dust Storm Warning", "false"))
        switches.append(Switch(stackView, "RADAR_SHOW_HI", "Hail Index", "false"))
        switches.append(Switch(stackView, "COD_HW_DEFAULT", "Highways", "true"))
        switches.append(Switch(stackView, "COD_LAKES_DEFAULT", "Lakes and Rivers", "false"))
        switches.append(Switch(stackView, "COD_LOCDOT_DEFAULT", "Location markers", "true"))
        switches.append(Switch(stackView, "LOCDOT_FOLLOWS_GPS", "Location marker follows GPS", "false"))
        switches.append(Switch(stackView, "DUALPANE_SHARE_POSN", "Multi-pane: share lat/lon/zoom", "true"))
        switches.append(Switch(stackView, "WXOGL_OBS", "Observations", "false"))
        switches.append(Switch(stackView, "WXOGL_REMEMBER_LOCATION", "Remember location", "true"))
        switches.append(Switch(stackView, "WXOGL_SPOTTERS", "Spotters", "false"))
        switches.append(Switch(stackView, "WXOGL_SPOTTERS_LABEL", "Spotter Labels", "false"))
        switches.append(Switch(stackView, "RADAR_HW_ENH_EXT", "Secondary Roads", "false"))
        switches.append(Switch(stackView, "SHOW_RADAR_WHEN_PAN", "Show radar during a pan/drag motion", "true"))
        switches.append(Switch(stackView, "RADAR_SHOW_SQW", "Snow Squall Warning", "false"))
        switches.append(Switch(stackView, "RADAR_SHOW_SMW", "Special Marine Warning", "false"))
        switches.append(Switch(stackView, "RADAR_SHOW_SPS", "Special Weather Statement", "false"))
        switches.append(Switch(stackView, "RADAR_AUTOREFRESH", "Screen stays on and auto refresh radar", "false"))
        switches.append(Switch(stackView, "RADAR_STATE_HIRES", "States use high resolution data", "false"))
        switches.append(Switch(stackView, "RADAR_SHOW_STI", "Storm Tracks", "false"))
        switches.append(Switch(stackView, "RADAR_SHOW_TVS", "Tornado Vortex Signatures", "false"))
        switches.append(Switch(stackView, "COD_WARNINGS_DEFAULT", "Warnings (Tor/Tstorm/Ffw)", "true"))
        switches.append(Switch(stackView, "RADAR_SHOW_WATCH", "Watches and MCDs", "false"))
        switches.append(Switch(stackView, "WXOGL_OBS_WINDBARBS", "Windbarbs", "false"))
        switches.append(Switch(stackView, "RADAR_SHOW_WPC_FRONTS", "WPC Fronts and pressure highs and lows", "false"))
        switches.append(Switch(stackView, "RADAR_SHOW_MPD", "WPC MPD: Mesoscale Precipitation Discussions", "false"))
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
