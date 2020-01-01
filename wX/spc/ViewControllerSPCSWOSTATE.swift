/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerSPCSWOSTATE: UIwXViewController {

    var day = ""
    var state = ""
    var stateButton = ObjectToolbarIcon()
    var image = ObjectTouchImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        stateButton = ObjectToolbarIcon(self, #selector(stateClicked))
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, stateButton, shareButton]).items
        image = ObjectTouchImageView(self, toolbar)
        self.view.addSubview(toolbar)
        day = ActVars.spcswoDay
        state = Location.state
        stateButton.title = state
        self.getContent(state)
    }

    @objc func willEnterForeground() {
        self.getContent(state)
    }

    func getContent(_ state: String) {
        self.state = state
        stateButton.title = self.state
        DispatchQueue.global(qos: .userInitiated).async {
            let bitmap = Bitmap(
                MyApplication.nwsSPCwebsitePrefix
                    + "/public/state/images/"
                    + self.state + "_swody" + self.day + ".png"
            )
            DispatchQueue.main.async {
                self.image.setBitmap(bitmap)
            }
        }
    }

    @objc func stateClicked(sender: ObjectToolbarIcon) {
        _ = ObjectPopUp(self, "State Selection", sender, GlobalArrays.states, self.getContent(_:))
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, image.bitmap)
    }
}
