/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class ObjectImageTileMatrix: NSObject {

    private var uiv: UIViewController?
    private var menuButton = ObjectToolbarIcon()
    private var tabType: TabType = .spc
    private var icons = [String]()

    convenience init(_ uiv: UIViewController, _ stackView: UIStackView, _ tabType: TabType) {
        self.init()
        self.uiv = uiv
        self.tabType = tabType
        let toolbar = ObjectToolbar(.top)
        let radarButton = ObjectToolbarIcon(uiv, .radar, #selector(radarClicked))
        let cloudButton = ObjectToolbarIcon(uiv, .cloud, #selector(cloudClicked))
        let wfoTextButton = ObjectToolbarIcon(uiv, .wfo, #selector(wfotextClicked))
        self.menuButton = ObjectToolbarIcon(uiv, .submenu, #selector(menuClicked))
        let dashButton = ObjectToolbarIcon(uiv, .severeDashboard, #selector(dashClicked))
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace,
                                         target: nil,
                                         action: nil)
        fixedSpace.width = UIPreferences.toolbarIconSpacing
        toolbar.items = ObjectToolbarItems([flexBarButton,
                                            dashButton,
                                            wfoTextButton,
                                            cloudButton,
                                            radarButton,
                                            menuButton]).items
        uiv.view.addSubview(toolbar)
        let rowCount = UIPreferences.tilesPerRow
        let iconsPerRow = CGFloat(rowCount)
        switch tabType {
        case .spc: icons = iconsSpc
        case .misc: icons = iconsMisc
        }
        var jIndex = 0
        while true {
            let sV = ObjectStackView(.fill, .horizontal, UIPreferences.stackviewCardSpacing)
            var index = 0
            for _ in (0...(rowCount - 1)) {
                if jIndex >= icons.count {
                    break
                }
                let tile = ObjectTileImage(stackView, sV.view, icons[jIndex], jIndex, iconsPerRow)
                switch tabType {
                case .spc:
                    tile.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                     action: #selector(imgClickedSpc(sender:))))
                case .misc:
                    tile.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                     action: #selector(imgClickedMisc(sender:))))
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
        case "mcd_tile":     token="spcmcd"
        case "wat":          token="spcwat"
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
        case "warn": token = "usalerts"
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
        case "nws_sector":   token = "nwsmosaic"
        case "opc":          token = "opc"
        case "goesfulldisk": token = "goesglobal"
        case "nwsobs":       token = "obssites"
        case "wxogldualpane":
            ActVars.WXOGLPaneCnt = "2"
            if UIPreferences.useMetalRadar {
                token = "wxmetalradar"
            } else {
                token = "wxoglmultipane"
            }
        case "wxoglquadpane":
            ActVars.WXOGLPaneCnt = "4"
            if UIPreferences.useMetalRadar {
                token = "wxmetalradar"
            } else {
                token = "wxoglmultipane"
            }
        case "nsslwrf":
            token = "modelgeneric"
            ActVars.modelActivitySelected = "NSSLWRF"
        case "lightning":   token = "lightning"
        case "ncar_ensemble":
            token = "modelgeneric"
            ActVars.modelActivitySelected = "NCAR_ENSEMBLE"
        case "wpcgefs":
            token = "modelgeneric"
            ActVars.modelActivitySelected = "WPCGEFS"
        case "twstate":
            let stateCodeCurrent = Location.state
            let twitter_state_id = preferences.getString("STATE_TW_ID_" + stateCodeCurrent, "")
            let url = "<a class=\"twitter-timeline\" data-dnt=\"true\" href=\"https://twitter.com/search?q=%23"
                + stateCodeCurrent.lowercased()
                + "wx\" data-widget-id=\""
                + twitter_state_id
                + "\" data-chrome=\"noscrollbar noheader nofooter noborders  \" data-tweet-limit=20>Tweets about \"#"
                + stateCodeCurrent.lowercased()
                + "wx\"</a><script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http"
                + ":/.test(d.location)?'http':'https';if"
                + "(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+\"://platform.twitter.com"
                + "/widgets.js\";fjs.parentNode.insertBefore(js,fjs);}}"
                + "(document,\"script\",\"twitter-wjs\");</script>"
            ActVars.WEBVIEWurl = url
            ActVars.WEBVIEWstateCode = stateCodeCurrent
            token = "webview"
        case "twtornado":
            ActVars.WEBVIEWurl = "<html><meta name=\"viewport\" content=\"width=device-width,"
                + " user-scalable=no\" /> <body width=\"100%\"><div><script>!function(d,s,id)"
                + "{var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?"
                + "'http':'https';if(!d.getElementById(id))"
                + "{js=d.createElement(s);js.id=id;js.src=p+\"://platform.twitter.com/widgets.js\";"
                + "fjs.parentNode.insertBefore(js,fjs);}}"
                + "(document,\"script\",\"twitter-wjs\");</script><html><a"
                + " class=\"twitter-timeline\" data-dnt=\"true\" "
                + "href=\"https://twitter.com/search?q=%23tornado\" data-widget-id=\"406096257220763648\" data"
                + "-chrome=\"noscrollbar noheader "
                + "nofooter noborders \" data-tweet-limit=20>Tweets about \"#tornado\"</a></div></body></html>"
            token = "webview"
            ActVars.WEBVIEWstateCode = "tornado"
        default:  break
        }
        if !MyApplication.helpMode {
            uiv!.goToVC(token)
        } else {
            UtilityActions.showHelp(token, uiv!, menuButton)
        }
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

    var iconsMisc = [
        "ncep",
        "hrrrviewer",
        "nsslwrf",
        "wpcgefs",
        "wxogldualpane",
        "wxoglquadpane",
        "warn",
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
        "lightning"
        ]
}
