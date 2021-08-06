// *****************************************************************************
// Copyright (c)  2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
//
// Refer to the COPYING file of the official project for license.
// *****************************************************************************

import UIKit

final class vcSpcSwoState: UIwXViewController {

    private var state = ""
    private var stateButton = ToolbarIcon()
    private var image = TouchImage()
    var day = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = ToolbarIcon(self, .share, #selector(shareClicked))
        stateButton = ToolbarIcon(self, #selector(stateClicked))
        toolbar.items = ToolbarItems([doneButton, GlobalVariables.flexBarButton, stateButton, shareButton]).items
        image = TouchImage(self, toolbar)
        getContent(Location.state)
    }

    override func willEnterForeground() {
        getContent(state)
    }

    func getContent(_ state: String) {
        self.state = state
        if self.state == "AK" || self.state == "HI" || self.state == "" {
            self.state = "AL"
        }
        stateButton.title = self.state
        _ = FutureBytes(GlobalVariables.nwsSPCwebsitePrefix + "/public/state/images/" + self.state + "_swody" + day + ".png", image.setBitmap)
    }

    @objc func stateClicked(sender: ToolbarIcon) {
        _ = ObjectPopUp(self, title: "State Selection", sender, GlobalArrays.states, getContent)
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.image(self, sender, image.bitmap)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { _ in self.image.refresh() })
    }
}
