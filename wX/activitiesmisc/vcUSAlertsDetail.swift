// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class vcUSAlertsDetail: UIwXViewControllerWithAudio {

    private var cap = CapAlert()
    private var objectAlertDetail: ObjectAlertDetail!
    var usAlertsDetailUrl = ""
    var statusButton: ToolbarIcon!

    override func viewDidLoad() {
        super.viewDidLoad()
        statusButton = ToolbarIcon(title: "", self, nil)
        let shareButton = ToolbarIcon(self, .share, #selector(shareClicked))
        let radarButton = ToolbarIcon(self, .radar, #selector(radarClicked))
        playButton = ToolbarIcon(self, .play, #selector(playClicked))
        toolbar.items = ToolbarItems([doneButton, statusButton, GlobalVariables.flexBarButton, playButton, shareButton, radarButton]).items
        objScrollStackView = ScrollStackView(self)
        getContent()
    }

    override func getContent() {
        refreshViews()
        stackView.spacing = 0
        objectAlertDetail = ObjectAlertDetail(stackView)
        _ = FutureVoid({ self.cap = CapAlert(url: self.usAlertsDetailUrl) }, display)
    }

    private func display() {
        objectAlertDetail.updateContent(scrollView, cap)
        var hailUnit = ""
        if cap.maxHailSize != "" {
            hailUnit = " in"
        }
        statusButton.title = cap.windThreat.replace("RADAR INDICATED", "") + " " + cap.maxWindGust + " " + cap.hailThreat.replace("RADAR INDICATED", "") + " " + cap.maxHailSize + hailUnit
    }

    override func playClicked() {
        UtilityAudio.playClicked(cap.text, synthesizer, playButton)
    }

    override func shareClicked(sender: UIButton) {
        UtilityShare.share(self, sender, cap.text.removeHtml())
    }

    @objc func radarClicked() {
        Route.radarNoSave(self, cap.getClosestRadar())
    }
}
