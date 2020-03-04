/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcCanadaHourly: UIwXViewController {
    
    private var html = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems(
            [
                doneButton,
                GlobalVariables.flexBarButton,
                shareButton
            ]
        ).items
        objScrollStackView = ObjectScrollStackView(self)
        self.getContent()
    }

    override func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.html = UtilityCanadaHourly.getString(Location.getLocationIndex)
            DispatchQueue.main.async {
                self.displayContent()
            }
        }
    }
    
    private func displayContent() {
        refreshViews()
        let objectTextView = ObjectTextView(self.stackView, html, FontSize.hourly.size)
        objectTextView.constrain(scrollView)
        _ = ObjectCALegal(self.stackView)
    }
    
    @objc func shareClicked(sender: UIButton) {
        UtilityShare.share(self, sender, html)
    }
}
