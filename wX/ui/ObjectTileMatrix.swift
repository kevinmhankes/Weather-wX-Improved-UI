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
        //var token = ""
        let iconTitle = icons[sender.view!.tag]
        switch iconTitle {
        case "spcsref":
            //token = "modelgeneric"
            ActVars.modelActivitySelected = "SPCSREF"
            let vc = vcModels()
            uiv!.goToVC(vc)
        case "spc_sum":
            //token = "spcswosummary"
            let vc = vcSpcSwoSummary()
            uiv!.goToVC(vc)
        case "day1":
            ActVars.spcswoDay = "1"
            //token = "spcswo"
            let vc = vcSpcSwo()
            uiv!.goToVC(vc)
        case "day2":
            ActVars.spcswoDay = "2"
            //token = "spcswo"
            let vc = vcSpcSwo()
            uiv!.goToVC(vc)
        case "day3":
            ActVars.spcswoDay = "3"
            //token = "spcswo"
            let vc = vcSpcSwo()
            uiv!.goToVC(vc)
        case "day48":
            ActVars.spcswoDay = "48"
            //token = "spcswo"
            let vc = vcSpcSwo()
            uiv!.goToVC(vc)
        case "report_today":
            ActVars.spcStormReportsDay = "today"
            //token = "spcstormreports"
            let vc = vcSpcStormReports()
            uiv!.goToVC(vc)
        case "report_yesterday":
            ActVars.spcStormReportsDay = "yesterday"
            //token = "spcstormreports"
            let vc = vcSpcStormReports()
            uiv!.goToVC(vc)
        case "mcd_tile":
            //token="spcwatchmcdmpd"
            ActVars.watchMcdMpdType = .MCD
            let vc = vcSpcWatchMcdMpd()
            uiv!.goToVC(vc)
        case "wat":
            //token="spcwat"
            ActVars.watchMcdMpdType = .WATCH
            let vc = vcSpcWatchMcdMpd()
            uiv!.goToVC(vc)
        case "meso":
            //token="spcmeso"
            let vc = vcSpcMeso()
            uiv!.goToVC(vc)
        case "fire_outlook":
            //token="spcfiresummary"
            let vc = vcSpcFireSummary()
            uiv!.goToVC(vc)
        case "tstorm":
            //token="spctstsummary"
            let vc = vcSpcTstormSummary()
            uiv!.goToVC(vc)
        case "spccompmap":
            //token="spccompmap"
            let vc = vcSpcCompMap()
            uiv!.goToVC(vc)
        case "spchrrr":
            //token = "modelgeneric"
            ActVars.modelActivitySelected = "SPCHRRR"
            let vc = vcModels()
            uiv!.goToVC(vc)
        case "spchref":
            //token = "modelgeneric"
            ActVars.modelActivitySelected = "SPCHREF"
            let vc = vcModels()
            uiv!.goToVC(vc)
        case "spcsseo":
            //token = "modelgeneric"
            ActVars.modelActivitySelected = "SPCSSEO"
            let vc = vcModels()
            uiv!.goToVC(vc)
        default:
            //token = "spcswo"
            let vc = vcSpcSwo()
            uiv!.goToVC(vc)
        }
        /*if !MyApplication.helpMode {
            uiv!.goToVC(token)
        } else {
            UtilityActions.showHelp(token, uiv!, menuButton)
        }*/
    }

    @objc func imgClickedMisc(sender: UITapGestureRecognizer) {
        //var token = ""
        let iconTitle = icons[sender.view!.tag]
        switch iconTitle {
        case "ncep":
            //token = "modelgeneric"
            ActVars.modelActivitySelected = "NCEP"
            let vc = vcModels()
            uiv!.goToVC(vc)
        case "hrrrviewer":
            //token = "modelgeneric"
            ActVars.modelActivitySelected = "ESRL"
            let vc = vcModels()
            uiv!.goToVC(vc)
        case "uswarn":
            //token = "usalerts"
            let vc = vcUSAlerts()
            uiv!.goToVC(vc)
        case "goes":
            let vc = vcGoes()
            vc.productCode = "09"
            vc.sectorCode = "CONUS"
            uiv!.goToVC(vc)
        case "srfd":
            //token = "WPCText"
            let vc = vcWpcText()
            uiv!.goToVC(vc)
        case "fmap":
            //token = "wpcimg"
            let vc = vcWpcImg()
            uiv!.goToVC(vc)
        case "nhc":
            //token = "nhc"
            let vc = vcNhc()
            uiv!.goToVC(vc)
        case "nws_sector":
            if !UIPreferences.useAwcRadarMosaic {
                //token = "nwsmosaic"
                let vc = vcRadarMosaic()
                uiv!.goToVC(vc)
            } else {
                //token = "awcradarmosaic"
                let vc = vcRadarMosaicAwc()
                uiv!.goToVC(vc)
            }
            //uiv!.goToVC(token)
        case "opc":
            //token = "opc"
            let vc = vcOpc()
            uiv!.goToVC(vc)
        case "goesfulldisk":
            //token = "goesglobal"
            let vc = vcGoesGlobal()
            uiv!.goToVC(vc)
        case "nwsobs":
            //token = "obssites"
            let vc = vcObsSites()
            uiv!.goToVC(vc)
        case "wxogldualpane":
            ActVars.wxoglPaneCount = "2"
            //token = "wxmetalradar"
            let vc = vcNexradRadar()
            uiv!.goToVC(vc)
        case "wxoglquadpane":
            ActVars.wxoglPaneCount = "4"
            //token = "wxmetalradar"
            let vc = vcNexradRadar()
            uiv!.goToVC(vc)
        case "nsslwrf":
            //token = "modelgeneric"
            ActVars.modelActivitySelected = "NSSLWRF"
            let vc = vcModels()
            uiv!.goToVC(vc)
        case "lightning":
            //token = "lightning"
            let vc = vcLightning()
            uiv!.goToVC(vc)
        case "wpc_rainfall":
            //token = "wpcrainfallsummary"
            let vc = vcWpcRainfallSummary()
            uiv!.goToVC(vc)
        case "ncar_ensemble":
            //token = "modelgeneric"
            ActVars.modelActivitySelected = "NCAR_ENSEMBLE"
            let vc = vcModels()
            uiv!.goToVC(vc)
        case "wpcgefs":
            //token = "modelgeneric"
            ActVars.modelActivitySelected = "WPCGEFS"
            let vc = vcModels()
            uiv!.goToVC(vc)
        case "twstate":
            ActVars.webViewUrl = ""
            ActVars.webViewStateCode = Location.state
            //token = "webview"
            let vc = vcWebView()
            uiv!.goToVC(vc)
        case "twtornado":
            ActVars.webViewUrl = ""
            ActVars.webViewStateCode = "tornado"
            //token = "webview"
            let vc = vcWebView()
            uiv!.goToVC(vc)
        default:  break
        }
        /*if !MyApplication.helpMode {
            uiv!.goToVC(token)
        } else {
            UtilityActions.showHelp(token, uiv!, menuButton)
        }*/
    }

    @objc func multiPaneRadarClicked(_ paneCount: String) {
        //var token = ""
        switch paneCount {
        case "2":
            ActVars.wxoglPaneCount = "2"
            //token = "wxmetalradar"
        case "4":
            ActVars.wxoglPaneCount = "4"
            //token = "wxmetalradar"
        default: break
        }
        let vc = vcNexradRadar()
        uiv!.goToVC(vc)
        //UtilityActions.goToVCS(uiv!, token)
    }

    @objc func genericClicked(_ vc: UIViewController) {
        UtilityActions.goToVCS(uiv!, vc)
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
