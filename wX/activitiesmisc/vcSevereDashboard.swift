/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation

final class vcSevereDashboard: UIwXViewController {

    private var buttonActions = [String]()
    private let snWat = SevereNotice(.SPCWAT)
    private let snMcd = SevereNotice(.SPCMCD)
    private let snMpd = SevereNotice(.WPCMPD)
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
        getContent()
    }

    override func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            UtilityDownloadRadar.getAllRadarData()
            self.bitmap = Bitmap(GlobalVariables.nwsSPCwebsitePrefix + "/climo/reports/" + "today" + ".gif")
            self.usAlertsBitmap = Bitmap(ObjectAlertSummary.imageUrls[0])
            self.snMcd.getBitmaps()
            self.snWat.getBitmaps()
            self.snMpd.getBitmaps()
            DispatchQueue.main.async {
                self.display()
            }
        }
    }

    @objc func imageClicked(sender: UITapGestureRecognizerWithData) {
        if buttonActions[sender.data].hasPrefix("WPCMPD") {
            Route.spcMcdWatchItem(self, .WPCMPD, buttonActions[sender.data].replace("WPCMPD", ""))
        } else if buttonActions[sender.data].hasPrefix("SPCMCD") {
            Route.spcMcdWatchItem(self, .SPCMCD, buttonActions[sender.data].replace("SPCMCD", ""))
        } else if buttonActions[sender.data].hasPrefix("SPCWAT") {
            Route.spcMcdWatchItem(self, .SPCWAT, buttonActions[sender.data].replace("SPCWAT", ""))
        }
    }

    func showTextWarnings() {
        let wTor = SevereWarning(.TOR)
        let wTst = SevereWarning(.TST)
        let wFfw = SevereWarning(.FFW)
        [wTor, wTst, wFfw].forEach { severeWarning in
            if severeWarning.getCount() > 0 {
                _ = ObjectCardBlackHeaderText(self, "(" + String(severeWarning.getCount()) + ") " + severeWarning.getName())
                for w in severeWarning.warningList {
                    if w.isCurrent {
                        let radarSite = w.getClosestRadar()
                        _ = ObjectCardDashAlertItem(
                            self,
                            w,
                            UITapGestureRecognizerWithData(w.url, self, #selector(goToAlert(sender:))),
                            UITapGestureRecognizerWithData(radarSite, self, #selector(goToRadar(sender:))),
                            UITapGestureRecognizerWithData(radarSite, self, #selector(goToRadar(sender:)))
                        )
                    }
                }
            }
        }
        if wTor.getCount() > 0 || wTst.getCount() > 0 || wFfw.getCount() > 0 {
            statusWarnings = "(" + wTor.getCount() + "," + wTst.getCount() + "," + wFfw.getCount() + ")"
        } else {
            statusWarnings = ""
        }
    }

    @objc func goToAlerts() {
        goToVC(vcUSAlerts())
    }

    @objc func goToAlert(sender: UITapGestureRecognizerWithData) {
        Route.alertDetail(self, sender.strData)
    }

    @objc func goToRadar(sender: UITapGestureRecognizerWithData) {
        Route.radarNoSave(self, sender.strData)
    }

    @objc func spcStormReportsClicked() {
        Route.spcStormReports(self, "today")
    }

    @objc func share(sender: UIButton) {
        UtilityShare.image(self, sender, [bitmap] + snMcd.bitmaps + snWat.bitmaps + snMpd.bitmaps)
    }

    private func display() {
        refreshViews()
        var views = [UIView]()
        buttonActions = [String]()
        var imageCount = 0
        var imagesPerRow = 2
        var imageStackViewList = [ObjectStackView]()
        let noticeCount = getNoticeCount()
        if UtilityUI.isTablet() && UtilityUI.isLandscape() {
            imagesPerRow = 3
        }
        if noticeCount == 0 && UtilityUI.isLandscape() {
            imagesPerRow = 2
        }
//        else if noticeCount == 0 && !UtilityUI.isLandscape() {
//            imagesPerRow = 1
//        }
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
                buttonActions.append(String(describing: severeNotice.type) + severeNotice.numberList[imageIndex])
                objectImage.img.accessibilityLabel = String(describing: severeNotice.type) + severeNotice.numberList[imageIndex]
                objectImage.img.isAccessibilityElement = true
                views.append(objectImage.img)
                index += 1
                imageCount += 1
            }
        }
        showTextWarnings()
        view.bringSubviewToFront(toolbar)
        scrollView.accessibilityElements = views
        var status = ""
        let warningLabel = ["W", "M", "P"]
        [snWat, snMcd, snMpd].enumerated().forEach { index, severeNotice in
            if severeNotice.bitmaps.count > 0 {
                status += warningLabel[index] + "(" + String(severeNotice.getCount()) + ") "
            }
        }
        statusButton.title = status + " " + statusWarnings
    }
    
    func getNoticeCount() -> Int {
        var count = 0
        [snWat, snMcd, snMpd].forEach { severeNotice in
            count += severeNotice.getCount()
        }
        return count
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { _ -> Void in self.display() })
    }
}
