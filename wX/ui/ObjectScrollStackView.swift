/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

public class ObjectScrollStackView {

    var fragmentHeightConstraint: [NSLayoutConstraint]?

    init(_ uiv: UIViewController, _ scrollView: UIScrollView, _ stackView: UIStackView) {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        uiv.view.addSubview(scrollView)
        uiv.view.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[scrollView]|",
                options: .alignAllCenterX,
                metrics: nil,
                views: ["scrollView": scrollView]
            )
        )
        let topSpace = String(Int(Float(UtilityUI.getTopPadding())))
        uiv.view.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-" + topSpace + "-[scrollView]|",
                options: .alignAllCenterX,
                metrics: nil,
                views: ["scrollView": scrollView]
            )
        )
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        stackView.axis = .vertical
        stackView.spacing = UIPreferences.stackviewCardSpacing
        scrollView.addSubview(stackView)
        scrollView.addConstraints(
                NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[stackView]|",
                options: NSLayoutConstraint.FormatOptions.alignAllCenterX,
                metrics: nil,
                views: ["stackView": stackView]
            )
        )
        scrollView.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-" + "0" + "-[stackView]-50-|",
                options: NSLayoutConstraint.FormatOptions.alignAllCenterX,
                metrics: nil,
                views: ["stackView": stackView]
            )
        )
    }

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
        uiv.view.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|[scrollView]|",
                options: .alignAllCenterX,
                metrics: nil,
                views: ["scrollView": scrollView]
            )
        )
        let topSpace = String(48 + Int(Float(UtilityUI.getTopPadding())))
        fragmentHeightConstraint = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-" + topSpace + "-[scrollView]-52-|",
            options: .alignAllCenterX,
            metrics: nil,
            views: ["scrollView": scrollView]
        )
        uiv.view.addConstraints(fragmentHeightConstraint!)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = UIPreferences.stackviewCardSpacing
        stackView.alignment = .center
        stackView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        scrollView.addSubview(stackView)
        scrollView.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-4-[stackView]-4-|",
                options: NSLayoutConstraint.FormatOptions.alignAllCenterX,
                metrics: nil, views: ["stackView": stackView]
            )
        )
        scrollView.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[stackView]|",
                options: NSLayoutConstraint.FormatOptions.alignAllCenterX,
                metrics: nil,
                views: ["stackView": stackView]
            )
        )
    }
}
