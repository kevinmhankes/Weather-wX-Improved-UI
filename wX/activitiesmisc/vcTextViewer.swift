/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation

class vcTextViewer: UIwXViewController {

    var textView = ObjectTextView()
    var playButton = ObjectToolbarIcon()
    var playlistButton = ObjectToolbarIcon()
    var synth = AVSpeechSynthesizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        playButton = ObjectToolbarIcon(self, .play, #selector(playClicked))
        playlistButton = ObjectToolbarIcon(self, .playList, #selector(playlistClicked))
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, playButton, shareButton, playlistButton]).items
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        displayContent()
    }

    @objc override func doneClicked() {
        //UIApplication.shared.isIdleTimerDisabled = false
        UtilityActions.resetAudio(&synth, playButton)
        super.doneClicked()
    }

    @objc func playClicked() {
        UtilityActions.playClicked(textView.view, synth, playButton)
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.share(self, sender, ActVars.textViewText)
    }

    @objc func playlistClicked() {
        UtilityPlayList.add(ActVars.textViewProduct, ActVars.textViewText, self, playlistButton)
    }

    private func displayContent() {
        textView = ObjectTextView(stackView, ActVars.textViewText)
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
