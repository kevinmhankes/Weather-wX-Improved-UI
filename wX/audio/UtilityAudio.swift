/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation

final class UtilityAudio {
    
    static func speakText(_ text: String, _ synth: AVSpeechSynthesizer) {
        var myUtterance = AVSpeechUtterance(string: "")
        if !synth.isSpeaking {
            myUtterance = AVSpeechUtterance(string: UtilityTtsTranslations.tranlasteAbbreviations(text))
            synth.speak(myUtterance)
        } else if synth.isPaused {
            synth.continueSpeaking()
        } else {
            synth.pauseSpeaking(at: AVSpeechBoundary.word)
        }
    }
    
    static func playClicked(_ textView: UITextView, _ synth: AVSpeechSynthesizer, _ playB: ObjectToolbarIcon) {
        let pauseIcon = "ic_pause_24dp"
        if synth.isPaused {
            print("continue speaking")
            synth.continueSpeaking()
            playB.setImage(ObjectToolbarIcon.getIcon(pauseIcon), for: .normal)
        } else if !synth.isSpeaking {
            print("speak")
            let myUtterance = AVSpeechUtterance(string: UtilityTtsTranslations.tranlasteAbbreviations(textView.text))
            synth.speak(myUtterance)
            playB.setImage(ObjectToolbarIcon.getIcon(pauseIcon), for: .normal)
        } else {
            print("pause speaking")
            synth.pauseSpeaking(at: AVSpeechBoundary.word)
            playB.setImage(ObjectToolbarIcon.getIcon("ic_play_arrow_24dp"), for: .normal)
        }
    }
    
    static func playClicked(_ str: String, _ synth: AVSpeechSynthesizer, _ playB: ObjectToolbarIcon) {
        var myUtterance = AVSpeechUtterance(string: "")
        let pauseIcon = "ic_pause_24dp"
        if synth.isPaused {
            print("continue speaking")
            synth.continueSpeaking()
            playB.setImage(ObjectToolbarIcon.getIcon(pauseIcon), for: .normal)
        } else if !synth.isSpeaking {
            print("play speaking")
            myUtterance = AVSpeechUtterance(string: UtilityTtsTranslations.tranlasteAbbreviations(str))
            synth.speak(myUtterance)
            playB.setImage(ObjectToolbarIcon.getIcon(pauseIcon), for: .normal)
        } else {
            print("pause speaking")
            synth.pauseSpeaking(at: AVSpeechBoundary.word)
            playB.setImage(ObjectToolbarIcon.getIcon("ic_play_arrow_24dp"), for: .normal)
        }
    }
    
    static func playClicked(_ str: String, _ synth: AVSpeechSynthesizer, _ fab: ObjectFab) {
        var myUtterance = AVSpeechUtterance(string: "")
        let pauseIcon = "ic_pause_24dp"
        if synth.isPaused {
            print("continue speaking")
            synth.continueSpeaking()
            fab.setImage(pauseIcon)
        } else if !synth.isSpeaking {
            print("play speaking")
            myUtterance = AVSpeechUtterance(string: UtilityTtsTranslations.tranlasteAbbreviations(str))
            synth.speak(myUtterance)
            fab.setImage(pauseIcon)
        } else {
            print("pause speaking")
            synth.pauseSpeaking(at: AVSpeechBoundary.word)
            fab.setImage("ic_play_arrow_24dp")
        }
    }
    
    static func playClickedNewItem(_ str: String, _ synth: AVSpeechSynthesizer, _ playB: ObjectToolbarIcon) {
        var myUtterance = AVSpeechUtterance(string: "")
        let pauseIcon = "ic_pause_24dp"
        myUtterance = AVSpeechUtterance(string: UtilityTtsTranslations.tranlasteAbbreviations(str))
        synth.speak(myUtterance)
        playB.setImage(ObjectToolbarIcon.getIcon(pauseIcon), for: .normal)
    }
    
    static func playClickedNewItem(_ str: String, _ synth: AVSpeechSynthesizer, _ fab: ObjectFab) {
        var myUtterance = AVSpeechUtterance(string: "")
        let pauseIcon = "ic_pause_24dp"
        myUtterance = AVSpeechUtterance(string: UtilityTtsTranslations.tranlasteAbbreviations(str))
        synth.speak(myUtterance)
        fab.setImage(pauseIcon)
    }
    
    static func stopAudio(_ synth: AVSpeechSynthesizer, _ playB: ObjectToolbarIcon) {
        let pauseIcon = "ic_pause_24dp"
        synth.stopSpeaking(at: AVSpeechBoundary.word)
        playB.setImage(ObjectToolbarIcon.getIcon(pauseIcon), for: .normal)
    }
    
    static func stopAudio(_ synth: AVSpeechSynthesizer, _ fab: ObjectFab) {
        let pauseIcon = "ic_pause_24dp"
        synth.stopSpeaking(at: AVSpeechBoundary.word)
        fab.setImage(pauseIcon)
    }
    
    static func resetAudio(_ synth: inout AVSpeechSynthesizer, _ playB: ObjectToolbarIcon) {
        if synth.isSpeaking {
            synth.pauseSpeaking(at: AVSpeechBoundary.word)
        }
        synth = AVSpeechSynthesizer()
        playB.setImage(ObjectToolbarIcon.getIcon("ic_play_arrow_24dp"), for: .normal)
    }
    
    static func resetAudio(_ synth: inout AVSpeechSynthesizer, _ fab: ObjectFab) {
        if synth.isSpeaking {
            synth.pauseSpeaking(at: AVSpeechBoundary.word)
        }
        synth = AVSpeechSynthesizer()
        fab.setImage("ic_play_arrow_24dp")
    }
}
