/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class Text {

    private let tv = UITextView()
    var textColor = wXColor()

    init() {
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.font = FontSize.medium.size
        tv.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
    }

    convenience init(_ stackView: UIStackView) {
        self.init()
        stackView.addArrangedSubview(tv)
        tv.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
    }
    
    convenience init(
        _ stackView: UIStackView,
        _ text: String,
        isUserInteractionEnabled: Bool = true,
        isZeroSpacing: Bool = false,
        widthDivider: Int = 1
    ) {
        self.init()
        stackView.addArrangedSubview(tv)
        if widthDivider == 1 {
            tv.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        } else {
            tv.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1.0 / CGFloat(widthDivider)).isActive = true
        }
        tv.text = text
        tv.isUserInteractionEnabled = isUserInteractionEnabled
        if isZeroSpacing {
            setZeroSpacing()
        }
    }
    
    convenience init(
        _ text: String,
        isUserInteractionEnabled: Bool = true,
        isZeroSpacing: Bool = false
    ) {
        self.init()
        tv.text = text
        tv.isUserInteractionEnabled = isUserInteractionEnabled
        if isZeroSpacing {
            setZeroSpacing()
        }
    }

    convenience init(_ stackView: UIStackView, _ text: String, _ gesture: UITapGestureRecognizer) {
        self.init(stackView, text)
        addGestureRecognizer(gesture)
    }

    convenience init(_ stackView: UIStackView, _ text: String, _ font: UIFont, _ color: UIColor) {
        self.init()
        tv.text = text
        self.color = color
        self.font = font
        stackView.addArrangedSubview(tv)
        tv.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
    }

    convenience init(_ stackView: UIStackView, _ text: String, _ font: UIFont) {
        self.init(stackView, text)
        self.font = font
    }

    convenience init(_ stackView: UIStackView, _ text: String, _ font: UIFont, _ gesture: UITapGestureRecognizer) {
        self.init(stackView, text, font)
        addGestureRecognizer(gesture)
    }

    convenience init(_ stackView: UIStackView, _ text: String, _ color: wXColor) {
        self.init(stackView, text)
        textColor = color
    }

    func addGestureRecognizer(_ gesture: UITapGestureRecognizer) {
        tv.addGestureRecognizer(gesture)
    }

    var color: UIColor {
        get { tv.textColor! }
        set { tv.textColor = newValue }
    }
    
    var isAccessibilityElement: Bool {
        get { tv.isAccessibilityElement }
        set { tv.isAccessibilityElement = newValue }
    }
    
    var accessibilityLabel: String {
        get { tv.accessibilityLabel ?? "" }
        set { tv.accessibilityLabel = newValue }
    }
    
    var isSelectable: Bool {
        get { tv.isSelectable }
        set { tv.isSelectable = newValue }
    }
    
    var isHidden: Bool {
        get { tv.isHidden }
        set { tv.isHidden = newValue }
    }
    
    var textAlignment: NSTextAlignment {
        get { tv.textAlignment }
        set { tv.textAlignment = newValue }
    }

    var background: UIColor {
        get { tv.backgroundColor! }
        set { tv.backgroundColor = newValue }
    }

    var font: UIFont {
        get { tv.font! }
        set { tv.font = newValue }
    }

    var text: String {
        get { tv.text }
        set { tv.text = newValue }
    }

    func setText(_ s: String) {
        tv.text = s
    }

    func setZeroSpacing() {
        tv.textContainerInset = UIEdgeInsets.zero
    }

    func constrain(_ scrollView: UIScrollView) {
        tv.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
    
    func constrain(_ stackView: UIStackView) {
        tv.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
    }

    var view: UITextView { tv }
}
