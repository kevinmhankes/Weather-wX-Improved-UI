/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation

final class UtilityAudio {
    
    static func speakText(_ text: String, _ synth: AVSpeechSynthesizer) {
        if !synth.isSpeaking {
            let myUtterance = AVSpeechUtterance(string: UtilityTtsTranslations.tranlasteAbbreviations(text))
            synth.speak(myUtterance)
        } else if synth.isPaused {
            synth.continueSpeaking()
        } else {
            synth.pauseSpeaking(at: AVSpeechBoundary.word)
        }
    }
    
    static func playClicked(_ str: String, _ synth: AVSpeechSynthesizer, _ playB: ObjectToolbarIcon) {
        if synth.isPaused {
            synth.continueSpeaking()
            playB.setImage(.pause)
        } else if !synth.isSpeaking {
             let myUtterance = AVSpeechUtterance(string: UtilityTtsTranslations.tranlasteAbbreviations(str))
            synth.speak(myUtterance)
            playB.setImage(.pause)
        } else {
            synth.pauseSpeaking(at: AVSpeechBoundary.word)
            playB.setImage(.play)
        }
    }
    
    static func playClicked(_ str: String, _ synth: AVSpeechSynthesizer, _ fab: ObjectFab) {
        if synth.isPaused {
            synth.continueSpeaking()
            fab.setImage(.pause)
        } else if !synth.isSpeaking {
            let myUtterance = AVSpeechUtterance(string: UtilityTtsTranslations.tranlasteAbbreviations(str))
            synth.speak(myUtterance)
            fab.setImage(.pause)
        } else {
            synth.pauseSpeaking(at: AVSpeechBoundary.word)
            fab.setImage(.play)
        }
    }
    
    static func playClickedNewItem(_ str: String, _ synth: AVSpeechSynthesizer, _ fab: ObjectFab) {
        let myUtterance = AVSpeechUtterance(string: UtilityTtsTranslations.tranlasteAbbreviations(str))
        synth.speak(myUtterance)
        fab.setImage(.pause)
    }
    
    static func resetAudio(_ synth: inout AVSpeechSynthesizer, _ playB: ObjectToolbarIcon) {
        if synth.isSpeaking { synth.pauseSpeaking(at: AVSpeechBoundary.word) }
        synth = AVSpeechSynthesizer()
        playB.setImage(.play)
    }
    
    static func resetAudio(_ synth: inout AVSpeechSynthesizer, _ fab: ObjectFab) {
        if synth.isSpeaking { synth.pauseSpeaking(at: AVSpeechBoundary.word) }
        synth = AVSpeechSynthesizer()
        fab.setImage(.play)
    }
}
