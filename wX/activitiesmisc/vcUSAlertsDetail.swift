/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation

class vcUSAlertsDetail: UIwXViewController {

    private var playButton = ObjectToolbarIcon()
    private var cap = CapAlert()
    private var objAlertDetail = ObjectAlertDetail()
    private var synth = AVSpeechSynthesizer()
    var usalertsDetailUrl = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        playButton = ObjectToolbarIcon(self, .play, #selector(playClicked))
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, playButton, shareButton]).items
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        self.getContent()
    }

    @objc func willEnterForeground() {
        self.getContent()
    }

    func getContent() {
        refreshViews()
        stackView.spacing = 0
        objAlertDetail = ObjectAlertDetail(stackView)
        DispatchQueue.global(qos: .userInitiated).async {
            self.cap = CapAlert(url: self.usalertsDetailUrl)
            DispatchQueue.main.async {
                self.displayContent()
            }
        }
    }

    @objc override func doneClicked() {
        UtilityActions.resetAudio(&synth, playButton)
        super.doneClicked()
    }

    @objc func playClicked() {
        UtilityActions.playClicked(cap.text + " " + cap.instructions, synth, playButton)
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.share(self, sender, cap.text.removeHtml())
    }

    private func displayContent() {
        self.objAlertDetail.updateContent(self.scrollView, self.cap)
    }

    /*override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: nil,
            completion: { _ -> Void in
                self.refreshViews()
                self.stackView.spacing = 0
                self.objAlertDetail = ObjectAlertDetail(self.stackView)
                self.displayContent()
            }
        )
    }*/
}
