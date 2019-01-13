/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectNumberPicker {

    let sw = UIPickerView()
    let vw = UIButton(type: UIButton.ButtonType.system)

    init(_ stackView: UIStackView, _ prefVar: String, _ pickerMap: [String: String]) {
        let sV = ObjectStackView(.fill, .horizontal)
        let label = pickerMap[prefVar]
        vw.setTitle(label, for: .normal)
        vw.contentHorizontalAlignment = .left
        vw.backgroundColor = UIColor.white
        sw.backgroundColor = UIColor.white
        sV.addArrangedSubviews([vw, sw])
        stackView.addArrangedSubview(sV.view)
    }
}
