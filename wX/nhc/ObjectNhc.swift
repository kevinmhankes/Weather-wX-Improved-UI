/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
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
    private var scrollView: UIScrollView
    private var textAtl = ""
    private var textPac = ""
    private var bitmapsAtlantic = [Bitmap]()
    private var bitmapsPacific = [Bitmap]()
    private var bitmapsCentral = [Bitmap]()
    private var imageCount = 0
    private var imagesPerRow = 2
    private var imageStackViewList = [ObjectStackView]()
    var regionMap = [NhcOceanEnum: ObjectNhcRegionSummary]()
    
    private let imageUrlsAtlanic = [
        MyApplication.nwsNhcWebsitePrefix + "/xgtwo/two_atl_0d0.png",
        MyApplication.nwsNhcWebsitePrefix + "/xgtwo/two_atl_2d0.png",
        MyApplication.nwsNhcWebsitePrefix + "/xgtwo/two_atl_5d0.png"
    ]

    private let imageUrlsPacific = [
        MyApplication.nwsNhcWebsitePrefix + "/xgtwo/two_pac_0d0.png",
        MyApplication.nwsNhcWebsitePrefix + "/xgtwo/two_pac_2d0.png",
        MyApplication.nwsNhcWebsitePrefix + "/xgtwo/two_pac_5d0.png"
    ]

    private let imageUrlsCentral = [
        MyApplication.nwsNhcWebsitePrefix + "/xgtwo/two_cpac_0d0.png",
        MyApplication.nwsNhcWebsitePrefix + "/xgtwo/two_cpac_2d0.png",
        MyApplication.nwsNhcWebsitePrefix + "/xgtwo/two_cpac_5d0.png"
    ]

    init(_ uiv: UIViewController, _ scrollView: UIScrollView, _ stackView: UIStackView) {
        self.uiv = uiv
        self.scrollView = scrollView
        self.stackView = stackView
        if UtilityUI.isTablet() {
            imagesPerRow = 3
        }
        super.init()
        NhcOceanEnum.allCases.forEach {
            regionMap[$0] = ObjectNhcRegionSummary($0)
        }
    }

    func updateParents(_ uiv: UIViewController, _ stackView: UIStackView) {
        self.uiv = uiv
        self.stackView = stackView
    }

    // TODO use a class to store 5 String Lists
    // potentially could use be a List of ObjectNhcStormInfo, list for ATL and one for PAC
    // ATL for example would have list of global bitmaps (which have url in object) and list for storms
    
    func getTextData() {
        (1...5).forEach {
            let dataRet = UtilityNhc.getHurricaneInfo(MyApplication.nwsNhcWebsitePrefix + "/nhc_at" + String($0) + ".xml")
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
            let dataRet = UtilityNhc.getHurricaneInfo(MyApplication.nwsNhcWebsitePrefix + "/nhc_ep" + String($0) + ".xml")
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

    func showTextData() {
        textAtl = ""
        if self.atlSumList.count < 1 {
            textAtl =  "There are no tropical cyclones in the Atlantic at this time."
        } else {
            self.atlSumList.indices.forEach {
                if atlImg1List[$0] != "" {
                    let objectNhcStormDetails = ObjectNhcStormDetails(self.atlSumList[$0])
                    _ = ObjectCardNhcStormReportItem(
                        stackView,
                        objectNhcStormDetails,
                        UITapGestureRecognizerWithData($0, self, #selector(gotoAtlNhcStorm(sender:)))
                    )
                }
            }
        }
        textPac = ""
        if self.pacSumList.count < 1 {
            textPac += "There are no tropical cyclones in the Eastern Pacific at this time."
        } else {
            self.pacSumList.indices.forEach {
                if pacImg1List[$0] != "" {
                    let objectNhcStormDetails = ObjectNhcStormDetails(self.pacSumList[$0])
                    _ = ObjectCardNhcStormReportItem(
                        stackView,
                        objectNhcStormDetails,
                        UITapGestureRecognizerWithData($0, self, #selector(gotoEpacNhcStorm(sender:)))
                    )
                }
            }
        }
        if textAtl != "" {
            let objectTextView = ObjectTextView(stackView, textAtl)
            //objectTextView.constrain(scrollView)
        }
        if textPac != "" {
            let objectTextView = ObjectTextView(stackView, textPac)
            //objectTextView.constrain(scrollView)
        }
    }
    
    func showImageData(_ region: NhcOceanEnum) {
        regionMap[region]!.bitmaps.enumerated().forEach { index, bitmap in
            if imageCount % imagesPerRow == 0 {
                let stackView = ObjectStackView(UIStackView.Distribution.fillEqually, NSLayoutConstraint.Axis.horizontal)
                imageStackViewList.append(stackView)
                self.stackView.addArrangedSubview(stackView.view)
                _ = ObjectImage(
                    stackView.view,
                    bitmap,
                    UITapGestureRecognizerWithData(regionMap[region]!.urls[index], uiv, #selector(imageClicked(sender:))),
                    widthDivider: imagesPerRow
                )
            } else {
                _ = ObjectImage(
                    imageStackViewList.last!.view,
                    bitmap,
                    UITapGestureRecognizerWithData(regionMap[region]!.urls[index], uiv, #selector(imageClicked(sender:))),
                    widthDivider: imagesPerRow
                )
            }
            imageCount += 1
        }
    }
    
    @objc func imageClicked(sender: UITapGestureRecognizerWithData) {}

    @objc func gotoEpacNhcStorm(sender: UITapGestureRecognizerWithData) {
        let index = sender.data
        let vc = vcNhcStorm()
        vc.nhcStormUrl = pacLinkList[index]
        vc.nhcStormTitle = pacTitleList[index]
        vc.nhcStormImgUrl1 = pacImg1List[index]
        vc.nhcStormImgUrl2 = pacImg2List[index]
        vc.nhcStormWallet = pacWalletList[index]
        uiv.goToVC(vc)
    }

    @objc func gotoAtlNhcStorm(sender: UITapGestureRecognizerWithData) {
        let index = sender.data
        let vc = vcNhcStorm()
        vc.nhcStormUrl = atlLinkList[index]
        vc.nhcStormTitle = atlTitleList[index]
        vc.nhcStormImgUrl1 = atlImg1List[index]
        vc.nhcStormImgUrl2 = atlImg2List[index]
        vc.nhcStormWallet = atlWalletList[index]
        uiv.goToVC(vc)
    }
}
