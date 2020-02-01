/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import WebKit

class ViewControllerWEBVIEW: UIwXViewController {

    var productButton = ObjectToolbarIcon()
    var webView = WKWebView()
    var browserButton = ObjectToolbarIcon()
    var stateCode = ""
    let prefToken = "STATE_CODE"

    override func viewDidLoad() {
        super.viewDidLoad()
        productButton = ObjectToolbarIcon(title: "Product", self, #selector(productClicked))
        browserButton = ObjectToolbarIcon(title: "Launch Browser", self, #selector(browserClicked))
        if ActVars.webViewShowProduct {
            toolbar.items = ObjectToolbarItems(
                [
                    doneButton,
                    GlobalVariables.flexBarButton,
                    browserButton,
                    productButton
                ]
            ).items
        } else {
            toolbar.items = ObjectToolbarItems(
                [
                    doneButton,
                    GlobalVariables.flexBarButton,
                    browserButton
                ]
            ).items
        }
        self.view.addSubview(toolbar)
        webView = WKWebView()
        self.view.addSubview(webView)
        self.view.bringSubviewToFront(toolbar)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: UtilityUI.getTopPadding()).isActive = true
        webView.bottomAnchor.constraint(equalTo: toolbar.topAnchor).isActive = true
        if ActVars.webViewStateCode != "tornado" && !ActVars.webViewUseUrl {
            stateCode = ActVars.webViewStateCode
            stateCode = Utility.readPref(prefToken, stateCode)
            urlChanged(stateCode)
            ActVars.webViewUseUrl = true
        }
        if ActVars.webViewStateCode == "tornado" {
            self.stateCode = ActVars.webViewStateCode
            ActVars.webViewUrl = "https://www.twitter.com/hashtag/tornado"
            ActVars.webViewUseUrl = true
        }
        if ActVars.webViewUseUrl {
            webView.load(URLRequest(url: URL(string: ActVars.webViewUrl)!))
        } else {
            webView.loadHTMLString(ActVars.webViewUrl, baseURL: nil)
        }
        if ActVars.webViewStateCode == "tornado" {
            productButton.title = "#tornado"
        }
        ActVars.webViewShowProduct = true
        ActVars.webViewUseUrl = false
    }

    @objc func productClicked() {
        _ = ObjectPopUp(
            self,
            "Product Selection",
            productButton,
            GlobalArrays.states + UtilityCanada.providenceCodes,
            self.productChanged(_:)
        )
    }

    func productChanged(_ stateCodeCurrent: String) {
        urlChanged(stateCodeCurrent)
        webView.load(URLRequest(url: URL(string: ActVars.webViewUrl)!))
        //webView.loadHTMLString(ActVars.webViewUrl, baseURL: nil)
        if ActVars.webViewStateCode != "tornado" {
            Utility.writePref(prefToken, self.stateCode)
        }
    }

    func urlChanged(_ stateString: String) {
        self.stateCode = stateString
        let state = stateString.split(":")[0]
        var url = "https://www.twitter.com/hashtag/" + state.lowercased()
        var title = "#" + state.lowercased()
        if state.count == 2 {
            url += "wx"
            title += "wx"
        }
        ActVars.webViewUrl = url
        productButton.title = title
    }

    @objc func browserClicked() {
        var tail = ""
        let state = stateCode.lowercased().split(":")[0]
        if state.count == 2 {
            tail = "wx"
        }
        let url = "http://www.twitter.com/hashtag/" + state + tail
        if ActVars.webViewUrl.hasPrefix("https://www.wrh.noaa.gov/map/?obs=true") ||
        ActVars.webViewUrl.hasPrefix("https://www.wrh.noaa.gov/mesowest") {
            UIApplication.shared.open(URL(string: ActVars.webViewUrl)!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
        }
    }
}
