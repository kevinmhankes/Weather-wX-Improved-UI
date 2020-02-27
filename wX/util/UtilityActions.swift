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
            uiv.goToVC(vc)
        } else {
            let vc = vcCanadaRadar()
            vc.caRadarImageType = "vis"
            uiv.goToVC(vc)
        }
    }
    
    static func radarClicked(_ uiv: UIViewController) {
        if !Location.isUS {
            let vc = vcCanadaRadar()
            vc.caRadarImageType = "radar"
            vc.caRadarProvince = ""
            uiv.goToVC(vc)
        } else {
            let vc = vcNexradRadar()
            if UIPreferences.dualpaneRadarIcon {
                vc.wxoglPaneCount = "2"
            } else {
                vc.wxoglPaneCount = "1"
            }
            uiv.goToVC(vc)
        }
    }
    
    static func wfotextClicked(_ uiv: UIViewController) {
        if Location.isUS {
            let vc = vcWfoText()
            uiv.goToVC(vc)
        } else {
            let vc = vcCanadaText()
            uiv.goToVC(vc)
        }
    }
    
    static func dashClicked(_ uiv: UIViewController) {
        if Location.isUS {
            let vc = vcSevereDashboard()
            uiv.goToVC(vc)
        } else {
            let vc = vcCanadaWarnings()
            uiv.goToVC(vc)
        }
    }
    
    static func multiPaneRadarClicked(_ uiv: UIViewController, _ paneCount: String) {
        let vc = vcNexradRadar()
        switch paneCount {
        case "2":
            vc.wxoglPaneCount = "2"
        case "4":
            vc.wxoglPaneCount = "4"
        default: break
        }
        uiv.goToVC(vc)
    }
    
    static func menuItemClicked(_ uiv: UIViewController, _ menuItem: String, _ button: ObjectToolbarIcon) {
        switch menuItem {
        case "Soundings":
            let vc = vcSoundings()
            uiv.goToVC(vc)
        case "Hourly Forecast":
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
                    let vc = vcRadarMosaic()
                    vc.nwsMosaicType = "local"
                    uiv.goToVC(vc)
                } else {
                    let vc = vcRadarMosaicAwc()
                    vc.nwsMosaicType = "local"
                    uiv.goToVC(vc)
                }
            } else {
                let prov = MyApplication.locations[Location.getLocationIndex].prov
                let vc = vcCanadaRadar()
                vc.caRadarProvince = UtilityCanada.getECSectorFromProvidence(prov)
                vc.caRadarImageType = "radar"
                uiv.goToVC(vc)
            }
        case "US Alerts":
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
    
    static func goToVc(_ uiv: UIViewController, _ target: UIViewController) {
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
        let menuList = [
            "Hourly Forecast",
            "Radar Mosaic",
            "US Alerts",
            "Observations",
            "Soundings",
            "PlayList",
            "Settings"
        ]
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
