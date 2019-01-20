/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerHOURLY: UIwXViewController {

    var html = ("", "")

    // TODO convert to audip/share setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton]).items
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        self.getContent()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.html = UtilityUSHourlyV2.getHourlyString(Location.getCurrentLocation())
            DispatchQueue.main.async {
                self.displayContent()
            }
        }
    }

    @objc func textAction() {
        scrollView.scrollToTop()
    }

    private func displayContent() {
        let objText = ObjectTextView(
            self.stackView,
            self.html.0,
            UIFont(
                name: "Courier",
                size: UIPreferences.textviewFontSize - 2
            )!
        )
        objText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.textAction)))
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: nil,
            completion: { _ -> Void in
                self.refreshViews()
                self.displayContent()
        }
        )
    }
}
