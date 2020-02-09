/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectTileMatrix: NSObject {

    private var uiv: UIViewController?
    private var menuButton = ObjectToolbarIcon()
    private var tabType: TabType = .spc
    private var icons = [String]()
    private var labels = [String]()
    var toolbar = ObjectToolbar()

    convenience init(_ uiv: UIViewController, _ stackView: UIStackView, _ tabType: TabType) {
        self.init()
        self.uiv = uiv
        self.tabType = tabType
        toolbar = ObjectToolbar(.top)
        let radarButton = ObjectToolbarIcon(uiv, .radar, #selector(radarClicked))
        let cloudButton = ObjectToolbarIcon(uiv, .cloud, #selector(cloudClicked))
        let wfoTextButton = ObjectToolbarIcon(uiv, .wfo, #selector(wfotextClicked))
        self.menuButton = ObjectToolbarIcon(uiv, .submenu, #selector(menuClicked))
        let dashButton = ObjectToolbarIcon(uiv, .severeDashboard, #selector(dashClicked))
        let fixedSpace = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace,
            target: nil,
            action: nil
        )
        fixedSpace.width = UIPreferences.toolbarIconSpacing
        if UIPreferences.mainScreenRadarFab {
            toolbar.items = ObjectToolbarItems(
                [
                    GlobalVariables.flexBarButton,
                    dashButton,
                    wfoTextButton,
                    cloudButton,
                    menuButton
                ]
            ).items
        } else {
            toolbar.items = ObjectToolbarItems(
                [
                    GlobalVariables.flexBarButton,
                    dashButton,
                    wfoTextButton,
                    cloudButton,
                    radarButton,
                    menuButton
                ]
            ).items
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
                    break
                }
                let tile = ObjectTileImage(sV.view, icons[jIndex], jIndex, iconsPerRow, labels[jIndex])
                switch tabType {
                case .spc:
                    tile.addGestureRecognizer(
                        UITapGestureRecognizer(
                            target: self,
                            action: #selector(imgClickedSpc(sender:))
                        )
                    )
                case .misc:
                    tile.addGestureRecognizer(
                        UITapGestureRecognizer(
                            target: self,
                            action: #selector(imgClickedMisc(sender:))
                        )
                    )
                }
                index += 1
                jIndex += 1
            }
            stackView.addArrangedSubview(sV.view)
            if jIndex >= icons.count {
                break
            }
        }
    }

    @objc func imgClicked(sender: UITapGestureRecognizer) {
        switch tabType {
        case .spc:    imgClickedSpc(sender: sender)
        case .misc:   imgClickedMisc(sender: sender)
        }
    }

    @objc func imgClickedSpc(sender: UITapGestureRecognizer) {
        var token = ""
        let iconTitle = icons[sender.view!.tag]
        switch iconTitle {
        case "spcsref":
            token = "modelgeneric"
            ActVars.modelActivitySelected = "SPCSREF"
        case "spc_sum": token = "spcswosummary"
        case "day1":
            ActVars.spcswoDay = "1"
            token = "spcswo"
        case "day2":
            ActVars.spcswoDay = "2"
            token = "spcswo"
        case "day3":
            ActVars.spcswoDay = "3"
            token = "spcswo"
        case "day48":
            ActVars.spcswoDay = "48"
            token = "spcswo"
        case "report_today":
            ActVars.spcStormReportsDay = "today"
            token = "spcstormreports"
        case "report_yesterday":
            ActVars.spcStormReportsDay = "yesterday"
            token = "spcstormreports"
        case "mcd_tile":
            token="spcwatchmcdmpd"
            ActVars.watchMcdMpdType = .MCD
        case "wat":
            token="spcwat"
            ActVars.watchMcdMpdType = .WATCH
        case "meso":         token="spcmeso"
        case "fire_outlook": token="spcfiresummary"
        case "tstorm":       token="spctstsummary"
        case "spccompmap":   token="spccompmap"
        case "spchrrr":
            token = "modelgeneric"
            ActVars.modelActivitySelected = "SPCHRRR"
        case "spchref":
            token = "modelgeneric"
            ActVars.modelActivitySelected = "SPCHREF"
        case "spcsseo":
            token = "modelgeneric"
            ActVars.modelActivitySelected = "SPCSSEO"
        default: token = "spcswo"
        }
        if !MyApplication.helpMode {
            uiv!.goToVC(token)
        } else {
            UtilityActions.showHelp(token, uiv!, menuButton)
        }
    }

    @objc func imgClickedMisc(sender: UITapGestureRecognizer) {
        var token = ""
        let iconTitle = icons[sender.view!.tag]
        switch iconTitle {
        case "ncep":
            token = "modelgeneric"
            ActVars.modelActivitySelected = "NCEP"
        case "hrrrviewer":
            token = "modelgeneric"
            ActVars.modelActivitySelected = "ESRL"
        case "uswarn": token = "usalerts"
        case "goes":
            ActVars.goesProduct = "09"
            ActVars.goesSector = "CONUS"
            token = "goes16"
        case "srfd":         token = "WPCText"
        case "fmap":         token = "wpcimg"
        case "nhc":          token = "nhc"
        case "auroralforecast":
            token = "modelgeneric"
            ActVars.modelActivitySelected = "AURORAL_FORECAST"
        case "nws_sector":
            if !UIPreferences.useAwcRadarMosaic {
                token = "nwsmosaic"
            } else {
                token = "awcradarmosaic"
            }
        case "opc":          token = "opc"
        case "goesfulldisk": token = "goesglobal"
        case "nwsobs":       token = "obssites"
        case "wxogldualpane":
            ActVars.wxoglPaneCount = "2"
            token = "wxmetalradar"
        case "wxoglquadpane":
            ActVars.wxoglPaneCount = "4"
            token = "wxmetalradar"
        case "nsslwrf":
            token = "modelgeneric"
            ActVars.modelActivitySelected = "NSSLWRF"
        case "lightning":   token = "lightning"
        case "wpc_rainfall":   token = "wpcrainfallsummary"
        case "ncar_ensemble":
            token = "modelgeneric"
            ActVars.modelActivitySelected = "NCAR_ENSEMBLE"
        case "wpcgefs":
            token = "modelgeneric"
            ActVars.modelActivitySelected = "WPCGEFS"
        case "twstate":
            ActVars.webViewUrl = ""
            ActVars.webViewStateCode = Location.state
            token = "webview"
        case "twtornado":
            ActVars.webViewUrl = ""
            ActVars.webViewStateCode = "tornado"
            token = "webview"
        default:  break
        }
        if !MyApplication.helpMode {
            uiv!.goToVC(token)
        } else {
            UtilityActions.showHelp(token, uiv!, menuButton)
        }
    }

    @objc func multiPaneRadarClicked(_ paneCount: String) {
        var token = ""
        switch paneCount {
        case "2":
            ActVars.wxoglPaneCount = "2"
            token = "wxmetalradar"
        case "4":
            ActVars.wxoglPaneCount = "4"
            token = "wxmetalradar"
        default: break
        }
        UtilityActions.goToVCS(uiv!, token)
    }

    @objc func genericClicked(_ token: String) {
        UtilityActions.goToVCS(uiv!, token)
    }

    @objc func cloudClicked() {
        UtilityActions.cloudClicked(uiv!)
    }

    @objc func radarClicked() {
        UtilityActions.radarClicked(uiv!)
    }

    @objc func wfotextClicked() {
        UtilityActions.wfotextClicked(uiv!)
    }

    @objc func menuClicked() {
        UtilityActions.menuClicked(uiv!, menuButton)
    }

    @objc func dashClicked() {
        UtilityActions.dashClicked(uiv!)
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
