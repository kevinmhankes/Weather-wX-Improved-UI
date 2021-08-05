// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class vcHourly: UIwXViewControllerWithAudio {

    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = ToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ToolbarItems([doneButton, GlobalVariables.flexBarButton, shareButton]).items
        objScrollStackView = ScrollStackView(self)
        objectTextView = Text(
            stackView,
            "",
            FontSize.hourly.size,
            UITapGestureRecognizer(target: self, action: #selector(scroll))
        )
        objectTextView.constrain(scrollView)
        getContent()
    }

    override func getContent() {
        _ = FutureText("HOURLY", objectTextView.setText)
    }

    @objc func scroll() {
        scrollView.scrollToTop()
    }

    override func shareClicked(sender: UIButton) {
        UtilityShare.share(self, sender, objectTextView.text)
    }
}
