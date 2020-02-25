/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

class vcWpcImg: UIwXViewController {
    
    private var image = ObjectTouchImageView()
    private var productButton = ObjectToolbarIcon()
    private var index = 0
    private var timePeriod = 1
    private var subMenu = ObjectMenuData(UtilityWpcImages.titles, UtilityWpcImages.urls, UtilityWpcImages.labels)
    var wpcImagesFromHomeScreen = false
    var wpcImagesToken = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        productButton = ObjectToolbarIcon(self, #selector(showProductMenu))
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems(
            [
                doneButton,
                GlobalVariables.flexBarButton,
                productButton,
                shareButton
            ]
        ).items
        self.view.addSubview(toolbar)
        image = ObjectTouchImageView(self, toolbar, #selector(handleSwipes(sender:)))
        index = Utility.readPref("WPCIMG_PARAM_LAST_USED", index)
        if wpcImagesFromHomeScreen {
            self.getContentFromHomescreen()
            wpcImagesFromHomeScreen = false
        } else {
            self.getContent(index)
        }
    }
    
    @objc func willEnterForeground() {
        self.getContent(index)
    }
    
    func getContent(_ index: Int) {
        self.index = index
        self.productButton.title = UtilityWpcImages.labels[index]
        DispatchQueue.global(qos: .userInitiated).async {
            var getUrl = UtilityWpcImages.urls[self.index]
            if getUrl.contains(MyApplication.nwsGraphicalWebsitePrefix + "/images/conus/") {
                getUrl += String(self.timePeriod) + "_conus.png"
            }
            let bitmap = Bitmap(getUrl)
            DispatchQueue.main.async {
                self.image.setBitmap(bitmap)
                Utility.writePref("WPCIMG_PARAM_LAST_USED", self.index)
            }
        }
    }
    
    func getContentFromHomescreen() {
        let titles = GlobalArrays.nwsImageProducts.filter {
            $0.hasPrefix(wpcImagesToken + ":")
        }
        if titles.count > 0 {
            self.productButton.title = titles[0].split(":")[1]
        }
        DispatchQueue.global(qos: .userInitiated).async {
            let bitmap = UtilityDownload.getImageProduct(self.wpcImagesToken)
            DispatchQueue.main.async {
                self.image.setBitmap(bitmap)
            }
        }
    }
    
    @objc func showProductMenu() {
        _ = ObjectPopUp(self, "Product Selection", productButton, subMenu.objTitles, self.showSubMenu(_:))
    }
    
    func showSubMenu(_ index: Int) {
        _ = ObjectPopUp(self, productButton, subMenu.objTitles, index, subMenu, self.getContent(_:))
    }
    
    @objc func shareClicked(sender: UIButton) {
        UtilityShare.shareImage(self, sender, image.bitmap)
    }
    
    @objc func handleSwipes(sender: UISwipeGestureRecognizer) {
        getContent(UtilityUI.sideSwipe(sender, index, UtilityWpcImages.urls))
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
