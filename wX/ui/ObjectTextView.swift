/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectTextView {

    let tv = UITextView()
    var textcolor = wXColor()

    init() {
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.font = UIFont.systemFont(ofSize: UIPreferences.textviewFontSize)
        tv.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
    }

    // UIScreen.main.bounds.width uiv.view.frame.width
    convenience init(_ text: String) {
        self.init()
        //self.tv.widthAnchor.constraint(equalToConstant: uiv.view.frame.width).isActive = true
        self.tv.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        self.tv.text = text
    }

    convenience init(_ stackView: UIStackView) {
        self.init()
        self.tv.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        stackView.addArrangedSubview(self.tv)
    }

    convenience init(_ stackView: UIStackView, _ text: String) {
        self.init()
        self.tv.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        self.tv.text = text
        stackView.addArrangedSubview(self.tv)
    }

    convenience init(_ stackView: UIStackView, _ text: String, _ font: UIFont, _ color: UIColor) {
        self.init()
        self.tv.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        self.tv.text = text
        self.color = color
        self.font = font
        stackView.addArrangedSubview(self.tv)
    }

    convenience init(_ stackView: UIStackView, _ text: String, _ font: UIFont) {
        self.init(stackView, text)
        self.font = font
    }

    convenience init(_ stackView: UIStackView, _ text: String, _ color: wXColor) {
        self.init(stackView, text)
        self.textcolor = color
    }

    convenience init(_ stackView: UIStackView, _ text: String, _ viewOrder: Int) {
        self.init(text)
        stackView.insertArrangedSubview(self.tv, at: viewOrder)
    }

    func addGestureRecognizer(_ gesture: UITapGestureRecognizer) {self.tv.addGestureRecognizer(gesture)}

    var color: UIColor {
        get {return tv.textColor!}
        set {tv.textColor = newValue}
    }

    var background: UIColor {
        get {return tv.backgroundColor!}
        set {tv.backgroundColor = newValue}
    }

    var font: UIFont {
        get {return tv.font!}
        set {tv.font = newValue}
    }

    var text: String {
        get {return tv.text}
        set {tv.text = newValue}
    }

    var textSize: Double {
        // FIXME not used but return a good value
        get {return 0}
        set {tv.font = UIFont.systemFont(ofSize: UIPreferences.textviewFontSize * CGFloat(newValue))}
    }

    var tag: Int {
        get {return tv.tag}
        set {tv.tag = newValue}
    }

    func setZeroSpacing() {tv.textContainerInset = UIEdgeInsets.zero}

    // default is 8 0 8 0
    func setSpacing(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
        //tv.textContainerInset = UIEdgeInsetsMake(top, left, bottom, right)
        tv.textContainerInset = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }

    var view: UITextView {return tv}
}
