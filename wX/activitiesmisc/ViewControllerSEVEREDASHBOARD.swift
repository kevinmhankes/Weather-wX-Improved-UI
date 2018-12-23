/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerSEVEREDASHBOARD: UIwXViewController {

    var buttonActionArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton]).items
        _ = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        self.getContent()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            let snWat = SevereNotice("wat")
            let snMcd = SevereNotice("mcd")
            let snMpd = SevereNotice("mpd")
            UtilityDownloadRadar.getPolygonVTEC()
            UtilityDownloadRadar.getMPD()
            UtilityDownloadRadar.getMCD()
            UtilityDownloadRadar.getWAT()
            let bm = Bitmap(MyApplication.nwsSPCwebsitePrefix + "/climo/reports/" + "today" + ".gif")
            snMcd.getBitmaps(MyApplication.mcdNoList.value)
            snWat.getBitmaps(MyApplication.watNoList.value)
            snMpd.getBitmaps(MyApplication.mpdNoList.value)
            DispatchQueue.main.async {
                self.showTextWarnings()
                let imgObject = ObjectImage(self.stackView, bm)
                let tapGestureRecognizerSPCRPT = UITapGestureRecognizer(target: self,
                    action: #selector(self.spcstreportsClicked(sender:)))
                imgObject.addGestureRecognizer(tapGestureRecognizerSPCRPT)
                var index = 0
                var watI = 0
                var mcdI = 0
                var mpdI = 0
                snWat.bitmaps.forEach {
                    let imgObject = ObjectImage(self.stackView, $0)
                    imgObject.addGestureRecognizer(
                        UITapGestureRecognizerWithData(index, self, #selector(self.imgClicked(sender:)))
                    )
                    self.buttonActionArray.append("SPCWAT" + snWat.numberList[watI])
                    index += 1
                    watI += 1
                }
                snMcd.bitmaps.forEach {
                    let imgObject = ObjectImage(self.stackView, $0)
                    imgObject.addGestureRecognizer(
                        UITapGestureRecognizerWithData(index, self, #selector(self.imgClicked(sender:)))
                    )
                    self.buttonActionArray.append("SPCMCD" + snMcd.numberList[mcdI])
                    index += 1
                    mcdI += 1
                }
                snMpd.bitmaps.forEach {
                    let imgObject = ObjectImage(self.stackView, $0)
                    imgObject.addGestureRecognizer(
                        UITapGestureRecognizerWithData(index, self, #selector(self.imgClicked(sender:)))
                    )
                    self.buttonActionArray.append("WPCMPD" + snMpd.numberList[mpdI])
                    index += 1
                    mpdI += 1
                }
                self.view.bringSubviewToFront(self.toolbar)
            }
        }
    }

    @objc func imgClicked(sender: UITapGestureRecognizerWithData) {
        var token = ""
        if self.buttonActionArray[sender.data].hasPrefix("WPCMPD") {
            ActVars.WPCMPDNo = self.buttonActionArray[sender.data].replace("WPCMPD", "")
            token = "wpcmpd"
        }
        if self.buttonActionArray[sender.data].hasPrefix("SPCMCD") {
            ActVars.SPCMCDNo = self.buttonActionArray[sender.data].replace("SPCMCD", "")
            token = "spcmcd"
        }
        if self.buttonActionArray[sender.data].hasPrefix("SPCWAT") {
            ActVars.SPCWATNo = self.buttonActionArray[sender.data].replace("SPCWAT", "")
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
                let objAlert = ObjectTextView(stackView, "(" + String(sArr.count-1) + ") "
                    + titles[$0] + MyApplication.newline + $1)
                objAlert.addGestureRecognizer(UITapGestureRecognizer(target: self,
                    action: #selector(ViewControllerSEVEREDASHBOARD.gotoAlerts)))
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
}
