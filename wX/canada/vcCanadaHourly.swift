/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcCanadaHourly: UIwXViewController {
    
    private var html = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        toolbar.items = ObjectToolbarItems(
            [
                doneButton,
                GlobalVariables.flexBarButton
            ]
        ).items
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        self.getContent()
    }
    
    @objc func willEnterForeground() {
        self.getContent()
    }
    
    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.html = UtilityCanadaHourly.getString(Location.getLocationIndex)
            DispatchQueue.main.async {
                self.displayContent()
            }
        }
    }
    
    private func displayContent() {
        refreshViews()
        let objectTextView = ObjectTextView(self.stackView, html, FontSize.hourly.size)
        objectTextView.tv.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
        _ = ObjectCALegal(self.stackView)
    }
}
