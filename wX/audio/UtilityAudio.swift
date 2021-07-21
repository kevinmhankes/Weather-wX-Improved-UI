/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation

final class UtilityAudio {

//    static func speakText(_ string: String, _ synthesizer: AVSpeechSynthesizer) {
//        if !synthesizer.isSpeaking {
//            let myUtterance = AVSpeechUtterance(string: UtilityTtsTranslations.translateAbbreviations(string))
//            synthesizer.speak(myUtterance)
//        } else if synthesizer.isPaused {
//            synthesizer.continueSpeaking()
//        } else {
//            synthesizer.pauseSpeaking(at: AVSpeechBoundary.word)
//        }
//    }

    static func playClicked(_ string: String, _ synthesizer: AVSpeechSynthesizer, _ playB: ToolbarIcon) {
        if synthesizer.isPaused {
            synthesizer.continueSpeaking()
            playB.setImage(.pause)
        } else if !synthesizer.isSpeaking {
            let myUtterance = AVSpeechUtterance(string: UtilityTtsTranslations.translateAbbreviations(string))
            synthesizer.speak(myUtterance)
            playB.setImage(.pause)
        } else {
            synthesizer.pauseSpeaking(at: AVSpeechBoundary.word)
            playB.setImage(.play)
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

    static func resetAudio(_ uiv: UIwXViewControllerWithAudio, _ playB: ToolbarIcon) {
        if uiv.synthesizer.isSpeaking {
            uiv.synthesizer.pauseSpeaking(at: AVSpeechBoundary.word)
        }
        uiv.synthesizer = AVSpeechSynthesizer()
        playB.setImage(.play)
    }

//    static func resetAudio(_ uiv: UIwXViewControllerWithAudio, _ fab: ObjectFab) {
//        if uiv.synthesizer.isSpeaking {
//            uiv.synthesizer.pauseSpeaking(at: AVSpeechBoundary.word)
//        }
//        uiv.synthesizer = AVSpeechSynthesizer()
//        fab.setImage(.play)
//    }
}
