/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerCAHOURLY: UIwXViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton]).items
        _ = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        self.getContent()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            let html = UtilityCanadaHourly.getHourlyString(Location.getLocationIndex)
            DispatchQueue.main.async {
                _ = ObjectTextView(self.stackView, html)
                _ = ObjectCALegal(self.stackView)
            }
        }
    }
}
