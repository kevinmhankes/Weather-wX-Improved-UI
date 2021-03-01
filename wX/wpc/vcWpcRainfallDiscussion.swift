/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class vcWpcRainfallDiscussion: UIwXViewControllerWithAudio {
    
    private var bitmap = Bitmap()
    private var html = ""
    var day = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let statusButton = ObjectToolbarIcon(title: "Day " + day, self, nil)
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems([
            doneButton,
            statusButton,
            GlobalVariables.flexBarButton,
            playButton,
            playListButton,
            shareButton
        ]).items
        objScrollStackView = ObjectScrollStackView(self)
        getContent()
    }
    
    override func getContent() {
        let number = (Int(day) ?? 1) - 1
        let imgUrl = UtilityWpcRainfallOutlook.urls[number]
        product = UtilityWpcRainfallOutlook.codes[number]
        DispatchQueue.global(qos: .userInitiated).async {
            self.html = UtilityDownload.getTextProduct(self.product)
            self.bitmap = Bitmap(imgUrl)
            DispatchQueue.main.async { self.display() }
        }
    }
    
    private func display() {
        refreshViews()
        _ = ObjectImageAndText(self, bitmap, html)
    }
    
    @objc func imageClicked() {
        Route.imageViewer(self, UtilityWpcRainfallOutlook.urls[(Int(day) ?? 1) - 1])
    }
    
    override func shareClicked(sender: UIButton) {
        UtilityShare.image(self, sender, bitmap, html)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { _ -> Void in self.display() })
    }
}
