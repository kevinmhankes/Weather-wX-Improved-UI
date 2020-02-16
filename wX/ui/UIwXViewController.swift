/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class UIwXViewController: UIViewController {

    var scrollView = UIScrollView()
    var stackView = UIStackView()
    let toolbar = ObjectToolbar()
    var doneButton = ObjectToolbarIcon()
    var objScrollStackView: ObjectScrollStackView?

    override func viewDidLoad() {
        super.viewDidLoad()
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .left
        view.addGestureRecognizer(edgePan)
        view.backgroundColor = AppColors.primaryBackgroundBlueUIColor
        self.view.addSubview(toolbar)
        toolbar.setConfigWithUiv(uiv: self)
        doneButton = ObjectToolbarIcon(self, .done, #selector(doneClicked))
    }
    
    @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized {
            doneClicked()
        }
    }

    @objc func doneClicked() {
        self.dismiss(animated: UIPreferences.backButtonAnimation, completion: {})
    }

    func refreshViews() {
        self.removeAllViews()
        self.scrollView = UIScrollView()
        self.stackView = UIStackView()
        self.view.addSubview(toolbar)
        toolbar.setConfigWithUiv(uiv: self)
        self.objScrollStackView = ObjectScrollStackView(self, self.scrollView, self.stackView, self.toolbar)
    }

    func removeAllViews() {
        self.view.subviews.forEach({ $0.removeFromSuperview() })
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle &&  UIApplication.shared.applicationState == .inactive {
                if UITraitCollection.current.userInterfaceStyle == .dark {
                    AppColors.update()
                    print("Dark mode")
                } else {
                    AppColors.update()
                    print("Light mode")
                }
                view.backgroundColor = AppColors.primaryBackgroundBlueUIColor
                toolbar.setColorToTheme()
            }
        } else {
            // Fallback on earlier versions
        }
    }

    override var keyCommands: [UIKeyCommand]? {
        return [UIKeyCommand(input: UIKeyCommand.inputEscape,
             modifierFlags: [],
             action: #selector(doneClicked))
        ]
    }
}
