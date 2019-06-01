/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectNhc: NSObject {

    private var atlSumList = [String]()
    private var atlLinkList = [String]()
    private var atlImg1List = [String]()
    private var atlImg2List = [String]()
    private var atlWalletList = [String]()
    private var atlTitleList = [String]()
    private var pacSumList = [String]()
    private var pacLinkList = [String]()
    private var pacImg1List = [String]()
    private var pacImg2List = [String]()
    private var pacWalletList = [String]()
    private var pacTitleList = [String]()
    private var uiv: UIViewController
    private var stackView: UIStackView
    //private var blob = ""
    private var textAtl = ""
    private var textPac = ""
    private var bitmaps = [Bitmap]()

    private let imageUrls = [
        MyApplication.nwsNhcWebsitePrefix + "/xgtwo/two_atl_0d0.png",
        MyApplication.nwsNhcWebsitePrefix + "/xgtwo/two_atl_2d0.png",
        MyApplication.nwsNhcWebsitePrefix + "/xgtwo/two_atl_5d0.png",
        MyApplication.nwsNhcWebsitePrefix + "/xgtwo/two_pac_0d0.png",
        MyApplication.nwsNhcWebsitePrefix + "/xgtwo/two_pac_2d0.png",
        MyApplication.nwsNhcWebsitePrefix + "/xgtwo/two_pac_5d0.png"
    ]

    init(_ uiv: UIViewController, _ stackView: UIStackView) {
        self.uiv = uiv
        self.stackView = stackView
    }

    func updateParents(_ uiv: UIViewController, _ stackView: UIStackView) {
        self.uiv = uiv
        self.stackView = stackView
    }

    func getData() {
        imageUrls.forEach {bitmaps.append(Bitmap($0))}
        (1...5).forEach {
            let dataRet = UtilityNhc.getHurricaneInfo(MyApplication.nwsNhcWebsitePrefix
                + "/nhc_at" + String($0) + ".xml")
            if dataRet.title != "" {
                self.atlSumList.append(dataRet.summary)
                let text = dataRet.url.getHtmlSep().parse(MyApplication.pre2Pattern)
                self.atlLinkList.append(text)
                self.atlImg1List.append(dataRet.img1)
                self.atlImg2List.append(dataRet.img2)
                self.atlWalletList.append(dataRet.wallet)
                self.atlTitleList.append(dataRet.title.replace("NHC Atlantic Wallet", ""))
            }
        }
        (1...5).forEach {
            let dataRet = UtilityNhc.getHurricaneInfo(MyApplication.nwsNhcWebsitePrefix
                + "/nhc_ep" + String($0) + ".xml")
            if dataRet.title != "" {
                self.pacSumList.append(dataRet.summary)
                let text = dataRet.url.getHtmlSep().parse(MyApplication.pre2Pattern)
                self.pacLinkList.append(text)
                self.pacImg1List.append(dataRet.img1)
                self.pacImg2List.append(dataRet.img2)
                self.pacWalletList.append(dataRet.wallet)
                self.pacTitleList.append(dataRet.title.replace("NHC Eastern Pacific Wallet", ""))
            }
        }
    }

    func showData() {
        if self.atlSumList.count < 1 {
            textAtl =  "There are no tropical cyclones in the Atlantic at this time."
        } else {
            self.atlSumList.indices.forEach {
                if atlImg1List[$0] != "" {
                    let text = self.atlSumList[$0].replaceAllRegexp("<.*?>", "")
                    _ = ObjectTextView(
                        stackView,
                        text,
                        UITapGestureRecognizerWithData($0, self, #selector(gotoAtlNhcStorm(sender:)))
                    )
                }
            }
        }
        if self.pacSumList.count < 1 {
            textPac += "There are no tropical cyclones in the Eastern Pacific at this time."
        } else {
            self.pacSumList.indices.forEach {
                if pacImg1List[$0] != "" {
                    let text = self.pacSumList[$0].replaceAllRegexp("<.*?>", "")
                    _ = ObjectTextView(
                        stackView,
                        text,
                        UITapGestureRecognizerWithData($0, self, #selector(gotoEpacNhcStorm(sender:)))
                    )
                }
            }
        }
        if textAtl != "" {
            _ = ObjectTextView(stackView, textAtl)
        }
        if textPac != "" {
            _ = ObjectTextView(stackView, textPac)
        }
        bitmaps.forEach {_ = ObjectImage(stackView, $0)}
    }

    @objc func gotoEpacNhcStorm(sender: UITapGestureRecognizerWithData) {
        let index = sender.data
        ActVars.nhcStormUrl = pacLinkList[index]
        ActVars.nhcStormTitle = pacTitleList[index]
        ActVars.nhcStormImgUrl1 = pacImg1List[index]
        ActVars.nhcStormImgUrl2 = pacImg2List[index]
        ActVars.nhcStormWallet = pacWalletList[index]
        uiv.goToVC("nhcstorm")
    }

    @objc func gotoAtlNhcStorm(sender: UITapGestureRecognizerWithData) {
        let index = sender.data
        ActVars.nhcStormUrl = atlLinkList[index]
        ActVars.nhcStormTitle = atlTitleList[index]
        ActVars.nhcStormImgUrl1 = atlImg1List[index]
        ActVars.nhcStormImgUrl2 = atlImg2List[index]
        ActVars.nhcStormWallet = atlWalletList[index]
        uiv.goToVC("nhcstorm")
    }
}
