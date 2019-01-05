/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation

final class UtilityActions {

    static func cloudClicked(_ uiv: UIViewController) {
        if Location.isUS {
            ActVars.goesProduct = ""
            ActVars.goesSector = ""
            goToVCS(uiv, "goes16")
        } else {
            ActVars.caRadarImageType = "vis"
            goToVCS(uiv, "caradar")
        }
    }

    static func radarClicked(_ uiv: UIViewController) {
        if !Location.isUS {
            ActVars.caRadarImageType = "radar"
            ActVars.caRadarProv = ""
            goToVCS(uiv, "caradar")
        } else {
            if UIPreferences.dualpaneRadarIcon {
                ActVars.wxoglPaneCount = "2"
            } else {
                ActVars.wxoglPaneCount = "1"
            }
            if UIPreferences.useMetalRadar {
                goToVCS(uiv, "wxmetalradar")
            } else {
                goToVCS(uiv, "wxoglmultipane")
            }
        }
    }

    static func wfotextClicked(_ uiv: UIViewController) {
        if Location.isUS {
            goToVCS(uiv, "wfotext")
        } else {
            goToVCS(uiv, "catext")
        }
    }

    static func dashClicked(_ uiv: UIViewController) {
        if Location.isUS {
            goToVCS(uiv, "severedashboard")
        } else {
            goToVCS(uiv, "cawarn")
        }
    }

    static func menuItemClicked(_ uiv: UIViewController, _ menuItem: String, _ button: ObjectToolbarIcon) {
        var token = ""
        if menuItem.hasPrefix("Help Mode") {
            if !MyApplication.helpMode {
                MyApplication.helpMode = true
                _ = ObjectToast("Help mode is now enabled. Select again to turn off. Tap any icon to see help text.",
                                uiv, button)
            } else {
                MyApplication.helpMode = false
                _ = ObjectToast("Help mode is now disabled. Select again to turn on.", uiv, button)
            }
            return
        }
        switch menuItem {
        case "Soundings":
            token = "sounding"
        case "Hourly":
            if Location.isUS {
                token = "hourly"
            } else {
                token = "cahourly"
            }
        case "Settings":
            token = "settingsmain"
        case "Observations":
            token = "observations"
        case "PlayList":
            token = "playlist"
        case "Radar Mosaic":
            if Location.isUS {
                ActVars.nwsMosaicType = "local"
                token = "nwsmosaic"
            } else {
                let prov = MyApplication.locations[Location.getLocationIndex].prov
                ActVars.caRadarProv = UtilityCanada.getECSectorFromProv(prov)
                ActVars.caRadarImageType = "radar"
                token = "caradar"
            }
        case "Alerts":
            if Location.isUS {
                token = "usalerts"
            } else {
                token = "cawarn"
            }
        case "Spotters":
            token = "spotters"
        case "Local Forecast":
            ActVars.webViewUseUrl = true
            ActVars.webViewUrl = "http://forecast.weather.gov/MapClick.php?lon="
                + Location.latlon.lonString + "&lat=" + Location.latlon.latString
            token = "webview"
        default:
            token = "hourly"
        }
        goToVCS(uiv, token)
    }

    static func goToVCS(_ uiv: UIViewController, _ target: String) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: target) as UIViewController
        uiv.present(nextViewController, animated: UIPreferences.backButtonAnimation, completion: nil)
    }

    static func goToVCDynamic(_ uiv: UIViewController, _ target: String, _ className: String) {
        let storyboard = UIStoryboard(name: target, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: className)
        uiv.navigationController?.show(vc, sender: nil)
    }

    static func showHelp(_ token: String, _ uiv: UIViewController, _ menuButton: ObjectToolbarIcon) {
        let alert = UIAlertController(
            title: UtilityHelp.helpStrings[token],
            message: "",
            preferredStyle: UIAlertController.Style.actionSheet
        )
        alert.addAction(UIAlertAction(title: "", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
        if let popoverController = alert.popoverPresentationController {
            popoverController.barButtonItem = menuButton
        }
        uiv.present(alert, animated: true, completion: nil)
    }

    static func menuClicked(_ uiv: UIViewController, _ button: ObjectToolbarIcon) {
        var menuList = [
            "Hourly",
            "Radar Mosaic",
            "Alerts",
            "Observations",
            "Soundings",
            "PlayList",
            "Settings",
            "Help Mode - Off"
        ]
        if MyApplication.helpMode {
            menuList.enumerated().forEach {
                if $1.contains("Help Mode") {
                    menuList[$0] = "Help Mode - On"
                }
            }
        }
        let alert = UIAlertController(
            title: "Select from:",
            message: "",
            preferredStyle: UIAlertController.Style.actionSheet
        )
        menuList.forEach { rid in
            let action = UIAlertAction(title: rid, style: .default, handler: {_ in menuItemClicked(uiv, rid, button)})
            if let popoverController = alert.popoverPresentationController {
                popoverController.barButtonItem = button
            }
            alert.addAction(action)
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        uiv.present(alert, animated: true, completion: nil)
    }

    static func doneClicked(_ uiv: UIViewController) {
        uiv.dismiss(animated: true, completion: {})
    }

    static func playClicked(_ textView: UITextView, _ synth: AVSpeechSynthesizer, _ playB: ObjectToolbarIcon) {
        var myUtterance = AVSpeechUtterance(string: "")
        let pauseIcon = "ic_pause_24dp"
        if !globalSynth.isSpeaking {
            myUtterance = AVSpeechUtterance(string: UtilityTTSTranslations.tranlasteAbbrev(textView.text))
            globalSynth.speak(myUtterance)
            playB.setImage(UIImage(named: pauseIcon)!, for: .normal)
        } else if globalSynth.isPaused {
            globalSynth.continueSpeaking()
            playB.setImage(UIImage(named: pauseIcon)!, for: .normal)
        } else {
            globalSynth.pauseSpeaking(at: AVSpeechBoundary.word)
            playB.setImage(UIImage(named: "ic_play_arrow_24dp")!, for: .normal)
        }
    }

    static func playClicked(_ str: String, _ synth: AVSpeechSynthesizer, _ playB: ObjectToolbarIcon) {
        var myUtterance = AVSpeechUtterance(string: "")
        let pauseIcon = "ic_pause_24dp"
        if !globalSynth.isSpeaking {
            myUtterance = AVSpeechUtterance(string: UtilityTTSTranslations.tranlasteAbbrev(str))
            globalSynth.speak(myUtterance)
            playB.setImage(UIImage(named: pauseIcon)!, for: .normal)
        } else if globalSynth.isPaused {
            globalSynth.continueSpeaking()
            playB.setImage(UIImage(named: pauseIcon)!, for: .normal)
        } else {
            globalSynth.pauseSpeaking(at: AVSpeechBoundary.word)
            playB.setImage(UIImage(named: "ic_play_arrow_24dp")!, for: .normal)
        }
    }

    static func playClickedNewItem(_ str: String, _ synth: AVSpeechSynthesizer, _ playB: ObjectToolbarIcon) {
        var myUtterance = AVSpeechUtterance(string: "")
        let pauseIcon = "ic_pause_24dp"
        myUtterance = AVSpeechUtterance(string: UtilityTTSTranslations.tranlasteAbbrev(str))
        globalSynth.speak(myUtterance)
        playB.setImage(UIImage(named: pauseIcon)!, for: .normal)
    }

    static func stopAudio(_ synth: AVSpeechSynthesizer, _ playB: ObjectToolbarIcon) {
        let pauseIcon = "ic_pause_24dp"
        globalSynth.stopSpeaking(at: AVSpeechBoundary.word)
        playB.setImage(UIImage(named: pauseIcon)!, for: .normal)
    }

    static func ttsPrep() {
        globalSynth.stopSpeaking(at: AVSpeechBoundary.word)
    }
}
