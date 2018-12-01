/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerSPCSWOSUMMARY: UIwXViewController {

    var bitmaps = [Bitmap]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems([doneButton, flexBarButton, shareButton]).items
        _ = ObjectScrollStackView(self, scrollView, stackView, toolbar)
        getContent()
    }

    func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.bitmaps = (1...3).map {UtilitySPCSWO.getImageUrls(String($0), getAllImages: false)[0]}
            self.bitmaps += UtilitySPCSWO.getImageUrls("48", getAllImages: true)
            DispatchQueue.main.async {
                self.bitmaps.enumerated().forEach {
                    let objImage = ObjectImage(self.stackView, $1)
                    objImage.addGestureRecognizer(UITapGestureRecognizerWithData(data: $0,
                                                                                 target: self,
                                                                                 action: #selector(self.imageClicked(sender:))))
                }
            }
        }
    }

    @objc func imageClicked(sender: UITapGestureRecognizerWithData) {
        switch sender.data {
        case 0...2:
            ActVars.spcswoDay = String(sender.data + 1)
            self.goToVC("spcswo")
        case 3...7:
            ActVars.spcswoDay = "48"
            self.goToVC("spcswo")
        default: break
        }
    }

    @objc func shareClicked(sender: UIButton) {UtilityShare.shareImage(self, sender, bitmaps)}
}
