/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerHOURLY: UIwXViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton]).items
        _ = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        self.getContent()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            let html = UtilityUSHourlyV2.getHourlyString(Location.getCurrentLocation())
            DispatchQueue.main.async {
                let objText = ObjectTextView(self.stackView, html.0,
                                             UIFont(name: "Courier", size: UIPreferences.textviewFontSize - 2)!)
                objText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.textAction)))
            }
        }
    }

    @objc func textAction() {
        scrollView.scrollToTop()
    }
}
