/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerSEVEREDASHBOARD: UIwXViewController {

    var buttonActionArray = [String]()
    let snWat = SevereNotice("wat")
    let snMcd = SevereNotice("mcd")
    let snMpd = SevereNotice("mpd")
    var bm = Bitmap()

    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, shareButton]).items
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        self.getContent()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            UtilityDownloadRadar.getPolygonVtec()
            UtilityDownloadRadar.getMpd()
            UtilityDownloadRadar.getMcd()
            UtilityDownloadRadar.getWatch()
            self.bm = Bitmap(MyApplication.nwsSPCwebsitePrefix + "/climo/reports/" + "today" + ".gif")
            self.snMcd.getBitmaps(MyApplication.mcdNoList.value)
            self.snWat.getBitmaps(MyApplication.watNoList.value)
            self.snMpd.getBitmaps(MyApplication.mpdNoList.value)
            DispatchQueue.main.async {
               self.displayContent()
            }
        }
    }

    @objc func imgClicked(sender: UITapGestureRecognizerWithData) {
        var token = ""
        if self.buttonActionArray[sender.data].hasPrefix("WPCMPD") {
            ActVars.wpcMpdNumber = self.buttonActionArray[sender.data].replace("WPCMPD", "")
            token = "wpcmpd"
        }
        if self.buttonActionArray[sender.data].hasPrefix("SPCMCD") {
            ActVars.spcMcdNumber = self.buttonActionArray[sender.data].replace("SPCMCD", "")
            token = "spcmcd"
        }
        if self.buttonActionArray[sender.data].hasPrefix("SPCWAT") {
            ActVars.spcWatchNumber = self.buttonActionArray[sender.data].replace("SPCWAT", "")
            token = "spcwat"
        }
        self.goToVC(token)
    }

    func showTextWarnings() {
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
                _ = ObjectTextView(
                    stackView,
                    "(" + String(sArr.count - 1) + ") " + titles[$0] + MyApplication.newline + $1,
                    UITapGestureRecognizer(target: self, action: #selector(gotoAlerts))
                )
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
        UtilityShare.shareImage(self, sender, [self.bm] + self.snMcd.bitmaps + self.snWat.bitmaps + self.snMpd.bitmaps)
    }

    private func displayContent() {
        self.showTextWarnings()
        _ = ObjectImage(
            self.stackView,
            bm,
            UITapGestureRecognizer(target: self, action: #selector(spcstreportsClicked(sender:)))
        )
        var index = 0
        var watI = 0
        var mcdI = 0
        var mpdI = 0
        snWat.bitmaps.forEach {
            _ = ObjectImage(
                self.stackView,
                $0,
                UITapGestureRecognizerWithData(index, self, #selector(imgClicked(sender:)))
            )
            self.buttonActionArray.append("SPCWAT" + snWat.numberList[watI])
            index += 1
            watI += 1
        }
        snMcd.bitmaps.forEach {
            _ = ObjectImage(
                self.stackView,
                $0,
                UITapGestureRecognizerWithData(index, self, #selector(imgClicked(sender:)))
            )
            self.buttonActionArray.append("SPCMCD" + snMcd.numberList[mcdI])
            index += 1
            mcdI += 1
        }
        snMpd.bitmaps.forEach {
            _ = ObjectImage(
                self.stackView,
                $0,
                UITapGestureRecognizerWithData(index, self, #selector(imgClicked(sender:)))
            )
            self.buttonActionArray.append("WPCMPD" + snMpd.numberList[mpdI])
            index += 1
            mpdI += 1
        }
        self.view.bringSubviewToFront(self.toolbar)
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
