/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit
import AVFoundation

class vcCanadaWarnings: UIwXViewController {

    private var objCAWARN: ObjectCanadaWarnings!
    private var provButton = ObjectToolbarIcon()
    private var prov = "Canada"

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        provButton = ObjectToolbarIcon(title: prov, self, #selector(provClicked))
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, provButton, shareButton]).items
        objScrollStackView = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        self.objCAWARN = ObjectCanadaWarnings(self, stackView)
        self.getContent()
    }

    @objc func willEnterForeground() {
           self.getContent()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.objCAWARN.getData()
            DispatchQueue.main.async {
                self.displayContent()
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
        _ = ObjectPopUp(self, "Providence Selection", provButton, self.objCAWARN.provList, self.provChanged(_:))
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
                let vc = vcTextViewer()
                vc.textViewText = data.replaceAllRegexp("<.*?>", "")
                self.goToVC(vc)
            }
        }
    }

    private func displayContent() {
        self.objCAWARN.updateParents(self, stackView)
        self.objCAWARN.showData()
        self.provButton.title = self.prov + "(" + (self.objCAWARN.count) + ")"
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: nil,
            completion: { _ -> Void in
                self.refreshViews()
                self.displayContent()
            }
        )
    }
}
