/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectNumberPicker {

    let sw = UIPickerView()

    init(_ stackView: UIStackView, _ prefVar: String, _ pickerMap: [String: String]) {
        let sV = UIStackView()
        sV.spacing = 0
        sV.axis = .horizontal
        let label = pickerMap[prefVar]
        let vw = UIButton(type: UIButtonType.system)
        vw.setTitle(label, for: .normal)
        vw.contentHorizontalAlignment = .left
        vw.backgroundColor = UIColor.white
        sw.backgroundColor = UIColor.white
        sV.addArrangedSubview(vw)
        sV.addArrangedSubview(sw)
        stackView.addArrangedSubview(sV)
    }
}
