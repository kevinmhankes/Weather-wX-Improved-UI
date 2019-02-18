/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
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
        let hazArr = UtilityCanada.getHazards(html)
        hazardsShort = hazArr.0
        hazards = hazArr.1
    }

    func getHazardsHtml(_ location: LatLon) -> String {
        let newLocation = UtilityMath.latLonFix(location)
        return ("https://api.weather.gov/alerts?point=" + newLocation.latString + ","
            + newLocation.lonString + "&active=1").getNwsHtml()
    }

    static var isUS = true

    // CA
    static func createForCanada(_ html: String) -> ObjectForecastPackageHazards {
        let obj = ObjectForecastPackageHazards()
        let hazArr = UtilityCanada.getHazards(html)
        obj.hazardsShort = hazArr.0
        obj.hazards = hazArr.1
        return obj
    }

    static func getHazardCount(_ objHazards: ObjectForecastPackageHazards) -> Int {
        var numHaz = 0
        let hazardTitles = objHazards.hazards.parseColumn("\"event\": \"(.*?)\"")
        // TODO fix this
        hazardTitles.enumerated().forEach { _, _ in
            numHaz += 1
        }
        return numHaz
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
            var idAl = objHazards.hazards.parseColumn("\"id\": \"(http.*?)\"")
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
            ActVars.usalertsDetailUrl = sender.strData
            ActVars.vc.goToVC("usalertsdetail")
        } else {
            ActVars.textViewText = sender.strData
            ActVars.vc.goToVC("textviewer")
        }
    }
}
