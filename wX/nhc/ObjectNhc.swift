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
        // sample data not quoted for these two
        // intensities = html.parseColumn("\"intensity\": (.*?),");
        // pressures = html.parseColumn("\"pressure\": (.*?),");
        //
        latitudes = html.parseColumn("\"latitude\": \"(.*?)\"")
        longitudes = html.parseColumn("\"longitude\": \"(.*?)\"")
        movementDirs = html.parseColumn("\"movementDir\": (.*?),")
        movementSpeeds = html.parseColumn("\"movementSpeed\": (.*?),")
        lastUpdates = html.parseColumn("\"lastUpdate\": \"(.*?)\"")
        binNumbers.forEach { number in
            let text = UtilityDownload.getTextProduct("MIATCP" + number)
            let status = text.parseFirst("(\\.\\.\\..*?\\.\\.\\.)")
            statusList.append(status)
        }
    }

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
                    statusList[index]
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
