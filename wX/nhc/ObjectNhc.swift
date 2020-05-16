/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectNhc: NSObject {
    
    private var atlSumList = [String]()
    private var atlImg1List = [String]()
    private var atlStormDataList = [ObjectNhcStormDetails]()
    private var pacSumList = [String]()
    private var pacImg1List = [String]()
    private var pacStormDataList = [ObjectNhcStormDetails]()
    private var uiv: UIwXViewController
    private var textAtl = ""
    private var textPac = ""
    private var imageCount = 0
    private var imagesPerRow = 2
    private var imageStackViewList = [ObjectStackView]()
    var regionMap = [NhcOceanEnum: ObjectNhcRegionSummary]()
    
    init(_ uiv: UIwXViewController) {
        self.uiv = uiv
        if UtilityUI.isTablet() { imagesPerRow = 3 }
        super.init()
        NhcOceanEnum.allCases.forEach { regionMap[$0] = ObjectNhcRegionSummary($0) }
    }
    
    func getTextData() {
        (1...5).forEach { index in
            let dataRet = UtilityNhc.getHurricaneInfo(MyApplication.nwsNhcWebsitePrefix + "/nhc_at" + String(index) + ".xml")
            if dataRet.title != "" {
                self.atlSumList.append(dataRet.summary)
                self.atlImg1List.append(dataRet.img1)
            }
        }
        (1...5).forEach { index in
            let dataRet = UtilityNhc.getHurricaneInfo(MyApplication.nwsNhcWebsitePrefix + "/nhc_ep" + String(index) + ".xml")
            if dataRet.title != "" {
                self.pacSumList.append(dataRet.summary)
                self.pacImg1List.append(dataRet.img1)
            }
        }
    }
    
    func showTextData() {
        textAtl = ""
        if self.atlSumList.count < 1 {
            textAtl =  "There are no tropical cyclones in the Atlantic at this time."
        } else {
            self.atlSumList.indices.forEach { index in
                if atlImg1List[index] != "" {
                    let objectNhcStormDetails = ObjectNhcStormDetails(self.atlSumList[index], self.atlImg1List[index])
                    atlStormDataList.append(objectNhcStormDetails)
                    _ = ObjectCardNhcStormReportItem(
                        uiv.stackView,
                        objectNhcStormDetails,
                        UITapGestureRecognizerWithData(index, self, #selector(gotoAtlNhcStorm(sender:)))
                    )
                }
            }
        }
        textPac = ""
        if self.pacSumList.count < 1 {
            textPac += "There are no tropical cyclones in the Eastern Pacific at this time."
        } else {
            self.pacSumList.indices.forEach { index in
                if pacImg1List[index] != "" {
                    let objectNhcStormDetails = ObjectNhcStormDetails(self.pacSumList[index], self.pacImg1List[index])
                    pacStormDataList.append(objectNhcStormDetails)
                    _ = ObjectCardNhcStormReportItem(
                        uiv.stackView,
                        objectNhcStormDetails,
                        UITapGestureRecognizerWithData(index, self, #selector(gotoEpacNhcStorm(sender:)))
                    )
                }
            }
        }
        if textAtl != "" { _ = ObjectTextView(uiv.stackView, textAtl) }
        if textPac != "" { _ = ObjectTextView(uiv.stackView, textPac) }
    }
    
    func showImageData(_ region: NhcOceanEnum) {
        regionMap[region]!.bitmaps.enumerated().forEach { index, bitmap in
            if imageCount % imagesPerRow == 0 {
                let stackView = ObjectStackView(UIStackView.Distribution.fillEqually, NSLayoutConstraint.Axis.horizontal)
                imageStackViewList.append(stackView)
                uiv.stackView.addArrangedSubview(stackView.view)
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
        Route.nhcStorm(uiv, pacStormDataList[sender.data])
    }
    
    @objc func gotoAtlNhcStorm(sender: UITapGestureRecognizerWithData) {
        Route.nhcStorm(uiv, atlStormDataList[sender.data])
    }
}
