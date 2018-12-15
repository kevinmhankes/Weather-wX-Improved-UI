/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation

class ViewControllerCAWARN: UIwXViewController {

    var objCAWARN: ObjectCAWARN!
    var provButton = ObjectToolbarIcon()
    var prov = "Canada"

    override func viewDidLoad() {
        super.viewDidLoad()
        provButton = ObjectToolbarIcon(title: prov, self, #selector(provClicked))
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, provButton, shareButton]).items
        _ = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        self.objCAWARN = ObjectCAWARN(self, stackView)
        self.getContent()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.objCAWARN.getData()
            DispatchQueue.main.async {
                self.objCAWARN.showData()
                self.provButton.title = self.prov + "(" + (self.objCAWARN.count) + ")"
            }
        }
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, self.objCAWARN.bitmap)
    }

    @objc func gotoWarning(sender: UITapGestureRecognizerWithData) {
        getWarningDetail(objCAWARN.getWarningUrl(sender.data))
    }

    @objc func provClicked() {
        let alert = ObjectPopUp(self, "Providence Selection", provButton)
        self.objCAWARN.provList.forEach { prov in
            alert.addAction(UIAlertAction(prov, {_ in self.provChanged(prov)}))}
        alert.finish()
    }

    func provChanged(_ prov: String) {
        self.prov = prov
        self.objCAWARN.setProv(prov)
        getContent()
    }

    func getWarningDetail(_ url: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            let data = UtilityCanada.getHazardsFromUrl(url)
            DispatchQueue.main.async {
                ActVars.TEXTVIEWText = data.replaceAllRegexp("<.*?>", "")
                self.goToVC("textviewer")
            }
        }
    }
}
