/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectCardPlayListItem {

    private let sV: ObjectCardStackView
    private let tv = ObjectTextViewLarge(80.0)
    private let tv2 = ObjectTextViewSmallGray(80.0)

    init(_ stackView: UIStackView, _ topLine: String, _ bottomLines: String) {
        tv.view.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .vertical)
        let sV2 = ObjectStackView(.fill, .vertical, 0, arrangedSubviews: [tv.view, tv2.view])
        sV2.view.alignment = UIStackView.Alignment.top
        let sVVertView = ObjectStackView(.fill, .vertical, 0, arrangedSubviews: [sV2.view])
        sV = ObjectCardStackView(arrangedSubviews: [sVVertView.view])
        tv.text = topLine
        tv2.text = bottomLines
        tv.view.isUserInteractionEnabled = false
        tv2.view.isUserInteractionEnabled = false
        stackView.addArrangedSubview(sV.view)
    }

    func addGestureRecognizer(_ gesture: UITapGestureRecognizerWithData) {
        sV.view.addGestureRecognizer(gesture)
        //tv2.view.addGestureRecognizer(gesture2)
    }
}
