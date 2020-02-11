/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import WebKit

class vcWebView: UIwXViewController {

    private var productButton = ObjectToolbarIcon()
    private var webView = WKWebView()
    private var browserButton = ObjectToolbarIcon()
    private var stateCode = ""
    private let prefToken = "STATE_CODE"
    var webViewUrl = ""
    var webViewStateCode = ""
    var webViewShowProduct = true
    var webViewUseUrl = false

    override func viewDidLoad() {
        super.viewDidLoad()
        productButton = ObjectToolbarIcon(title: "Product", self, #selector(productClicked))
        browserButton = ObjectToolbarIcon(title: "Launch Browser", self, #selector(browserClicked))
        if webViewShowProduct {
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
        if webViewStateCode != "tornado" && !webViewUseUrl {
            stateCode = webViewStateCode
            stateCode = Utility.readPref(prefToken, stateCode)
            urlChanged(stateCode)
            webViewUseUrl = true
        }
        if webViewStateCode == "tornado" {
            self.stateCode = webViewStateCode
            webViewUrl = "https://www.twitter.com/hashtag/tornado"
            webViewUseUrl = true
        }
        if webViewUseUrl {
            webView.load(URLRequest(url: URL(string: webViewUrl)!))
        } else {
            webView.loadHTMLString(webViewUrl, baseURL: nil)
        }
        if webViewStateCode == "tornado" {
            productButton.title = "#tornado"
        }
        webViewShowProduct = true
        webViewUseUrl = false
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
        webView.load(URLRequest(url: URL(string: webViewUrl)!))
        if webViewStateCode != "tornado" {
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
        webViewUrl = url
        productButton.title = title
    }

    @objc func browserClicked() {
        var tail = ""
        let state = stateCode.lowercased().split(":")[0]
        if state.count == 2 {
            tail = "wx"
        }
        let url = "http://www.twitter.com/hashtag/" + state + tail
        if webViewUrl.hasPrefix("https://www.wrh.noaa.gov/map/?obs=true") ||
        webViewUrl.hasPrefix("https://www.wrh.noaa.gov/mesowest") {
            UIApplication.shared.open(URL(string: webViewUrl)!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
        }
    }
}
