/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class vcSettingsUI: UIwXViewController {

    private var objectSliders = [ObjectSlider]()
    private var switches = [ObjectSettingsSwitch]()
    private var numberPickers = [ComboBox]()

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
        
        Array(UtilitySettingsUI.boolean.keys).sorted(by: <).enumerated().forEach { index, prefVar in
            let switchObject = ObjectSettingsSwitch(
                stackView,
                prefVar,
                UtilitySettingsUI.booleanDefault,
                UtilitySettingsUI.boolean
            )
            switchObject.addTarget()
            switchObject.switchUi.tag = index
            switches.append(switchObject)
        }
        setupSliders()
        setupComboBox()
    }
    
    func setupComboBox() {
        numberPickers.append(ComboBox(stackView, "UI_THEME", "Color theme", "blue", ["blue", "black", "green"]))
    }

    func setupSliders() {
        for pref in UtilitySettingsUI.sliderPreferences {
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
