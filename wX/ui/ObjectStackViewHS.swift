/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectStackViewHS {
    
    let view = UIStackView()

    func setup() {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        view.axis = .vertical
        view.alignment = .center
        view.spacing = 0.0
    }
    
    func setup(_ stackView: UIStackView) {
        view.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        view.axis = .vertical
        view.alignment = .center
        view.spacing = 0.0
    }

    func setupWithPadding() {
        setup()
        view.spacing = UIPreferences.stackviewCardSpacing
    }
    
    func setupWithPadding(_ stackView: UIStackView) {
        setup(stackView)
        view.spacing = UIPreferences.stackviewCardSpacing
    }
    
    func addWidget(_ w: UIView) {
        view.addArrangedSubview(w)
    }
    
    func addLayout(_ w: UIView) {
        view.addArrangedSubview(w)
    }
    
    
    func addGesture(_ gesture: UIGestureRecognizer) {
        view.addGestureRecognizer(gesture)
    }
    
    func addGesture(_ gesture: GestureData) {
        view.addGestureRecognizer(gesture)
    }
    
    func removeFromSuperview() {
        view.removeFromSuperview()
    }
    
    func get() -> UIStackView {
        return view
    }
}
