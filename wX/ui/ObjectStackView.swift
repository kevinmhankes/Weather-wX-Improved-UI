/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectStackView {

    let uiStackView = UIStackView()

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
            arrangedSubviews.forEach { uiStackView.addArrangedSubview($0) }
        }
    }
    
    func addLayout(_ w: UIView) {
        view.addArrangedSubview(w)
    }
    
    func addLayout(_ layout: ObjectStackView) {
        view.addArrangedSubview(layout.get())
    }
    
    func get() -> UIStackView {
        uiStackView
    }
    
    func removeChildren() {
        view.subviews.forEach { $0.removeFromSuperview() }
    }
    
    func removeAllChildren() {
        get().removeViews()
        get().removeFromSuperview()
    }

    var view: UIStackView { uiStackView }
}
