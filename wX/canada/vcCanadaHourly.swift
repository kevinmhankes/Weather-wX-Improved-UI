/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class vcCanadaHourly: UIwXViewControllerWithAudio {
        
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
            let html = UtilityCanadaHourly.getString(Location.getLocationIndex)
            DispatchQueue.main.async { self.display(html) }
        }
    }
    
    private func display(_ html: String) {
        self.objectTextView.text = html
    }
}
