/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

public class ObjectScrollStackView {

    var fragmentHeightAnchor1: NSLayoutConstraint?
    var fragmentHeightAnchor2: NSLayoutConstraint?
    var fragmentCenterAnchor: NSLayoutConstraint?

    init(_ uiv: UIViewController, _ scrollView: UIScrollView, _ stackView: UIStackView) {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        uiv.view.addSubview(scrollView)
        scrollView.leadingAnchor.constraint(equalTo: uiv.view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: uiv.view.trailingAnchor).isActive = true
        scrollView.centerXAnchor.constraint(equalTo: uiv.view.centerXAnchor).isActive = true
        let topSpace = UtilityUI.getTopPadding()
        let bottomSpace = -(UtilityUI.getBottomPadding() + UIPreferences.toolbarHeight)
        scrollView.topAnchor.constraint(equalTo: uiv.view.topAnchor, constant: topSpace).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: uiv.view.bottomAnchor, constant: bottomSpace).isActive = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        stackView.axis = .vertical
        stackView.spacing = UIPreferences.stackviewCardSpacing
        scrollView.addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        //scrollView.backgroundColor = UIColor.white
    }

    // TODO fold in above
    convenience init(
        _ uiv: UIViewController,
        _ scrollView: UIScrollView,
        _ stackView: UIStackView,
        _ toolbar: UIToolbar
        ) {
        self.init(uiv, scrollView, stackView)
        uiv.view.addSubview(toolbar)
    }

    init(_ uiv: UIViewController, _ scrollView: UIScrollView, _ stackView: UIStackView, _ type: LayoutType) {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        uiv.view.addSubview(scrollView)
        scrollView.leadingAnchor.constraint(equalTo: uiv.view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: uiv.view.trailingAnchor).isActive = true
        scrollView.centerXAnchor.constraint(equalTo: uiv.view.centerXAnchor).isActive = true
        let topSpace = 48 + UtilityUI.getTopPadding()
        fragmentHeightAnchor1 = scrollView.centerXAnchor.constraint(equalTo: uiv.view.centerXAnchor)
        fragmentHeightAnchor2 = scrollView.topAnchor.constraint(equalTo: uiv.view.topAnchor, constant: topSpace)
        fragmentCenterAnchor = scrollView.bottomAnchor.constraint(equalTo: uiv.view.bottomAnchor, constant: -52.0)
        uiv.view.addConstraints([fragmentHeightAnchor1!, fragmentHeightAnchor2!, fragmentCenterAnchor!])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = UIPreferences.stackviewCardSpacing
        stackView.alignment = .center
        stackView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        scrollView.addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 4.0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -4.0).isActive = true
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
}
