/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerWEBVIEW: UIwXViewController {

    var productButton = ObjectToolbarIcon()
    var webView = UIWebView()
    var browserButton = ObjectToolbarIcon()
    var stateCodeCurrent = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        productButton = ObjectToolbarIcon(title: "Product", self, #selector(productClicked))
        browserButton = ObjectToolbarIcon(title: "Launch Browser", self, #selector(browserClicked))
        if ActVars.WEBVIEWshowProd {
            toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, browserButton, productButton]).items
        } else {
            toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, browserButton]).items
        }
        self.view.addSubview(toolbar)
        webView = UIWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.height - toolbar.frame.size.height))
        webView.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        if ActVars.WEBVIEWstateCode != "tornado" && !ActVars.WEBVIEWuseUrl {
            stateCodeCurrent = ActVars.WEBVIEWstateCode
            stateCodeCurrent = preferences.getString("STATE_CODE", stateCodeCurrent)
            urlChanged(stateCodeCurrent)
        }
        if ActVars.WEBVIEWuseUrl {
            webView.loadRequest(URLRequest(url: URL(string: ActVars.WEBVIEWurl)!))
        } else {
            webView.loadHTMLString(ActVars.WEBVIEWurl, baseURL: nil)
        }
        self.view.addSubview(webView)
        if ActVars.WEBVIEWstateCode=="tornado" {productButton.title = "#tornado"}
        ActVars.WEBVIEWshowProd = true
        ActVars.WEBVIEWuseUrl = false
    }

    @objc func productClicked() {
        let alert = ObjectPopUp(self, "Product Selection", productButton)
        (GlobalArrays.states + UtilityCanada.provCodes).forEach { rid in
            alert.addAction(UIAlertAction(title: rid, style: .default, handler: {_ in self.productChanged(rid)}))
        }
        alert.finish()
    }

    func productChanged(_ stateCodeCurrent: String) {
        urlChanged(stateCodeCurrent)
        webView.loadHTMLString(ActVars.WEBVIEWurl, baseURL: nil)
        if ActVars.WEBVIEWstateCode != "tornado" {editor.putString("STATE_CODE", self.stateCodeCurrent)}
    }

    func urlChanged(_ stateCodeCurrent: String) {
        self.stateCodeCurrent = stateCodeCurrent
        let stateCodeCurrentLocal = stateCodeCurrent.split(":")[0]
        let twitterStateId = preferences.getString("STATE_TW_ID_" + stateCodeCurrentLocal, "")
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
        ActVars.WEBVIEWurl = url
        productButton.title = "#" + stateCodeCurrentLocal + "wx"
    }

    @objc func browserClicked() {
        let tail = "wx"
        let stateTmp = stateCodeCurrent.lowercased().split(":")[0]
        let url = "http://twitter.com/hashtag/" + stateTmp + tail
        UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
    }
}
