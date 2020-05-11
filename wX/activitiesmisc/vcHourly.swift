/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcHourly: UIwXViewControllerWithAudio {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, shareButton]).items
        objScrollStackView = ObjectScrollStackView(self)
        objectTextView = ObjectTextView(
            self.stackView,
            "",
            FontSize.hourly.size,
            UITapGestureRecognizer(target: self, action: #selector(textAction))
        )
        objectTextView.constrain(scrollView)
        self.getContent()
    }
    
    override func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            let html = UtilityHourly.getHourlyString(Location.getCurrentLocation())[0]
            DispatchQueue.main.async { self.displayContent(html) }
        }
    }
    
    private func displayContent(_ html: String) {
        self.objectTextView.text = html
    }
    
    @objc func textAction() {
        scrollView.scrollToTop()
    }
    
    @objc override func shareClicked(sender: UIButton) {
        UtilityShare.share(self, sender, objectTextView.text)
    }
}
