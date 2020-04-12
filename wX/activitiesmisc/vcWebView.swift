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
    var url = ""
    var aStateCode = ""
    var showProduct = true
    var useUrl = false

    override func viewDidLoad() {
        super.viewDidLoad()
        productButton = ObjectToolbarIcon(title: "Product", self, #selector(productClicked))
        browserButton = ObjectToolbarIcon(title: "Launch Browser", self, #selector(browserClicked))
        if showProduct {
            toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, browserButton, productButton]).items
        } else {
            toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, browserButton]).items
        }
        webView = WKWebView()
        self.view.addSubview(webView)
        self.view.bringSubviewToFront(toolbar)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: UtilityUI.getTopPadding()).isActive = true
        webView.bottomAnchor.constraint(equalTo: toolbar.topAnchor).isActive = true
        if stateCode != "tornado" && !useUrl {
            stateCode = aStateCode
            stateCode = Utility.readPref(prefToken, stateCode)
            urlChanged(stateCode)
            useUrl = true
        }
        if aStateCode == "tornado" {
            self.stateCode = aStateCode
            url = "https://www.twitter.com/hashtag/tornado"
            useUrl = true
        }
        if useUrl {
            webView.load(URLRequest(url: URL(string: url)!))
        } else {
            webView.loadHTMLString(url, baseURL: nil)
        }
        if aStateCode == "tornado" {
            productButton.title = "#tornado"
        }
        showProduct = true
        useUrl = false
    }

    @objc func productClicked() {
        _ = ObjectPopUp(
            self,
            productButton,
            GlobalArrays.states + UtilityCanada.provinceCodes,
            self.productChanged(_:)
        )
    }

    func productChanged(_ stateCodeCurrent: String) {
        urlChanged(stateCodeCurrent)
        webView.load(URLRequest(url: URL(string: url)!))
        if aStateCode != "tornado" {
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
        self.url = url
        productButton.title = title
    }

    @objc func browserClicked() {
        var tail = ""
        let state = stateCode.lowercased().split(":")[0]
        if state.count == 2 {
            tail = "wx"
        }
        let url = "http://www.twitter.com/hashtag/" + state + tail
        if url.hasPrefix("https://www.wrh.noaa.gov/map/?obs=true") ||
        url.hasPrefix("https://www.wrh.noaa.gov/mesowest") {
            UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
        }
    }
}
