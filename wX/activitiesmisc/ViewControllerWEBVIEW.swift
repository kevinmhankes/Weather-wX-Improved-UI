/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
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
                    flexBarButton,
                    browserButton,
                    productButton
                ]
            ).items
        } else {
            toolbar.items = ObjectToolbarItems(
                [
                    doneButton,
                    flexBarButton,
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
        webView.loadHTMLString(ActVars.webViewUrl, baseURL: nil)
        if ActVars.webViewStateCode != "tornado" {
            Utility.writePref(prefToken, self.stateCode)
        }
    }

    func urlChanged(_ stateCodeCurrent: String) {
        self.stateCode = stateCodeCurrent
        let stateCodeCurrentLocal = stateCodeCurrent.split(":")[0]
        let twitterStateId = Utility.readPref("STATE_TW_ID_" + stateCodeCurrentLocal, "")
        let url = "<a class=\"twitter-timeline\" data-dnt=\"true\" href=\"https://twitter.com/search?q=%23"
            + stateCodeCurrentLocal.lowercased()
            + "wx\" data-widget-id=\""
            + twitterStateId
            + "\" data-chrome=\"noscrollbar noheader nofooter noborders  \" data-tweet-limit=20>Tweets about \"#"
            + stateCodeCurrentLocal.lowercased()
            + "wx\"</a><script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p"
            + "=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id))"
            + "{js=d.createElement(s);js.id=id;js.src=p+\"://platform.twitter.com/widgets.js\";"
            + "fjs.parentNode.insertBefore(js,fjs);}}(document,\"script\",\"twitter-wjs\");</script>"
        ActVars.webViewUrl = url
        productButton.title = "#" + stateCodeCurrentLocal + "wx"
    }

    @objc func browserClicked() {
        let tail = "wx"
        let url = "http://twitter.com/hashtag/" + stateCode.lowercased().split(":")[0] + tail
        print(ActVars.webViewUrl)
        if ActVars.webViewUrl.hasPrefix("https://www.wrh.noaa.gov/map/?obs=true") ||
        ActVars.webViewUrl.hasPrefix("https://www.wrh.noaa.gov/mesowest") {
            UIApplication.shared.open(URL(string: ActVars.webViewUrl)!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
        }
    }
}
