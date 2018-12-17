/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerSPCTSTSUMMARY: UIwXViewController {

    var urls = [String]()
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
            self.urls = UtilitySPC.getTstormOutlookUrls()
            self.bitmaps = self.urls.map {Bitmap($0)}
            DispatchQueue.main.async {
                self.bitmaps.enumerated().forEach {
                    let objImage = ObjectImage(self.stackView, $1)
                    objImage.addGestureRecognizer(
                        UITapGestureRecognizerWithData($0, self, #selector(self.imageClicked(sender:)))
                    )
                }
            }
        }
    }

    @objc func imageClicked(sender: UITapGestureRecognizerWithData) {
        ActVars.IMAGEVIEWERurl = urls[sender.data]
        self.goToVC("imageviewer")
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, bitmaps)
    }
}
