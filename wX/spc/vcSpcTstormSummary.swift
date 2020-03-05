/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcSpcTstormSummary: UIwXViewController {
    
    private var urls = [String]()
    private var bitmaps = [Bitmap]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems(
            [
                doneButton,
                GlobalVariables.flexBarButton,
                shareButton
            ]
        ).items
        objScrollStackView = ObjectScrollStackView(self)
        getContent()
    }
    
    override func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.urls = UtilitySpc.getTstormOutlookUrls()
            self.bitmaps = self.urls.map { Bitmap($0) }
            DispatchQueue.main.async {
                self.displayContent()
            }
        }
    }
    
    @objc func imageClicked(sender: UITapGestureRecognizerWithData) {
        let vc = vcImageViewer()
        vc.url = urls[sender.data]
        self.goToVC(vc)
    }
    
    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, bitmaps)
    }
    
    private func displayContent() {
        self.refreshViews()
        _ = ObjectImageSummary(self, bitmaps)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: nil,
            completion: { _ -> Void in
                self.displayContent()
        }
        )
    }
}
