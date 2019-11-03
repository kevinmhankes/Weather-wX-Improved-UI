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
    var usAlertsBitmap = Bitmap()
    let synth = AVSpeechSynthesizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, shareButton]).items
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        self.getContent()
    }

    @objc func willEnterForeground() {
        self.getContent()
    }

    func getContent() {
        refreshViews()
        DispatchQueue.global(qos: .userInitiated).async {
            UtilityDownloadRadar.getAllRadarData()
            self.bitmap = Bitmap(MyApplication.nwsSPCwebsitePrefix + "/climo/reports/" + "today" + ".gif")
            self.usAlertsBitmap = Bitmap("https://forecast.weather.gov/wwamap/png/US.png")
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
        wTor.generateString(MyApplication.severeDashboardTor.value)
        wTst.generateString(MyApplication.severeDashboardTst.value)
        wFfw.generateString(MyApplication.severeDashboardFfw.value)
        [wTor, wTst, wFfw].enumerated().forEach { index, warningType in
            if warningType.text != "" {
                _ = ObjectCardBlackHeaderText(stackView, "(" + String(warningType.getCount()) + ") " + warningType.getName())
                warningType.eventList.enumerated().forEach { index, _ in
                    if warningType.warnings.count > 0 {
                        let data = warningType.warnings[index]
                        //let vtecIsCurrent = UtilityTime.isVtecCurrent(data);
                        if !data.hasPrefix("O.EXP") {
                            let objectCardDashAlertItem = ObjectCardDashAlertItem(
                                stackView,
                                warningType.senderNameList[index],
                                warningType.eventList[index],
                                warningType.effectiveList[index],
                                warningType.expiresList[index],
                                warningType.areaDescList[index],
                                UITapGestureRecognizerWithData(warningType.idList[index], self, #selector(gotoAlert(sender:)))
                            )
                            self.stackView.addArrangedSubview(objectCardDashAlertItem.cardStackView.view)
                        }
                    }
                }
            }
        }
    }

    @objc func gotoAlerts() {
        self.goToVC("usalerts")
    }

    @objc func gotoAlert(sender: UITapGestureRecognizerWithData) {
        ActVars.usalertsDetailUrl = "https://api.weather.gov/alerts/" + sender.strData
        self.goToVC("usalertsdetail")
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
        var imageCount = 0
        let imagesPerRow = 2
        var imageStackViewList = [ObjectStackView]()
        (0..<(2 + self.snMcd.bitmaps.count + self.snMpd.bitmaps.count + self.snWat.bitmaps.count)).forEach {
            imageStackViewList.append(
                ObjectStackView(
                    UIStackView.Distribution.fillEqually,
                    NSLayoutConstraint.Axis.horizontal
                )
            )
            self.stackView.addArrangedSubview(imageStackViewList[$0].view)
        }
        let objectImage = ObjectImage(
            imageStackViewList[0].view,
            usAlertsBitmap,
            UITapGestureRecognizer(target: self, action: #selector(gotoAlerts)),
            widthDivider: imagesPerRow
        )
        imageCount += 1
        objectImage.img.accessibilityLabel = "US Alerts"
        objectImage.img.isAccessibilityElement = true
        views.append(objectImage.img)
        let objectImage2 = ObjectImage(
            imageStackViewList[0].view,
            bitmap,
            UITapGestureRecognizer(target: self, action: #selector(spcstreportsClicked(sender:))),
            widthDivider: imagesPerRow
        )
        imageCount += 1
        objectImage2.img.accessibilityLabel = "spc storm reports"
        objectImage2.img.isAccessibilityElement = true
        views.append(objectImage2.img)
        var index = 0
        var watI = 0
        var mcdI = 0
        var mpdI = 0
        snWat.bitmaps.enumerated().forEach {
            let objectImage  = ObjectImage(
                imageStackViewList[imageCount / imagesPerRow].view,
                $1,
                UITapGestureRecognizerWithData(index, self, #selector(imgClicked(sender:))),
                widthDivider: imagesPerRow
            )
            self.buttonActions.append("SPCWAT" + snWat.numberList[watI])
            objectImage.img.accessibilityLabel = "SPCWAT" + snWat.numberList[watI]
            objectImage.img.isAccessibilityElement = true
            views.append(objectImage.img)
            index += 1
            watI += 1
            imageCount += 1
        }
        snMcd.bitmaps.enumerated().forEach {
            let objectImage = ObjectImage(
                imageStackViewList[imageCount / imagesPerRow].view,
                $1,
                UITapGestureRecognizerWithData(index, self, #selector(imgClicked(sender:))),
                widthDivider: imagesPerRow
            )
            self.buttonActions.append("SPCMCD" + snMcd.numberList[mcdI])
            objectImage.img.accessibilityLabel = "SPCMCD" + snMcd.numberList[mcdI]
            objectImage.img.isAccessibilityElement = true
            views.append(objectImage.img)
            index += 1
            mcdI += 1
            imageCount += 1
        }
        snMpd.bitmaps.enumerated().forEach {
            let objectImage = ObjectImage(
                imageStackViewList[imageCount / imagesPerRow].view,
                $1,
                UITapGestureRecognizerWithData(index, self, #selector(imgClicked(sender:))),
                widthDivider: imagesPerRow
            )
            self.buttonActions.append("WPCMPD" + snMpd.numberList[mpdI])
            objectImage.img.accessibilityLabel = "WPCMPD" + snMpd.numberList[mpdI]
            objectImage.img.isAccessibilityElement = true
            views.append(objectImage.img)
            index += 1
            mpdI += 1
            imageCount += 1
        }
        self.showTextWarnings(&views)
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
