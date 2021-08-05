// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit
import AVFoundation

final class vcCanadaWarnings: UIwXViewController {

    private var objectCanadaWarnings: ObjectCanadaWarnings!
    private var provinceButton = ToolbarIcon()
    private var province = "Canada"

    override func viewDidLoad() {
        super.viewDidLoad()
        provinceButton = ToolbarIcon(title: province, self, #selector(provinceClicked))
        let shareButton = ToolbarIcon(self, .share, #selector(share))
        toolbar.items = ToolbarItems([doneButton, GlobalVariables.flexBarButton, provinceButton, shareButton]).items
        objScrollStackView = ScrollStackView(self)
        objectCanadaWarnings = ObjectCanadaWarnings(self)
        getContent()
    }

    override func getContent() {
        _ = FutureVoid(objectCanadaWarnings.getData, display)
    }

    @objc func share(sender: UIButton) {
        UtilityShare.image(self, sender, objectCanadaWarnings.bitmap)
    }

    // this is called in objectCanadaWarnings
    @objc func goToWarning(sender: GestureData) {
        getWarningDetail(objectCanadaWarnings.getWarningUrl(sender.data))
    }

    @objc func provinceClicked() {
        _ = ObjectPopUp(self, title: "Province Selection", provinceButton, objectCanadaWarnings.provinces, provinceChanged(_:))
    }

    func provinceChanged(_ province: String) {
        self.province = province
        objectCanadaWarnings.setProvince(province)
        getContent()
    }

    func getWarningDetail(_ url: String) {
        _ = FutureText2({ UtilityCanada.getHazardsFromUrl(url) }, { data in Route.textViewer(self, data.replaceAllRegexp("<.*?>", "").replace("ATOM", "").replace("\n\n", "\n"))}
        )
    }

    private func display() {
        refreshViews()
        objectCanadaWarnings.showData()
        provinceButton.title = province + "(" + (objectCanadaWarnings.count) + ")"
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { _ in self.display() })
    }
}
