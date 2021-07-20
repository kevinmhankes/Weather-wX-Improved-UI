/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class vcSettingsUI: UIwXViewController {

    private var objectSliders = [ObjectSlider]()
    private var switches = [Switch]()
    private var numberPickers = [ComboBox]()
    let sliderPreferences = [
        "TEXTVIEW_FONT_SIZE",
        "REFRESH_LOC_MIN",
        "ANIM_INTERVAL",
        "UI_TILES_PER_ROW",
        "HOMESCREEN_TEXT_LENGTH_PREF",
        "NWS_ICON_SIZE_PREF"
    ]

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

    private func display() {
        switches.removeAll()
        objectSliders.removeAll()
        setupSwitch()
        setupSliders()
        setupComboBox()
    }
    
    func setupSwitch() {
        switches.append(Switch(stackView, "BACK_ARROW_ANIM", "Animation with back arrow", "true"))
        switches.append(Switch(stackView, "DUALPANE_RADAR_ICON", "Lightning button opens dual pane radar", "false"))
        switches.append(Switch(stackView, "UI_MAIN_SCREEN_RADAR_FAB", "Main screen radar button (requires restart)", "true"))
        switches.append(Switch(stackView, "RADAR_TOOLBAR_TRANSPARENT", "Radar uses transparent toolbars", "true"))
        switches.append(Switch(stackView, "UI_MAIN_SCREEN_CONDENSE", "Show less information on main screen", "false"))
        switches.append(Switch(stackView, "GOES_USE_FULL_RESOLUTION_IMAGES", "Use full resolution GOES images", "false"))
        switches.append(Switch(stackView, "UNITS_M", "Use millibars", "true"))
        switches.append(Switch(stackView, "USE_NWS_API_SEVEN_DAY", "Use new NWS API for 7 day", "false"))
        switches.append(Switch(stackView, "USE_NWS_API_HOURLY", "Use new NWS API for hourly", "true"))
        switches.append(Switch(stackView, "WFO_REMEMBER_LOCATION", "WFO text viewer remembers location", "false"))
        switches.append(Switch(stackView, "DEBUG_MODE", "Debug mode - developer use", "false"))
    }
    
    func setupComboBox() {
        numberPickers.append(ComboBox(stackView, "UI_THEME", "Color theme", "blue", ["blue", "black", "green"]))
    }

    func setupSliders() {
        for pref in sliderPreferences {
            objectSliders.append(ObjectSlider(self, pref))
        }
    }

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
