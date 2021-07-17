/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation

class UIwXViewControllerWithAudio: UIwXViewController, AVSpeechSynthesizerDelegate {

    // A superclass for all activities that will support TTS such as WFO Text, National Text, TextViewer
    // and various text/graphical mix such as SPC SWO/Fire and WPC Excessive Rain
    //
    // The primary support are 2 toolbar icons: play, add to playlist
    // And the Text and product variable
    // doneClicked resets the audio

    var playButton = ToolbarIcon()
    var playListButton = ToolbarIcon()
    var synthesizer = AVSpeechSynthesizer()
    var objectTextView = Text()
    var product = "PMDSPD"

    override func viewDidLoad() {
        super.viewDidLoad()
        synthesizer.delegate = self
        playButton = ToolbarIcon(self, .play, #selector(playClicked))
        playListButton = ToolbarIcon(self, .playList, #selector(playlistClicked))
    }

    override func doneClicked() {
        UtilityAudio.resetAudio(self, playButton)
        super.doneClicked()
    }

    @objc func playClicked() {
        UtilityAudio.playClicked(objectTextView.view.text, synthesizer, playButton)
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.share(self, sender, objectTextView.text)
    }

    @objc func playlistClicked() {
        _ = UtilityPlayList.add(product, objectTextView.text, self, playListButton)
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        // DispatchQueue.main.async { UtilityAudio.resetAudio(self, self.playButton) }
        _ = FutureVoid({ UtilityAudio.resetAudio(self, self.playButton) }, {})
    }
}
