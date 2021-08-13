// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class ObjectTileMatrix: NSObject {

    private var uiv: UIViewController?
    private var menuButton = ToolbarIcon()
    private var tabType: TabType = .spc
    private var icons = [String]()
    private var labels = [String]()
    var toolbar = ObjectToolbar()

    convenience init(_ uiv: UIViewController, _ stackView: ObjectStackView, _ tabType: TabType) {
        self.init()
        self.uiv = uiv
        self.tabType = tabType
        toolbar = ObjectToolbar()
        let radarButton = ToolbarIcon(uiv, .radar, #selector(radarClicked))
        let cloudButton = ToolbarIcon(uiv, .cloud, #selector(cloudClicked))
        let wfoTextButton = ToolbarIcon(uiv, .wfo, #selector(wfotextClicked))
        menuButton = ToolbarIcon(uiv, .submenu, #selector(menuClicked))
        let dashButton = ToolbarIcon(uiv, .severeDashboard, #selector(dashClicked))
        let fixedSpace = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace,
            target: nil,
            action: nil
        )
        fixedSpace.width = UIPreferences.toolbarIconSpacing
        if UIPreferences.mainScreenRadarFab {
            toolbar.items = ToolbarItems([
                GlobalVariables.flexBarButton,
                dashButton,
                wfoTextButton,
                cloudButton,
                menuButton
            ]).items
        } else {
            toolbar.items = ToolbarItems([
                GlobalVariables.flexBarButton,
                dashButton,
                wfoTextButton,
                cloudButton,
                radarButton,
                menuButton
            ]).items
        }
        uiv.view.addSubview(toolbar)
        toolbar.setConfigWithUiv(uiv: uiv, toolbarType: .top)
        let rowCount = UIPreferences.tilesPerRow
        let iconsPerRow = CGFloat(rowCount)
        switch tabType {
        case .spc:
            icons = iconsSpc
            labels = labelsSpc
        case .misc:
            icons = iconsMisc
            labels = labelsMisc
        }
        var jIndex = 0
        while true {
            let sV = ObjectStackView(.fill, .horizontal, spacing: UIPreferences.stackviewCardSpacing)
            var index = 0
            for _ in (0...(rowCount - 1)) {
                if jIndex >= icons.count {
                    _ = ObjectTileImage(sV, iconsPerRow)
                } else {
                    let tile = ObjectTileImage(sV, icons[jIndex], jIndex, iconsPerRow, labels[jIndex])
                    switch tabType {
                    case .spc:
                        tile.addGesture(UITapGestureRecognizer(target: self, action: #selector(imgClickedSpc(sender:))))
                    case .misc:
                        tile.addGesture(UITapGestureRecognizer(target: self, action: #selector(imgClickedMisc(sender:))))
                    }
                }
                index += 1
                jIndex += 1
            }
            stackView.addLayout(sV)
            if jIndex >= icons.count {
                break
            }
        }
    }

    @objc func imgClicked(sender: UITapGestureRecognizer) {
        switch tabType {
        case .spc:
            imgClickedSpc(sender: sender)
        case .misc:
            imgClickedMisc(sender: sender)
        }
    }

    @objc func imgClickedSpc(sender: UITapGestureRecognizer) {
        let iconTitle = icons[sender.view!.tag]
        switch iconTitle {
        case "spcsref":
            Route.model(uiv!, "SPCSREF")
        case "spc_sum":
            uiv!.goToVC(vcSpcSwoSummary())
        case "day1":
            Route.swo(uiv!, "1")
        case "day2":
            Route.swo(uiv!, "2")
        case "day3":
            Route.swo(uiv!, "3")
        case "day48":
            Route.swo(uiv!, "48")
        case "report_today":
            Route.spcStormReports(uiv!, "today")
        case "report_yesterday":
            Route.spcStormReports(uiv!, "yesterday")
        case "mcd_tile":
            Route.spcMcdWatchSummary(uiv!, .SPCMCD)
        case "wat":
            Route.spcMcdWatchSummary(uiv!, .SPCWAT)
        case "meso":
            Route.spcMeso(uiv!)
        case "fire_outlook":
            Route.spcFireSummary(uiv!)
        case "tstorm":
            Route.spcTstormSummary(uiv!)
        case "spccompmap":
            Route.spcCompMap(uiv!)
        case "spchrrr":
            Route.model(uiv!, "SPCHRRR")
        case "spchref":
            Route.model(uiv!, "SPCHREF")
        default:
            uiv!.goToVC(vcSpcSwo())
        }
    }

    @objc func imgClickedMisc(sender: UITapGestureRecognizer) {
        let iconTitle = icons[sender.view!.tag]
        switch iconTitle {
        case "ncep":
            Route.model(uiv!, "NCEP")
        case "hrrrviewer":
            Route.model(uiv!, "ESRL")
        case "uswarn":
            Route.alerts(uiv!)
        case "goes":
            Route.goesWaterVapor(uiv!)
        case "srfd":
            Route.wpcText(uiv!)
        case "fmap":
            Route.wpcImage(uiv!)
        case "nhc":
            Route.nhc(uiv!)
        case "nws_sector":
            Route.radarMosaic(uiv!)
        case "opc":
            Route.opc(uiv!)
        case "goesfulldisk":
            Route.goesGlobal(uiv!)
        case "nwsobs":
            Route.obsSites(uiv!)
        case "wxogldualpane":
            Route.radar(uiv!, "2")
        case "wxoglquadpane":
            Route.radar(uiv!, "4")
        case "nsslwrf":
            Route.model(uiv!, "NSSLWRF")
        case "lightning":
            Route.lightning(uiv!)
        case "wpc_rainfall":
            Route.wpcRainfallSummary(uiv!)
        case "ncar_ensemble":
            Route.model(uiv!, "NCAR_ENSEMBLE")
        case "wpcgefs":
            Route.model(uiv!, "WPCGEFS")
        case "twstate":
            Route.webTwitter(uiv!, Location.state)
        case "twtornado":
            Route.webTwitter(uiv!, "tornado")
        default:
            break
        }
    }

    @objc func genericClicked(_ vc: UIViewController) {
        uiv!.goToVC(vc)
    }

    @objc func cloudClicked() {
        Route.cloud(uiv!)
    }

    @objc func radarClicked() {
        Route.radarFromMainScreen(uiv!)
    }

    @objc func wfotextClicked() {
        Route.wfoText(uiv!)
    }

    @objc func menuClicked() {
        UtilityActions.menuClicked(uiv!, menuButton)
    }

    @objc func dashClicked() {
        Route.severeDashboard(uiv!)
    }

    var iconsSpc = [
        "spcsref",
        "meso",
        "spchrrr",
        "spchref",
        "spccompmap",
        "spc_sum",
        "day1",
        "day2",
        "day3",
        "day48",
        "report_today",
        "report_yesterday",
        "mcd_tile",
        "wat",
        "fire_outlook",
        "tstorm"
    ]

    var labelsSpc = [
        "SREF",
        "Mesoanalysis",
        "HRRR",
        "HREF",
        "Compmap",
        "Convective Summary by Image",
        "Day 1",
        "Day 2",
        "Day 3",
        "Day 4 through 8",
        "Storm reports today",
        "Storm reports yesterday",
        "MCD",
        "Watches",
        "Fire outlooks",
        "Thunderstorm outlooks"
    ]

    var iconsMisc = [
        "ncep",
        "hrrrviewer",
        "nsslwrf",
        "wpcgefs",
        "wxogldualpane",
        "wxoglquadpane",
        "uswarn",
        "srfd",
        "nhc",
        "nws_sector",
        "goes",
        "fmap",
        "twstate",
        "twtornado",
        "nwsobs",
        "opc",
        "goesfulldisk",
        "lightning",
        "wpc_rainfall"
    ]

    var labelsMisc = [
        "NCEP Models",
        "HRRR",
        "NSSL WRF",
        "WPC GEFS",
        "Dual pane nexrad radar",
        "Quad pane nexrad radar",
        "US Warnings",
        "National text products",
        "NHC",
        "nws_sector",
        "GOES",
        "National Images",
        "Twitter state",
        "Twitter tornado",
        "Observation sites",
        "OPC",
        "GOES Full Disk",
        "Lightning",
        "WPC Excessive Rainfall Outlook"
    ]
}
