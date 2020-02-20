/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

public class ObjectScrollStackView {

    var fragmentHeightAnchor1: NSLayoutConstraint?
    var fragmentHeightAnchor2: NSLayoutConstraint?
    var fragmentWidthAnchor1: NSLayoutConstraint?
    var fragmentWidthAnchor2: NSLayoutConstraint?
    var fragmentCenterAnchor: NSLayoutConstraint?

    init(_ uiv: UIViewController, _ scrollView: UIScrollView, _ stackView: UIStackView) {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        uiv.view.addSubview(scrollView)
        scrollView.leadingAnchor.constraint(equalTo: uiv.view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: uiv.view.trailingAnchor).isActive = true
        scrollView.centerXAnchor.constraint(equalTo: uiv.view.centerXAnchor).isActive = true
        let topSpace = UtilityUI.getTopPadding()
        let bottomSpace = -(UtilityUI.getBottomPadding() + UIPreferences.toolbarHeight)
        scrollView.topAnchor.constraint(equalTo: uiv.view.topAnchor, constant: topSpace).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: uiv.view.bottomAnchor, constant: bottomSpace).isActive = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = UIPreferences.stackviewCardSpacing
        scrollView.addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }

    convenience init(
        _ uiv: UIViewController,
        _ scrollView: UIScrollView,
        _ stackView: UIStackView,
        _ toolbar: UIToolbar
        ) {
        self.init(uiv, scrollView, stackView)
        uiv.view.addSubview(toolbar)
        scrollView.bottomAnchor.constraint(equalTo: toolbar.topAnchor).isActive = true
    }

    // TODO use dynamic calc: let height = self.tabBarController?.tabBar.frame.height ?? 49.0
    init(_ uiv: UIViewController, _ scrollView: UIScrollView, _ stackView: UIStackView, _ type: LayoutType) {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        uiv.view.addSubview(scrollView)
        let topSpace = UtilityUI.getTopPadding() + UIPreferences.toolbarHeight
        fragmentHeightAnchor1 = scrollView.centerXAnchor.constraint(equalTo: uiv.view.centerXAnchor)
        fragmentHeightAnchor2 = scrollView.topAnchor.constraint(equalTo: uiv.view.topAnchor, constant: topSpace)
        fragmentWidthAnchor1 = scrollView.leftAnchor.constraint(equalTo: uiv.view.leftAnchor)
        fragmentWidthAnchor2 = scrollView.rightAnchor.constraint(equalTo: uiv.view.rightAnchor)
        fragmentCenterAnchor = scrollView.bottomAnchor.constraint(equalTo: uiv.view.bottomAnchor, constant: -UIPreferences.tabBarHeight)
        uiv.view.addConstraints([fragmentHeightAnchor1!, fragmentHeightAnchor2!, fragmentCenterAnchor!, fragmentWidthAnchor1!, fragmentWidthAnchor2!])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = UIPreferences.stackviewCardSpacing
        stackView.alignment = .center
        stackView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        scrollView.addSubview(stackView)
        stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
    }
}
