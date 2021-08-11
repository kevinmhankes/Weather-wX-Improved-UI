// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class TextSmallGray {

    private let tv = UITextView()

    init(text: String = "", isUserInteractionEnabled: Bool = true) {
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isEditable = false
        tv.isScrollEnabled = false
        tv.font = FontSize.small.size
        tv.textContainerInset = UIEdgeInsets.zero
        tv.textColor = ColorCompatibility.secondaryLabel
        self.text = text
        tv.isUserInteractionEnabled = isUserInteractionEnabled
    }
    
    func constrain(_ view: ObjectStackView) {
        tv.widthAnchor.constraint(equalTo: view.get().widthAnchor).isActive = true
    }

    func resetTextSize() {
        tv.font = FontSize.medium.size
    }
    
    func addGesture(_ gesture: UITapGestureRecognizer) {
        tv.addGestureRecognizer(gesture)
    }

    var text: String {
        get { tv.text }
        set { tv.text = newValue }
    }
    
    var isAccessibilityElement: Bool {
        get { tv.isAccessibilityElement }
        set { tv.isAccessibilityElement = newValue }
    }
    
    var view: UITextView { tv }
}
