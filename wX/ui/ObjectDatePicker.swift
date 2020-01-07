/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectDatePicker {

    let datePicker = UIDatePicker()

    init(_ stackView: UIStackView) {
        datePicker.backgroundColor = AppColors.primaryBackgroundBlueUIColor
        datePicker.setValue(UIColor.white, forKey: "textColor")
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.maximumDate = Date()
        stackView.addArrangedSubview(datePicker)
    }
}
