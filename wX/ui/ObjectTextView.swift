/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectTextView {

    let tv = UITextView()
    var textColor = wXColor()

    init() {
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.font = FontSize.medium.size
        tv.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
    }

    convenience init(_ text: String, isUserInteractionEnabled: Bool = true, isZeroSpacing: Bool = false, widthDivider: Int = 1) {
        self.init()
        // FIXME need to use widthAnchor
        let (width, _) = UtilityUI.getScreenBoundsCGFloat()
        self.tv.widthAnchor.constraint(equalToConstant: width / CGFloat(widthDivider)).isActive = true
        //self.tv.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1.0 / CGFloat(widthDivider)).isActive = true
        self.tv.text = text
        self.tv.isUserInteractionEnabled = isUserInteractionEnabled
        if isZeroSpacing {
            setZeroSpacing()
        }
    }

    convenience init(_ stackView: UIStackView) {
        self.init()
        stackView.addArrangedSubview(self.tv)
        self.tv.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
    }

    convenience init(
        _ stackView: UIStackView,
        _ text: String,
        isUserInteractionEnabled: Bool = true,
        isZeroSpacing: Bool = false,
        widthDivider: Int = 1
    ) {
        self.init()
        stackView.addArrangedSubview(self.tv)
        if widthDivider == 1 {
            self.tv.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        } else {
            self.tv.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1.0 / CGFloat(widthDivider)).isActive = true
        }
        self.tv.text = text
        self.tv.isUserInteractionEnabled = isUserInteractionEnabled
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
        self.tv.text = text
        self.color = color
        self.font = font
        stackView.addArrangedSubview(self.tv)
        self.tv.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
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
        self.textColor = color
    }

    convenience init(_ stackView: UIStackView, _ text: String, _ viewOrder: Int) {
        self.init(text)
        stackView.insertArrangedSubview(self.tv, at: viewOrder)
    }

    func resetTextSize() {
        tv.font = FontSize.medium.size
    }

    func addGestureRecognizer(_ gesture: UITapGestureRecognizer) {
        self.tv.addGestureRecognizer(gesture)
    }

    var color: UIColor {
        get { tv.textColor! }
        set { tv.textColor = newValue }
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

    var tag: Int {
        get { tv.tag }
        set { tv.tag = newValue }
    }

    func setZeroSpacing() {
        tv.textContainerInset = UIEdgeInsets.zero
    }

    func setSpacing(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
        tv.textContainerInset = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    
    func constrain(_ scrollView: UIScrollView) {
        tv.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }

    var view: UITextView { tv }
}
