/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class vcImageViewer: UIwXViewController {
    
    private var image = ObjectTouchImageView()
    var url = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, shareButton]).items
        self.getContent()
    }
    
    override func willEnterForeground() {}
    
    override func getContent() {
        DispatchQueue.global(qos: .userInitiated).async {
            let bitmap = Bitmap(self.url)
            DispatchQueue.main.async { self.displayContent(bitmap) }
        }
    }
    
    private func displayContent(_ bitmap: Bitmap) {
        self.image = ObjectTouchImageView(self, self.toolbar, bitmap)
    }
    
    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, image.bitmap)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { _ -> Void in self.image.refresh() })
    }
}
