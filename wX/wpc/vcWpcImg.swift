/*****************************************************************************
 * Copyright (c) 2016, 2017, 2018, 2019, 2020, 2021 joshua.tee@gmail.com. All rights reserved.
 *
 * Refer to the COPYING file of the official project for license.
 *****************************************************************************/

import UIKit

final class vcWpcImg: UIwXViewController {

    private var image = ObjectTouchImageView()
    private var productButton = ObjectToolbarIcon()
    private var index = 0
    private var timePeriod = 1
    private let subMenu = ObjectMenuData(UtilityWpcImages.titles, UtilityWpcImages.urls, UtilityWpcImages.labels)
    var wpcImagesFromHomeScreen = false
    var wpcImagesToken = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        productButton = ObjectToolbarIcon(self, #selector(showProductMenu))
        let shareButton = ObjectToolbarIcon(self, .share, #selector(shareClicked))
        toolbar.items = ObjectToolbarItems([doneButton, GlobalVariables.flexBarButton, productButton, shareButton]).items
        image = ObjectTouchImageView(self, toolbar, #selector(handleSwipes(sender:)))
        index = Utility.readPref("WPCIMG_PARAM_LAST_USED", index)
        if wpcImagesFromHomeScreen {
            getContentFromHomeScreen()
            wpcImagesFromHomeScreen = false
        } else {
            getContent(index)
        }
    }

    override func willEnterForeground() {
        getContent(index)
    }

    func getContent(_ index: Int) {
        self.index = index
        productButton.title = UtilityWpcImages.labels[index]
        var getUrl = UtilityWpcImages.urls[self.index]
        if getUrl.contains(GlobalVariables.nwsGraphicalWebsitePrefix + "/images/conus/") {
            getUrl += String(timePeriod) + "_conus.png"
        }
        DispatchQueue.global(qos: .userInitiated).async {
            let bitmap = Bitmap(getUrl)
            DispatchQueue.main.async { self.display(bitmap) }
        }
    }

    private func display(_ bitmap: Bitmap) {
        image.setBitmap(bitmap)
        Utility.writePref("WPCIMG_PARAM_LAST_USED", index)
    }

    func getContentFromHomeScreen() {
        let titles = GlobalArrays.nwsImageProducts.filter { $0.hasPrefix(wpcImagesToken + ":") }
        if titles.count > 0 {
            productButton.title = titles[0].split(":")[1]
        }
        DispatchQueue.global(qos: .userInitiated).async {
            let bitmap = UtilityDownload.getImageProduct(self.wpcImagesToken)
            DispatchQueue.main.async { self.image.setBitmap(bitmap) }
        }
    }

    @objc func showProductMenu() {
        _ = ObjectPopUp(self, "Product Selection", productButton, subMenu.objTitles, showSubMenu(_:))
    }

    func showSubMenu(_ index: Int) {
        _ = ObjectPopUp(self, productButton, subMenu.objTitles, index, subMenu, getContent(_:))
    }

    @objc func shareClicked(sender: UIButton) {
        UtilityShare.image(self, sender, image.bitmap)
    }

    @objc func handleSwipes(sender: UISwipeGestureRecognizer) {
        getContent(UtilityUI.sideSwipe(sender, index, UtilityWpcImages.urls))
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { _ -> Void in self.image.refresh() })
    }
}
