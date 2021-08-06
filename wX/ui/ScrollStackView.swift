// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class ScrollStackView {

    var fragmentHeightAnchor1: NSLayoutConstraint?
    var fragmentHeightAnchor2: NSLayoutConstraint?
    var fragmentWidthAnchor1: NSLayoutConstraint?
    var fragmentWidthAnchor2: NSLayoutConstraint?

    init(_ uiv: UIwXViewController) {
        uiv.scrollView.backgroundColor = ColorCompatibility.systemGray5
        uiv.scrollView.translatesAutoresizingMaskIntoConstraints = false
        uiv.view.addSubview(uiv.scrollView)
        uiv.scrollView.leadingAnchor.constraint(equalTo: uiv.view.leadingAnchor).isActive = true
        uiv.scrollView.trailingAnchor.constraint(equalTo: uiv.view.trailingAnchor).isActive = true
        uiv.scrollView.centerXAnchor.constraint(equalTo: uiv.view.centerXAnchor).isActive = true
        let topSpace = UtilityUI.getTopPadding()
        let bottomSpace = -(UtilityUI.getBottomPadding() + UIPreferences.toolbarHeight)
        uiv.scrollView.topAnchor.constraint(equalTo: uiv.view.topAnchor, constant: topSpace).isActive = true
        uiv.scrollView.bottomAnchor.constraint(equalTo: uiv.view.bottomAnchor, constant: bottomSpace).isActive = true
        uiv.stackView.get().translatesAutoresizingMaskIntoConstraints = false
        uiv.stackView.get().axis = .vertical
        uiv.stackView.spacing = UIPreferences.stackviewCardSpacing
        uiv.scrollView.addSubview(uiv.stackView.get())
        uiv.stackView.get().leadingAnchor.constraint(equalTo: uiv.scrollView.leadingAnchor).isActive = true
        uiv.stackView.get().trailingAnchor.constraint(equalTo: uiv.scrollView.trailingAnchor).isActive = true
        uiv.stackView.get().topAnchor.constraint(equalTo: uiv.scrollView.topAnchor).isActive = true
        uiv.stackView.get().bottomAnchor.constraint(equalTo: uiv.scrollView.bottomAnchor).isActive = true
        uiv.view.addSubview(uiv.toolbar)
        uiv.scrollView.bottomAnchor.constraint(equalTo: uiv.toolbar.topAnchor).isActive = true
    }

    // TODO use dynamic calc: let height = self.tabBarController?.tabBar.frame.height ?? 49.0
    init(_ uiv: UIViewController, _ scrollView: UIScrollView, _ stackView: UIStackView) {
        scrollView.backgroundColor = ColorCompatibility.systemGray5
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        uiv.view.addSubview(scrollView)
        let topSpace = UtilityUI.getTopPadding() + UIPreferences.toolbarHeight
        fragmentHeightAnchor1 = scrollView.bottomAnchor.constraint(equalTo: uiv.view.bottomAnchor, constant: -UIPreferences.tabBarHeight)
        fragmentHeightAnchor2 = scrollView.topAnchor.constraint(equalTo: uiv.view.topAnchor, constant: topSpace)
        fragmentWidthAnchor1 = scrollView.leadingAnchor.constraint(equalTo: uiv.view.leadingAnchor)
        fragmentWidthAnchor2 = scrollView.widthAnchor.constraint(equalTo: uiv.view.widthAnchor)
        uiv.view.addConstraints([fragmentHeightAnchor1!, fragmentHeightAnchor2!, fragmentWidthAnchor1!, fragmentWidthAnchor2!])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = UIPreferences.stackviewCardSpacing
        stackView.alignment = .center
        scrollView.addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
}
