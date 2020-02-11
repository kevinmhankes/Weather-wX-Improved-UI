/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation

final class UtilityActions {

    static func cloudClicked(_ uiv: UIViewController) {
        if Location.isUS {
            let vc = vcGoes()
            vc.productCode = ""
            vc.sectorCode = ""
            goToVCS(uiv, vc)
        } else {
            ActVars.caRadarImageType = "vis"
            let vc = vcCanadaRadar()
            goToVCS(uiv, vc)
        }
    }

    @objc static func radarClickedFromMenu() {
        print("radar shortcut")
        if !Location.isUS {
            ActVars.caRadarImageType = "radar"
            ActVars.caRadarProv = ""
        } else {
            if UIPreferences.dualpaneRadarIcon {
                ActVars.wxoglPaneCount = "2"
            } else {
                ActVars.wxoglPaneCount = "1"
            }
        }
    }

    static func radarClicked(_ uiv: UIViewController) {
        if !Location.isUS {
            ActVars.caRadarImageType = "radar"
            ActVars.caRadarProv = ""
            let vc = vcCanadaRadar()
            goToVCS(uiv, vc)
        } else {
            if UIPreferences.dualpaneRadarIcon {
                ActVars.wxoglPaneCount = "2"
            } else {
                ActVars.wxoglPaneCount = "1"
            }
            let vc = vcNexradRadar()
            goToVCS(uiv, vc)
        }
    }

    static func wfotextClicked(_ uiv: UIViewController) {
        if Location.isUS {
            let vc = vcWfoText()
            goToVCS(uiv, vc)
        } else {
            let vc = vcCanadaText()
            goToVCS(uiv, vc)
        }
    }

    static func dashClicked(_ uiv: UIViewController) {
        if Location.isUS {
            let vc = vcSevereDashboard()
            goToVCS(uiv, vc)
        } else {
            let vc = vcCanadaWarnings()
            goToVCS(uiv, vc)
        }
    }

    static func multiPaneRadarClicked(_ uiv: UIViewController, _ paneCount: String) {
           //var token = ""
           switch paneCount {
           case "2":
               ActVars.wxoglPaneCount = "2"
               //token = "wxmetalradar"
           case "4":
               ActVars.wxoglPaneCount = "4"
               //token = "wxmetalradar"
           default: break
           }
            let vc = vcNexradRadar()
           UtilityActions.goToVCS(uiv, vc)
       }

    static func menuItemClicked(_ uiv: UIViewController, _ menuItem: String, _ button: ObjectToolbarIcon) {
        //var token = ""
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
            let vc = vcSoundings()
            uiv.goToVC(vc)
        case "Hourly":
            if Location.isUS {
                let vc = vcHourly()
                uiv.goToVC(vc)
            } else {
                let vc = vcCanadaHourly()
                uiv.goToVC(vc)
            }
        case "Settings":
            let vc = vcSettingsMain()
            uiv.goToVC(vc)
        case "Observations":
            let vc = vcObservations()
            uiv.goToVC(vc)
        case "PlayList":
            let vc = vcPlayList()
            uiv.goToVC(vc)
        case "Radar Mosaic":
            if Location.isUS {
                if !UIPreferences.useAwcRadarMosaic {
                    ActVars.nwsMosaicType = "local"
                    let vc = vcRadarMosaic()
                    uiv.goToVC(vc)
                } else {
                    ActVars.nwsMosaicType = "local"
                    let vc = vcRadarMosaicAwc()
                    uiv.goToVC(vc)
                }
            } else {
                let prov = MyApplication.locations[Location.getLocationIndex].prov
                ActVars.caRadarProv = UtilityCanada.getECSectorFromProvidence(prov)
                ActVars.caRadarImageType = "radar"
                let vc = vcCanadaRadar()
                uiv.goToVC(vc)
            }
        case "Alerts":
            if Location.isUS {
                let vc = vcUSAlerts()
                uiv.goToVC(vc)
            } else {
                let vc = vcCanadaWarnings()
                uiv.goToVC(vc)
            }
        case "Spotters":
            let vc = vcSpotters()
            uiv.goToVC(vc)
        default:
            let vc = vcHourly()
            uiv.goToVC(vc)
        }
    }

    static func goToVCS(_ uiv: UIViewController, _ target: UIViewController) {
        target.modalPresentationStyle = .fullScreen
        uiv.present(target, animated: UIPreferences.backButtonAnimation, completion: nil)
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
            "Settings"
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
        alert.view.tintColor = ColorCompatibility.label
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

    static func playClickedNewItem(_ str: String, _ synth: AVSpeechSynthesizer, _ playB: ObjectToolbarIcon) {
        var myUtterance = AVSpeechUtterance(string: "")
        let pauseIcon = "ic_pause_24dp"
        myUtterance = AVSpeechUtterance(string: UtilityTtsTranslations.tranlasteAbbreviations(str))
        synth.speak(myUtterance)
        playB.setImage(ObjectToolbarIcon.getIcon(pauseIcon), for: .normal)
    }

    static func stopAudio(_ synth: AVSpeechSynthesizer, _ playB: ObjectToolbarIcon) {
        let pauseIcon = "ic_pause_24dp"
        synth.stopSpeaking(at: AVSpeechBoundary.word)
        playB.setImage(ObjectToolbarIcon.getIcon(pauseIcon), for: .normal)
    }

    static func resetAudio(_ synth: inout AVSpeechSynthesizer, _ playB: ObjectToolbarIcon) {
        if synth.isSpeaking {
            synth.pauseSpeaking(at: AVSpeechBoundary.word)
        }
        synth = AVSpeechSynthesizer()
        playB.setImage(ObjectToolbarIcon.getIcon("ic_play_arrow_24dp"), for: .normal)
    }
}
