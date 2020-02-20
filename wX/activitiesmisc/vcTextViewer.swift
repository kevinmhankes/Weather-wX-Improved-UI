/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation

class vcTextViewer: UIwXViewController {

    private var objectTextView = ObjectTextView()
    private var playButton = ObjectToolbarIcon()
    private var playlistButton = ObjectToolbarIcon()
    private var synth = AVSpeechSynthesizer()
    var textViewProduct = ""
    var textViewText = ""

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
        UtilityActions.resetAudio(&synth, playButton)
        super.doneClicked()
    }

    @objc func playClicked() {
        UtilityActions.playClicked(objectTextView.view, synth, playButton)
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.share(self, sender, textViewText)
    }

    @objc func playlistClicked() {
        UtilityPlayList.add(textViewProduct, textViewText, self, playlistButton)
    }

    private func displayContent() {
        objectTextView = ObjectTextView(stackView, textViewText)
        objectTextView.tv.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
    }

    /*override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: nil,
            completion: { _ -> Void in
                self.refreshViews()
                self.displayContent()
            }
        )
    }*/
}
