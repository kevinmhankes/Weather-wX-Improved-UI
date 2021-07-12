/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class vcHourly: UIwXViewControllerWithAudio {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, shareButton]).items
        objScrollStackView = ObjectScrollStackView(self)
        objectTextView = ObjectTextView(
            stackView,
            "",
            FontSize.hourly.size,
            UITapGestureRecognizer(target: self, action: #selector(scroll))
        )
        objectTextView.constrain(scrollView)
        getContent()
    }
    
    override func getContent() {
        _ = FutureText("HOURLY", self.display)
//        DispatchQueue.global(qos: .userInitiated).async {
//            let html = UtilityHourly.get(Location.getCurrentLocation())[0]
//            DispatchQueue.main.async { self.display(html) }
//        }
    }
    
    private func display(_ html: String) {
        objectTextView.text = html
    }
    
    @objc func scroll() {
        scrollView.scrollToTop()
    }
    
    override func shareClicked(sender: UIButton) {
        UtilityShare.share(self, sender, objectTextView.text)
    }
}
