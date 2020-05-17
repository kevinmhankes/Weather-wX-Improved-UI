/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectNhc: NSObject {
    
    private var atlSumList = [String]()
    private var atlImg1List = [String]()
    //private var atlStormDataList = [ObjectNhcStormDetails]()
    private var pacSumList = [String]()
    private var pacImg1List = [String]()
    //private var pacStormDataList = [ObjectNhcStormDetails]()
    private var stormDataList = [ObjectNhcStormDetails]()
    private let uiv: UIwXViewController
    private var textAtl = ""
    private var textPac = ""
    private var imageCount = 0
    private var imagesPerRow = 2
    private var imageStackViewList = [ObjectStackView]()
    var ids = [String]()
    var binNumbers = [String]()
    var names = [String]()
    var classifications = [String]()
    var intensities = [String]()
    var pressures = [String]()
    var latitudes = [String]()
    var longitudes = [String]()
    var movementDirs = [String]()
    var movementSpeeds = [String]()
    var lastUpdates = [String]()
    var statusList = [String]()
    var regionMap = [NhcOceanEnum: ObjectNhcRegionSummary]()
    
    init(_ uiv: UIwXViewController) {
        self.uiv = uiv
        if UtilityUI.isTablet() { imagesPerRow = 3 }
        super.init()
        NhcOceanEnum.allCases.forEach { regionMap[$0] = ObjectNhcRegionSummary($0) }
    }
    
    func getTextData() {
        statusList = []
        let url = MyApplication.nwsNhcWebsitePrefix + "/CurrentStorms.json"
        //final url = "https://www.nhc.noaa.gov/productexamples/NHC_JSON_Sample.json"
        let html = url.getHtml()
        ids = html.parseColumn("\"id\": \"(.*?)\"")
        binNumbers = html.parseColumn("\"binNumber\": \"(.*?)\"")
        names = html.parseColumn("\"name\": \"(.*?)\"")
        classifications = html.parseColumn("\"classification\": \"(.*?)\"")
        intensities = html.parseColumn("\"intensity\": \"(.*?)\"")
        pressures = html.parseColumn("\"pressure\": \"(.*?)\"")
        // sample data not quoted for these two
        //intensities = html.parseColumn("\"intensity\": (.*?),");
        //pressures = html.parseColumn("\"pressure\": (.*?),");
        //
        latitudes = html.parseColumn("\"latitude\": \"(.*?)\"")
        longitudes = html.parseColumn("\"longitude\": \"(.*?)\"")
        movementDirs = html.parseColumn("\"movementDir\": (.*?),")
        movementSpeeds = html.parseColumn("\"movementSpeed\": (.*?),")
        lastUpdates = html.parseColumn("\"lastUpdate\": \"(.*?)\"")
        binNumbers.forEach {
            let text = UtilityDownload.getTextProduct("MIATCP" + $0)
            let status = text.parseFirst("(\\.\\.\\..*?\\.\\.\\.)")
            statusList.append(status)
        }
    }
    
    func showTextData() {
        if ids.count > 0 {
            ids.enumerated().forEach { index, _ in
                let objectNhcStormDetails = ObjectNhcStormDetails(
                    names[index],
                    movementDirs[index],
                    movementSpeeds[index],
                    pressures[index],
                    binNumbers[index],
                    ids[index],
                    lastUpdates[index],
                    classifications[index],
                    latitudes[index],
                    longitudes[index],
                    intensities[index],
                    statusList[index]
                )
                stormDataList.append(objectNhcStormDetails)
                _ = ObjectCardNhcStormReportItem(
                    uiv.stackView,
                    objectNhcStormDetails,
                    UITapGestureRecognizerWithData(index, self, #selector(gotoNhcStorm(sender:))))
            }
        }
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
    
    //@objc func gotoEpacNhcStorm(sender: UITapGestureRecognizerWithData) {
    //    Route.nhcStorm(uiv, pacStormDataList[sender.data])
    //}
    
    @objc func gotoNhcStorm(sender: UITapGestureRecognizerWithData) {
        Route.nhcStorm(uiv, stormDataList[sender.data])
    }
}
