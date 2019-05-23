/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectSlider {

    let button = UIButton(type: UIButton.ButtonType.system)
    let step: Float = 1 // If you want UISlider to snap to steps by 10

    init(
        _ uiv: UIViewController,
        _ stackView: UIStackView,
        _ prefVar: String,
        _ pickerMap: [String: String],
        _ pickerInit: [String: Int]
    ) {
        let label = pickerMap[prefVar]!
        let slider = UISlider(frame: CGRect(x: 10, y: 100, width: 300, height: 20))
        slider.minimumValue = 0
        slider.value = Float(Utility.readPref(prefVar, pickerInit[prefVar]!))
        slider.maximumValue = 100
        slider.isContinuous = true
        slider.thumbTintColor = AppColors.primaryColorFab
        button.setTitle(label + ": " + String(Int(slider.value)), for: .normal)
        button.contentHorizontalAlignment = .left
        button.backgroundColor = UIColor.white
        slider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
        let container = ObjectCardStackView(arrangedSubviews: [button, slider])
        //container.setAxis(.vertical)
        stackView.addArrangedSubview(container.view)
    }

    @objc func sliderValueDidChange(_ sender: UISlider!) {
        print("Slider value changed")
        // Use this code below only if you want UISlider to snap to values step by step
        let roundedStepValue = round(sender.value / step) * step
        sender.value = roundedStepValue
        print("Slider step value \(Int(roundedStepValue))")
        //print("Slider step value \(sender.value)")
    }
}
