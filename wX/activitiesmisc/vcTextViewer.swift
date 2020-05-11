/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcTextViewer: UIwXViewControllerWithAudio {
    
    var textViewText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, playButton, shareButton]).items
        objScrollStackView = ObjectScrollStackView(self)
        displayContent()
    }

    private func displayContent() {
        objectTextView = ObjectTextView(stackView, textViewText)
        objectTextView.constrain(scrollView)
    }
}
