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
                    _ = ObjectTileImage(sV.view, iconsPerRow)
                } else {
                    let tile = ObjectTileImage(sV.view, icons[jIndex], jIndex, iconsPerRow, labels[jIndex])
                    switch tabType {
                    case .spc:
                        tile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imgClickedSpc(sender:))))
                    case .misc:
                        tile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imgClickedMisc(sender:))))
                    }
                }
                index += 1
                jIndex += 1
            }
            stackView.addArrangedSubview(sV.view)
            if jIndex >= icons.count { break }
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
            let vc = vcModels()
            vc.modelActivitySelected = "SPCSREF"
            uiv!.goToVC(vc)
        case "spc_sum":
            let vc = vcSpcSwoSummary()
            uiv!.goToVC(vc)
        case "day1":
            let vc = vcSpcSwo()
            vc.spcSwoDay = "1"
            uiv!.goToVC(vc)
        case "day2":
            let vc = vcSpcSwo()
            vc.spcSwoDay = "2"
            uiv!.goToVC(vc)
        case "day3":
            let vc = vcSpcSwo()
            vc.spcSwoDay = "3"
            uiv!.goToVC(vc)
        case "day48":
            let vc = vcSpcSwo()
            vc.spcSwoDay = "48"
            uiv!.goToVC(vc)
        case "report_today":
            let vc = vcSpcStormReports()
            vc.spcStormReportsDay = "today"
            uiv!.goToVC(vc)
        case "report_yesterday":
            let vc = vcSpcStormReports()
            vc.spcStormReportsDay = "yesterday"
            uiv!.goToVC(vc)
        case "mcd_tile":
            let vc = vcSpcWatchMcdMpd()
            vc.watchMcdMpdType = .MCD
            uiv!.goToVC(vc)
        case "wat":
            let vc = vcSpcWatchMcdMpd()
            vc.watchMcdMpdType = .WATCH
            uiv!.goToVC(vc)
        case "meso":
            let vc = vcSpcMeso()
            uiv!.goToVC(vc)
        case "fire_outlook":
            let vc = vcSpcFireSummary()
            uiv!.goToVC(vc)
        case "tstorm":
            let vc = vcSpcTstormSummary()
            uiv!.goToVC(vc)
        case "spccompmap":
            let vc = vcSpcCompMap()
            uiv!.goToVC(vc)
        case "spchrrr":
            let vc = vcModels()
            vc.modelActivitySelected = "SPCHRRR"
            uiv!.goToVC(vc)
        case "spchref":
            let vc = vcModels()
            vc.modelActivitySelected = "SPCHREF"
            uiv!.goToVC(vc)
        default:
            let vc = vcSpcSwo()
            uiv!.goToVC(vc)
        }
    }
    
    @objc func imgClickedMisc(sender: UITapGestureRecognizer) {
        let iconTitle = icons[sender.view!.tag]
        switch iconTitle {
        case "ncep":
            let vc = vcModels()
            vc.modelActivitySelected = "NCEP"
            uiv!.goToVC(vc)
        case "hrrrviewer":
            let vc = vcModels()
            vc.modelActivitySelected = "ESRL"
            uiv!.goToVC(vc)
        case "uswarn":
            let vc = vcUSAlerts()
            uiv!.goToVC(vc)
        case "goes":
            let vc = vcGoes()
            vc.productCode = "09"
            vc.sectorCode = "CONUS"
            uiv!.goToVC(vc)
        case "srfd":
            let vc = vcWpcText()
            uiv!.goToVC(vc)
        case "fmap":
            let vc = vcWpcImg()
            uiv!.goToVC(vc)
        case "nhc":
            let vc = vcNhc()
            uiv!.goToVC(vc)
        case "nws_sector":
            if !UIPreferences.useAwcRadarMosaic {
                let vc = vcRadarMosaic()
                uiv!.goToVC(vc)
            } else {
                let vc = vcRadarMosaicAwc()
                uiv!.goToVC(vc)
            }
        case "opc":
            let vc = vcOpc()
            uiv!.goToVC(vc)
        case "goesfulldisk":
            let vc = vcGoesGlobal()
            uiv!.goToVC(vc)
        case "nwsobs":
            let vc = vcObsSites()
            uiv!.goToVC(vc)
        case "wxogldualpane":
            let vc = vcNexradRadar()
            vc.wxoglPaneCount = "2"
            uiv!.goToVC(vc)
        case "wxoglquadpane":
            let vc = vcNexradRadar()
            vc.wxoglPaneCount = "4"
            uiv!.goToVC(vc)
        case "nsslwrf":
            let vc = vcModels()
            vc.modelActivitySelected = "NSSLWRF"
            uiv!.goToVC(vc)
        case "lightning":
            let vc = vcLightning()
            uiv!.goToVC(vc)
        case "wpc_rainfall":
            let vc = vcWpcRainfallSummary()
            uiv!.goToVC(vc)
        case "ncar_ensemble":
            let vc = vcModels()
            vc.modelActivitySelected = "NCAR_ENSEMBLE"
            uiv!.goToVC(vc)
        case "wpcgefs":
            let vc = vcModels()
            vc.modelActivitySelected = "WPCGEFS"
            uiv!.goToVC(vc)
        case "twstate":
            let vc = vcWebView()
            vc.url = ""
            vc.aStateCode = Location.state
            uiv!.goToVC(vc)
        case "twtornado":
            let vc = vcWebView()
            vc.url = ""
            vc.aStateCode = "tornado"
            uiv!.goToVC(vc)
        default:
            break
        }
    }
    
    @objc func multiPaneRadarClicked(_ paneCount: String) {
        let vc = vcNexradRadar()
        switch paneCount {
        case "2":
            vc.wxoglPaneCount = "2"
        case "4":
            vc.wxoglPaneCount = "4"
        default:
            break
        }
        uiv!.goToVC(vc)
    }
    
    @objc func genericClicked(_ vc: UIViewController) {
        uiv!.goToVC(vc)
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
