/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcCanadaHourly: UIwXViewController {
    
    var objectTextView = ObjectTextView()
    private var html = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, shareButton]).items
        objScrollStackView = ObjectScrollStackView(self)
        objectTextView = ObjectTextView(self.stackView, "", FontSize.hourly.size)
        objectTextView.constrain(scrollView)
        _ = ObjectCanadaLegal(self.stackView)
        self.getContent()
    }
    
    override func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.html = UtilityCanadaHourly.getString(Location.getLocationIndex)
            DispatchQueue.main.async {
                self.objectTextView.text = self.html
            }
        }
    }
    
    @objc func shareClicked(sender: UIButton) {
        UtilityShare.share(self, sender, html)
    }
}
