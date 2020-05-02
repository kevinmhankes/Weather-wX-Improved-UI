/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcSpcSwoState: UIwXViewController {
    
    private var state = ""
    private var stateButton = ObjectToolbarIcon()
    private var image = ObjectTouchImageView()
    var day = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        stateButton = ObjectToolbarIcon(self, #selector(stateClicked))
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, stateButton, shareButton]).items
        image = ObjectTouchImageView(self, toolbar)
        self.getContent(Location.state)
    }
    
    @objc override func willEnterForeground() {
        self.getContent(state)
    }
    
    func getContent(_ state: String) {
        self.state = state
        if self.state == "AK" || self.state == "HI" || self.state == "" { self.state = "AL" }
        stateButton.title = self.state
        DispatchQueue.global(qos: .userInitiated).async {
            let bitmap = Bitmap(MyApplication.nwsSPCwebsitePrefix + "/public/state/images/" + self.state + "_swody" + self.day + ".png")
            DispatchQueue.main.async {
                self.image.setBitmap(bitmap)
            }
        }
    }
    
    @objc func stateClicked(sender: ObjectToolbarIcon) {
        _ = ObjectPopUp(self, title: "State Selection", sender, GlobalArrays.states, self.getContent(_:))
    }
    
    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, image.bitmap)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { _ -> Void in self.image.refresh() })
    }
}
