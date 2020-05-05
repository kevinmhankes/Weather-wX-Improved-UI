/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class UtilityActions {
    
    static func cloudClicked(_ uiv: UIViewController) {
        if Location.isUS {
            Route.vis(uiv)
        } else {
            Route.visCanada(uiv)
        }
    }
    
    static func radarClicked(_ uiv: UIViewController) {
        if !Location.isUS {
            Route.radarCanada(uiv)
        } else {
            if UIPreferences.dualpaneRadarIcon { Route.radar(uiv, "2") } else { Route.radar(uiv, "1") }
        }
    }
    
    static func wfotextClicked(_ uiv: UIViewController) {
        if Location.isUS {
            uiv.goToVC(vcWfoText())
        } else {
            uiv.goToVC(vcCanadaText())
        }
    }
    
    static func dashClicked(_ uiv: UIViewController) {
        if Location.isUS {
            uiv.goToVC(vcSevereDashboard())
        } else {
            uiv.goToVC(vcCanadaWarnings())
        }
    }
    
    static func menuItemClicked(_ uiv: UIViewController, _ menuItem: String, _ button: ObjectToolbarIcon) {
        switch menuItem {
        case "Soundings":
            uiv.goToVC(vcSoundings())
        case "Hourly Forecast":
            if Location.isUS {
                uiv.goToVC(vcHourly())
            } else {
                uiv.goToVC(vcCanadaHourly())
            }
        case "Settings":
            uiv.goToVC(vcSettingsMain())
        case "Observations":
            uiv.goToVC(vcObservations())
        case "PlayList":
            uiv.goToVC(vcPlayList())
        case "Radar Mosaic":
            Route.radarMosaicLocal(uiv)
        case "Canadian Alerts":
            uiv.goToVC(vcCanadaWarnings())
        case "US Alerts":
            uiv.goToVC(vcUSAlerts())
        case "Spotters":
            uiv.goToVC(vcSpotters())
        default:
            uiv.goToVC(vcHourly())
        }
    }
    
    static func goToVc(_ uiv: UIViewController, _ target: UIViewController) {
        target.modalPresentationStyle = .fullScreen
        uiv.present(target, animated: UIPreferences.backButtonAnimation, completion: nil)
    }
    
    static func showHelp(_ token: String, _ uiv: UIViewController, _ menuButton: ObjectToolbarIcon) {
        let alert = UIAlertController(
            title: UtilityHelp.helpStrings[token],
            message: "",
            preferredStyle: UIAlertController.Style.actionSheet
        )
        alert.addAction(UIAlertAction(title: "", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
        if let popoverController = alert.popoverPresentationController {
            popoverController.barButtonItem = menuButton
        }
        uiv.present(alert, animated: true, completion: nil)
    }
    
    static func menuClicked(_ uiv: UIViewController, _ button: ObjectToolbarIcon) {
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
        let alert = UIAlertController(
            title: "Select from:",
            message: "",
            preferredStyle: UIAlertController.Style.actionSheet
        )
        alert.view.tintColor = ColorCompatibility.label
        menuList.forEach { item in
            let action = UIAlertAction(title: item, style: .default, handler: {_ in menuItemClicked(uiv, item, button)})
            if let popoverController = alert.popoverPresentationController { popoverController.barButtonItem = button }
            alert.addAction(action)
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        uiv.present(alert, animated: true, completion: nil)
    }
}
