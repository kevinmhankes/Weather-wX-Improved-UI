/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation

class ViewControllerUSALERTSDETAIL: UIwXViewController {

    var playButton = ObjectToolbarIcon()
    var cap = CAPAlert()
    var objAlertDetail = ObjectAlertDetail()
    let synth = AVSpeechSynthesizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        playButton = ObjectToolbarIcon(self, .play, #selector(playClicked))
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, playButton, shareButton]).items
        _ = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        stackView.spacing = 0
        objAlertDetail = ObjectAlertDetail(stackView)
        self.getContent()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.cap = CAPAlert(url: ActVars.usalertsDetailUrl)
            DispatchQueue.main.async {
                self.objAlertDetail.updateContent(self.cap)
            }
        }
    }

    @objc func playClicked() {
        UtilityActions.playClicked(cap.text + " " + cap.instructions, synth, playButton)
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.share(self, sender, cap.text.removeHtml())
    }
}
