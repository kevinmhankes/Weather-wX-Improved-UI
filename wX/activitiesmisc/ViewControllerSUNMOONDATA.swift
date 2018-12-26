/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation

class ViewControllerSUNMOONDATA: UIwXViewController {

    var textView = ObjectTextView()
    var playButton = ObjectToolbarIcon()
    let synth = AVSpeechSynthesizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        playButton = ObjectToolbarIcon(self, .play, #selector(playClicked))
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, playButton]).items
        _ = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        textView = ObjectTextView(stackView, "", UIFont(name: "Courier", size: UIPreferences.textviewFontSize)!)
        getContent()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            let text = UtilitySunMoon.getExtendedData()
            let text2 = UtilitySunMoon.getFullDates()
            DispatchQueue.main.async {
                self.textView.text = UtilitySunMoon.parseData(text).1
                    + MyApplication.newline
                    + MyApplication.newline
                    + text2
            }
        }
    }

    @objc func playClicked() {
        UtilityActions.playClicked(textView.view, synth, playButton)
    }
}
