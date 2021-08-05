// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class vcCanadaHourly: UIwXViewControllerWithAudio {

    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = ToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ToolbarItems([doneButton, GlobalVariables.flexBarButton, shareButton]).items
        objScrollStackView = ScrollStackView(self)
        objectTextView = Text(stackView, "", FontSize.hourly.size)
        objectTextView.constrain(scrollView)
        _ = ObjectCanadaLegal(stackView.get())
        getContent()
    }

    override func getContent() {
        _ = FutureText2({ UtilityCanadaHourly.getString(Location.getLocationIndex) }, objectTextView.setText)
    }
}
