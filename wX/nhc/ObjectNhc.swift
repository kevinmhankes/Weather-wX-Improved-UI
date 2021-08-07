// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class ObjectNhc: NSObject {

    var stormDataList = [ObjectNhcStormDetails]()
    private let uiv: UIwXViewController
    private var ids = [String]()
    private var binNumbers = [String]()
    private var names = [String]()
    private var classifications = [String]()
    private var intensities = [String]()
    private var pressures = [String]()
    private var latitudes = [String]()
    private var longitudes = [String]()
    private var movementDirs = [String]()
    private var movementSpeeds = [String]()
    private var lastUpdates = [String]()
    private var statusList = [String]()
    private var urls = [String]()
    private var stormPrefixList = [String]()
    var regionMap = [NhcOceanEnum: ObjectNhcRegionSummary]()

    init(_ uiv: UIwXViewController) {
        self.uiv = uiv
        super.init()
        NhcOceanEnum.allCases.forEach {
            regionMap[$0] = ObjectNhcRegionSummary($0)
        }
    }

    func getTextData() {
        statusList.removeAll()
        stormDataList.removeAll()
        let url = GlobalVariables.nwsNhcWebsitePrefix + "/CurrentStorms.json"
        // let url = "https://www.nhc.noaa.gov/productexamples/NHC_JSON_Sample.json"
        let html = url.getHtml()
        ids = html.parseColumn("\"id\": \"(.*?)\"")
        binNumbers = html.parseColumn("\"binNumber\": \"(.*?)\"")
        names = html.parseColumn("\"name\": \"(.*?)\"")
        classifications = html.parseColumn("\"classification\": \"(.*?)\"")
        intensities = html.parseColumn("\"intensity\": \"(.*?)\"")
        pressures = html.parseColumn("\"pressure\": \"(.*?)\"")
        urls = html.parseColumn("\"url\": \"(.*?)\"")
        // sample data not quoted for these two
        // intensities = html.parseColumn("\"intensity\": (.*?),");
        // pressures = html.parseColumn("\"pressure\": (.*?),");
        //
        latitudes = html.parseColumn("\"latitude\": \"(.*?)\"")
        longitudes = html.parseColumn("\"longitude\": \"(.*?)\"")
        movementDirs = html.parseColumn("\"movementDir\": (.*?),")
        movementSpeeds = html.parseColumn("\"movementSpeed\": (.*?),")
        lastUpdates = html.parseColumn("\"lastUpdate\": \"(.*?)\"")
        
        let forecastDiscussions = html.parseColumn("\"forecastDiscussion\": \\{(.*?)\\}")
        forecastDiscussions.forEach {
            var nhcPrefix = "MIATCP"
            if $0.contains("/HFOTCD") {
                nhcPrefix = "HFOTCP"
            }
            print("http " + nhcPrefix + $0)
            stormPrefixList.append(nhcPrefix)
        }
//        var nhcPrefix = "MIATCP"
//        if forecastDiscussions.count > 0 {
//            if urls.first!.contains("/HFOTCP") {
//                nhcPrefix = "HFOTCP"
//            }
//        }
        
        binNumbers.enumerated().forEach { index, number in
            // let text = UtilityDownload.getTextProduct(nhcPrefix + number)
            let text = UtilityDownload.getTextProduct(stormPrefixList[index] + number)
            let status = text.parseFirst("(\\.\\.\\..*?\\.\\.\\.)")
            statusList.append(status)
        }
    }
    
//    "forecastDiscussion": {
//                    "advNum": "017",
//                    "issuance": "2021-08-07T03:00:00.000Z",
//                    "url": "https://www.nhc.noaa.gov/text/HFOTCDCP2.shtml"
//                },

    func showTextData() {
        if ids.count > 0 {
            ids.indices.forEach { index in
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
                    statusList[index],
                    stormPrefixList[index]
                )
                stormDataList.append(objectNhcStormDetails)
            }
        }
    }

    @objc func imageClicked(sender: GestureData) {}

    @objc func gotoNhcStorm(sender: GestureData) {
        Route.nhcStorm(uiv, stormDataList[sender.data])
    }
}
