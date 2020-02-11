/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectForecastPackageHazards {

    var hazardsShort = ""
    var hazards = ""

    convenience init(_ locNum: Int) {
        self.init(Location.getLatLon(locNum))
    }

    // US by LAT LON
    convenience init(_ location: LatLon) {
        self.init()
        let homescreenFav = TextUtils.split(
            Utility.readPref("HOMESCREEN_FAV", MyApplication.homescreenFavDefault),
             ":"
        )
        if homescreenFav.contains("TXT-HAZ") {
            hazards = getHazardsHtml(location)
        }
    }

    // CA
    convenience init(_ html: String) {
        self.init()
        let hazards = UtilityCanada.getHazards(html)
        hazardsShort = hazards[0]
        self.hazards = hazards[1]
    }

    func getHazardsHtml(_ location: LatLon) -> String {
        let newLocation = UtilityMath.latLonFix(location)
        return ("https://api.weather.gov/alerts?point=" + newLocation.latString + ","
            + newLocation.lonString + "&active=1").getNwsHtml()
    }

    static var isUS = true

    // CA
    static func createForCanada(_ html: String) -> ObjectForecastPackageHazards {
        let objectForecastPackageHazards = ObjectForecastPackageHazards()
        let hazards = UtilityCanada.getHazards(html)
        objectForecastPackageHazards.hazardsShort = hazards[0]
        objectForecastPackageHazards.hazards = hazards[1]
        return objectForecastPackageHazards
    }

    static func getHazardCount(_ objectForecastPackageHazards: ObjectForecastPackageHazards) -> Int {
        return objectForecastPackageHazards.hazards.parseColumn("\"event\": \"(.*?)\"").count
    }

    static func getHazardCards(
        _ stackView: UIStackView,
        _ objHazards: ObjectForecastPackageHazards,
        _ isUS: Bool = true
    ) {
        self.isUS = isUS
        var numHaz = 0
        let stackViewLocalHaz = ObjectStackViewHS()
        stackViewLocalHaz.setupWithPadding()
        if !isUS {
            let hazard = objHazards.hazardsShort.replace("<BR>", "")
            _ = ObjectCardHazard(
                stackViewLocalHaz,
                hazard,
                UITapGestureRecognizerWithData(objHazards.hazards, self, #selector(self.hazardsAction(sender:)))
            )
            numHaz += 1
        } else {
            let idAl = objHazards.hazards.parseColumn("\"id\": \"(http.*?)\"")
            let hazardTitles = objHazards.hazards.parseColumn("\"event\": \"(.*?)\"")
            hazardTitles.enumerated().forEach { index, hazard in
                _ = ObjectCardHazard(
                    stackViewLocalHaz,
                    hazard,
                    UITapGestureRecognizerWithData(idAl[index], self, #selector(self.hazardsAction(sender:)))
                )
                numHaz += 1
            }
        }
        if numHaz > 0 {
            stackView.addArrangedSubview(stackViewLocalHaz)
        }
    }

    @objc static func hazardsAction(sender: UITapGestureRecognizerWithData) {
        if isUS {
            let vc = vcUSAlertsDetail()
            vc.usalertsDetailUrl = sender.strData
            ActVars.vc.goToVC(vc)
        } else {
            let vc = vcTextViewer()
            vc.textViewText = sender.strData
            ActVars.vc.goToVC(vc)
        }
    }
}
