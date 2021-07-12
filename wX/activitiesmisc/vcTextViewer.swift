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
        let shareButton = ToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ToolbarItems([doneButton, GlobalVariables.flexBarButton, playButton, shareButton]).items
        objScrollStackView = ScrollStackView(self)
        display()
    }

    private func display() {
        objectTextView = Text(stackView, textViewText)
        objectTextView.constrain(scrollView)
    }
}
