// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class ObjectCardStackView {

    private let stackView: StackView
    private let padding: CGFloat = 3.0

    init() {
        stackView = StackView()
    }

    init(arrangedSubviews: [UIView], alignment: UIStackView.Alignment = .top, axis: NSLayoutConstraint.Axis = .horizontal) {
        stackView = StackView(arrangedSubviews: arrangedSubviews)
        stackView.backgroundColor = ColorCompatibility.systemBackground
        stackView.distribution = .fill
        stackView.alignment = alignment
        stackView.axis = axis
        stackView.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stackView.isLayoutMarginsRelativeArrangement = true
    }
    
    init(_ objectStackView: ObjectStackView) {
        stackView = StackView(arrangedSubviews: [objectStackView.view])
        stackView.backgroundColor = ColorCompatibility.systemBackground
        stackView.distribution = .fill
        stackView.alignment = .top
        stackView.axis = .horizontal
        stackView.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stackView.isLayoutMarginsRelativeArrangement = true
    }
    
    func constrain(_ stackView: UIStackView) {
        stackView.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
    }
    
    func constrain(_ stackView: ObjectStackView) {
        stackView.get().widthAnchor.constraint(equalTo: stackView.get().widthAnchor).isActive = true
    }
    
    func addGesture(_ gesture: GestureData) {
        stackView.addGestureRecognizer(gesture)
    }
    
    func addGesture(_ gesture: UITapGestureRecognizer) {
        stackView.addGestureRecognizer(gesture)
    }
    
    var view: StackView { stackView }

    var color: UIColor {
        get { stackView.backgroundColor! }
        set { stackView.backgroundColor = newValue }
    }
    
    var isAccessibilityElement: Bool {
        get { stackView.isAccessibilityElement }
        set { stackView.isAccessibilityElement = newValue }
    }
    
    var accessibilityLabel: String {
        get { stackView.accessibilityLabel ?? "" }
        set { stackView.accessibilityLabel = newValue }
    }
    
    func get() -> UIStackView {
        stackView
    }
}
