/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation

final class vcSevereDashboard: UIwXViewController {
    
    private var buttonActions = [String]()
    private let snWat = SevereNotice("SPCWAT")
    private let snMcd = SevereNotice("SPCMCD")
    private let snMpd = SevereNotice("WPCMPD")
    private var bitmap = Bitmap()
    private var usAlertsBitmap = Bitmap()
    private var statusButton = ObjectToolbarIcon()
    private let synthesizer = AVSpeechSynthesizer()
    private var statusWarnings = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = ObjectToolbarIcon(self, .share, #selector(share))
        statusButton = ObjectToolbarIcon(self, nil)
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, statusButton, shareButton]).items
        objScrollStackView = ObjectScrollStackView(self)
        self.getContent()
    }
    
    override func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            UtilityDownloadRadar.getAllRadarData()
            self.bitmap = Bitmap(MyApplication.nwsSPCwebsitePrefix + "/climo/reports/" + "today" + ".gif")
            self.usAlertsBitmap = Bitmap(ObjectAlertSummary.imageUrls[0])
            self.snMcd.getBitmaps(MyApplication.mcdNoList.value)
            self.snWat.getBitmaps(MyApplication.watNoList.value)
            self.snMpd.getBitmaps(MyApplication.mpdNoList.value)
            DispatchQueue.main.async {
                if UIAccessibility.isVoiceOverRunning { UtilityAudio.speakText(self.getStatusText(), self.synthesizer) }
                self.display()
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
        [wTor.text, wTst.text, wFfw.text].enumerated().forEach { index, item in
            if item != "" {
                let sArr = item.split(MyApplication.newline)
                let count = String(sArr.count - 1)
                spokenText += count + titles[index] + " "
            }
        }
        spokenText += String(self.snMcd.bitmaps.count) + " mcd " + String(self.snWat.bitmaps.count) + " watch " + String(self.snMpd.bitmaps.count) + " mpd "
        return spokenText
    }
    
    @objc func imageClicked(sender: UITapGestureRecognizerWithData) {
        if self.buttonActions[sender.data].hasPrefix("WPCMPD") {
            Route.spcMcdWatchItem(self, .MPD, self.buttonActions[sender.data].replace("WPCMPD", ""))
        } else if self.buttonActions[sender.data].hasPrefix("SPCMCD") {
            Route.spcMcdWatchItem(self, .MCD, self.buttonActions[sender.data].replace("SPCMCD", ""))
        } else if self.buttonActions[sender.data].hasPrefix("SPCWAT") {
            Route.spcMcdWatchItem(self, .WATCH, self.buttonActions[sender.data].replace("SPCWAT", ""))
        }
    }
    
    func showTextWarnings() {
        let wTor = SevereWarning("tor")
        let wTst = SevereWarning("tst")
        let wFfw = SevereWarning("ffw")
        wTor.generateString(MyApplication.severeDashboardTor.value)
        wTst.generateString(MyApplication.severeDashboardTst.value)
        wFfw.generateString(MyApplication.severeDashboardFfw.value)
        [wTor, wTst, wFfw].enumerated().forEach { index, warningType in
            if warningType.text != "" {
                _ = ObjectCardBlackHeaderText(self, "(" + String(warningType.getCount()) + ") " + warningType.getName())
                warningType.eventList.indices.forEach { index in
                    if warningType.warnings.count > 0 {
                        let data = warningType.warnings[index]
                        //let vtecIsCurrent = UtilityTime.isVtecCurrent(data);
                        if !data.hasPrefix("O.EXP") {
                            _ = ObjectCardDashAlertItem(
                                self,
                                warningType,
                                index,
                                UITapGestureRecognizerWithData(warningType.idList[index], self, #selector(goToAlert(sender:))),
                                UITapGestureRecognizerWithData(warningType.listOfWfo[index], self, #selector(goToRadar(sender:))),
                                UITapGestureRecognizerWithData(warningType.listOfWfo[index], self, #selector(goToRadar(sender:)))
                            )
                        }
                    }
                }
            }
        }
        if wTor.eventList.count > 0 || wTst.eventList.count > 0 || wFfw.eventList.count > 0 {
            statusWarnings = "(" + String(wTor.eventList.count) + ","  + String(wTst.eventList.count) + "," + String(wFfw.eventList.count) + ")"
        } else {
            statusWarnings = ""
        }
    }
    
    @objc func goToAlerts() {
        self.goToVC(vcUSAlerts())
    }
    
    @objc func goToAlert(sender: UITapGestureRecognizerWithData) {
        Route.alertDetail(self, "https://api.weather.gov/alerts/" + sender.strData)
    }
    
    @objc func goToRadar(sender: UITapGestureRecognizerWithData) {
        Route.radarNoSave(self, GlobalDictionaries.wfoToRadarSite[sender.strData] ?? "")
    }
    
    @objc func spcStormReportsClicked() {
        Route.spcStormReports(self, "today")
    }
    
    @objc func share(sender: UIButton) {
        UtilityShare.image(self, sender, [self.bitmap] + self.snMcd.bitmaps + self.snWat.bitmaps + self.snMpd.bitmaps)
    }
    
    private func display() {
        self.refreshViews()
        var views = [UIView]()
        buttonActions = [String]()
        var imageCount = 0
        var imagesPerRow = 2
        var imageStackViewList = [ObjectStackView]()
        if UtilityUI.isTablet() && UtilityUI.isLandscape() { imagesPerRow = 3 }
        let objectImage: ObjectImage
        if imageCount % imagesPerRow == 0 {
            let stackView = ObjectStackView(UIStackView.Distribution.fillEqually, NSLayoutConstraint.Axis.horizontal)
            imageStackViewList.append(stackView)
            self.stackView.addArrangedSubview(stackView.view)
            stackView.view.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
            objectImage = ObjectImage(
                stackView.view,
                usAlertsBitmap,
                UITapGestureRecognizer(target: self, action: #selector(goToAlerts)),
                widthDivider: imagesPerRow
            )
        } else {
            objectImage = ObjectImage(
                imageStackViewList.last!.view,
                usAlertsBitmap,
                UITapGestureRecognizer(target: self, action: #selector(goToAlerts)),
                widthDivider: imagesPerRow
            )
        }
        imageCount += 1
        objectImage.img.accessibilityLabel = "US Alerts"
        objectImage.img.isAccessibilityElement = true
        views.append(objectImage.img)
        let objectImage2: ObjectImage
        if imageCount % imagesPerRow == 0 {
            let stackView = ObjectStackView(UIStackView.Distribution.fillEqually, NSLayoutConstraint.Axis.horizontal)
            imageStackViewList.append(stackView)
            self.stackView.addArrangedSubview(stackView.view)
            objectImage2 = ObjectImage(
                stackView.view,
                bitmap,
                UITapGestureRecognizer(target: self, action: #selector(spcStormReportsClicked)),
                widthDivider: imagesPerRow
            )
        } else {
            objectImage2 = ObjectImage(
                imageStackViewList.last!.view,
                bitmap,
                UITapGestureRecognizer(target: self, action: #selector(spcStormReportsClicked)),
                widthDivider: imagesPerRow
            )
        }
        imageCount += 1
        objectImage2.img.accessibilityLabel = "spc storm reports"
        objectImage2.img.isAccessibilityElement = true
        views.append(objectImage2.img)
        var index = 0
        [snWat, snMcd, snMpd].forEach { severeNotice in
            severeNotice.bitmaps.enumerated().forEach { imageIndex, image in
                let stackView: UIStackView
                if imageCount % imagesPerRow == 0 {
                    let objectStackView = ObjectStackView(UIStackView.Distribution.fillEqually, NSLayoutConstraint.Axis.horizontal)
                    imageStackViewList.append(objectStackView)
                    stackView = objectStackView.view
                    self.stackView.addArrangedSubview(stackView)
                } else {
                    stackView = imageStackViewList.last!.view
                }
                let objectImage = ObjectImage(
                    stackView,
                    image,
                    UITapGestureRecognizerWithData(index, self, #selector(imageClicked(sender:))),
                    widthDivider: imagesPerRow
                )
                self.buttonActions.append(severeNotice.type + severeNotice.numberList[imageIndex])
                objectImage.img.accessibilityLabel = severeNotice.type + severeNotice.numberList[imageIndex]
                objectImage.img.isAccessibilityElement = true
                views.append(objectImage.img)
                index += 1
                imageCount += 1
            }
        }
        self.showTextWarnings()
        self.view.bringSubviewToFront(self.toolbar)
        scrollView.accessibilityElements = views
        var status = ""
        let warningLabel = ["W", "M", "P"]
        [snWat, snMcd, snMpd].enumerated().forEach { index, severeNotice in
            if severeNotice.bitmaps.count > 0 {
                status += warningLabel[index] + "(" + String(severeNotice.bitmaps.count) + ") "
            }
        }
        self.statusButton.title = status + " " + statusWarnings
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { _ -> Void in self.display() })
    }
}
