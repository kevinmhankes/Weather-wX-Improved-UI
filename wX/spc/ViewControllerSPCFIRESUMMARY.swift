/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class ViewControllerSPCFIRESUMMARY: UIwXViewController {

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
            self.bitmaps = UtilitySPCFireOutlook.urls.map {Bitmap($0)}
            DispatchQueue.main.async {
                self.displayContent()
            }
        }
    }

    @objc func imageClicked(sender: UITapGestureRecognizerWithData) {
        ActVars.wpcTextProduct = UtilitySPCFireOutlook.products[sender.data]
        self.goToVC("WPCText")
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, bitmaps)
    }

    private func displayContent() {
        self.bitmaps.enumerated().forEach {
            let imgObject = ObjectImage(self.stackView, $1)
            imgObject.addGestureRecognizer(
                UITapGestureRecognizerWithData($0, self, #selector(self.imageClicked(sender:)))
            )
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil,
                            completion: { _ -> Void in
                                self.refreshViews()
                                self.displayContent()
        })
    }
}
