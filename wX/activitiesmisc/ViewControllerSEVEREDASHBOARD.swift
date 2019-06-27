/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation

class ViewControllerSEVEREDASHBOARD: UIwXViewController {

    var buttonActions = [String]()
    let snWat = SevereNotice("wat")
    let snMcd = SevereNotice("mcd")
    let snMpd = SevereNotice("mpd")
    var bitmap = Bitmap()
    let synth = AVSpeechSynthesizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, shareButton]).items
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        self.getContent()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            UtilityDownloadRadar.getAllRadarData()
            self.bitmap = Bitmap(MyApplication.nwsSPCwebsitePrefix + "/climo/reports/" + "today" + ".gif")
            self.snMcd.getBitmaps(MyApplication.mcdNoList.value)
            self.snWat.getBitmaps(MyApplication.watNoList.value)
            self.snMpd.getBitmaps(MyApplication.mpdNoList.value)
            DispatchQueue.main.async {
                if UIAccessibility.isVoiceOverRunning {
                    UtilityActions.speakText(self.getStatusText(), self.synth)
                }
               self.displayContent()
            }
        }
    }

    func getStatusText() -> String {
        var spokenText = "Download complete with"
        let wTor = SevereWarning("tor")
        let wTst = SevereWarning("tst")
        let wFfw = SevereWarning("ffw")
        let titles = ["Tornado Warnings ", "Severe Thunderstorm Warnings ", "Flash Flood Warnings "]
        wTor.generateString(MyApplication.severeDashboardTor.value)
        wTst.generateString(MyApplication.severeDashboardTst.value)
        wFfw.generateString(MyApplication.severeDashboardFfw.value)
        [wTor.text, wTst.text, wFfw.text].enumerated().forEach {
            if $1 != "" {
                let sArr = $1.split(MyApplication.newline)
                let count = String(sArr.count - 1)
                spokenText += count + titles[$0] + " "
            }
        }
        spokenText += String(self.snMcd.bitmaps.count) + " mcd "
            + String(self.snWat.bitmaps.count) + " watch "
            + String(self.snMpd.bitmaps.count) + " mpd "
        return spokenText
    }

    @objc func imgClicked(sender: UITapGestureRecognizerWithData) {
        var token = ""
        if self.buttonActions[sender.data].hasPrefix("WPCMPD") {
            ActVars.wpcMpdNumber = self.buttonActions[sender.data].replace("WPCMPD", "")
            token = "wpcmpd"
        }
        if self.buttonActions[sender.data].hasPrefix("SPCMCD") {
            ActVars.spcMcdNumber = self.buttonActions[sender.data].replace("SPCMCD", "")
            token = "spcmcd"
        }
        if self.buttonActions[sender.data].hasPrefix("SPCWAT") {
            ActVars.spcWatchNumber = self.buttonActions[sender.data].replace("SPCWAT", "")
            token = "spcwat"
        }
        self.goToVC(token)
    }

    func showTextWarnings(_ views: inout [UIView]) {
        let wTor = SevereWarning("tor")
        let wTst = SevereWarning("tst")
        let wFfw = SevereWarning("ffw")
        let titles = ["Tornado Warnings:", "Severe Thunderstorm Warnings:", "Flash Flood Warnings:"]
        wTor.generateString(MyApplication.severeDashboardTor.value)
        wTst.generateString(MyApplication.severeDashboardTst.value)
        wFfw.generateString(MyApplication.severeDashboardFfw.value)
        [wTor.text, wTst.text, wFfw.text].enumerated().forEach {
            if $1 != "" {
                let sArr = $1.split(MyApplication.newline)
                let visibleText = "(" + String(sArr.count - 1) + ") " + titles[$0] + MyApplication.newline + $1
                let objectTextView = ObjectTextView(
                    stackView,
                    visibleText,
                    UITapGestureRecognizer(target: self, action: #selector(gotoAlerts))
                )
                objectTextView.tv.isAccessibilityElement = true
                objectTextView.tv.accessibilityLabel = visibleText
                views.append(objectTextView.tv)
            }
        }
    }

    @objc func gotoAlerts() {
        self.goToVC("usalerts")
    }

    @objc func spcstreportsClicked(sender: UITapGestureRecognizer) {
        ActVars.spcStormReportsDay = "today"
        self.goToVC("spcstormreports")
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self,
                                sender,
                                [self.bitmap] + self.snMcd.bitmaps + self.snWat.bitmaps + self.snMpd.bitmaps
        )
    }

    private func displayContent() {
        var views = [UIView]()
        self.showTextWarnings(&views)
        let objectImage = ObjectImage(
            self.stackView,
            bitmap,
            UITapGestureRecognizer(target: self, action: #selector(spcstreportsClicked(sender:)))
        )
        objectImage.img.accessibilityLabel = "spc storm reports"
        objectImage.img.isAccessibilityElement = true
        views.append(objectImage.img)
        var index = 0
        var watI = 0
        var mcdI = 0
        var mpdI = 0
        snWat.bitmaps.forEach {
            let objectImage  = ObjectImage(
                self.stackView,
                $0,
                UITapGestureRecognizerWithData(index, self, #selector(imgClicked(sender:)))
            )
            self.buttonActions.append("SPCWAT" + snWat.numberList[watI])
            objectImage.img.accessibilityLabel = "SPCWAT" + snWat.numberList[watI]
            objectImage.img.isAccessibilityElement = true
            views.append(objectImage.img)
            index += 1
            watI += 1
        }
        snMcd.bitmaps.forEach {
            let objectImage = ObjectImage(
                self.stackView,
                $0,
                UITapGestureRecognizerWithData(index, self, #selector(imgClicked(sender:)))
            )
            self.buttonActions.append("SPCMCD" + snMcd.numberList[mcdI])
            objectImage.img.accessibilityLabel = "SPCMCD" + snMcd.numberList[mcdI]
            objectImage.img.isAccessibilityElement = true
            views.append(objectImage.img)
            index += 1
            mcdI += 1
        }
        snMpd.bitmaps.forEach {
            let objectImage = ObjectImage(
                self.stackView,
                $0,
                UITapGestureRecognizerWithData(index, self, #selector(imgClicked(sender:)))
            )
            self.buttonActions.append("WPCMPD" + snMpd.numberList[mpdI])
            objectImage.img.accessibilityLabel = "WPCMPD" + snMpd.numberList[mpdI]
            objectImage.img.isAccessibilityElement = true
            views.append(objectImage.img)
            index += 1
            mpdI += 1
        }
        self.view.bringSubviewToFront(self.toolbar)
        scrollView.accessibilityElements = views
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: nil,
            completion: { _ -> Void in
                self.refreshViews()
                self.displayContent()
            }
        )
    }
}
