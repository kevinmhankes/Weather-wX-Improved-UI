/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class vcTextViewer: UIwXViewControllerWithAudio {
    
    var textViewText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, playButton, shareButton]).items
        objScrollStackView = ObjectScrollStackView(self)
        display()
    }

    private func display() {
        objectTextView = ObjectTextView(stackView, textViewText)
        objectTextView.constrain(scrollView)
    }
}
