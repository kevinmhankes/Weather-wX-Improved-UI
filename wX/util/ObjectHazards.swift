/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectHazards {

    private var hazardsShort = ""
    var hazards = ""
    private static var uiv: UIViewController?

    convenience init(_ uiv: UIViewController, _ locNum: Int) {
        self.init(uiv, Location.getLatLon(locNum))
    }

    // US by LAT LON (used in adhoc location and other init)
    convenience init(_ uiv: UIViewController, _ location: LatLon) {
        self.init()
        let homescreenFav = TextUtils.split(Utility.readPref("HOMESCREEN_FAV", GlobalVariables.homescreenFavDefault), ":")
        if homescreenFav.contains("TXT-HAZ") {
            hazards = getHazardsHtml(location)
        }
        ObjectHazards.uiv = uiv
    }

    func getHazardsHtml(_ location: LatLon) -> String {
        let newLocation = UtilityMath.latLonFix(location)
        let html = ("https://api.weather.gov/alerts?point=" + newLocation.latString + "," + newLocation.lonString + "&active=1").getNwsHtml()
        return html
    }

    static var isUS = true

    // CA
    static func createForCanada(_ html: String) -> ObjectHazards {
        let objectForecastPackageHazards = ObjectHazards()
        let hazards = UtilityCanada.getHazards(html)
        objectForecastPackageHazards.hazardsShort = hazards[0]
        objectForecastPackageHazards.hazards = hazards[1]
        return objectForecastPackageHazards
    }

    static func getHazardCount(_ objectHazards: ObjectHazards) -> Int {
        objectHazards.hazards.parseColumn("\"event\": \"(.*?)\"").count
    }

    static func getHazardCards(_ stackView: ObjectStackView, _ objectHazards: ObjectHazards, _ isUS: Bool = true) {
        self.isUS = isUS
        var numHaz = 0
        let stackViewLocalHaz = ObjectStackViewHS()
        stackViewLocalHaz.setupWithPadding()
        if !isUS {
            let hazard = objectHazards.hazardsShort.replace("<BR>", "")
            _ = ObjectCardHazard(
                stackViewLocalHaz,
                hazard,
                GestureData(objectHazards.hazards, self, #selector(hazardsAction(sender:)))
            )
            numHaz += 1
        } else {
            let ids = objectHazards.hazards.parseColumn("\"id\": \"(http.*?)\"")
            let hazardTitles = objectHazards.hazards.parseColumn("\"event\": \"(.*?)\"")
            hazardTitles.enumerated().forEach { index, hazard in
                _ = ObjectCardHazard(
                    stackViewLocalHaz,
                    hazard,
                    GestureData(ids[index], self, #selector(hazardsAction(sender:)))
                )
                numHaz += 1
            }
        }
        if numHaz > 0 {
            stackView.addWidget(stackViewLocalHaz.get())
        }
    }

    @objc static func hazardsAction(sender: GestureData) {
        if isUS {
            Route.alertDetail(uiv!, sender.strData)
        } else {
            Route.textViewer(uiv!, sender.strData)
        }
    }
}
