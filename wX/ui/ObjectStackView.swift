/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectStackView {

    private let uiStackView = UIStackView()
    
    // for a normal UIStackView:
    // default distribution is .fill
    // default aix is .horizontal
    // default spacing is 0.0

    init(
        _ distribution: UIStackView.Distribution,
        _ axis: NSLayoutConstraint.Axis,
        spacing: CGFloat = 0.0,
        arrangedSubviews: [UIView] = []
    ) {
        uiStackView.distribution = distribution
        uiStackView.axis = axis
        uiStackView.spacing = spacing
        if !arrangedSubviews.isEmpty {
            arrangedSubviews.forEach {
                uiStackView.addArrangedSubview($0)
            }
        }
    }
    
    func constrain(_ uiv: UIwXViewController) {
        uiStackView.widthAnchor.constraint(equalTo: uiv.scrollView.widthAnchor).isActive = true
    }
    
    func constrain(_ scrollView: UIScrollView) {
        uiStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
    
    func constrain(_ stackView: UIStackView) {
        uiStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
    }
    
    func constrain(_ stackView: ObjectStackView) {
        uiStackView.widthAnchor.constraint(equalTo: stackView.get().widthAnchor).isActive = true
    }
    
    func constrain(_ stackView: UIStackView, _ padding: CGFloat) {
        uiStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: padding).isActive = true
    }
    
    func constrain(_ stackView: ObjectStackView, _ padding: CGFloat) {
        uiStackView.widthAnchor.constraint(equalTo: stackView.get().widthAnchor, constant: padding).isActive = true
    }
    
    func addWidget(_ w: UIView) {
        uiStackView.addArrangedSubview(w)
    }
    
    func addLayout(_ w: UIView) {
        uiStackView.addArrangedSubview(w)
    }
    
    func addLayout(_ layout: ObjectStackView) {
        uiStackView.addArrangedSubview(layout.get())
    }
    
    func addLayout(_ layout: ObjectCardStackView) {
        uiStackView.addArrangedSubview(layout.get())
    }
    
    func addLayout(_ layout: ObjectStackViewHS) {
        uiStackView.addArrangedSubview(layout.get())
    }
    
    func addGesture(_ gesture: GestureData) {
        uiStackView.addGestureRecognizer(gesture)
    }

    func addGesture(_ gesture: UIGestureRecognizer) {
        uiStackView.addGestureRecognizer(gesture)
    }
    
    func get() -> UIStackView {
        uiStackView
    }
    
    func removeViews() {
        uiStackView.removeViews()
    }
    
    func removeChildren() {
        uiStackView.subviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
    func removeAllChildren() {
        get().removeViews()
        get().removeFromSuperview()
    }
    
    func removeArrangedViews() {
        get().removeArrangedViews()
    }
    
    var color: UIColor {
        get { uiStackView.backgroundColor! }
        set { uiStackView.backgroundColor = newValue }
    }
    
    var isAccessibilityElement: Bool {
        get { uiStackView.isAccessibilityElement }
        set { uiStackView.isAccessibilityElement = newValue }
    }
    
    var isHidden: Bool {
        get { uiStackView.isHidden }
        set { uiStackView.isHidden = newValue }
    }
    
    var axis: NSLayoutConstraint.Axis {
        get { uiStackView.axis }
        set { uiStackView.axis = newValue }
    }
    
    var spacing: CGFloat {
        get { uiStackView.spacing }
        set { uiStackView.spacing = newValue }
    }

    var accessibilityLabel: String {
        get { uiStackView.accessibilityLabel ?? "" }
        set { uiStackView.accessibilityLabel = newValue }
    }

    var alignment: UIStackView.Alignment {
        get { uiStackView.alignment }
        set { uiStackView.alignment = newValue }
    }
        
    var view: UIStackView { uiStackView }
}
