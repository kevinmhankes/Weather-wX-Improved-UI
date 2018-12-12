/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectNHC: NSObject {

    var atlSumList = [String]()
    var atlLinkList = [String]()
    var atlImg1List = [String]()
    var atlImg2List = [String]()
    var atlWalletList = [String]()
    var atlTitleList = [String]()
    var pacSumList = [String]()
    var pacLinkList = [String]()
    var pacImg1List = [String]()
    var pacImg2List = [String]()
    var pacWalletList = [String]()
    var pacTitleList = [String]()
    var uiv: UIViewController
    var stackView: UIStackView
    var blob = ""
    var bitmaps = [Bitmap]()

    let imageUrls = [
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

    func getData() {
        imageUrls.forEach {bitmaps.append(Bitmap($0))}
        (1...5).forEach {
            let dataRet = UtilityNHC.getHurricaneInfo(MyApplication.nwsNhcWebsitePrefix
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
            let dataRet = UtilityNHC.getHurricaneInfo(MyApplication.nwsNhcWebsitePrefix
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
            blob =  "There are no tropical cyclones in the Atlantic at this time." + MyApplication.newline
        } else {
            self.atlSumList.indices.forEach {
                if atlImg1List[$0] != "" {
                    let textStr = self.atlSumList[$0].replaceAllRegexp("<.*?>", "")
                    let obj = ObjectTextView(stackView, textStr)
                    obj.addGestureRecognizer(
                        UITapGestureRecognizerWithData(
                            data: $0,
                            target: self,
                            action: #selector(self.gotoATLNHCStorm(sender:))
                        )
                    )
                }
            }
        }
        if self.pacSumList.count < 1 {
            blob += "There are no tropical cyclones in the Eastern Pacific at this time."
                +  MyApplication.newline + MyApplication.newline
        } else {
            self.pacSumList.indices.forEach {
                if pacImg1List[$0] != "" {
                    let textStr = self.pacSumList[$0].replaceAllRegexp("<.*?>", "")
                    let obj = ObjectTextView(stackView, textStr)
                    obj.addGestureRecognizer(
                        UITapGestureRecognizerWithData(
                            data: $0,
                            target: self,
                            action: #selector(self.gotoEPACNHCStorm(sender:))
                        )
                    )
                }
            }
        }
        bitmaps.forEach {_ = ObjectImage(stackView, $0)}
    }

    @objc func gotoEPACNHCStorm(sender: UITapGestureRecognizerWithData) {
        let index = sender.data
        ActVars.NHCStormUrl = pacLinkList[index]
        ActVars.NHCStormTitle = pacTitleList[index]
        ActVars.NHCStormImgUrl1 = pacImg1List[index]
        ActVars.NHCStormImgUrl2 = pacImg2List[index]
        ActVars.NHCStormWallet = pacWalletList[index]
        uiv.goToVC("nhcstorm")
    }

    @objc func gotoATLNHCStorm(sender: UITapGestureRecognizerWithData) {
        let index = sender.data
        ActVars.NHCStormUrl = atlLinkList[index]
        ActVars.NHCStormTitle = atlTitleList[index]
        ActVars.NHCStormImgUrl1 = atlImg1List[index]
        ActVars.NHCStormImgUrl2 = atlImg2List[index]
        ActVars.NHCStormWallet = atlWalletList[index]
        uiv.goToVC("nhcstorm")
    }
}
