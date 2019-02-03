/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerWEBVIEW: UIwXViewController {

    var productButton = ObjectToolbarIcon()
    var webView = UIWebView()
    var browserButton = ObjectToolbarIcon()
    var stateCodeCurrent = ""
    let prefToken = "STATE_CODE"

    override func viewDidLoad() {
        super.viewDidLoad()
        productButton = ObjectToolbarIcon(title: "Product", self, #selector(productClicked))
        browserButton = ObjectToolbarIcon(title: "Launch Browser", self, #selector(browserClicked))
        if ActVars.webViewShowProduct {
            toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, browserButton, productButton]).items
        } else {
            toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, browserButton]).items
        }
        self.view.addSubview(toolbar)
        let (width, height) = UtilityUI.getScreenBoundsCGFloat()
        webView = UIWebView(
            frame: CGRect(
                x: 0,
                y: UtilityUI.getTopPadding(),
                width: width,
                height: height
                    - toolbar.frame.size.height
                    - UtilityUI.getTopPadding()
                    - UtilityUI.getBottomPadding()
            )
        )
        webView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        if ActVars.webViewStateCode != "tornado" && !ActVars.webViewUseUrl {
            stateCodeCurrent = ActVars.webViewStateCode
            stateCodeCurrent = Utility.readPref(prefToken, stateCodeCurrent)
            urlChanged(stateCodeCurrent)
        }
        if ActVars.webViewUseUrl {
            webView.loadRequest(URLRequest(url: URL(string: ActVars.webViewUrl)!))
        } else {
            webView.loadHTMLString(ActVars.webViewUrl, baseURL: nil)
        }
        self.view.addSubview(webView)
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
            GlobalArrays.states + UtilityCanada.provCodes,
            self.productChanged(_:)
        )
    }

    func productChanged(_ stateCodeCurrent: String) {
        urlChanged(stateCodeCurrent)
        webView.loadHTMLString(ActVars.webViewUrl, baseURL: nil)
        if ActVars.webViewStateCode != "tornado" {
            Utility.writePref(prefToken, self.stateCodeCurrent)
        }
    }

    func urlChanged(_ stateCodeCurrent: String) {
        self.stateCodeCurrent = stateCodeCurrent
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
        let stateTmp = stateCodeCurrent.lowercased().split(":")[0]
        let url = "http://twitter.com/hashtag/" + stateTmp + tail
        UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
    }
}
