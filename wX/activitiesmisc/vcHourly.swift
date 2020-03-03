/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcHourly: UIwXViewControllerWithAudio {
    
    private var html = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems(
            [
                doneButton,
                GlobalVariables.flexBarButton,
                shareButton
            ]
        ).items
        objScrollStackView = ObjectScrollStackView(self)
        objectTextView = ObjectTextView(
            self.stackView,
            self.html,
            FontSize.hourly.size,
            UITapGestureRecognizer(target: self, action: #selector(textAction))
        )
        objectTextView.constrain(scrollView)
        self.getContent()
    }
    
    @objc func willEnterForeground() {
        self.getContent()
    }
    
    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.html = UtilityHourly.getHourlyString(Location.getCurrentLocation())[0]
            DispatchQueue.main.async {
                self.objectTextView.text = self.html
            }
        }
    }
    
    @objc func textAction() {
        scrollView.scrollToTop()
    }
    
    @objc override func shareClicked(sender: UIButton) {
        UtilityShare.share(self, sender, self.html)
    }
}
