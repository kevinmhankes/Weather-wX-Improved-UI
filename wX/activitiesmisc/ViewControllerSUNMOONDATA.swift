/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation

class ViewControllerSUNMOONDATA: UIwXViewController {

    var textView = ObjectTextView()
    var playButton = ObjectToolbarIcon()
    let synth = AVSpeechSynthesizer()

    // TODO add share button

    override func viewDidLoad() {
        super.viewDidLoad()
        playButton = ObjectToolbarIcon(self, .play, #selector(playClicked))
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, playButton]).items
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        displayContent()
    }

    @objc func playClicked() {
        UtilityActions.playClicked(textView.view, synth, playButton)
    }

    private func displayContent() {
        textView = ObjectTextView(stackView, "", UIFont(name: "Courier", size: UIPreferences.textviewFontSize)!)
        self.textView.text = UtilitySunMoon.computeData()
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
