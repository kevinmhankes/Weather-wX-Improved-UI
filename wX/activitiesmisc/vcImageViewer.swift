/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcImageViewer: UIwXViewController {
    
    private var image = ObjectTouchImageView()
    var imageViewerUrl = ""
    
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
        self.view.addSubview(toolbar)
        self.getContent(imageViewerUrl)
    }
    
    override func willEnterForeground() {}
    
    func getContent(_ url: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            let bitmap = Bitmap(url)
            DispatchQueue.main.async {
                self.image = ObjectTouchImageView(self, self.toolbar, bitmap)
            }
        }
    }
    
    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, image.bitmap)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: nil,
            completion: { _ -> Void in
                self.image.refresh()
        }
        )
    }
}
