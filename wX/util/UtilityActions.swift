/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class UtilityActions {

    static func menuItemClicked(_ uiv: UIViewController, _ menuItem: String) {
        switch menuItem {
        case "Soundings":
            Route.soundings(uiv)
        case "Hourly Forecast":
            Route.hourly(uiv)
        case "Settings":
            Route.settings(uiv)
        case "Observations":
            Route.observations(uiv)
        case "PlayList":
            Route.playList(uiv)
        case "Radar Mosaic":
            Route.radarMosaicLocal(uiv)
        case "Canadian Alerts":
            Route.alerts(uiv)
        case "US Alerts":
            Route.alerts(uiv)
        default:
            Route.hourly(uiv)
        }
    }

    static func menuClicked(_ uiv: UIViewController, _ button: ToolbarIcon) {
        // items in the list below need to match items in menuItemClicked's switch
        var menuList = [
            "Hourly Forecast",
            "Radar Mosaic",
            "US Alerts",
            "Observations",
            "Soundings",
            "PlayList",
            "Settings"
        ]
        if !Location.isUS {
            menuList = [
                "Hourly Forecast",
                "Radar Mosaic",
                "Canadian Alerts",
                "Observations",
                "Soundings",
                "PlayList",
                "Settings"
            ]
        }
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        alert.view.tintColor = ColorCompatibility.label
        menuList.forEach { item in
            let action = UIAlertAction(title: item, style: .default, handler: { _ in menuItemClicked(uiv, item) })
            if let popoverController = alert.popoverPresentationController {
                popoverController.barButtonItem = button
            }
            alert.addAction(action)
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        uiv.present(alert, animated: true, completion: nil)
    }
}
