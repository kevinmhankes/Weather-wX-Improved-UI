/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class UIwXViewController: UIViewController {
    
    //
    // parent class for most viewcontrollers, sets up
    // basic UI elements - toolbar, stackview, scrollview
    // refresh when comining into focus
    // swipe from left edge
    //

    var scrollView = UIScrollView()
    var stackView = UIStackView()
    let toolbar = ObjectToolbar()
    var doneButton = ObjectToolbarIcon()
    //var shareButton = ObjectToolbarIcon()
    var objScrollStackView: ObjectScrollStackView?

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .left
        view.addGestureRecognizer(edgePan)
        view.backgroundColor = AppColors.primaryBackgroundBlueUIColor
        self.view.addSubview(toolbar)
        toolbar.setConfigWithUiv(uiv: self)
        doneButton = ObjectToolbarIcon(self, .done, #selector(doneClicked))
        //shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
    }
    
    //
    // each class that has this as a parent should override getContent()
    // in some cases willEnterForeground needs to be overriden
    //
    @objc func willEnterForeground() {
        self.getContent()
    }
    
    func getContent() {}
    
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
        self.objScrollStackView = ObjectScrollStackView(self)
    }

    func removeAllViews() {
        self.view.subviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
    //@objc func shareClicked(sender: UIButton) {
        //UtilityShare.share(self, sender, self.html)
    //}

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
