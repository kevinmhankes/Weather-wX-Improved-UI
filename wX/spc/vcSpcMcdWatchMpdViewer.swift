/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class vcSpcMcdWatchMpdViewer: UIwXViewControllerWithAudio {
    
    private var bitmap = Bitmap()
    private var html = ""
    private var numbers = [String]()
    private var listOfText = [String]()
    private var url = ""
    private var productNumber = ""
    private var objectWatchProduct: ObjectWatchProduct?
    var watchMcdMpdNumber = ""
    var watchMcdMpdType = PolygonEnum.SPCWAT
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = true
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        let radarButton = ObjectToolbarIcon(self, .radar, #selector(radarClicked))
        productNumber = watchMcdMpdNumber
        if productNumber != "" {
            watchMcdMpdNumber = ""
        }
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, playButton, playListButton, shareButton, radarButton]).items
        objScrollStackView = ObjectScrollStackView(self)
        getContent()
    }
    
    override func doneClicked() {
        UIApplication.shared.isIdleTimerDisabled = false
        super.doneClicked()
    }
    
    override func willEnterForeground() {}

    override func getContent() {
        let number = String(format: "%04d", to.Int(self.productNumber.replace(" ", "")))
        self.objectWatchProduct = ObjectWatchProduct(self.watchMcdMpdType, number)
        getImage()
        getText()
    }
    
    func getImage() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.url = self.objectWatchProduct!.imgUrl
            self.bitmap = Bitmap(self.url)
            DispatchQueue.main.async { self.display() }
        }
    }
    
    func getText() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.html = self.objectWatchProduct!.getDataTextOnly()
            DispatchQueue.main.async { self.display() }
        }
    }
    
    @objc func imageClicked() {
        Route.imageViewer(self, url)
    }
    
    override func shareClicked(sender: UIButton) {
        if let object = objectWatchProduct {
            UtilityShare.image(self, sender, bitmap, object.text)
        }
    }
    
    override func playlistClicked() {
        if let object = objectWatchProduct {
            _ = UtilityPlayList.add(objectWatchProduct!.prod, object.text, self, playListButton)
        }
    }
    
    @objc func radarClicked() {
        Route.radarNoSave(self, objectWatchProduct?.getClosestRadar() ?? "")
    }
    
    private func display() {
        refreshViews()
        _ = ObjectImageAndText(self, bitmap, html)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(
            alongsideTransition: nil,
            completion: { _ -> Void in
                self.refreshViews()
                self.display()
            }
        )
    }
}
