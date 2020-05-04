/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcUSAlertsDetail: UIwXViewControllerWithAudio {
    
    private var cap = CapAlert()
    private var objectAlertDetail = ObjectAlertDetail()
    var usAlertsDetailUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        playButton = ObjectToolbarIcon(self, .play, #selector(playClicked))
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, playButton, shareButton]).items
        objScrollStackView = ObjectScrollStackView(self)
        self.getContent()
    }
    
    override func getContent() {
        refreshViews()
        stackView.spacing = 0
        objectAlertDetail = ObjectAlertDetail(stackView)
        DispatchQueue.global(qos: .userInitiated).async {
            self.cap = CapAlert(url: self.usAlertsDetailUrl)
            DispatchQueue.main.async { self.displayContent() }
        }
    }
    
    private func displayContent() {
        self.objectAlertDetail.updateContent(self.scrollView, self.cap)
    }
    
    override func playClicked() {
        UtilityAudio.playClicked(cap.text + " " + cap.instructions, synthesizer, playButton)
    }
    
    @objc override func shareClicked(sender: UIButton) {
        UtilityShare.share(self, sender, cap.text.removeHtml())
    }
}
