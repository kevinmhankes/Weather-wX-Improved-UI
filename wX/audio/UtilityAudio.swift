// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit
import AVFoundation

final class UtilityAudio {

    static func playClicked(_ string: String, _ synthesizer: AVSpeechSynthesizer, _ playButton: ToolbarIcon) {
        if synthesizer.isPaused {
            synthesizer.continueSpeaking()
            playButton.setImage(.pause)
        } else if !synthesizer.isSpeaking {
            let myUtterance = AVSpeechUtterance(string: UtilityTtsTranslations.translateAbbreviations(string))
            synthesizer.speak(myUtterance)
            playButton.setImage(.pause)
        } else {
            synthesizer.pauseSpeaking(at: AVSpeechBoundary.word)
            playButton.setImage(.play)
        }
    }

    static func playClicked(_ string: String, _ synthesizer: AVSpeechSynthesizer, _ fab: ObjectFab) {
        if synthesizer.isPaused {
            synthesizer.continueSpeaking()
            fab.setImage(.pause)
        } else if !synthesizer.isSpeaking {
            let myUtterance = AVSpeechUtterance(string: UtilityTtsTranslations.translateAbbreviations(string))
            synthesizer.speak(myUtterance)
            fab.setImage(.pause)
        } else {
            synthesizer.pauseSpeaking(at: AVSpeechBoundary.word)
            fab.setImage(.play)
        }
    }

    static func playClickedNewItem(_ string: String, _ synthesizer: AVSpeechSynthesizer, _ fab: ObjectFab) {
        let myUtterance = AVSpeechUtterance(string: UtilityTtsTranslations.translateAbbreviations(string))
        synthesizer.speak(myUtterance)
        fab.setImage(.pause)
    }

    static func resetAudio(_ uiv: UIwXViewControllerWithAudio, _ playButton: ToolbarIcon) {
        if uiv.synthesizer.isSpeaking {
            uiv.synthesizer.pauseSpeaking(at: AVSpeechBoundary.word)
        }
        uiv.synthesizer = AVSpeechSynthesizer()
        playButton.setImage(.play)
    }
}
