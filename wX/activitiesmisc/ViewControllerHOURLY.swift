/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation

class ViewControllerHOURLY: UIwXViewController {

    var html = ""
    var playButton = ObjectToolbarIcon()
    let synth = AVSpeechSynthesizer()

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
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, playButton, shareButton]).items
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        self.getContent()
    }

    @objc func willEnterForeground() {
        self.getContent()
    }

    func getContent() {
        refreshViews()
        DispatchQueue.global(qos: .userInitiated).async {
            self.html = UtilityHourly.getHourlyString(Location.getCurrentLocation())[0]
            DispatchQueue.main.async {
                self.displayContent()
            }
        }
    }

    @objc func textAction() {
        scrollView.scrollToTop()
    }

    @objc func playClicked() {
        UtilityActions.playClicked(self.html, synth, playButton)
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.share(self, sender, self.html)
    }

    private func displayContent() {
        let objTextView = ObjectTextView(
            self.stackView,
            self.html,
            FontSize.hourly.size,
            UITapGestureRecognizer(target: self, action: #selector(textAction))
        )
        scrollView.accessibilityElements = [objTextView.view]
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: nil,
            completion: { _ -> Void in
                self.refreshViews()
                self.displayContent()
            }
        )
    }
}
